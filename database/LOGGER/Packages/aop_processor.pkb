alter trigger aop_processor_trg disable;

--Ensure no inlining so ms_logger can be used
alter session set plsql_optimize_level = 1;

set define off;

create or replace package body aop_processor is
  -- AUTHID CURRENT_USER
  -- @AOP_NEVER
  
--This package is not yet aware of commented code.
--IE it will perform incorrectly on code that has been commented out.

--TODO: Create a safety measure for commented code.
--Remove all comments -> AOP
--AOP -> Remove all comments
--Compare the results and alert the developer to any discrepancies.
--Aim to leave a AOP version of the code with original comments.
--(Any comments created by AOP will have to be retained.)
   

  g_package_name        CONSTANT VARCHAR2(30) := 'aop_processor'; 
 
  g_during_advise boolean:= false;
  
  g_aop_directive CONSTANT VARCHAR2(30) := '@AOP_LOG'; 
  

  
  g_for_aop_html      boolean := false;
 
  g_weave_start_time  date;
  
  g_weave_timeout_secs NUMBER := 30;   
  
  g_initial_level     constant integer := 0;
  
  TYPE clob_stack_typ IS
  TABLE OF CLOB
  INDEX BY BINARY_INTEGER;
 
  g_comment_stack clob_stack_typ;
  g_quote_stack   clob_stack_typ;
  
 
  g_code              CLOB;
  g_current_pos       INTEGER;
  x_weave_timeout      EXCEPTION; 
  x_invalid_keyword    EXCEPTION;
  x_string_not_found   EXCEPTION;
  
  ----------------------------------------------------------------------------
  -- REGULAR EXPRESSIONS
  ----------------------------------------------------------------------------
  g_word_search          VARCHAR2(10) := '\w+'; --'[A-Z|_]+';--'[^ ]+'; 
  
  
  
  procedure check_timeout is
  begin
    if (sysdate - g_weave_start_time) * 24 * 60 * 60 >  g_weave_timeout_secs then
	  raise x_weave_timeout;
	end if;
  
  end;
  
  

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
					 ,p_level    in number   default null
					 ,p_colour   in varchar2 default null ) IS
                     
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'splice');  
	  l_new_code        CLOB;
	  l_colour          VARCHAR2(10);
	  L_NEW_CODE_COLOUR VARCHAR2(10) := '#9CFFFE';
	  
    BEGIN
  
      --ms_logger.param(l_node, 'p_code'          ,p_code );
      --ms_logger.param(l_node, 'LENGTH(p_code)'  ,LENGTH(p_code)  );
      --ms_logger.param(l_node, 'p_new_code'      ,p_new_code);
      ms_logger.param(l_node, 'p_pos     '      ,p_pos     );
	  ms_logger.param(l_node, 'p_level     '    ,p_level     );
	  ms_logger.param(l_node, 'p_colour  '      ,p_colour     );
	  
	  --p_pos := p_pos -1;
	  
	  --check_timeout;
	  
	  ms_logger.note(l_node, 'g_for_aop_html     '     ,g_for_aop_html     );
	  IF g_for_aop_html THEN
	    l_colour := NVL(p_colour, L_NEW_CODE_COLOUR);
		ms_logger.note(l_node, 'l_colour     '     ,l_colour     );
	  END IF;
 
	  l_new_code := CASE 
			          WHEN l_colour IS NULL THEN 
				          p_new_code
			          ELSE 
				          '<span style="background-color:#'||LTRIM(l_colour,'#')||';">'||p_new_code||'</span>'
                    END;
      ms_logger.note(l_node, 'l_new_code     '     ,l_new_code     );
	  
	  IF p_level is not null then
	    l_new_code := replace(chr(10)||l_new_code,chr(10),chr(10)||rpad(' ',(p_level-1)*2+2,' '))||chr(10);
	  END IF; 
 
      p_code:= substr(p_code, 1, p_pos)
	         ||l_new_code
             ||substr(p_code, p_pos+1);
  
	  p_pos := p_pos + length(l_new_code);	
	  
	  --ms_logger.note(l_node, 'p_code     '     ,p_code     );
	  --ms_logger.note(l_node, 'p_pos     '      ,p_pos     );
 
    END;
	
  --------------------------------------------------------------------
  -- splice_here
  --------------------------------------------------------------------
    procedure splice_here( i_new_code in varchar2
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
	
    procedure inject( i_new_code in varchar2
					      ,i_level    in number
						  ,i_colour   in varchar2 default null) IS
	BEGIN
	  IF i_new_code IS NOT NULL THEN
	    splice( p_code      => g_code    
	           ,p_new_code  => i_new_code
	           ,p_pos       => g_current_pos     
	           ,p_level     => i_level
               ,p_colour    => i_colour	 );  
	  END IF;			 
	END;
	
	
	
	
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
 
 
--------------------------------------------------------------------------------- 
-- REFACTORED
--------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------- 
-- ATOMIC
--------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------- 
-- get_next - return first matching string, stripped of upto 1 leading and trailing whitespace
--------------------------------------------------------------------------------- 
FUNCTION get_next(i_search             IN VARCHAR2
                 ,i_modifier           IN VARCHAR2 DEFAULT 'i'
                 ,i_raise_error        IN BOOLEAN  DEFAULT FALSE
                 --,i_shortest_alternate IN BOOLEAN  DEFAULT FALSE 
				 ) return CLOB IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'get_next');	
  l_result CLOB;
BEGIN
  check_timeout; --GET_NEXT
  ms_logger.param(l_node, 'i_search',i_search);
  
  l_result := TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(g_code,i_search,g_current_pos,1,i_modifier),'^\s|\s$',''));
  
  IF l_result IS NULL AND i_raise_error THEN
	ms_logger.fatal(l_node, 'String missing '||i_search);
	splice_here( i_new_code => 'STRING NOT FOUND '||i_search
	            ,i_colour   => '#FF6600');
    RAISE x_string_not_found;
  END IF;
  
  RETURN l_result;
END get_next;
--------------------------------------------------------------------------------- 
-- get_next_lower
--------------------------------------------------------------------------------- 
FUNCTION get_next_lower(i_search      IN VARCHAR2
                       ,i_modifier    IN VARCHAR2 DEFAULT 'i'
                       ,i_raise_error IN BOOLEAN  DEFAULT FALSE) return CLOB IS
BEGIN
  RETURN LOWER(get_next(i_search   => i_search
                       ,i_modifier => i_modifier
					   ,i_raise_error => i_raise_error));
END;
--------------------------------------------------------------------------------- 
-- get_next_upper
--------------------------------------------------------------------------------- 
FUNCTION get_next_upper(i_search IN VARCHAR2
                       ,i_modifier IN VARCHAR2 DEFAULT 'i'
                       ,i_raise_error IN BOOLEAN  DEFAULT FALSE) return CLOB IS
BEGIN
  RETURN UPPER(get_next(i_search   => i_search
                       ,i_modifier => i_modifier
					   ,i_raise_error => i_raise_error));
END;

--------------------------------------------------------------------------------- 
-- go
---------------------------------------------------------------------------------
PROCEDURE go(i_search     IN VARCHAR2
            ,i_modifier   IN VARCHAR2 
			,i_past_prior IN INTEGER
			,i_offset IN INTEGER DEFAULT 0) IS
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
	            ,i_colour   => '#FF6600');
    raise x_string_not_found;
  end if;
  g_current_pos := l_new_pos + i_offset;
END;


--------------------------------------------------------------------------------- 
-- go_past
---------------------------------------------------------------------------------
PROCEDURE go_past(i_search IN VARCHAR2
                 ,i_modifier IN VARCHAR2 DEFAULT 'i'
				 ,i_offset IN INTEGER DEFAULT 0) IS
 
BEGIN
  go(i_search     => i_search    
    ,i_modifier   => i_modifier  
    ,i_past_prior => 1
	,i_offset     => i_offset);

 
END;

--------------------------------------------------------------------------------- 
-- go_upto
---------------------------------------------------------------------------------
PROCEDURE go_upto(i_search IN VARCHAR2
                  ,i_modifier IN VARCHAR2 DEFAULT 'i'
				  ,i_offset IN INTEGER DEFAULT -1) IS
 
BEGIN
  go(i_search     => i_search    
    ,i_modifier   => i_modifier  
    ,i_past_prior => 0
	,i_offset     => i_offset);
 
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
-- AOP_prog_unit - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_unit(i_level IN INTEGER);


--------------------------------------------------------------------------------- 
-- AOP_pu_block - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_pu_block(i_prog_unit_name IN VARCHAR2
                      ,i_params         IN CLOB
                      ,i_level          IN INTEGER );

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
  
  l_param_line_mask       VARCHAR2(200) := '(\(|,)\s*\w+\s+(IN\s+OUT\s+|IN\s+|OUT\s+)?\w+';
  l_is_as_mask            VARCHAR2(200) := '\sIS\s|\sAS\s';
  l_open_close_comma_mask VARCHAR2(200) := '\(|\,|\)';
  l_open_comma_mask       VARCHAR2(200) := '\(|\,'; 
  l_default_mask          VARCHAR2(200) := '(DEFAULT|:=)';

  l_bracket_count        INTEGER;
 
BEGIN  
 
  loop
    --check_timeout;
    BEGIN

      --Find first: "(" "," "DEFAULT" ":=" "AS" "IS"
 
      l_keyword := get_next_upper(l_open_comma_mask
	                       ||'|'||l_is_as_mask
	                       ||'|'||l_default_mask,'i',TRUE); 
 
      ms_logger.note(l_node, 'l_keyword' ,REPLACE(l_keyword,chr(10),'#')); 
	  ms_logger.note_length(l_node, 'l_keyword' ,l_keyword); 
	  
      CASE 
 
		--NEW PARAMETER LINE
		WHEN REGEXP_LIKE(l_keyword, l_open_comma_mask,'i') THEN
	      ms_logger.comment(l_node, 'Found new parameter');
		  --find the parameter - Search for Eg
		  --( varname IN OUT vartype ,
		  --, varname IN vartype)
		  --, varname vartype,
		  --( varname OUT vartype)
		  --l_param_line := get_next('(\(|,)\s*\w+\s+((IN|IN\s+OUT|OUT)\s+)?\w+\s*(,|\))'); 
          l_param_line := get_next(l_param_line_mask);	 
		  --Move onto next param
	      go_past(l_param_line_mask);
	      
	  	  ms_logger.note(l_node, 'l_param_line',l_param_line);
          
		  IF UPPER(REGEXP_SUBSTR(l_param_line,g_word_search,1,2,'i')) = 'OUT' THEN
		    RAISE x_out_param;
		  END IF;
          
	      --Remove remaining IN and OUT
	  	  l_param_line := REGEXP_REPLACE(l_param_line,'(\sIN\s)',' ',1,1,'i');
		  l_param_line := REGEXP_REPLACE(l_param_line,'(\sOUT\s)',' ',1,1,'i');
		  ms_logger.note(l_node, 'l_param_line',l_param_line);		
		  
	  	  l_param_name := LOWER(REGEXP_SUBSTR(l_param_line,g_word_search,1,1,'i')); 
	  	  ms_logger.note(l_node, 'l_param_name',l_param_name);
	  	  l_param_type := UPPER(REGEXP_SUBSTR(l_param_line,g_word_search,1,2,'i'));  
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
		WHEN REGEXP_LIKE(l_keyword, l_default_mask,'i') THEN 
		  ms_logger.comment(l_node, 'Found DEFAULT, searching for complex value');
		  go_past(l_default_mask,'i');
 
		  l_bracket_count := 0;
		  loop
		    --check_timeout;
		    l_bracket := get_next(l_open_close_comma_mask,'i',TRUE);
            ms_logger.note(l_node, 'l_bracket' ,l_bracket); 
            CASE 
			  WHEN l_bracket = ',' THEN 
			    EXIT WHEN l_bracket_count = 0;

	          WHEN l_bracket = '(' THEN  
			    l_bracket_count := l_bracket_count + 1;

	          WHEN l_bracket = ')' THEN  
                l_bracket_count := l_bracket_count - 1;
				EXIT WHEN l_bracket_count = -1;

              ELSE 
			    ms_logger.fatal(l_node, 'Complex Default: Expected "(" " or ")"');
				RAISE x_invalid_keyword;
		    END CASE;	
		    go_past(l_open_close_comma_mask,'i');
			
		  END LOOP;
 
	    --NO MORE PARAMS
		WHEN l_keyword IN ('AS','IS') THEN EXIT;
          ms_logger.comment(l_node, 'No more parameters');
		  
		  
        --OOPS
        ELSE
		  ms_logger.fatal(l_node, 'Expected "(" "," "DEFAULT" ":=" "AS" or "IS"');
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
PROCEDURE AOP_declare(i_level       IN INTEGER) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_declare'); 
BEGIN

  --go_past('\sDECLARE\s');
  
  --Search for nested PROCEDURE and FUNCTION within the declaration section of the block.
  --Drop out when a BEGIN is reached.
 
  AOP_prog_unit(i_level => i_level + 1);
 
  
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
                   ,i_level          IN INTEGER
                   ,i_inject_params  IN VARCHAR2 DEFAULT NULL
                   ,i_inject_node    IN VARCHAR2 DEFAULT NULL
				   ,i_node_type      IN VARCHAR2) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_is_as'); 
  l_inject_params   CLOB;
  
  l_keyword               VARCHAR2(50);
  l_regex_begin         VARCHAR2(50) := '\sBEGIN\s';
  l_regex_end_begin     VARCHAR2(50) := '\sEND\s*?\w*?\s*?;'; 
  
BEGIN

  l_inject_params := AOP_pu_params;
   
  go_past('\sIS\s|\sAS\s');
 
 --LATER WANT TO REFACTOR THIS MY ONLY INJECTING A PACKAGE NODE IF THERE IS AN INITIALISATION BLOCK.
  inject( i_new_code  => i_inject_node
         ,i_level     => i_level);   
 
  --Rest of IS_AS is a simple declaration.
  AOP_declare(i_level => i_level);
  
  --If this is a package there may not be a BEGIN, just an END;
  
  l_keyword := get_next_upper(l_regex_begin||'|'||l_regex_end_begin ,'i');
  IF l_keyword = 'BEGIN' OR i_node_type <> 'new_pkg' THEN --Packages don't need to have BEGIN.  
 
    AOP_pu_block(i_prog_unit_name  => i_prog_unit_name
                ,i_params          => l_inject_params
                ,i_level           => i_level);
  END IF;
 
  --WHILE get_next_upper('\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s') IN ('PROCEDURE','FUNCTION') LOOP
  --  AOP_prog_unit(i_level => i_level + 1);
  --END LOOP;
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_is_as;

	
				
--------------------------------------------------------------------------------- 
-- AOP_block
---------------------------------------------------------------------------------
PROCEDURE AOP_block(i_level          IN INTEGER )  IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_block');
  
  l_keyword               VARCHAR2(50);
  --l_block_open_mask       VARCHAR2(200) := '\sDECLARE\s|\sBEGIN\s|\LOOP\s|\sCASE\s|\sIF\s|\sELSE\s|\sELSIF\s';
  --
  --l_block_close_mask       VARCHAR2(200) := '\sDECLARE\s|\sBEGIN\s|\LOOP\s|\sCASE\s|\sIF\s|\sELSE\s|\sELSIF\s';
  
  --Opening Blocks
  l_regex_declare       VARCHAR2(50) := '\sDECLARE\s';
  l_regex_begin         VARCHAR2(50) := '\sBEGIN\s';
  l_regex_loop          VARCHAR2(50) := '\sLOOP\s';
  l_regex_case          VARCHAR2(50) := '\sCASE\s';
  l_regex_if            VARCHAR2(50) := '\sIF\s';
  l_regex_else          VARCHAR2(50) := '\sELSE\s';
  l_regex_elsif         VARCHAR2(50) := '\sELSIF\s';
  
  
  
  l_regex_open         VARCHAR2(200) :=   l_regex_declare      
                                   ||'|'||l_regex_begin        
                                   ||'|'||l_regex_loop         
                                   ||'|'||l_regex_case         
                                   ||'|'||l_regex_if           
                                   ||'|'||l_regex_else         
                                   ||'|'||l_regex_elsif;   
 
  
  --Closing Blocks
  l_regex_end_begin     VARCHAR2(50) := '\sEND\s*?\w*?\s*?;';    --END(any whitespace)(any wordschars)(any whitespace);
  l_regex_end_loop      VARCHAR2(50) := '\sEND\s+?LOOP\s*?;';
  l_regex_end_case      VARCHAR2(50) := '\sEND\s+?CASE\s*?;';
  l_regex_end_case_expr VARCHAR2(50) := '\sEND\s+?[[:punct:]]{1}';
  l_regex_end_if        VARCHAR2(50) := '\sEND\s+?IF\s*?;';
  
 
  l_regex_close        VARCHAR2(200) :=  l_regex_end_begin    
                                  ||'|'||l_regex_end_loop     
                                  ||'|'||l_regex_end_case     
                                  ||'|'||l_regex_end_case_expr
                                  ||'|'||l_regex_end_if;      
  
  l_regex_search       VARCHAR2(200) :=  l_regex_open||'|'||l_regex_close;
  
  
 
BEGIN
 
  --go_past('\sBEGIN\s|\sCASE\s');
 		  
  loop

	--l_keyword := get_next_upper('\sDECLARE\s|\sBEGIN\s|\sEND;\s|\sCASE\s.*?\sEND CASE;|\sCASE\s.*?\sEND(,|;)\s','in',TRUE);

    --Ignore WHEN, does not yet seem necessary to handle it.

	l_keyword := get_next_upper(l_regex_search,'i'); 
    --go_past(l_block_open_mask);  (NO DONT->could use this go_past to obviate the need for the first in each WHEN below.)
	ms_logger.note(l_node, 'l_keyword',l_keyword);
 
    CASE 
	  WHEN l_keyword = 'DECLARE' THEN
	    go_past(l_regex_declare);             --DECLARE                    
        AOP_declare(i_level  => i_level + 1);                                                                          
      WHEN l_keyword = 'BEGIN' THEN                                        
        go_past(l_regex_begin);		          --BEGIN                      
        AOP_block(i_level  => i_level + 1);                                
		go_past(l_regex_end_begin);           --END;                       
      WHEN l_keyword = 'LOOP' THEN                                         
        go_past(l_regex_loop);		          --LOOP                       
        AOP_block(i_level  => i_level + 1);                                
		go_past(l_regex_end_loop);            --END LOOP;                  
      WHEN l_keyword = 'CASE' THEN
        go_past(l_regex_case);		          --CASE
		--inc level +2 due to implied WHEN or ELSE
        AOP_block(i_level  => i_level + 2);      
		go_past(l_regex_end_case              --END CASE;   or
		 ||'|'||l_regex_end_case_expr);	      --END[;,+-||]
      WHEN l_keyword = 'IF' THEN
        go_past(l_regex_if);		             --IF
        AOP_block(i_level  => i_level + 1);
		go_past(l_regex_end_if);              --END IF;
      WHEN l_keyword IN ('ELSE','ELSIF') THEN
        go_past(l_regex_else                  --ELSE        or
		 ||'|'||l_regex_elsif);		          --ELSIF
	    --level is NOT increased again, same level as preceding IF
        AOP_block(i_level  => i_level); 
		--Don't look for END IF, since the IF will look for this.
	  WHEN REGEXP_LIKE(l_keyword,l_regex_close) THEN
	    ms_logger.comment(l_node, 'End Block ');
		EXIT;
      ELSE
	    ms_logger.warning(l_node,'No opens or closes. Not sure what this should be.');
		EXIT;
	    --ms_logger.fatal(l_node, 'Expected "DECLARE" "BEGIN" "LOOP" "CASE" "IF" "ELSE" or "ELSIF"');
    END CASE;
 
  END LOOP;
  ms_logger.comment(l_node, 'No more Block Openings');
 
  --go_past('\sEND;\s');
 
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
                      ,i_level          IN INTEGER ) IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_block');
  
BEGIN
 
  --Add extra begin
  go_upto('\sBEGIN\s');
 
  inject( i_new_code  => 'begin --'||i_prog_unit_name
              ,i_level     => i_level
			  ,i_colour    => '#FF9933');
  --Add the params (if any)
  inject( i_new_code  => i_params
         ,i_level     => i_level
		 ,i_colour    => '#FF99FF');
 
  --First Block is BEGIN 
  AOP_block(i_level  => i_level );
  
  --Add extra exception handler
  --add the terminating exception handler of the new surrounding block
  inject( i_new_code  => 'exception'
  	               ||chr(10)||'  when others then'
  			       ||chr(10)||'    ms_logger.warn_error(l_node);'
  			       ||chr(10)||'    raise;'
  			       ||chr(10)||'end; --'||i_prog_unit_name
              ,i_level     => i_level
			  ,i_colour    => '#FF9933');
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_pu_block;


 
--------------------------------------------------------------------------------- 
-- AOP_prog_unit
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_unit(i_level IN INTEGER) IS
  l_node    ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_prog_unit'); 

  l_keyword         VARCHAR2(50);
  l_node_type       VARCHAR2(50);
  l_inject_node     VARCHAR2(200);
  l_prog_unit_name  VARCHAR2(30);
  l_regex_prog_unit VARCHAR2(200) := '\sPACKAGE\s+?BODY\s|\sPROCEDURE\s|\sFUNCTION\s';
  
BEGIN

  LOOP

  --Find node type
  l_keyword := get_next_upper(l_regex_prog_unit,'i',TRUE);
  ms_logger.note(l_node, 'l_keyword' ,l_keyword);   
  CASE 
    WHEN l_keyword LIKE 'PACKAGE%BODY' THEN
      l_node_type := 'new_pkg';
	  l_prog_unit_name := 'Initialise';
    WHEN l_keyword = 'PROCEDURE' THEN
      l_node_type := 'new_proc';
    WHEN l_keyword = 'FUNCTION' THEN
      l_node_type := 'new_func';
	WHEN l_keyword is NULL THEN
	  EXIT;
    ELSE
	  ms_logger.fatal(l_node, 'Expected "PROCEDURE" or "FUNCTION" or "PACKAGE BODY"');
      RAISE x_invalid_keyword;
  END CASE;	 
  ms_logger.note(l_node, 'l_node_type' ,l_node_type);  
  
  --Get program unit name
  go_past(l_regex_prog_unit);
  
  --Check for LANGUAGE JAVA NAME
  --If this is a JAVA function then we don't want a node and don't need to bother reading spec or parsing body.
  --Will find a LANGUAGE keyword before next ";"
  l_keyword := get_next_upper('\sLANGUAGE\s|;');
  ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
  IF l_keyword = 'LANGUAGE' THEN
	ms_logger.comment(l_node, 'Found a LANGUAGE prog unit - skipping AOP_prog_unit'); 
	--Move pointer to after this special program unit and we are done.
	go_past(';');
	RETURN;
  END IF;
 
  IF l_prog_unit_name IS NULL THEN
    l_prog_unit_name := get_next_lower(g_word_search);
  END IF;
  ms_logger.note(l_node, 'l_prog_unit_name' ,l_prog_unit_name);
  
  l_inject_node    := '  l_node ms_logger.node_typ := ms_logger.'||l_node_type||'($$plsql_unit ,'''||l_prog_unit_name||''');';
 
  AOP_is_as(i_prog_unit_name => l_prog_unit_name
           ,i_level          => i_level
           ,i_inject_node    => l_inject_node
		   ,i_node_type      => l_node_type);
			 
 
  END LOOP;
 
  ms_logger.comment(l_node, 'No more program units.');
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END AOP_prog_unit;
 
 
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
	
	g_for_aop_html := p_for_html;
	
	g_weave_start_time := SYSDATE;
	
	--First task will be to remove all comments or 
	--somehow identify and remember all sections that can be ignored because they are comments
	
	g_code := chr(10)||p_code||chr(10); --add a trailing CR to help with searching

	stash_comments_and_quotes;
 
    --LATER WHEN WE WANT TO SUPPORT THE BEGIN SECTION OF A PACKAGE
	--WE WOULD REPLACE parse_prog_unit below with parse_anon_block
 
	--Change any program unit ending of form "end program_unit_name;" to just "end;" for simplicity
	--Preprocess p_code cleaning up block end statements.
    --IE Translate "END prog_unit_name;" -> "END;"	
 
	  --Reset the processing pointer.
      g_current_pos := 1;
 
 /*
    --PROBLEM - This routine is really only meant to replace END prog_unit_name; with END;
	--However it may replace other things like in this example 
	-- A := CASE WHEN i=1 then 2 ELSE 3 END + 2;
	--It would replace the "END + 2;" with "END;" there by changing the code substantially. 
	--NEED to workaround "END prog_unit_name;" without doing this replacement. 
 
    declare
	  l_mask VARCHAR2(50) := '(\sEND)\s+?(\w+)\s*?;';
    begin
      loop
	    l_end_value := get_next_upper(l_mask);   
		EXIT WHEN l_end_value IS NULL;
	    ms_logger.note(l_node, 'l_end_value'      ,l_end_value);
 
		l_mystery_word := UPPER(REGEXP_SUBSTR(l_end_value,g_word_search,1,2,'i')); 
	    if l_mystery_word in ('IF'
	                         ,'LOOP'
	    					 ,'CASE') then
		  g_code := REGEXP_REPLACE(g_code,l_mask,'\1 \2;',g_current_pos,1,'i');					 	 
		  go_past('END (\w+);');						 
		ELSE						 
	      ms_logger.info(l_node, 'Replacing '||l_end_value);
	      g_code := REGEXP_REPLACE(g_code,l_mask,'\1;',g_current_pos,1,'i');
		  go_past('END;');
	    end if;
 
	  END LOOP;
	end;  
 
  --Replace all remaining occurances like "END ;" with "END;"  OR "END ," with "END," OR "END +" with "END+"
  --g_code := REGEXP_REPLACE(g_code,'(\sEND)\s+?([:punct:]{1})','\1\2',1,0,'i'); 
  g_code := REGEXP_REPLACE(g_code,'(\sEND)\s+?([:punct:])','\1\2',1,0,'i'); 
  
  ms_logger.comment(l_node, 'Finished cleaning ENDs');
*/ 
 
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
	  l_keyword := get_next_upper('\sDECLARE\s|\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s|\sPACKAGE BODY\s','i',TRUE);
	  ms_logger.note(l_node, 'l_keyword' ,l_keyword);

	  CASE 
	    --WHEN l_keyword = 'DECLARE' THEN --NEED TO REFACTOR THIS BIT TOO.
		--  AOP_declare(i_level => g_initial_level);
		--  AOP_block(i_level => g_initial_level);
		--WHEN l_keyword = 'BEGIN' THEN  --NEED TO REFACTOR THIS BIT TOO.
		--  AOP_block(i_level => g_initial_level);
		WHEN l_keyword in ('DECLARE','BEGIN') THEN
		  AOP_block(i_level => g_initial_level);
		
		WHEN l_keyword IN ('PROCEDURE','FUNCTION','PACKAGE BODY') THEN
		  AOP_prog_unit(i_level => g_initial_level);
		  
		  
		--WHEN l_keyword = 'PACKAGE BODY' THEN
		--  go_past('PACKAGE BODY');
        --
        --
		--  --Match on combinatsion like owner.package_name, "owner"."package_name",package_name,"package_name"
		--  --Remove "
		--  l_package_name := REPLACE(get_next_lower('\w+\.\w+|\w+\"?\.\"?\w+|\w+'),'"','');
		--  --Remove owner.
		--  l_package_name := REGEXP_REPLACE(l_package_name,'\w+\.','');
        --
        --  --declaration of package body
        --  AOP_is_as(i_level        => g_initial_level
		--           ,i_inject_node  => );	
		--  ----initialisation of package body (optional)
        --  --l_keyword := get_next_upper('\sBEGIN\s|\sEND;\s','i',TRUE);
		--  --IF l_keyword = 'BEGIN' THEN
		--  --   AOP_pu_block(i_prog_unit_name => l_package_name
		--  --                     ,i_params         => NULL   
		--  --                     ,i_level          => g_initial_level);
		--  --ELSIF l_keyword IS NULL THEN
		--  --  ms_logger.fatal(l_node, 'Expected "BEGIN" or "END;"');
		--  --  RAISE x_invalid_keyword;
		--  --END IF;
		ELSE
		  ms_logger.fatal(l_node, 'Expected "DECLARE", "BEGIN", "PROCEDURE", "FUNCTION" or "PACKAGE BODY"');
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
	              ,i_colour  => '#FF6600');
      l_advised := false;
    when x_weave_timeout then
	  splice_here( i_new_code => 'WEAVE TIMED OUT'
	              ,i_colour  => '#FF6600');
      l_advised := false;
    when x_string_not_found then
      l_advised := false;
   
  end;

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
	  IF g_for_aop_html THEN
	    l_text := '<span style="background-color:#99FF99;">'||g_comment_stack(l_index)||'</span>';
	  ELSE
	    l_text := g_comment_stack(l_index);
      END IF;	  
	  g_code := REPLACE(g_code,'##comment'||l_index||'##',l_text);
	END LOOP;
  
    FOR l_index in 1..g_quote_stack.count loop
	  IF g_for_aop_html THEN
	    l_text := '<span style="background-color:#99CCFF;">'||g_quote_stack(l_index)||'</span>';
	  ELSE
	    l_text := g_quote_stack(l_index);
      END IF;	
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
	  l_comment := get_next(i_mask,i_modifier); --multi-line, lazy
	  ms_logger.note(l_node, 'l_comment', l_comment);
	  g_comment_stack(g_comment_stack.count+1) := l_comment; --Put another comment on the stack
	  ms_logger.note(l_node, 'g_comment_stack.count', g_comment_stack.count);
	  g_code := REGEXP_REPLACE(g_code, i_mask, '##comment'||g_comment_stack.count||'##',g_current_pos, 1, i_modifier);
	  go_past('##comment'||g_comment_stack.count||'##');
	END;
	
	procedure extract_quote(i_mask     IN VARCHAR2
	                       ,i_modifier IN VARCHAR2 DEFAULT 'in') IS
	  l_quote              CLOB;
	BEGIN
	  l_quote := get_next(i_mask,i_modifier); --multi-line, lazy
	  ms_logger.note(l_node, 'l_quote', l_quote);
	  g_quote_stack(g_quote_stack.count+1) := l_quote; --Put another quote on the stack
	  ms_logger.note(l_node, 'g_quote_stack.count', g_quote_stack.count);
	  g_code := REGEXP_REPLACE(g_code, i_mask, '##quote'||g_quote_stack.count||'##',g_current_pos, 1, i_modifier);
	  go_past('##quote'||g_quote_stack.count||'##');
	END;
 
BEGIN  
 
   g_current_pos   := 1;
 
   --initialise comments and quotes
   g_comment_stack.DELETE;  
   g_quote_stack.DELETE;
 
 
  loop
    BEGIN
	  --check_timeout;
      --Searching for the start of a comment or quote
      l_keyword := get_next_lower('--|/\*|\''|q\''\S');	  
      ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
	  
      CASE 
	    WHEN l_keyword = '--' THEN  
	      --REMOVE SINGLE LINE COMMENTS 
	      --Find "--" and remove chars upto EOL 		
		  extract_comment(i_mask     => '--.*'
		                 ,i_modifier => 'i');
 
        WHEN l_keyword = '/*' THEN
	      --REMOVE MULTI-LINE COMMENTS 
	      --Find "/*" and remove upto "*/" 
		  extract_comment(i_mask => '/\*.*?\*/');
 
        WHEN l_keyword = '''' THEN
		  --REMOVE SIMPLE QUOTES - MULTI_LINE
          --Find "'" and remove to next "'" 		
		  extract_quote(i_mask => '\''.*?\''');
 
        WHEN l_keyword LIKE 'q''%' THEN
		  --REMOVE ADVANCED QUOTES - MULTI_LINE
		  --Find "q'[" and remove to next "]'", variations in clude [] {} <> () and any single printable char.
		  extract_quote(i_mask => 'q\''\[.*?\]\''|q\''\{.*?\}\''|q\''\(.*?\)\''|q\''\<.*?\>\''|q\''(\S).*?\1\''');
 
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