alter trigger aop_processor_trg disable;

--Ensure no inlining so ms_logger can be used
alter session set plsql_optimize_level = 1;

set define off;

create or replace package body aop_processor is
  -- AUTHID CURRENT_USER
  -- @AOP_NEVER
 
  g_package_name        CONSTANT VARCHAR2(30) := 'aop_processor'; 
 
  g_during_advise boolean:= false;
  
  g_aop_directive CONSTANT VARCHAR2(30) := '@AOP_LOG'; 
 
  g_for_aop_html      boolean := false;
 
  g_weave_start_time  date;
  
  G_TIMEOUT_SECS_PER_1000_LINES CONSTANT NUMBER := 30; 
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
  
  g_aop_module_name    VARCHAR2(30); 
 
  ----------------------------------------------------------------------------
  -- REGULAR EXPRESSIONS
  ----------------------------------------------------------------------------
  G_REGEX_WORD          VARCHAR2(10) := '\w+';  
 
  G_REGEX_PKG_BODY       CONSTANT VARCHAR2(50) := '\sPACKAGE\s+?BODY\s';
  G_REGEX_PROCEDURE      CONSTANT VARCHAR2(50) := '\sPROCEDURE\s';
  G_REGEX_FUNCTION       CONSTANT VARCHAR2(50) := '\sFUNCTION\s';
  G_REGEX_PROG_UNIT      CONSTANT VARCHAR2(200) := G_REGEX_PKG_BODY
                                            ||'|'||G_REGEX_PROCEDURE
                                            ||'|'||G_REGEX_FUNCTION;
  
  G_REGEX_JAVA           CONSTANT VARCHAR2(50) := '\sLANGUAGE\s+?JAVA\s+?NAME\s';
 
  --Opening Blocks
  G_REGEX_DECLARE       CONSTANT VARCHAR2(50) := '\sDECLARE\s';
  G_REGEX_BEGIN         CONSTANT VARCHAR2(50) := '\sBEGIN\s';
  G_REGEX_LOOP          CONSTANT VARCHAR2(50) := '\sLOOP\s';
  G_REGEX_CASE          CONSTANT VARCHAR2(50) := '\sCASE\s';
  G_REGEX_IF            CONSTANT VARCHAR2(50) := '\sIF\s';
  --Neutral Blocks
  G_REGEX_ELSE          CONSTANT VARCHAR2(50) := '\sELSE\s';
  G_REGEX_ELSIF         CONSTANT VARCHAR2(50) := '\sELSIF\s';
  G_REGEX_WHEN          CONSTANT VARCHAR2(50) := '\sWHEN\s';
  G_REGEX_THEN          CONSTANT VARCHAR2(50) := '\sTHEN\s';
  G_REGEX_EXCEPTION     CONSTANT VARCHAR2(50) := '\sEXCEPTION\s';
  --Closing Blocks
  G_REGEX_END_BEGIN     CONSTANT VARCHAR2(50) := '\sEND\s*?\w*?\s*?;';    --END(any whitespace)(any wordschars)(any whitespace)SEMI-COLON
  G_REGEX_END_LOOP      CONSTANT VARCHAR2(50) := '\sEND\s+?LOOP\s*?;';
  G_REGEX_END_CASE      CONSTANT VARCHAR2(50) := '\sEND\s+?CASE\s*?;';
  G_REGEX_END_CASE_EXPR CONSTANT VARCHAR2(50) := '\sEND\W'; 
  G_REGEX_END_IF        CONSTANT VARCHAR2(50) := '\sEND\s+?IF\s*?;';
   
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
 
  G_REGEX_CLOSE        CONSTANT VARCHAR2(200) :=  G_REGEX_END_BEGIN    
                                           ||'|'||G_REGEX_END_LOOP     
                                           ||'|'||G_REGEX_END_CASE     
                                           ||'|'||G_REGEX_END_CASE_EXPR
                                           ||'|'||G_REGEX_END_IF;    
 
 
  --Param searching
  G_REGEX_OPEN_BRACKET    CONSTANT VARCHAR2(20) := '\('; 
  G_REGEX_CLOSE_BRACKET   CONSTANT VARCHAR2(20) := '\)'; 
  G_REGEX_COMMA           CONSTANT VARCHAR2(20) := '\,'; 
  
  G_REGEX_IS_AS           CONSTANT VARCHAR2(20) := '\sIS\s|\sAS\s'; 
  G_REGEX_DEFAULT         CONSTANT VARCHAR2(20) := '(DEFAULT|:=)';
  
  G_REGEX_PARAM_LINE      CONSTANT VARCHAR2(200) := '\s*\w+\s+(IN\s+OUT\s+|IN\s+|OUT\s+)?\w+';
 
  G_REGEX_START_ANNOTATION      CONSTANT VARCHAR2(50) :=  '--(""|\?\?|!!|##)';
  
  G_REGEX_STASHED_COMMENT    VARCHAR2(50) := '##comment\d+##';
  G_REGEX_COMMENT    VARCHAR2(50) := '--""';
  G_REGEX_INFO       VARCHAR2(50) := '--\?\?';
  G_REGEX_WARNING    VARCHAR2(50) := '--!!';
  G_REGEX_FATAL      VARCHAR2(50) := '--##';  
  
 
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
  G_COLOUR_PKG_BEGIN        CONSTANT VARCHAR2(10) := '#CCCC00'; 
  G_COLOUR_GO_PAST          CONSTANT VARCHAR2(10) := '#FF9999'; 
  G_COLOUR_BRACKETS         CONSTANT VARCHAR2(10) := '#FF5050'; 
  G_COLOUR_EXCEPTION_BLOCK  CONSTANT VARCHAR2(10) := '#FF9933'; 
  G_COLOUR_JAVA             CONSTANT VARCHAR2(10) := '#33CCCC'; 
  G_COLOUR_ANNOTATION       CONSTANT VARCHAR2(10) := '#FFCCFF'; 
  G_COLOUR_BIND_VAR         CONSTANT VARCHAR2(10) := '#FFFF00';
  G_COLOUR_NOTE             CONSTANT VARCHAR2(10) := '#00FF99';
 
  
  FUNCTION matched_with(i_match    IN CLOB
                       ,i_search   IN VARCHAR2 	) RETURN BOOLEAN IS
  BEGIN
    RETURN REGEXP_LIKE(' '||i_match||' ',i_search);
  END;
 
  function elapsed_time_secs return integer is
  begin
    return (sysdate - g_weave_start_time) * 24 * 60 * 60;
  end;
 
  FUNCTION f_colour(i_text   IN CLOB
                   ,i_colour IN VARCHAR2) RETURN CLOB IS
  BEGIN
    IF g_for_aop_html AND i_colour IS NOT NULL THEN
	  RETURN '<span style="background-color:#'||LTRIM(i_colour,'#')||';">'
	       ||i_text
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
    g_weave_timeout_secs := ROUND(l_weave_line_count/1000*G_TIMEOUT_SECS_PER_1000_LINES);
    ms_logger.note(l_node, 'g_weave_timeout_secs ',g_weave_timeout_secs );
	g_weave_start_time := SYSDATE;
 
  END;
 
  --------------------------------------------------------------------
  -- during_advise
  --------------------------------------------------------------------
  
  function during_advise 
  return boolean
  is
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
					  ) RETURN boolean IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'validate_source');              
                      
    l_aop_source    aop_source%ROWTYPE;    
    PRAGMA AUTONOMOUS_TRANSACTION;
 
  BEGIN     
 
    ms_logger.param(l_node, 'i_name      '          ,i_name   );
    ms_logger.param(l_node, 'i_type      '          ,i_type      );
    --ms_logger.param(l_node, 'i_text    '          ,i_text          ); --too big.
	ms_logger.param(l_node, 'i_aop_ver   '           ,i_aop_ver      );

	--Prepare record.
    l_aop_source.name          := i_name;
	l_aop_source.type          := i_type;
    l_aop_source.aop_ver       := i_aop_ver;
    l_aop_source.text          := i_text;
    l_aop_source.load_datetime := sysdate;
    l_aop_source.valid_yn      := 'Y';
    l_aop_source.result        := 'Success.';
	
	if i_aop_ver like '%HTML' then
	  l_aop_source.valid_yn := NULL;
	else
	
      begin
	    execute immediate 'alter session set plsql_optimize_level = 1';
	  
        execute immediate i_text;  --11G CLOB OK
	  exception
        when others then
	      l_aop_source.result   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	  	  l_aop_source.valid_yn := 'N';
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
 
	logger.ins_upd_aop_source(i_aop_source => l_aop_source);
     
    COMMIT;
	
	RETURN l_aop_source.valid_yn = 'Y';
   
      
  END;
 
  

 
 
  --------------------------------------------------------------------
  -- splice
  --------------------------------------------------------------------
    procedure splice( p_code     in out clob
                     ,p_new_code in clob
                     ,p_pos      in out number
					 ,p_indent    in number   default null
					 ,p_colour   in varchar2 default null ) IS
                     
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'splice');  
	  l_new_code        CLOB;
	  l_colour          VARCHAR2(10);
 
    BEGIN
  
      --ms_logger.param(l_node, 'p_code'          ,p_code );
      --ms_logger.param(l_node, 'LENGTH(p_code)'  ,LENGTH(p_code)  );
      --ms_logger.param(l_node, 'p_new_code'      ,p_new_code);
      ms_logger.param(l_node, 'p_pos     '      ,p_pos     );
	  ms_logger.param(l_node, 'p_indent     '    ,p_indent     );
	  ms_logger.param(l_node, 'p_colour  '      ,p_colour     );
 
	  ms_logger.note(l_node, 'g_for_aop_html     '     ,g_for_aop_html     );
 
	  l_new_code := f_colour(i_text   => p_new_code
	                        ,i_colour => NVL(p_colour, G_COLOUR_SPLICE));

      ms_logger.note(l_node, 'l_new_code     '     ,l_new_code     );
	  
	  IF p_indent is not null then
	    l_new_code := replace(chr(10)||l_new_code,chr(10),chr(10)||rpad(' ',(p_indent-1)*2+2,' '))||chr(10);
	  END IF; 
 
      p_code:= substr(p_code, 1, p_pos)
	         ||l_new_code
             ||substr(p_code, p_pos+1);
  
	  p_pos := p_pos + length(l_new_code) ;	
	  
	  --ms_logger.note(l_node, 'p_code     '     ,p_code     );
	  --ms_logger.note(l_node, 'p_pos     '      ,p_pos     );
 
    END;
	
  --------------------------------------------------------------------
  -- splice_here
  --------------------------------------------------------------------
    PROCEDURE splice_here( i_new_code in varchar2
                          ,i_colour   in varchar2 default null) IS
	
	BEGIN
	  IF i_new_code IS NOT NULL THEN
	    splice( p_code      => g_code    
	           ,p_new_code  => i_new_code
	           ,p_pos       => g_current_pos
               ,p_colour    => i_colour	 );
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
	    g_current_pos := g_current_pos - 1;
	    splice( p_code      => g_code    
	           ,p_new_code  => i_new_code
	           ,p_pos       => g_current_pos     
	           ,p_indent    => i_indent
               ,p_colour    => i_colour	 );  
	  END IF;			 
	END;
	

--------------------------------------------------------------------------------- 
-- ATOMIC
--------------------------------------------------------------------------------- 


--------------------------------------------------------------------------------- 
-- get_next - return first matching string, stripped of upto 1 leading and trailing whitespace
-- if colour is not null and the result is not null then current position will advance
---------------------------------------------------------------------------------

FUNCTION get_next(i_search             IN VARCHAR2 DEFAULT NULL
                 ,i_stop               IN VARCHAR2 DEFAULT NULL
                 ,i_modifier           IN VARCHAR2 DEFAULT 'i'
				 ,i_upper              IN BOOLEAN  DEFAULT FALSE
                 ,i_lower              IN BOOLEAN  DEFAULT FALSE
				 ,i_colour             IN VARCHAR2 DEFAULT NULL 
                 ,i_raise_error        IN BOOLEAN  DEFAULT FALSE
                 ,i_trim  		       IN BOOLEAN  DEFAULT TRUE
                 ,i_sub_expr		   IN POSITIVE DEFAULT NULL	 ) return CLOB IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'get_next');	
  
  l_either_match   VARCHAR2(32000);
  l_colour_either_match   VARCHAR2(32000);
  l_search_match   VARCHAR2(32000);
  l_result         VARCHAR2(32000);
  l_either         VARCHAR2(32000);
  
BEGIN
  check_timeout; --GET_NEXT
  ms_logger.param(l_node, 'i_search',i_search);
  ms_logger.param(l_node, 'i_stop',i_stop);
  
  l_either := TRIM('|' FROM i_search ||'|'||i_stop); 
 
  --Keep the original "either" match
  l_either_match := REGEXP_SUBSTR(g_code,l_either,g_current_pos,1,i_modifier);
  --l_either_match := REGEXP_SUBSTR(g_code,l_either,g_current_pos,1,i_modifier,i_sub_expr);
  IF i_trim THEN
    l_result := TRIM(REGEXP_REPLACE(l_either_match,'^\s|\s$',''));
  ELSE
   l_result := l_either_match;
  END IF; 
  --Check that the match is a consumable match, meaning we will advance the g_current_pos.
  l_search_match := REGEXP_SUBSTR(l_either_match,i_search,1,1,i_modifier);
  l_search_match := TRIM(REGEXP_REPLACE(l_search_match,'^\s|\s$',''));
  ms_logger.note(l_node, 'l_search_match',l_search_match  );
  ms_logger.note_length(l_node, 'l_search_match',l_search_match  );
 
  IF l_result IS NULL AND i_raise_error THEN
	ms_logger.fatal(l_node, 'String missing '||l_either);
	splice_here( i_new_code => 'STRING NOT FOUND '||l_either
	            ,i_colour   => G_COLOUR_ERROR);
    RAISE x_string_not_found;
	
  END IF;	
  
  --Calculate the new positions.  VERIFY THAT THIS SHOULD STILL BE GLOBAL!!  Eg how often do i use go_past;
  g_upto_pos := REGEXP_INSTR(g_code,l_either,g_current_pos,1,0,i_modifier);
  g_past_pos := REGEXP_INSTR(g_code,l_either,g_current_pos,1,1,i_modifier);   

  IF l_result IS NOT NULL and l_search_match IS NOT NULL THEN
    ms_logger.note(l_node, 'l_result IS NOT NULL',l_result IS NOT NULL);
    ms_logger.note(l_node, 'l_search_match IS NOT NULL',l_search_match IS NOT NULL);
    ms_logger.comment(l_node, 'Consuming:' ||l_result);
 
    --Don't default a colour, that will stuff up the comment extraction routines.
    
     
    l_colour_either_match := f_colour(i_text   => l_either_match	
	                                 ,i_colour => i_colour);
 
    g_code := SUBSTR(g_code,1,g_upto_pos-1)
            ||l_colour_either_match
            ||SUBSTR(g_code,g_past_pos)  ;
	 	   
    g_past_pos := g_upto_pos + LENGTH(l_colour_either_match);
    
    g_current_pos := g_past_pos;
  
  end if;
  
  IF i_upper THEN     
    RETURN UPPER(l_result);
  ELSIF i_lower THEN
    RETURN LOWER(l_result);
  ELSE
    RETURN l_result;
  END IF;	
END get_next;
--------------------------------------------------------------------------------- 
-- get_next_lower - deprecated
--------------------------------------------------------------------------------- 
FUNCTION get_next_lower(i_search             IN VARCHAR2 DEFAULT NULL
                       ,i_stop               IN VARCHAR2 DEFAULT NULL
                       ,i_modifier           IN VARCHAR2 DEFAULT 'i'
				       ,i_colour             IN VARCHAR2 DEFAULT NULL 
                       ,i_raise_error        IN BOOLEAN  DEFAULT FALSE
                       ,i_trim  		     IN BOOLEAN  DEFAULT TRUE
                       ,i_sub_expr		     IN POSITIVE DEFAULT NULL	 )return CLOB IS 
BEGIN
  RETURN LOWER(get_next(i_search      => i_search     
                       ,i_stop        => i_stop       
					   ,i_modifier    => i_modifier   
					   ,i_colour      => i_colour     
					   ,i_raise_error => i_raise_error
                       ,i_trim        => i_trim	
  					   ,i_sub_expr    => i_sub_expr ));
END;
--------------------------------------------------------------------------------- 
-- get_next_upper - deprecated
--------------------------------------------------------------------------------- 
FUNCTION get_next_upper(i_search             IN VARCHAR2 DEFAULT NULL
                       ,i_stop               IN VARCHAR2 DEFAULT NULL
                       ,i_modifier           IN VARCHAR2 DEFAULT 'i'
				       ,i_colour             IN VARCHAR2 DEFAULT NULL 
                       ,i_raise_error        IN BOOLEAN  DEFAULT FALSE
                       ,i_trim  		     IN BOOLEAN  DEFAULT TRUE
                       ,i_sub_expr		     IN POSITIVE DEFAULT NULL	 )return CLOB IS 
BEGIN
  RETURN UPPER(get_next(i_search      => i_search     
                       ,i_stop        => i_stop       
					   ,i_modifier    => i_modifier   
					   ,i_colour      => i_colour     
					   ,i_raise_error => i_raise_error
                       ,i_trim        => i_trim	
  					   ,i_sub_expr    => i_sub_expr ));
END;

--------------------------------------------------------------------------------- 
-- go
---------------------------------------------------------------------------------
PROCEDURE go(i_search     IN VARCHAR2
            ,i_modifier   IN VARCHAR2 
			,i_past_prior IN INTEGER
			,i_offset     IN INTEGER DEFAULT 0) IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'go');
  l_new_pos INTEGER;
BEGIN
  check_timeout; --GO
  ms_logger.param(l_node, 'i_search'    ,i_search);
  ms_logger.param(l_node, 'i_modifier'  ,i_modifier);
  ms_logger.param(l_node, 'i_past_prior',i_past_prior);
  ms_logger.param(l_node, 'i_offset'    ,i_offset);
  l_new_pos := REGEXP_INSTR(g_code,i_search,g_current_pos,1,i_past_prior,i_modifier);
  IF l_new_pos = 0 then
    ms_logger.fatal(l_node, 'String missing '||i_search);
	splice_here( i_new_code => 'STRING NOT FOUND '||i_search
	            ,i_colour   => G_COLOUR_ERROR);
    raise x_string_not_found;
  end if;
  g_current_pos := l_new_pos + i_offset;
END;


--------------------------------------------------------------------------------- 
-- go_past
---------------------------------------------------------------------------------
PROCEDURE go_past(i_search   IN VARCHAR2 DEFAULT NULL
                 ,i_modifier IN VARCHAR2 DEFAULT 'i'
				 ,i_offset   IN INTEGER  DEFAULT 0
                 ,i_colour   IN VARCHAR2 DEFAULT G_COLOUR_GO_PAST) IS
  l_dummy CLOB;
BEGIN

  IF i_search is null then
    --just goto the position found during last get_next
	g_current_pos := g_past_pos;
  ELSE
 
     l_dummy := get_next(i_search      => i_search     
                        ,i_stop        => NULL       
                        ,i_modifier    => i_modifier   
                        ,i_colour      => i_colour     
                        ,i_raise_error => TRUE );
 
  END IF;
 
END;

--------------------------------------------------------------------------------- 
-- go_upto
---------------------------------------------------------------------------------
PROCEDURE go_upto(i_search    IN VARCHAR2 DEFAULT NULL
                  ,i_modifier IN VARCHAR2 DEFAULT 'i'
				  ,i_offset   IN INTEGER  DEFAULT -1) IS
 
BEGIN

  IF i_search is null then
    --just goto the position found during last get_next
	g_current_pos := g_upto_pos;
  ELSE

    go(i_search     => i_search    
      ,i_modifier   => i_modifier  
      ,i_past_prior => 0
      ,i_offset     => i_offset);
  END IF;
 
 
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
PROCEDURE AOP_prog_units(i_indent IN INTEGER);


--------------------------------------------------------------------------------- 
-- AOP_pu_block - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_pu_block(i_prog_unit_name IN VARCHAR2
                      ,i_params         IN CLOB
                      ,i_indent          IN INTEGER );

--------------------------------------------------------------------------------- 
-- AOP_block
---------------------------------------------------------------------------------
PROCEDURE AOP_block(i_indent         IN INTEGER
                   ,i_nest           IN INTEGER
                   ,i_regex_end      IN VARCHAR2 );                      
                      
--------------------------------------------------------------------------------- 
-- END FORWARD DECLARATIONS
--------------------------------------------------------------------------------- 				
		

 
--------------------------------------------------------------------------------- 
-- AOP_pu_params
---------------------------------------------------------------------------------
FUNCTION AOP_pu_params return CLOB is
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_params'); 
  l_param_injection      CLOB;
  l_param_line           CLOB;
  l_param_name           VARCHAR2(30);
  l_param_type           VARCHAR2(50);
  l_keyword              CLOB;
  l_bracket              VARCHAR2(50);
  x_out_param            EXCEPTION;
  x_unhandled_param_type EXCEPTION;
  
 
  l_bracket_count        INTEGER;
 
BEGIN  
 
  loop
    BEGIN

      --Find first: "(" "," "DEFAULT" ":=" "AS" "IS"
      l_keyword := get_next_upper( i_search       => G_REGEX_OPEN_BRACKET
                                              ||'|'||G_REGEX_COMMA
                                              ||'|'||G_REGEX_IS_AS
                                              ||'|'||G_REGEX_DEFAULT
                                  ,i_colour       => G_COLOUR_PROG_UNIT
                                  ,i_raise_error  => TRUE);
     
      ms_logger.note(l_node, 'l_keyword' ,REPLACE(l_keyword,chr(10),'#')); 
	  --ms_logger.note_length(l_node, 'l_keyword' ,l_keyword); 
	  
      CASE 
 
		--NEW PARAMETER LINE
		WHEN matched_with(l_keyword , G_REGEX_OPEN_BRACKET
                               ||'|'||G_REGEX_COMMA)        THEN
	      ms_logger.comment(l_node, 'Found new parameter');
		  --find the parameter - Search for Eg
          --  varname IN OUT vartype ,
          --  varname IN vartype)
  
          l_param_line := get_next( i_search       => G_REGEX_PARAM_LINE
                                   ,i_colour       => G_COLOUR_PARAM
                                   ,i_raise_error  => TRUE);	 
		  --Move onto next param
	      --go_past;--(l_param_line_mask);
	      
	  	  ms_logger.note(l_node, 'l_param_line',l_param_line);
          
		  IF UPPER(REGEXP_SUBSTR(l_param_line,G_REGEX_WORD,1,2,'i')) = 'OUT' THEN
		    RAISE x_out_param;
		  END IF;
          
	      --Remove remaining IN and OUT
	  	  l_param_line := REGEXP_REPLACE(l_param_line,'(\sIN\s)',' ',1,1,'i');
		  l_param_line := REGEXP_REPLACE(l_param_line,'(\sOUT\s)',' ',1,1,'i');
		  ms_logger.note(l_node, 'l_param_line',l_param_line);		
		  
	  	  l_param_name := LOWER(REGEXP_SUBSTR(l_param_line,G_REGEX_WORD,1,1,'i')); 
	  	  ms_logger.note(l_node, 'l_param_name',l_param_name);
	  	  l_param_type := UPPER(REGEXP_SUBSTR(l_param_line,G_REGEX_WORD,1,2,'i'));  
	  	  ms_logger.note(l_node, 'l_param_type',l_param_type);
	  	  IF  l_param_type NOT IN ('NUMBER'
	  	                          ,'INTEGER'
	  	  					      ,'BINARY_INTEGER'
	  	  					      ,'PLS_INTEGER'
	  	  					      ,'DATE'
	  						      ,'VARCHAR2'
	  						      ,'BOOLEAN') then
		    RAISE x_unhandled_param_type;
          END IF;		  
		  					
	  	  l_param_injection := LTRIM(l_param_injection||chr(10)||'  ms_logger.param(l_node,'''||l_param_name||''','||l_param_name||');',chr(10));
 
 
       --DEFAULT or :=
		WHEN matched_with(l_keyword , G_REGEX_DEFAULT) THEN 
		  ms_logger.comment(l_node, 'Found DEFAULT, searching for complex value');
 
		  l_bracket_count := 0;
		  loop
		    l_bracket := get_next( i_stop       => G_REGEX_OPEN_BRACKET
                                            ||'|'||G_REGEX_CLOSE_BRACKET
                                            ||'|'||G_REGEX_COMMA
                                  ,i_raise_error => TRUE);
 
            ms_logger.note(l_node, 'l_bracket' ,l_bracket); 
            CASE 
			  WHEN matched_with(l_bracket , G_REGEX_COMMA) THEN
			    EXIT WHEN l_bracket_count = 0;

	          WHEN matched_with(l_bracket , G_REGEX_OPEN_BRACKET) THEN
			    l_bracket_count := l_bracket_count + 1;

	          WHEN matched_with(l_bracket , G_REGEX_CLOSE_BRACKET) THEN
                l_bracket_count := l_bracket_count - 1;
				EXIT WHEN l_bracket_count = -1;

              ELSE 
			    ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
				RAISE x_invalid_keyword;
		    END CASE;	
		    go_past(i_colour => G_COLOUR_BRACKETS);
			
		  END LOOP;
 
	    --NO MORE PARAMS
		WHEN matched_with(l_keyword , G_REGEX_IS_AS) THEN EXIT;
          ms_logger.comment(l_node, 'No more parameters');
          
        --OOPS
        ELSE
		  ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
          RAISE x_invalid_keyword;
      END CASE;
    EXCEPTION
	  WHEN x_out_param THEN  
	    ms_logger.comment(l_node, 'Skipped OUT param');
	  WHEN x_unhandled_param_type THEN
	    ms_logger.comment(l_node, 'Unsupported param type');
	END;
 
  END LOOP; 
  
  --NB g_current_pos is still behind next keyword 'IS'
  return l_param_injection;
   
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_params;		
		
--------------------------------------------------------------------------------- 
-- AOP_declare
---------------------------------------------------------------------------------
PROCEDURE AOP_declare(i_indent       IN INTEGER) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_declare'); 
BEGIN

  --go_past('\sDECLARE\s');
  
  --Search for nested PROCEDURE and FUNCTION within the declaration section of the block.
  --Drop out when a BEGIN is reached.
 
  AOP_prog_units(i_indent => i_indent + 1);
  
  AOP_block(i_indent    => i_indent + 1
           ,i_nest      => 1
           ,i_regex_end => G_REGEX_END_BEGIN);
 
  
  --go_past('\sBEGIN\s');
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_declare;

	
--------------------------------------------------------------------------------- 
-- AOP_is_as
---------------------------------------------------------------------------------
PROCEDURE AOP_is_as(i_prog_unit_name IN VARCHAR2
                   ,i_indent          IN INTEGER
                   ,i_inject_node    IN VARCHAR2 DEFAULT NULL
				   ,i_node_type      IN VARCHAR2) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_is_as'); 
  l_inject_params   CLOB;
  
  l_keyword               VARCHAR2(50);

  
BEGIN

  l_inject_params := AOP_pu_params;
   
  --go_past('\sIS\s|\sAS\s');
 
 --LATER WANT TO REFACTOR THIS MY ONLY INJECTING A PACKAGE NODE IF THERE IS AN INITIALISATION BLOCK.
  inject( i_new_code  => i_inject_node
         ,i_indent     => i_indent
         ,i_colour     => G_COLOUR_NODE);   
 
  --Rest of IS_AS is a simple declaration.
  --AOP_declare(i_indent => i_indent);
  AOP_prog_units(i_indent => i_indent + 1);
  
  
  --If this is a package there may not be a BEGIN, just an END;
  
  l_keyword := get_next_upper( i_stop        => G_REGEX_BEGIN||'|'||G_REGEX_END_BEGIN
                              ,i_colour      => G_COLOUR_PKG_BEGIN
                              ,i_raise_error => TRUE                              );
 
  IF matched_with(l_keyword , G_REGEX_END_BEGIN) and i_node_type = 'new_pkg' THEN
    --Packages don't need to have BEGIN. 
	--and in this case we don't need the Initialisation node either, so remove it again.
	--(This will leave the colour there, but that won't be visible.)
	g_code := REPLACE(g_code, i_inject_node, ''); 
 
  ELSE
    
    AOP_pu_block(i_prog_unit_name  => i_prog_unit_name
                ,i_params          => l_inject_params
                ,i_indent          => i_indent);
 		
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
                   ,i_nest           IN INTEGER
                   ,i_regex_end      IN VARCHAR2 )  IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_block');
  
  l_keyword               VARCHAR2(50);
  l_stashed_comment       VARCHAR2(50);
  l_function              VARCHAR2(30);
  l_bind_var              VARCHAR2(30);

  
  
  G_REGEX_ASSIGN_TO_BIND_VAR  CONSTANT VARCHAR2(50) := ':\w+?\W+?:=';
  G_REGEX_BIND_VAR            CONSTANT VARCHAR2(50) := ':\w+?\W';
  
  
BEGIN

  ms_logger.note(l_node, 'i_indent    '     ,i_indent     );
  ms_logger.note(l_node, 'i_regex_end '     ,i_regex_end  );
 
 
  loop
 
	l_keyword := get_next_upper( i_search      => G_REGEX_OPEN
                                           ||'|'||G_REGEX_NEUTRAL
                                           ||'|'||G_REGEX_CLOSE
                                           ||'|'||G_REGEX_WHEN_OTHERS_THEN
                                ,i_stop        => G_REGEX_START_ANNOTATION --don't colour it
                                           ||'|'||G_REGEX_ASSIGN_TO_BIND_VAR
                                ,i_colour      => G_COLOUR_BLOCK);
 
	ms_logger.note(l_node, 'l_keyword',l_keyword);
 
    CASE 
	  WHEN matched_with(l_keyword , G_REGEX_DECLARE) THEN            
        AOP_declare(i_indent  => i_indent + 1);    
        
      WHEN matched_with(l_keyword , G_REGEX_BEGIN) THEN                                                     
        AOP_block(i_indent     => i_indent + 1
                 ,i_nest       => i_nest + 1
		         ,i_regex_end  => G_REGEX_END_BEGIN);     
                 
      WHEN matched_with(l_keyword , G_REGEX_LOOP) THEN                                                          
        AOP_block(i_indent     => i_indent + 1
                 ,i_nest       => i_nest + 1
		         ,i_regex_end  => G_REGEX_END_LOOP );                                
             
      WHEN matched_with(l_keyword , G_REGEX_CASE) THEN    
		--inc level +2 due to implied WHEN or ELSE
        AOP_block(i_indent     => i_indent + 2
                 ,i_nest       => i_nest + 1
		         ,i_regex_end  => G_REGEX_END_CASE||'|'||G_REGEX_END_CASE_EXPR );      
	 
      WHEN matched_with(l_keyword , G_REGEX_IF) THEN    
        AOP_block(i_indent     => i_indent + 1
                 ,i_nest       => i_nest + 1
		         ,i_regex_end  => G_REGEX_END_IF );

      WHEN matched_with(l_keyword , G_REGEX_NEUTRAL) THEN
        --Just let it keep going around the loop.
        NULL;
        
      --END_BEGIN will also match END_LOOP, END_CASE and END IF
      --So we need to make sure it hasn't matched on them.      
	  WHEN i_regex_end = G_REGEX_END_BEGIN              AND
           matched_with(l_keyword , i_regex_end)        AND 
           (  matched_with(l_keyword ,G_REGEX_END_LOOP) OR
              matched_with(l_keyword ,G_REGEX_END_CASE) OR 
              matched_with(l_keyword ,G_REGEX_END_IF)) THEN
	    ms_logger.fatal(l_node, 'Mis-matched Expected END; Got '||l_keyword);
		RAISE X_INVALID_KEYWORD;
 
	  WHEN matched_with(l_keyword ,i_regex_end) THEN
	     ms_logger.info(l_node, 'Block End Found!');
		EXIT;
        
	  WHEN matched_with(l_keyword ,G_REGEX_CLOSE) THEN
	    ms_logger.fatal(l_node, 'Mis-matched END Expecting :'||i_regex_end||' Got: '||l_keyword);
		RAISE X_INVALID_KEYWORD;
        
      WHEN matched_with(l_keyword ,G_REGEX_START_ANNOTATION) THEN
        --What sort of annotation is it?
         CASE 
           WHEN matched_with(l_keyword ,G_REGEX_COMMENT) THEN l_function := 'comment';
           WHEN matched_with(l_keyword ,G_REGEX_INFO   ) THEN l_function := 'info';
           WHEN matched_with(l_keyword ,G_REGEX_WARNING) THEN l_function := 'warning';
           WHEN matched_with(l_keyword ,G_REGEX_FATAL  ) THEN l_function := 'fatal';
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
						           ,i_colour => G_COLOUR_ANNOTATION)
						 ||l_stashed_comment||''');');
 
						  
      WHEN matched_with(l_keyword ,G_REGEX_ASSIGN_TO_BIND_VAR) THEN	 
        -- find assignment of bind variable and inject a note
        go_upto;	  
	    l_bind_var := get_next ( i_search      => G_REGEX_BIND_VAR
		                        ,i_lower       => TRUE
                                ,i_colour      => G_COLOUR_BIND_VAR);
		l_bind_var := RTRIM(l_bind_var,':'); 						
		go_past(';');	
        inject( i_new_code => 'ms_logger.note(l_node,'''||l_bind_var||''','||l_bind_var||');'
        	   ,i_indent   => i_indent
        	   ,i_colour   => G_COLOUR_NOTE);
			   
      WHEN matched_with(l_keyword ,G_REGEX_WHEN_OTHERS_THEN) THEN	 	   
	    --warn of error after WHEN OTHERS THEN	
        inject( i_new_code => 'ms_logger.warn_error(l_node);'
        	   ,i_indent   => i_indent
        	   ,i_colour   => G_COLOUR_EXCEPTION_BLOCK);
 
      ELSE
	    ms_logger.info(l_node,'No more blocks.');
		EXIT;

    END CASE;
    
    EXIT WHEN i_nest = 1;
 
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
                      ,i_params         IN CLOB
                      ,i_indent          IN INTEGER ) IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_block');
  
BEGIN
 
  --Add extra begin
  go_upto;--('\sBEGIN\s');
 
  inject( i_new_code  => 'begin --'||i_prog_unit_name
              ,i_indent     => i_indent
			  ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
  --Add the params (if any)
  inject( i_new_code  => i_params
         ,i_indent     => i_indent
		 ,i_colour    => G_COLOUR_PARAM);
 
  --First Block is BEGIN 
  AOP_block(i_indent    => i_indent + 1
           ,i_nest      => 1
           ,i_regex_end  => G_REGEX_END_BEGIN  );
  
  --Add extra exception handler
  --add the terminating exception handler of the new surrounding block
  inject( i_new_code  => 'exception'
  	               ||chr(10)||'  when others then'
  			       ||chr(10)||'    ms_logger.warn_error(l_node);'
  			       ||chr(10)||'    raise;'
  			       ||chr(10)||'end; --'||i_prog_unit_name
              ,i_indent     => i_indent
			  ,i_colour    => G_COLOUR_EXCEPTION_BLOCK);
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_block;


 
--------------------------------------------------------------------------------- 
-- AOP_prog_units
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_units(i_indent IN INTEGER ) IS
  l_node    ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_prog_units'); 

  l_keyword         VARCHAR2(50);
  l_node_type       VARCHAR2(50);
  l_inject_node     VARCHAR2(200);
  l_prog_unit_name  VARCHAR2(30);
  
  x_language_java_name EXCEPTION;
 
BEGIN
 
  LOOP
    BEGIN
 
        --Find node type
        l_keyword := get_next_upper( i_search      => G_REGEX_PROG_UNIT
                                    ,i_stop        => G_REGEX_BEGIN
                                    ,i_colour      => G_COLOUR_PROG_UNIT );
     
      ms_logger.note(l_node, 'l_keyword' ,l_keyword);   
      CASE 
        WHEN l_keyword LIKE 'PACKAGE%BODY' THEN
          l_node_type := 'new_pkg';
    	  l_prog_unit_name := 'Initialise';
        WHEN l_keyword = 'PROCEDURE' THEN
          l_node_type := 'new_proc';
          l_prog_unit_name := NULL;
        WHEN l_keyword = 'FUNCTION' THEN
          l_node_type := 'new_func';
          l_prog_unit_name := NULL;
    	WHEN l_keyword = 'BEGIN' OR l_keyword IS NULL THEN
    	  EXIT;
        ELSE
		  ms_logger.fatal(l_node, 'AOP BUG - REGEX Mismatch');
		  RAISE x_invalid_keyword;
      END CASE;	 
      ms_logger.note(l_node, 'l_node_type' ,l_node_type);  
     
      
      --Check for LANGUAGE JAVA NAME
      --If this is a JAVA function then we don't want a node and don't need to bother reading spec or parsing body.
      --Will find a LANGUAGE keyword before next ";"
      l_keyword := get_next_upper(i_search       => G_REGEX_JAVA 
                                 ,i_stop         => ';'
    		                     ,i_colour       => G_COLOUR_JAVA
                                 ,i_raise_error  => TRUE );
     
      ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
      IF l_keyword LIKE 'LANGUAGE%' THEN
        RAISE x_language_java_name; 
      END IF;
      
      --Get program unit name
      IF l_prog_unit_name IS NULL THEN
        l_prog_unit_name := get_next_lower(i_search  => G_REGEX_WORD     
                                          ,i_colour  => G_COLOUR_PU_NAME);
     
      END IF;
      ms_logger.note(l_node, 'l_prog_unit_name' ,l_prog_unit_name);
      
      l_inject_node    := '  l_node ms_logger.node_typ := ms_logger.'||l_node_type||'('||g_aop_module_name||' ,'''||l_prog_unit_name||''');';
     
      AOP_is_as(i_prog_unit_name => l_prog_unit_name
               ,i_indent         => i_indent
               ,i_inject_node    => l_inject_node
    		   ,i_node_type      => l_node_type);
    	
    EXCEPTION 
      WHEN x_language_java_name THEN
        ms_logger.comment(l_node, 'Found LANGUAGE JAVA NAME.');    
    END;
  END LOOP;
 
  ms_logger.comment(l_node, 'No more program units.');
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_prog_units;
 
 
--------------------------------------------------------------------------------- 
-- weave
---------------------------------------------------------------------------------
  function weave
  ( p_code in out clob
  , p_package_name in varchar2
  , p_for_html in boolean default false
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
 
	--First task will be to remove all comments or 
	--somehow identify and remember all sections that can be ignored because they are comments
	
	g_code := chr(10)||p_code||chr(10); --add a trailing CR to help with searching

    set_weave_timeout;
    
	stash_comments_and_quotes;
 
    --LATER WHEN WE WANT TO SUPPORT THE BEGIN SECTION OF A PACKAGE
	--WE WOULD REPLACE parse_prog_unit below with parse_anon_block
 
	--Change any program unit ending of form "end program_unit_name;" to just "end;" for simplicity
	--Preprocess p_code cleaning up block end statements.
    --IE Translate "END prog_unit_name;" -> "END;"	
 
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
	  l_keyword varchar2(50);
	
	begin
	  g_current_pos := 1;
	  l_keyword := get_next_upper(i_stop       => G_REGEX_DECLARE
                                           ||'|'||G_REGEX_BEGIN  
                                           ||'|'||G_REGEX_PROCEDURE
                                           ||'|'||G_REGEX_FUNCTION 
                                           ||'|'||G_REGEX_PKG_BODY 
                                 ,i_raise_error => TRUE  );
 
	  ms_logger.note(l_node, 'l_keyword' ,l_keyword);

	  CASE 
        WHEN matched_with(l_keyword , G_REGEX_DECLARE) THEN
		  AOP_declare(i_indent => g_initial_indent);
          
        WHEN matched_with(l_keyword , G_REGEX_BEGIN) THEN
		  AOP_block(i_indent     => g_initial_indent
                   ,i_nest       => 1
		           ,i_regex_end  => G_REGEX_END_IF);
		
        WHEN matched_with(l_keyword , G_REGEX_PROCEDURE
                               ||'|'||G_REGEX_FUNCTION 
                               ||'|'||G_REGEX_PKG_BODY) THEN
		  AOP_prog_units(i_indent => g_initial_indent );

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
    when x_invalid_keyword then
	  splice_here( i_new_code => 'INVALID KEYWORD'
	              ,i_colour  => G_COLOUR_ERROR);
      l_advised := false;
    when x_weave_timeout then
	  splice_here( i_new_code => 'WEAVE TIMED OUT'
	              ,i_colour  => G_COLOUR_ERROR);
      l_advised := false;
    when x_string_not_found then
      l_advised := false;
   
  end;
  
    ms_logger.note(l_node, 'elapsed_time_secs' ,elapsed_time_secs);
    
    g_code := REPLACE(g_code,g_aop_directive,'Logging by AOP_PROCESSOR on '||to_char(systimestamp,'DD-MM-YYYY HH24:MI:SS'));
	
	IF g_for_aop_html then
	  g_code := REPLACE(REPLACE(g_code,'<<','&lt;&lt;'),'>>','&gt;&gt;');
      g_code := REGEXP_REPLACE(g_code,'(ms_logger)(.+)(;)','<B>\1\2\3</B>');
      g_code := '<PRE>'||g_code||'</PRE>';
	END IF;  
 
    p_code := g_code;
 
    return l_advised;
 
  exception 
    when others then
      ms_logger.oracle_error(l_node);	
	  raise;
	
  end weave;
  
  
	
  --------------------------------------------------------------------
  -- get_body
  --------------------------------------------------------------------
  function get_body
  ( p_object_name   in varchar2
  , p_object_owner  in varchar2
  ) return clob
  is
  
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'get_body');     
    l_code clob;
  begin
    ms_logger.param(l_node, 'p_object_name  '          ,p_object_name   );
    ms_logger.param(l_node, 'p_object_owner '          ,p_object_owner  );
    -- make sure that dbms_metadata does return the package body 
    DBMS_METADATA.SET_TRANSFORM_PARAM 
    ( transform_handle  => dbms_metadata.SESSION_TRANSFORM
    , name              => 'BODY'
    , value             => true
    , object_type       => 'PACKAGE'
    );
    -- make sure that dbms_metadata does not return the package specification as well
    DBMS_METADATA.SET_TRANSFORM_PARAM 
    ( transform_handle  => dbms_metadata.SESSION_TRANSFORM
    , name              => 'SPECIFICATION'
    , value             => false
    , object_type       => 'PACKAGE'
    );
    l_code:= dbms_metadata.get_ddl('PACKAGE', p_object_name, p_object_owner);
    return l_code;
  end get_body;

  
  
  --------------------------------------------------------------------
  -- advise_package
  --------------------------------------------------------------------  
  procedure advise_package
  ( p_object_name   in varchar2
  , p_object_type   in varchar2
  , p_object_owner  in varchar2
  ) is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'advise_package');
  
	l_orig_body clob;
	l_aop_body clob;
	l_html_body clob;
    l_advised boolean := false;
  begin	
  begin
    ms_logger.param(l_node, 'p_object_name'  ,p_object_name  );
    ms_logger.param(l_node, 'p_object_type'  ,p_object_type  );
    ms_logger.param(l_node, 'p_object_owner' ,p_object_owner );
    g_during_advise:= true;
    -- test for state of package; no sense in trying to post-process an invalid package
    
    -- if valid then retrieve source
    l_orig_body:= get_body( p_object_name, p_object_owner);
    -- check if perhaps the AOP_NEVER string is included that indicates that no AOP should be applied to a program unit
    -- (this bail-out is primarily used for this package itself, riddled as it is with AOP instructions)
	-- Conversely it also checks for @AOP_LOG, which must be present or AOP will also exit.
	--This ensure that a routine is not logged unless explicitly requested.
	--Also AOP will remove AOP_LOG in the AOP Source, so that logging cannot be doubled-up.
    if instr(l_orig_body, '@AOP_NEVER') > 0 or instr(l_orig_body, g_aop_directive) = 0 
    then
	  g_during_advise:= false; 
      return;
    end if;
	
	IF NOT  validate_source(i_name  => p_object_name
	                      , i_type  => p_object_type
	                      , i_text  => l_orig_body
	                      , i_aop_ver => 'ORIG') THEN
	  g_during_advise:= false; 
	  return; -- Don't bother with AOP since the original source is invalid anyway.			
	end if;		  
 
	l_aop_body := l_orig_body;
    -- manipulate source by weaving in aspects as required; only weave if the key logging not yet applied.
    l_advised := weave( p_code         => l_aop_body
                      , p_package_name => lower(p_object_name)  );
 
    -- (re)compile the source if any advises have been applied
    if l_advised then
	
	  IF NOT validate_source(i_name  => p_object_name
	                       , i_type  => p_object_type
	                       , i_text  => l_aop_body
	                       , i_aop_ver => 'AOP') THEN
 
	    --reexecute the original so that we at least end up with a valid package.
	    IF NOT  validate_source(i_name  => p_object_name
	                          , i_type  => p_object_type
	                          , i_text  => l_orig_body
	                          , i_aop_ver => 'ORIG') THEN
		  --unlikely that we'd get an error in the original if it worked last time
		  --but trap it incase we do	
          ms_logger.fatal(l_node,'Original Source is invalid on second try.');		  
		end if;
	  end if;
 
	  --Reweave with html
	  ms_logger.comment(l_node,'Reweave with html');	
	  l_html_body := l_orig_body;
      l_advised := weave( p_code         => l_html_body
                        , p_package_name => lower(p_object_name)
                        , p_for_html     => true );

	  IF NOT validate_source(i_name  => p_object_name
	                       , i_type  => p_object_type
	                       , i_text  => l_html_body
	                       , i_aop_ver => 'AOP_HTML') THEN
	    ms_logger.fatal(l_node,'Oops problem with AOP_HTML on second try.');						 
	 
	  END IF;
 
    end if;
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
  end advise_package;
  
  --------------------------------------------------------------------
  -- reapply_aspect
  --------------------------------------------------------------------  
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL) is
  begin
    for l_object in (select object_name 
	                      , object_type
						  , owner 
				     from all_objects 
					 where object_type ='PACKAGE BODY'
					 and   object_name = NVL(i_object_name,object_name)) loop
        advise_package( p_object_name  => l_object.object_name
                      , p_object_type  => l_object.object_type
                      , p_object_owner => l_object.owner);

    end loop;
  end reapply_aspect;
  


  --------------------------------------------------------------------
  -- restore_comments_and_quotes
  --------------------------------------------------------------------  
  procedure restore_comments_and_quotes IS
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'restore_comments_and_quotes'); 
      l_text CLOB;	  
  BEGIN
    FOR l_index in 1..g_comment_stack.count loop
	  l_text := f_colour(i_text   => g_comment_stack(l_index)
	                    ,i_colour => G_COLOUR_COMMENT);
	  g_code := REPLACE(g_code,'##comment'||l_index||'##',l_text);
	END LOOP;
  
    FOR l_index in 1..g_quote_stack.count loop
	  l_text := f_colour(i_text   => g_quote_stack(l_index)
	                    ,i_colour => G_COLOUR_QUOTE);
	  g_code := REPLACE(g_code,'##quote'||l_index||'##',l_text);
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
	  ms_logger.note(l_node, 'l_comment', l_comment);
	  g_comment_stack(g_comment_stack.count+1) := l_comment; --Put another comment on the stack
	  ms_logger.note(l_node, 'g_comment_stack.count', g_comment_stack.count);
	  g_code := REGEXP_REPLACE(g_code, i_mask, '##comment'||g_comment_stack.count||'##',g_current_pos, 1, i_modifier);
	  go_past(i_search => '##comment'||g_comment_stack.count||'##'
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
	  g_code := REGEXP_REPLACE(g_code, i_mask, '##quote'||g_quote_stack.count||'##',g_current_pos, 1, i_modifier);
	  go_past(i_search => '##quote'||g_quote_stack.count||'##'
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
   G_REGEX_START_QUOTE      CONSTANT VARCHAR2(50) :=  '\'''    ;
   G_REGEX_START_ADV_QUOTE  CONSTANT VARCHAR2(50) :=  'q\''\S' ;
 
   G_REGEX_START_COMMENT_OR_QUOTE CONSTANT VARCHAR2(200) := G_REGEX_START_SINGLE_COMMENT  
                                                     ||'|'||G_REGEX_START_MULTI_COMMENT
                                                     ||'|'||G_REGEX_START_QUOTE
                                                     ||'|'||G_REGEX_START_ADV_QUOTE;
 
   G_REGEX_SINGLE_LINE_ANNOTATION   CONSTANT VARCHAR2(50)  :=    '.*';
   G_REGEX_SINGLE_LINE_COMMENT   CONSTANT VARCHAR2(50)  :=    '--.*';
   G_REGEX_MULTI_LINE_COMMENT    CONSTANT VARCHAR2(50)  :=    '/\*.*?\*/';
   G_REGEX_MULTI_LINE_QUOTE      CONSTANT VARCHAR2(50)  :=    '\''.*?\''';
   G_REGEX_MULTI_LINE_ADV_QUOTE  CONSTANT VARCHAR2(100) :=    'q\''\[.*?\]\''|q\''\{.*?\}\''|q\''\(.*?\)\''|q\''\<.*?\>\''|q\''(\S).*?\1\''';
 
    BEGIN
 
      --Searching for the start of a comment or quote
      l_keyword :=  get_next_lower(i_stop       => G_REGEX_START_COMMENT_OR_QUOTE
                                  ,i_trim       => FALSE	  );
 
      ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
	  
      CASE 

	    WHEN matched_with(l_keyword , G_REGEX_START_SINGLE_COMMENT)  THEN 
          --Check for an annotation                         
          IF matched_with(l_keyword , G_REGEX_START_ANNOTATION) THEN                           
            ms_logger.info(l_node, 'Annotation');         
            --ANNOTATION          
            go_past;          
            extract_comment(i_mask     => G_REGEX_SINGLE_LINE_ANNOTATION          
                           ,i_modifier => 'i');           
          ELSE
 
            --Just a comment
            ms_logger.info(l_node, 'Single Line Comment');         
	        --REMOVE SINGLE LINE COMMENTS 
	        --Find "--" and remove chars upto EOL 		
		    extract_comment(i_mask     => G_REGEX_SINGLE_LINE_COMMENT
		                   ,i_modifier => 'i');
    
          END IF;
  
 
	    WHEN matched_with(l_keyword , G_REGEX_START_MULTI_COMMENT)  THEN  
           ms_logger.info(l_node, 'Multi Line Comment');  
	      --REMOVE MULTI-LINE COMMENTS 
	      --Find "/*" and remove upto "*/" 
		  extract_comment(i_mask => G_REGEX_MULTI_LINE_COMMENT);
 
	    WHEN matched_with(l_keyword , G_REGEX_START_ADV_QUOTE)  THEN  
           ms_logger.info(l_node, 'Multi Line Adv Quote');  
		  --REMOVE ADVANCED QUOTES - MULTI_LINE
		  --Find "q'[" and remove to next "]'", variations in clude [] {} <> () and any single printable char.
		  extract_quote(i_mask => G_REGEX_MULTI_LINE_ADV_QUOTE);
          
	    WHEN matched_with(l_keyword , G_REGEX_START_QUOTE)  THEN  
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
	
 
 
end aop_processor;
/
show error;

set define on;

alter trigger aop_processor_trg enable;