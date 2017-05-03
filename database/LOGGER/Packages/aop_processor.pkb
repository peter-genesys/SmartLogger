--alter trigger aop_processor_trg disable;

--Ensure no inlining so ms_logger can be used
alter session set plsql_optimize_level = 1;

set define off;

create or replace package body aop_processor is
  -- AUTHID CURRENT_USER - see spec
  -- @AOP_NEVER
 
  g_package_name        CONSTANT VARCHAR2(30) := 'aop_processor'; 
 
  g_during_advise boolean:= false;
  
  g_aop_never     CONSTANT VARCHAR2(30) := '@AOP_NEVER';
  g_aop_directive CONSTANT VARCHAR2(30) := '@AOP_LOG'; 
 
  g_for_aop_html      boolean := false;
 
  g_weave_start_time  date;
  
  G_TIMEOUT_SECS_PER_1000_LINES CONSTANT NUMBER := 180; 
  g_weave_timeout_secs NUMBER;   
  
  g_initial_indent     constant integer := 0;
  
  TYPE clob_stack_typ IS
  TABLE OF CLOB
  INDEX BY BINARY_INTEGER;

  g_comment_stack clob_stack_typ;
  g_quote_stack   clob_stack_typ;
 
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
  G_PARAM_NAME_PADDING CONSTANT NUMBER := 32;


  TYPE var_list_typ IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(106);  
  
  TYPE param_list_typ IS TABLE OF VARCHAR2(106) INDEX BY BINARY_INTEGER;  
  
  g_indent_spaces     CONSTANT INTEGER := 2;

  g_end_user          VARCHAR2(30); --owner for normal packages, invoker for invoker packages.
 
  ----------------------------------------------------------------------------
  -- REGULAR EXPRESSIONS
  ----------------------------------------------------------------------------
  --Word Char  = non-quoted Oracle identifier chars include "A-Z,_,#,$"
  G_REGEX_WORD_CHAR      CONSTANT VARCHAR2(50) := '(\w|\#|\$)'; 
  --Word is at least 1 Word Char
  G_REGEX_WORD           CONSTANT VARCHAR2(50) := G_REGEX_WORD_CHAR||'+';  
  G_REGEX_2WORDS         CONSTANT VARCHAR2(50) := G_REGEX_WORD||'\.'||G_REGEX_WORD;
  G_REGEX_2_QUOTED_WORDS CONSTANT VARCHAR2(50) := '"*'||G_REGEX_WORD||'"*\."*'||G_REGEX_WORD||'"*'; --quotes are optional    
 
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
 
  --Opening Blocks
  G_REGEX_DECLARE       CONSTANT VARCHAR2(50) := '\s *DECLARE\s';
  G_REGEX_BEGIN         CONSTANT VARCHAR2(50) := '\s *BEGIN\s';
  G_REGEX_LOOP          CONSTANT VARCHAR2(50) := '\s *LOOP\s';
  G_REGEX_CASE          CONSTANT VARCHAR2(50) := '\s *CASE\s';
  G_REGEX_IF            CONSTANT VARCHAR2(50) := '\s *IF\s';
  --Neutral Blocks
  G_REGEX_ELSE          CONSTANT VARCHAR2(50) := '\sELSE\s';
  G_REGEX_ELSIF         CONSTANT VARCHAR2(50) := '\sELSIF\s';
  G_REGEX_WHEN          CONSTANT VARCHAR2(50) := '\sWHEN\s';
  G_REGEX_THEN          CONSTANT VARCHAR2(50) := '\sTHEN\s';
  G_REGEX_EXCEPTION     CONSTANT VARCHAR2(50) := '\sEXCEPTION\s';
  --Closing Blocks
  G_REGEX_END_BEGIN     CONSTANT VARCHAR2(50) := '\sEND\s*?'||G_REGEX_WORD_CHAR||'*?\s*?;';    --END(any whitespace)(any wordschars)(any whitespace)SEMI-COLON
  G_REGEX_END_LOOP      CONSTANT VARCHAR2(50) := '\sEND\s+?LOOP\s*?;';
  G_REGEX_END_CASE      CONSTANT VARCHAR2(50) := '\sEND\s+?CASE\s*?;';
  G_REGEX_END_CASE_EXPR CONSTANT VARCHAR2(50) := '\sEND\W'; 
  G_REGEX_END_IF        CONSTANT VARCHAR2(50) := '\sEND\s+?IF\s*?;';

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
  --                                          ||'|'||G_REGEX_THEN     
                                            ||'|'||G_REGEX_EXCEPTION                                            
                                            ;      
  G_REGEX_WHEN_OTHERS_THEN          CONSTANT VARCHAR2(50) := '\sWHEN\s+?OTHERS\s+?THEN\s';
  G_REGEX_WHEN_EXCEPT_THEN          CONSTANT VARCHAR2(50) := '\sWHEN\s+?('||G_REGEX_WORD||'\s+?)+?THEN\s';
 
  G_REGEX_CLOSE        CONSTANT VARCHAR2(200) :=  G_REGEX_END_BEGIN    
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
  
  G_REGEX_SUPPORTED_TYPES CONSTANT VARCHAR2(200) := '(NUMBER|INTEGER|POSITIVE|BINARY_INTEGER|PLS_INTEGER'
                                                  ||'|DATE|VARCHAR2|VARCHAR|CHAR|BOOLEAN|CLOB)';
 
  G_REGEX_START_ANNOTATION      CONSTANT VARCHAR2(50) :=  '--(""|\?\?|!!|##)';
  
  G_REGEX_STASHED_COMMENT    CONSTANT VARCHAR2(50) := '<<comment\d+>>';
  G_REGEX_COMMENT            CONSTANT VARCHAR2(50) := '--""';
  G_REGEX_INFO               CONSTANT VARCHAR2(50) := '--\?\?';
  G_REGEX_WARNING            CONSTANT VARCHAR2(50) := '--!!';
  G_REGEX_FATAL              CONSTANT VARCHAR2(50) := '--##';  

 
 
  ----------------------------------------------------------------------------
  -- COLOUR CODES
  ----------------------------------------------------------------------------
 
  G_COLOUR_PROG_UNIT        CONSTANT VARCHAR2(10) := '#9999FF';
  G_COLOUR_BLOCK            CONSTANT VARCHAR2(10) := '#FFCC99';
  G_COLOUR_COMMENT          CONSTANT VARCHAR2(10) := '#FFFF99';
  G_COLOUR_QUOTE            CONSTANT VARCHAR2(10) := '#99CCFF';
  G_COLOUR_PARAM            CONSTANT VARCHAR2(10) := '#FF99FF';
  G_COLOUR_NODE             CONSTANT VARCHAR2(10) := '#66FFFF';
  G_COLOUR_ERROR            CONSTANT VARCHAR2(10) := '#FF6600';
  G_COLOUR_SPLICE           CONSTANT VARCHAR2(10) := '#FFCC66';
  G_COLOUR_PU_NAME          CONSTANT VARCHAR2(10) := '#99FF99';
  G_COLOUR_OBJECT_NAME      CONSTANT VARCHAR2(10) := '#FFCC00';
  G_COLOUR_PKG_BEGIN        CONSTANT VARCHAR2(10) := '#CCCC00'; 
  G_COLOUR_GO_PAST          CONSTANT VARCHAR2(10) := '#FF9999'; 
  G_COLOUR_BRACKETS         CONSTANT VARCHAR2(10) := '#FF5050'; 
  G_COLOUR_EXCEPTION_BLOCK  CONSTANT VARCHAR2(10) := '#FF9933'; 
  G_COLOUR_JAVA             CONSTANT VARCHAR2(10) := '#33CCCC'; 
  G_COLOUR_UNSUPPORTED      CONSTANT VARCHAR2(10) := '#999966'; 
  G_COLOUR_ANNOTATION       CONSTANT VARCHAR2(10) := '#FFCCFF'; 
  G_COLOUR_BIND_VAR         CONSTANT VARCHAR2(10) := '#FFFF00';
  G_COLOUR_VAR              CONSTANT VARCHAR2(10) := '#99FF66';
  G_COLOUR_NOTE             CONSTANT VARCHAR2(10) := '#00FF99';
  G_COLOUR_VAR_LINE         CONSTANT VARCHAR2(10) := '#00CCFF';
 

  --------------------------------------------------------------------
  -- regex_match
  --------------------------------------------------------------------
  FUNCTION regex_match(i_source_string   IN CLOB
                      ,i_pattern         IN VARCHAR2
                      ,i_match_parameter IN VARCHAR2 DEFAULT 'i') RETURN BOOLEAN IS
  BEGIN
    RETURN REGEXP_LIKE(i_source_string,i_pattern,i_match_parameter);
  END;
 
  --------------------------------------------------------------------
  -- table_owner
  --------------------------------------------------------------------
  FUNCTION table_owner(i_table_name IN VARCHAR2) RETURN VARCHAR2 IS
    
    -- find the most appropriate table owner.
    -- Of All Tables (that the end user can see)
    -- Select 1 owner, with preference to the end user
    CURSOR cu_owner IS
    select owner
    from   all_tables
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
  -- calc_indent
  --------------------------------------------------------------------
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

 
  function elapsed_time_secs return integer is
  begin
    return (sysdate - g_weave_start_time) * 24 * 60 * 60;
  end;
 

  FUNCTION escape_html(i_text   IN CLOB ) RETURN CLOB IS

    l_result CLOB;

  BEGIN

    l_result := REPLACE(i_text  , '&', '&amp');
    l_result := REPLACE(l_result, '<', '&lt');
    l_result := REPLACE(l_result, '>', '&gt');

    RETURN l_result;

  END;



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
 
  procedure check_timeout is
  --The timeout is used to protect against infinite recursion or iteration.
  begin
    if elapsed_time_secs >  g_weave_timeout_secs then
    raise x_weave_timeout;
  end if;
  
  end;
  
  procedure set_weave_timeout is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'set_weave_timeout');  
    l_weave_line_count INTEGER;
 
  BEGIN
    --Line Count derived from length of CLOB minus length of CLOB-without-CR
  l_weave_line_count := LENGTH(g_code) - LENGTH(REPLACE(g_code,chr(10)));
    ms_logger.note(l_node, 'l_weave_line_count ',l_weave_line_count );
    g_weave_timeout_secs := ROUND(l_weave_line_count/1000*G_TIMEOUT_SECS_PER_1000_LINES)+2;
    ms_logger.note(l_node, 'g_weave_timeout_secs ',g_weave_timeout_secs );
  g_weave_start_time := SYSDATE;
 
  END;
 
  --------------------------------------------------------------------
  -- during_advise
  --------------------------------------------------------------------
  
  function during_advise return boolean is
  begin 
    return g_during_advise;
  end during_advise;

 
  --------------------------------------------------------------------
  -- validate_source
  --------------------------------------------------------------------
  function validate_source(i_name        IN VARCHAR2
                         , i_type        IN VARCHAR2
                         , i_text        IN CLOB
                         , i_aop_ver     IN VARCHAR2
                         , i_compile     IN BOOLEAN  
            ) RETURN boolean IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'validate_source');              
                      
    l_aop_source    aop_source%ROWTYPE;    
    PRAGMA AUTONOMOUS_TRANSACTION;
 
  BEGIN     
 
    ms_logger.param(l_node, 'i_name      '          ,i_name   );
    ms_logger.param(l_node, 'i_type      '          ,i_type      );
    --ms_logger.param(l_node, 'i_text    '          ,i_text          ); --too big.
    ms_logger.param(l_node, 'i_aop_ver   '           ,i_aop_ver      );
    ms_logger.param(l_node, 'i_compile   '           ,i_compile      );

    --Prepare record.
    l_aop_source.name          := i_name;
    l_aop_source.type          := i_type;
    l_aop_source.aop_ver       := i_aop_ver;
    l_aop_source.text          := i_text;
    l_aop_source.load_datetime := sysdate;
    l_aop_source.valid_yn      := 'N';
    l_aop_source.result        := 'Success.';
  
    IF i_compile THEN 
 
      begin
        execute immediate 'alter session set plsql_optimize_level = 1';
        --execute immediate 'set scan off';
      
          execute immediate i_text;  --11G CLOB OK
          l_aop_source.valid_yn := 'Y';
      exception
          when others then
          l_aop_source.result   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
           ms_logger.warn_error(l_node);   
        
        --Output Show Errors info
            FOR l_error IN (select line||' '||text  error_line
                        from USER_ERRORS 
                        where NAME = i_name 
                        AND   type = i_type)
            LOOP
              DBMS_OUTPUT.PUT_LINE(l_error.error_line);
              ms_logger.warning(l_node,l_error.error_line); 
              l_aop_source.result := l_aop_source.result ||chr(10)||l_error.error_line;
            END LOOP;
    
      end;
 
    end if;
 
    ins_upd_aop_source(i_aop_source => l_aop_source);
       
    COMMIT;
    
    RETURN NOT i_compile OR l_aop_source.valid_yn = 'Y';
 
  exception
      when others then
         ms_logger.oracle_error(l_node);  
         RETURN FALSE;	   
  
  END;
 
 

  --------------------------------------------------------------------
  -- splice
  --------------------------------------------------------------------
  procedure splice( p_code     in out clob
                   ,p_new_code in clob
                   ,p_pos      in out number
                   ,p_indent   in number   default null
                   ,p_colour   in varchar2 default null ) IS
                   
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'splice');  
    l_new_code        CLOB;
    l_colour          VARCHAR2(10);
    l_leading_nl_offset       INTEGER := 0; --NO OFFSET 
    l_trailing_nl_offset       INTEGER := 0; --NO OFFSET
    l_next_char       CHAR(1);
  
  
    l_word_char_pos   INTEGER;
    l_nl_pos          INTEGER;


  BEGIN

    --ms_logger.param(l_node, 'p_code'          ,p_code );
    --ms_logger.param(l_node, 'LENGTH(p_code)'  ,LENGTH(p_code)  );
    --ms_logger.param(l_node, 'p_new_code'      ,p_new_code);
    ms_logger.param(l_node, 'p_pos     '       ,p_pos     );
    ms_logger.param(l_node, 'p_indent     '    ,p_indent     );
    ms_logger.param(l_node, 'p_colour  '       ,p_colour     );

    ms_logger.note(l_node, 'g_for_aop_html     '     ,g_for_aop_html     );

    l_new_code := f_colour(i_text   => p_new_code
                          ,i_colour => NVL(p_colour, G_COLOUR_SPLICE));
    ms_logger.note(l_node, 'l_new_code     '     ,l_new_code     );
  

    --ms_logger.note(l_node, 'char @ intial pos-2     '   ,substr(p_code, p_pos-2, 1)||ascii(substr(p_code, p_pos-2, 1)));
    --ms_logger.note(l_node, 'char @ intial pos-1     '   ,substr(p_code, p_pos-1, 1)||ascii(substr(p_code, p_pos-1, 1)));
    --ms_logger.note(l_node, 'char @ intial pos       '   ,substr(p_code, p_pos, 1)||ascii(substr(p_code, p_pos, 1)));
    --ms_logger.note(l_node, 'char @ intial pos+1     '   ,substr(p_code, p_pos+1, 1)||ascii(substr(p_code, p_pos+1, 1)));
    --ms_logger.note(l_node, 'char @ intial pos+2     '   ,substr(p_code, p_pos+2, 1)||ascii(substr(p_code, p_pos+2, 1)));

    IF p_indent is not null then
      ----INJECT LINE
 
      IF ascii(substr(p_code, p_pos-1, 1)) = 10 then
        --Current char is a NL - we want to skip it in the splice, since we are going to add a NL infront of the splice anyway.
        ms_logger.comment(l_node, 'Seting the NL offset to remove 1 NL');
        l_leading_nl_offset := 1;
      END IF;
 
      --Apply a leading new line and indent by p_indent spaces
      --l_new_code := replace(chr(10)||l_new_code,chr(10),chr(10)||rpad(' ',(p_indent-1)*g_indent_spaces+g_indent_spaces,' '));
      l_new_code := replace(chr(10)||l_new_code,chr(10),chr(10)||rpad(' ',p_indent+g_indent_spaces,' '));
 
      IF REGEXP_INSTR(p_code,G_REGEX_WORD_CHAR,p_pos) < INSTR(p_code,chr(10),p_pos) THEN
        --Add a trailing newline, because there is a word-char before the next NL.
        ms_logger.comment(l_node, 'Add a trailing newline');
        l_new_code := l_new_code||chr(10);
        l_trailing_nl_offset := 1;
      END IF;
  
    END IF; 

    --p_pos - the current position is taken to indicate the next character to be read eg by regex_substr
    --so when you splice with current position, it is to be between pos-1 and pos
    p_code:= substr(p_code, 1, p_pos-1-l_leading_nl_offset)
           ||l_new_code
           ||substr(p_code, p_pos);

    p_pos := p_pos + length(l_new_code)-l_leading_nl_offset-l_trailing_nl_offset;  

    --ms_logger.note(l_node, 'char @ final pos-2     '   ,substr(p_code, p_pos-2, 1)||ascii(substr(p_code, p_pos-2, 1)));
    --ms_logger.note(l_node, 'char @ final pos-1     '   ,substr(p_code, p_pos-1, 1)||ascii(substr(p_code, p_pos-1, 1)));
    --ms_logger.note(l_node, 'char @ final pos       '   ,substr(p_code, p_pos, 1)||ascii(substr(p_code, p_pos, 1)));
    --ms_logger.note(l_node, 'char @ final pos+1     '   ,substr(p_code, p_pos+1, 1)||ascii(substr(p_code, p_pos+1, 1)));
    --ms_logger.note(l_node, 'char @ final pos+2     '   ,substr(p_code, p_pos+2, 1)||ascii(substr(p_code, p_pos+2, 1)));
    
    --ms_logger.note(l_node, 'p_code     '     ,p_code     );
    --ms_logger.note(l_node, 'p_pos     '      ,p_pos     );

  END;
  
  --------------------------------------------------------------------
  -- wedge
  --------------------------------------------------------------------
    PROCEDURE wedge( i_new_code in varchar2
                    ,i_colour   in varchar2 default null) IS
  
  BEGIN
    IF i_new_code IS NOT NULL THEN
      splice( p_code      => g_code    
             ,p_new_code  => i_new_code
             ,p_pos       => g_current_pos
             ,p_colour    => i_colour  );
    END IF;      
   
  END;
  
  --------------------------------------------------------------------
  -- inject
  --------------------------------------------------------------------
  
    PROCEDURE inject( i_new_code in varchar2
                     ,i_indent   in number
                     ,i_colour   in varchar2 default null) IS
  BEGIN
    IF i_new_code IS NOT NULL THEN
      --g_current_pos := g_current_pos - 1;
      splice( p_code      => g_code    
             ,p_new_code  => i_new_code
             ,p_pos       => g_current_pos     
             ,p_indent    => i_indent
             ,p_colour    => i_colour  );  
    END IF;      
  END;
  

--------------------------------------------------------------------------------- 
-- ATOMIC
--------------------------------------------------------------------------------- 
 
FUNCTION trim_whitespace(i_words IN CLOB) RETURN CLOB IS
  G_REGEX_LEADING_TRAILING_WHITE CONSTANT VARCHAR2(20) := '^\s|\s$';
BEGIN
  RETURN TRIM(REGEXP_REPLACE(i_words,G_REGEX_LEADING_TRAILING_WHITE,''));
END;

FUNCTION flatten(i_words IN VARCHAR2) RETURN VARCHAR2 IS
  G_REGEX_WHITE CONSTANT VARCHAR2(20) := '\s';
BEGIN
  RETURN REGEXP_REPLACE(i_words,G_REGEX_WHITE,' ');
END;


FUNCTION REGEXP_INSTR_NOT0(i_string           IN CLOB  
                          ,i_pattern          IN VARCHAR2
                          ,i_position         IN INTEGER  DEFAULT NULL
                          ,i_occurrence       IN INTEGER  DEFAULT NULL
                          ,i_return_position  IN INTEGER  DEFAULT NULL
                          ,i_regexp_modifier  IN VARCHAR2 DEFAULT NULL) RETURN INTEGER IS
--Overload the std oracle built-in, but this version does not return 0
--REGEXP_INSTR(string, pattern [, position [, occurrence [, return_position [, regexp_modifier]]]])

  l_result INTEGER;
 
BEGIN
  l_result := REGEXP_INSTR(i_string, i_pattern, i_position , i_occurrence , i_return_position , i_regexp_modifier );

  IF l_result = 0 THEN
    RETURN 10000000;
  ELSE  
    RETURN l_result;
  END IF;
 
END;  
 

--------------------------------------------------------------------------------- 
-- get_next - return first matching string
---------------------------------------------------------------------------------
-- Search is split into i_srch_before, i_stop, i_srch_after in that order of priority.
-- l_any_match is the match from any of the componants
-- i_modifier is applied to the std REGEXP_SUBSTR search
-- g_upto_pos is the start of the match
-- g_past_pos is the end of the match
-- IF i_trim_result    THEN stripped of upto 1 leading and trailing whitespace
-- IF i_trim_pointers  THEN g_upto_pos and g_past_pos will point to the start and stop of the trimmed match
-- IF match FROM i_srch_before/after THEN g_current_pos will advance to g_past_pos, otherwise g_current_pos does not change.
-- IF i_upper    THEN  result is in UPPER
-- IF i_lower    THEN  result is in LOWER
-- IN HTML mode i_colour determines the highlighting used when the match is consumed (g_current_pos set to g_past_pos)
-- IF i_raise_error and NO MATCH, and exception is raises, and the search string written out.
---------------------------------------------------------------------------------

FUNCTION get_next(i_srch_before        IN VARCHAR2 DEFAULT NULL
                 ,i_srch_after         IN VARCHAR2 DEFAULT NULL 
                 ,i_stop               IN VARCHAR2 DEFAULT NULL
                 ,i_modifier           IN VARCHAR2 DEFAULT 'i'
                 ,i_upper              IN BOOLEAN  DEFAULT FALSE
                 ,i_lower              IN BOOLEAN  DEFAULT FALSE
                 ,i_colour             IN VARCHAR2 DEFAULT NULL 
                 ,i_raise_error        IN BOOLEAN  DEFAULT FALSE
                 ,i_trim_pointers      IN BOOLEAN  DEFAULT TRUE
                 ,i_trim_result        IN BOOLEAN  DEFAULT FALSE ) return CLOB IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'get_next'); 
  
  l_any_match             CLOB;
  l_trimmed_any_match     CLOB;
  l_colour_either_match   CLOB;
  l_search_match          CLOB;
  l_result                CLOB;
  l_any_search            CLOB;
  l_search                CLOB;

  l_trim_upto_pos         INTEGER;

  l_srch_before_pos       INTEGER;
  l_srch_after_pos        INTEGER;


  l_use_srch_before          BOOLEAN := TRUE;


  PROCEDURE consume_search IS
  BEGIN
    ms_logger.comment(l_node, 'Consume search componant');
    l_colour_either_match := f_colour(i_text   => l_trimmed_any_match  
                                     ,i_colour => i_colour);
 
    g_code := SUBSTR(g_code,1,g_upto_pos-1)
            ||l_colour_either_match
            ||SUBSTR(g_code,g_past_pos)  ;
       
    --Now advance the past_pos   
    g_past_pos := g_upto_pos + LENGTH(l_colour_either_match);
    --Current pos is now the past_pos
    g_current_pos := g_past_pos;
  END;
 

BEGIN
  check_timeout; --GET_NEXT
  ms_logger.param(l_node, 'i_srch_before'     ,i_srch_before);
  ms_logger.param(l_node, 'i_srch_after'    ,i_srch_after);
  ms_logger.param(l_node, 'i_stop'       ,i_stop);
  ms_logger.param(l_node, 'g_current_pos',g_current_pos);

  

  --Workaround - when i_srch_before gets too long -> ORA-03113: end-of-file on communication channel
  --So split into 2 searches.
  --Now i_srch_after will search after i_stop
  IF i_srch_before IS NOT NULL AND i_srch_after IS NULL THEN
    l_use_srch_before := TRUE;

  ELSIF i_srch_before IS NULL AND i_srch_after IS NOT NULL THEN  
    l_use_srch_before := FALSE;

  ELSIF i_srch_before IS NOT NULL AND i_srch_after IS NOT NULL THEN 

    ms_logger.comment(l_node, 'Choosing search param');
 
    l_srch_before_pos  := REGEXP_INSTR_NOT0(g_code,i_srch_before,g_current_pos,1,0,i_modifier);
    l_srch_after_pos := REGEXP_INSTR_NOT0(g_code,i_srch_after,g_current_pos,1,0,i_modifier);

    ms_logger.note(l_node, 'l_srch_before_pos',l_srch_before_pos);
    ms_logger.note(l_node, 'l_srch_after_pos',l_srch_after_pos);
 
    l_use_srch_before := l_srch_before_pos < l_srch_after_pos;
 
  end if;
 
  If l_use_srch_before THEN
      ms_logger.info(l_node, 'Using i_srch_before');
      l_search := i_srch_before;
      l_any_search := TRIM('|' FROM i_srch_before ||'|'||i_stop);
    else
      ms_logger.info(l_node, 'Using i_srch_after');
      l_search := i_srch_after;
      l_any_search := TRIM('|' FROM i_stop ||'|'||i_srch_after);
  end if;

 
  ms_logger.note(l_node, 'l_any_search',l_any_search  );
  ms_logger.note_length(l_node, 'l_any_search',l_any_search  );
 
  --Keep the original "either" match
  l_any_match := REGEXP_SUBSTR(g_code,l_any_search,g_current_pos,1,i_modifier);
  ms_logger.note_clob(l_node, 'l_any_match',l_any_match  );
 
  --Should we raise an error?
  IF l_any_match IS NULL AND i_raise_error THEN
    ms_logger.fatal(l_node, 'String missing '||l_any_search);
    wedge( i_new_code => 'STRING NOT FOUND '||l_any_search
          ,i_colour   => G_COLOUR_ERROR);
    RAISE x_string_not_found;
  
  END IF; 
  
  --Calculate the new positions.  
  g_upto_pos := REGEXP_INSTR(g_code,l_any_search,g_current_pos,1,0,i_modifier);
  g_past_pos := REGEXP_INSTR(g_code,l_any_search,g_current_pos,1,1,i_modifier);     
  ms_logger.note(l_node, 'g_upto_pos',g_upto_pos  );
 
  
  l_trimmed_any_match := trim_whitespace(l_any_match);
  
  IF i_trim_result THEN
    l_result := l_trimmed_any_match; 
  ELSE
   l_result := l_any_match;
  END IF; 
 
  if l_trimmed_any_match IS NOT NULL AND i_trim_pointers THEN
  
    --Now that we've trimmed the match, lets change the pointers to suit.
    --Not a regex search, since just searching for the known string.
    ms_logger.info(l_node, 'Shifting pointers to trimmed match.');
    g_upto_pos := INSTR(g_code,l_trimmed_any_match,g_upto_pos);
    g_past_pos := g_upto_pos + LENGTH(l_trimmed_any_match);
    ms_logger.note(l_node, 'g_upto_pos',g_upto_pos  );
    ms_logger.note(l_node, 'g_past_pos',g_past_pos  );   
  
  END IF;
 
 
  
  IF  l_use_srch_before AND regex_match(l_any_match,l_search,i_modifier) THEN
    ms_logger.info(l_node, 'Matched on the search componant1');
    consume_search;
 
  ELSIF regex_match(l_any_match,i_stop,i_modifier) THEN
    ms_logger.info(l_node, 'Matched on the stop componant');
    --Matched on the stop componant, don't consume - ie don't advance the pointer.
    NULL;
  ELSIF NOT l_use_srch_before AND regex_match(l_any_match,l_search,i_modifier) THEN
    ms_logger.info(l_node, 'Matched on the search componant2');
    consume_search;  
  END IF;
 
 
  --ms_logger.param(l_node, 'g_current_pos',g_current_pos);
  --ms_logger.note(l_node, 'char @ g_current_pos -2     '   ,substr(g_code, g_current_pos-2, 1)||ascii(substr(g_code, g_current_pos-2, 1)));
  --ms_logger.note(l_node, 'char @ g_current_pos -1     '   ,substr(g_code, g_current_pos-1, 1)||ascii(substr(g_code, g_current_pos-1, 1)));
  --ms_logger.note(l_node, 'char @ g_current_pos        '   ,substr(g_code, g_current_pos, 1)||ascii(substr(g_code, g_current_pos, 1)));
  --ms_logger.note(l_node, 'char @ g_current_pos +1     '   ,substr(g_code, g_current_pos+1, 1)||ascii(substr(g_code, g_current_pos+1, 1)));
  --ms_logger.note(l_node, 'char @ g_current_pos +2     '   ,substr(g_code, g_current_pos+2, 1)||ascii(substr(g_code, g_current_pos+2, 1)));
 
  ms_logger.note_clob(l_node, 'l_result',l_result); 

  ms_logger.note_clob(l_node, 'l_result with LF,CR,SP' ,REPLACE(
                                                        REPLACE(
                                                        REPLACE(l_result,chr(10),'LF')
                                                                        ,chr(13),'CR')
                                                                        ,chr(32),'SP') ); 
 

  IF i_upper THEN   
    RETURN UPPER(l_result);
  ELSIF i_lower THEN
    RETURN LOWER(l_result);
  ELSE
    RETURN l_result;
  END IF; 

exception
  when others then
    ms_logger.warn_error(l_node);
    raise;

END get_next;
 
 

--------------------------------------------------------------------------------- 
-- go_past
---------------------------------------------------------------------------------
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
PROCEDURE go_upto(i_stop          IN VARCHAR2 DEFAULT NULL
                 ,i_modifier      IN VARCHAR2 DEFAULT 'i'
                 ,i_trim_pointers IN BOOLEAN DEFAULT FALSE
                 ) IS
  l_dummy CLOB;
BEGIN

  IF i_stop is null then
    --just goto the position found during last get_next
    g_current_pos := g_upto_pos;
  ELSE
     l_dummy := get_next(i_stop           => i_stop       
                        ,i_modifier       => i_modifier   
                        ,i_trim_pointers  => i_trim_pointers     
                        ,i_raise_error    => TRUE );
  
     g_current_pos := g_upto_pos;
 
  END IF;
 
 
END;

--------------------------------------------------------------------------------- 
-- get_next_object_name
---------------------------------------------------------------------------------
FUNCTION get_next_object_name RETURN VARCHAR2 IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'get_next_object_name'); 
  l_object_name VARCHAR2(100);

BEGIN
  l_object_name := get_next(i_srch_before  => G_REGEX_2_QUOTED_WORDS
                                  ||'|'||G_REGEX_WORD
                           ,i_lower   => TRUE        
                           ,i_colour  => G_COLOUR_OBJECT_NAME
                           ,i_raise_error  => TRUE);
  --Check for double-word
  IF regex_match(l_object_name , G_REGEX_2_QUOTED_WORDS) THEN
    ms_logger.comment(l_node, 'Double word name - get 2nd word'); 
    l_object_name := REGEXP_SUBSTR(l_object_name,G_REGEX_WORD,1,2,'i');
 
  END IF;

  RETURN l_object_name;

END;  


--------------------------------------------------------------------------------- 
-- FORWARD DECLARATIONS
--------------------------------------------------------------------------------- 
    
--------------------------------------------------------------------------------- 
-- stash_comments_and_quotes - Forward Declaration
---------------------------------------------------------------------------------
procedure stash_comments_and_quotes;

--------------------------------------------------------------------------------- 
-- restore_comments_and_quotes - Forward Declaration
---------------------------------------------------------------------------------
procedure restore_comments_and_quotes;

--------------------------------------------------------------------------------- 
-- AOP_prog_units - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_units(i_indent   IN INTEGER
                        ,i_var_list IN var_list_typ);


--------------------------------------------------------------------------------- 
-- AOP_pu_block - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_pu_block(i_prog_unit_name IN VARCHAR2
                      ,i_indent         IN INTEGER
                      ,i_param_list     IN param_list_typ
                      ,i_param_types    IN param_list_typ
                      ,i_var_list       IN var_list_typ );

--------------------------------------------------------------------------------- 
-- AOP_block
---------------------------------------------------------------------------------
PROCEDURE AOP_block(i_indent         IN INTEGER
                   ,i_regex_end      IN VARCHAR2
                   ,i_var_list       IN var_list_typ );                      
                      
--------------------------------------------------------------------------------- 
-- END FORWARD DECLARATIONS
---------------------------------------------------------------------------------         
    

 
--------------------------------------------------------------------------------- 
-- AOP_pu_params
---------------------------------------------------------------------------------
PROCEDURE AOP_pu_params(io_param_list  IN OUT param_list_typ
                       ,io_param_types IN OUT param_list_typ
                       ,io_var_list    IN OUT var_list_typ ) is
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_params'); 
 
  l_param_line           CLOB;
  
  l_param_name  VARCHAR2(30);
  l_param_type  VARCHAR2(106);
  l_table_name  VARCHAR2(30);
  l_column_name VARCHAR2(30);
  l_table_owner VARCHAR2(30);
 
  l_keyword              CLOB;
  l_bracket              VARCHAR2(50);
  x_out_param            EXCEPTION;
  x_unsupported_data_type EXCEPTION;
 
  l_bracket_count        INTEGER;
  
  l_in_var               BOOLEAN;
  l_out_var              BOOLEAN;
  
  --This should be expanded to cover G_REGEX_2WORDS etc
  G_REGEX_PARAM_LINE      CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+(IN\s+)?(OUT\s+)?('||G_REGEX_WORD||')';
  G_REGEX_NAME_IN_OUT     CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+(IN\s+)?(OUT\s+)?';

 
    
  l_var_def                     CLOB;
  G_REGEX_VAR_DEF_LINE          CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||G_REGEX_SUPPORTED_TYPES;
  G_REGEX_REC_VAR_DEF_LINE      CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||'?)%ROWTYPE';
  G_REGEX_TAB_COL_VAR_DEF_LINE  CONSTANT VARCHAR2(200) := G_REGEX_NAME_IN_OUT||'('||G_REGEX_WORD||'?)\.('||G_REGEX_WORD||'?)%TYPE';
  
   
    
  PROCEDURE store_var_def(i_param_name IN VARCHAR2
                         ,i_param_type IN VARCHAR2  
                         ,i_in_var     IN BOOLEAN
                         ,i_out_var    IN BOOLEAN ) IS
                         
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'store_var_def'); 
                         
  BEGIN
  
    ms_logger.param(l_node, 'i_param_name' ,i_param_name); 
    ms_logger.param(l_node, 'i_param_type' ,i_param_type); 
    ms_logger.param(l_node, 'i_in_var    ' ,i_in_var    ); 
    ms_logger.param(l_node, 'i_out_var   ' ,i_out_var   ); 
 
    IF regex_match(i_param_type,G_REGEX_SUPPORTED_TYPES,'i') THEN
 
    IF i_in_var OR NOT l_out_var THEN
        --IN and IN OUT and (implicit IN) included in the param input list.
        io_param_list(io_param_list.COUNT+1)   := i_param_name;  
        io_param_types(io_param_types.COUNT+1) := i_param_type;  

     END IF;  
  
      IF l_out_var THEN
        --Save IN OUT and OUT params in the variable list.        
        io_var_list(i_param_name) := i_param_type;  
        ms_logger.note(l_node, 'io_var_list.count',io_var_list.count);
      END IF;
 
    END IF;
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
           ms_logger.comment(l_node, 'Found new parameter');
         --find the parameter - Search for Eg
             --  varname IN OUT vartype ,
             --  varname IN vartype)
             
            l_var_def := get_next( i_srch_before    =>  G_REGEX_REC_VAR_DEF_LINE  
                                               ||'|'||G_REGEX_TAB_COL_VAR_DEF_LINE
                                    ,i_stop         => G_REGEX_VAR_DEF_LINE||'\W' 
                                               ||'|'||G_REGEX_PARAM_LINE           
                                    ,i_upper        => TRUE
                                    ,i_colour       => G_COLOUR_PARAM
                                    ,i_raise_error  => TRUE);
             
            ms_logger.note(l_node, 'l_var_def',l_var_def);


            --temp debugging only
            -- ms_logger.note(l_node, 'l_var_def p1', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',1));
            -- ms_logger.note(l_node, 'l_var_def p2', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',2));
            -- ms_logger.note(l_node, 'l_var_def p3', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',3));
            -- ms_logger.note(l_node, 'l_var_def p4', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',4));
            -- ms_logger.note(l_node, 'l_var_def p5', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',5));
            -- ms_logger.note(l_node, 'l_var_def p6', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',6));
            -- ms_logger.note(l_node, 'l_var_def p7', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',7));
            -- ms_logger.note(l_node, 'l_var_def p8', REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',8));


             
             l_in_var  := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_NAME_IN_OUT,1,1,'i',3)) LIKE 'IN%';
             l_out_var := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_NAME_IN_OUT,1,1,'i',4)) LIKE 'OUT%';
             ms_logger.note(l_node, 'l_in_var',l_in_var);
             ms_logger.note(l_node, 'l_out_var',l_out_var);
     
             CASE 

            WHEN regex_match(l_var_def , G_REGEX_REC_VAR_DEF_LINE) THEN 
              ms_logger.info(l_node, 'LOOKING FOR ROWTYPE VARS'); 
              --Looking for ROWTYPE VARS
                 l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_REC_VAR_DEF_LINE,1,1,'i',1));
                 l_table_name  := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_REC_VAR_DEF_LINE,1,1,'i',5));
          
                 ms_logger.note(l_node, 'l_param_name',l_param_name); 
                 ms_logger.note(l_node, 'l_table_name',l_table_name); 
  
                 --Remember the Record name itself as a var with a type of TABLE_NAME
                 io_var_list(l_param_name) := l_table_name;  
                 ms_logger.note(l_node, 'io_var_list.count',io_var_list.count);   
            
            --Also need to add 1 var def for each valid componant of the record type.
            l_table_owner := table_owner(i_table_name => l_table_name);
            FOR l_column IN 
              (select lower(column_name) column_name
                     ,data_type
               from all_tab_columns
               where table_name = l_table_name 
               and   owner      = l_table_owner ) LOOP
               
                   store_var_def(i_param_name  => l_param_name||'.'||l_column.column_name
                                ,i_param_type  => l_column.data_type
                                ,i_in_var      => l_in_var
                                ,i_out_var     => l_out_var );
 
            END LOOP;   
            
            WHEN regex_match(l_var_def , G_REGEX_TAB_COL_VAR_DEF_LINE) THEN 
              ms_logger.info(l_node, 'LOOKING FOR TAB COL TYPE VARS'); 
                 l_param_name    := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',1));
                 l_table_name    := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',5));
                 l_column_name   := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_VAR_DEF_LINE,1,1,'i',7));
            
                 ms_logger.note(l_node, 'l_param_name' ,l_param_name); 
                 ms_logger.note(l_node, 'l_table_name' ,l_table_name); 
                 ms_logger.note(l_node, 'l_column_name',l_column_name);     
            
            --This should find only 1 record
            l_table_owner := table_owner(i_table_name => l_table_name);
            FOR l_column IN 
              (select lower(column_name) column_name
                     ,data_type
               from all_tab_columns
               where table_name =  l_table_name
               and   column_name = l_column_name 
               and   owner      = l_table_owner ) LOOP
               
                   store_var_def(i_param_name  => l_param_name 
                                ,i_param_type  => l_column.data_type
                                ,i_in_var      => l_in_var
                                ,i_out_var     => l_out_var );
  
            END LOOP; 

            WHEN regex_match(l_var_def , G_REGEX_VAR_DEF_LINE) THEN 
              ms_logger.info(l_node, 'LOOKING FOR ATOMIC VARS'); 
              --LOOKING FOR ATOMIC VARS
                l_param_name := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_VAR_DEF_LINE,1,1,'i',1));
                l_param_type := UPPER(REGEXP_SUBSTR(l_var_def,G_REGEX_VAR_DEF_LINE,1,1,'i',5));
                ms_logger.note(l_node, 'l_param_name',l_param_name);
                ms_logger.note(l_node, 'l_param_type',l_param_type);
                
                store_var_def(i_param_name  => l_param_name
                             ,i_param_type  => l_param_type
                             ,i_in_var      => l_in_var
                             ,i_out_var     => l_out_var );
 
                go_past(i_search => G_REGEX_VAR_DEF_LINE
                       ,i_colour => G_COLOUR_GO_PAST);
          
               --UNSUPPORTED
               ELSE
                 ms_logger.info(l_node, 'Unsupported datatype');
                go_past(i_search => G_REGEX_PARAM_LINE
                       ,i_colour => G_COLOUR_UNSUPPORTED);

                 --RAISE x_invalid_keyword;
         
             END CASE; 
          
  
 
       --DEFAULT or :=
    WHEN regex_match(l_keyword , G_REGEX_DEFAULT) THEN 
      ms_logger.comment(l_node, 'Found DEFAULT, searching for complex value');
 
      l_bracket_count := 0;
      loop
        l_bracket := get_next( i_stop       => G_REGEX_OPEN_BRACKET
                                            ||'|'||G_REGEX_CLOSE_BRACKET
                                            ||'|'||G_REGEX_COMMA
                                  ,i_raise_error => TRUE);
 
            ms_logger.note(l_node, 'l_bracket' ,l_bracket); 
            CASE 
        WHEN regex_match(l_bracket , G_REGEX_COMMA) THEN
          EXIT WHEN l_bracket_count = 0;

            WHEN regex_match(l_bracket , G_REGEX_OPEN_BRACKET) THEN
          l_bracket_count := l_bracket_count + 1;

            WHEN regex_match(l_bracket , G_REGEX_CLOSE_BRACKET) THEN
                l_bracket_count := l_bracket_count - 1;
        EXIT WHEN l_bracket_count = -1;

              ELSE 
          ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
        RAISE x_invalid_keyword;
        END CASE; 
        go_past(i_colour => G_COLOUR_BRACKETS);
      
      END LOOP; 
 
    --  --NO MORE PARAMS
    WHEN regex_match(l_keyword , G_REGEX_RETURN_IS_AS_DECLARE) THEN
          ms_logger.comment(l_node, 'No more parameters');
          --Needed to find Return to get to end of params, 
          --but now make sure we consume the IS/AS/DECLARE (DECLARE for triggers).
          go_past(i_search => G_REGEX_IS_AS_DECLARE
                 ,i_stop   => G_REGEX_BEGIN
                 ,i_colour => G_COLOUR_GO_PAST);
 
          EXIT;
          
        --OOPS
        ELSE
      ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
          RAISE x_invalid_keyword;
      END CASE;
    EXCEPTION
    WHEN x_out_param THEN  
      ms_logger.comment(l_node, 'Skipped OUT param');
    WHEN x_unsupported_data_type THEN
      ms_logger.comment(l_node, 'Unsupported param type');
  END;
 
  END LOOP; 
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_params;    

 

--------------------------------------------------------------------------------- 
-- AOP_var_def - Harvests any vars and appends them to the var list.     
---------------------------------------------------------------------------------
FUNCTION AOP_var_defs(i_var_list IN var_list_typ) RETURN var_list_typ IS
  l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'AOP_var_defs'); 
  
  l_var_list              var_list_typ := i_var_list;
  l_var_def               CLOB;
  G_REGEX_VAR_DEF_LINE         CONSTANT VARCHAR2(200) := '\s('||G_REGEX_WORD||'?)\s+?'||G_REGEX_SUPPORTED_TYPES||'\W';
  G_REGEX_REC_VAR_DEF_LINE     CONSTANT VARCHAR2(200) := '\s'||G_REGEX_WORD||'?\s+?'||G_REGEX_WORD||'?%ROWTYPE';
  G_REGEX_TAB_COL_VAR_DEF_LINE CONSTANT VARCHAR2(200) := '\s'||G_REGEX_WORD||'?\s+?'||G_REGEX_WORD||'?\.'||G_REGEX_WORD||'?%TYPE';
  
  
  G_REGEX_VAR_NAME_TYPE       CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+('||G_REGEX_WORD||')';
  G_REGEX_REC_VAR_NAME_TYPE   CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+('||G_REGEX_WORD||')%ROWTYPE';
  G_REGEX_TAB_COL_NAME_TYPE   CONSTANT VARCHAR2(200) := '('||G_REGEX_WORD||')\s+('||G_REGEX_WORD||')\.('||G_REGEX_WORD||')%TYPE';

  
  l_param_name  VARCHAR2(30);
  l_param_type  VARCHAR2(106);
  l_table_name  VARCHAR2(30);
  l_column_name VARCHAR2(30);
  l_table_owner VARCHAR2(30);
 
BEGIN
  --Search for var_name var_type pairs.
 
  loop
 
  l_var_def := get_next( i_srch_before      => G_REGEX_VAR_DEF_LINE 
                                    ||'|'||G_REGEX_REC_VAR_DEF_LINE  
                                    ||'|'||G_REGEX_TAB_COL_VAR_DEF_LINE
                         ,i_stop        => G_REGEX_BEGIN  
                                    ||'|'||G_REGEX_PROG_UNIT
                         ,i_upper      => TRUE
                         ,i_colour      => G_COLOUR_VAR_LINE);
 
  ms_logger.note(l_node, 'l_var_def',l_var_def);
 
    CASE 
    WHEN regex_match(l_var_def , G_REGEX_VAR_DEF_LINE) THEN 
      ms_logger.info(l_node, 'LOOKING FOR ATOMIC VARS'); 
      --LOOKING FOR ATOMIC VARS
        l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_VAR_NAME_TYPE,1,1,'i',1));
        l_param_type  := REGEXP_SUBSTR(l_var_def,G_REGEX_VAR_NAME_TYPE,1,1,'i',3);

        --l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_WORD,1,1,'i'));
        --l_param_type  := REGEXP_SUBSTR(l_var_def,G_REGEX_WORD,1,2,'i');

   
        ms_logger.note(l_node, 'l_param_name',l_param_name); 
        ms_logger.note(l_node, 'l_param_type',l_param_type); 
    
      IF  regex_match(l_param_type , G_REGEX_SUPPORTED_TYPES) THEN
          
      --Supported data type so store in the var list.
          l_var_list(l_param_name) := l_param_type;  
          ms_logger.note(l_node, 'l_var_list.count',l_var_list.count);     
 
        END IF; 
 
    WHEN regex_match(l_var_def , G_REGEX_REC_VAR_DEF_LINE) THEN 
      ms_logger.info(l_node, 'LOOKING FOR ROWTYPE VARS'); 
      --Looking for ROWTYPE VARS
        l_param_name  := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_REC_VAR_NAME_TYPE,1,1,'i',1));
        l_table_name  := REGEXP_SUBSTR(l_var_def,G_REGEX_REC_VAR_NAME_TYPE,1,1,'i',3);
 
        ms_logger.note(l_node, 'l_param_name',l_param_name); 
        ms_logger.note(l_node, 'l_table_name',l_table_name); 
 
        --Remember the Record name itself as a var with a type of TABLE_NAME
        l_var_list(l_param_name) := l_table_name;  
        ms_logger.note(l_node, 'l_var_list.count',l_var_list.count);   
    
    --Also need to add 1 var def for each valid componant of the record type.
    l_table_owner := table_owner(i_table_name => l_table_name);
    FOR l_column IN 
      (select lower(column_name) column_name
             ,data_type
       from all_tab_columns
       where table_name = l_table_name 
       and   owner      = l_table_owner  ) LOOP

         IF  regex_match(l_column.data_type , G_REGEX_SUPPORTED_TYPES) THEN
       
           l_var_list(l_param_name||'.'||l_column.column_name) := l_column.data_type;  
           ms_logger.note(l_node, 'l_var_list.count',l_var_list.count);       
         END IF; 
       
    END LOOP;   
    
    WHEN regex_match(l_var_def , G_REGEX_TAB_COL_VAR_DEF_LINE) THEN 
        ms_logger.info(l_node, 'LOOKING FOR TAB COL TYPE VARS'); 
        l_param_name    := LOWER(REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_NAME_TYPE,1,1,'i',1));
        l_table_name    :=       REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_NAME_TYPE,1,1,'i',3);
        l_column_name   :=       REGEXP_SUBSTR(l_var_def,G_REGEX_TAB_COL_NAME_TYPE,1,1,'i',5);
    
        ms_logger.note(l_node, 'l_param_name' ,l_param_name); 
        ms_logger.note(l_node, 'l_table_name' ,l_table_name); 
        ms_logger.note(l_node, 'l_column_name',l_column_name);    
    
    --Also need to add 1 var def for each valid componant of the record type.
    l_table_owner := table_owner(i_table_name => l_table_name);
    FOR l_column IN 
      (select lower(column_name) column_name
             ,data_type
       from all_tab_columns
       where table_name =  l_table_name
       and   column_name = l_column_name 
       and   owner       = l_table_owner  ) LOOP

         IF  regex_match(l_column.data_type , G_REGEX_SUPPORTED_TYPES) THEN
       
          l_var_list(l_param_name) := l_column.data_type;  
          ms_logger.note(l_node, 'l_var_list.count',l_var_list.count);    

         END IF;    
       
    END LOOP; 
 
      ELSE
      ms_logger.info(l_node,'No more variables.');
    EXIT;

    END CASE;
  
  END LOOP;

  RETURN l_var_list;
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_var_defs;

    
--------------------------------------------------------------------------------- 
-- AOP_declare
---------------------------------------------------------------------------------
PROCEDURE AOP_declare(i_indent   IN INTEGER
                     ,i_var_list IN var_list_typ) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_declare'); 
  
  l_var_list          var_list_typ := i_var_list;
  
BEGIN

  ms_logger.param(l_node, 'i_indent' ,i_indent); 

  --Search for nested PROCEDURE and FUNCTION within the declaration section of the block.
  --Drop out when a BEGIN is reached.
 
  l_var_list := AOP_var_defs( i_var_list => l_var_list);    
 
  AOP_prog_units(i_indent   => i_indent + g_indent_spaces
                ,i_var_list => l_var_list);
  
  --calc indent and consume BEGIN
  AOP_block(i_indent    => calc_indent(i_indent, get_next(i_srch_before => G_REGEX_BEGIN
                                                         ,i_colour => G_COLOUR_GO_PAST))
           ,i_regex_end => G_REGEX_END_BEGIN
           ,i_var_list  => l_var_list);
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_declare;

  
--------------------------------------------------------------------------------- 
-- AOP_is_as
---------------------------------------------------------------------------------
PROCEDURE AOP_is_as(i_prog_unit_name IN VARCHAR2
                   ,i_indent         IN INTEGER
                   ,i_node_type      IN VARCHAR2
                   ,i_var_list       IN var_list_typ) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_is_as'); 
 
  l_keyword               VARCHAR2(50);
  l_inject_node           VARCHAR2(200);  
  l_inject_process        VARCHAR2(200);  
  l_param_list            param_list_typ;
  l_param_types           param_list_typ;
  l_var_list              var_list_typ := i_var_list;
  
BEGIN
  ms_logger.param(l_node, 'i_prog_unit_name' ,i_prog_unit_name); 
  ms_logger.param(l_node, 'i_indent        ' ,i_indent        ); 
  ms_logger.param(l_node, 'i_node_type     ' ,i_node_type     ); 
 
  AOP_pu_params(io_param_list  => l_param_list  
               ,io_param_types => l_param_types               
               ,io_var_list   => l_var_list);    
 
  --NEW PROCESS
  IF UPPER(i_prog_unit_name) = 'BEFOREPFORM' THEN
    --BEFOREPFORM signifies beginning of report. Create a new process before the node
    l_inject_process :=  'l_process_id INTEGER := ms_logger.new_process('||g_aop_module_name||',''REPORT'',:p_report_run_id);';
    inject( i_new_code  => l_inject_process
           ,i_indent    => i_indent
           ,i_colour    => G_COLOUR_NODE);
  END IF;
  
  --NEW NODE
  l_inject_node := 'l_node ms_logger.node_typ := ms_logger.'||i_node_type||'('||g_aop_module_name||' ,'''||i_prog_unit_name||''');';
  inject( i_new_code  =>  l_inject_node
         ,i_indent     => i_indent
         ,i_colour     => G_COLOUR_NODE);   
       
  l_var_list := AOP_var_defs( i_var_list => l_var_list);    
 
  AOP_prog_units(i_indent    => i_indent + g_indent_spaces
                ,i_var_list  => l_var_list);
  
  
  --If this is a package there may not be a BEGIN, just an END;
  l_keyword := get_next( i_stop        => G_REGEX_BEGIN||'|'||G_REGEX_END_BEGIN
                        ,i_upper       => TRUE
                        ,i_raise_error => TRUE                              );
 
  IF regex_match(l_keyword , G_REGEX_END_BEGIN) and i_node_type = 'new_pkg' THEN
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
                ,i_param_types     => l_param_types
                ,i_var_list        => l_var_list);
    
  END IF;
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_is_as;

  
        
--------------------------------------------------------------------------------- 
-- AOP_block
---------------------------------------------------------------------------------
PROCEDURE AOP_block(i_indent         IN INTEGER
                   ,i_regex_end      IN VARCHAR2
                   ,i_var_list       IN var_list_typ  )  IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_block');
  
  l_keyword               CLOB;
  l_stashed_comment       VARCHAR2(50);
  l_function              VARCHAR2(30);
 
  l_var_list              var_list_typ := i_var_list;

  l_table_owner           VARCHAR2(30);
  l_table_name            VARCHAR2(30);


  l_into_var_list         var_list_typ;
  l_index                 binary_integer;
  l_var                   VARCHAR2(100);

  l_exception_section     BOOLEAN :=FALSE;

  
  G_REGEX_ASSIGN_TO_REC_COL   CONSTANT VARCHAR2(50) :=  G_REGEX_2WORDS||'\s*?:=';

  --matches on both G_REGEX_ASSIGN_TO_VAR and G_REGEX_ASSIGN_TO_BIND_VAR 
  G_REGEX_ASSIGN_TO_VARS      CONSTANT VARCHAR2(50) :=  ':*?'||G_REGEX_WORD||'?\s*?:='; 

  G_REGEX_ASSIGN_TO_VAR       CONSTANT VARCHAR2(50) :=  G_REGEX_WORD||'\s*?:=';  
  G_REGEX_ASSIGN_TO_BIND_VAR  CONSTANT VARCHAR2(50) :=  ':'||G_REGEX_WORD||'\s*?:=';
  
  G_REGEX_VAR                 CONSTANT VARCHAR2(50) := G_REGEX_WORD;
  G_REGEX_REC_COL             CONSTANT VARCHAR2(50) := G_REGEX_WORD||'.'||G_REGEX_WORD;
  G_REGEX_BIND_VAR            CONSTANT VARCHAR2(50) := ':'||G_REGEX_WORD;

  G_REGEX_SHOW_ME_LINE        CONSTANT VARCHAR2(50) :=  '.+--(\@\@)';
  G_REGEX_ROW_COUNT_LINE      CONSTANT VARCHAR2(50) :=  '.+--(RC)';
 
 
  G_REGEX_DELETE_FROM         CONSTANT VARCHAR2(50) := '\sDELETE\s+?FROM\s';
  G_REGEX_DELETE              CONSTANT VARCHAR2(50) := '\sDELETE\s'        ;
  G_REGEX_INSERT_INTO         CONSTANT VARCHAR2(50) := '\sINSERT\s+?INTO\s';
  G_REGEX_UPDATE              CONSTANT VARCHAR2(50) := '\sUPDATE\s';

  G_REGEX_FROM                CONSTANT VARCHAR2(50) := '\sFROM\s';
 
  
  G_REGEX_SELECT_FETCH_INTO   CONSTANT VARCHAR2(50) := '\s(SELECT|FETCH)\s+?(\s|\S)+?\s+?INTO\s';

  G_REGEX_DML                 CONSTANT VARCHAR2(200) :=   G_REGEX_DELETE_FROM 
                                                  ||'|'|| G_REGEX_DELETE
                                                  ||'|'|| G_REGEX_INSERT_INTO
                                                  ||'|'|| G_REGEX_UPDATE;
 
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
    l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'note_var');
    -- Note a variable 
  BEGIN
    ms_logger.note(l_node,'i_var' ,i_var);
    ms_logger.note(l_node,'i_type',i_type);
    IF i_type = 'CLOB' THEN
      inject( i_new_code   => 'ms_logger.note_clob(l_node,'''||i_var||''','||i_var||');'
             ,i_indent     => i_indent
             ,i_colour     => G_COLOUR_NOTE);
    ELSE
      inject( i_new_code   => 'ms_logger.note(l_node,'''||i_var||''','||i_var||');'
             ,i_indent     => i_indent
             ,i_colour     => G_COLOUR_NOTE);
    END IF;
  END;
 

  PROCEDURE note_non_bind_var(i_var in varchar2 ) IS
    -- find assignment of non-bind variable and inject a note
   
  BEGIN
 
        IF l_var_list.EXISTS(i_var) THEN
          --This variable exists in the list of scoped variables with compatible types    
          ms_logger.comment(l_node, 'Scoped Var');
          ms_logger.note(l_node,'l_var_list(i_var)',l_var_list(i_var));
          IF  regex_match(l_var_list(i_var) , G_REGEX_SUPPORTED_TYPES) THEN
            --Data type is supported.
            ms_logger.comment(l_node, 'Data type is supported');
            --So we can write a note for it.
            note_var(i_var   => i_var
                     ,i_type => l_var_list(i_var));
          ELSE
            ms_logger.comment(l_node, 'Data type is TABLE_NAME');
            --Data type is unsupported so it is the name of a table instead.
            --Now write a note for each supported column.
            ms_logger.comment(l_node, 'Data type is supported');
            --Also need to add 1 var def for each valid componant of the record type.
            l_table_owner := table_owner(i_table_name => l_var_list(i_var));
            FOR l_column IN 
              (select lower(column_name) column_name
                     ,data_type
               from all_tab_columns
               where table_name = l_var_list(i_var) 
               and   owner      = l_table_owner  ) LOOP

               IF  regex_match(l_column.data_type , G_REGEX_SUPPORTED_TYPES) THEN
                 note_var(i_var  => i_var||'.'||l_column.column_name
                         ,i_type => l_column.data_type);
               END IF;

            END LOOP;  
 
          END IF;

         
        END IF;
  END;

  PROCEDURE note_rec_col_var(i_var  in varchar2) IS
  -- find assignment of rec.column variable and inject a note
 
  BEGIN
 
    IF l_var_list.EXISTS(i_var) THEN
      --Tab Column rec variable exists 
      note_var(i_var  => i_var
              ,i_type => l_var_list(i_var));
       
    END IF;
  END;

 

 
BEGIN

  ms_logger.param(l_node, 'i_indent    '      ,i_indent     );
  ms_logger.param(l_node, 'i_regex_end '     ,i_regex_end  );

 
  loop
 
  l_keyword := get_next(  i_srch_before       =>   G_REGEX_OPEN
                                       ||'|'||G_REGEX_NEUTRAL
                                       ||'|'||G_REGEX_CLOSE
                          ,i_srch_after       => G_REGEX_WHEN_EXCEPT_THEN --(also matches for G_REGEX_WHEN_OTHERS_THEN)
                                       ||'|'||G_REGEX_SHOW_ME_LINE 
                                       --||'|'||G_REGEX_ROW_COUNT_LINE
                                       --||'|'||G_REGEX_DML               
                                       --||'|'||G_REGEX_SELECT_FETCH_INTO          
                          ,i_stop          => G_REGEX_START_ANNOTATION --don't colour it
                                       ||'|'||G_REGEX_ASSIGN_TO_REC_COL
                                       ||'|'||G_REGEX_ASSIGN_TO_VARS
                          ,i_upper        => TRUE
                          ,i_colour       => G_COLOUR_BLOCK
                          ,i_raise_error  => TRUE
);
 
  ms_logger.note(l_node, 'l_keyword',l_keyword);
 
    CASE 
    WHEN regex_match(l_keyword , G_REGEX_DECLARE) THEN     
        ms_logger.info(l_node, 'Declare');    
        AOP_declare(i_indent    => calc_indent(i_indent + g_indent_spaces,l_keyword)
                   ,i_var_list  => l_var_list);    
        
      WHEN regex_match(l_keyword , G_REGEX_BEGIN) THEN    
        ms_logger.info(l_node, 'Begin');      
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword)
                 ,i_regex_end  => G_REGEX_END_BEGIN
                 ,i_var_list   => l_var_list);     
                 
      WHEN regex_match(l_keyword , G_REGEX_LOOP) THEN   
        ms_logger.info(l_node, 'Loop'); 
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword)
                 ,i_regex_end  => G_REGEX_END_LOOP
                 ,i_var_list   => l_var_list );                                
             
      WHEN regex_match(l_keyword , G_REGEX_CASE) THEN   
        ms_logger.info(l_node, 'Case'); 
    --inc level +2 due to implied WHEN or ELSE
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword) +  g_indent_spaces
                 ,i_regex_end  => G_REGEX_END_CASE||'|'||G_REGEX_END_CASE_EXPR
                 ,i_var_list   => l_var_list );      
   
      WHEN regex_match(l_keyword , G_REGEX_IF) THEN    
        ms_logger.info(l_node, 'If'); 
        AOP_block(i_indent     => calc_indent(i_indent + g_indent_spaces,l_keyword)
                 ,i_regex_end  => G_REGEX_END_IF
                 ,i_var_list   => l_var_list );

      WHEN regex_match(l_keyword , G_REGEX_EXCEPTION) THEN
        ms_logger.info(l_node, 'Exception Section');  
        --Now safe to look for WHEN X THEN
        l_exception_section := TRUE;
 
      WHEN regex_match(l_keyword , G_REGEX_NEUTRAL) THEN
        ms_logger.info(l_node, 'Neutral');  
        --Just let it keep going around the loop.
        NULL;
        
      --END_BEGIN will also match END_LOOP, END_CASE and END IF
      --So we need to make sure it hasn't matched on them.      
    WHEN i_regex_end = G_REGEX_END_BEGIN              AND
           regex_match(l_keyword , i_regex_end)        AND 
           (  regex_match(l_keyword ,G_REGEX_END_LOOP) OR
              regex_match(l_keyword ,G_REGEX_END_CASE) OR 
              regex_match(l_keyword ,G_REGEX_END_IF)) THEN
      ms_logger.fatal(l_node, 'Mis-matched Expected END; Got '||l_keyword);
    RAISE X_INVALID_KEYWORD;
 
    WHEN regex_match(l_keyword ,i_regex_end) THEN
       ms_logger.info(l_node, 'Block End Found!');
       EXIT;
        
    WHEN regex_match(l_keyword ,G_REGEX_CLOSE) THEN
      ms_logger.fatal(l_node, 'Mis-matched END Expecting :'||i_regex_end||' Got: '||l_keyword);
    RAISE X_INVALID_KEYWORD;
        
      WHEN regex_match(l_keyword ,G_REGEX_START_ANNOTATION) THEN
        --What sort of annotation is it?
         CASE 
           WHEN regex_match(l_keyword ,G_REGEX_COMMENT) THEN l_function := 'comment';
           WHEN regex_match(l_keyword ,G_REGEX_INFO   ) THEN l_function := 'info';
           WHEN regex_match(l_keyword ,G_REGEX_WARNING) THEN l_function := 'warning';
           WHEN regex_match(l_keyword ,G_REGEX_FATAL  ) THEN l_function := 'fatal';
         END CASE;
         
         ms_logger.note(l_node, 'l_function',l_function);
       
         --Find the placeholder for the stashed comment.
         go_past; --Now go past (just can't afford it to be coloured)
         l_stashed_comment := get_next( i_stop        => G_REGEX_STASHED_COMMENT
                                       ,i_raise_error => TRUE);
         ms_logger.note(l_node, 'l_stashed_comment',l_stashed_comment);
  
         g_code := REPLACE(g_code
                         , l_keyword||l_stashed_comment
                         , f_colour(i_text   => 'ms_logger.'||l_function||'(l_node,'''
                         , i_colour => G_COLOUR_ANNOTATION)
             ||l_stashed_comment||''');');
 
      WHEN regex_match(l_keyword ,G_REGEX_SHOW_ME_LINE) THEN
      ms_logger.info(l_node, 'Show Me');
      --expose this line of code as a comment 
        inject( i_new_code => 'ms_logger.comment(l_node,'''
                        ||SUBSTR(l_keyword,1,LENGTH(l_keyword)-4)  
              ||''');'
               ,i_indent   => i_indent
               ,i_colour   => G_COLOUR_COMMENT);
 
     -- WHEN regex_match(l_keyword ,G_REGEX_ROW_COUNT_LINE) THEN
     -- ms_logger.info(l_node, 'Rowcount');
     -- --expose this line of code as a note with rowcount 
     --   inject( i_new_code => 'ms_logger.note_rowcount(l_node,'''
     --                   ||SUBSTR(l_keyword,1,LENGTH(l_keyword)-4)  
     --         ||''');'
     --          ,i_indent   => i_indent
     --          ,i_colour   => G_COLOUR_NOTE);

 
      WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_BIND_VAR) THEN  
        ms_logger.info(l_node, 'Assign Bind Var');

        l_var := find_var(i_search => G_REGEX_BIND_VAR);
        note_var(i_var  => l_var
                ,i_type => NULL);
 
      WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_REC_COL) THEN   
        ms_logger.info(l_node, 'Assign Record.Column');

        l_var := find_var(i_search => G_REGEX_REC_COL);
        note_rec_col_var(i_var => l_var);

      WHEN regex_match(l_keyword ,G_REGEX_ASSIGN_TO_VAR) THEN  
        ms_logger.info(l_node, 'Assign Var');  

        l_var := find_var(i_search => G_REGEX_VAR);
        note_non_bind_var(i_var => l_var);

 
      WHEN regex_match(l_keyword ,G_REGEX_SELECT_FETCH_INTO  ) THEN   
        ms_logger.info(l_node, 'Select/Fetch Into');

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
          ms_logger.note(l_node, 'l_var',l_var);
           IF regex_match(l_var ,G_REGEX_SEMI_COL    
                          ||'|'||G_REGEX_FROM)  THEN 
             go_past(G_REGEX_SEMI_COL);
             EXIT;
           END IF;
           ms_logger.info(l_node, 'Adding a variable');
           l_into_var_list (l_into_var_list.COUNT+1) := l_var;  
 
        END LOOP; 
 
        --Loop thru the variables after all have been found.
        l_index := l_into_var_list.FIRST;
        WHILE l_index IS NOT NULL LOOP
          l_var := l_into_var_list(l_index);
          --Note the variable
          CASE 
            WHEN regex_match(l_var ,G_REGEX_BIND_VAR) THEN note_var(i_var  => l_var
                                                                   ,i_type => NULL);
            WHEN regex_match(l_var ,G_REGEX_VAR)      THEN note_non_bind_var(i_var => l_var );
            WHEN regex_match(l_var ,G_REGEX_REC_COL)  THEN note_rec_col_var(i_var => l_var );
            ELSE 
              ms_logger.fatal(l_node, 'AOP G_REGEX_FETCH_INTO BUG - REGEX Mismatch');
              RAISE x_invalid_keyword;
          END CASE;
 
          --Next variable
          l_index := l_into_var_list.NEXT(l_index);
        END LOOP;
 

  
      WHEN regex_match(l_keyword ,G_REGEX_WHEN_OTHERS_THEN) THEN  
        ms_logger.info(l_node, 'WHEN OTHERS THEN');   
        --warn of error after WHEN OTHERS THEN  
        inject( i_new_code => 'ms_logger.warn_error(l_node);'
               ,i_indent   => i_indent
               ,i_colour   => G_COLOUR_EXCEPTION_BLOCK);
               
      WHEN regex_match(l_keyword ,G_REGEX_WHEN_EXCEPT_THEN) THEN 
        --Only want to note exceptions in an exception section.
        IF l_exception_section THEN
          ms_logger.info(l_node, 'WHEN_EXCEPT_THEN');       
          --comment the exception after WHEN exception THEN 
          inject( i_new_code => 'ms_logger.comment(l_node,'''||flatten(trim_whitespace(l_keyword))||''');'
                 ,i_indent   => i_indent
                 ,i_colour   => G_COLOUR_COMMENT);   
        END IF;    

      --WHEN regex_match(l_keyword ,G_REGEX_DML) THEN 
      --  ms_logger.info(l_node, 'DML');
      --  l_table_name := get_next_object_name;
      --
      --  go_past(G_REGEX_SEMI_COL); 
      --  inject( i_new_code => 'ms_logger.note_rowcount(l_node,'''||flatten(trim_whitespace(l_keyword))||' '||l_table_name||''');'
      --         ,i_indent   => i_indent
      --         ,i_colour   => G_COLOUR_NOTE); 

 
      ELSE 
          ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
          RAISE x_invalid_keyword;
  
    END CASE;
 
  END LOOP;

 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_block;

--------------------------------------------------------------------------------- 
-- AOP_pu_block
---------------------------------------------------------------------------------
PROCEDURE AOP_pu_block(i_prog_unit_name IN VARCHAR2
                      ,i_indent         IN INTEGER
                      ,i_param_list     IN param_list_typ
                      ,i_param_types    IN param_list_typ
                      ,i_var_list       IN var_list_typ ) IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_block');
  
  l_var_list              var_list_typ := i_var_list;
  l_index                 BINARY_INTEGER;
 
BEGIN
 
  ms_logger.param(l_node, 'i_prog_unit_name'     ,i_prog_unit_name     );
  ms_logger.param(l_node, 'i_indent        '     ,i_indent             );
 

  --Add extra BEGIN infront of existing BEGIN, ensuring not trimmed.
  go_upto(i_stop      => G_REGEX_BEGIN); --default is i_trim_pointers FALSE
 
  inject( i_new_code  => 'begin --'||i_prog_unit_name
          ,i_indent   => i_indent - g_indent_spaces
          ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  --Add the params (if any)
  l_index := i_param_list.FIRST;
  WHILE l_index IS NOT NULL LOOP
    IF i_param_types(l_index) = 'CLOB' THEN
      inject( i_new_code  => 'ms_logger.param_clob(l_node,'||RPAD(''''||i_param_list(l_index)||'''',GREATEST(G_PARAM_NAME_PADDING,LENGTH(i_param_list(l_index))))||','||i_param_list(l_index)||');'
             ,i_indent    => i_indent
             ,i_colour    => G_COLOUR_PARAM);
    ELSE
      inject( i_new_code  => 'ms_logger.param(l_node,'||RPAD(''''||i_param_list(l_index)||'''',GREATEST(G_PARAM_NAME_PADDING,LENGTH(i_param_list(l_index))))||','||i_param_list(l_index)||');'
             ,i_indent    => i_indent
             ,i_colour    => G_COLOUR_PARAM);
  END IF;
           
    l_index := i_param_list.NEXT(l_index);    
 
  END LOOP;

  IF i_prog_unit_name = 'beforepform' THEN
    inject( i_new_code  => 'ms_logger.info(l_node,''Starting Report ''||'||g_aop_module_name||');'
           ,i_indent   => i_indent+1
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  ELSIF i_prog_unit_name = 'afterreport' THEN
    inject( i_new_code  => 'ms_logger.info(l_node,''Finished Report ''||'||g_aop_module_name||');'
           ,i_indent   => i_indent+1
           ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  END IF;
 
  --First Block is BEGIN 
  --calc indent and consume BEGIN
  AOP_block(i_indent    => calc_indent(i_indent, get_next(i_srch_before => G_REGEX_BEGIN
                                                         ,i_colour => G_COLOUR_GO_PAST))
           ,i_regex_end  => G_REGEX_END_BEGIN
           ,i_var_list   => l_var_list  );
  
  --Add extra exception handler
  --add the terminating exception handler of the new surrounding block
  inject( i_new_code  => 'exception'
         ,i_indent    => i_indent - g_indent_spaces
         ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

  inject( i_new_code  => '  when others then'
         ,i_indent    => i_indent - g_indent_spaces
         ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

  inject( i_new_code  => '    ms_logger.warn_error(l_node);'
         ,i_indent    => i_indent - g_indent_spaces
         ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

  inject( i_new_code  => '    raise;'
         ,i_indent    => i_indent - g_indent_spaces
         ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

  inject( i_new_code  => 'end; --'||i_prog_unit_name
         ,i_indent    => i_indent - g_indent_spaces
         ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);

 

exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_block;


 
--------------------------------------------------------------------------------- 
-- AOP_prog_units
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_units(i_indent   IN INTEGER
                        ,i_var_list IN var_list_typ  ) IS
  l_node    ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_prog_units'); 

  l_keyword         VARCHAR2(50);
  l_language        VARCHAR2(50);
  l_forward_declare        VARCHAR2(50);
  l_node_type       VARCHAR2(50);
  l_prog_unit_name  VARCHAR2(30);
  
  l_var_list        var_list_typ := i_var_list;
  
  x_language_java_name EXCEPTION;
  x_forward_declare    EXCEPTION;
 
BEGIN

  ms_logger.param(l_node, 'i_indent        '     ,i_indent             );
 
  LOOP
    BEGIN
 
        --Find node type
        l_keyword := get_next( i_srch_before      => G_REGEX_PROG_UNIT
                              ,i_stop        => G_REGEX_BEGIN
                              ,i_upper       => TRUE
                              ,i_colour      => G_COLOUR_PROG_UNIT );
     
      ms_logger.note(l_node, 'l_keyword' ,l_keyword);   
      CASE 
        WHEN regex_match(l_keyword,G_REGEX_PKG_BODY) THEN
          l_node_type := 'new_pkg';
          l_prog_unit_name := 'Initialise';
        WHEN regex_match(l_keyword,G_REGEX_PROCEDURE) THEN
          l_node_type := 'new_proc';
          l_prog_unit_name := NULL;
        WHEN regex_match(l_keyword,G_REGEX_FUNCTION) THEN
          l_node_type := 'new_func';
          l_prog_unit_name := NULL;
        WHEN regex_match(l_keyword,G_REGEX_TRIGGER) THEN
          l_node_type := 'new_trig';
          l_prog_unit_name := NULL;
      WHEN regex_match(l_keyword,G_REGEX_BEGIN) OR l_keyword IS NULL THEN
        EXIT;
        ELSE
      ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
      RAISE x_invalid_keyword;
      END CASE;  
      ms_logger.note(l_node, 'l_node_type' ,l_node_type);  
 
      --Check for LANGUAGE JAVA NAME
      --If this is a JAVA function then we don't want a node and don't need to bother reading spec or parsing body.
      --Will find a LANGUAGE keyword before next ";"
      l_language := get_next(i_srch_before  => G_REGEX_JAVA 
                            ,i_stop         => G_REGEX_SEMI_COL
                            ,i_upper        => TRUE
                            ,i_colour       => G_COLOUR_JAVA
                            ,i_raise_error  => TRUE );
     
      ms_logger.note(l_node, 'l_language' ,l_language); 
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
     
      ms_logger.note(l_node, 'l_forward_declare' ,l_forward_declare); 
      IF l_forward_declare = G_REGEX_SEMI_COL THEN
        RAISE x_forward_declare; 
      END IF;
      
      
      IF l_prog_unit_name IS NULL THEN
        --Get program unit name
        l_prog_unit_name := get_next_object_name;
 
      END IF;
      ms_logger.note(l_node, 'l_prog_unit_name' ,l_prog_unit_name);
      
 
      AOP_is_as(i_prog_unit_name => l_prog_unit_name
               ,i_indent         => calc_indent(i_indent, l_keyword)
               ,i_node_type      => l_node_type
               ,i_var_list       => l_var_list);
      
    EXCEPTION 
      WHEN x_language_java_name THEN
        ms_logger.comment(l_node, 'Found LANGUAGE JAVA NAME.');    
      
      WHEN x_forward_declare THEN
        ms_logger.comment(l_node, 'Found FORWARD DECLARATION.');    
    END;
  END LOOP;
 
  ms_logger.comment(l_node, 'No more program units.');
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_prog_units;
 
--------------------------------------------------------------------
-- trim_clob
--------------------------------------------------------------------
FUNCTION trim_clob(i_clob IN CLOB) RETURN CLOB IS
  G_REGEX_LEADING_TRAILING_WHITE CONSTANT VARCHAR2(20) := '^\s*|\s*$';
BEGIN
  RETURN TRIM(REGEXP_REPLACE(i_clob,G_REGEX_LEADING_TRAILING_WHITE,''));
END;


--------------------------------------------------------------------------------- 
-- weave
---------------------------------------------------------------------------------
  function weave
  ( p_code         in out clob
  , p_package_name in varchar2
  , p_for_html     in boolean default false
  , p_end_user     in varchar default null
  ) return boolean
  is

    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'weave'); 
 
    l_advised            boolean := false;
    l_current_pos        integer := 1;
    l_count              NUMBER  := 0;
    l_end_pos            integer;  
  
    l_end_value          varchar2(50);
    l_mystery_word       varchar2(50);

    l_package_name       varchar2(50);
  
  begin
  begin
 
    ms_logger.param(l_node, 'p_package_name'      ,p_package_name);
    ms_logger.param(l_node, 'p_for_html'          ,p_for_html);
  
    IF p_package_name IS NULL THEN
      g_aop_module_name := '$$plsql_unit';
      ELSE
      g_aop_module_name := ''''||p_package_name||'''';
    END IF;
   
    g_for_aop_html := p_for_html;
    g_end_user     := p_end_user;
   
    --First task will be to remove all comments or 
    --somehow identify and remember all sections that can be ignored because they are comments
    
    g_code := chr(10)||p_code||chr(10); --add a trailing CR to help with searching
  
    set_weave_timeout;
      
    stash_comments_and_quotes;
 
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
    l_var_list   var_list_typ;
  
  begin
    g_current_pos := 1;
    l_keyword := get_next(i_stop       => G_REGEX_DECLARE
                                   ||'|'||G_REGEX_BEGIN  
                                   ||'|'||G_REGEX_PROG_UNIT 
                                   ||'|'||G_REGEX_CREATE
                         ,i_upper      => TRUE
                         ,i_raise_error => TRUE  );
 
    ms_logger.note(l_node, 'l_keyword' ,l_keyword);

    CASE 
      WHEN regex_match(l_keyword , G_REGEX_DECLARE) THEN
        --calc indent and consume DECLARE
        AOP_declare(i_indent    => calc_indent(g_initial_indent, get_next(i_srch_before => G_REGEX_DECLARE
                                                                         ,i_colour => G_COLOUR_GO_PAST))
                   ,i_var_list => l_var_list);
          
      WHEN regex_match(l_keyword , G_REGEX_BEGIN) THEN
        --calc indent and consume BEGIN
        AOP_block(i_indent    => calc_indent(g_initial_indent, get_next(i_srch_before => G_REGEX_BEGIN
                                                                       ,i_colour => G_COLOUR_GO_PAST))
                 ,i_regex_end  => G_REGEX_END_BEGIN
                 ,i_var_list   => l_var_list);
    
      WHEN regex_match(l_keyword , G_REGEX_PROG_UNIT
                            ||'|'||G_REGEX_CREATE) THEN
        AOP_prog_units(i_indent   => calc_indent(g_initial_indent,l_keyword)
                      ,i_var_list => l_var_list      );

    ELSE
      ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
      RAISE x_invalid_keyword;
    end case;   
  end;
 
    l_advised:= true;

  --Translate SIMPLE ms_feedback syntax to MORE COMPLEX ms_logger syntax
  --EG ms_feedback.x(           ->  ms_logger.x(l_node,
  g_code := REGEXP_REPLACE(g_code,'(ms_feedback)(\.)(.+)(\()','ms_logger.\3(l_node,');

  --Replace routines with no params 
  --EG ms_feedback.oracle_error -> ms_logger.oracle_error(l_node)
  g_code := REGEXP_REPLACE(g_code,'(ms_feedback)(\.)(.+)(;)','ms_logger.\3(l_node);');
  
 
  restore_comments_and_quotes;
 
  exception 
    when x_restore_failed then
      ms_logger.fatal(l_node, 'x_restore_failed');
      wedge( i_new_code => 'RESTORE FAILED'
            ,i_colour  => G_COLOUR_ERROR);
      l_advised := false;
    when x_invalid_keyword then
      ms_logger.fatal(l_node, 'x_invalid_keyword');
      wedge( i_new_code => 'INVALID KEYWORD'
            ,i_colour  => G_COLOUR_ERROR);
      l_advised := false;
    when x_weave_timeout then
      ms_logger.fatal(l_node, 'x_weave_timeout');
      wedge( i_new_code => 'WEAVE TIMED OUT'
            ,i_colour  => G_COLOUR_ERROR);
      l_advised := false;
    when x_string_not_found then
      ms_logger.fatal(l_node, 'x_string_not_found');
      l_advised := false;
   
  end;
  
    ms_logger.note(l_node, 'elapsed_time_secs' ,elapsed_time_secs);
    
    g_code := REPLACE(g_code,g_aop_directive,'Logging by AOP_PROCESSOR on '||to_char(systimestamp,'DD-MM-YYYY HH24:MI:SS'));
  
  IF g_for_aop_html then
    g_code := REPLACE(REPLACE(g_code,'<<','&lt;&lt;'),'>>','&gt;&gt;');
      g_code := REGEXP_REPLACE(g_code,'(ms_logger)(.+)(;)','<B>\1\2\3</B>');
      g_code := '<PRE>'||g_code||'</PRE>';
  END IF;  
 
    p_code := trim_clob(i_clob => g_code);
 
    return l_advised;
 
  exception 
    when others then
      ms_logger.oracle_error(l_node); 
    raise;
  
  end weave;
  
 
  --------------------------------------------------------------------
  -- get_plsql
  --------------------------------------------------------------------
  function get_plsql ( i_object_name   in varchar2
                     , i_object_type   in varchar2
                     , i_object_owner  in varchar2 )  return clob is
  
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'get_plsql');     
    l_code clob;
  begin
    ms_logger.param(l_node, 'i_object_name  '          ,i_object_name   );
    ms_logger.param(l_node, 'i_object_type  '          ,i_object_type   );
    ms_logger.param(l_node, 'i_object_owner '          ,i_object_owner  );
 
    --dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE );

    l_code:= dbms_metadata.get_ddl(REPLACE(i_object_type,' ','_'), i_object_name, i_object_owner);

    IF i_object_type = 'TRIGGER' THEN
      l_code:= regexp_replace(l_code 
                            ,'(CREATE OR REPLACE TRIGGER )(.+)(ALTER TRIGGER .+)', 
                     '\1\2', 1, 0, 'n');
    END IF;

 
    return trim_clob(i_clob => l_code);
  end get_plsql;

  
  
  --------------------------------------------------------------------
  -- instrument_plsql
  --------------------------------------------------------------------  
  procedure instrument_plsql
  ( i_object_name   in varchar2
  , i_object_type   in varchar2
  , i_object_owner  in varchar2
  ) is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'instrument_plsql');
  
    l_orig_body clob;
    l_aop_body clob;
    l_html_body clob;
    l_advised boolean := false;
  begin 
  begin
    ms_logger.param(l_node, 'i_object_name'  ,i_object_name  );
    ms_logger.param(l_node, 'i_object_type'  ,i_object_type  );
    ms_logger.param(l_node, 'i_object_owner' ,i_object_owner );
    g_during_advise:= true;
    -- test for state of package; no sense in trying to post-process an invalid package
    
    -- if valid then retrieve source
    l_orig_body:= get_plsql( i_object_name    => i_object_name
                           , i_object_owner   => i_object_owner
                           , i_object_type    => i_object_type   );
    -- check if perhaps the AOP_NEVER string is included that indicates that no AOP should be applied to a program unit
    -- (this bail-out is primarily used for this package itself, riddled as it is with AOP instructions)
  -- Conversely it also checks for @AOP_LOG, which must be present or AOP will also exit.
  --This ensure that a routine is not logged unless explicitly requested.
  --Also AOP will remove AOP_LOG in the AOP Source, so that logging cannot be doubled-up.
    if instr(l_orig_body, g_aop_never) > 0 THEN
      g_during_advise:= false; 
	  ms_logger.info(l_node, '@AOP_NEVER found.  AOP_PROCESSOR skipping this request' );
      return;
    elsif instr(l_orig_body, g_aop_directive) = 0 then
      g_during_advise:= false; 
	  ms_logger.info(l_node, '@AOP_LOG not found.  AOP_PROCESSOR skipping this request' );
      return;
    end if;
  
  IF NOT  validate_source(i_name  => i_object_name
                        , i_type  => i_object_type
                        , i_text  => l_orig_body
                        , i_aop_ver => 'ORIG'
                        , i_compile => TRUE
                        ) THEN
    g_during_advise:= false; 
	ms_logger.info(l_node, 'Original Source is invalid.  AOP_PROCESSOR skipping this request' );
    return;    
  end if;     
 
    l_aop_body := l_orig_body;
    -- manipulate source by weaving in aspects as required; only weave if the key logging not yet applied.
    l_advised := weave( p_code         => l_aop_body
                      , p_package_name => lower(i_object_name)
                      , p_end_user     => i_object_owner        );
 
    -- (re)compile the source 
    ms_logger.comment(l_node, 'Validate the AOP version.' );
    IF NOT validate_source(i_name  => i_object_name
                       , i_type  => i_object_type
                       , i_text  => l_aop_body
                       , i_aop_ver => 'AOP'
                       , i_compile => l_advised  ) THEN
      ms_logger.info(l_node, 'Recompile the Original version.' );
      --reexecute the original so that we at least end up with a valid package.
      IF NOT  validate_source(i_name  => i_object_name
                            , i_type  => i_object_type
                            , i_text  => l_orig_body
                            , i_aop_ver => 'ORIG'
                            , i_compile => TRUE) THEN
      --unlikely that will get an error in the original if it worked last time
      --but trap it incase we do  
          ms_logger.fatal(l_node,'Original Source is invalid on second try.');      
      end if;
    end if;
  

    --Reweave with html - even if the AOP failed.
    --We want to see what happened.
    ms_logger.comment(l_node,'Reweave with html');  
    l_html_body := l_orig_body;
      l_advised := weave( p_code         => l_html_body
                        , p_package_name => lower(i_object_name)
                        , p_for_html     => true
                        , p_end_user     => i_object_owner);
 
    IF NOT validate_source(i_name  => i_object_name
                         , i_type  => i_object_type
                         , i_text  => l_html_body
                         , i_aop_ver => 'AOP_HTML'
                         , i_compile => FALSE) THEN
      ms_logger.fatal(l_node,'Oops problem committing AOP_HTML.');             
   
    END IF;
 
    
    g_during_advise:= false; 

  exception 
    when others then
      ms_logger.oracle_error(l_node); 
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
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL) is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'reapply_aspect'); 
  begin
    ms_logger.param(l_node, 'i_object_name', i_object_name);
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
                          , i_object_owner => l_object.owner);
  
      end loop;
  end reapply_aspect;


  --------------------------------------------------------------------
  -- restore_comments_and_quotes
  --------------------------------------------------------------------  
  procedure restore_comments_and_quotes IS
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'restore_comments_and_quotes'); 
      l_text CLOB;    
      l_temp_code CLOB;
  BEGIN
    --Reset the processing pointer.
    g_current_pos := 1;
 
    FOR l_index in 1..g_comment_stack.count loop
      ms_logger.note(l_node, 'comment', l_index);
      l_temp_code := g_code;
      l_text := f_colour(i_text   => g_comment_stack(l_index)
                        ,i_colour => G_COLOUR_COMMENT);
      g_code := REPLACE(g_code,'<<comment'||l_index||'>>',l_text);

      IF l_temp_code = g_code THEN
         ms_logger.warning(l_node, 'Did not find '||'<<comment'||l_index||'>>');
         wedge( i_new_code => 'LOOKING FOR '||'<<comment'||l_index||'>>'
                ,i_colour  => G_COLOUR_ERROR);
        RAISE x_restore_failed;
      END IF; 
 
    END LOOP;
  
    FOR l_index in 1..g_quote_stack.count loop
      ms_logger.note(l_node, 'quote', l_index);
      l_temp_code := g_code;
      l_text := f_colour(i_text   => g_quote_stack(l_index)
                        ,i_colour => G_COLOUR_QUOTE);
      g_code := REPLACE(g_code,'<<quote'||l_index||'>>',l_text);

      IF l_temp_code = g_code THEN
         ms_logger.warning(l_node, 'Did not find '||'<<quote'||l_index||'>>');
         wedge( i_new_code => 'LOOKING FOR '||'<<quote'||l_index||'>>'
                ,i_colour  => G_COLOUR_ERROR);
        RAISE x_restore_failed;
      END IF; 

  END LOOP;





  END;
  
  --------------------------------------------------------------------
  -- stash_comments_and_quotes
  -- www.orafaq.com/forum/t/99722/2/ discussion of alternative methods.
  --------------------------------------------------------------------

    procedure stash_comments_and_quotes  IS
       
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'stash_comments_and_quotes');  
  
      l_keyword              VARCHAR2(50);  

  procedure extract_comment(i_mask     IN VARCHAR2
                           ,i_modifier IN VARCHAR2 DEFAULT 'in') IS
    l_comment              CLOB;
  BEGIN
    l_comment := get_next(i_stop     => i_mask
                           ,i_modifier => i_modifier ); --multi-line, lazy
    ms_logger.note_clob(l_node, 'l_comment', l_comment);
    g_comment_stack(g_comment_stack.count+1) := l_comment; --Put another comment on the stack
    ms_logger.note(l_node, 'g_comment_stack.count', g_comment_stack.count);
    g_code := REGEXP_REPLACE(g_code, i_mask, '<<comment'||g_comment_stack.count||'>>',g_current_pos, 1, i_modifier);
    go_past(i_search => '<<comment'||g_comment_stack.count||'>>'
           ,i_colour => NULL);
      
  END;
  
  procedure extract_quote(i_mask     IN VARCHAR2
                         ,i_modifier IN VARCHAR2 DEFAULT 'in') IS
    l_quote              CLOB;
  BEGIN
    l_quote := get_next(i_stop     => i_mask
                       ,i_modifier => i_modifier ); --multi-line, lazy
    ms_logger.note(l_node, 'l_quote', l_quote);
    g_quote_stack(g_quote_stack.count+1) := l_quote; --Put another quote on the stack
    ms_logger.note(l_node, 'g_quote_stack.count', g_quote_stack.count);
    g_code := REGEXP_REPLACE(g_code, i_mask, '<<quote'||g_quote_stack.count||'>>',g_current_pos, 1, i_modifier);
    go_past(i_search => '<<quote'||g_quote_stack.count||'>>'
           ,i_colour => NULL);
  END;
 
BEGIN  
 
   g_current_pos   := 1;
 
   --initialise comments and quotes
   
   g_comment_stack.DELETE;  
   g_quote_stack.DELETE;
 
 
  loop
   
   DECLARE
  
   G_REGEX_START_ANNOTATION      CONSTANT VARCHAR2(50) :=  '--(""|\?\?|!!|##)';

   G_REGEX_START_SINGLE_COMMENT  CONSTANT VARCHAR2(50) :=  '--..'    ;
   G_REGEX_START_MULTI_COMMENT   CONSTANT VARCHAR2(50) :=  '/\*'    ;
   G_REGEX_START_QUOTE           CONSTANT VARCHAR2(50) :=  '\'''    ;
   G_REGEX_START_ADV_QUOTE       CONSTANT VARCHAR2(50) :=  'Q\''\S' ;

   G_REGEX_SHOW_ME               CONSTANT VARCHAR2(50) :=  '--(\@\@)';
   G_REGEX_ROW_COUNT             CONSTANT VARCHAR2(50) :=  '--(RC)';
 
   G_REGEX_START_COMMENT_OR_QUOTE CONSTANT VARCHAR2(200) := G_REGEX_START_SINGLE_COMMENT  
                                                     ||'|'||G_REGEX_START_MULTI_COMMENT
                                                     ||'|'||G_REGEX_START_QUOTE
                                                     ||'|'||G_REGEX_START_ADV_QUOTE;
 
   G_REGEX_SINGLE_LINE_ANNOTATION   CONSTANT VARCHAR2(50)  :=    '.*';
   G_REGEX_SINGLE_LINE_COMMENT      CONSTANT VARCHAR2(50)  :=    '--.*';
   G_REGEX_MULTI_LINE_COMMENT       CONSTANT VARCHAR2(50)  :=    '/\*.*?\*/'; --'/\*(\s|\S)*?\*/';
   G_REGEX_MULTI_LINE_QUOTE         CONSTANT VARCHAR2(50)  :=    '\''.*?\''';
   G_REGEX_MULTI_LINE_ADV_QUOTE     CONSTANT VARCHAR2(100) :=    'Q\''\[.*?\]\''|Q\''\{.*?\}\''|Q\''\(.*?\)\''|Q\''\<.*?\>\''|Q\''(\S).*?\1\''';
 
    BEGIN
 
      --Searching for the start of a comment or quote
      l_keyword :=  get_next(i_stop       => G_REGEX_START_COMMENT_OR_QUOTE
                            ,i_upper      => TRUE   );
 
      ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
    
      CASE 

      WHEN regex_match(l_keyword , G_REGEX_START_SINGLE_COMMENT)  THEN 


  
          --Check for an annotation                         
          IF regex_match(l_keyword , G_REGEX_START_ANNOTATION) THEN                           
            ms_logger.info(l_node, 'Annotation');         
            --ANNOTATION          
            go_past;          
            extract_comment(i_mask     => G_REGEX_SINGLE_LINE_ANNOTATION          
                           ,i_modifier => 'i');   

          ELSIF regex_match(l_keyword , G_REGEX_SHOW_ME) THEN                           
            ms_logger.info(l_node, 'Show Me');         
            --SHOW ME
            --Just ignore this till later.      
            go_past;  

          ELSIF regex_match(l_keyword , G_REGEX_ROW_COUNT) THEN                           
            ms_logger.info(l_node, 'Rowcount');         
            --ROWCOUNT
            --Just ignore this till later.      
            go_past;  


 
          ELSE
 
            --Just a comment
            ms_logger.info(l_node, 'Single Line Comment');         
          --REMOVE SINGLE LINE COMMENTS 
          --Find "--" and remove chars upto EOL     
        extract_comment(i_mask     => G_REGEX_SINGLE_LINE_COMMENT
                       ,i_modifier => 'i');
    
          END IF;
  
 
      WHEN regex_match(l_keyword , G_REGEX_START_MULTI_COMMENT)  THEN  
           ms_logger.info(l_node, 'Multi Line Comment');  
        --REMOVE MULTI-LINE COMMENTS 
        --Find "/*" and remove upto "*/" 
      extract_comment(i_mask => G_REGEX_MULTI_LINE_COMMENT);
                        -- ,i_modifier => 'i');
 
      WHEN regex_match(l_keyword , G_REGEX_START_ADV_QUOTE)  THEN  
           ms_logger.info(l_node, 'Multi Line Adv Quote');  
      --REMOVE ADVANCED QUOTES - MULTI_LINE
      --Find "q'[" and remove to next "]'", variations in clude [] {} <> () and any single printable char.
      extract_quote(i_mask => G_REGEX_MULTI_LINE_ADV_QUOTE);
          
      WHEN regex_match(l_keyword , G_REGEX_START_QUOTE)  THEN  
           ms_logger.info(l_node, 'Multi Line Simple Quote');
      --REMOVE SIMPLE QUOTES - MULTI_LINE
          --Find "'" and remove to next "'"     
      extract_quote(i_mask => G_REGEX_MULTI_LINE_QUOTE);
          
 
    ELSE 
      EXIT;
    
    END CASE; 
  
  END;
 
  
  END LOOP; 
  
  ms_logger.comment(l_node, 'No more comments or quotes.'); 
  
    exception
      when others then
        ms_logger.warn_error(l_node);
        raise;
     
    END stash_comments_and_quotes;
  
 function using_aop(i_object_name IN VARCHAR2
                   ,i_object_type IN VARCHAR2 DEFAULT 'PACKAGE BODY') return varchar2 is

    CURSOR cu_dba_source is
    select 1
    from dba_source_v
    where NAME = i_object_name
    and type   = i_object_type
    and text like '%Logging by AOP_PROCESSOR%';

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
 
end aop_processor;
/
show error;

set define on;

--alter trigger aop_processor_trg enable;