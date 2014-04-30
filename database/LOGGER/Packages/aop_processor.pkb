alter trigger aop_processor_trg disable;

create or replace package body aop_processor is
  -- @AOP_NEVER
  
--This package is not yet aware of commented code.
--IE it will perform incorrectly on code that has been commented out.
   

  g_package_name        CONSTANT VARCHAR2(30) := 'aop_processor'; 
 
  g_during_advise boolean:= false;
  
  g_aop_directive CONSTANT VARCHAR2(30) := '@AOP_LOG'; 
  
  x_string_not_found EXCEPTION;

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
                         , i_aop_yn      IN VARCHAR2
					  ) RETURN boolean IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'validate_source');              
                      
    l_aop_source    aop_source%ROWTYPE;    
    PRAGMA AUTONOMOUS_TRANSACTION;
 
  BEGIN     
 
    ms_logger.param(l_node, 'i_name'             ,i_name   );
    ms_logger.param(l_node, 'i_type   '          ,i_type      );
    --ms_logger.param(l_node, 'i_text       '          ,i_text          ); --too big.
	ms_logger.param(l_node, 'i_aop_yn   '            ,i_aop_yn      );

	--Prepare record.
    l_aop_source.name          := i_name;
	l_aop_source.type          := i_type;
    l_aop_source.aop_yn        := i_aop_yn;
    l_aop_source.text          := i_text;
    l_aop_source.load_datetime := sysdate;
    l_aop_source.valid_yn      := 'Y';
    l_aop_source.result        := 'Success.';
	
	
    begin
      execute immediate cast(i_text as varchar2);
	exception
      when others then
	    l_aop_source.result   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		l_aop_source.valid_yn := 'N';
        ms_logger.warn_error(l_node);   
	end;
 
 
    --update original source
    UPDATE aop_source
    SET   text          = l_aop_source.text  
         ,load_datetime = sysdate
		 ,valid_yn      = l_aop_source.valid_yn    
         ,result        = l_aop_source.result
    WHERE name   = l_aop_source.name
	AND   type   = l_aop_source.type
    AND   aop_yn = l_aop_source.aop_yn;
    
    IF SQL%ROWCOUNT = 0 THEN
    
      --insert original source
 
      INSERT INTO aop_source VALUES l_aop_source;
    
    END IF;
     
    COMMIT;
	
	RETURN l_aop_source.valid_yn = 'Y';
   
      
  END;
  
  function flatten(i_clob IN CLOB) return CLOB is
  begin
    return UPPER(replace(replace(i_clob,chr(10),' '),chr(13),' '));
  end;

  --------------------------------------------------------------------
  -- tokenise
  --------------------------------------------------------------------
  FUNCTION tokenise(i_string      IN VARCHAR2
                  , i_delimeter   IN VARCHAR2
				  , i_exclude     IN VARCHAR2) return APEX_APPLICATION_GLOBAL.VC_ARR2 IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'tokenise');
    l_raw        APEX_APPLICATION_GLOBAL.VC_ARR2;
	l_clean      APEX_APPLICATION_GLOBAL.VC_ARR2;
	l_index      binary_integer :=  0;
	l_exclude    APEX_APPLICATION_GLOBAL.VC_ARR2;
	l_keep       BOOLEAN;
  BEGIN
    ms_logger.param(l_node, 'i_string    ',i_string );
    ms_logger.param(l_node, 'i_delimeter ',i_delimeter );
  
     dbms_output.enable(100000);
     l_exclude := APEX_UTIL.STRING_TO_TABLE(UPPER(i_exclude),i_delimeter);  
     l_raw := APEX_UTIL.STRING_TO_TABLE(UPPER(flatten(i_string)),i_delimeter);
     FOR z IN 1..l_raw.count LOOP
	    ms_logger.param(l_node, 'l_raw('||z||')',l_raw(z) );
		if l_raw(z) is not null then
		  l_keep := TRUE;
          FOR i IN 1..l_exclude.count LOOP
		    if l_raw(z) = l_exclude(i) then
			  l_keep := false;
			end if;
		  END LOOP;
		  if l_keep then
		    l_index := l_index + 1;
		    l_clean(l_index) := l_raw(z);
		    ms_logger.param(l_node, 'l_clean('||l_index||')',l_raw(z) );
		  end if;
		end if;
     END LOOP;
	 
	 return l_clean;
  
  END;
 
  --------------------------------------------------------------------
  -- splice
  --------------------------------------------------------------------
    procedure splice( p_code     in out clob
                     ,p_new_code in varchar2
                     ,p_pos      in out number ) IS
                     
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'splice');  
    BEGIN
  
      ms_logger.param(l_node, 'p_code'          ,p_code );
      ms_logger.param(l_node, 'LENGTH(p_code)'  ,LENGTH(p_code)  );
      ms_logger.param(l_node, 'p_new_code'      ,p_new_code);
      ms_logger.param(l_node, 'p_pos     '      ,p_pos     );
      
      p_code:=     substr(p_code, 1, p_pos)
                 ||p_new_code
                 ||substr(p_code, p_pos+1);
  
	  p_pos := p_pos + length(p_new_code);	
	  
	  ms_logger.note(l_node, 'p_code     '     ,p_code     );
	  ms_logger.note(l_node, 'p_pos     '      ,p_pos     );
 
    END;
 
  --------------------------------------------------------------------
  -- inject
  --------------------------------------------------------------------
    procedure inject( p_code     in out clob
                     ,p_new_code in varchar2
                     ,p_pos      in out number ) IS
      --Calls splice with p_new_code wrapped in CR
    BEGIN
	
	  splice( p_code     =>  p_code
	         ,p_new_code => chr(10)||p_new_code||chr(10)
	         ,p_pos      =>  p_pos);   
 
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

  --------------------------------------------------------------------
  -- find_first_string_after
  --------------------------------------------------------------------
  -- finds a string that starts after p_find, ends before the first occurrence of p_end and has all p_to_trim characters removed
  -- for example: @AOP( advice =LOG); p_find = @AOP
  function find_first_string_after
  ( p_string in varchar2 -- for example  @AOP( advice =LOG)
  , p_find in varchar2 -- for example @AOP
  , p_start in varchar2 -- for example advice
  , p_end  in varchar2 -- for example ) 
  , p_to_trim in varchar2 -- for example ' =
  , p_occurrence in number default 1
  , p_last_pos   in number default null
  ) return varchar2
  is
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'find_first_string_after');
  
    l_pos    number(5); 
    l_pos2   number(5);
    l_result varchar2(32700);
    
    -- from http://www.oracle.com/technology/oramag/oracle/06-jan/o16plsql.html by Steven Feuerstein
    FUNCTION stripped_string 
    ( string_in               IN   VARCHAR2
    , strip_characters_in     IN   VARCHAR2
    ) RETURN VARCHAR2
    IS
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'stripped_string');
    
    -- With REGEXP_REPLACE, each character to be replaced with NULL,
    -- must be followed by a "*".

      c_asterisk              CONSTANT CHAR (1) := '*';
      l_strip_characters      VARCHAR2 (32767);
      l_length                PLS_INTEGER;
      l_character             VARCHAR2 (2);
    BEGIN
      ms_logger.param(l_node, 'string_in          ' ,string_in          );
      ms_logger.param(l_node, 'strip_characters_in' ,strip_characters_in);
      l_length := LENGTH (strip_characters_in);
      IF l_length > 0
      THEN
        FOR l_index IN 1 .. l_length
        LOOP
          l_character := SUBSTR (strip_characters_in, l_index, 1);

          IF l_character = c_asterisk
          THEN
            l_character := '\*';  
          END IF;

          l_strip_characters :=
               l_strip_characters
            || l_character
            || c_asterisk;
        END LOOP;
      END IF;
      RETURN regexp_replace (string_in, l_strip_characters);
    END stripped_string;

  begin
  ms_logger.param(l_node, 'p_string    ' ,p_string    );
  ms_logger.param(l_node, 'p_find      ' ,p_find      );
  ms_logger.param(l_node, 'p_start     ' ,p_start     );
  ms_logger.param(l_node, 'p_end       ' ,p_end       );
  ms_logger.param(l_node, 'p_to_trim   ' ,p_to_trim   );
  ms_logger.param(l_node, 'p_occurrence' ,p_occurrence);
  ms_logger.param(l_node, 'p_last_pos  ' ,p_last_pos  );

    l_pos:= regexp_instr( p_string, p_find, 1, 1,0,'i');
    if l_pos > 0
    then
      l_pos2:= regexp_instr( p_string, p_start, l_pos, p_occurrence,0,'i'); -- find the first instance of p_start, starting from position l_pos in the p_string
      if l_pos2 > 0 and l_pos2 < nvl(p_last_pos, l_pos2+1)
      then
        l_result := substr(p_string, l_pos2, regexp_instr(p_string,p_end,l_pos2,1,0,'i') - l_pos2 ); 
        l_result:= stripped_string (l_result, p_to_trim);        
      end if;
    end if;
    return l_result;
  end find_first_string_after;
  
 

  --------------------------------------------------------------------
  -- find_string (UNUSED)
  --------------------------------------------------------------------
  function find_string(i_code         IN CLOB
                      ,i_search       IN VARCHAR2
					  ,io_current_pos IN OUT INTEGER) return boolean is
					  
    l_no_line_endings CLOB := flatten(i_code);
	l_string_pos      INTEGER;
	
  begin
    l_string_pos := INSTR(l_no_line_endings,' '||i_search||' ',io_current_pos);
	if l_string_pos = 0 then
	  return false;
	end if;
	
	io_current_pos := l_string_pos + length (i_search);
	return true;
	
  end;
  
  --------------------------------------------------------------------
  -- get_pos_end - refactor with REGEXP_INSTR return_option gives you first char or char pos after.
  --------------------------------------------------------------------
  function get_pos_end(i_code        in CLOB
                      ,i_current_pos IN INTEGER
				      ,i_search      IN VARCHAR2
					  ,i_raise_error IN boolean default false
					  ,i_use_spaces  IN boolean default true) return integer is
				  
	l_no_line_endings  CLOB := replace(replace(i_code,chr(10),' '),chr(13),' ');	
    l_string_pos      INTEGER;	
	l_search          varchar2(2000);
	l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'get_pos_end');	
	l_result number;
  begin
    ms_logger.param(l_node, 'i_current_pos',i_current_pos);
	ms_logger.param(l_node, 'i_search',i_search);
	ms_logger.param(l_node, 'i_raise_error',i_raise_error);
    
	if i_use_spaces THEN
      l_search  := ' '||i_search||' ';
    else
	  l_search  := i_search;
	end if;
    l_string_pos := INSTR(UPPER(l_no_line_endings),UPPER(l_search),i_current_pos);
	if l_string_pos = 0 then
	  IF i_raise_error THEN
	    raise x_string_not_found;
      ELSE
	    l_result := 1000000;
	  end if;
	else   
	  l_result := l_string_pos + length (l_search);  
	end if;
	
	ms_logger.param(l_node, 'l_result',l_result);
 
	return l_result;
	
  end;
  

  --------------------------------------------------------------------
  -- parse_block - forward declaration (used recursively)
  --------------------------------------------------------------------
  procedure parse_block(io_code        in out clob
                       ,i_package_name in varchar2
                       ,i_block_name      in varchar2
					   ,i_param_injection in varchar2
                       ,io_current_pos IN OUT INTEGER
					   ,i_level        in integer); 
  
 
  
  --------------------------------------------------------------------
  -- parse_anon_block
  --------------------------------------------------------------------
  function parse_anon_block(io_code        in out clob
                          ,i_package_name in varchar2
                          ,io_current_pos IN OUT INTEGER
						  ,i_level        in integer) return boolean IS
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'parse_anon_block');					
		

	--interatively and recursively find anonymous blocks beginning DECLARE/BEGIN
	--  if DECLARE collect params again in another exposed-params-string
	
	--    in here there could also be additional procedures and functions...
	
	--  after BEGIN
	--    inject the exposed-params-string (if any)
	--  recursively call search_anon_block
    --find END
	--return pos of END


		
	l_next_declare   INTEGER := NULL;
	l_next_begin     INTEGER := NULL;
	l_next_end       INTEGER := NULL;
    l_next 	     INTEGER := NULL;
	l_end_of_unit  INTEGER := NULL;
	l_feedback    INTEGER := NULL;
	l_open_bracket INTEGER := NULL;
	l_semi_colon   INTEGER := NULL;
	
	--l_keyword_offset INTEGER := NULL;
	l_end_prog_unit_name INTEGER := NULL;
	l_inject_node VARCHAR2(200);
	l_prog_unit_name VARCHAR2(200);
	l_remainder  CLOB;
	l_count INTEGER;
	
	is_pos         INTEGER := NULL;
	bracket_pos    INTEGER := NULL;
	endbracket_pos INTEGER := NULL;
	comma_pos      INTEGER := NULL;
	
	l_param_line      VARCHAR2(2000);
	l_param_injection VARCHAR2(2000) := NULL;
	
	l_so_far  CLOB;
	
	l_name_pos     INTEGER;
	l_anon_block_name  VARCHAR2(200);
	l_declare          VARCHAR2(200);
	
  BEGIN
 
	l_next_declare := get_pos_end(io_code,io_current_pos,'DECLARE',false, false);
	ms_logger.note(l_node, 'l_next_declare',l_next_declare);
	
	l_next_begin := get_pos_end(io_code,io_current_pos,'BEGIN',false, false);
	ms_logger.note(l_node, 'l_next_begin',l_next_begin);
	
	l_next_end := get_pos_end(io_code,io_current_pos,'END;',false, false);
	ms_logger.note(l_node, 'l_next_end',l_next_end);
	l_next := least(l_next_declare,l_next_begin,l_next_end);
 
	IF l_next_end = l_next Then
	  ms_logger.info(l_node, 'No Anon Block Found');
	  return false;  --Reached END of calling prog unit.
	elsif l_next_declare = l_next then
	
	  --Search for a label if present.  (will be immediately preceding) 
	  --Eg 
	  --<<LABEL>>
	  --DECLARE
      l_so_far := dbms_lob.substr(io_code,l_next_declare,1);
	  ms_logger.note(l_node, 'l_so_far',l_so_far);

	  l_name_pos        :=  REGEXP_INSTR(l_so_far,'<<(.+)>>',1,REGEXP_COUNT(l_so_far,'<<(.+)>>'),0 );
	  ms_logger.note(l_node, 'l_name_pos',l_name_pos);
	  
	  l_anon_block_name :=  REGEXP_SUBSTR(io_code,'<<(.+)>>',l_name_pos,1,null,1);
	  ms_logger.note(l_node, 'l_anon_block_name',l_anon_block_name);

	  --To be doubly sure we'll need to check the next word is at l_next
	  l_declare := REGEXP_SUBSTR(io_code,'(.+)',l_name_pos+length(l_anon_block_name)+4,1);
	  ms_logger.note(l_node, 'l_declare',l_declare);
	  if TRIM(UPPER(l_declare)) <> 'DECLARE' THEN
	    ms_logger.fatal(l_node,'Anon block name mis-read');
	  END IF;
 

	elsif l_next_begin = l_next then
	
	  l_anon_block_name := NULL;

	end if;
 
    io_current_pos    := l_next;
	parse_block(io_code         => io_code
	           ,i_package_name  => i_package_name
	           ,i_block_name    => l_anon_block_name
               ,i_param_injection => NULL
			   ,io_current_pos  => io_current_pos
			   ,i_level         => i_level );
 
    return true;
	
  EXCEPTION
    --when x_string_not_found then
	--   return false;
	when others then
	   ms_logger.oracle_error(l_node); 
	   RAISE;
  
  END parse_anon_block;

 
  --------------------------------------------------------------------
  -- parse_prog_unit
  --------------------------------------------------------------------
  function parse_prog_unit(io_code        in out clob
                          ,i_package_name in varchar2
                          ,io_current_pos IN OUT INTEGER
						  ,i_level        in integer) return boolean IS
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'parse_prog_unit');					
							
	l_next_proc  INTEGER := NULL;
    l_next_func  INTEGER := NULL;	
	l_next_begin INTEGER := NULL;
	l_next_end   INTEGER := NULL;
    l_next 	     INTEGER := NULL;
	l_end_of_unit  INTEGER := NULL;
	l_feedback    INTEGER := NULL;
	l_open_bracket INTEGER := NULL;
	l_semi_colon   INTEGER := NULL;
	
	--l_keyword_offset INTEGER := NULL;
	l_end_prog_unit_name INTEGER := NULL;
	l_inject_node VARCHAR2(200);
	l_prog_unit_name VARCHAR2(200);
	l_remainder  CLOB;
	l_count INTEGER;
	
	is_pos         INTEGER := NULL;
	bracket_pos    INTEGER := NULL;
	endbracket_pos INTEGER := NULL;
	comma_pos      INTEGER := NULL;
	
	l_param_line      VARCHAR2(2000);
	l_param_injection VARCHAR2(2000) := NULL;
	
  BEGIN
 
  
    l_next_proc := get_pos_end(io_code,io_current_pos,'PROCEDURE');
	ms_logger.note(l_node, 'l_next_proc',l_next_proc);
	
	l_next_func := get_pos_end(io_code,io_current_pos,'FUNCTION'); 
	ms_logger.note(l_node, 'l_next_func',l_next_func);
	
	l_next_begin := get_pos_end(io_code,io_current_pos,'BEGIN');
	ms_logger.note(l_node, 'l_next_begin',l_next_begin);
	
	l_next_end := get_pos_end(io_code,io_current_pos,'END;');
	l_next := least(l_next_proc,l_next_func,l_next_begin,l_next_end);
	
	ms_logger.note(l_node, 'l_next_end',l_next_end);
	IF l_next IN (l_next_begin, l_next_end) Then
	  ms_logger.comment(l_node,'No more program units found');
	  return false;  
	elsif l_next = l_next_proc then
	  l_inject_node := 'new_proc';
	elsif l_next =  l_next_func then
	  l_inject_node := 'new_func';
	end if;
	ms_logger.note(l_node, 'l_inject_node',l_inject_node);
	
	io_current_pos := l_next;
	
    --l_remainder := replace(replace(ltrim(substr(io_code,io_current_pos)),chr(10),' '),chr(13),' ');
    l_end_prog_unit_name := regexp_instr( io_code, '\(|RETURN | IS', io_current_pos, 1,0,'i');
	ms_logger.note(l_node, 'l_end_prog_unit_name',l_end_prog_unit_name);
	l_prog_unit_name := substr(io_code,io_current_pos,l_end_prog_unit_name-io_current_pos);
	ms_logger.note(l_node, 'l_prog_unit_name',l_prog_unit_name);
 
	----if next token is open-bracket 
	----  loop until found close-bracket
	----    harvest each passed param and add to the exposed-params-string   
	--l_params := get_params_prog_unit(io_code, l_current_pos);
	--
	
    is_pos := get_pos_end(io_code,io_current_pos,'IS');
    --bracket_pos := get_pos_end(io_code,io_current_pos,'(',false);   
	bracket_pos := INSTR(io_code,'(',io_current_pos);
	--endbracket_pos := get_pos_end(io_code,io_current_pos,')',false);
	ms_logger.note(l_node, 'is_pos',is_pos);
	ms_logger.note(l_node, 'bracket_pos',bracket_pos);
	
    if bracket_pos < is_pos then
	  ms_logger.comment(l_node,'Found a bracket section before the IS');
	  io_current_pos := bracket_pos + 1;
	  endbracket_pos := INSTR(io_code,')',io_current_pos);
	  ms_logger.note(l_node, 'endbracket_pos',endbracket_pos);
	  --next token is open-bracket
	  --loop thru params collecting names and types.
	  l_count := 0;
	  loop
	    --comma_pos := get_pos_end(io_code,io_current_pos,',',false);
		comma_pos := INSTR(io_code,',',io_current_pos);
		if comma_pos = 0 then 
		  comma_pos := 100000;
		end if;
		ms_logger.note(l_node, 'comma_pos',comma_pos);
		l_param_line := substr(io_code,io_current_pos,LEAST(comma_pos,endbracket_pos)-io_current_pos);
	    ms_logger.note(l_node, 'l_param_line',l_param_line);
		
        declare 
	      l_tokens APEX_APPLICATION_GLOBAL.VC_ARR2;
		  l_param_name VARCHAR2(100);
		  l_param_type VARCHAR2(100);
	    begin
		  --ms_logger.comment(l_node, 'tokenise');
	      l_tokens := tokenise(i_string    => l_param_line
		                     , i_delimeter => ' '
		              	     , i_exclude   => 'IN OUT');
 
	      IF l_tokens.count > 1 then
		     ms_logger.comment(l_node, 'found l_param_name and l_param_type');
		     l_param_name := LOWER(l_tokens(1));
		     l_param_type := l_tokens(2);
			 ms_logger.note(l_node, 'l_param_name',l_param_name);
			 ms_logger.note(l_node, 'l_param_type',l_param_type);
		     IF  l_param_type IN ('NUMBER','DATE','VARCHAR2') then
			   ms_logger.comment(l_node, 'valid l_param_type');
		       l_param_injection := l_param_injection||chr(10)||rpad(' ',i_level*2+2,' ')||'ms_logger.param(l_node,'''||l_param_name||''','||l_param_name||');';
			    ms_logger.note(l_node, 'l_param_injection',l_param_injection);
		     else
               ms_logger.comment(l_node, 'INVALID l_param_type');			 
		     end if;
		   end if;
		end;
		
	    exit when comma_pos > endbracket_pos or l_count > 50 or endbracket_pos = 0;
		io_current_pos := comma_pos+1;
		l_count := l_count+ 1;	
      end loop;	  
	  
	
	end if;
 
 
    io_current_pos := get_pos_end(io_code,io_current_pos,'IS');
	
	ms_logger.comment(l_node, 'Injecting new node');	
    inject( p_code      => io_code  
           ,p_new_code  => rpad(' ',i_level*2+2,' ')
           ||'l_node ms_logger.node_typ := ms_logger.'||l_inject_node||'('''||i_package_name||''','''||l_prog_unit_name||''');'
           ,p_pos      => io_current_pos);
 
    ms_logger.comment(l_node, 'Injected new node');
	
	parse_block(io_code         => io_code
	           ,i_package_name  => i_package_name
	           ,i_block_name    => l_prog_unit_name
               ,i_param_injection => l_param_injection
			   ,io_current_pos  => io_current_pos
			   ,i_level         => i_level );

 
    return true;
	
  EXCEPTION
	when others then
	   ms_logger.oracle_error(l_node); 
	   RAISE;
  
  END;
  
 
  --------------------------------------------------------------------
  -- parse_block
  --------------------------------------------------------------------
  procedure parse_block(io_code           in out clob
                       ,i_package_name    in varchar2
                       ,i_block_name      in varchar2
					   ,i_param_injection in varchar2
                       ,io_current_pos IN OUT INTEGER
					   ,i_level        in integer) IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'parse_block');					   
		
    l_count       INTEGER;
	
	l_end_of_unit INTEGER;
 
  begin
  
    ms_logger.param(l_node, 'i_package_name'             ,i_package_name    );
    ms_logger.param(l_node, 'i_block_name'               ,i_block_name      );
    ms_logger.param(l_node, 'i_param_injection'          ,i_param_injection );  
	ms_logger.param(l_node, 'io_current_pos'             ,io_current_pos      );
    ms_logger.param(l_node, 'i_level'                    ,i_level      );
  
  
    --look for embedded prog units before the next begin or end.
    l_count := 0;
    WHILE parse_prog_unit(io_code         => io_code
	                     ,i_package_name  => i_package_name 
                         ,io_current_pos  => io_current_pos
						 ,i_level         => i_level + 1) and l_count < 50 LOOP
	  ms_logger.note(l_node, 'Program Units found in header',l_count);					 
	  l_count := l_count+ 1;					 
    END LOOP;
  
    ms_logger.comment(l_node, 'Finished looking for Program Units in header');

	ms_logger.comment(l_node, 'Now find the begin so we can inject the params');
	--Now find the begin so we can inject the params
	io_current_pos := get_pos_end(io_code,io_current_pos,'BEGIN',false,false)-1;
	
	--Mark the BEGIN of the program unit.
    splice( p_code      => io_code  
           ,p_new_code  => '--'||i_block_name||' AOP'
           ,p_pos       => io_current_pos);
 
    inject( p_code      => io_code  
           ,p_new_code  => '  begin --'||i_block_name||' ORIG' --extra begin so we can have a surrounding block for the AOP exception when others 
		           ||chr(10)||i_param_injection
           ,p_pos       => io_current_pos);
		   
		   
    l_count := 0;
    WHILE parse_anon_block(io_code         => io_code
	                      ,i_package_name  => i_package_name 
                          ,io_current_pos  => io_current_pos
						  ,i_level         => i_level + 1) and l_count < 50 LOOP
	  l_count := l_count+ 1;
	  ms_logger.note(l_node, 'Anonymous Blocks found in body',l_count);	
    END LOOP;  
  
	l_end_of_unit := get_pos_end(io_code,io_current_pos,' END;',false, false)-1;
	 
    ms_logger.comment(l_node, 'move pointer to the end of this program unit');
    --move pointer to the end of this program unit (which will cause this loop to exit)
	io_current_pos := l_end_of_unit;

	--Mark end of original program unit code.
    splice( p_code      => io_code  
           ,p_new_code  => '--'||i_block_name||' ORIG'
           ,p_pos       => io_current_pos);	
	
	--add the terminating exception handler of the new surrounding block
    inject( p_code      => io_code  
           ,p_new_code  => 'exception'
		         ||chr(10)||'  when others then'
				 ||chr(10)||'    ms_logger.warn_error(l_node);'
				 ||chr(10)||'    raise;'
				 ||chr(10)||'end; --'||i_block_name||' AOP'
           ,p_pos       => io_current_pos);
	
  EXCEPTION
	when others then
	   ms_logger.oracle_error(l_node); 
	   RAISE;
	
END;  
  

  function weave
  ( p_code in out clob
  , p_package_name in varchar2
  ) return boolean
  is

    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'weave'); 
 
    l_advised            boolean := false;
	l_current_pos        integer := 1;
    l_count              NUMBER  := 0;
    l_end_pos            integer;  
	
	l_end_value          varchar2(50);
	l_mystery_word       varchar2(50);
 
  begin
 
    ms_logger.param(l_node, 'p_package_name'      ,p_package_name);
	
	--First task will be to remove all comments or 
	--somehow identify and remember all sections that can be ignored because they are comments
 
   
    --LATER WHEN WE WANT TO SUPPORT THE BEGIN SECTION OF A PACKAGE
	--WE WOULD REPLACE parse_prog_unit below with parse_anon_block
 
	--Change any program unit ending of form "end program_unit_name;" to just "end;" for simplicity
	--Preprocess p_code cleaning up block end statements.
    --IE Translate "END prog_unit_name;" -> "END;"	
	
	--Reset the processing pointer.
    l_current_pos := 1;
	l_end_pos     := 1;
	LOOP
	  l_end_pos := REGEXP_INSTR(p_code,'end (.*);',l_current_pos,1,0,'i');
	  EXIT WHEN l_end_pos = 0; 
	 
	  l_end_value := SUBSTR(REGEXP_SUBSTR(p_code,'end (.*);',l_current_pos,1,'i'),1,50);
	  ms_logger.note(l_node, 'l_end_value'      ,l_end_value);
	  --check that the end value was all from 1 line.
	  if l_end_value like '%;' then
	    l_mystery_word := trim(rtrim(substr(l_end_value,4),';'));
	    ms_logger.note(l_node, 'l_mystery_word'      ,l_mystery_word);
	    if l_mystery_word not in ('IF'
	                             ,'LOOP'
	    						   ,'CASE') then
	      ms_logger.info(l_node, 'Replacing '||l_end_value);
	      p_code := REGEXP_REPLACE(p_code,'end (.*);','end;',l_current_pos,1,'i');
	    
	    end if;
	  end if;
      
	  l_current_pos := l_end_pos + 4;
 
	END LOOP;
 
	
	--Reset the processing pointer.
    l_current_pos := 1;
    --This limit is a safetly limit only.
	--Currently stops more than 50 program units, at the top level, being processed.
    l_count := 0;
    WHILE parse_prog_unit(io_code         => p_code
	                     ,i_package_name  => p_package_name 
                         ,io_current_pos  => l_current_pos
						 ,i_level         => 1) and l_count < 50 LOOP
	  l_count := l_count+ 1;					 
    END LOOP;
 
    l_advised:= true;
 
    p_code := REPLACE(p_code,g_aop_directive,'Logging by AOP_PROCESSOR on '||to_char(systimestamp,'DD-MM-YYYY HH24:MI:SS'));
    
	--Translate SIMPLE ms_feedback syntax to MORE COMPLEX ms_logger syntax
	--EG ms_feedback.x(           ->  ms_logger.x(l_node,
	p_code := REGEXP_REPLACE(p_code,'(ms_feedback)(\.)(.+)(\()','ms_logger.\3(l_node,');

	--Replace routines with no params 
	--EG ms_feedback.oracle_error -> ms_logger.oracle_error(l_node)
	p_code := REGEXP_REPLACE(p_code,'(ms_feedback)(\.)(.+)(;)','ms_logger.\3(l_node);');

 
    return l_advised;
	
  exception 
    when others then
      ms_logger.oracle_error(l_node);	
	  raise;
	
  end weave;
  
  procedure advise_package
  ( p_object_name   in varchar2
  , p_object_type   in varchar2
  , p_object_owner  in varchar2
  ) is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'advise_package');
  
	l_orig_body clob;
	l_woven_body clob;
    l_advised boolean := false;
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
	                      , i_aop_yn => 'N') THEN
	  g_during_advise:= false; 
	  return; -- Don't bother with AOP since the original source is invalid anyway.			
	end if;		  
 
	l_woven_body := l_orig_body;
    -- manipulate source by weaving in aspects as required; only weave if the key logging not yet applied.
    l_advised := weave( p_code         => l_woven_body
                      , p_package_name => lower(p_object_name)  );
 
    -- (re)compile the source if any advises have been applied
    if l_advised then
	
	  IF NOT validate_source(i_name  => p_object_name
	                       , i_type  => p_object_type
	                       , i_text  => l_woven_body
	                       , i_aop_yn => 'Y') THEN
 
	    --reexecute the original so that we at least end up with a valid package.
	    IF NOT  validate_source(i_name  => p_object_name
	                          , i_type  => p_object_type
	                          , i_text  => l_orig_body
	                          , i_aop_yn => 'N') THEN
		  --unlikely that we'd get an error in the original if it worked last time
		  --but trap it incase we do	
          ms_logger.fatal(l_node,'Original Source is invalid on second try.');		  
		end if;
 
	  end if;	
 
    end if;
    g_during_advise:= false; 

  exception 
    when others then
      ms_logger.oracle_error(l_node);	
	  g_during_advise:= false; 
   
  end advise_package;
  
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
 
end aop_processor;
/
show error;

alter trigger aop_processor_trg enable;