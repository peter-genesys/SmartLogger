WHENEVER SQLERROR CONTINUE
alter trigger sm_weaver_trg disable;



--Ensure no inlining so sm_logger can be used
alter session set plsql_optimize_level = 1;

set define off;



create or replace package body sm_weaver is
/** 
* WEAVER - AOP Processor - Aspect Orientated Programming Processor
* Weaves the logging instrumentation into valid plsql progam units. 
*/

  -- AUTHID CURRENT_USER - see spec
  -- @AOP_NEVER
 
  --GREAT regex tesing resource => https://www.regextester.com/


  g_node_type_package    CONSTANT VARCHAR2(30) := 'new_pkg'; 
  g_node_type_function   CONSTANT VARCHAR2(30) := 'new_func';  
  g_node_type_procedure  CONSTANT VARCHAR2(30) := 'new_proc'; 
  g_node_type_trigger    CONSTANT VARCHAR2(30) := 'new_trig'; 
  
 
  g_recent_label          varchar2(100);

  g_use_plscope         constant boolean := true;
 
  g_package_name        CONSTANT VARCHAR2(30) := 'sm_weaver'; 
 
  g_during_advise       boolean:= false;
  
  g_aop_never           CONSTANT VARCHAR2(30) := '@AOP_NEVER';
  g_aop_directive       CONSTANT VARCHAR2(30) := '@AOP_LOG'; 
  g_aop_woven           CONSTANT VARCHAR2(30) := '@AOP_LOG_WOVEN';
  g_aop_weave_now       CONSTANT VARCHAR2(30) := '@AOP_LOG_WEAVE_NOW'; 

  g_aop_reg_mode_debug  CONSTANT VARCHAR2(30) := '@AOP_REG_MODE_DEBUG';
 
  g_logger_id_param          CONSTANT VARCHAR2(30) := 'O_LOGGER_ID';
  g_logger_url_param         CONSTANT VARCHAR2(30) := 'O_LOGGER_URL';
  g_logger_debug_param       CONSTANT VARCHAR2(30) := 'I_LOGGER_DEBUG';
  g_logger_normal_param      CONSTANT VARCHAR2(30) := 'I_LOGGER_NORMAL';
  g_logger_quiet_param       CONSTANT VARCHAR2(30) := 'I_LOGGER_QUIET';
  g_logger_disabled_param    CONSTANT VARCHAR2(30) := 'I_LOGGER_DISABLED';
  g_logger_msg_mode_param    CONSTANT VARCHAR2(30) := 'I_LOGGER_MSG_MODE';
 
  g_for_aop_html      boolean := false;
 
  g_weave_start_time  date;
  
  G_TIMEOUT_SECS_PER_1000_LINES CONSTANT NUMBER := 300; -- 5mins per 1000 lines
  g_weave_timeout_secs NUMBER;   
  
  g_initial_indent     constant integer := 0;
  
  TYPE clob_stack_typ IS
  TABLE OF CLOB
  INDEX BY BINARY_INTEGER;

  g_comment_stack clob_stack_typ;
  g_string_stack  clob_stack_typ;
 
  --@TODO could change this into a record type 
  --Then attempt to do both AOP and HTML versions at once. - or that could be just making it too hard.

  g_code               CLOB;
  g_current_pos        INTEGER;
  g_upto_pos           INTEGER;
  g_past_pos           INTEGER;
 
  x_weave_timeout      EXCEPTION; 
  x_invalid_keyword    EXCEPTION;
  x_string_not_found   EXCEPTION;
  x_restore_failed     EXCEPTION;
  
  g_aop_module_name    VARCHAR2(30); 
  
  G_PARAM_NAME_WIDTH   CONSTANT NUMBER := 106;
  G_MIN_PARAM_NAME_PADDING CONSTANT NUMBER := 5;  --for formatting only.
 
  g_indent_spaces     CONSTANT INTEGER := 2;

  g_end_user          VARCHAR2(30); --owner for normal packages, invoker for invoker packages.


  g_note_params                 boolean;
  g_note_vars                   boolean; --THIS IS THE BIG ONE! NOT YET IMPLIMENTED.
  g_note_unhandled_errors       boolean;
  g_warn_unhandled_errors       boolean;
  g_fatal_unhandled_errors      boolean;
  g_add_wrapper_block           boolean;
  g_note_exception_handlers     boolean;

 
  ----------------------------------------------------------------------------
  -- REGULAR EXPRESSIONS
  ----------------------------------------------------------------------------
  --Word Char  = non-quoted Oracle identifier chars include "A-Z,_,#,$"
  G_REGEX_WORD_CHAR      CONSTANT VARCHAR2(50) := '(\w|\#|\$)'; 

  --Word is at least 1 Word Char
  G_REGEX_WORD           CONSTANT VARCHAR2(50) := G_REGEX_WORD_CHAR||'+';  
  G_REGEX_2WORDS         CONSTANT VARCHAR2(50) := G_REGEX_WORD||'\.'||G_REGEX_WORD;

  G_REGEX_ANY_WORDS      CONSTANT VARCHAR2(50) := '(\w|\#|\$|\(|\))+(\.(\w|\#|\$)+)*'; --Eg 'abd.dfg.hij'  works with l_nam_tab(2)
  --G_REGEX_ANY_WORDS      CONSTANT VARCHAR2(50) := '(\w|\#|\$|\(|\))+(\.(\w|\#|\$|\(|\))+)*'; --Eg 'abd.dfg.hij' --fails with l_nam_tab(2).rec(1) 

  --G_REGEX_ANY_WORDS      CONSTANT VARCHAR2(50) := '(\.|\w|\#|\$|\(|\))+'; loops

  --G_REGEX_ANY_WORDS      CONSTANT VARCHAR2(50) :='[a-zA-Z0-9.() $_]+'; This works fine is regextester, but not here.  just disappears.


  G_REGEX_2_QUOTED_WORDS CONSTANT VARCHAR2(50) := '"*'||G_REGEX_WORD||'"*\."*'||G_REGEX_WORD||'"*'; --quotes are optional    

  G_REGEX_NON_WORD_CHAR  CONSTANT VARCHAR2(50) := '[^\w\#\$]'; 
  --G_REGEX_NON_WORD_CHAR  CONSTANT VARCHAR2(50) := '(^\w|\#|\$)';
  G_REGEX_NON_WORD       CONSTANT VARCHAR2(50) := G_REGEX_NON_WORD_CHAR||'+'; 
 
  G_REGEX_PKG_BODY       CONSTANT VARCHAR2(50) := '\s *PACKAGE\s+?BODY\s';
  G_REGEX_PROCEDURE      CONSTANT VARCHAR2(50) := '\s *PROCEDURE\s';
  G_REGEX_FUNCTION       CONSTANT VARCHAR2(50) := '\s *FUNCTION\s';
  G_REGEX_TRIGGER        CONSTANT VARCHAR2(50) := '\s *TRIGGER\s';
  G_REGEX_CREATE         CONSTANT VARCHAR2(50) := '\s *CREATE\s';
  G_REGEX_PROG_UNIT      CONSTANT VARCHAR2(200) := G_REGEX_PKG_BODY
                                            ||'|'||G_REGEX_PROCEDURE
                                            ||'|'||G_REGEX_FUNCTION
                                            ||'|'||G_REGEX_TRIGGER;
  
  G_REGEX_JAVA           CONSTANT VARCHAR2(50) := '\sLANGUAGE\s+?JAVA\s+?NAME\s';
 
  --Opening Blocks (CR and spaces needed by calc_indent)
  G_REGEX_DECLARE       CONSTANT VARCHAR2(50) := '\s *DECLARE\s'; --Find CR and spaces and DECLARE
  G_REGEX_BEGIN         CONSTANT VARCHAR2(50) := '\s *BEGIN\s';   --Find CR and spaces and BEGIN
  G_REGEX_LOOP          CONSTANT VARCHAR2(50) := '\s *LOOP\s';    --Find CR and spaces and LOOP
  G_REGEX_CASE          CONSTANT VARCHAR2(50) := G_REGEX_NON_WORD_CHAR||'CASE\s'; --CASE can be preceded by any non-word
  -- G_REGEX_CASE          CONSTANT VARCHAR2(50) := '(\s|\,|\||\)|\()CASE\s'; --CASE can be preceded by [WS ) ( , ||] --though not sure 

  G_REGEX_IF            CONSTANT VARCHAR2(50) := '\s *IF\s';
  --Neutral Blocks
  G_REGEX_ELSE          CONSTANT VARCHAR2(50) := '\sELSE\s';
  G_REGEX_ELSIF         CONSTANT VARCHAR2(50) := '\sELSIF\s';
  G_REGEX_WHEN          CONSTANT VARCHAR2(50) := '\sWHEN\s';
  G_REGEX_THEN          CONSTANT VARCHAR2(50) := '\sTHEN\s';
  G_REGEX_EXCEPTION     CONSTANT VARCHAR2(50) := '\sEXCEPTION\s';
  --Closing Blocks
  G_REGEX_END_BEGIN_NO_NAME CONSTANT VARCHAR2(50) := '\sEND\s*?;';         --END(any whitespace)SEMI-COLON
  G_REGEX_END_BEGIN_NAMED   CONSTANT VARCHAR2(50) := '\sEND\s+?'||G_REGEX_WORD_CHAR||'*?\s*?;';  --END(at least 1 whitespace)(any wordschars)(any whitespace)SEMI-COLON
  
  G_REGEX_END_BEGIN         CONSTANT VARCHAR2(200) :=   G_REGEX_END_BEGIN_NO_NAME      
                                                 ||'|'||G_REGEX_END_BEGIN_NAMED;   

  G_REGEX_END_LOOP_NO_NAME CONSTANT VARCHAR2(50) := '\sEND\s+?LOOP\s*?;'; --END(at least 1 whitespace)LOOP(any whitespace)SEMI-COLON  
  G_REGEX_END_LOOP_NAMED   CONSTANT VARCHAR2(50) := '\sEND\s+?LOOP\s+?'||G_REGEX_WORD_CHAR||'*?\s*?;';  --END(at least 1 whitespace)LOOP(any wordschars)(any whitespace)SEMI-COLON
  
  G_REGEX_END_LOOP        CONSTANT VARCHAR2(200) :=   G_REGEX_END_LOOP_NO_NAME      
                                               ||'|'||G_REGEX_END_LOOP_NAMED;  

  G_REGEX_END_CASE        CONSTANT VARCHAR2(50) := '\sEND\s+?CASE\s*?;';
  G_REGEX_END_CASE_EXPR   CONSTANT VARCHAR2(50) := '\sEND\W'; 
  G_REGEX_END_IF          CONSTANT VARCHAR2(50) := '\sEND\s+?IF\s*?;';

  G_REGEX_SEMI_COL      CONSTANT VARCHAR2(50) := ';';
   
  --G_REGEX_ANNOTATION          CONSTANT VARCHAR2(50) := '--';
 
 
  G_REGEX_OPEN         CONSTANT VARCHAR2(200) :=   G_REGEX_DECLARE      
                                            ||'|'||G_REGEX_BEGIN        
                                            ||'|'||G_REGEX_LOOP         
                                            ||'|'||G_REGEX_CASE         
                                            ||'|'||G_REGEX_IF
                                            ;   
  G_REGEX_NEUTRAL      CONSTANT VARCHAR2(200) :=   G_REGEX_ELSE         
                                            ||'|'||G_REGEX_ELSIF
  --                                          ||'|'||G_REGEX_WHEN
                                            ||'|'||G_REGEX_THEN     
                                            ||'|'||G_REGEX_EXCEPTION                                            
                                            ;      
  G_REGEX_WHEN_OTHERS_THEN          CONSTANT VARCHAR2(50) := '\sWHEN\s+?OTHERS\s+?THEN\s';
  G_REGEX_WHEN_EXCEPT_THEN          CONSTANT VARCHAR2(50) := '\sWHEN\s+?('||G_REGEX_WORD||'\s+?)+?THEN\s';
 
  G_REGEX_CLOSE        CONSTANT VARCHAR2(300) :=  G_REGEX_END_BEGIN    
                                           ||'|'||G_REGEX_END_LOOP     
                                           ||'|'||G_REGEX_END_CASE     
                                           ||'|'||G_REGEX_END_CASE_EXPR
                                           ||'|'||G_REGEX_END_IF;    
 
 
  --Param searching
  G_REGEX_OPEN_BRACKET    CONSTANT VARCHAR2(20) := '\('; 
  G_REGEX_CLOSE_BRACKET   CONSTANT VARCHAR2(20) := '\)'; 
  G_REGEX_COMMA           CONSTANT VARCHAR2(20) := '\,'; 
  
  --G_REGEX_IS_AS           CONSTANT VARCHAR2(20) := '\sIS\s|\sAS\s'; 
  G_REGEX_IS_AS           CONSTANT VARCHAR2(20) := '(\)|\s)\s*(IS|AS)\s';
  G_REGEX_IS_AS_DECLARE   CONSTANT VARCHAR2(50) := '(\)|\s)\s*(IS|AS|DECLARE)\s';
  G_REGEX_RETURN_IS_AS    CONSTANT VARCHAR2(50) := '(\)|\s)\s*(RETURN|IS|AS)\s';
  G_REGEX_RETURN_IS_AS_DECLARE    CONSTANT VARCHAR2(50) := '(\)|\s)\s*(RETURN|IS|AS|DECLARE)\s';
  G_REGEX_DEFAULT         CONSTANT VARCHAR2(20) := '(DEFAULT|:=)';
  
  G_REGEX_ATOMIC_TYPES CONSTANT VARCHAR2(200) := '(NUMBER|INTEGER|POSITIVE|BINARY_INTEGER|PLS_INTEGER'
                                                  ||'|DATE|VARCHAR2|VARCHAR|CHAR|BOOLEAN|CLOB)';
  
  G_REGEX_START_ANNOTATION      CONSTANT VARCHAR2(50) :=  '--(""|\?\?|!!|##|\^\^)';
  
  G_REGEX_STASHED_COMMENT    CONSTANT VARCHAR2(50) := '{{comment:\d+}}';
  G_REGEX_COMMENT            CONSTANT VARCHAR2(50) := '--""';
  G_REGEX_INFO               CONSTANT VARCHAR2(50) := '--\?\?';
  G_REGEX_WARNING            CONSTANT VARCHAR2(50) := '--!!';
  G_REGEX_FATAL              CONSTANT VARCHAR2(50) := '--##';  
  G_REGEX_NOTE               CONSTANT VARCHAR2(50) := '--\^\^';  

  G_REGEX_BRACKETED_TERM     CONSTANT VARCHAR2(50) := '\([^()]*\)'; --that contains no brackets
  G_REGEX_STASHED_TERM       CONSTANT VARCHAR2(50) := '{{term:(\d+)}}'; --term with index, used to find index


  FUNCTION is_atomic_type(i_type varchar2) return boolean is
  BEGIN
    --Various inaccurate ways to use the regex.  
    --return regex_match(i_type,G_REGEX_ATOMIC_TYPES,'i')
    --return G_REGEX_ATOMIC_TYPES like '%'||i_type||'%';
    --return i_type is not null and
    --       REGEXP_REPLACE(i_type,G_REGEX_ATOMIC_TYPES,'') is null

    --Better just to do a simple IN and be accurate.
    return i_type in ('NUMBER'
                     ,'INTEGER'
                     ,'POSITIVE'
                     ,'BINARY_INTEGER'
                     ,'PLS_INTEGER'
                     ,'DATE'
                     ,'VARCHAR2'
                     ,'VARCHAR'
                     ,'CHAR'
                     ,'BOOLEAN'
                     ,'CLOB');     
  END;

 
--------------------------------------------------------------------
-- regex_match
--------------------------------------------------------------------
/** PRIVATE
* Uses REGEXP_LIKE to check for i_pattern within i_source_string
* @param i_source_string   Source Text 
* @param i_pattern         Search Pattern
* @param i_match_parameter Match Parameter - text literal that lets you change the default matching behavior of the function REGEXP_LIKE
*  i - specifies case-insensitive matching.
*  c - specifies case-sensitive matching.
*  n - allows the period (.), which is the match-any-character wildcard character, to match the newline character. If you omit this parameter, the period does not match the newline character.
*  m - treats the source string as multiple lines. Oracle interprets ^ and $ as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string. If you omit this parameter, Oracle treats the source string as a single line.
* @return TRUE indicates a match was found.
*/
  FUNCTION regex_match(i_source_string   IN CLOB
                      ,i_pattern         IN VARCHAR2
                      ,i_match_parameter IN VARCHAR2 DEFAULT 'i') RETURN BOOLEAN IS
  BEGIN
    RETURN REGEXP_LIKE(i_source_string,i_pattern,i_match_parameter);
  END;
 
--------------------------------------------------------------------
-- table_owner
--------------------------------------------------------------------
/** PRIVATE
* Search dba_tables for table i_table_name.
* Find the most appropriate table owner.
* Of All Tables (that the end user can see)
* Select 1 owner, with preference to the end user
* @param i_table_name      Table Name
* @return Table Owner
*/
  FUNCTION table_owner(i_table_name IN VARCHAR2) RETURN VARCHAR2 IS
    

    CURSOR cu_owner IS
    select owner
    from   dba_tables
    where  table_name = i_table_name
    order by decode(owner,g_end_user,1,2);

    l_result VARCHAR2(30);

  BEGIN
    OPEN cu_owner;
    FETCH cu_owner INTO l_result;
    CLOSE cu_owner;

    RETURN l_result;
 
  END;


--------------------------------------------------------------------
-- object_owner
--------------------------------------------------------------------
/** PRIVATE
* Search dba_objects for i_object_name
* Find the most appropriate object owner.
* Of All Objects (that the end user can see)
* Select 1 owner, with preference to the end user
* @param i_obect_name      Object Name
* @param i_obect_type      Object Type
* @return Object Owner
*/
  FUNCTION object_owner(i_object_name IN VARCHAR2
                       ,i_object_type IN VARCHAR2) RETURN VARCHAR2 IS
    

    CURSOR cu_owner IS
    select owner
    from   dba_objects
    where  object_name = i_object_name
    and    object_type = i_object_type
    order by decode(owner,g_end_user,1,2);

    l_result VARCHAR2(30);

  BEGIN
    OPEN cu_owner;
    FETCH cu_owner INTO l_result;
    CLOSE cu_owner;

    RETURN l_result;
 
  END;

--------------------------------------------------------------------
-- get_db_object_signature
--------------------------------------------------------------------
/** PRIVATE
* Get the signature of the db object
* Declaration and definition use the same signature
* @param i_object_name        Db object name
* @param i_object_type        Db object ntype
* @return signature of the db object
*/

FUNCTION get_db_object_signature(i_object_name         IN varchar2
                                ,i_object_type         IN varchar2) return varchar2 is
l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_db_object_signature'); 

   CURSOR cu_plscope_var is
   select  o.*
    from   all_identifiers o
    where o.object_name      = UPPER(i_object_name)
    and   o.object_type      = UPPER(i_object_type)
    and   o.usage            = decode(UPPER(i_object_type), 'PACKAGE'     ,'DECLARATION'
                                                          , 'PACKAGE BODY','DEFINITION')
    and   o.type             = decode(UPPER(i_object_type), 'PACKAGE'     ,'PACKAGE'
                                                          , 'PACKAGE BODY','PACKAGE');
    --Since Declaration and definition use the same signature, 
    --it will be necesary to specify usage when using the signature later.

    l_plscope_var cu_plscope_var%ROWTYPE; 
BEGIN
  sm_logger.param(l_node, 'i_object_name'  ,i_object_name ); 
  sm_logger.param(l_node, 'i_object_type'  ,i_object_type ); 
 
  OPEN cu_plscope_var;
  FETCH cu_plscope_var into l_plscope_var;
  CLOSE cu_plscope_var;

  sm_logger.note(l_node, 'l_plscope_var.name'         ,l_plscope_var.name );
  sm_logger.note(l_node, 'l_plscope_var.type'         ,l_plscope_var.type );
  sm_logger.note(l_node, 'l_plscope_var.signature'    ,l_plscope_var.signature );
 

  RETURN l_plscope_var.signature;
 
END get_db_object_signature;  



--------------------------------------------------------------------
-- get_pu_signature
--------------------------------------------------------------------
/** PRIVATE
* get the signature of the program unit
* @param i_parent_signature   Signature of the parent block declaration
* @param i_pu_name            Program Unit name
* @param i_pu_type            Program Unit type
* @return signature of the program unit
*/

FUNCTION get_pu_signature(--i_pu_stack         IN pu_stack_typ
                          i_parent_signature in varchar2
                         ,i_parent_type      in varchar2
                         ,i_pu_name          IN varchar2
                         ,i_pu_type          IN varchar2) return varchar2 is
  l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_pu_signature'); 


   --Start at the definition of the parent block and jump down 1 level to declaration of the child.
   --(@refactor - could use a std 3 level query and go to the definition of the child, instead.)
   --NB For a label there will be a declaration only.

   CURSOR cu_plscope_var(c_parent_signature in varchar2
                        ,c_parent_type      in varchar2
                        ,c_pu_name          in varchar2
                        ,c_pu_type          in varchar2 )  is
   select  p.name        parent_name
          ,c.name        child_name
          ,c.type        child_type
          ,c.signature   signature
    from   all_identifiers p
          ,all_identifiers c
    where p.usage            = decode(c_parent_type,'LABEL','DECLARATION','DEFINITION') --For Labels - search from DECLARATION
    and   p.signature        = c_parent_signature
    and   c.usage_context_id = p.usage_id
    and   c.owner            = p.owner
    and   c.object_name      = p.object_name
    and   c.object_type      = p.object_type
    and   c.name             = c_pu_name
    and   c.type             = c_pu_type
    and   c.usage            IN ('DECLARATION','DEFINITION'); 
    --Could be a declaration or definition, depending on whether the pu is declared in the package spec.
    --Luckilly it doesn't matter which is retrieved, since they have the same signature.

 
    l_plscope_var cu_plscope_var%ROWTYPE; 
BEGIN
  sm_logger.param(l_node, 'i_parent_signature' ,i_parent_signature ); 
  sm_logger.param(l_node, 'i_parent_type'      ,i_parent_type ); 
  sm_logger.param(l_node, 'i_pu_name'          ,i_pu_name ); 
  sm_logger.param(l_node, 'i_pu_type'          ,i_pu_type ); 
  
  OPEN cu_plscope_var(c_parent_signature => i_parent_signature
                     ,c_parent_type      => i_parent_type 
                     ,c_pu_name          => UPPER(i_pu_name)
                     ,c_pu_type          => UPPER(i_pu_type)); 
  FETCH cu_plscope_var into l_plscope_var;
  CLOSE cu_plscope_var;


  sm_logger.note(l_node, 'l_plscope_var.child_name'         ,l_plscope_var.child_name );
  sm_logger.note(l_node, 'l_plscope_var.child_type'         ,l_plscope_var.child_type );
  sm_logger.note(l_node, 'l_plscope_var.signature'          ,l_plscope_var.signature );

  RETURN l_plscope_var.signature;
 
END get_pu_signature;  




--------------------------------------------------------------------
-- push_pu - push a program unit onto the pu stack
--         - find the plscope identifier for the PU too.
-------------------------------------------------------------------- 
procedure push_pu(i_name       in varchar2
                 ,i_type       in varchar2
                -- ,i_signature  in varchar2
                 ,io_pu_stack IN OUT pu_stack_typ ) is
  l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'push_pu'); 
  l_pu_rec pu_rec_typ;
BEGIN
  sm_logger.param(l_node, 'i_name'          ,i_name ); 
  sm_logger.param(l_node, 'i_type'          ,i_type ); 
  --sm_logger.param(l_node, 'i_signature'     ,i_signature ); 
  sm_logger.note(l_node, 'io_pu_stack.COUNT'          ,io_pu_stack.COUNT ); 
  

  l_pu_rec.name      := i_name;
  l_pu_rec.type      := i_type;
  
  --@TODO - Signatures cannot be used for the QUICK WEAVE since the program is not compiles PLScope does not exist.
  IF i_type IN ('PACKAGE','PACKAGE BODY') THEN
    --Get signature for the root of the package.
    l_pu_rec.signature := get_db_object_signature(i_object_name  => i_name
                                                 ,i_object_type  => i_type);
  ELSif io_pu_stack.COUNT > 0 THEN
    l_pu_rec.signature := get_pu_signature(i_parent_signature => io_pu_stack(io_pu_stack.LAST).signature
                                          ,i_parent_type      => io_pu_stack(io_pu_stack.LAST).type
                                          ,i_pu_name          => i_name
                                          ,i_pu_type          => i_type);
  END IF;
 
  l_pu_rec.level     := io_pu_stack.COUNT+1; 

  sm_logger.note(l_node, 'l_pu_rec.signature'      ,l_pu_rec.signature ); 
  sm_logger.note(l_node, 'l_pu_rec.level'          ,l_pu_rec.level ); 

  io_pu_stack(l_pu_rec.level) := l_pu_rec; 
END;



--------------------------------------------------------------------
-- f_push_pu - push a program unit onto the pu stack
-------------------------------------------------------------------- 
function f_push_pu(i_name       in varchar2
                  ,i_type       in varchar2
                 -- ,i_signature  in varchar2
                  ,i_pu_stack   IN pu_stack_typ ) return pu_stack_typ is
 
    l_pu_stack   pu_stack_typ := i_pu_stack;
BEGIN
 
  push_pu(i_name      => i_name
         ,i_type      => i_type
        -- ,i_signature => i_signature
         ,io_pu_stack => l_pu_stack);

  return l_pu_stack;
 
END;


--------------------------------------------------------------------
-- log_var_list - Log the var list
--------------------------------------------------------------------
  procedure log_var_list(i_var_list in var_list_typ) is
    l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'log_var_list'); 
    l_index varchar2(200);
  BEGIN
    l_index := i_var_list.FIRST;
    
    WHILE l_index is not null loop
      --sm_logger.note(l_node,i_var_list(l_index).name,i_var_list(l_index).type,i_var_list(l_index).signature);
      sm_logger.note(l_node,l_index,i_var_list(l_index).type,i_var_list(l_index).signature); --show the index
      l_index := i_var_list.NEXT(l_index);
    end loop;
  END;

  

--------------------------------------------------------------------
-- log_new_var_list - Log the new var list minus old var list
--------------------------------------------------------------------
  procedure log_new_var_list(i_old_var_list  in var_list_typ
                            ,i_new_var_list  in var_list_typ) is
    l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'log_new_var_list'); 
    l_index varchar2(200);
  BEGIN
    l_index := i_new_var_list.FIRST;
    
    WHILE l_index is not null loop
      if NOT i_old_var_list.EXISTS(l_index) OR
         NVL(i_old_var_list(l_index).signature,'X') <> NVL(i_new_var_list(l_index).signature,'X') OR
         i_old_var_list(l_index).level <> i_new_var_list(l_index).level THEN
        --This entry is not in the old list, or the signature is different, or level is different, so it's a new one.  Log it.
        sm_logger.note(l_node,l_index,i_new_var_list(l_index).type,i_new_var_list(l_index).signature); --show the index
      end if;
      l_index := i_new_var_list.NEXT(l_index);
    end loop;
  END;

--------------------------------------------------------------------
-- log_param_list - Log the param list
--------------------------------------------------------------------
  procedure log_param_list(i_param_list in param_list_typ) is
    l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'log_param_list'); 
    l_index BINARY_INTEGER;
  BEGIN
    l_index := i_param_list.FIRST;
    
    WHILE l_index is not null loop
      sm_logger.note(l_node,i_param_list(l_index).name,i_param_list(l_index).type,i_param_list(l_index).signature);
      l_index := i_param_list.NEXT(l_index);
    end loop;
  END;


--------------------------------------------------------------------
-- get_declaration_type
--------------------------------------------------------------------  
/** PRIVATE
* Find the type of a declaration.
* @param i_signature Signature of a DECLARATION
* @returns all_identifiers%rowtype The last row subordinate to the DECLARATION row.
*/
FUNCTION get_declaration_type(i_signature in varchar2) return all_identifiers%rowtype is

  cursor cu_declaration_type(c_signature varchar2) is
  --SELECT * from (
    SELECT *
    FROM all_identifiers
    START WITH  signature = i_signature 
            and usage     = 'DECLARATION' 
    CONNECT BY PRIOR usage_id    = usage_context_id 
           and prior owner       = owner
           and prior object_name = object_name
           and prior object_type = object_type
    ORDER SIBLINGS BY line, col;
  -- )
  --where usage = 'REFERENCE';

  l_all_identifiers all_identifiers%rowtype;

BEGIN
   
  --Maybe more than two records in the hierachy - get the last one.  
  FOR l_declaration_type IN cu_declaration_type(c_signature => i_signature) LOOP
    l_all_identifiers := l_declaration_type;
  END LOOP;
 
  return l_all_identifiers;
 
END;  


--------------------------------------------------------------------
-- get_type_signature
--------------------------------------------------------------------
/** PRIVATE
* get the signature of the type
* @param i_parent_signature   Signature of the parent block declaration
* @param i_var_name           Variable name
* @param i_var_type           Variable type
* @return signature of the type
*/

FUNCTION get_type_signature(i_parent_signature IN varchar2
                           ,i_var_name         IN varchar2
                           ,i_var_type         IN varchar2) return varchar2 is
l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_type_signature'); 
   CURSOR cu_plscope_var is
   select  p.name        parent_name
          ,c.name        child_name
          ,c.type        child_type
          ,c.signature   var_decl_signature
       --   ,t.name        data_type
       --   ,t.type        data_class 
       --   ,t.signature   type_signature
    from   all_identifiers p
          ,all_identifiers c
         -- ,all_identifiers t
    where 
    --PARENT
          p.usage            = 'DEFINITION'
    and   p.signature        = i_parent_signature
    --CHILD
    and   c.usage_context_id = p.usage_id
    and   c.owner            = p.owner
    and   c.object_name      = p.object_name
    and   c.object_type      = p.object_type
    and   REGEXP_LIKE(c.type,'VARIABLE|FORM','i')
    and   c.usage            = 'DECLARATION'
    and   c.name             = UPPER(i_var_name);
 --  --TYPE
 --  and   t.usage_context_id = c.usage_id
 --  and   t.owner            = c.owner
 --  and   t.object_name      = c.object_name
 --  and   t.object_type      = c.object_type
 --  and   t.name             = UPPER(i_var_type);

    l_plscope_var cu_plscope_var%ROWTYPE; 
    l_type_signature varchar2(32);
BEGIN
  sm_logger.param(l_node, 'i_parent_signature'  ,i_parent_signature ); 
  sm_logger.param(l_node, 'i_var_name'          ,i_var_name ); 
  sm_logger.param(l_node, 'i_var_type'          ,i_var_type ); 
  
  OPEN cu_plscope_var;
  FETCH cu_plscope_var into l_plscope_var;
  CLOSE cu_plscope_var;

  sm_logger.note(l_node, 'l_plscope_var.var_decl_signature'          ,l_plscope_var.var_decl_signature );

  l_type_signature := get_declaration_type(i_signature => l_plscope_var.var_decl_signature).signature;

  sm_logger.note(l_node, 'l_type_signature'          ,l_type_signature );
 
  RETURN l_type_signature;
 
END get_type_signature;  

--------------------------------------------------------------------
-- get_type_signature @TODO - is this used?
--------------------------------------------------------------------
/** PRIVATE
* get the signature of the type
* @param i_var_signature   Signature of the variable declaration
* @return signature of the type
*/
FUNCTION get_type_signature(i_var_signature IN varchar2 ) return varchar2 is
l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_type_signature'); 
   CURSOR cu_plscope_var is
   select  c.name        child_name
          ,c.type        child_type
          ,t.name        data_type
          ,t.type        data_class 
          ,t.signature   type_signature
    from   all_identifiers c
          ,all_identifiers t
    where 
    --CHILD
          c.type             = 'VARIABLE'
    and   c.usage            = 'DECLARATION'
    and   c.signature        = i_var_signature
    --TYPE
    and   t.usage_context_id = c.usage_id
    and   t.owner            = c.owner
    and   t.object_name      = c.object_name
    and   t.object_type      = c.object_type;

    l_plscope_var cu_plscope_var%ROWTYPE; 
BEGIN
  sm_logger.param(l_node, 'i_var_signature'  ,i_var_signature ); 
 
  OPEN cu_plscope_var;
  FETCH cu_plscope_var into l_plscope_var;
  CLOSE cu_plscope_var;

  sm_logger.note(l_node, 'l_plscope_var.type_signature'          ,l_plscope_var.type_signature );

  RETURN l_plscope_var.type_signature;
 
END get_type_signature;  




--------------------------------------------------------------------
-- identifier_exists
--------------------------------------------------------------------  
/** PRIVATE
* Does this signature exist?
* @param i_signature   Signature of a DECLARATION
*/
FUNCTION identifier_exists(i_signature   in varchar2) return boolean is
 
  --Query to identify a simple reference
  CURSOR cu_identifier is
    SELECT 1
    FROM all_identifiers 
    where signature = i_signature 
    and usage = 'DECLARATION';
 
   l_dummy  number;
   l_result boolean;
 BEGIN
   
   OPEN cu_identifier;
   FETCH cu_identifier INTO l_dummy;
   l_result := cu_identifier%FOUND;
   CLOSE cu_identifier;

   RETURN l_result;

 END; 


--------------------------------------------------------------------
-- get_type_defn
--------------------------------------------------------------------  
/** PRIVATE
* Find the type definition, and componants
* @param i_signature   Signature of a DECLARATION
*/

FUNCTION get_type_defn( i_signature   in varchar2) return identifier_tab is
  l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'get_type_defn');

 
  CURSOR cu_identifier is
   select  d.name        defn_name
          ,d.type        defn_type
          ,c.name        col_name
          ,c.type        col_type
          ,c.signature   col_signature
          ,t.name        data_type
          ,t.type        data_class 
          ,t.signature   signature
    from   all_identifiers d
          ,all_identifiers c
          ,all_identifiers t
    where d.usage            = 'DECLARATION'
    and   d.signature        = i_signature
    and   c.usage_context_id = d.usage_id
    and   c.owner            = d.owner
    and   c.object_name      = d.object_name
    and   c.object_type      = d.object_type
    and   t.usage_context_id = c.usage_id
    and   t.owner            = c.owner
    and   t.object_name      = c.object_name
    and   t.object_type      = c.object_type;

  --Query to identify a simple reference
  --SELECT *  FROM all_identifiers where signature = '8E8A2905C526B95322C8C0560108A24A' and usage = 'DECLARATION'

   l_identifier_tab   identifier_tab;
   l_index            number := 0;
 
begin --get_type_defn
  sm_logger.param(l_node,'i_signature',i_signature);
 BEGIN


  --Find record details for a table.
  --If d.type = 'INDEX TABLE' then look for the record defn 
  --If c.type = 'RECORD' then return c.signature

 
   
   FOR l_identifier_rec IN cu_identifier LOOP

     l_index := l_index + 1;
     sm_logger.note(l_node,'l_index',l_index);

     IF l_identifier_rec.defn_type = 'INDEX TABLE' THEN
       --@TODO need to check whether there was an index in the record name or not...
        IF l_identifier_rec.col_type  = 'RECORD' then
          l_identifier_tab :=  get_type_defn( i_signature => l_identifier_rec.col_signature);
          --exit; --@TODO test whether this works with tables in records...
        ELSIF l_identifier_rec.col_type  like '%DATATYPE' then
          sm_logger.comment(l_node,'INDEX TABLE of atomic data type.');
 
          l_identifier_tab(l_index).col_name   := null;
          l_identifier_tab(l_index).data_type  := l_identifier_rec.col_name;
          l_identifier_tab(l_index).data_class := l_identifier_rec.col_type;
          l_identifier_tab(l_index).signature  := l_identifier_rec.col_signature;

        ELSE
          sm_logger.note(l_node,'l_identifier_rec.col_type',l_identifier_rec.col_type);
          sm_logger.fatal(l_node,'INDEX TABLE found but unexpected col_type');
          --exit;
        END IF;
 
     ELSE

       l_identifier_tab(l_index).col_name   := l_identifier_rec.col_name;
       l_identifier_tab(l_index).data_type  := l_identifier_rec.data_type;
       l_identifier_tab(l_index).data_class := l_identifier_rec.data_class;
       l_identifier_tab(l_index).signature  := l_identifier_rec.signature;

     END IF;   

     sm_logger.note(l_node,'l_identifier_tab(l_index).col_name' ,l_identifier_tab(l_index).col_name);
     sm_logger.note(l_node,'l_identifier_tab(l_index).data_type',l_identifier_tab(l_index).data_type);
     sm_logger.note(l_node,'l_identifier_tab(l_index).data_class',l_identifier_tab(l_index).data_class);
     sm_logger.note(l_node,'l_identifier_tab(l_index).signature',l_identifier_tab(l_index).signature);
 

   END LOOP;

   sm_logger.note(l_node,'l_identifier_tab.count',l_identifier_tab.count);

   RETURN l_identifier_tab;

 END;
exception
  when others then
    sm_logger.warn_error(l_node);
    raise;
end; --get_type_defn



--------------------------------------------------------------------
-- create_var_rec - smart constructor for var_rec
-- @TODO param_name may not be simple at all
--       need to be able to cope with complex names..
--------------------------------------------------------------------
 FUNCTION create_var_rec(i_param_name IN VARCHAR2
                        ,i_param_type IN VARCHAR2 default null
                        ,i_rowtype    IN VARCHAR2 default null
                        ,i_in_var     IN BOOLEAN  default false --in  param implcit or explicit
                        ,i_out_var    IN BOOLEAN  default false --out param            explicit
                        ,i_lex_var    in BOOLEAN  default false --lex locally declared explicit
                        ,i_lim_var    in BOOLEAN  default false --lim locally declared implicit (eg FOR LOOP)
                        ,i_assign_var in BOOLEAN  default false --plscope var assignment
                        ,i_signature  in varchar2 default null 
                        ,i_pu_stack   in pu_stack_typ
                       ) return var_rec_typ is
    l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'create_var_rec'); 
    l_var      var_rec_typ;
    l_index    binary_integer;
    l_declaration_type all_identifiers%rowtype;
  BEGIN
    sm_logger.param(l_node, 'i_param_name' ,i_param_name); 
    sm_logger.param(l_node, 'i_param_type' ,i_param_type); 
    sm_logger.param(l_node, 'i_rowtype'    ,i_rowtype   );
    sm_logger.param(l_node, 'i_in_var'     ,i_in_var    ); 
    sm_logger.param(l_node, 'i_out_var'    ,i_out_var   ); 
    sm_logger.param(l_node, 'i_lex_var'    ,i_lex_var   ); 
    sm_logger.param(l_node, 'i_lim_var'    ,i_lim_var   ); 
    sm_logger.param(l_node, 'i_assign_var' ,i_assign_var   ); 
    sm_logger.param(l_node, 'i_signature'  ,i_signature ); 
    sm_logger.param(l_node, 'i_pu_stack.count'  ,i_pu_stack.count ); 


    l_var.name    := i_param_name;
    l_var.type    := UPPER(i_param_type); --convert all types to UPPERCASE   
    l_var.rowtype := i_rowtype;
    l_var.level   := i_pu_stack.count;

    l_var.in_var  := i_in_var OR (NOT i_out_var and NOT i_lex_var and NOT i_lim_var and NOT i_assign_var);  --in  param implcit or explicit
    l_var.out_var := i_out_var;  --out param            explicit
    l_var.lex_var := i_lex_var;  --lex locally declared explicit
    l_var.lim_var := i_lim_var;  --lim locally declared implicit (eg FOR LOOP)
    l_var.assign_var := i_assign_var;
    --,owner                     --current scope    @FUTURE USE
    --,scope                     --program hierachy @FUTURE USE


    if i_assign_var Then
      sm_logger.comment(l_node, 'PLScope ASSIGNMENT');
      --This variable was discovered from a plscoped ASSIGNMENT
      --Every assignment should therefore turn up later when parsing the source.

      l_declaration_type := get_declaration_type(i_signature => i_signature);

      if l_declaration_type.type = 'VARIABLE' then
         sm_logger.warning(l_node, 'VARIABLE type from PLScope is not supported.  Ignoring this Assignment.');

      else

         sm_logger.comment(l_node, 'Use the declaration info');
         l_var.type       := l_declaration_type.name;
         l_var.data_class := l_declaration_type.type;
         l_var.signature  := l_declaration_type.signature;
   
         sm_logger.note(l_node, 'l_var.type      '    ,l_var.type       ); 
         sm_logger.note(l_node, 'l_var.data_class'    ,l_var.data_class ); 
         sm_logger.note(l_node, 'l_var.signature '    ,l_var.signature  ); 
      end if;   

    else
      
 
    if l_var.type is null then
      if  l_var.rowtype is not null then 
        l_var.type := 'ROWTYPE'; --BEWARE %rowtype is also used with cursors.
      end if;
    else
      if is_atomic_type(i_type => l_var.type ) then
        sm_logger.comment(l_node, 'Found Atomic Type'); 
      else
        if i_signature is not null then
          sm_logger.comment(l_node, 'Create with known signature'); 
          l_var.signature := i_signature;
        else
 
          l_index := i_pu_stack.LAST; --last pu on the stack has the parent signature
          --Find the siganture of the variable's type.
          l_var.signature := get_type_signature(i_parent_signature => i_pu_stack(l_index).signature
                                               ,i_var_name         => i_param_name
                                               ,i_var_type         => i_param_type );
          if l_var.signature is not null then
            sm_logger.info(l_node, 'Found type signature'); 
            sm_logger.note(l_node, 'l_var.signature'  ,l_var.signature ); 
          else
            sm_logger.warning(l_node, 'Unable to find type signature'); 
          end if;  

          --sm_logger.comment(l_node, 'Searching for Type'); 

          --DONT FORGET A GOOD WAY TO FIGURE THIS OUT IS TO LOOK AT THE PLSCOPE 
          --GIVEN THAT WE KNOW THE CONTEXT WE FIND THE VARIABLE OR PARAM IN

          --Could demand a rethink about whether we search through objects and recompile with plscope.
          --or can we just get from plscope.

          --1.  Find the signature of this variable.
      
          --May need to already know the signature of the enclosing procedure to be able to search for the variable!!
          --Lets do some testing of this..

          --I know the name of the variable and the type (and potentially where i am upto in the source file)
          --Should be able to find the variable in PLScope by looking up its var name and type name and getting the 
          --signature to store.
          --May also need the parent procedure - but not sure about this.
          --Other variables of the same name and type may exist in other procedures - 
          --so will need either parent proc (signature) or location in code.
          
          --Let us assume we have already got the parent signature..
                 
          --From AOP_TEST       
          --   PROCEDURE TEST99 (DECLARATION) - F89279D140926C817730D2187C7F2570
          --     PROCEDURE TEST99 (DEFINITION) - F89279D140926C817730D2187C7F2570
          --       VARIABLE L_TEST (DECLARATION) - 70FFE2B593CA200C0C5A61FAE273283E
          --         RECORD TEST_TYP (REFERENCE) - 8E8A2905C526B95322C8C0560108A24A

/*
--Find the variables declared in a given proc known by its signature.

Also look at the query construct used in functions get_type_defn

WITH plscope_hierarchy
        AS (SELECT line
                 , col
                 , name
                 , TYPE
                 , usage
                 , usage_id
                 , usage_context_id
                 , signature
              FROM all_identifiers
             WHERE owner       = 'PACMAN'
               AND object_name = 'AOP_TEST'
               AND object_type = 'PACKAGE BODY')
select v.name
      ,v.type
      ,v.usage
      ,t.name      data_type
      ,t.type      data_class
      ,t.signature signature
from  plscope_hierarchy p
     ,plscope_hierarchy v
     ,plscope_hierarchy t
where p.signature  = 'F89279D140926C817730D2187C7F2570' --known signature of the enclosing PU.
and   p.usage      = 'DEFINITION'
and   v.usage_context_id = p.usage_id
and   v.type  = 'VARIABLE'
and   v.usage = 'DECLARATION'
and   t.usage_context_id = v.usage_id
*/



          

          



        --Search in type list first. @TODO - harvest package level types in the same routine that harvests vars.
        --Prob should store in a separate list, but could be the same, as long as we ignore that the names could
        --collide, or find a way to stop that happening.


        --Then go looking for other types.

        --Create a regex for users 
        --G_REGEX_USERS - lists all users db_objects with packages (specs).
        
        --Package Types
        -------------------
        --User.Package.Type
        --     Package.Type

        --DB Types
        ------------
        --User.Type
        --     Type
        




     -- if l_var like '%.%' then
     --   sm_logger.comment(l_node, 'Let us remove the last componant and try again');
     --   declare
     --     l_componant varchar2(1000);
     --   begin
     --      l_componant  := REGEXP_SUBSTR(l_var,G_REGEX_WORD||'$',1,1,'i');
     --      sm_logger.note(l_node,'l_componant',l_componant);
     --      l_var        := REGEXP_REPLACE(l_var,'.'||G_REGEX_WORD||'$',''); --remove the last word
     --      sm_logger.note(l_node,'l_var',l_var);
--
     --      note_complex_var(i_var       => l_var
     --                       ,i_componant => i_componant||'.'||l_componant );
     --   end;
     -- else
     --   sm_logger.warning(l_node, 'Var not known '||i_var||'.'||i_componant); --RTRIM(i_var||'.'||i_componant,'.');
     --   log_var_list(i_var_list => l_var_list);
     -- end if;
        END IF;
      END IF;
    END IF;
    END IF;



    RETURN l_var;
  END;

/*
  FUNCTION | PROCEDURE decompose_type(i_var       in     var_rec_typ
                                     ,io_var_list IN OUT var_list_typ) is
  BEGIN
    
    IF 

            --Also need to add 1 var def for each valid componant of the record type.
            l_table_owner := table_owner(i_table_name => l_table_name);
            FOR l_column IN 
              (select lower(column_name) column_name
                     ,data_type
               from dba_tab_columns
               where table_name = l_table_name 
               and   owner      = l_table_owner ) LOOP
               
                   store_var_def(i_param_name  => l_param_name||'.'||l_column.column_name
                                ,i_param_type  => l_column.data_type
                                ,i_in_var      => l_in_var
                                ,i_out_var     => l_out_var );
 
            END LOOP;   

  END;
*/

 

--------------------------------------------------------------------
-- store_param_list - Store variable in paramlist in order of appearance
--------------------------------------------------------------------
  procedure store_param_list(i_param       in     var_rec_typ
                            ,io_param_list in out param_list_typ ) is
  BEGIN
    io_param_list(io_param_list.COUNT+1) := i_param; 
  END;

 








--------------------------------------------------------------------
-- store_var_list - Store variable in variable list, index by upper of name
-- Put multiple entries in the var list for a single var.
--------------------------------------------------------------------
  procedure store_var_list(i_var        in     var_rec_typ
                          ,io_var_list  in out var_list_typ
                          ,i_pu_stack   in     pu_stack_typ ) is
    l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'store_var_list'); 
    l_var   var_rec_typ := i_var;
 
    procedure add_var(i_var        in     var_rec_typ ) is
  
      l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'add_var'); 
   
      x_assign_var_exists exception;
   
    BEGIN
      sm_logger.param(l_node,'i_var.name' ,i_var.name);
      sm_logger.param(l_node,'i_var.type' ,i_var.type);
      sm_logger.param(l_node,'i_var.level',i_var.level);
  
      IF io_var_list.EXISTS(UPPER(i_var.name)) then
        IF io_var_list(UPPER(l_var.name)).assign_var            and  
           io_var_list(UPPER(l_var.name)).signature is not null then
          raise x_assign_var_exists;
        end if;
  
  
        IF io_var_list(UPPER(i_var.name)).level = i_var.level then
          sm_logger.warning(l_node, 'This variable already exists at this scoping level.  New version overwriting it.');
        ELSE 
          sm_logger.comment(l_node, 'A variable of the same name exists at a higher scoped level.');
          sm_logger.comment(l_node, 'The new variable now has scope at this level.');
        END IF;  
      END IF;  
  
      --Add the variable into variable list.
      io_var_list(UPPER(i_var.name)) := i_var;  
  
    EXCEPTION
      WHEN x_assign_var_exists THEN
        sm_logger.comment(l_node, 'An ASSIGNMENT variable is already stored for this name and scoping level.  Ignoring this instance');
   
    END;
 
  BEGIN
    sm_logger.param(l_node,'i_var.name' ,i_var.name);
    sm_logger.param(l_node,'i_var.type' ,i_var.type);
    sm_logger.param(l_node,'i_var.level',i_var.level);

    add_var(i_var  => l_var );

    --ADDITIONAL NAMED VERSIONS 
    --This section pre-dated the usage of PLScope in SmartLogger.
    --It should not longer be needed at all, except it is being used as a workaround for the following issues.
     
    --PLScope LIMITATION - Variables in the package spec, these can be addressed in by OWNER.PACKAGE.VARNAME
    --  But PLScope only records PACKAGE.VARNAME in the ASSIGNMENT entry.
    --  So this routine is used to supply the OWNER.PACKAGE.VARNAME version of the variable.

    --PLScope BUG        -Null statements in a PLSQL block illcit a bug in PLScope, where it does not register ASSIGNMENTS.
    --  When this happens in conjunction with qualified naming of variables, variable names are not recognised.

    --Hence the routine below, now reinstated for storing every type of var
 
    declare
       l_index        BINARY_INTEGER;
    begin   
      l_index := i_pu_stack.LAST; --Find last entry in the pu stack

        --These variables may need to be addressed by a rollup of their names.
        --In order to index the variable by all of it's possible names  
        --we will step backwards thru the i_pu_stack adding names onto the var name 
        --and adding it to the list again
        --until we have fully qualified the variable name.
        WHILE l_index is not null loop
          sm_logger.note(l_node,i_pu_stack(l_index).name,i_pu_stack(l_index).type);
          l_var.name := lower(i_pu_stack(l_index).name||'.'||l_var.name);

          add_var(i_var  => l_var );
          --Find previous name in the pu stack
          l_index := i_pu_stack.PRIOR(l_index);
        end loop;

    end;
 

  END;

--------------------------------------------------------------------
-- get_expanded_param_list - Expand any composite parameter into its componants
--------------------------------------------------------------------
 FUNCTION get_expanded_param_list(i_param_list in param_list_typ ) return param_list_typ is
  l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_expanded_param_list'); 
  l_expanded_param_list   param_list_typ;
  l_index                 BINARY_INTEGER;

BEGIN
 
  
  --  Expand any composite parameter into its componants and add them to the new list.
 
  --Loop thru input list 
  l_index := i_param_list.FIRST;
  WHILE l_index IS NOT NULL LOOP

     sm_logger.note(l_node, 'i_param_list(l_index).name'   ,i_param_list(l_index).name); 
     sm_logger.note(l_node, 'i_param_list(l_index).type'   ,i_param_list(l_index).type); 
     sm_logger.note(l_node, 'i_param_list(l_index).rowtype',i_param_list(l_index).rowtype); 

    
    CASE
      --Check type of param
      WHEN is_atomic_type(i_type => i_param_list(l_index).type) THEN
        sm_logger.comment(l_node, 'Copy simple param to new list.');
        store_param_list(i_param       => i_param_list(l_index)
                        ,io_param_list => l_expanded_param_list);

      --Check for rowtype
      WHEN i_param_list(l_index).rowtype is not null then
        sm_logger.comment(l_node, 'Expand a Rowtype');
        --assume we've already figured out this is a rowtype
        declare 
          l_table_owner     varchar2(30);
          l_component_param var_rec_typ;
        begin

          l_table_owner     := table_owner(i_table_name => i_param_list(l_index).rowtype);
          sm_logger.note(l_node, 'l_table_owner'    ,l_table_owner); 
 
          FOR l_column IN 
            (select lower(column_name) column_name
                   ,data_type
             from dba_tab_columns
             where table_name = i_param_list(l_index).rowtype 
             and   owner      = l_table_owner ) LOOP

             l_component_param         := i_param_list(l_index); --clone the parent type
             l_component_param.rowtype := null;
             l_component_param.name    := l_component_param.name||'.'||l_column.column_name;
             l_component_param.type    := l_column.data_type;

             store_param_list(i_param       => l_component_param
                             ,io_param_list => l_expanded_param_list);

          END LOOP;   
        end;

       ELSE
         sm_logger.comment(l_node, 'Param ommitted!');

     END CASE;   
 
    l_index := i_param_list.NEXT(l_index);    
 
  END LOOP;

  log_param_list(i_param_list => l_expanded_param_list);

  RETURN l_expanded_param_list;


END;





--------------------------------------------------------------------
-- source_has_tag
--------------------------------------------------------------------
/** PRIVATE
* Check existence of a text tag within the source text of an object
* @param i_owner Object Owner 
* @param i_name  Object Name 
* @param i_type  Object Type 
* @param i_tag   Search Tag
*/
  function source_has_tag(i_owner varchar2
                         ,i_name  varchar2
                         ,i_type  varchar2
                         ,i_tag   varchar2) return boolean is
    l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'source_has_tag');

  cursor cu_check_aop_tags(c_owner varchar2
                          ,c_name  varchar2
                          ,c_type  varchar2
                          ,c_tag   varchar2) is
  select 1 --l_archived, owner, name, type, line, text
  --from   dba_source
  --where  owner = c_owner
  from   user_source
  where  name  = c_name
  and    type  = c_type
  and    text  like '%'||i_tag||'%';


  l_dummy number;
  l_result boolean;
  begin --source_has_tag
    sm_logger.param(l_node,'i_owner'                       ,i_owner);
    sm_logger.param(l_node,'i_name'                        ,i_name);
    sm_logger.param(l_node,'i_type'                        ,i_type);
    sm_logger.param(l_node,'i_tag'                         ,i_tag);
  begin
    OPEN cu_check_aop_tags(c_owner => i_owner
                          ,c_name  => i_name 
                          ,c_type  => i_type
                          ,c_tag   => i_tag );
    FETCH cu_check_aop_tags into l_dummy;
    l_result := cu_check_aop_tags%FOUND;
    sm_logger.note(l_node,'l_result',l_result);
    CLOSE cu_check_aop_tags;

    return l_result;
  end;
  exception
    when others then
      sm_logger.warn_error(l_node);
      raise;
  end; --source_has_tag

--------------------------------------------------------------------
-- source_weave_now
--------------------------------------------------------------------
/** PUBLIC
* Check existence of @AOP_LOG_WEAVE_NOW tag within the source text of an object
* @param i_owner Object Owner 
* @param i_name  Object Name 
* @param i_type  Object Type 
*/
  function source_weave_now(i_owner varchar2
                           ,i_name  varchar2
                           ,i_type  varchar2) return boolean is
  BEGIN
    return source_has_tag(i_owner => i_owner
                         ,i_name  => i_name 
                         ,i_type  => i_type 
                         ,i_tag   => g_aop_weave_now );
  

  END;

--------------------------------------------------------------------
-- source_reg_mode_debug
--------------------------------------------------------------------
/** PUBLIC
* Check existence of @AOP_REG_MODE_DEBUG tag within the source text of an object
* @param i_owner Object Owner 
* @param i_name  Object Name 
* @param i_type  Object Type 
*/
  function source_reg_mode_debug(i_owner varchar2
                           ,i_name  varchar2
                           ,i_type  varchar2) return boolean is
  BEGIN
    return source_has_tag(i_owner => i_owner
                         ,i_name  => i_name 
                         ,i_type  => i_type 
                         ,i_tag   => g_aop_reg_mode_debug );
  

  END;
 


--------------------------------------------------------------------
-- calc_indent
--------------------------------------------------------------------
/** PRIVATE
* Read the indent (number of leading spaces) in i_match
* @param i_default      Default Ident
* @param i_match        Matched string 
* @return Count of leading spaces in i_match, or if i_match does not start with CR, just return i_default.
*/
  FUNCTION calc_indent(i_default IN INTEGER
                      ,i_match   IN VARCHAR2) RETURN INTEGER IS
    l_indent INTEGER;
  BEGIN
 
    IF substr(i_match,1,1) = chr(10) THEN

      l_indent := LENGTH(REGEXP_SUBSTR(i_match,'\s*'))-1; --Count leading spaces

      RETURN l_indent;

    ELSE
      RETURN i_default;

    END IF;
  END;


--------------------------------------------------------------------
-- elapsed_time_secs
--------------------------------------------------------------------
/** PRIVATE
* Calculate the elapsed time since the weave began 
* @return Elapsed time in seconds
*/
  function elapsed_time_secs return integer is
  begin
    return (sysdate - g_weave_start_time) * 24 * 60 * 60;
  end;
 
--------------------------------------------------------------------
-- escape_html
--------------------------------------------------------------------
/** PRIVATE
* Replace some chars [&<>] that are reserved in HTML with coded equivalents
* @param i_text   Source Text
* @return i_text post replacement
*/
  FUNCTION escape_html(i_text   IN CLOB ) RETURN CLOB IS

    l_result CLOB;

  BEGIN

    l_result := REPLACE(i_text  , '&', '&amp');
    l_result := REPLACE(l_result, '<', '&lt');
    l_result := REPLACE(l_result, '>', '&gt');

    RETURN l_result;

  END;


--------------------------------------------------------------------
-- f_colour
--------------------------------------------------------------------
/** PRIVATE
* Add HTML inline span style colour tags to highlight the HTML text
* This is specifically designed for display in the Apex app.
* @param i_text   Source Text
* @param i_colour HEX colour code 
* @return i_text post replacement
*/
  FUNCTION f_colour(i_text   IN CLOB
                   ,i_colour IN VARCHAR2) RETURN CLOB IS
  BEGIN
    IF g_for_aop_html AND i_colour IS NOT NULL THEN
    RETURN '<span style="background-color:#'||LTRIM(i_colour,'#')||';">'
         ||escape_html(i_text)
       ||'</span>';
    ELSE
     RETURN i_text;
  END IF;
  END;
 

--------------------------------------------------------------------
-- check_timeout
--------------------------------------------------------------------
/** PRIVATE
* Determine whether the precalculated timeout has been exceeded.
* @throws x_weave_timeout
*/
  procedure check_timeout is
  --
  begin
    if elapsed_time_secs >  g_weave_timeout_secs then
    raise x_weave_timeout;
  end if;
  
  end;

--------------------------------------------------------------------
-- set_weave_timeout
--------------------------------------------------------------------
/** PRIVATE
* Calculate the max time allowed for the weave, based on the number of lines in the source.
* Result is stored in g_weave_timeout_secs
* The timeout is used to protect against infinite recursion or iteration.
* @throws x_weave_timeout
*/
  procedure set_weave_timeout is
    l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'set_weave_timeout');  
    l_weave_line_count INTEGER;
 
  BEGIN
    --Line Count derived from length of CLOB minus length of CLOB-without-CR
    l_weave_line_count := LENGTH(g_code) - LENGTH(REPLACE(g_code,chr(10)));
    sm_logger.note(l_node, 'l_weave_line_count ',l_weave_line_count );
    g_weave_timeout_secs := ROUND(l_weave_line_count/1000*G_TIMEOUT_SECS_PER_1000_LINES)+2;
    sm_logger.note(l_node, 'g_weave_timeout_secs ',g_weave_timeout_secs );
  g_weave_start_time := SYSDATE;
 
  END;
 
--------------------------------------------------------------------
-- during_advise
--------------------------------------------------------------------
/** PUBLIC
* Is the weaver currently performing a weave.
* This function is used purely by the trigger sm_weaver_trg to ensure it is NOT triggered by the weaver itself.
* @return TRUE when weaving.
*/
  function during_advise return boolean is
  begin 
    return g_during_advise;
  end during_advise;

--------------------------------------------------------------------
-- compile_plsql
--------------------------------------------------------------------  
/** PRIVATE
* Recompile the source code with compiler directives.
* @param i_text         Source Code
* @param i_with_plscope plscope for AOP
* @param i_for_logger   optimiser level 1 for sm_logger
*/
PROCEDURE compile_plsql(i_text         in clob
                       ,i_with_plscope in boolean default true
                       ,i_for_logger   in boolean default true) is
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN     

  IF i_with_plscope then
    --IDENTIFIERS:ALL
    --recompile with plscope set to identifiers:all to ensure any references to this package are captured.
    execute immediate q'[alter session set plscope_settings='IDENTIFIERS:ALL']';

  end if;  

  IF i_for_logger then
    --optimiser level 1
    --sm_logger relies on packages compiled in optimiser level 1, to correcly determine execution tree.
    --This prevents the optimiser from rewriting sub-procedures as inline macros.

    --https://docs.oracle.com/cd/B28359_01/server.111/b28320/initparams184.htm#REFRN10255
    --PLSQL_OPTIMIZE_LEVEL specifies the optimization level that will be used to compile PL/SQL library units. 
    --The higher the setting of this parameter, the more effort the compiler makes to optimize PL/SQL library units.
    --Applies a wide range of optimizations to PL/SQL programs including the elimination of unnecessary computations and exceptions, 
    --but generally does not move source code out of its original source order.

    execute immediate 'alter session set plsql_optimize_level = 1';

  end if;
 
  execute immediate i_text;  --11G CLOB OK
  commit;
END;



 
--------------------------------------------------------------------
-- validate_source
--------------------------------------------------------------------
/** PRIVATE
* Compile the source against the database, as directed (i_compile).
* Store the source in table sm_source
* Return the success result of compilation, if any.
* Executes i_text against the database.
* Uses ALL_ERRORS to report compilation errors.
* @param i_name     Object Name
* @param i_type     Object Type
* @param i_text     Object source text
* @param i_aop_ver  AOP Version (ORIG,AOP,HTML)
* @param i_compile  Directive to compile or not.
* @return TRUE if compilation successful, or not directed to compile.
*/
  function validate_source(i_name        IN VARCHAR2
                         , i_type        IN VARCHAR2
                         , i_text        IN CLOB
                         , i_aop_ver     IN VARCHAR2
                         , i_compile     IN BOOLEAN  
            ) RETURN boolean IS
    l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'validate_source');              
                      
    l_sm_source    sm_source%ROWTYPE;    
 
  BEGIN     
 
    sm_logger.param(l_node, 'i_name      '          ,i_name   );
    sm_logger.param(l_node, 'i_type      '          ,i_type      );
    --sm_logger.param(l_node, 'i_text    '          ,i_text          ); --too big.
    sm_logger.param(l_node, 'i_aop_ver   '           ,i_aop_ver      );
    sm_logger.param(l_node, 'i_compile   '           ,i_compile      );

    --Prepare record.
    l_sm_source.name          := i_name;
    l_sm_source.type          := i_type;
    l_sm_source.aop_ver       := i_aop_ver;
    l_sm_source.text          := i_text;
    l_sm_source.load_datetime := sysdate;
    l_sm_source.valid_yn      := 'N';
    l_sm_source.result        := 'Success.';
  
    IF i_compile THEN 
 
      begin

        --NB Esp do not want PLScope when validating before the recompile of referenced packages
        --Because these packages need to be compiled with PLScope in the right order.
        compile_plsql(i_text         => i_text
                     ,i_with_plscope => i_aop_ver = 'AOP'
                     ,i_for_logger   => i_aop_ver = 'AOP');

          l_sm_source.valid_yn := 'Y';
      exception
          when others then
          l_sm_source.result   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
           sm_logger.warn_error(l_node);   
        
        --Output Show Errors info
            FOR l_error IN (select line||' '||text  error_line
                        from USER_ERRORS 
                        where NAME = i_name 
                        AND   type = i_type)
            LOOP
              DBMS_OUTPUT.PUT_LINE(l_error.error_line);
              sm_logger.warning(l_node,l_error.error_line); 
              l_sm_source.result := l_sm_source.result ||chr(10)||l_error.error_line;
            END LOOP;
    
      end;
 
    end if;
 
    ins_upd_sm_source(i_sm_source => l_sm_source);
       
    COMMIT;
    
    RETURN NOT i_compile OR l_sm_source.valid_yn = 'Y';
 
  exception
      when others then
         sm_logger.oracle_error(l_node);  
         RETURN FALSE;	   
  
  END;
 
 
--------------------------------------------------------------------
-- splice
--------------------------------------------------------------------
/** PRIVATE
* Splice extra code into source code.  
* Extra code will be inserted within the source code to create a longer result.
* Return the result in io_code.
* @param io_code     Source Code
* @param i_new_code Extra Code to be spliced into Source Code
* @param i_pos      Position within Source Code to splice Extra Code
* @param i_indent   Current indenting (number of spaces indented) - if not null, then a new line is injected.
* @param i_colour   Colour to be wrapped around the spliced code.
*/
  procedure splice( io_code     in out clob
                   ,i_new_code in clob
                   ,i_pos      in out number
                   ,i_indent   in number   default null
                   ,i_colour   in varchar2 default null ) IS
                   
    l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'splice');  
    l_new_code        CLOB;
    l_colour          VARCHAR2(10);
    l_leading_nl_offset       INTEGER := 0; --NO OFFSET 
    l_trailing_nl_offset       INTEGER := 0; --NO OFFSET
    l_next_char       CHAR(1);
  
  
    l_word_char_pos   INTEGER;
    l_nl_pos          INTEGER;


  BEGIN

    --sm_logger.param(l_node, 'io_code'          ,io_code );
    --sm_logger.param(l_node, 'LENGTH(io_code)'  ,LENGTH(io_code)  );
    --sm_logger.param(l_node, 'i_new_code'      ,i_new_code);
    sm_logger.param(l_node, 'i_pos     '       ,i_pos     );
    sm_logger.param(l_node, 'i_indent     '    ,i_indent     );
    sm_logger.param(l_node, 'i_colour  '       ,i_colour     );

    sm_logger.note(l_node, 'g_for_aop_html     '     ,g_for_aop_html     );

    l_new_code := f_colour(i_text   => i_new_code
                          ,i_colour => NVL(i_colour, G_COLOUR_SPLICE));
    sm_logger.note(l_node, 'l_new_code     '     ,l_new_code     );
  

    --sm_logger.note(l_node, 'char @ intial pos-2     '   ,substr(io_code, i_pos-2, 1)||ascii(substr(io_code, i_pos-2, 1)));
    --sm_logger.note(l_node, 'char @ intial pos-1     '   ,substr(io_code, i_pos-1, 1)||ascii(substr(io_code, i_pos-1, 1)));
    --sm_logger.note(l_node, 'char @ intial pos       '   ,substr(io_code, i_pos, 1)||ascii(substr(io_code, i_pos, 1)));
    --sm_logger.note(l_node, 'char @ intial pos+1     '   ,substr(io_code, i_pos+1, 1)||ascii(substr(io_code, i_pos+1, 1)));
    --sm_logger.note(l_node, 'char @ intial pos+2     '   ,substr(io_code, i_pos+2, 1)||ascii(substr(io_code, i_pos+2, 1)));

    IF i_indent is not null then
      ----INJECT LINE
 
      IF ascii(substr(io_code, i_pos-1, 1)) = 10 then
        --Current char is a NL - we want to skip it in the splice, since we are going to add a NL infront of the splice anyway.
        sm_logger.comment(l_node, 'Seting the NL offset to remove 1 NL');
        l_leading_nl_offset := 1;
      END IF;
 
      --Apply a leading new line and indent by i_indent spaces
      --l_new_code := replace(chr(10)||l_new_code,chr(10),chr(10)||rpad(' ',(i_indent-1)*g_indent_spaces+g_indent_spaces,' '));
      l_new_code := replace(chr(10)||l_new_code,chr(10),chr(10)||rpad(' ',i_indent+g_indent_spaces,' '));
 
      IF REGEXP_INSTR(io_code,G_REGEX_WORD_CHAR,i_pos) < INSTR(io_code,chr(10),i_pos) THEN
        --Add a trailing newline, because there is a word-char before the next NL.
        sm_logger.comment(l_node, 'Add a trailing newline');
        l_new_code := l_new_code||chr(10);
        l_trailing_nl_offset := 1;
      END IF;
  
    END IF; 

    --i_pos - the current position is taken to indicate the next character to be read eg by regex_substr
    --so when you splice with current position, it is to be between pos-1 and pos
    io_code:= substr(io_code, 1, i_pos-1-l_leading_nl_offset)
           ||l_new_code
           ||substr(io_code, i_pos);

    i_pos := i_pos + length(l_new_code)-l_leading_nl_offset-l_trailing_nl_offset;  

    --sm_logger.note(l_node, 'char @ final pos-2     '   ,substr(io_code, i_pos-2, 1)||ascii(substr(io_code, i_pos-2, 1)));
    --sm_logger.note(l_node, 'char @ final pos-1     '   ,substr(io_code, i_pos-1, 1)||ascii(substr(io_code, i_pos-1, 1)));
    --sm_logger.note(l_node, 'char @ final pos       '   ,substr(io_code, i_pos, 1)||ascii(substr(io_code, i_pos, 1)));
    --sm_logger.note(l_node, 'char @ final pos+1     '   ,substr(io_code, i_pos+1, 1)||ascii(substr(io_code, i_pos+1, 1)));
    --sm_logger.note(l_node, 'char @ final pos+2     '   ,substr(io_code, i_pos+2, 1)||ascii(substr(io_code, i_pos+2, 1)));
    
    --sm_logger.note(l_node, 'io_code     '     ,io_code     );
    --sm_logger.note(l_node, 'i_pos     '      ,i_pos     );

  END;
  
--------------------------------------------------------------------
-- wedge
--------------------------------------------------------------------
/** PRIVATE
* Wedge splices i_new_code into the global g_code at the global g_current_pos
* Does not specify i_indent when calling splice, so splice will NOT create a new line.
* @param i_new_code Extra Code to be spliced into g_code
* @param i_colour   Colour to be wrapped around the spliced code.
*/
    PROCEDURE wedge( i_new_code in varchar2
                    ,i_colour   in varchar2 default null) IS
  
  BEGIN
    IF i_new_code IS NOT NULL THEN
      splice( io_code     => g_code    
             ,i_new_code  => i_new_code
             ,i_pos       => g_current_pos
             ,i_colour    => i_colour  );
    END IF;      
   
  END;
  
--------------------------------------------------------------------
-- inject
--------------------------------------------------------------------
/** PRIVATE
* Inject splices i_new_code into the global g_code at the global g_current_pos with a new line (assuming i_indent is not null)
* @param i_new_code Extra Code to be spliced into g_code.
* @param i_indent   Indenting to be used on the new line.
* @param i_colour   Colour to be wrapped around the spliced code.
*/
    PROCEDURE inject( i_new_code in varchar2
                     ,i_indent   in number
                     ,i_colour   in varchar2 default null) IS
  BEGIN
    IF i_new_code IS NOT NULL THEN
      --g_current_pos := g_current_pos - 1;
      splice( io_code      => g_code    
             ,i_new_code  => i_new_code
             ,i_pos       => g_current_pos     
             ,i_indent    => i_indent
             ,i_colour    => i_colour  );  
    END IF;      
  END;
  

--------------------------------------------------------------------------------- 
-- ATOMIC - Low level routines.
--------------------------------------------------------------------------------- 
 

--------------------------------------------------------------------
-- trim_whitespace
--------------------------------------------------------------------
/** PRIVATE
* Use REGEXP_REPLACE to remove upto 1 leading and trailing whitespace from i_words
* @param i_words Source Text to be trimmed.
* @return Trimmed Source Text 
*/
FUNCTION trim_whitespace(i_words IN CLOB) RETURN CLOB IS
  G_REGEX_LEADING_TRAILING_WHITE CONSTANT VARCHAR2(20) := '^\s|\s$'; --upto 1 leading and trailing whitespace
BEGIN
  RETURN TRIM(REGEXP_REPLACE(i_words,G_REGEX_LEADING_TRAILING_WHITE,''));
END;

--------------------------------------------------------------------
-- flatten
--------------------------------------------------------------------
/** PRIVATE
* Use REGEXP_REPLACE to convert all whitespace in i_words to simple spaces.
* This effectively turns multiple lines into a single line.
* @param i_words Source Text to be trimmed.
* @return Flatten Source Text 
*/
FUNCTION flatten(i_words IN VARCHAR2) RETURN VARCHAR2 IS
  G_REGEX_WHITE CONSTANT VARCHAR2(20) := '\s';
BEGIN
  RETURN REGEXP_REPLACE(i_words,G_REGEX_WHITE,' ');
END;

--------------------------------------------------------------------
-- shrink
--------------------------------------------------------------------
/** PRIVATE
* Use REGEXP_REPLACE to remove all whitespace in i_words
* @param i_words Source Text to be trimmed.
* @return Source Text with no whitespace
*/
FUNCTION shrink(i_words IN VARCHAR2) RETURN VARCHAR2 IS
  G_REGEX_WHITE CONSTANT VARCHAR2(20) := '\s';
BEGIN
  RETURN REGEXP_REPLACE(i_words,G_REGEX_WHITE,'');
END;


--------------------------------------------------------------------
-- REGEXP_INSTR_NOT0
--------------------------------------------------------------------
/** PRIVATE
* Variant of REGEXP_INSTR.   This version will return 10000000 instead of 0.
* Usage: REGEXP_INSTR_NOT0(string, pattern [, position [, occurrence [, return_position [, regexp_modifier]]]])
* @param i_string          source string
* @param i_pattern         search pattern
* @param i_position        start search position
* @param i_occurrence      search for this occurrence
* @param i_return_option   lets you specify what Oracle should return in relation to the occurrence:
* If you specify 0, then Oracle returns the position of the first character of the occurrence. This is the default.
* If you specify 1, then Oracle returns the position of the character following the occurrence.
* @param i_regexp_modifier  Is a text literal that lets you change the default matching behavior of the function REGEXP_INSTR
* @return position of i_pattern within i_string.
*/
FUNCTION REGEXP_INSTR_NOT0(i_string           IN CLOB  
                          ,i_pattern          IN VARCHAR2
                          ,i_position         IN INTEGER  DEFAULT NULL
                          ,i_occurrence       IN INTEGER  DEFAULT NULL
                          ,i_return_option    IN INTEGER  DEFAULT NULL
                          ,i_regexp_modifier  IN VARCHAR2 DEFAULT NULL) RETURN INTEGER IS

  l_result INTEGER;
 
BEGIN
  l_result := REGEXP_INSTR(i_string, i_pattern, i_position , i_occurrence , i_return_option , i_regexp_modifier );

  IF l_result = 0 THEN
    RETURN 10000000;
  ELSE  
    RETURN l_result;
  END IF;
 
END;  
 
 
--------------------------------------------------------------------
-- get_next
--------------------------------------------------------------------
/** PRIVATE
* Given keywords to find, get_next will return first matching string.
* The search keywords are split into i_srch_before, i_stop, i_srch_after, in that order of priority.
* If there is a match in more than one keyword set, the match from i_srch_before is given priority over i_stop, and i_stop is given priority over i_srch_after
* The highest priority match is returned as the result, but only a match from i_srch_before or i_srch_after is consumed.
* When a match is consumed, the current position is advanced past the match, and the text is then not scanned again.
* A match from i_stop is merely used to halt the search.  The match itself is not consumed.  The current position is not advanced.
* After ANY match the global positions will be updated
*   g_upto_pos to the start of the match
*   g_past_pos to the end of the match
* IF match FROM i_srch_before or i_srch_after THEN it is consumed, meaning g_current_pos will also advance to g_past_pos. 
* IF match FROM i_stop                        THEN it is NOT consumed.  g_current_pos does not change, even though g_upto_pos and g_past_pos have advanced.
* @param i_srch_before     search and consume keywords       - higher priority than i_stop   
* @param i_stop            search and stop without consuming
* @param i_srch_after      search and consume keywords       - lower  priority than i_stop
* @param i_modifier        modifier is applied in all REGEX functions       
* @param i_upper           return UPPER(result)     
* @param i_lower           return LOWER(result)         
* @param i_colour          colour used to highlight consumed words in HTML mode.       
* @param i_raise_error     raise an error if no match, and output the search string
* @param i_trim_result     strip from result, upto 1 leading and trailing whitespace     
* @param i_trim_pointers   g_upto_pos and g_past_pos will point to the start and stop of the trimmed result      
* @return matched text
* @throws x_string_not_found
*/
FUNCTION get_next(i_srch_before        IN     VARCHAR2 DEFAULT NULL
                 ,i_srch_after         IN     VARCHAR2 DEFAULT NULL 
                 ,i_stop               IN     VARCHAR2 DEFAULT NULL
                 ,i_modifier           IN     VARCHAR2 DEFAULT 'i'
                 ,i_upper              IN     BOOLEAN  DEFAULT FALSE
                 ,i_lower              IN     BOOLEAN  DEFAULT FALSE
                 ,i_colour             IN     VARCHAR2 DEFAULT NULL 
                 ,i_raise_error        IN     BOOLEAN  DEFAULT FALSE
                 ,i_trim_pointers      IN     BOOLEAN  DEFAULT TRUE
                 ,i_trim_result        IN     BOOLEAN  DEFAULT FALSE 
                 ,io_code               IN OUT CLOB 
                 ,io_current_pos        IN OUT INTEGER 
                 ,io_upto_pos           IN OUT INTEGER 
                 ,io_past_pos           IN OUT INTEGER ) return CLOB IS

  l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_next'); 
  
  l_any_match             CLOB;  --the match from any of the componants
  l_trimmed_any_match     CLOB;
  l_colour_either_match   CLOB;
  l_result                CLOB;
  l_any_search            CLOB;
 
  l_trim_upto_pos         INTEGER;

  l_srch_before_pos       INTEGER;
  l_srch_after_pos        INTEGER;


  l_use_srch_before          BOOLEAN := TRUE;

  --------------------------------------------------------------------
  -- consume_search
  --------------------------------------------------------------------
  /** SUB-PROC
  * Consume search componant that was just found.
  */
  PROCEDURE consume_search IS
  BEGIN
    sm_logger.comment(l_node, 'Consume search componant');
    l_colour_either_match := f_colour(i_text   => l_trimmed_any_match  
                                     ,i_colour => i_colour);
 
    io_code := SUBSTR(io_code,1,io_upto_pos-1)
            ||l_colour_either_match
            ||SUBSTR(io_code,io_past_pos)  ;
       
    --Now advance the past_pos   
    io_past_pos := io_upto_pos + LENGTH(l_colour_either_match);
    --Current pos is now the past_pos
    io_current_pos := io_past_pos;
  END;
 

BEGIN --GET_NEXT
  sm_logger.param(l_node, 'i_srch_before'     ,i_srch_before);
  sm_logger.param(l_node, 'i_srch_after'      ,i_srch_after);
  sm_logger.param(l_node, 'i_stop'            ,i_stop);
  sm_logger.param(l_node, 'i_modifier     '   ,i_modifier     );
  sm_logger.param(l_node, 'i_upper        '   ,i_upper        );
  sm_logger.param(l_node, 'i_lower        '   ,i_lower        );
  sm_logger.param(l_node, 'i_colour       '   ,i_colour       );
  sm_logger.param(l_node, 'i_raise_error  '   ,i_raise_error  );
  sm_logger.param(l_node, 'i_trim_pointers'   ,i_trim_pointers);
  sm_logger.param(l_node, 'i_trim_result  '   ,i_trim_result  );
  sm_logger.param(l_node, 'io_current_pos'    ,io_current_pos);
  sm_logger.param(l_node, 'io_upto_pos'       ,io_upto_pos);
  sm_logger.param(l_node, 'io_past_pos'       ,io_past_pos);

  --Workaround - when i_srch_before gets too long -> ORA-03113: end-of-file on communication channel
  --So split into 2 searches.
  --Now i_srch_after will search after i_stop
  IF i_srch_before IS NOT NULL AND i_srch_after IS NULL THEN
    l_use_srch_before := TRUE;

  ELSIF i_srch_before IS NULL AND i_srch_after IS NOT NULL THEN  
    l_use_srch_before := FALSE;

  ELSIF i_srch_before IS NOT NULL AND i_srch_after IS NOT NULL THEN 

    sm_logger.comment(l_node, 'Choosing search param');
 
 --@TODO May be useful to test the after pos, instead of the before position esp WRT '.*:='
    --Find out which seach terms (i_srch_before or i_srch_after) find the first result.
    l_srch_before_pos  := REGEXP_INSTR_NOT0(io_code,i_srch_before,io_current_pos,1,0,i_modifier);
    l_srch_after_pos   := REGEXP_INSTR_NOT0(io_code,i_srch_after ,io_current_pos,1,0,i_modifier);

    sm_logger.note(l_node, 'l_srch_before_pos',l_srch_before_pos);
    sm_logger.note(l_node, 'l_srch_after_pos',l_srch_after_pos);
 
    --Use search before, if that term yields the first (earliest) result.  Otherwise search after.
    l_use_srch_before := l_srch_before_pos < l_srch_after_pos;
 
  end if;
 
  If l_use_srch_before THEN
      sm_logger.info(l_node, 'Using i_srch_before|i_stop');
      l_any_search := TRIM('|' FROM i_srch_before ||'|'||i_stop);
    else
      sm_logger.info(l_node, 'Using i_stop|i_srch_after');
      l_any_search := TRIM('|' FROM i_stop ||'|'||i_srch_after);
  end if;

 
  sm_logger.note(l_node, 'l_any_search',l_any_search  );
  sm_logger.note_length(l_node, 'l_any_search',l_any_search  );
 
  --Keep the original "either" match
  l_any_match := REGEXP_SUBSTR(io_code,l_any_search,io_current_pos,1,i_modifier);
  sm_logger.note_clob(l_node, 'l_any_match',l_any_match  );
 
  --Should we raise an error?
  IF l_any_match IS NULL AND i_raise_error THEN
    sm_logger.fatal(l_node, 'String missing '||l_any_search);
    wedge( i_new_code => 'STRING NOT FOUND '||l_any_search
          ,i_colour   => G_COLOUR_ERROR);
    RAISE x_string_not_found;
  
  END IF; 
  
  --Calculate the new positions.  
  io_upto_pos := REGEXP_INSTR(io_code,l_any_search,io_current_pos,1,0,i_modifier);
  io_past_pos := REGEXP_INSTR(io_code,l_any_search,io_current_pos,1,1,i_modifier);     
  sm_logger.note(l_node, 'io_upto_pos',io_upto_pos  );
 
  
  l_trimmed_any_match := trim_whitespace(l_any_match);
  
  IF i_trim_result THEN
    l_result := l_trimmed_any_match; 
  ELSE
   l_result := l_any_match;
  END IF; 
 
  if l_trimmed_any_match IS NOT NULL AND i_trim_pointers THEN
  
    --Now that we've trimmed the match, lets change the pointers to suit.
    --Not a regex search, since just searching for the known string.
    sm_logger.info(l_node, 'Shifting pointers to trimmed match.');
    io_upto_pos := INSTR(io_code,l_trimmed_any_match,io_upto_pos);
    io_past_pos := io_upto_pos + LENGTH(l_trimmed_any_match);
    sm_logger.note(l_node, 'io_upto_pos',io_upto_pos  );
    sm_logger.note(l_node, 'io_past_pos',io_past_pos  );   
  
  END IF;
 
 
  --Determine the priority i_srch_before > i_stop > i_srch_after
  IF  l_use_srch_before AND regex_match(l_any_match,i_srch_before,i_modifier) THEN
    sm_logger.info(l_node, 'Matched on the search componant1');
    consume_search;
 
  ELSIF regex_match(l_any_match,i_stop,i_modifier) THEN
    sm_logger.info(l_node, 'Matched on the stop componant');
    --Matched on the stop componant, don't consume - ie don't advance the pointer.
    NULL;
  ELSIF NOT l_use_srch_before AND regex_match(l_any_match,i_srch_after,i_modifier) THEN
    sm_logger.info(l_node, 'Matched on the search componant2');
    consume_search;  
  END IF;
 
 
  --sm_logger.param(l_node, 'io_current_pos',io_current_pos);
  --sm_logger.note(l_node, 'char @ io_current_pos -2     '   ,substr(io_code, io_current_pos-2, 1)||ascii(substr(io_code, io_current_pos-2, 1)));
  --sm_logger.note(l_node, 'char @ io_current_pos -1     '   ,substr(io_code, io_current_pos-1, 1)||ascii(substr(io_code, io_current_pos-1, 1)));
  --sm_logger.note(l_node, 'char @ io_current_pos        '   ,substr(io_code, io_current_pos, 1)||ascii(substr(io_code, io_current_pos, 1)));
  --sm_logger.note(l_node, 'char @ io_current_pos +1     '   ,substr(io_code, io_current_pos+1, 1)||ascii(substr(io_code, io_current_pos+1, 1)));
  --sm_logger.note(l_node, 'char @ io_current_pos +2     '   ,substr(io_code, io_current_pos+2, 1)||ascii(substr(io_code, io_current_pos+2, 1)));
 
  sm_logger.note_clob(l_node, 'l_result',l_result); 

  sm_logger.note_clob(l_node, 'l_result with LF,CR,SP' ,REPLACE(
                                                        REPLACE(
                                                        REPLACE(l_result,chr(10),'[LF]')
                                                                        ,chr(13),'[CR]')
                                                                        ,chr(32),'[SP]') ); 
 

  IF i_upper THEN   
    RETURN UPPER(l_result);
  ELSIF i_lower THEN
    RETURN LOWER(l_result);
  ELSE
    RETURN l_result;
  END IF; 

exception
  when others then
    sm_logger.warn_error(l_node);
    raise;

END get_next;

--------------------------------------------------------------------
-- get_next
--------------------------------------------------------------------
/** PRIVATE
* Overloaded to allow for unit testing of get_next without package variables
*/
FUNCTION get_next(i_srch_before        IN VARCHAR2 DEFAULT NULL
                 ,i_srch_after         IN VARCHAR2 DEFAULT NULL 
                 ,i_stop               IN VARCHAR2 DEFAULT NULL
                 ,i_modifier           IN VARCHAR2 DEFAULT 'i'
                 ,i_upper              IN BOOLEAN  DEFAULT FALSE
                 ,i_lower              IN BOOLEAN  DEFAULT FALSE
                 ,i_colour             IN VARCHAR2 DEFAULT NULL 
                 ,i_raise_error        IN BOOLEAN  DEFAULT FALSE
                 ,i_trim_pointers      IN BOOLEAN  DEFAULT TRUE
                 ,i_trim_result        IN BOOLEAN  DEFAULT FALSE ) return CLOB is
begin
  check_timeout;  

  return get_next(i_srch_before      => i_srch_before    
                 ,i_srch_after       => i_srch_after     
                 ,i_stop             => i_stop           
                 ,i_modifier         => i_modifier       
                 ,i_upper            => i_upper          
                 ,i_lower            => i_lower          
                 ,i_colour           => i_colour         
                 ,i_raise_error      => i_raise_error    
                 ,i_trim_pointers    => i_trim_pointers  
                 ,i_trim_result      => i_trim_result    
                 ,io_code             => g_code         
                 ,io_current_pos      => g_current_pos  
                 ,io_upto_pos         => g_upto_pos     
                 ,io_past_pos         => g_past_pos); 
 
end;
 
--------------------------------------------------------------------------------- 
-- go_past
---------------------------------------------------------------------------------
/** PRIVATE
* Use get_next to advance past i_search
* Discard result, raise error if no match
* If i_search is null then simply goto the position g_past_pos found during last get_next
* @param i_search   pass to get_next as i_srch_before
* @param i_stop     pass to get_next
* @param i_modifier pass to get_next
* @param i_colour   pass to get_next
* @throws x_string_not_found
*/
PROCEDURE go_past(i_search   IN VARCHAR2 DEFAULT NULL
                 ,i_stop     IN VARCHAR2 DEFAULT NULL
                 ,i_modifier IN VARCHAR2 DEFAULT 'i'
                 ,i_colour   IN VARCHAR2 DEFAULT G_COLOUR_GO_PAST) IS
  l_dummy CLOB;
BEGIN

  IF i_search is null then
    --just goto the position found during last get_next
    g_current_pos := g_past_pos;
  ELSE
 
     l_dummy := get_next(i_srch_before => i_search     
                        ,i_stop        => i_stop       
                        ,i_modifier    => i_modifier   
                        ,i_colour      => i_colour     
                        ,i_raise_error => TRUE );
 
  END IF;
 
END;

--------------------------------------------------------------------------------- 
-- go_upto
---------------------------------------------------------------------------------
/** PRIVATE
* Advance upto i_stop
* Discard result, raise error if no match
* If i_stop is null then simply goto the position g_upto_pos found during last get_next
* @param i_stop            pass to get_next
* @param i_modifier        pass to get_next
* @param i_trim_pointers   pass to get_next
* @throws x_string_not_found
*/
PROCEDURE go_upto(i_stop          IN VARCHAR2 DEFAULT NULL
                 ,i_modifier      IN VARCHAR2 DEFAULT 'i'
                 ,i_trim_pointers IN BOOLEAN DEFAULT FALSE
                 ) IS
  l_dummy CLOB;
BEGIN
 
  if i_stop is not null then

     l_dummy := get_next(i_stop           => i_stop       
                        ,i_modifier       => i_modifier   
                        ,i_trim_pointers  => i_trim_pointers     
                        ,i_raise_error    => TRUE );
  --else
     --just goto the position found during last get_next

  end if;   

  g_current_pos := g_upto_pos;
 
END;


--------------------------------------------------------------------------------- 
-- grab_upto
---------------------------------------------------------------------------------
/** PRIVATE
* Get chars upto i_stop
* Find i_stop, Discard result.  Then grab chars from current to i_stop, raise error if no match
* If i_stop is null then simply goto the position g_upto_pos found during last get_next
* @param i_stop            pass to get_next
* @param i_modifier        pass to get_next
* @param i_trim_pointers   pass to get_next
* @param i_colour          pass to get_next
* @param i_lower           returns result in lowercase
* @param i_upper           returns result in uppercase
* @throws x_string_not_found
*/
FUNCTION grab_upto(i_stop          IN VARCHAR2 DEFAULT NULL
                  ,i_modifier      IN VARCHAR2 DEFAULT 'i'
                  ,i_trim_pointers IN BOOLEAN  DEFAULT FALSE
                  ,i_colour        IN VARCHAR2 DEFAULT G_COLOUR_GO_PAST
                  ,i_lower         IN BOOLEAN  DEFAULT FALSE
                  ,i_upper         IN BOOLEAN  DEFAULT FALSE
                  ) return varchar2 is
l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'grab_upto'); 
  l_dummy  CLOB;
  l_result CLOB;
  l_colour_result CLOB;
BEGIN

  sm_logger.param(l_node, 'i_stop' ,i_stop); 

  if i_stop is not null then

     l_dummy := get_next(i_stop           => i_stop       
                        ,i_modifier       => i_modifier   
                        ,i_trim_pointers  => i_trim_pointers   
                        ,i_colour         => i_colour   
                        ,i_raise_error    => TRUE );
  --else
     --just goto the position found during last get_next

  end if;  

  l_result := SUBSTR(g_code,g_current_pos,g_upto_pos-g_current_pos);

  if i_lower then
    l_result := LOWER(l_result);
  end if;  
  if i_upper then
    l_result := UPPER(l_result);
  end if;  

  --colour the result
  l_colour_result := f_colour(i_text   => l_result  
                             ,i_colour => i_colour);
 
  g_code := SUBSTR(g_code,1,g_current_pos-1)
          ||l_colour_result
          ||SUBSTR(g_code,g_upto_pos)  ;
     
  --Now advance the upto pos  
  g_upto_pos := g_current_pos + LENGTH(l_colour_result);
  
  --Current pos is now the pto pos 
  g_current_pos := g_upto_pos;

  sm_logger.note(l_node, 'l_result' ,l_result); 

  return l_result;
 
END;





--------------------------------------------------------------------------------- 
-- get_next_object_name
---------------------------------------------------------------------------------
/** PRIVATE
* get and consume the next object name
* Search from current position for a single or double word.
* If double word then l_object_name is the 2nd word.
* @return l_object_name
*/
FUNCTION get_next_object_name RETURN VARCHAR2 IS
  l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'get_next_object_name'); 
  l_object_name VARCHAR2(100);

BEGIN
  l_object_name := get_next(i_srch_before  => G_REGEX_2_QUOTED_WORDS
                                  ||'|'||G_REGEX_WORD
                           ,i_lower   => TRUE        
                           ,i_colour  => G_COLOUR_OBJECT_NAME
                           ,i_raise_error  => TRUE);
  --Check for double-word
  IF regex_match(l_object_name , G_REGEX_2_QUOTED_WORDS) THEN
    sm_logger.comment(l_node, 'Double word name - get 2nd word'); 
    l_object_name := REGEXP_SUBSTR(l_object_name,G_REGEX_WORD,1,2,'i');
 
  END IF;

  RETURN l_object_name;

END;  


--------------------------------------------------------------------------------- 
-- FORWARD DECLARATIONS
--------------------------------------------------------------------------------- 
    
--------------------------------------------------------------------------------- 
-- stash_comments_and_strings - Forward Declaration
---------------------------------------------------------------------------------
procedure stash_comments_and_strings;

--------------------------------------------------------------------------------- 
-- restore_comments_and_strings - Forward Declaration
---------------------------------------------------------------------------------
procedure restore_comments_and_strings;

--------------------------------------------------------------------------------- 
-- AOP_prog_units - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_units(i_indent   IN INTEGER
                        ,i_var_list IN var_list_typ
                        ,i_pu_stack in pu_stack_typ );


--------------------------------------------------------------------------------- 
-- AOP_pu_block - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_pu_block(i_prog_unit_name IN VARCHAR2
                      ,i_indent         IN INTEGER
                      ,i_param_list     IN param_list_typ
                      ,i_var_list       IN var_list_typ
                      ,i_pu_stack       in pu_stack_typ  );

--------------------------------------------------------------------------------- 
-- AOP_block
---------------------------------------------------------------------------------
PROCEDURE AOP_block(i_indent         IN INTEGER
                   ,i_regex_end      IN VARCHAR2
                   ,i_var_list       IN var_list_typ
                   ,i_pu_stack       in pu_stack_typ  );                      
                      
--------------------------------------------------------------------------------- 
-- END FORWARD DECLARATIONS
---------------------------------------------------------------------------------         
    

 
--------------------------------------------------------------------------------- 
-- AOP_pu_params
---------------------------------------------------------------------------------
/** PRIVATE
* Indentify parameters in the header of the current program unit
* Determine usage of parameter and add to approp parameter lists.
* param input lists (io_param_list and io_param_types) - For params IN or IN OUT or implicit IN
* variable list     (io_var_list)                      - For params       IN OUT or OUT  
* @param io_param_list  List of input parameter names (indexed by integer)
* @param io_param_types List of input parameter types (indexed by integer)
* @param io_var_list    List of variable names and types -(indexed by name) 
*/
PROCEDURE AOP_pu_params(io_param_list  IN OUT param_list_typ
                       ,io_var_list    IN OUT var_list_typ
                       ,i_pu_stack     IN     pu_stack_typ) is

  l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'AOP_pu_params'); 
 
  l_param_line           CLOB;
  
  l_param_name    VARCHAR2(30);
  l_param_type    VARCHAR2(106);
  l_table_name    VARCHAR2(30);
  l_column_name   VARCHAR2(30);
  l_table_owner   VARCHAR2(30);
  l_package_owner  VARCHAR2(30);
  l_package_name   varchar2(50);
  l_type_name  VARCHAR2(30);


  l_keyword              CLOB;
  l_bracket              VARCHAR2(50);
  x_out_param            EXCEPTION;
  x_unsupported_data_type EXCEPTION;
 
  l_bracket_count        INTEGER;
  
  l_in_var               BOOLEAN;
  l_out_var              BOOLEAN;

  l_var_list_in          var_list_typ := io_var_list; --Keep copy for the end.

  
  --This should be expanded to cover G_REGEX_2WORDS etc - PAB DOING ...
  G_REGEX_NAME_IN_OUT     CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+(IN\s+)?(OUT\s+)?';
  --G_REGEX_PARAM_LINE    CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+(IN\s+)?(OUT\s+)?('||G_REGEX_WORD||')';
  --G_REGEX_PARAM_LINE      CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+(IN\s+)?(OUT\s+)?('||G_REGEX_WORD||')(\.'||G_REGEX_WORD||')?';

  --G_REGEX_PARAM_LINE      CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||')(\.'||G_REGEX_WORD||')?';



 
    
  l_var_def                      CLOB;
  G_REGEX_PARAM_PREDEFINED       CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||G_REGEX_ATOMIC_TYPES;
  G_REGEX_PARAM_ROWTYPE          CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||')%ROWTYPE';                     --Table row type
  G_REGEX_PARAM_COLTYPE          CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||')\.('||G_REGEX_WORD||')%TYPE'; --Table column Type
  G_REGEX_CUSTOM_PLSQL_TYPE_2WD  CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||')\.('||G_REGEX_WORD||')';
  G_REGEX_CUSTOM_PLSQL_TYPE_1WD  CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||')';

  --G_REGEX_CUSTOM_PLSQL_TYPE_2WD      CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||G_REGEX_2WORDS;
   
  --G_REGEX_PACK_REC_VAR_DEF_LINE CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||'?)\.[\w\#\$]+[^\w\#\$]+?';

  --'('||G_REGEX_WORD||'?)'||G_REGEX_NON_WORD_CHAR; --Packaged Record Type
    

  --G_REGEX_PACK_REC_VAR_DEF_LINE CONSTANT VARCHAR2(200) :='([\w\#\$]+)\s+(IN\s+)?(OUT\s+)?([\w\#\$]+?)\.([\w\#\$]+?)[^\w\#\$]';
 
 
  PROCEDURE store_var_def(i_param_name IN VARCHAR2
                         ,i_param_type IN VARCHAR2 default null
                         ,i_rowtype    IN VARCHAR2 default null
                         ,i_in_var     IN BOOLEAN
                         ,i_out_var    IN BOOLEAN ) IS
                         
  l_node     sm_logger.node_typ := sm_logger.new_proc(g_package_name,'store_var_def'); 
  l_var      var_rec_typ;
                    
  BEGIN
  
    sm_logger.param(l_node, 'i_param_name' ,i_param_name); 
    sm_logger.param(l_node, 'i_param_type' ,i_param_type); 
    sm_logger.param(l_node, 'i_rowtype' ,   i_rowtype); 
    sm_logger.param(l_node, 'i_in_var    ' ,i_in_var    ); 
    sm_logger.param(l_node, 'i_out_var   ' ,i_out_var   ); 

    l_var :=  create_var_rec(i_param_name => i_param_name
                            ,i_param_type => i_param_type
                            ,i_rowtype    => i_rowtype
                            ,i_in_var     => i_in_var    
                            ,i_out_var    => i_out_var
                            ,i_pu_stack   => i_pu_stack   );
  
    IF l_var.in_var THEN
      store_param_list(i_param       => l_var
                      ,io_param_list => io_param_list);
    END IF;

    --Now store all params as vars even though not all params can be written to.
    --Need to be able to search for a param by name, to check for special logger params.
    store_var_list(i_var        => l_var
                  ,io_var_list  => io_var_list
                  ,i_pu_stack   => i_pu_stack);




 /*
    IF regex_match(i_param_type,G_REGEX_ATOMIC_TYPES,'i') THEN
 
      IF i_in_var OR NOT i_out_var THEN
          --IN and IN OUT and (implicit IN) included in the param input list.
          sm_logger.comment(l_node, 'Stored IN var');  
          l_var.name    := i_param_name;
          l_var.type    := i_param_type;
          l_var.in_var  := i_in_var OR NOT i_out_var;   --in  param implcit or explicit
          l_var.out_var := i_out_var;                   --out param            explicit
          l_var.lex_var := false;                       --lex locally declared explicit
          l_var.lim_var := false;          --lim locally declared implicit (eg FOR LOOP)
          --,owner --current scope    @FUTURE USE
          --,scope --program hierachy @FUTURE USE
          l_var.signature := null;         --@TODO Populate this. PLScope changes every time the package is recompiled.
 
          io_param_list(io_param_list.COUNT+1) := l_var
 
       END IF;  
    
       IF i_out_var THEN
          --Save IN OUT and OUT params in the variable list. 
          sm_logger.comment(l_node, 'Stored OUT var');  
  
          store_var_list(i_var  _name => i_param_name
                        ,i_param_type => i_param_type
                        ,io_var_list  => io_var_list );
   
          sm_logger.note(l_node, 'io_var_list.count',io_var_list.count);
        END IF;

    ELSE
    
      sm_logger.warning(l_node, 'Not a predefined type. '||G_REGEX_ATOMIC_TYPES);      
 
    END IF;
    */

  END store_var_def;  
 
BEGIN  
 
  loop
    BEGIN

      --Find first: "(" "," "DEFAULT" ":=" "AS" "IS"
      l_keyword := get_next( i_srch_before       => G_REGEX_OPEN_BRACKET
                                        ||'|'||G_REGEX_COMMA
                                        --||'|'||G_REGEX_CLOSE_BRACKET
                                        ||'|'||G_REGEX_DEFAULT
                            ,i_stop         => G_REGEX_RETURN_IS_AS_DECLARE            
                            ,i_upper        => TRUE
                            ,i_colour       => G_COLOUR_PROG_UNIT
                            ,i_raise_error  => TRUE);
 
      CASE 
 
    --NEW PARAMETER LINE
    WHEN regex_match(l_keyword , G_REGEX_OPEN_BRACKET
                               ||'|'||G_REGEX_COMMA)        THEN
           sm_logger.comment(l_node, 'Found new parameter');
         --find the parameter - Search for Eg
             --  varname IN OUT vartype ,
             --  varname IN vartype)
             
          l_var_def := get_next( i_srch_before    =>  G_REGEX_PARAM_ROWTYPE
                                               ||'|'||G_REGEX_PARAM_COLTYPE

                                  ,i_stop         =>  G_REGEX_PARAM_PREDEFINED||'\W'
                                               ||'|'||G_REGEX_CUSTOM_PLSQL_TYPE_2WD
                                               ||'|'||G_REGEX_CUSTOM_PLSQL_TYPE_1WD
                                    ,i_upper        => TRUE
                                    ,i_colour       => G_COLOUR_PARAM
                                    ,i_raise_error  => TRUE);
             
            sm_logger.note(l_node, 'l_var_def',l_var_def);


            --temp debugging only
          -- sm_logger.note(l_node, 'l_var_def p1', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',1));
          -- sm_logger.note(l_node, 'l_var_def p2', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',2));
          -- sm_logger.note(l_node, 'l_var_def p3', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',3));
          -- sm_logger.note(l_node, 'l_var_def p4', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',4));
          -- sm_logger.note(l_node, 'l_var_def p5', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',5));
          -- sm_logger.note(l_node, 'l_var_def p6', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',6));
          -- sm_logger.note(l_node, 'l_var_def p7', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',7));
          -- sm_logger.note(l_node, 'l_var_def p8', REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',8));


             
             l_in_var  := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_NAME_IN_OUT,1,1,'i',3)) LIKE 'IN%';
             l_out_var := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_NAME_IN_OUT,1,1,'i',4)) LIKE 'OUT%';
             sm_logger.note(l_node, 'l_in_var',l_in_var);
             sm_logger.note(l_node, 'l_out_var',l_out_var);
     
             CASE 

            WHEN regex_match(l_var_def , G_REGEX_PARAM_ROWTYPE) THEN
              sm_logger.info(l_node, 'LOOKING FOR ROWTYPE VARS'); 
              --Looking for ROWTYPE VARS
                 l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_ROWTYPE,1,1,'i',1));
                 l_table_name  := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_ROWTYPE,1,1,'i',5));
          
                 sm_logger.note(l_node, 'l_param_name',l_param_name); 
                 sm_logger.note(l_node, 'l_table_name',l_table_name); 
  
                 --Remember the Record name itself as a var with a type of TABLE_NAME
                 --store_var_list(i_var  _name => l_param_name
                 --              ,i_param_type => l_table_name
                 --              ,io_var_list  => io_var_list );
                 --@TODO check this still works after change to proc used..
                 --@TODO Rowtype is not always a table/view could realate to a cursor.
                 store_var_def(i_param_name => l_param_name
                              ,i_rowtype    => l_table_name
                              ,i_in_var     => l_in_var
                              ,i_out_var    => l_out_var );

 
                 sm_logger.note(l_node, 'io_var_list.count',io_var_list.count);   
       
            
            WHEN regex_match(l_var_def , G_REGEX_PARAM_COLTYPE) THEN
              sm_logger.info(l_node, 'LOOKING FOR TAB COL TYPE VARS'); 
                 l_param_name    := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',1));
                 l_table_name    := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',5));
                 l_column_name   := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_COLTYPE,1,1,'i',7));
            
                 sm_logger.note(l_node, 'l_param_name' ,l_param_name); 
                 sm_logger.note(l_node, 'l_table_name' ,l_table_name); 
                 sm_logger.note(l_node, 'l_column_name',l_column_name);     
            
            --This should find only 1 record
            l_table_owner := table_owner(i_table_name => l_table_name);
            FOR l_column IN 
              (select lower(column_name) column_name
                     ,data_type
               from dba_tab_columns
               where table_name =  l_table_name
               and   column_name = l_column_name 
               and   owner      = l_table_owner ) LOOP
               
                   store_var_def(i_param_name  => l_param_name 
                                ,i_param_type  => l_column.data_type
                                ,i_in_var      => l_in_var
                                ,i_out_var     => l_out_var );
  
            END LOOP; 


             --@TODO will also need to cover database types and object types

            WHEN regex_match(l_var_def , G_REGEX_PARAM_PREDEFINED) THEN
              sm_logger.info(l_node, 'LOOKING FOR ATOMIC VARS'); 
              --LOOKING FOR ATOMIC VARS
                l_param_name := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_PREDEFINED,1,1,'i',1));
                l_param_type := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_PARAM_PREDEFINED,1,1,'i',5));
                sm_logger.note(l_node, 'l_param_name',l_param_name);
                sm_logger.note(l_node, 'l_param_type',l_param_type);
                
                store_var_def(i_param_name  => l_param_name
                             ,i_param_type  => l_param_type
                             ,i_in_var      => l_in_var
                             ,i_out_var     => l_out_var );
 
                go_past(i_search => G_REGEX_PARAM_PREDEFINED
                       ,i_colour => G_COLOUR_GO_PAST);


            WHEN regex_match(l_var_def , G_REGEX_CUSTOM_PLSQL_TYPE_2WD) THEN
              sm_logger.info(l_node, 'LOOKING FOR FOREIGN CUSTOM PLSQL TYPE VARS');

                 l_in_var  := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_NAME_IN_OUT,1,1,'i',3)) LIKE 'IN%';
                 l_out_var := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_NAME_IN_OUT,1,1,'i',4)) LIKE 'OUT%';
                 sm_logger.note(l_node, 'l_in_var',l_in_var);
                 sm_logger.note(l_node, 'l_out_var',l_out_var);
 
                 l_param_name      := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_2WD,1,1,'i',1));
                 l_package_name    := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_2WD,1,1,'i',5));
                 l_type_name       := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_2WD,1,1,'i',7));

                 sm_logger.note(l_node, 'l_param_name'   ,l_param_name);
                 sm_logger.note(l_node, 'l_package_name' ,l_package_name);
                 sm_logger.note(l_node, 'l_type_name'    ,l_type_name);

                 --@TODO Currently assuming a 2WD typename is package.type but could also be user.type
                 --   Need to also search for user.package.type
                 --   May also need to be able to resolve synonyms, and database links.


                --Remember the Record name itself as a var with a type of PACKAGE_NAME.TYPE_NAME
                --store_var_list(i_var  _name => l_param_name
                --              ,i_param_type => l_package_name||'.'||l_type_name
                --              ,io_var_list  => io_var_list );
                 --@TODO check this still works after change to proc used..
                 --@TODO need to store signature
                 store_var_def(i_param_name => l_param_name
                              ,i_param_type => l_package_name||'.'||l_type_name
                              ,i_in_var     => l_in_var
                              ,i_out_var    => l_out_var );
 
                 sm_logger.note(l_node, 'io_var_list.count',io_var_list.count);   
 
 /*
                 --Only attempts to write out atomic vars, unless we start recursion..
                 --Also need to add 1 var def for each valid componant of the record type.
                 l_package_owner := 'PACMAN'; --package_owner(i_table_name => l_table_name);

                 declare
                   l_param_found boolean := FALSE;
                 begin  
                   FOR l_column IN 
                     (select lower(ATTR_NAME) column_name
                            ,DECODE(ATTR_TYPE_NAME,'PL/SQL BOOLEAN','BOOLEAN'
                                                                   ,ATTR_TYPE_NAME)   data_type
                      from pack_record_v
                      where  type_owner   =  l_package_owner    
                      and    type_name    =  l_package_name
                      and    type_subname =  l_type_name  ) LOOP

                     sm_logger.note(l_node, 'l_column.data_type',l_column.data_type);
                      
                      --Restrict to atomic types.
                      IF is_atomic_type(i_type => l_column.data_type) THEN
 
                          l_param_found := TRUE;
                          store_var_def(i_param_name  => l_param_name||'.'||l_column.column_name
                                       ,i_param_type  => l_column.data_type
                                       ,i_in_var      => l_in_var
                                       ,i_out_var     => l_out_var );
                      ELSE
                         sm_logger.note(l_node, 'l_column.data_type',l_column.data_type);   
                         sm_logger.warning(l_node, 'Parameter data type not recognised atomic data type.');   
                      END IF;    
    
                   END LOOP; 
                   
                   if not l_param_found then
                     sm_logger.warning(l_node, 'Parameter NOT stored!');
                   end if;

                 end;
*/
                   
                 go_past(i_search => G_REGEX_CUSTOM_PLSQL_TYPE_2WD
                        ,i_colour => G_COLOUR_GO_PAST);



            WHEN regex_match(l_var_def , G_REGEX_CUSTOM_PLSQL_TYPE_1WD) THEN
              sm_logger.info(l_node, 'LOOKING FOR LOCAL CUSTOM PLSQL TYPE VARS');

              --temp debugging only
              sm_logger.note(l_node, 'l_var_def p1', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',1));
              sm_logger.note(l_node, 'l_var_def p2', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',2));
              sm_logger.note(l_node, 'l_var_def p3', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',3));
              sm_logger.note(l_node, 'l_var_def p4', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',4));
              sm_logger.note(l_node, 'l_var_def p5', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',5));
              sm_logger.note(l_node, 'l_var_def p6', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',6));
              sm_logger.note(l_node, 'l_var_def p7', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',7));
              sm_logger.note(l_node, 'l_var_def p8', REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',8));


                 l_param_name      := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',1));
                 l_param_type    := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',5));
                 --l_type_name       := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_CUSTOM_PLSQL_TYPE_1WD,1,1,'i',7));

                 sm_logger.note(l_node, 'l_param_name' ,l_param_name);
                 --sm_logger.note(l_node, 'l_package_name' ,l_package_name);
                 sm_logger.note(l_node, 'l_param_type',l_param_type);

                 store_var_def(i_param_name => l_param_name
                              ,i_param_type => l_param_type
                              ,i_in_var     => l_in_var
                              ,i_out_var    => l_out_var );


                go_past(i_search => G_REGEX_CUSTOM_PLSQL_TYPE_1WD
                       ,i_colour => G_COLOUR_GO_PAST);
          
               --UNSUPPORTED
               ELSE
                 sm_logger.info(l_node, 'Unsupported datatype');
                go_past(i_search => G_REGEX_CUSTOM_PLSQL_TYPE_2WD
                       ,i_colour => G_COLOUR_UNSUPPORTED);

                 --RAISE x_invalid_keyword;
         
             END CASE; 
          
  
 
       --DEFAULT or :=
    WHEN regex_match(l_keyword , G_REGEX_DEFAULT) THEN 
      sm_logger.comment(l_node, 'Found DEFAULT, searching for complex value');
 
      l_bracket_count := 0;
      loop
        l_bracket := get_next( i_stop       => G_REGEX_OPEN_BRACKET
                                            ||'|'||G_REGEX_CLOSE_BRACKET
                                            ||'|'||G_REGEX_COMMA
                                  ,i_raise_error => TRUE);
 
            sm_logger.note(l_node, 'l_bracket' ,l_bracket); 
            CASE 
        WHEN regex_match(l_bracket , G_REGEX_COMMA) THEN
          EXIT WHEN l_bracket_count = 0;

            WHEN regex_match(l_bracket , G_REGEX_OPEN_BRACKET) THEN
          l_bracket_count := l_bracket_count + 1;

            WHEN regex_match(l_bracket , G_REGEX_CLOSE_BRACKET) THEN
                l_bracket_count := l_bracket_count - 1;
        EXIT WHEN l_bracket_count = -1;

              ELSE 
          sm_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
        RAISE x_invalid_keyword;
        END CASE; 
        go_past(i_colour => G_COLOUR_BRACKETS);
      
      END LOOP; 
 
    --  --NO MORE PARAMS
    WHEN regex_match(l_keyword , G_REGEX_RETURN_IS_AS_DECLARE) THEN
          sm_logger.comment(l_node, 'No more parameters');
          --Needed to find Return to get to end of params, 
          --but now make sure we consume the IS/AS/DECLARE (DECLARE for triggers).
          go_past(i_search => G_REGEX_IS_AS_DECLARE
                 ,i_stop   => G_REGEX_BEGIN
                 ,i_colour => G_COLOUR_GO_PAST);
 
          EXIT;
          
        --OOPS
        ELSE
      sm_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
          RAISE x_invalid_keyword;
      END CASE;
    EXCEPTION
    WHEN x_out_param THEN  
      sm_logger.comment(l_node, 'Skipped OUT param');
    WHEN x_unsupported_data_type THEN
      sm_logger.comment(l_node, 'Unsupported param type');
  END;
 
  END LOOP; 
 
  --Log just the new vars
  log_new_var_list(i_old_var_list => l_var_list_in
                  ,i_new_var_list => io_var_list);
  --Log all params
  log_param_list(i_param_list => io_param_list);
 
exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_params;    

 
 
--------------------------------------------------------------------------------- 
-- PLS_pu_assign    
---------------------------------------------------------------------------------
/** PRIVATE
* Read PLScope for all of the assigned variables in the current program unit or named block 
* @NB There may be hidden issues around the fact that plscope does NOT create a name/ref for an unnamed block
*     But i do process unnamed blocks as a new scoping level WRT to the varlist.
* Trace these back to determine the type
* @param  i_var_list list of scoped variables
* @param  i_pu_stack stack of program units
* @return total list of scoped variables
*/
FUNCTION PLS_pu_assign(i_var_list IN var_list_typ
                      ,i_pu_stack IN pu_stack_typ) RETURN var_list_typ IS
  l_node sm_logger.node_typ := sm_logger.new_func(g_package_name,'PLS_pu_assign'); 


--This query give a qualified list of assigments within a procedure
--does not yet give as a link to the type.
--we still need to know the type of the assigment.
 
  CURSOR cu_plscope_assign(c_parent_signature in varchar2
                          ,c_parent_type      in varchar2 ) is
    select * from (
      SELECT  name
             ,type
             ,signature
             ,usage
             ,ltrim(sys_connect_by_path( decode(level,1,null,name), '.' ), '.' ) scoped_name
             --,sys_connect_by_path(type, '.')  connect_by_type
      FROM all_identifiers 
      START WITH  signature = c_parent_signature 
              and usage = decode(c_parent_type,'LABEL','DECLARATION','DEFINITION') --For Labels - search from DECLARATION
      CONNECT BY PRIOR usage_id    = usage_context_id 
             and prior owner       = owner
             and prior object_name = object_name
             and prior object_type = object_type
             and  usage <> 'DECLARATION'  --Ensure we only find assignments related directly to the parent.
     ORDER SIBLINGS BY line, col
     )
     where usage = 'ASSIGNMENT'
     --THIS FEATURE COMMENTED OUT (FOR NOW)
     --remove variable assignments that are not direct descendents of the pu definition
     --and   REGEXP_COUNT( connect_by_type, 'PACKAGE|PROCEDURE|FUNCTION') = 1
     --Purpose was to stop indirect assigments from being collected.
     --Side effect is that variables qualified with a procedure name were also ignored.
     ;

 

  --for now, lets just assume the lowest level is a NUMBER and enter it as such.



--   CURSOR cu_plscope_assign(c_parent_signature in varchar2) is
--   select  p.name        parent_name
--          ,c.name        child_name
--          ,c.type        child_type
--          ,c.signature   child_signature
--    from   all_identifiers p
--          ,all_identifiers c
--    where p.usage            = 'DEFINITION'
--    and   p.signature        = c_parent_signature
--    and   c.usage_context_id = p.usage_id
--    and   c.owner            = p.owner
--    and   c.object_name      = p.object_name
--    and   c.object_type      = p.object_type
--    and   c.type             = 'VARIABLE'
--    and   c.usage            in ('REFERENCE','ASSIGNMENT');



--SELECT    LPAD (' ', 3 * (LEVEL - 1))
--       || TYPE
--       || ' '
--       || name
--       || ' ('
--       || usage
--       || ') - '||signature
--          identifier_hierarchy,
--          sys_connect_by_path( name, '.' ) full_name
--        ,type
--  FROM plscope_hierarchy
--START WITH 
--    usage = 'DEFINITION' 
--and signature = 
--CONNECT BY PRIOR 
--    usage_id = usage_context_id
--and 
--ORDER SIBLINGS BY line, col

 

--select * from (
--SELECT    LPAD (' ', 3 * (LEVEL - 1))
--       || TYPE
--       || ' '
--       || name
--       || ' ('
--       || usage
--       || ') - '||signature
--          identifier_hierarchy,
--          sys_connect_by_path( name, '.' ) long_name
--        ,type
--        ,usage
--  FROM all_identifiers
--START WITH  signature = '1152CAD74D1ED194261A08B060D55A98' 
--        and usage = 'DEFINITION' 
--CONNECT BY PRIOR usage_id    = usage_context_id 
--       and prior owner       = owner
--       and prior object_name = object_name
--       and prior object_type = object_type
--ORDER SIBLINGS BY line, col
--)
--where usage = 'ASSIGNMENT'
--;


  l_var_list              var_list_typ := i_var_list;
  x_no_stack exception;
BEGIN
  if i_pu_stack.count = 0 then
    raise x_no_stack;
  end if;
  sm_logger.note(l_node, 'i_pu_stack(i_pu_stack.last).name'     ,i_pu_stack(i_pu_stack.last).name);
  sm_logger.note(l_node, 'i_pu_stack(i_pu_stack.last).signature',i_pu_stack(i_pu_stack.last).signature);
  sm_logger.note(l_node, 'i_pu_stack(i_pu_stack.last).type'     ,i_pu_stack(i_pu_stack.last).type);

  --Loop thru each variable assigned within this procedure, or named block.
  FOR l_plscope in cu_plscope_assign(c_parent_signature => i_pu_stack(i_pu_stack.last).signature
                                    ,c_parent_type      => i_pu_stack(i_pu_stack.last).type) LOOP
 
    sm_logger.note(l_node, 'l_plscope.name'            , l_plscope.name);
    sm_logger.note(l_node, 'l_plscope.type'            , l_plscope.type);
    sm_logger.note(l_node, 'l_plscope.signature'       , l_plscope.signature);
    sm_logger.note(l_node, 'l_plscope.scoped_name'     , l_plscope.scoped_name);

    --Add the plscode variable assignment to the var list, 
    --so that later when same variable assignment is found in the source, it can be easilly identified.
    --if l_plscope.type = 'VARIABLE' then
    --  sm_logger.warning(l_node, 'VARIABLE type from PLScope is not supported.  Ignoring this Assignment.');

    --else
     store_var_list(i_var       => create_var_rec(i_param_name  => lower(l_plscope.scoped_name)
                                                 ,i_param_type  => l_plscope.type
                                                 ,i_assign_var  => true
                                                 ,i_signature   => l_plscope.signature
                                                 ,i_pu_stack    => i_pu_stack)
                   ,io_var_list => l_var_list
                   ,i_pu_stack  => i_pu_stack);
    --end if;

    --Loop thru the first segment of each assigned var.
    --@TODO candidate for later refactoring..

    --What we are looking for is a sequence of identifiers that have been used in the source code
    --to identify the variable or one of its componants in an assignment statement.
    --Need to find the whole chain of names down to the final one which will have a usage of ASSIGNMENT
    --Also need to determine which name componant leads to a variable declaration.
    --IE the signature of that name componant will match a variable declaration.
    --This signature can be used to find the type of the variable, and then the declaration of that type.
    --Then need to trace down thru the declaration of the variable type to identify the type and signature of the 
    --corresponding ASSIGNMENT componant (lowest level)

    --Finally will insert into val_list a record that has the concatonated var name
    --EG user.package.procedure.var.col with the type of col eg NUMBER and no signature
    --     user.package.procedure.var   with the type of RECORD rec_typ and its signature.

    --This then allows us to 
    --  Search directly for the identified variable as read from the source.
    --  Immediately find the relevant type or signature from the varlist
    --  Create the Note for PREDEFINED TYPES or 
    --  Keep decomposing the COMPLEX TYPE retrieve TAB from get_type_defn( i_signature )
    --    Use the tab to Create the Note for each column.  
    --    Recursively process as many columns as needed.
 
  
--!! becareful looking up the next level.  MUST include full join information, when looking for a reference line
--CANNOT just use the signature

--    and   p.signature        = c_parent_signature
--    and   c.usage_context_id = p.usage_id
--    and   c.owner            = p.owner
--    and   c.object_name      = p.object_name
--    and   c.object_type      = p.object_type
--
--select name, signature, type, usage_id, count(*), min(usage) min_usage, max(usage) max_usage 
--from all_identifiers
--group by name, signature, type , usage_id
--having count(*) > 1
--
--When looking up the definition by signature_id MUST specify usage='DEFINITION'

--May need to add a feature to discover whether referenced packages were already compiled with plscope.
--If not compile them and then recompile and reweave this package.


  END LOOP;
 

  log_new_var_list(i_old_var_list => i_var_list
                  ,i_new_var_list => l_var_list);

 
  return l_var_list;

EXCEPTION
  WHEN x_no_stack THEN
    sm_logger.fatal(l_node,'Illegal state: There are no program units on the Stack.');
    return l_var_list;
 
END PLS_pu_assign;  


--------------------------------------------------------------------------------- 
-- AOP_var_defs    
---------------------------------------------------------------------------------
/** PRIVATE
* Indentify variables defined in the declaration section of the current block
* Add vars them to the var list. 
* @param  i_var_list list of scoped variables
* @return total list of scoped variables
*/
FUNCTION AOP_var_defs(i_var_list IN var_list_typ
                     ,i_pu_stack IN pu_stack_typ) RETURN var_list_typ IS
  l_node sm_logger.node_typ := sm_logger.new_func(g_package_name,'AOP_var_defs'); 
  
  l_var_list              var_list_typ := i_var_list;
  l_var_def               CLOB;

  G_REGEX_NAME     CONSTANT VARCHAR2(200) := '\s('||G_REGEX_WORD||'?)\s+?';

  G_REGEX_PARAM_PREDEFINED    CONSTANT VARCHAR2(200) := '\s('||G_REGEX_WORD||'?)\s+?'||G_REGEX_ATOMIC_TYPES||'\W';
  G_REGEX_PARAM_ROWTYPE       CONSTANT VARCHAR2(200) := '\s'||G_REGEX_WORD||'?\s+?'||G_REGEX_WORD||'?%ROWTYPE';
  G_REGEX_PARAM_COLTYPE       CONSTANT VARCHAR2(200) := '\s'||G_REGEX_WORD||'?\s+?'||G_REGEX_WORD||'?\.'||G_REGEX_WORD||'?%TYPE';
  
  
  G_REGEX_VAR_NAME_TYPE       CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+('||G_REGEX_WORD||')';
  G_REGEX_REC_VAR_NAME_TYPE   CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+('||G_REGEX_WORD||')%ROWTYPE';
  G_REGEX_TAB_COL_NAME_TYPE   CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+('||G_REGEX_WORD||')\.('||G_REGEX_WORD||')%TYPE';

  G_REGEX_CUSTOM_PLSQL_TYPE_2WD  CONSTANT VARCHAR2(200) := G_REGEX_NAME||'('||G_REGEX_WORD||')\.('||G_REGEX_WORD||')';
  G_REGEX_CUSTOM_PLSQL_TYPE_1WD  CONSTANT VARCHAR2(200) := G_REGEX_NAME||'('||G_REGEX_WORD||')';

  
  l_param_name  VARCHAR2(30);
  l_param_type  VARCHAR2(106);
  l_table_name  VARCHAR2(30);
  l_column_name VARCHAR2(30);
  l_table_owner VARCHAR2(30);
 
BEGIN
  --Search for var_name var_type pairs.
 
  loop
 
  l_var_def := get_next( i_srch_before      => G_REGEX_PARAM_PREDEFINED
                                    ||'|'||G_REGEX_PARAM_ROWTYPE
                                    ||'|'||G_REGEX_PARAM_COLTYPE
                         ,i_stop        => G_REGEX_BEGIN  
                                    ||'|'||G_REGEX_PROG_UNIT
                         ,i_upper      => TRUE
                         ,i_colour      => G_COLOUR_VAR_LINE);
 
  sm_logger.note(l_node, 'l_var_def',l_var_def);
 
    CASE 
    WHEN regex_match(l_var_def , G_REGEX_PARAM_PREDEFINED) THEN
      sm_logger.info(l_node, 'LOOKING FOR ATOMIC VARS'); 
      --LOOKING FOR ATOMIC VARS
        l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_VAR_NAME_TYPE,1,1,'i',1));
        l_param_type  := REGEXP_SUBSTR(l_var_def,G_REGEX_VAR_NAME_TYPE,1,1,'i',3);

        --l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_WORD,1,1,'i'));
        --l_param_type  := REGEXP_SUBSTR(l_var_def,G_REGEX_WORD,1,2,'i');

   
        sm_logger.note(l_node, 'l_param_name',l_param_name); 
        sm_logger.note(l_node, 'l_param_type',l_param_type); 

        store_var_list(i_var       => create_var_rec(i_param_name  => l_param_name
                                                    ,i_param_type  => l_param_type
                                                    ,i_lex_var     => true
                                                    ,i_pu_stack    => i_pu_stack)
                      ,io_var_list => l_var_list
                      ,i_pu_stack  => i_pu_stack);

    
        --IF  regex_match(l_param_type , G_REGEX_ATOMIC_TYPES) THEN
        ----Supported data type so store in the var list.
        --  store_var_list(i_var  _name => l_param_name
        --                ,i_param_type => l_param_type
        --                ,io_var_list  => l_var_list );
        --  sm_logger.note(l_node, 'l_var_list.count',l_var_list.count);     
        --END IF; 
 
    WHEN regex_match(l_var_def , G_REGEX_PARAM_ROWTYPE) THEN
      sm_logger.info(l_node, 'LOOKING FOR ROWTYPE VARS'); 
      --Looking for ROWTYPE VARS
        l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_REC_VAR_NAME_TYPE,1,1,'i',1));
        l_table_name  := REGEXP_SUBSTR(l_var_def,G_REGEX_REC_VAR_NAME_TYPE,1,1,'i',3);
 
        sm_logger.note(l_node, 'l_param_name',l_param_name); 
        sm_logger.note(l_node, 'l_table_name',l_table_name); 
 
        --Remember the Record name itself as a var with a type of TABLE_NAME
        --store_var_list(i_var  _name => l_param_name
        --              ,i_param_type => l_table_name
        --              ,io_var_list  => l_var_list );

        store_var_list(i_var       => create_var_rec(i_param_name  => l_param_name
                                                    ,i_rowtype     => l_table_name
                                                    ,i_lex_var     => true
                                                    ,i_pu_stack    => i_pu_stack)
                     ,io_var_list  => l_var_list
                     ,i_pu_stack   => i_pu_stack);
 
        sm_logger.note(l_node, 'l_var_list.count',l_var_list.count);   
    
    --Also need to add 1 var def for each valid componant of the record type.
    l_table_owner := table_owner(i_table_name => l_table_name);
    FOR l_column IN 
      (select lower(column_name) column_name
             ,data_type
       from dba_tab_columns
       where table_name = l_table_name 
       and   owner      = l_table_owner  ) LOOP

         IF is_atomic_type(i_type => l_column.data_type) THEN
           --store_var_list(i_var  _name => l_param_name||'.'||l_column.column_name
           --              ,i_param_type => l_column.data_type
           --              ,io_var_list  => l_var_list );
           store_var_list(i_var       => create_var_rec(i_param_name  => l_param_name||'.'||l_column.column_name
                                                       ,i_param_type  => l_column.data_type
                                                       ,i_lex_var     => true
                                                       ,i_pu_stack    => i_pu_stack)
                        ,io_var_list  => l_var_list
                        ,i_pu_stack   => i_pu_stack);


           sm_logger.note(l_node, 'l_var_list.count',l_var_list.count);       
         END IF; 
       
    END LOOP;   
    
    WHEN regex_match(l_var_def , G_REGEX_PARAM_COLTYPE) THEN
        sm_logger.info(l_node, 'LOOKING FOR TAB COL TYPE VARS'); 
        l_param_name    := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_NAME_TYPE,1,1,'i',1));
        l_table_name    :=       REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_NAME_TYPE,1,1,'i',3);
        l_column_name   :=       REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_NAME_TYPE,1,1,'i',5);
    
        sm_logger.note(l_node, 'l_param_name' ,l_param_name); 
        sm_logger.note(l_node, 'l_table_name' ,l_table_name); 
        sm_logger.note(l_node, 'l_column_name',l_column_name);    
    
    --Need to add 1 var def for just one componant of the record type.
    l_table_owner := table_owner(i_table_name => l_table_name);
    FOR l_column IN 
      (select lower(column_name) column_name
             ,data_type
       from dba_tab_columns
       where table_name =  l_table_name
       and   column_name = l_column_name 
       and   owner       = l_table_owner  ) LOOP

         IF  is_atomic_type(i_type => l_column.data_type) THEN
       
          --store_var_list(i_var  _name => l_param_name
          --              ,i_param_type => l_column.data_type
          --              ,io_var_list  => l_var_list );

           store_var_list(i_var       => create_var_rec(i_param_name  => l_param_name
                                                       ,i_param_type  => l_column.data_type
                                                       ,i_lex_var     => true
                                                       ,i_pu_stack    => i_pu_stack)
                         ,io_var_list  => l_var_list
                         ,i_pu_stack   => i_pu_stack);

          sm_logger.note(l_node, 'l_var_list.count',l_var_list.count);    

         END IF;    
       
    END LOOP; 
 
      ELSE
      sm_logger.info(l_node,'No more variables.');
    EXIT;

    END CASE;
  
  END LOOP;

  log_new_var_list(i_old_var_list => i_var_list
                  ,i_new_var_list => l_var_list);

  RETURN l_var_list;
 
exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_var_defs;




--------------------------------------------------------------------------------- 
-- labelled_block_extras
---------------------------------------------------------------------------------
/** PRIVATE
* For labelled blocks
*   Called from either declaration or main block, which comes first
*   Add label to pu_stack
*   Find PLScope ASSIGNMENTs and record as vars
* @param  io_var_list list of scoped variables
* @param  io_pu_stack program_unit stack
*/
PROCEDURE labelled_block_extras(io_var_list IN OUT var_list_typ
                               ,io_pu_stack IN OUT pu_stack_typ) IS
  l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'labelled_block_extras'); 

begin  
  --@TODO This cannot remain a global value (g_recent_label)
  --Labelled block. (Not needed for an unnamed block as these assignments are picked up in the parent block.)
  if g_recent_label is not null then
    --There is a recent label, so we'll add it to the pu stack, to help identify variables.
    push_pu(i_name       => g_recent_label
           ,i_type       => 'LABEL' 
           ,io_pu_stack  => io_pu_stack);         
    g_recent_label := null;

    --Read all of the assigned variables from plscope
    --add them into the var list
    io_var_list := PLS_pu_assign( i_var_list => io_var_list
                                 ,i_pu_stack => io_pu_stack);   
  end if;  

end;





    
--------------------------------------------------------------------------------- 
-- AOP_declare_block
---------------------------------------------------------------------------------
/** PRIVATE
* Process a block with a declaration section.
*   Find declared variables
*   Process declared sub program units
*   Process the rest of the block. 
* @param  i_indent   current indent count
* @param  i_var_list list of scoped variables
*/
PROCEDURE AOP_declare_block(i_indent   IN INTEGER
                           ,i_var_list IN var_list_typ
                           ,i_pu_stack IN pu_stack_typ) IS
  l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'AOP_declare_block'); 
  
  l_var_list          var_list_typ := i_var_list;
  l_pu_stack          pu_stack_typ := i_pu_stack;
  
BEGIN

  sm_logger.param(l_node, 'i_indent' ,i_indent); 

  --Called here and in AOP_block 
  labelled_block_extras(io_var_list => l_var_list
                       ,io_pu_stack => l_pu_stack);
 
  --Find the vars defined in this block
  l_var_list := AOP_var_defs( i_var_list => l_var_list
                             ,i_pu_stack => l_pu_stack);    
 

  --Search for nested PROCEDURE and FUNCTION within the declaration section of the block.
  --Pass in the scoped list of vars
  --Drop out when a BEGIN is reached.
  AOP_prog_units(i_indent   => i_indent + g_indent_spaces
                ,i_var_list => l_var_list
                ,i_pu_stack => l_pu_stack);
  
  --Calc indent and consume BEGIN
  --Drop out when the corresponding END is reached.
  AOP_block(i_indent    => calc_indent(i_indent, get_next(i_srch_before => G_REGEX_BEGIN
                                                         ,i_colour      => G_COLOUR_GO_PAST))
           ,i_regex_end => G_REGEX_END_BEGIN
           ,i_var_list  => l_var_list
           ,i_pu_stack => l_pu_stack);
 
exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_declare_block;

  
--------------------------------------------------------------------------------- 
-- AOP_is_as
---------------------------------------------------------------------------------
/** PRIVATE
* Found IS or AS section of current Program Unit 
*   Find the program unit parameters
*   Find declared variables
*   Process declared sub program units
*   Process the program unit block. 
* @param  i_prog_unit_name Name of the Program Unit
* @param  i_indent         Current indent count
* @param  i_node_type      Type of Node
* @param  i_var_list       List of scoped variables
* @param  i_pu_stack
*/
PROCEDURE AOP_is_as(i_prog_unit_name IN VARCHAR2
                   ,i_indent         IN INTEGER
                   ,i_node_type      IN VARCHAR2
                   ,i_var_list       IN var_list_typ
                   ,i_pu_stack       IN pu_stack_typ ) IS
  l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'AOP_is_as'); 
 
  l_keyword               VARCHAR2(50);
  l_inject_node           VARCHAR2(200);  
  l_inject_process        VARCHAR2(200);  
  l_param_list            param_list_typ;
  l_var_list              var_list_typ := i_var_list;
  l_pu_stack              pu_stack_typ := i_pu_stack;
  l_extra_node_params     varchar2(1000);
 
BEGIN
  sm_logger.param(l_node, 'i_prog_unit_name' ,i_prog_unit_name); 
  sm_logger.param(l_node, 'i_indent        ' ,i_indent        ); 
  sm_logger.param(l_node, 'i_node_type     ' ,i_node_type     ); 

  if i_node_type = g_node_type_package  then
 
    push_pu(i_name       => i_prog_unit_name
           ,i_type       => 'PACKAGE BODY' 
           ,io_pu_stack  => l_pu_stack);

  elsif i_node_type = g_node_type_procedure  then
 
    push_pu(i_name       => i_prog_unit_name
           ,i_type       => 'PROCEDURE' 
           ,io_pu_stack  => l_pu_stack);

  elsif i_node_type = g_node_type_function  then
 
    push_pu(i_name       => i_prog_unit_name
           ,i_type       => 'FUNCTION' 
           ,io_pu_stack  => l_pu_stack);

  end if;
 
  --Read all of the assigned variables from plscope
  --add them into the var list
  l_var_list := PLS_pu_assign( i_var_list => l_var_list
                              ,i_pu_stack => l_pu_stack);  


  AOP_pu_params(io_param_list  => l_param_list          
               ,io_var_list    => l_var_list
               ,i_pu_stack     => l_pu_stack);    
 
  --NEW PROCESS
  IF UPPER(i_prog_unit_name) = 'BEFOREPFORM' THEN
    --BEFOREPFORM signifies beginning of report. Create a new process before the node
    l_inject_process :=  'l_session_id INTEGER := sm_logger.new_process('||g_aop_module_name||',''REPORT'',:p_report_run_id);';
    inject( i_new_code  => l_inject_process
           ,i_indent    => i_indent
           ,i_colour    => G_COLOUR_NODE);
  END IF;

 
  --If a logger OnDemand param is included, in THIS node, then pass it to the logger.
  if l_var_list.exists(g_logger_debug_param)                  and
     l_var_list(g_logger_debug_param).level = l_pu_stack.count and
     l_var_list(g_logger_debug_param).in_var                  then
     l_extra_node_params := l_extra_node_params ||',i_debug => '||lower(g_logger_debug_param);

  end if;

  if l_var_list.exists(g_logger_normal_param)                  and
     l_var_list(g_logger_normal_param).level = l_pu_stack.count and
     l_var_list(g_logger_normal_param).in_var                  then
     l_extra_node_params := l_extra_node_params ||',i_normal => '||lower(g_logger_normal_param);

  end if;

  if l_var_list.exists(g_logger_quiet_param)                  and
     l_var_list(g_logger_quiet_param).level = l_pu_stack.count and
     l_var_list(g_logger_quiet_param).in_var                  then
     l_extra_node_params := l_extra_node_params ||',i_quiet => '||lower(g_logger_quiet_param);

  end if;
 
  if l_var_list.exists(g_logger_msg_mode_param)                  and
     l_var_list(g_logger_msg_mode_param).level = l_pu_stack.count and
     l_var_list(g_logger_msg_mode_param).in_var                  then
     l_extra_node_params := l_extra_node_params ||',i_msg_mode => '||lower(g_logger_msg_mode_param);

  end if;
  
  --NEW NODE
  l_inject_node := 'l_node sm_logger.node_typ := sm_logger.'||i_node_type||'('||g_aop_module_name||' ,'''||i_prog_unit_name||''''||l_extra_node_params||');';
  inject( i_new_code  =>  l_inject_node
         ,i_indent     => i_indent
         ,i_colour     => G_COLOUR_NODE);   

 
  l_var_list := AOP_var_defs( i_var_list => l_var_list
                             ,i_pu_stack => l_pu_stack);    
 
  AOP_prog_units(i_indent    => i_indent + g_indent_spaces
                ,i_var_list  => l_var_list
                ,i_pu_stack  => l_pu_stack);
  
  
  --If this is a package there may not be a BEGIN, just an END;
  l_keyword := get_next( i_stop        => G_REGEX_BEGIN||'|'||G_REGEX_END_BEGIN
                        ,i_upper       => TRUE
                        ,i_raise_error => TRUE                              );
 
  IF regex_match(l_keyword , G_REGEX_END_BEGIN) and i_node_type = g_node_type_package THEN
    --Packages don't need to have BEGIN. 
    --Reached the final END.  Highlight it.
    go_past(i_search => G_REGEX_END_BEGIN
           ,i_colour => G_COLOUR_PROG_UNIT);
 
    g_current_pos := NULL; --Just to emphasise we are finished with this pass.

    --No BEGIN, don't need the Initialisation node either, so remove it again.
    --(This will leave the colour there, but that won't be visible.)
    g_code := REPLACE(g_code, l_inject_node, ''); 
 
  ELSE
    
    AOP_pu_block(i_prog_unit_name  => i_prog_unit_name
                ,i_indent          => i_indent
                ,i_param_list      => l_param_list
                ,i_var_list        => l_var_list
                ,i_pu_stack        => l_pu_stack);
    
  END IF;
 
exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_is_as;

--------------------------------------------------------------------------------- 
-- is_record
---------------------------------------------------------------------------------
/** PRIVATE
* Deterine whether last segment of the name originally contained a bracketed term.
* To be used when the data class is 'INDEX TABLE'
* @param  i_original_name  clean version of var name, before bracketed terms were removed.
* @return true when final
* 
*/
FUNCTION is_record(i_original_name in varchar2) return boolean is
BEGIN
  
  return i_original_name like '%)';

END;

--------------------------------------------------------------------------------- 
-- quoted_var_name
---------------------------------------------------------------------------------
/** PRIVATE
* If var name contains a string placeholder or any single quotes then wrap the var in special quotes
* Otherwise wrap it in normal single quotes.
* @param  i_var_name  variable identifier
* @return i_var_name wrapped in quotes or special quotes.
* 
*/
  function quoted_var_name(i_var_name in varchar2) return varchar2 is
  BEGIN
    if i_var_name like '%{{%}}%' OR --like '%{{string:%}}%' OR  ?? why was this originally just string?
       i_var_name like '%''%'              then
      --var name contains a string constant
      --so need to wrap the var in special quotes
      -- "q'[" and "]'"
      return 'q''['||i_var_name||']''';
    else
      --otherwise just use the simple version
      -- "'" and "'"
      return ''''||i_var_name||'''';
    end if;
  END; 


--------------------------------------------------------------------------------- 
-- AOP_block
---------------------------------------------------------------------------------
/** PRIVATE
* Process any kind of block - currently kinds accommodated.
*   BEGIN - END
*   LOOP  - END LOOP
*   CASE  - END CASE
*   IF    - END IF  (Includes ELSIF and ELSE)
* @param  i_indent    Current indent count
* @param  i_regex_end End of the block must match this regex.
* @param  i_var_list  List of scoped variables
*/
PROCEDURE AOP_block(i_indent         IN INTEGER
                   ,i_regex_end      IN VARCHAR2
                   ,i_var_list       IN var_list_typ
                   ,i_pu_stack       IN pu_stack_typ  )  IS
  l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'AOP_block');

  l_pu_stack              pu_stack_typ := i_pu_stack;
  
  l_keyword               CLOB;
  l_stashed_comment       VARCHAR2(50);
  l_function              VARCHAR2(30);
 
  l_var_list              var_list_typ := i_var_list;

  l_table_owner           VARCHAR2(30);
  l_table_name            VARCHAR2(30);


  l_into_var_list         var_list_typ;
  l_index                 binary_integer;
  l_var                   VARCHAR2(1000);
  l_var_name              VARCHAR2(1000);

  l_exception_section     BOOLEAN :=FALSE;

  G_REGEX_VAR_ASSIGN          CONSTANT VARCHAR2(50) :=  '\s*?:=';

  --Capture term prior to the assignment, but the term must be on one line
  --G_REGEX_ASSIGNMENT          CONSTANT VARCHAR2(50) :=   '.*\s*:='; 
  --G_REGEX_ASSIGNMENT          CONSTANT VARCHAR2(50) :=   '(.|\s)*:='; --Capture everything prior to the assignment
  --G_REGEX_ASSIGNMENT          CONSTANT VARCHAR2(50) :=   '(.|\s)*:='; --Capture everything prior to the assignment

  --Capture everything prior to the assignment, including newlines, but excluding ;
  --G_REGEX_ASSIGNMENT          CONSTANT VARCHAR2(50) :=   '[^;\n]*:=';  
 
  --Capture term prior to the assignment, but the term must be on one line.
  --Allows for comments on lines between term and :=
  --G_REGEX_ASSIGNMENT          CONSTANT VARCHAR2(50) :=   '.*(\s*{{comment:\w*}})*\s*:='; 

   G_REGEX_ASSIGNMENT          CONSTANT VARCHAR2(50) :=   ':=';  
 
  G_REGEX_ASSIGN_TO_ANY_WORDS   CONSTANT VARCHAR2(50) :=  G_REGEX_ANY_WORDS||G_REGEX_VAR_ASSIGN;
  
  --G_REGEX_ASSIGN_COMPLEX_TYPE   CONSTANT VARCHAR2(50) :=  '(THEN|>>|;|BEGIN|ELSE)+[\s\w().]*:='; --supports arrays
 
  G_REGEX_ASSIGN_TO_REC_COL   CONSTANT VARCHAR2(50) :=  G_REGEX_2WORDS     ||'\s*?:=';

  --matches on both G_REGEX_ASSIGN_TO_BIND_VAR andG_REGEX_ASSIGN_TO_ANY_WORDS
  G_REGEX_ASSIGN_TO_VARS      CONSTANT VARCHAR2(50) :=  ':*?'||G_REGEX_ASSIGN_TO_ANY_WORDS;
 -- G_REGEX_ASSIGN_TO_VARS      CONSTANT VARCHAR2(50) :=  ':*?'||G_REGEX_ASSIGN_TO_ANY_WORDS||'?\s*?:=';

  G_REGEX_ASSIGN_TO_VAR       CONSTANT VARCHAR2(50) :=  G_REGEX_WORD       ||'\s*?:=';  
  G_REGEX_ASSIGN_TO_BIND_VAR  CONSTANT VARCHAR2(50) :=  ':'||G_REGEX_WORD  ||'\s*?:=';
  
  G_REGEX_VAR                 CONSTANT VARCHAR2(50) := G_REGEX_WORD;
  G_REGEX_REC_COL             CONSTANT VARCHAR2(50) := G_REGEX_WORD||'.'||G_REGEX_WORD;
  G_REGEX_BIND_VAR            CONSTANT VARCHAR2(50) := ':'||G_REGEX_WORD;

  G_REGEX_SHOW_ME             CONSTANT VARCHAR2(50) :=    '--(\@\@)';
  G_REGEX_SHOW_ME_LINE        CONSTANT VARCHAR2(50) :=  '.+--(\@\@)';
  G_REGEX_ROW_COUNT_LINE      CONSTANT VARCHAR2(50) :=  '.+--(RC)';
 
 
  G_REGEX_DELETE_FROM         CONSTANT VARCHAR2(50) := '\sDELETE\s+?FROM\s';
  G_REGEX_DELETE              CONSTANT VARCHAR2(50) := '\sDELETE\s'        ;
  G_REGEX_INSERT_INTO         CONSTANT VARCHAR2(50) := '\sINSERT\s+?INTO\s';
  G_REGEX_UPDATE              CONSTANT VARCHAR2(50) := '\sUPDATE\s';

  G_REGEX_FROM                CONSTANT VARCHAR2(50) := '\sFROM\s';
 
  
  --G_REGEX_BULK_FETCH_INTO     CONSTANT VARCHAR2(50) := '\s(FETCH)\s+?(\s|\S)+?\s+?BULK\s+COLLECT\s+INTO\s';
  G_REGEX_BULK_FETCH_INTO     CONSTANT VARCHAR2(50) := '\sFETCH\s.*?BULK\s+COLLECT\s+INTO\s'; --TEMP FIX ONE LINE ONLY
  --G_REGEX_SELECT_FETCH_INTO   CONSTANT VARCHAR2(50) := '\s(SELECT|FETCH)\s+?(\s|\S)+?\s+?INTO\s';
  G_REGEX_SELECT_FETCH_INTO   CONSTANT VARCHAR2(50) := '\s(SELECT|FETCH)\s.*?INTO\s'; --TEMP FIX ONE LINE ONLY

  --G_REGEX_INTO_VARS          CONSTANT VARCHAR2(50) :=   '.*(\s*{{comment:\w*}})*\s*(;|\sFROM\s)'; 
  G_REGEX_INTO_VARS          CONSTANT VARCHAR2(50) :=  '(.|\s)*(;|\sFROM\s)'; --mulitple lines
  G_REGEX_END_SELECT_FETCH_INTO   CONSTANT VARCHAR2(50) :=  G_REGEX_SEMI_COL
                                                     ||'|'||G_REGEX_FROM;  

  G_REGEX_DML                 CONSTANT VARCHAR2(200) :=   G_REGEX_DELETE_FROM 
                                                  ||'|'|| G_REGEX_DELETE
                                                  ||'|'|| G_REGEX_INSERT_INTO
                                                  ||'|'|| G_REGEX_UPDATE;

  G_REGEX_LABEL               CONSTANT VARCHAR2(50) := '(<<)('||G_REGEX_WORD||')(>>)';

  G_REGEX_EOL                 CONSTANT VARCHAR2(50) := '.*';  --End of line, any chars to EOL.

 
  FUNCTION find_var(i_search in varchar2) RETURN VARCHAR2 IS   
    -- Note a variable (type not important)   
    l_result varchar2(100);
  BEGIN
        go_upto; 
        l_result := get_next ( i_srch_before      => i_search
                              ,i_lower       => TRUE
                              ,i_colour      => G_COLOUR_VAR);      
        go_past(G_REGEX_SEMI_COL); 

        RETURN l_result;
  END;
 

  PROCEDURE note_var(i_var  in varchar2
                    ,i_type in varchar2) IS   
    l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'note_var');
    -- Note a variable 
  BEGIN
    sm_logger.param(l_node,'i_var' ,i_var);
    sm_logger.param(l_node,'i_type',i_type);
      
    IF i_type = 'CLOB' THEN
      inject( i_new_code   => 'sm_logger.note_clob(l_node,'||quoted_var_name(i_var)||','||i_var||');'
             ,i_indent     => i_indent
             ,i_colour     => G_COLOUR_NOTE);
    ELSE
      inject( i_new_code   => 'sm_logger.note(l_node,'||quoted_var_name(i_var)||','||i_var||');'
             ,i_indent     => i_indent
             ,i_colour     => G_COLOUR_NOTE);
    END IF;

  END;


 
  PROCEDURE note_complex_var(i_var_name   in varchar2
                            ,i_var        in varchar2
                            ,i_componant  in varchar2 default null) IS
    -- find assignment of non-bind variable and inject a note
    l_node      sm_logger.node_typ := sm_logger.new_proc(g_package_name,'note_complex_var');
    l_var       varchar2(1000) := upper(i_var);
    

      procedure note_record(i_name_prefix in varchar2
                           ,i_signature   in varchar2) is
      l_node      sm_logger.node_typ := sm_logger.new_proc(g_package_name,'note_record');
      --This procedure is modular, but currently only called by note_complex_var

       --Find columns for this signature.
 
         l_type_defn_tab identifier_tab;
         l_index         binary_integer;
         l_col_name      varchar2(1000);
       BEGIN
         l_type_defn_tab := get_type_defn(i_signature => i_signature);
         l_index := l_type_defn_tab.FIRST;
         WHILE l_index is not null loop

           sm_logger.note(l_node,'l_type_defn_tab(l_index).col_name',l_type_defn_tab(l_index).col_name);
           sm_logger.note(l_node,'l_type_defn_tab(l_index).data_type',l_type_defn_tab(l_index).data_type);
           sm_logger.note(l_node,'l_type_defn_tab(l_index).data_class',l_type_defn_tab(l_index).data_class);
   
           if l_type_defn_tab(l_index).col_name is null THEN 
              sm_logger.comment(l_node,'No col_name - Record is just a single unnamed column');
              note_var(i_var  => i_name_prefix
                      ,i_type => l_type_defn_tab(l_index).data_type);

           elsif is_atomic_type(i_type => l_type_defn_tab(l_index).col_name) THEN
              sm_logger.comment(l_node,'Type in col_name - Record is just a single unnamed column');
              note_var(i_var  => i_name_prefix
                      ,i_type => l_type_defn_tab(l_index).col_name);
           else   

             l_col_name := lower(i_name_prefix||'.'||l_type_defn_tab(l_index).col_name);
             IF  is_atomic_type(i_type => l_type_defn_tab(l_index).data_type) THEN 
                sm_logger.comment(l_node,'Record.Column is an atomic type');
                note_var(i_var  => l_col_name
                        ,i_type => l_type_defn_tab(l_index).data_type);
             ELSIF   l_type_defn_tab(l_index).data_class = 'RECORD' then
                 sm_logger.comment(l_node,'Record.Column is another record, recursively search lower record.');
                 note_record(i_name_prefix => l_col_name
                            ,i_signature   => l_type_defn_tab(l_index).signature);
             ELSE
                 sm_logger.fatal(l_node,'Record.Column is unrecognised type');    
             END IF;    
           END IF;

           l_index := l_type_defn_tab.NEXT(l_index);
         END LOOP;
       END;


  BEGIN --note_complex_var 
    sm_logger.param(l_node,'i_var_name' ,i_var_name);
    sm_logger.param(l_node,'i_var'      ,i_var);
    sm_logger.param(l_node,'i_componant',i_componant);
    sm_logger.note(l_node ,'l_var'      ,l_var);
    IF l_var_list.EXISTS(l_var) THEN
      --This variable exists in the list of scoped variables with compatible types    
      sm_logger.comment(l_node, 'Scoped Var Found');
      sm_logger.note(l_node,'l_var_list(l_var).name',l_var_list(l_var).name);
      sm_logger.note(l_node,'l_var_list(l_var).type',l_var_list(l_var).type);
      sm_logger.note(l_node,'l_var_list(l_var).data_class',l_var_list(l_var).data_class);

      IF is_atomic_type(i_type => l_var_list(l_var).type)   THEN
        --Data type is supported.
        sm_logger.comment(l_node, 'Data type is supported');
        --So we can write a note for it.
        note_var(i_var  => i_var_name --l_var_list(l_var).name  
                ,i_type => l_var_list(l_var).type);


      ELSIF  identifier_exists(i_signature => l_var_list(l_var).signature) THEN
        sm_logger.comment(l_node, 'Signature is known');

        if l_var_list(l_var).data_class = 'RECORD' then
          sm_logger.comment(l_node, 'Record class detected from PLScope');
          note_record(i_name_prefix  => lower(i_var_name)
                     ,i_signature    => l_var_list(l_var).signature);

        elsif l_var_list(l_var).data_class in ( 'INDEX TABLE','ASSOCIATIVE ARRAY' ) then
          sm_logger.comment(l_node, 'Index Table / Assoc Array class detected from PLScope');
            
          --Need to determine where at index is associated with this table
          --Compare the original fullname i_var_name with the bracket-free i_var
          --If NO index was associated with this table then DO NOT create a note
          if is_record(i_original_name => i_var_name) then
            note_record(i_name_prefix  => lower(i_var_name)
                       ,i_signature    => l_var_list(l_var).signature);
          else
            --This is a table not a record.
            sm_logger.warning(l_node, 'Ignoring assignment to an entire table.');
          end if;  
        else
          sm_logger.fatal(l_node, 'Data class is unexpected.');
        end if;  
        
        
        ----Find columns for this signature.
        --DECLARE
        --  l_type_defn_tab identifier_tab;
        --  l_index binary_integer;
        --BEGIN
        --  l_type_defn_tab := get_type_defn(i_signature => l_var_list(l_var).signature);
        --  l_index := l_type_defn_tab.FIRST;
        --  WHILE l_index is not null loop
        --    
        --    IF  regex_match(l_type_defn_tab(l_index).data_type , G_REGEX_ATOMIC_TYPES) THEN 
        --      --@TODO This needs to be able to recursively search lower levels.
        --       note_var(i_var  => lower(i_var||'.'||l_type_defn_tab(l_index).col_name)
        --               ,i_type => l_type_defn_tab(l_index).data_type);
        --    END IF;
--
        --    l_index := l_type_defn_tab.NEXT(l_index);
        --  END LOOP;
        --END;
  
      ELSIF l_var_list(l_var).type = 'ROWTYPE' then

        sm_logger.comment(l_node, 'RowType should be a TABLE_NAME');
        sm_logger.note(l_node,'l_var_list(l_var).type',l_var_list(l_var).type);
        sm_logger.note(l_node,'l_var_list(l_var).rowtype',l_var_list(l_var).rowtype);
        --Data type is unsupported so it is the name of a table instead.
        --Now write a note for each supported column.
        --
        --Also need to add 1 var def for each valid componant of the record type.
        l_table_owner := table_owner(i_table_name => l_var_list(l_var).rowtype);
        FOR l_column IN 
          (select lower(column_name) column_name
                 ,data_type
           from dba_tab_columns
           where table_name = l_var_list(l_var).rowtype 
           and   owner      = l_table_owner  ) LOOP

           IF  l_column.column_name like lower(i_componant)||'%' and -- only show componants that match the search.
              --This is NOT a perfect solution if original search was for TABLE.COL.X (if that is even possible)
               is_atomic_type(i_type => l_column.data_type) THEN
             note_var(i_var  => lower(i_var)||'.'||l_column.column_name --Use the original case
                      --i_var    => i_var_name||'.'||l_column.column_name --Use the original case
                     ,i_type => l_column.data_type);
           END IF;

        END LOOP;  

      ELSE  
        sm_logger.fatal(l_node, 'Data type is unsupported, but it was in the list of scoped vars.');
 
      END IF;

    ELSE 
 
      if l_var like '%.%' then
        sm_logger.comment(l_node, 'Let us remove the last componant and try again');
        declare
          l_componant varchar2(1000);
          l_new_var   varchar2(1000);
        begin
           l_componant  := REGEXP_SUBSTR(l_var,G_REGEX_WORD||'$',1,1,'i');
           sm_logger.note(l_node,'l_componant',l_componant);
           l_new_var    := REGEXP_REPLACE(l_var,'.'||G_REGEX_WORD||'$',''); --remove the last word
           sm_logger.note(l_node,'l_new_var',l_new_var);
           if length(l_new_var) < length(l_var) then
             note_complex_var(i_var_name  => i_var_name
                             ,i_var       => l_new_var
                             ,i_componant => RTRIM(l_componant||'.'||i_componant ,'.'));
           else 
             sm_logger.fatal(l_node, 'Unable to remove last componant.');
           end if;
        end;
      else
        sm_logger.warning(l_node, 'Var not known '||i_var||'.'||i_componant); --RTRIM(i_var||'.'||i_componant,'.');
        log_var_list(i_var_list => l_var_list);
      end if;

    END IF;
  END;

  PROCEDURE note_rec_col_var(i_var  in varchar2) IS
  -- find assignment of rec.column variable and inject a note
    l_var varchar2(200) := upper(i_var);
  BEGIN
 
    IF l_var_list.EXISTS(l_var) THEN
      --Tab Column rec variable exists 
      note_var(i_var  => l_var_list(l_var).name
              ,i_type => l_var_list(l_var).type);
       
   ELSE 
      sm_logger.warning(l_node, 'Var not known');
      log_var_list(i_var_list => l_var_list);
 
   END IF;
  END;

 

 
BEGIN --AOP_block

  sm_logger.param(l_node, 'i_indent    '      ,i_indent     );
  sm_logger.param(l_node, 'i_regex_end '     ,i_regex_end  );

  --Called here and in AOP_declare_block
  labelled_block_extras(io_var_list => l_var_list
                       ,io_pu_stack => l_pu_stack);
 
  loop
 
    --The first match attempts to get the next keyword.  It includes a range of general search terms.
    --From this we get the keywords, but will use the another search of the keywords to determine what we have found.
 
  l_keyword := get_next(  i_srch_before  =>   G_REGEX_OPEN
                                       ||'|'||G_REGEX_NEUTRAL
                                       ||'|'||G_REGEX_CLOSE
                                       ||'|'||G_REGEX_LABEL
                                       ||'|'||G_REGEX_SEMI_COL

                          ,i_srch_after       => G_REGEX_WHEN_EXCEPT_THEN --(also matches for G_REGEX_WHEN_OTHERS_THEN)
                                       --||'|'||G_REGEX_ROW_COUNT_LINE
                                       --||'|'||G_REGEX_DML               
                                       ||'|'||G_REGEX_SELECT_FETCH_INTO          
                          ,i_stop          => G_REGEX_START_ANNOTATION --don't colour it
                                       ||'|'||G_REGEX_SHOW_ME_LINE 
                                       --||'|'||G_REGEX_ASSIGN_TO_REC_COL
                                       --||'|'||G_REGEX_ASSIGN_TO_ANY_WORDS
                                       ||'|'||G_REGEX_ASSIGNMENT
                                       
                          ,i_upper        => TRUE
                          ,i_colour       => G_COLOUR_BLOCK
                          ,i_raise_error  => TRUE
);
 
  sm_logger.note(l_node, 'l_keyword',l_keyword);
  --Now process the key words that have already been identified.
    CASE 
      --BLOCK CLOSING REGEX
      --Check for the CLOSEs first, since they are more selective than the OPENs

      --END_BEGIN will also match END_LOOP, END_CASE and END IF
      --So we need to make sure it hasn't matched on them.      
      WHEN i_regex_end = G_REGEX_END_BEGIN               AND
             regex_match(l_keyword , i_regex_end)        AND 
             (  regex_match(l_keyword ,G_REGEX_END_LOOP) OR
                regex_match(l_keyword ,G_REGEX_END_CASE) OR 
                regex_match(l_keyword ,G_REGEX_END_IF)) THEN
        sm_logger.fatal(l_node, 'Mis-matched Expected END; Got '||l_keyword);
        RAISE X_INVALID_KEYWORD;
 
      WHEN regex_match(l_keyword ,i_regex_end) THEN
         sm_logger.info(l_node, 'Block End Found!');
         EXIT;
          
      WHEN regex_match(l_keyword ,G_REGEX_CLOSE) THEN
        sm_logger.fatal(l_node, 'Mis-matched END Expecting :'||i_regex_end||' Got: '||l_keyword);
        RAISE X_INVALID_KEYWORD;

      --BLOCK OPENING REGEX
      WHEN regex_match(l_keyword , G_REGEX_DECLARE) THEN     
          sm_logger.info(l_node, 'Declare');    
        AOP_declare_block(i_indent    => calc_indent(i_indent + g_indent_spaces,l_keyword)
                         ,i_var_list  => l_var_list
                         ,i_pu_stack  => l_pu_stack);    
        
      WHEN regex_match(l_keyword , G_REGEX_BEGIN) THEN    
        sm_logger.info(l_node, 'Begin');      
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword)
                 ,i_regex_end  => G_REGEX_END_BEGIN
                 ,i_var_list   => l_var_list
                 ,i_pu_stack   => l_pu_stack);     
                 
      WHEN regex_match(l_keyword , G_REGEX_LOOP) THEN   
        sm_logger.info(l_node, 'Loop'); 
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword)
                 ,i_regex_end  => G_REGEX_END_LOOP
                 ,i_var_list   => l_var_list
                 ,i_pu_stack   => l_pu_stack );                                
             
      WHEN regex_match(l_keyword , G_REGEX_CASE) THEN   
        sm_logger.info(l_node, 'Case'); 
    --inc level +2 due to implied WHEN or ELSE
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword) +  g_indent_spaces
                 ,i_regex_end  => G_REGEX_END_CASE||'|'||G_REGEX_END_CASE_EXPR
                 ,i_var_list   => l_var_list
                 ,i_pu_stack   => l_pu_stack );      
   
      WHEN regex_match(l_keyword , G_REGEX_IF) THEN    
        sm_logger.info(l_node, 'If'); 
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword)
                 ,i_regex_end  => G_REGEX_END_IF
                 ,i_var_list   => l_var_list
                 ,i_pu_stack   => l_pu_stack );

      --BLOCK NEUTRAL - no further nesting/indenting
      WHEN regex_match(l_keyword , G_REGEX_EXCEPTION) THEN
        sm_logger.info(l_node, 'Exception Section');  
        --Now safe to look for WHEN X THEN
        l_exception_section := TRUE;
 
      WHEN regex_match(l_keyword , G_REGEX_NEUTRAL) THEN
        sm_logger.info(l_node, 'Neutral');  
        --Just let it keep going around the loop.
        NULL;
 
      WHEN regex_match(l_keyword ,G_REGEX_START_ANNOTATION) THEN
        --What sort of annotation is it?
         CASE 
           WHEN regex_match(l_keyword ,G_REGEX_COMMENT) THEN l_function := 'comment';
           WHEN regex_match(l_keyword ,G_REGEX_INFO   ) THEN l_function := 'info';
           WHEN regex_match(l_keyword ,G_REGEX_WARNING) THEN l_function := 'warning';
           WHEN regex_match(l_keyword ,G_REGEX_FATAL  ) THEN l_function := 'fatal';
           WHEN regex_match(l_keyword ,G_REGEX_NOTE  )  THEN l_function := 'note';
     
         END CASE;
         
         sm_logger.note(l_node, 'l_function',l_function);
       
         --Find the placeholder for the stashed comment.
         go_past; --Now go past (just can't afford it to be coloured)
         l_stashed_comment := get_next( i_stop        => G_REGEX_STASHED_COMMENT
                                       ,i_raise_error => TRUE);
         sm_logger.note(l_node, 'l_stashed_comment',l_stashed_comment);
 
         if l_function = 'note' then
           g_code := REPLACE(g_code
                           , l_keyword||l_stashed_comment
                           , f_colour(i_text   => 'sm_logger.'||l_function||'(l_node,'||quoted_var_name(l_stashed_comment)||','||l_stashed_comment||');'
                                    , i_colour => G_COLOUR_NOTE) );
         else 
  
           g_code := REPLACE(g_code
                           , l_keyword||l_stashed_comment
                           , f_colour(i_text   => 'sm_logger.'||l_function||'(l_node,'||quoted_var_name(l_stashed_comment)||');'
                                    , i_colour => G_COLOUR_NOTE) );
         end if;
         go_past(i_search => G_REGEX_EOL --advance to after the new logger message EOL
                ,i_colour => null);      --no colour
 
      WHEN regex_match(l_keyword ,G_REGEX_SHOW_ME_LINE) THEN
        sm_logger.info(l_node, 'Show Me');
 
        --expose this line of code as a comment 
        inject( i_new_code => 'sm_logger.comment(l_node,'||quoted_var_name(SUBSTR(lower(l_keyword),1,instr(l_keyword,'--@@')-1))||');'
               ,i_indent   => i_indent
               ,i_colour   => G_COLOUR_COMMENT);
 
      WHEN regex_match(l_keyword ,G_REGEX_LABEL) THEN
        sm_logger.info(l_node, 'Label');
 
        g_recent_label := REGEXP_SUBSTR(l_keyword,G_REGEX_LABEL,1,1,'i',2);
        sm_logger.note(l_node, 'g_recent_label',g_recent_label);

 
 
     -- WHEN regex_match(l_keyword ,G_REGEX_ROW_COUNT_LINE) THEN
     -- sm_logger.info(l_node, 'Rowcount');
     -- --expose this line of code as a note with rowcount 
     --   inject( i_new_code => 'sm_logger.note_rowcount(l_node,'''
     --                   ||SUBSTR(l_keyword,1,LENGTH(l_keyword)-4)  
     --         ||''');'
     --          ,i_indent   => i_indent
     --          ,i_colour   => G_COLOUR_NOTE);

 
      WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_BIND_VAR) THEN  
        sm_logger.info(l_node, 'Assign Bind Var');

        l_var := find_var(i_search => G_REGEX_BIND_VAR);
        note_var(i_var  => l_var
                ,i_type => NULL);

      --WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_VARS) THEN  
        --Need to clean the l_keyword
        --sm_logger.note(l_node, 'l_keyword',l_keyword);
        
       -- sm_logger.info(l_node, 'Assign Complex words');
       --   l_var := find_var(i_search => G_REGEX_ASSIGN_TO_VARS);
          
      --  --Clean the string
      --  l_var := REGEXP_REPLACE(l_var,'{{\w*:\w*}}',''); --Remove {{comment:1}} entirely
      --  sm_logger.note(l_node, 'l_var',l_var);
--
      --  --strip all whitespace
      --  l_var := shrink(i_words => l_var);
      --  sm_logger.note(l_node, 'l_var',l_var);
--
--
      --  l_var_no_brackets := l_var;
      --  --while l_var_no_brackets like '%(%)%' LOOP --THOUGHT THIS CAUSED infinit loop but no, thats not it.
      --    l_var_no_brackets := REGEXP_REPLACE(l_var_no_brackets,G_REGEX_BRACKETED_TERM,'');
      --    sm_logger.note(l_node, 'l_var_no_brackets',l_var_no_brackets);
      --  --end loop;
--
      --  --then note what is left
      --   --note_complex_var(i_var => l_var_no_brackets);
 
      WHEN regex_match(l_keyword ,G_REGEX_ASSIGNMENT) THEN  
        sm_logger.info(l_node, 'General Assignment');
  


        --using G_REGEX_ASSIGNMENT to highlight the original text
        --l_var := find_var(i_search => G_REGEX_ASSIGNMENT);
 
        l_var := grab_upto(i_stop   => G_REGEX_ASSIGNMENT
                          ,i_colour => G_COLOUR_VAR
                          ,i_lower  => TRUE);
        go_past(G_REGEX_SEMI_COL); 


        sm_logger.note(l_node, 'l_var',l_var);

        ----remove trailing :=
        --l_var := REGEXP_REPLACE(l_var,':=$',''); 
        --sm_logger.note(l_node, 'l_var',l_var);

        --strip all whitespace
        l_var := shrink(i_words => l_var);
        sm_logger.note(l_node, 'l_var',l_var);

        --remove any comment tags, but keep string tags
        l_var := REGEXP_REPLACE(l_var,'{{comment:\w*}}',''); --Remove {{comment:1}} entirely
        sm_logger.note(l_node, 'l_var',l_var);

        --Remember l_var_name, then remove all bracketed subterms from l_var
        l_var_name := l_var;
        declare
          l_prev varchar2(100) := l_var;
        begin
          while l_var like '%(%)%' LOOP
            --contains bracketed term that needs to be removed.
            l_var := REGEXP_REPLACE(l_var,G_REGEX_BRACKETED_TERM,''); --remove any set of brackets containing non-brackets
            sm_logger.note(l_node, 'l_var',l_var);
            if l_var = l_prev then
              sm_logger.fatal(l_node, 'Unable to remove bracketed term.');
              exit;
            end if;
            l_prev := l_var;
          end loop;
        end;
  
        --note the complex var with both var full name and var index name
        note_complex_var(i_var_name   => l_var_name
                        ,i_var        => l_var);

/*
        --G_REGEX_ASSIGN_COMPLEX_TYPE   CONSTANT VARCHAR2(50) :=  '(THEN|>>|;|BEGIN|ELSE)+([\s\w().]*)(:=)'; --supports arrays

        l_var := find_var(i_search => G_REGEX_ASSIGN_COMPLEX_TYPE);
        sm_logger.note(l_node, 'l_var',l_var);
        l_var := REGEXP_REPLACE(l_var,G_REGEX_ASSIGN_COMPLEX_TYPE,'/3') ;
        sm_logger.note(l_node, 'l_var',l_var);

        --remove the leading operator - (THEN|>>|;|BEGIN|ELSE)
        --select REGEXP_REPLACE('BEGIN ; tab(x(1.2.3)).col {{comment:12}}X ','(THEN|>>|;|BEGIN|ELSE)','',1,1) from dual
        --Or could use the leading operator ^
        --REGEXP_REPLACE(' BEGIN ; tab(x(1.2.3)).col {{comment:12}}X ','^(THEN|>>|;|BEGIN|ELSE)','') 

        --Clean the string
        l_var := REGEXP_REPLACE(l_var,'{{\w*:\w*}}','') --Remove {{comment:1}} entirely
        sm_logger.note(l_node, 'l_var',l_var);

        --strip all whitespace
        l_var := shrink(i_words => l_var);
        sm_logger.note(l_node, 'l_var',l_var);

        l_var_no_brackets := l_var;
        while l_var_no_brackets like '%(%)%' LOOP
          l_var_no_brackets := REGEXP_REPLACE(l_var_no_brackets,G_REGEX_BRACKETED_TERM,'');
          sm_logger.note(l_node, 'l_var',l_var);
        end loop;



 
          --Remove ()   but keep for later
          --@TODO - new version of find_var - can match on G_REGEX_ANY_WORDS but store orgin name too. (or perhaps write that on return)
          --        and note_complex_var


        
          sm_logger.info(l_node, 'Assign Any number of words');
          l_var := find_var(i_search => G_REGEX_ANY_WORDS);
          note_complex_var(i_var => l_var);
         */

      --WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_ANY_WORDS) THEN  
      --  sm_logger.info(l_node, 'Assign Any number of words');
      --  l_var := find_var(i_search => G_REGEX_ANY_WORDS);
      --  note_complex_var(i_var => l_var);
 
      --WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_REC_COL) THEN   
      --  sm_logger.info(l_node, 'Assign Record.Column');

      --  l_var := find_var(i_search => G_REGEX_REC_COL);
      --  note_rec_col_var(i_var => l_var);

      --PAB No longer needed - covered by the general case G_REGEX_ANY_WORDS
      --WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_VAR) THEN  
      --  sm_logger.info(l_node, 'Assign Var');  
      --
      --  l_var := find_var(i_search => G_REGEX_VAR);
      --  note_complex_var(i_var => l_var);

      WHEN regex_match(l_keyword ,G_REGEX_BULK_FETCH_INTO  ) THEN   
        sm_logger.info(l_node, 'Fetch Bulk Collect Into');
        --This fetches into a tab, which the weaver cannot support, so skip to semi-colon;
        go_past(G_REGEX_SEMI_COL); 

     

 
      WHEN regex_match(l_keyword ,G_REGEX_SELECT_FETCH_INTO  ) THEN   
        sm_logger.info(l_node, 'Select/Fetch Into');

        --@REWRITE Needed
        --Must grab everything upto the ; or FROM.
        --Then dissect it removing whitespace and bracketed terms. (but must be able to put bracketed terms back.)
        --Need to then separate into distinct variables by breaking based on semi-colons.
        declare
          --l_into_vars varchar2(1000);
          --l_dummy      varchar2(10);
          g_term_stack clob_stack_typ;
        begin

          l_var := grab_upto(i_stop   => G_REGEX_END_SELECT_FETCH_INTO 
                            ,i_colour => G_COLOUR_INTO_VARS);
 
          sm_logger.note(l_node, 'l_var',l_var);

          --removing whitespace and bracketed terms
            
          --strip all whitespace
          l_var := shrink(i_words => l_var);
          sm_logger.note(l_node, 'l_var',l_var);

          --remove any comment tags, but keep string tags
          l_var := REGEXP_REPLACE(l_var,'{{comment:\w*}}',''); --Remove {{comment:1}} entirely
          sm_logger.note(l_node, 'l_var',l_var);

          ----Remember l_var_name, then remove all bracketed subterms from l_var
          --l_var_name := l_var;
          --declare
          --  l_prev varchar2(100) := l_var;
          --begin
          --  while l_var like '%(%)%' LOOP
          --    --contains bracketed term that needs to be removed.
          --    l_var := REGEXP_REPLACE(l_var,G_REGEX_BRACKETED_TERM,''); --remove any set of brackets containing non-brackets
          --    sm_logger.note(l_node, 'l_var',l_var);
          --    if l_var = l_prev then
          --      sm_logger.fatal(l_node, 'Unable to remove bracketed term.');
          --      exit;
          --    end if;
          --    l_prev := l_var;
          --  end loop;
          --end;
        
          --STASH BRACKETED TERMS
          --Iteratively replace each bracketed term with a placeholder until no bracketed terms remain.
          --create an empty term list.
          l_var_name := l_var;
          declare
            l_prev varchar2(1000) := l_var;
          begin
            while l_var like '%(%)%' LOOP
              --contains bracketed term that needs to be removed.
              g_term_stack(g_term_stack.count+1) :=  REGEXP_SUBSTR(l_var,G_REGEX_BRACKETED_TERM,1,1,'i');
              l_var := REGEXP_REPLACE(l_var,G_REGEX_BRACKETED_TERM,'{{term:'||g_term_stack.count||'}}',1,1); --remove any set of brackets containing non-brackets
              sm_logger.note(l_node, 'l_var',l_var);
              if l_var = l_prev then
                sm_logger.fatal(l_node, 'Unable to remove bracketed term.');
                exit;
              end if;
              l_prev := l_var;
            end loop;
          end;
 
          --Should now have a simple csv list of terms, which may contain placeholders.

          --Once we've finished advance to the terminator so show where we were.
          --advance past..
          go_past(G_REGEX_SEMI_COL); 

          --LOOP THRU VARS, NOTING EACH VAR
          declare
            l_var_array APEX_APPLICATION_GLOBAL.VC_ARR2;
            l_into_var       varchar2(1000);
            l_into_var_name  varchar2(1000);
         begin
        
           l_var_array := APEX_UTIL.STRING_TO_TABLE(l_var,',');
           FOR l_index IN 1..l_var_array.count LOOP

               if l_var_array(l_index) is not null then --ignore any nulls that may be in the list.
             
                 --Create a clean var for searching.
                 l_into_var := l_var_array(l_index);
                 l_into_var := REGEXP_REPLACE(l_into_var,G_REGEX_STASHED_TERM,''); --Remove stashed term
                 sm_logger.note(l_node, 'l_into_var',l_into_var);
                 
                 --Restore original var name for the note.
                 --interatively restore the stashed terms
                 l_into_var_name  := l_var_array(l_index);
           
                 declare
                   l_prev             varchar2(1000) := l_into_var_name;
                   l_term_placeholder varchar2(20);
                   l_term_index       integer;
                 begin
                   while l_into_var_name like '%{{term:%}}%' LOOP
                     --contains stashed term that needs to be restored

                     --find a placeholder
                     l_term_placeholder := REGEXP_SUBSTR(l_into_var_name,G_REGEX_STASHED_TERM,1,1,'i');
                     sm_logger.note(l_node, 'l_term_placeholder',l_term_placeholder);

                     --determine the index
                     l_term_index := REGEXP_REPLACE(l_term_placeholder,G_REGEX_STASHED_TERM,'\1');
                     sm_logger.note(l_node, 'l_term_index',l_term_index);    

                     --Restore the bracketed term as indicated by the index
                     l_into_var_name := REGEXP_REPLACE(l_into_var_name,G_REGEX_STASHED_TERM,g_term_stack(l_term_index),1,1);

                     sm_logger.note(l_node, 'l_into_var_name',l_into_var_name);
                     if l_into_var_name = l_prev then
                       sm_logger.fatal(l_node, 'Unable to restore bracketed term.');
                       exit;
                     end if;
                     l_prev := l_into_var_name;
                   end loop;
                 end;
       
                 --Note the variable
                 CASE 
                   WHEN regex_match(l_into_var ,G_REGEX_BIND_VAR) THEN 
                     note_var(i_var  => l_into_var
                             ,i_type => NULL);
                   ELSE 
                     note_complex_var(i_var_name => l_into_var_name 
                                     ,i_var      => l_into_var );
                     --sm_logger.fatal(l_node, 'AOP G_REGEX_FETCH_INTO BUG - REGEX Mismatch');
                     --RAISE x_invalid_keyword;
                 END CASE;
 
               end if;
           END LOOP;

 
        end;
      end;  

/*

 
        --Find each variable until a ";" is reached.
        l_into_var_list.DELETE;
        LOOP
            l_var := get_next( i_srch_after     => G_REGEX_VAR        
                                         ||'|'||G_REGEX_REC_COL    
                                         ||'|'||G_REGEX_BIND_VAR  
                              ,i_stop        => G_REGEX_SEMI_COL    
                                         ||'|'||G_REGEX_FROM
                              ,i_lower       => TRUE
                              ,i_colour      => G_COLOUR_VAR
                              ,i_raise_error => TRUE);
          sm_logger.note(l_node, 'l_var',l_var);
           IF regex_match(l_var ,G_REGEX_SEMI_COL    
                          ||'|'||G_REGEX_FROM)  THEN 
             go_past(G_REGEX_SEMI_COL);
             EXIT;
           END IF;
           sm_logger.info(l_node, 'Adding a variable');
           --l_into_var_list (l_into_var_list.COUNT+1) := l_var;  
           store_var_list(i_var       => create_var_rec(i_param_name  => l_var
                                                       ,i_param_type  => 'SELECT_INTO' --Unable to derive the datatype
                                                       ,i_lim_var     => true
                                                       ,i_pu_stack    => l_pu_stack)
                         ,io_var_list => l_into_var_list
                         ,i_pu_stack  => l_pu_stack);
 
        END LOOP; 
 
        --Loop thru the variables after all have been found.
        l_index := l_into_var_list.FIRST;
        WHILE l_index IS NOT NULL LOOP
          l_var := l_into_var_list(l_index).name;
          --Note the variable
          CASE 
            WHEN regex_match(l_var ,G_REGEX_BIND_VAR) THEN note_var(i_var  => l_var
                                                                   ,i_type => NULL);
            --@TODO this will need to match properly on complex vars too.
            WHEN regex_match(l_var ,G_REGEX_VAR)      THEN note_complex_var(i_var_name => l_var 
                                                                           ,i_var      => l_var );
            WHEN regex_match(l_var ,G_REGEX_REC_COL)  THEN note_rec_col_var(i_var => l_var );
            ELSE 
              sm_logger.fatal(l_node, 'AOP G_REGEX_FETCH_INTO BUG - REGEX Mismatch');
              RAISE x_invalid_keyword;
          END CASE;
 
          --Next variable
          l_index := l_into_var_list.NEXT(l_index);
        END LOOP;
 
*/
  
      WHEN regex_match(l_keyword ,G_REGEX_WHEN_OTHERS_THEN) THEN  
        sm_logger.info(l_node, 'WHEN OTHERS THEN');   
        if g_note_exception_handlers then
  
          --note an error after WHEN OTHERS THEN  
          inject( i_new_code => q'[sm_logger.comment(l_node,'WHEN OTHERS Exception Handler');]'
                 ,i_indent   => i_indent
                 ,i_colour   => G_COLOUR_EXCEPTION_BLOCK);
  
          inject( i_new_code => 'sm_logger.note_error(l_node);'
                 ,i_indent   => i_indent
                 ,i_colour   => G_COLOUR_EXCEPTION_BLOCK);
  
        end if;  
        
      WHEN regex_match(l_keyword ,G_REGEX_WHEN_EXCEPT_THEN) THEN 
        --Only want to note exceptions in an exception section.
        IF l_exception_section and g_note_exception_handlers THEN
          sm_logger.info(l_node, 'WHEN EXCEPT THEN');       

          --comment the exception after WHEN explicit_exception THEN 
          inject( i_new_code => q'[sm_logger.comment(l_node,'EXPLICIT Exception Handler');]'
                 ,i_indent   => i_indent
                 ,i_colour   => G_COLOUR_EXCEPTION_BLOCK);

          inject( i_new_code => 'sm_logger.comment(l_node,'''||flatten(trim_whitespace(l_keyword))||''');'
                 ,i_indent   => i_indent
                 ,i_colour   => G_COLOUR_EXCEPTION_BLOCK);   
        END IF;    

      --WHEN regex_match(l_keyword ,G_REGEX_DML) THEN 
      --  sm_logger.info(l_node, 'DML');
      --  l_table_name := get_next_object_name;
      --
      --  go_past(G_REGEX_SEMI_COL); 
      --  inject( i_new_code => 'sm_logger.note_rowcount(l_node,'''||flatten(trim_whitespace(l_keyword))||' '||l_table_name||''');'
      --         ,i_indent   => i_indent
      --         ,i_colour   => G_COLOUR_NOTE); 

      WHEN regex_match(l_keyword ,G_REGEX_SEMI_COL) THEN 
        sm_logger.info(l_node, 'Any other statement');
        --go_past(G_REGEX_SEMI_COL); 
 
      ELSE 
          sm_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
          RAISE x_invalid_keyword;
  
    END CASE;
 
  END LOOP;

 
exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_block;

--------------------------------------------------------------------------------- 
-- AOP_pu_block
---------------------------------------------------------------------------------
/** PRIVATE
* Weave a Program Unit block
*   Wrap an extra BEGIN END block around the original block, to support
*   - logger param calls before the original BEGIN.
*   - an EXCEPTION WHEN OTHERS after the original END.
*     to trap, note and re-raise errors from the original block.
* @param  i_prog_unit_name Name of program unit
* @param  i_indent    Current indent count
* @param  i_param_list  List of parameters (indexed by integer)
* @param  i_var_list    List of scoped variables
*/
PROCEDURE AOP_pu_block(i_prog_unit_name IN VARCHAR2
                      ,i_indent         IN INTEGER
                      ,i_param_list     IN param_list_typ
                      ,i_var_list       IN var_list_typ
                      ,i_pu_stack       in pu_stack_typ  ) IS
  l_node   sm_logger.node_typ := sm_logger.new_proc(g_package_name,'AOP_pu_block');
  
  l_var_list              var_list_typ := i_var_list;
  l_index                 BINARY_INTEGER;
  l_param_padding         integer;

  l_expanded_param_list   param_list_typ;
 
BEGIN
 
  sm_logger.param(l_node, 'i_prog_unit_name'     ,i_prog_unit_name     );
  sm_logger.param(l_node, 'i_indent        '     ,i_indent             );
 

  l_expanded_param_list := get_expanded_param_list(i_param_list => i_param_list);

  --Calculate optimal param padding to line them up nicely.
  l_param_padding := 0;
  l_index := l_expanded_param_list.FIRST;
  WHILE l_index IS NOT NULL LOOP

    --Find the length of the longest parameter name
    l_param_padding := GREATEST(l_param_padding, LENGTH(l_expanded_param_list(l_index).name)+2, G_MIN_PARAM_NAME_PADDING);
 
    l_index := l_expanded_param_list.NEXT(l_index);    
 
  END LOOP;

 

  --Add extra BEGIN infront of existing BEGIN, ensuring not trimmed.
  go_upto(i_stop      => G_REGEX_BEGIN); --default is i_trim_pointers FALSE
 
  if g_add_wrapper_block then
    --BEGIN a wrapper block. 
    inject( i_new_code  => 'begin --'||i_prog_unit_name
            ,i_indent   => i_indent - g_indent_spaces
            ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  end if;

  if g_note_params then
    --Add the params (if any)
    l_index := l_expanded_param_list.FIRST;
    WHILE l_index IS NOT NULL LOOP
      IF l_expanded_param_list(l_index).type = 'CLOB' THEN
        inject( i_new_code  => 'sm_logger.param_clob(l_node,'||RPAD(''''||l_expanded_param_list(l_index).name||'''',l_param_padding)||','||l_expanded_param_list(l_index).name||');'
               ,i_indent    => i_indent
               ,i_colour    => G_COLOUR_PARAM);
      ELSE
        inject( i_new_code  => 'sm_logger.param(l_node,'||RPAD(''''||l_expanded_param_list(l_index).name||'''',l_param_padding)||','||l_expanded_param_list(l_index).name||');'
               ,i_indent    => i_indent
               ,i_colour    => G_COLOUR_PARAM);
      END IF;
             
      l_index := l_expanded_param_list.NEXT(l_index);    
   
    END LOOP;
  end if;

  --If the logger process id parameter is included, in THIS node, then
  --return a pointer to the logged process
  if l_var_list.exists(g_logger_id_param)                   and
     l_var_list(g_logger_id_param).level = i_pu_stack.count and
     l_var_list(g_logger_id_param).out_var                  then
      inject( i_new_code  => lower(g_logger_id_param)||' := l_node.call.session_id;'
             ,i_indent    => i_indent
             ,i_colour    => G_COLOUR_RETURN_LOG);

  end if;

  --If the logger url parameter is included, in THIS node, then
  --return a url to view the process in the logger app.
  if l_var_list.exists(g_logger_url_param)                  and
     l_var_list(g_logger_url_param).level = i_pu_stack.count and
     l_var_list(g_logger_url_param).out_var                  then
      inject( i_new_code  => 
        lower(g_logger_url_param)||' := sm_api.get_smartlogger_trace_URL(i_session_id  => l_node.call.session_id);'
             ,i_indent    => i_indent
             ,i_colour    => G_COLOUR_RETURN_LOG);

  end if;
 
 
  IF i_prog_unit_name = 'beforepform' THEN
    inject( i_new_code  => 'sm_logger.info(l_node,''Starting Report ''||'||g_aop_module_name||');'
           ,i_indent   => i_indent+1
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  ELSIF i_prog_unit_name = 'afterreport' THEN
    inject( i_new_code  => 'sm_logger.info(l_node,''Finished Report ''||'||g_aop_module_name||');'
           ,i_indent   => i_indent+1
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  END IF;
 
  --First Block is BEGIN 
  --calc indent and consume BEGIN
  AOP_block(i_indent    => calc_indent(i_indent, get_next(i_srch_before => G_REGEX_BEGIN
                                                         ,i_colour => G_COLOUR_GO_PAST))
           ,i_regex_end  => G_REGEX_END_BEGIN
           ,i_var_list   => l_var_list
           ,i_pu_stack   => i_pu_stack  );
  
  if g_note_unhandled_errors or 
     g_warn_unhandled_errors or 
     g_fatal_unhandled_errors then
    --Add extra exception handler
    --add the terminating exception handler of the new surrounding block
    inject( i_new_code  => 'exception'
           ,i_indent    => i_indent - g_indent_spaces
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  
    inject( i_new_code  => '  when others then'
           ,i_indent    => i_indent - g_indent_spaces
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

    inject( i_new_code  => q'[  sm_logger.comment(l_node,'Unhandled Error');]'
           ,i_indent    => i_indent
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
    
    if g_note_unhandled_errors  then
 
      inject( i_new_code  => '    sm_logger.note_error(l_node);'
             ,i_indent    => i_indent - g_indent_spaces
             ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

    elsif g_warn_unhandled_errors  then
 
      inject( i_new_code  => '    sm_logger.warn_error(l_node);'
             ,i_indent    => i_indent - g_indent_spaces
             ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

    else --g_fatal_unhandled_errors

      inject( i_new_code  => '    sm_logger.oracle_error(l_node);'
             ,i_indent    => i_indent - g_indent_spaces
             ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
    end if;
 
    inject( i_new_code  => '    raise;'
           ,i_indent    => i_indent - g_indent_spaces
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  end if;

  if g_add_wrapper_block then
    --END wrapper block
    inject( i_new_code  => 'end; --'||i_prog_unit_name
           ,i_indent    => i_indent - g_indent_spaces
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  end if;
 

exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_block;


 
--------------------------------------------------------------------------------- 
-- AOP_prog_units
---------------------------------------------------------------------------------
/** PRIVATE
* Weave program units until no more program units found.
* @param  i_indent   current indent count
* @param  i_var_list list of scoped variables
*/
PROCEDURE AOP_prog_units(i_indent   IN INTEGER
                        ,i_var_list IN var_list_typ
                        ,i_pu_stack in pu_stack_typ) IS
  l_node    sm_logger.node_typ := sm_logger.new_proc(g_package_name,'AOP_prog_units'); 

  l_keyword         VARCHAR2(50);
  l_language        VARCHAR2(50);
  l_forward_declare VARCHAR2(50);
  l_node_type       VARCHAR2(50);
  l_prog_unit_name  VARCHAR2(30);
  
  l_var_list        var_list_typ := i_var_list;
  x_language_java_name EXCEPTION;
  x_forward_declare    EXCEPTION;
 
BEGIN

  sm_logger.param(l_node, 'i_indent'     ,i_indent );
 
  LOOP
    BEGIN
 
        --Find node type
        l_keyword := get_next( i_srch_before => G_REGEX_PROG_UNIT
                              ,i_stop        => G_REGEX_BEGIN
                              ,i_upper       => TRUE
                              ,i_colour      => G_COLOUR_PROG_UNIT );
     
      sm_logger.note(l_node, 'l_keyword' ,l_keyword);   
      CASE 
        WHEN regex_match(l_keyword,G_REGEX_PKG_BODY) THEN
          l_node_type := g_node_type_package;
        WHEN regex_match(l_keyword,G_REGEX_PROCEDURE) THEN
          l_node_type := g_node_type_procedure;
        WHEN regex_match(l_keyword,G_REGEX_FUNCTION) THEN
          l_node_type := g_node_type_function;
        WHEN regex_match(l_keyword,G_REGEX_TRIGGER) THEN
          l_node_type := g_node_type_trigger;
      WHEN regex_match(l_keyword,G_REGEX_BEGIN) OR l_keyword IS NULL THEN
        EXIT;
        ELSE
      sm_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
      RAISE x_invalid_keyword;
      END CASE;  
      sm_logger.note(l_node, 'l_node_type' ,l_node_type);  
 
      --Check for LANGUAGE JAVA NAME
      --If this is a JAVA function then we don't want a node and don't need to bother reading spec or parsing body.
      --Will find a LANGUAGE keyword before next ";"
      l_language := get_next(i_srch_before  => G_REGEX_JAVA 
                            ,i_stop         => G_REGEX_SEMI_COL
                            ,i_upper        => TRUE
                            ,i_colour       => G_COLOUR_JAVA
                            ,i_raise_error  => TRUE );
     
      sm_logger.note(l_node, 'l_language' ,l_language); 
      IF l_language LIKE 'LANGUAGE%' THEN
        RAISE x_language_java_name; 
      END IF;
    
      
      --Check for Forward Declaration
      --If this is a Forward Declaration 
      --then we don't want a node and don't need to bother reading spec or parsing body.
      --Will find a ";" before next IS or AS (or DECLARE for trigger)
      l_forward_declare := get_next(i_srch_before  => G_REGEX_SEMI_COL 
                                   ,i_stop         => G_REGEX_IS_AS_DECLARE 
                                   ,i_upper        => TRUE
                                   ,i_colour       => G_COLOUR_GO_PAST --G_COLOUR_FORWARD_DECLARE
                                   ,i_raise_error  => TRUE );
     
      sm_logger.note(l_node, 'l_forward_declare' ,l_forward_declare); 
      IF l_forward_declare = G_REGEX_SEMI_COL THEN
        RAISE x_forward_declare; 
      END IF;
      
      
      --Get program unit name
      l_prog_unit_name := get_next_object_name;
 
      if l_node_type = g_node_type_package then
        --Create a default unit name for a package.
        l_prog_unit_name := 'init_package';
      end if;  

      sm_logger.note(l_node, 'l_prog_unit_name' ,l_prog_unit_name);
 
      AOP_is_as(i_prog_unit_name => l_prog_unit_name
               ,i_indent         => calc_indent(i_indent, l_keyword)
               ,i_node_type      => l_node_type
               ,i_var_list       => l_var_list
               ,i_pu_stack       => i_pu_stack );
      
    EXCEPTION 
      WHEN x_language_java_name THEN
        sm_logger.comment(l_node, 'Found LANGUAGE JAVA NAME.');    
      
      WHEN x_forward_declare THEN
        sm_logger.comment(l_node, 'Found FORWARD DECLARATION.');    
    END;
  END LOOP;
 
  sm_logger.comment(l_node, 'No more program units.');
 
exception
  when others then
    sm_logger.warn_error(l_node);
    raise; 
 
END AOP_prog_units;
 
--------------------------------------------------------------------
-- trim_clob
--------------------------------------------------------------------
/** PRIVATE
* Remove all leading and trailing whitespace from CLOB
* @param i_clob   source clob
* @return trim(source clob)
*/
FUNCTION trim_clob(i_clob IN CLOB) RETURN CLOB IS
  G_REGEX_LEADING_TRAILING_WHITE CONSTANT VARCHAR2(20) := '^\s*|\s*$';
BEGIN
  RETURN TRIM(REGEXP_REPLACE(i_clob,G_REGEX_LEADING_TRAILING_WHITE,''));
END;


  --------------------------------------------------------------------
  -- get_plsql
  --------------------------------------------------------------------
/** PRIVATE
* Retrieve PLSQL object source using dbms_metadata.get_ddl
* @param i_object_name      Object Name
* @param i_object_type      Object Type
* @param i_object_owner     Object Owner
* @return object source code
*/
  function get_plsql ( i_object_name   in varchar2
                     , i_object_type   in varchar2
                     , i_object_owner  in varchar2 )  return clob is
  
    l_node sm_logger.node_typ := sm_logger.new_func(g_package_name,'get_plsql');     
    l_code clob;
    l_object_type varchar2(30);
  begin
    sm_logger.param(l_node, 'i_object_name  '          ,i_object_name   );
    sm_logger.param(l_node, 'i_object_type  '          ,i_object_type   );
    sm_logger.param(l_node, 'i_object_owner '          ,i_object_owner  );
 
    --dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE );

    l_object_type := case 
                       when i_object_type = 'PACKAGE'      then 'PACKAGE_SPEC'
                       when i_object_type = 'PACKAGE BODY' then 'PACKAGE_BODY'
                       else i_object_type
                     end;
    sm_logger.note(l_node, 'l_object_type '          ,l_object_type  );

    l_code:= dbms_metadata.get_ddl(l_object_type, i_object_name, i_object_owner);

    --Remove alter trigger statement
    IF i_object_type = 'TRIGGER' THEN
      l_code:= regexp_replace(l_code 
                            ,'(CREATE OR REPLACE TRIGGER )(.+)(ALTER TRIGGER .+)', 
                     '\1\2', 1, 0, 'n'); --omit the third componant
    END IF;
 
    return trim_clob(i_clob => l_code);
  end get_plsql;


-----------------------------------------------------------------------------------------------
-- P U B L I C
----------------------------------------------------------------------------------------------- 

 

-----------------------------------------------------------------------------------------------
-- weave
----------------------------------------------------------------------------------------------- 
/** PRIVATE
* Weave logger instrumentation into the source code.  
* Will process 
*  one package body (and componants) or 
*  one anonymous block (and componants) or
*  a list of program units (Procedures and Functions)            
* @param io_code         source code
* @param i_package_name name of package (optional)
* @param i_var_list     list of scoped variables, typically from a package spec
* @param i_pu_stack     program stack - private type pu_stack_typ
* @param i_for_html     flag to add HTML style tags for apex pretty print
* @param i_end_user     object owner
* @return TRUE if woven successfully.
*/

  function weave
  ( io_code                   in out clob
  , i_package_name            in varchar2
  , i_var_list                in var_list_typ 
  , i_pu_stack                in pu_stack_typ 
  , i_for_html                in boolean      default false
  , i_end_user                in varchar2     default null
  ) return boolean
  is

    l_node sm_logger.node_typ := sm_logger.new_func(g_package_name,'weave'); 
 
    l_woven              boolean := false;
    l_current_pos        integer := 1;
    l_count              NUMBER  := 0;
    l_end_pos            integer;  
  
    l_end_value          varchar2(50);
    l_mystery_word       varchar2(50);

    l_package_name       varchar2(50);
  
  begin
    sm_logger.param(l_node, 'i_package_name'      ,i_package_name);
    sm_logger.param(l_node, 'i_for_html'          ,i_for_html);
    sm_logger.param(l_node, 'i_end_user'          ,i_end_user);

    begin
 
      IF i_package_name IS NULL THEN
        g_aop_module_name := '$$plsql_unit';
        ELSE
        g_aop_module_name := ''''||i_package_name||'''';
      END IF;
     
      g_for_aop_html := i_for_html;
      g_end_user     := i_end_user;
   
      g_code := chr(10)||io_code||chr(10); --add a trailing CR to help with searching
    
      set_weave_timeout;
        
      --Remove all comments and string constants, so they can be ignored by the weaver.  
      stash_comments_and_strings;
   
      --Reset the processing pointer.
      g_current_pos := 1;
   
      --Need to determine what sort of code we have - at the top level.
  
      --Anonymous Block             - look for DECLARE or BEGIN
      --Progam Units                - look for PROCEDURE or FUNCTION 
      --PACKAGE BODY                - look for PACKAGE BODY
      
      --Each of these can have prog units embedded in the declaration section (if any).
      --and each may have additional Anonymous blocks embedded in the body section (if any).
      
      
      --  A package body which would be similar to procedure or function but with no parameters.

      declare
        l_keyword    varchar2(50);
        l_var_list   var_list_typ := i_var_list; 
        --l_pu_stack   pu_stack_typ := i_pu_stack; 
     
      
      begin
        g_current_pos := 1;
        l_keyword := get_next(i_stop       => G_REGEX_DECLARE
                                       ||'|'||G_REGEX_BEGIN  
                                       ||'|'||G_REGEX_PROG_UNIT 
                                       ||'|'||G_REGEX_CREATE
                             ,i_upper       => TRUE
                             ,i_raise_error => TRUE  );
     
        sm_logger.note(l_node, 'l_keyword' ,l_keyword);
    
        CASE --@TODO might need to add a check for a <<NAME>> before a block
          WHEN regex_match(l_keyword , G_REGEX_DECLARE) THEN
            sm_logger.comment(l_node, 'Found Anonymous Block with declaration');
            --calc indent and consume DECLARE
            AOP_declare_block(i_indent    => calc_indent(g_initial_indent, get_next(i_srch_before => G_REGEX_DECLARE
                                                                                   ,i_colour      => G_COLOUR_GO_PAST))
                             ,i_var_list  => l_var_list
                             ,i_pu_stack  => i_pu_stack);
              
          WHEN regex_match(l_keyword , G_REGEX_BEGIN) THEN
            sm_logger.comment(l_node, 'Found Simple Anonymous Block');
            --calc indent and consume BEGIN
            AOP_block(i_indent     => calc_indent(g_initial_indent, get_next(i_srch_before => G_REGEX_BEGIN
                                                                            ,i_colour      => G_COLOUR_GO_PAST))
                     ,i_regex_end  => G_REGEX_END_BEGIN
                     ,i_var_list   => l_var_list
                     ,i_pu_stack   => i_pu_stack);
        
          WHEN regex_match(l_keyword , G_REGEX_PROG_UNIT
                                ||'|'||G_REGEX_CREATE) THEN
            sm_logger.comment(l_node, 'Found Program Unit');
            AOP_prog_units(i_indent   => calc_indent(g_initial_indent,l_keyword)
                          ,i_var_list => l_var_list
                          ,i_pu_stack => i_pu_stack);
    
        ELSE
          sm_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
          RAISE x_invalid_keyword;
        end case;   
      end;
 
      l_woven:= true;

      --Translate sm_jotter syntax to equivalent sm_logger syntax
      --EG sm_jotter.x(           ->  sm_logger.x(l_node,
      g_code := REGEXP_REPLACE(g_code,'(sm_jotter)(\.)(.+)(\()','sm_logger.\3(l_node,');
    
      --Replace routines with no params 
      --EG sm_jotter.oracle_error -> sm_logger.oracle_error(l_node)
      g_code := REGEXP_REPLACE(g_code,'(sm_jotter)(\.)(.+)(;)','sm_logger.\3(l_node);');

 
      restore_comments_and_strings;
 
    exception 
      when x_restore_failed then
        sm_logger.fatal(l_node, 'x_restore_failed');
        wedge( i_new_code => 'RESTORE FAILED'
              ,i_colour  => G_COLOUR_ERROR);
        l_woven := false;
      when x_invalid_keyword then
        sm_logger.fatal(l_node, 'x_invalid_keyword');
        wedge( i_new_code => 'INVALID KEYWORD'
              ,i_colour  => G_COLOUR_ERROR);
        l_woven := false;
      when x_weave_timeout then
        sm_logger.fatal(l_node, 'x_weave_timeout');
        wedge( i_new_code => 'WEAVE TIMED OUT'
              ,i_colour  => G_COLOUR_ERROR);
        l_woven := false;
      when x_string_not_found then
        sm_logger.fatal(l_node, 'x_string_not_found');
        l_woven := false;
     
    end;
  
    sm_logger.note(l_node, 'elapsed_time_secs' ,elapsed_time_secs);
    
    g_code := REPLACE(g_code,g_aop_directive,'Logging by sm_weaver on '||to_char(systimestamp,'DD-MM-YYYY HH24:MI:SS'));
  
    IF g_for_aop_html then
        g_code := REPLACE(REPLACE(g_code,'<<','&lt;&lt;'),'>>','&gt;&gt;');
        g_code := REGEXP_REPLACE(g_code,'(sm_logger)(.+)(;)','<B>\1\2\3</B>'); --BOLD all sm_logger calls
        g_code := '<PRE>'||g_code||'</PRE>'; --@TODO - may be able to add this into the SmartLogger display page instead.
    END IF;  
 
    io_code := trim_clob(i_clob => g_code);
 
    return l_woven;
 
  exception 
    when others then
      sm_logger.oracle_error(l_node); 
    raise;
  
  end weave;
  


--------------------------------------------------------------------
-- is_PLScoped
--------------------------------------------------------------------  
/** PRIVATE
* Verify that PL/Scope collected all identifiers
* @param i_name   Object Name 
* @param i_type   Object Type 
*/

FUNCTION is_PLScoped(i_name in varchar2
                    ,i_type in varchar2 ) return boolean is
  l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'is_plscoped');

  cursor cu_plsql_object_settings is
  SELECT PLSCOPE_SETTINGS
  FROM   USER_PLSQL_OBJECT_SETTINGS
  WHERE  NAME = i_name 
  AND    TYPE = i_type;

  l_plsql_object_settings cu_plsql_object_settings%ROWTYPE;
begin --is_plscoped
  sm_logger.param(l_node,'i_name',i_name);
  sm_logger.param(l_node,'i_type',i_type);
BEGIN
  OPEN  cu_plsql_object_settings;
  FETCH cu_plsql_object_settings INTO l_plsql_object_settings;
  CLOSE cu_plsql_object_settings;

  return l_plsql_object_settings.plscope_settings = 'IDENTIFIERS:ALL';

END;
exception
  when others then
    sm_logger.warn_error(l_node);
    raise;
end; --is_plscoped
 


--------------------------------------------------------------------
-- get_vars_from_compiled_object
--------------------------------------------------------------------  
/** PRIVATE
* Use PLScope to find variables in the compiled_object - package or package body
* recompile spec if needed
* @param i_name   Object Name 
* @param i_owner  Object Owner
* @param i_type   Object Type
*/
FUNCTION get_vars_from_compiled_object(i_name       in varchar2
                                      ,i_owner      in varchar2
                                      ,i_type       in varchar2 
                                      ,i_var_list   in var_list_typ) return var_list_typ is
    l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'get_vars_from_compiled_object');
    l_var_list    var_list_typ := i_var_list;
    l_pu_stack    pu_stack_typ;
    l_source_code clob;
  begin --get_vars_from_compiled_object
    sm_logger.param(l_node,'i_name' ,i_name);
    sm_logger.param(l_node,'i_owner',i_owner);
    sm_logger.param(l_node,'i_type' ,i_type);
  BEGIN
    IF is_PLScoped(i_name => i_name
                  ,i_type => i_type) THEN
      sm_logger.info(l_node,'Object is already PLScoped');

    ELSIF i_name IN ('SM_LOGGER','SM_JOTTER','SM_API','SM_WEAVER') THEN
      sm_logger.warning(l_node,'Deny recompile of SmartLogger packages');

    ELSE
      sm_logger.comment(l_node,'Object is not currently PLScoped');
      --Need to recompile the package spec with plscope set
      l_source_code := get_plsql( i_object_name    => i_name
                                , i_object_owner   => i_owner
                                , i_object_type    => i_type   );
      sm_logger.note_clob(l_node,'l_source_code',l_source_code);
      compile_plsql(i_text         => l_source_code);

      IF NOT is_PLScoped(i_name => i_name
                        ,i_type => i_type) THEN
        sm_logger.warning(l_node,'Object could not be compiled with PLSCOPE');
        null;
      END IF;
     
    END IF;

    
    IF i_type = 'PACKAGE' THEN
      --Variables in the spec may be named by their owner.package.varname
      push_pu(i_name        => i_owner  --@TODO - figure out if own is needed as a PU level
             ,i_type        => 'OWNER'
             --,i_signature   => null
             ,io_pu_stack   => l_pu_stack);

      --What is in plscope for and assignment that uses a package spec var called by username??



    END IF;  

    push_pu(i_name       => i_name
           ,i_type       => i_type
          -- ,i_signature  => null
           ,io_pu_stack  => l_pu_stack);
 
    --Now get the variables.
    For l_var in (
WITH plscope_hierarchy
        AS (SELECT line
                 , col
                 , name
                 , TYPE
                 , usage
                 , usage_id
                 , usage_context_id
                 , signature
              FROM all_identifiers
             WHERE owner       = i_owner
               AND object_name = i_name
               AND object_type = i_type)
select v.name
      ,v.type
      ,v.usage
      ,t.name      data_type
      ,t.type      data_class
      ,t.signature signature
from  plscope_hierarchy p
     ,plscope_hierarchy v
     ,plscope_hierarchy t
where p.usage_context_id = 0
and   v.usage_context_id = p.usage_id
and   v.type  = 'VARIABLE'
and   v.usage = 'DECLARATION'
and   t.usage_context_id = v.usage_id ) LOOP

--NB - Could use the original hierarchical query 
--Or could just use a recursive proc/function to store what ever it need with recursive calls 
--to the same query..


      sm_logger.note(l_node, 'l_var.name'     ,l_var.name);
      sm_logger.note(l_node, 'l_var.data_type',l_var.data_type);

      IF  is_atomic_type(i_type => l_var.data_type)  THEN
          sm_logger.comment(l_node, 'Found predefined type variable in Package Spec');
          --l_var_list(l_var.name) := l_var; 
          --@TODO check that this info is used correctly later.
          store_var_list(i_var        => create_var_rec(i_param_name => lower(l_var.name)
                                                       ,i_param_type => l_var.data_type
                                                       ,i_signature  => l_var.signature
                                                       ,i_lex_var     => true
                                                       ,i_pu_stack    => l_pu_stack)
                        ,io_var_list  => l_var_list
                        ,i_pu_stack   => l_pu_stack);
           
          sm_logger.note(l_node, 'l_var_list.count',l_var_list.count);    

      ELSIF l_var.data_class = 'RECORD' THEN
          sm_logger.comment(l_node, 'Found a Package Spec variable of record type, type defined in the package?');
          sm_logger.comment(l_node, 'Add the record variable with the signature as the signature');
          --l_var_list(l_var.name) := l_var; --Add the Record 
          --@TODO check that this info is used correctly later.
          store_var_list(i_var        => create_var_rec(i_param_name => lower(l_var.name)
                                                       ,i_param_type => l_var.data_type
                                                       ,i_signature  => l_var.signature
                                                       ,i_lex_var    => true
                                                       ,i_pu_stack    => l_pu_stack)
                        ,io_var_list  => l_var_list
                        ,i_pu_stack   => l_pu_stack);
          --Add all the componants
          DECLARE
            l_type_defn_tab identifier_tab;
            l_index binary_integer;
          BEGIN
            l_type_defn_tab := get_type_defn(i_signature => l_var.signature);
            l_index := l_type_defn_tab.FIRST;
            WHILE l_index is not null loop
              
              IF  is_atomic_type(i_type => l_type_defn_tab(l_index).data_type) THEN 
                --@TODO This needs to be able to recursively search lower levels.
                sm_logger.note(l_node, l_type_defn_tab(l_index).col_name ,l_type_defn_tab(l_index).data_type);
                --Add the Record Type

                --@TODO check that this info is used correctly later.
                store_var_list(i_var        => create_var_rec(i_param_name => lower(l_var.name||'.'||l_type_defn_tab(l_index).col_name)
                                                             ,i_param_type => l_type_defn_tab(l_index).data_type
                                                             ,i_signature  => l_var.signature
                                                             ,i_lex_var    => true
                                                             ,i_pu_stack    => l_pu_stack)
                              ,io_var_list  => l_var_list
                              ,i_pu_stack   => l_pu_stack);
                --l_var_list(l_var.name||'.'||l_type_defn_tab(l_index).col_name) := l_type_defn_tab(l_index).data_type; 
 
              END IF;

              l_index := l_type_defn_tab.NEXT(l_index);
            END LOOP;
          END;

          /*
          -- @TODO verify that this is still the way i want to do it!
          --(@TODO Convert this to cursor function)
          FOR l_column in ( WITH plscope_hierarchy
                AS (SELECT line
                         , col
                         , name
                         , TYPE
                         , usage
                         , usage_id
                         , usage_context_id
                      FROM all_identifiers
                     WHERE owner       = i_owner
                     AND   object_name = 'AOP_TEST'
                     AND   object_type = i_type)
                select v.name
                      ,v.type
                      ,v.usage
                      ,col.name col_name
                     -- ,col.type var_type
                      ,typ.name data_type
                      ,typ.type type_class
                from  plscope_hierarchy p
                     ,plscope_hierarchy v
                     ,plscope_hierarchy col
                     ,plscope_hierarchy typ
                where p.usage_context_id = 0
                and   v.usage_context_id = p.usage_id
                and   v.type  = 'RECORD'
                and   v.usage = 'DECLARATION'
                and   v.name  = l_var.data_type 
                and   v.type  = 'RECORD'
                and   col.usage_context_id = v.usage_id 
                and   typ.usage_context_id = col.usage_id 
                ) LOOP 

             sm_logger.note(l_node, 'l_column.col_name'  ,l_column.col_name);
             sm_logger.note(l_node, 'l_column.data_type' ,l_column.data_type);
             l_var_list(l_var.name||'.'||l_column.col_name) := l_column.data_type; --Add the Record Type
 
          END LOOP; 
          */
 
      ELSE
         null;
          --So it is another sort of type 
          --What are the choices
          --DB table or view Record Type
          --PLSQL Record Type
          --PLSQL Table Type
          --Cursor Type - not sure we will be able to determine this one.
          --Package Spec Type
          --Database Type
 
      END IF;    
     

    END LOOP;

    log_new_var_list(i_old_var_list => i_var_list
                    ,i_new_var_list => l_var_list);
 
    return l_var_list;
  END;
  exception
    when others then
      sm_logger.warn_error(l_node);
      raise;
  end; --get_vars_from_compiled_object



-----------------------------------------------------------------------------------------------
-- weave
----------------------------------------------------------------------------------------------- 
/** PUBLIC
* Calls the private weave function with an empty i_var_list
* So that the Apex app can call this for Quick Weave without sending i_var_list
* If package name is given - get package spec vars for var list
* If owner is not given - derive it from package name           
* @param io_code         source code
* @param i_package_name name of package (optional)
* @param i_for_html     flag to add HTML style tags for apex pretty print
* @param i_end_user     object owner
* @return TRUE if woven successfully.
*/
  function weave ( io_code                   in out clob
                 , i_package_name            in varchar2
                 , i_for_html                in boolean      default false
                 , i_end_user                in varchar2     default null
                 , i_note_params             in boolean      default true
                 , i_note_vars               in boolean      default true
                 , i_note_unhandled_errors   in boolean      default true
                 , i_warn_unhandled_errors   in boolean      default false
                 , i_fatal_unhandled_errors  in boolean      default false
                 , i_note_exception_handlers in boolean      default true
                 ) return boolean is
    l_var_list   var_list_typ;
    l_owner      varchar2(30) := i_end_user;
    l_pu_stack   pu_stack_typ;
    l_package_body_signature varchar2(32);
  BEGIN

      --THIS SECTION SHOULD BE SAME AS IN reapply_aspect
      g_note_params              := i_note_params; 
      g_note_vars                := i_note_vars; 
      g_note_unhandled_errors    := i_note_unhandled_errors;
      g_warn_unhandled_errors    := i_warn_unhandled_errors; 
      g_fatal_unhandled_errors   := i_fatal_unhandled_errors;
      g_note_exception_handlers  := i_note_exception_handlers; 
      g_add_wrapper_block        := g_note_params           or
                                    g_note_unhandled_errors or 
                                    g_warn_unhandled_errors or 
                                    g_fatal_unhandled_errors;    


    if i_package_name is not null then

      if l_owner is null then

         l_owner := object_owner(i_object_name => i_package_name
                                ,i_object_type => 'PACKAGE');

      end if;     

      --Recompile all referenced packages with PLScope before compiling this package with PLScope
      for l_referenced_object in (  select * 
                                    from  all_dependencies  
                                    where name  = i_package_name
                                    and   owner = l_owner
                                    and   type in ('PACKAGE','PACKAGE BODY') --Get refs of both the spec and body
                                    and referenced_type = 'PACKAGE' 
                                    and referenced_owner NOT IN ( 'SYS' ,'APEX_050100')
                                    and referenced_name not in ('sm_logger','sm_weaver',i_package_name)) LOOP

        --Get a list of variables from any package spec directly referenced from the spec or body of this package.
        l_var_list := get_vars_from_compiled_object(i_name     => l_referenced_object.referenced_name
                                                   ,i_owner    => l_referenced_object.referenced_owner 
                                                   ,i_type     => l_referenced_object.referenced_type 
                                                   ,i_var_list => l_var_list   );

  
      end loop;


      --Compile this package spec and body with PLScope
      --Get a list of variables from the package spec
      l_var_list := get_vars_from_compiled_object(i_name     => i_package_name
                                                 ,i_owner    => l_owner 
                                                 ,i_type     =>  'PACKAGE'
                                                 ,i_var_list => l_var_list   );

      --Get a list of variables from the package body
      l_var_list := get_vars_from_compiled_object(i_name     => i_package_name
                                                 ,i_owner    => l_owner 
                                                 ,i_type     =>  'PACKAGE BODY' 
                                                 ,i_var_list => l_var_list   );

 

   --   push_pu(i_name       => l_owner
   --          ,i_type       => 'OWNER'
   --         -- ,i_signature  => null
   --          ,io_pu_stack => l_pu_stack);
   --
   --  -- l_package_body_signature := get_db_object_signature(i_object_name => i_package_name
   --  --                                                 ,i_object_type => 'PACKAGE BODY');
   --
   --   push_pu(i_name       => i_package_name
   --          ,i_type       => 'PACKAGE BODY'
   --         -- ,i_signature  => l_package_body_signature
   --          ,io_pu_stack => l_pu_stack);
   
    end if;  
    
    RETURN weave( io_code                     => io_code        
                , i_package_name              => i_package_name
                , i_var_list                  => l_var_list  
                , i_pu_stack                  => l_pu_stack  
                , i_for_html                  => i_for_html    
                , i_end_user                  => i_end_user 
                ) ;
 
    
  END;  



--------------------------------------------------------------------
-- instrument_plsql
--------------------------------------------------------------------  
/** PRIVATE
* Reweave the object for each requested version and store the results.
* @param i_object_name   Object Name 
* @param i_object_type   Object Type 
* @param i_object_owner  Object Owner
* @param i_versions      Versions of Logger weaving required 'AOP,HTML' or 'HTML,AOP', or 'HTML' or 'AOP'
*/
  procedure instrument_plsql
  ( i_object_name             in varchar2
  , i_object_type             in varchar2
  , i_object_owner            in varchar2
  , i_versions                in varchar2 --USAGE 'AOP,HTML' or 'HTML,AOP', or 'HTML' or 'AOP'
  ) is
    l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'instrument_plsql');
  
    l_orig_body  clob;
    l_aop_body   clob;
    l_html_body  clob;
    l_woven      boolean := false;
    l_var_list   var_list_typ;
    l_pu_stack   pu_stack_typ;
    l_package_body_signature varchar2(32);
  begin 
  begin
    sm_logger.param(l_node, 'i_object_name'  ,i_object_name  );
    sm_logger.param(l_node, 'i_object_type'  ,i_object_type  );
    sm_logger.param(l_node, 'i_object_owner' ,i_object_owner );
    sm_logger.param(l_node, 'i_versions'     ,i_versions );
    g_during_advise:= true;
    -- test for state of package; no sense in trying to post-process an invalid package
    
    -- if valid then retrieve source
    l_orig_body:= get_plsql( i_object_name    => i_object_name
                           , i_object_owner   => i_object_owner
                           , i_object_type    => i_object_type   );
    -- check if perhaps the AOP_NEVER string is included that indicates that no AOP should be applied to a program unit
    -- (this bail-out is primarily used for this package itself, riddled as it is with AOP instructions)
    -- Conversely it also checks for @AOP_LOG, which must be present or AOP will also exit.
    -- This ensure that a routine is not logged unless explicitly requested.
    -- Also AOP will remove AOP_LOG in the AOP Source, so that logging cannot be doubled-up.
    if instr(l_orig_body, g_aop_never) > 0 THEN
      g_during_advise:= false; 
	  sm_logger.info(l_node, '@AOP_NEVER found.  sm_weaver skipping this request' );
      return;
    elsif instr(l_orig_body, g_aop_directive) = 0 then
      g_during_advise:= false; 
	  sm_logger.info(l_node, '@AOP_LOG not found.  sm_weaver skipping this request' );
      return;
    end if;
  
    IF NOT  validate_source(i_name    => i_object_name
                          , i_type    => i_object_type
                          , i_text    => l_orig_body
                          , i_aop_ver => 'ORIG'
                          , i_compile => TRUE
                          ) THEN
      g_during_advise:= false; 
	    sm_logger.info(l_node, 'Original Source is invalid.  sm_weaver skipping this request' );
      return;    
    end if;     
 
    IF i_object_type = 'PACKAGE BODY' THEN
      --Recompile all referenced packages with PLScope before compiling this package with PLScope


      for l_referenced_object in (  select * 
                                    from  all_dependencies  
                                    where name  = i_object_name
                                    and   owner = i_object_owner
                                    and   type in ('PACKAGE','PACKAGE BODY') --Get refs of both the spec and body
                                    and referenced_type = 'PACKAGE' 
                                    and referenced_owner NOT IN ( 'SYS' ,'APEX_050100')
                                    and referenced_name not in ('sm_logger','sm_weaver',i_object_name)) LOOP

        --Get a list of variables from any package spec directly referenced from the spec or body of this package.
        l_var_list := get_vars_from_compiled_object(i_name     => l_referenced_object.referenced_name
                                                   ,i_owner    => l_referenced_object.referenced_owner 
                                                   ,i_type     => l_referenced_object.referenced_type 
                                                   ,i_var_list => l_var_list   );

  
      end loop;

      --Compile this package spec and body with PLScope
      --Get a list of variables from the package spec
      l_var_list := get_vars_from_compiled_object(i_name     => i_object_name
                                                 ,i_owner    => i_object_owner 
                                                 ,i_type     =>  'PACKAGE'
                                                 ,i_var_list => l_var_list   );

      --Get a list of variables from the package body (EXPERIMENTAL) Need to verify that this is a good addition.
      l_var_list := get_vars_from_compiled_object(i_name     => i_object_name
                                                 ,i_owner    => i_object_owner 
                                                 ,i_type     =>  'PACKAGE BODY' 
                                                 ,i_var_list => l_var_list   );
 
    END IF;  

   -- --Seed the PU Stack
   -- push_pu(i_name       => i_object_owner
   --        ,i_type       => 'OWNER'
   --        --,i_signature  => null
   --        ,io_pu_stack  => l_pu_stack);
--
   ---- l_package_body_signature := get_db_object_signature(i_object_name => i_object_name
   -- --                                                ,i_object_type => i_object_type);
--
   -- --?? Should this be done here or in the as is routine.??
   -- push_pu(i_name       => i_object_name
   --        ,i_type       => i_object_type
   --       -- ,i_signature  => l_package_body_signature
   --        ,io_pu_stack  => l_pu_stack);
--
 
    if i_versions like 'HTML%' then
      --Reweave with html - even if the AOP failed.
      --We want to see what happened.
      sm_logger.comment(l_node,'Reweave with html');  
      l_html_body := l_orig_body;
        l_woven := weave( io_code         => l_html_body
                          , i_package_name => lower(i_object_name)
                          , i_var_list     => l_var_list
                          , i_pu_stack     => l_pu_stack
                          , i_for_html     => true
                          , i_end_user     => i_object_owner
                          );
 
      IF NOT validate_source(i_name  => i_object_name
                           , i_type  => i_object_type
                           , i_text  => l_html_body
                           , i_aop_ver => 'AOP_HTML'
                           , i_compile => FALSE) THEN
        sm_logger.fatal(l_node,'Oops problem committing AOP_HTML.');             
     
      END IF;

    end if;

    if i_versions like '%AOP%' then

      l_aop_body := l_orig_body;
      -- manipulate source by weaving in aspects as required; only weave if the keyword logging not yet applied.
      l_woven := weave( io_code         => l_aop_body
                        , i_package_name => lower(i_object_name)
                        , i_var_list     => l_var_list
                        , i_pu_stack     => l_pu_stack
                        , i_end_user     => i_object_owner        );

      -- (re)compile the source 
      sm_logger.comment(l_node, 'Validate the AOP version.' );
      IF NOT validate_source(i_name  => i_object_name
                         , i_type  => i_object_type
                         , i_text  => l_aop_body
                         , i_aop_ver => 'AOP'
                         , i_compile => l_woven  ) THEN
        sm_logger.info(l_node, 'Recompile the Original version.' );
        --reexecute the original so that we at least end up with a valid package.
        IF NOT  validate_source(i_name  => i_object_name
                              , i_type  => i_object_type
                              , i_text  => l_orig_body
                              , i_aop_ver => 'ORIG'
                              , i_compile => TRUE) THEN
        --unlikely that will get an error in the original if it worked last time
        --but trap it incase we do  
            sm_logger.fatal(l_node,'Original Source is invalid on second try.');      
        end if;
      else
        --Register the module!!
        if instr(l_orig_body, g_aop_reg_mode_debug) > 0 THEN
          sm_api.set_module_debug(i_module_name => i_object_name );
        end if;

      end if;
 
    end if;

    if i_versions = 'AOP,HTML' then

      --Reweave with html - even if the AOP failed.
      --We want to see what happened.
      sm_logger.comment(l_node,'Reweave with html');  
      l_html_body := l_orig_body;
        l_woven := weave( io_code         => l_html_body
                          , i_package_name => lower(i_object_name)
                          , i_var_list     => l_var_list
                          , i_pu_stack     => l_pu_stack
                          , i_for_html     => true
                          , i_end_user     => i_object_owner);
 
      IF NOT validate_source(i_name  => i_object_name
                           , i_type  => i_object_type
                           , i_text  => l_html_body
                           , i_aop_ver => 'AOP_HTML'
                           , i_compile => FALSE) THEN
        sm_logger.fatal(l_node,'Oops problem committing AOP_HTML.');             
     
      END IF;

    end if;

    
    g_during_advise:= false; 

  exception 
    when others then
      sm_logger.oracle_error(l_node); 
      g_during_advise:= false; 
  end;    
  exception 
    when others then
    --I think we need to ensure the routine does not fail, or it will re-submit job.
      g_during_advise:= false; 
  end instrument_plsql;

--------------------------------------------------------------------
-- reapply_aspect
--------------------------------------------------------------------  
/** PUBLIC
* Reweave the object
* @param i_object_name  Object Name 
* @param i_versions     Versions of Logger weaving required 'AOP,HTML' or 'HTML,AOP', or 'HTML' or 'AOP'
*/
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL
                         , i_versions    in varchar2 default 'AOP,HTML'
                         , i_note_params             in boolean      default true
                         , i_note_vars               in boolean      default true
                         , i_note_unhandled_errors   in boolean      default true
                         , i_warn_unhandled_errors   in boolean      default false
                         , i_fatal_unhandled_errors  in boolean      default false
                         , i_note_exception_handlers in boolean      default true
                         ) is
    l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'reapply_aspect'); 
  begin

      --THIS SECTION SHOULD BE SAME AS IN weave PUBLIC
      g_note_params              := i_note_params; 
      g_note_vars                := i_note_vars; 
      g_note_unhandled_errors    := i_note_unhandled_errors;
      g_warn_unhandled_errors    := i_warn_unhandled_errors; 
      g_fatal_unhandled_errors   := i_fatal_unhandled_errors;
      g_note_exception_handlers  := i_note_exception_handlers; 
      g_add_wrapper_block        := g_note_params           or
                                    g_note_unhandled_errors or 
                                    g_warn_unhandled_errors or 
                                    g_fatal_unhandled_errors;  

    sm_logger.param(l_node, 'i_object_name', i_object_name);
      for l_object in (select object_name 
                            , object_type
                            , USER         owner
                       from user_objects  --only want to see objects owned by the invoker
                       where object_type IN ('FUNCTION'
                                            ,'PACKAGE BODY'
                                            ,'PROCEDURE'
                                            ,'TRIGGER'
                                            ,'TYPE BODY')
                       and   object_name = NVL(UPPER(i_object_name),object_name)) loop

          --AOP the code
          instrument_plsql( i_object_name  => l_object.object_name
                          , i_object_type  => l_object.object_type
                          , i_object_owner => l_object.owner
                          ,i_versions      => i_versions);
  
      end loop;
  end reapply_aspect;

--------------------------------------------------------------------
-- restore_comments_and_strings
--------------------------------------------------------------------  
/** PRIVATE
* Replace all comment placeholders with the original comment
* Replace all string placeholders with the original strings
*/
  procedure restore_comments_and_strings IS
      l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'restore_comments_and_strings'); 
      l_text CLOB;    
      l_temp_code CLOB;
  BEGIN
    --Reset the processing pointer.
    g_current_pos := 1;
 
    FOR l_index in 1..g_comment_stack.count loop
      sm_logger.note(l_node, 'comment', l_index);
      l_temp_code := g_code;
      l_text := f_colour(i_text   => g_comment_stack(l_index)
                        ,i_colour => G_COLOUR_COMMENT);
      g_code := REPLACE(g_code,'{{comment:'||l_index||'}}',l_text);

      IF l_temp_code = g_code THEN
         sm_logger.warning(l_node, 'Did not find '||'{{comment:'||l_index||'}}');
         wedge( i_new_code => 'LOOKING FOR '||'{{comment:'||l_index||'}}'
                ,i_colour  => G_COLOUR_ERROR);
        RAISE x_restore_failed; 
        --Eg sometimes in HTML mode, cannot find {{comment:x}} if a html tag has been written in the middle of it.
      END IF; 
 
    END LOOP;
  
    FOR l_index in 1..g_string_stack.count loop
      sm_logger.note(l_node, 'string', l_index);
      l_temp_code := g_code;
      l_text := f_colour(i_text   => g_string_stack(l_index)
                        ,i_colour => G_COLOUR_STRING);
      g_code := REPLACE(g_code,'{{string:'||l_index||'}}',l_text);

      IF l_temp_code = g_code THEN
         sm_logger.warning(l_node, 'Did not find '||'{{string:'||l_index||'}}');
         wedge( i_new_code => 'LOOKING FOR '||'{{string:'||l_index||'}}'
                ,i_colour  => G_COLOUR_ERROR);
        RAISE x_restore_failed;
      END IF; 

  END LOOP;





  END;
  
--------------------------------------------------------------------
-- stash_comments_and_strings
--------------------------------------------------------------------  
/** PRIVATE
* Replace each comment with a placeholder and stash the original comment
* Replace each string with a placeholder and stash the original string
* www.orafaq.com/forum/t/99722/2/ discussion of alternative methods.
*/

  procedure stash_comments_and_strings  IS
     
    l_node sm_logger.node_typ := sm_logger.new_proc(g_package_name,'stash_comments_and_strings');  
  
    l_keyword              VARCHAR2(1000);  

    procedure extract_comment(i_mask     IN VARCHAR2
                             ,i_modifier IN VARCHAR2 DEFAULT 'in') IS
      l_comment              CLOB;
    BEGIN
      l_comment := get_next(i_stop     => i_mask
                           ,i_modifier => i_modifier ); --multi-line, lazy
      sm_logger.note_clob(l_node, 'l_comment', l_comment);
      g_comment_stack(g_comment_stack.count+1) := l_comment; --Put another comment on the stack
      sm_logger.note(l_node, 'g_comment_stack.count', g_comment_stack.count);
      g_code := REGEXP_REPLACE(g_code, i_mask, '{{comment:'||g_comment_stack.count||'}}',g_current_pos, 1, i_modifier);
      go_past(i_search => '{{comment:'||g_comment_stack.count||'}}'
             ,i_colour => NULL);
        
    END;
  
    procedure extract_strings(i_mask     IN VARCHAR2
                                 ,i_modifier IN VARCHAR2 DEFAULT 'in') IS
      l_string              CLOB;
    BEGIN
      l_string := get_next(i_stop     => i_mask
                         ,i_modifier => i_modifier ); --multi-line, lazy
      sm_logger.note(l_node, 'l_string', l_string);
      g_string_stack(g_string_stack.count+1) := l_string; --Put another string on the stack
      sm_logger.note(l_node, 'g_string_stack.count', g_string_stack.count);
      g_code := REGEXP_REPLACE(g_code, i_mask, '{{string:'||g_string_stack.count||'}}',g_current_pos, 1, i_modifier);
      go_past(i_search => '{{string:'||g_string_stack.count||'}}'
             ,i_colour => NULL);
    END;
 
  BEGIN  
 
    g_current_pos   := 1;
  
    --initialise comments and strings
    
    g_comment_stack.DELETE;  
    g_string_stack.DELETE;
 
 
    LOOP
     
      DECLARE
   
        G_REGEX_START_SINGLE_COMMENT  CONSTANT VARCHAR2(50) :=  '--.{0,2}';  -- double-dash + upto 2 chars
        G_REGEX_START_MULTI_COMMENT   CONSTANT VARCHAR2(50) :=  '/\*'    ;
        G_REGEX_START_STRING           CONSTANT VARCHAR2(50) :=  '\'''    ;
        G_REGEX_START_ADV_STRING       CONSTANT VARCHAR2(50) :=  'Q\''\S' ;
     
        G_REGEX_SHOW_ME               CONSTANT VARCHAR2(50) :=  '--(\@\@)';
        G_REGEX_ROW_COUNT             CONSTANT VARCHAR2(50) :=  '--(RC)';
      
        G_REGEX_START_COMMENT_OR_STR CONSTANT VARCHAR2(200) := G_REGEX_START_SINGLE_COMMENT  
                                                          ||'|'||G_REGEX_START_MULTI_COMMENT
                                                          ||'|'||G_REGEX_START_STRING
                                                          ||'|'||G_REGEX_START_ADV_STRING;
      
        G_REGEX_SINGLE_LINE_ANNOTATION   CONSTANT VARCHAR2(50)  :=    '.*';
        G_REGEX_SINGLE_LINE_COMMENT      CONSTANT VARCHAR2(50)  :=    '--.*';
        G_REGEX_MULTI_LINE_COMMENT       CONSTANT VARCHAR2(50)  :=    '/\*.*?\*/'; --'/\*(\s|\S)*?\*/';
        G_REGEX_MULTI_LINE_STRING         CONSTANT VARCHAR2(50)  :=    '\''.*?\''';
        G_REGEX_MULTI_LINE_ADV_STRING     CONSTANT VARCHAR2(100) :=    'Q\''\[.*?\]\''|Q\''\{.*?\}\''|Q\''\(.*?\)\''|Q\''\<.*?\>\''|Q\''(\S).*?\1\''';
   
      BEGIN
 
        --Searching for the start of a comment or string
        l_keyword :=  get_next(i_stop       => G_REGEX_START_COMMENT_OR_STR
                              ,i_upper      => TRUE   );
   
        sm_logger.note(l_node, 'l_keyword' ,l_keyword); 
      
        CASE 
  
          WHEN regex_match(l_keyword , G_REGEX_START_SINGLE_COMMENT)  THEN 


  
            --Check for an annotation                         
            IF regex_match(l_keyword , G_REGEX_START_ANNOTATION) THEN                           
              sm_logger.info(l_node, 'Annotation');         
              --ANNOTATION          
              go_past;          
              extract_comment(i_mask     => G_REGEX_SINGLE_LINE_ANNOTATION          
                             ,i_modifier => 'i');   
  
            ELSIF regex_match(l_keyword , G_REGEX_SHOW_ME) THEN                           
              sm_logger.info(l_node, 'Show Me');         
              --SHOW ME
              --Just ignore this till later.      
              go_past;  
  
            ELSIF regex_match(l_keyword , G_REGEX_ROW_COUNT) THEN                           
              sm_logger.info(l_node, 'Rowcount');         
              --ROWCOUNT
              --Just ignore this till later.      
              go_past;  
  
  
   
            ELSE
 
              --Just a comment
              sm_logger.info(l_node, 'Single Line Comment');         
              --REMOVE SINGLE LINE COMMENTS 
              --Find "--" and remove chars upto EOL     
              extract_comment(i_mask     => G_REGEX_SINGLE_LINE_COMMENT
                             ,i_modifier => 'i');
    
            END IF;
  
 
          WHEN regex_match(l_keyword , G_REGEX_START_MULTI_COMMENT)  THEN  
            sm_logger.info(l_node, 'Multi Line Comment');  
            --REMOVE MULTI-LINE COMMENTS 
            --Find "/*" and remove upto "*/" 
            extract_comment(i_mask => G_REGEX_MULTI_LINE_COMMENT);
                            -- ,i_modifier => 'i');
 
          WHEN regex_match(l_keyword , G_REGEX_START_ADV_STRING)  THEN  
            sm_logger.info(l_node, 'Multi Line Adv Quote');  
            --REMOVE ADVANCED STRINGS - MULTI_LINE
            --Find "q'[" and remove to next "]'", variations include [] {} <> () and any single printable char.
            extract_strings(i_mask => G_REGEX_MULTI_LINE_ADV_STRING);
              
          WHEN regex_match(l_keyword , G_REGEX_START_STRING)  THEN  
            sm_logger.info(l_node, 'Multi Line Simple Quote');
            --REMOVE SIMPLE STRINGS - MULTI_LINE
            --Find "'" and remove to next "'"     
            extract_strings(i_mask => G_REGEX_MULTI_LINE_STRING);
          
 
          ELSE 
            EXIT;
          
          END CASE; 
  
        END;
 
  
    END LOOP; 
  
    sm_logger.comment(l_node, 'No more comments or strings.'); 
  
  EXCEPTION
    WHEN OTHERS THEN
      sm_logger.warn_error(l_node);
      RAISE;
  END;

--------------------------------------------------------------------
-- using_aop
--------------------------------------------------------------------  
/** PUBLIC
* Determine whether the woven version is currently installed in the database.
* @return Yes/No
*/
  function using_aop(i_object_name IN VARCHAR2
                    ,i_object_type IN VARCHAR2 DEFAULT 'PACKAGE BODY') return varchar2 is

    CURSOR cu_dba_source is
    select 1
    from dba_source
    where NAME = i_object_name
    and type   = i_object_type
    and (text like '%Logging by sm_weaver%' or text like '%@AOP_LOG_WOVEN%');

    l_dummy number;
    l_found boolean;

  BEGIN
   
    open cu_dba_source;
    fetch cu_dba_source into l_dummy;
    l_found := cu_dba_source%FOUND;
    close cu_dba_source;

    IF l_found then
      return 'Yes';
    ELSE
      return 'No';  
    END IF;
 

  END;
 
end sm_weaver;
/
show error;

set define on;

alter trigger sm_weaver_trg enable;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

--Most likely will not want logging enabled on the sm_weaver
execute sm_api.set_module_disabled(i_module_name => 'sm_weaver');

