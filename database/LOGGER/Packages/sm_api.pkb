alter session set plsql_ccflags = 'intlog:false';
--alter package sm_api compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package sm_api compile PLSQL_CCFlags = 'intlog:false' reuse settings 

--Ensure no inlining so sm_api can be used
alter session set plsql_optimize_level = 1;

create or replace package body sm_api is
------------------------------------------------------------------
-- Program  : sm_api  
-- Name     : SmartLoggerAPI 
-- Author   : P.Burgess
-- Purpose  : API providing interaction with the logger
-- Since the SM_WEAVER can now instrument code for the SmartLogger (sm_logger),
-- sm_logger will contain only commands that the SM_WEAVER produces.
-- Other commands that control the SmartLogger, its modes, perhaps registry changes,
-- and requests for output, will generally be hand-coded into the target application.
-- These commands will form the SmartLoggerAPI.

------------------------------------------------------------------------
-- This package is not to be instrumented by the SM_WEAVER
-- @AOP_NEVER 
------------------------------------------------------------------------
 
G_SMARTLOGGER_SESSION_PAGE_NO CONSTANT NUMBER := 8;
G_SMARTLOGGER_TRACE_PAGE_NO   CONSTANT NUMBER := 24;
 

--------------------------------------------------------------------------------
--f_config_value
--------------------------------------------------------------------------------
function f_config_value(i_name IN VARCHAR2) return VARCHAR2 IS

  cursor cu_config(c_name IN VARCHAR2) is
  select value
  from   sm_config
  where  name = c_name;

  l_result  sm_config.value%type;
 
begin
  open  cu_config(c_name => i_name);
  fetch cu_config into l_result;
  close cu_config;

  return l_result;
 
end; 

------------------------------------------------------------------------ 
-- FUNCTIONS USED IN VIEWS
------------------------------------------------------------------------ 
 
FUNCTION msg_level_string (i_msg_level    IN NUMBER) RETURN VARCHAR2
IS
  v_result VARCHAR2(100) := NULL;
BEGIN
    IF i_msg_level = sm_logger.G_MSG_LEVEL_INFO THEN
      v_result  := 'Info ?';
    ELSIF i_msg_level =  sm_logger.G_MSG_LEVEL_COMMENT THEN
      v_result  := 'Comment';
    ELSIF i_msg_level =  sm_logger.G_MSG_LEVEL_WARNING THEN
      v_result  := 'Warning !';
    ELSIF i_msg_level =  sm_logger.G_MSG_LEVEL_FATAL THEN
      v_result  := 'Fatal !';
    ELSIF i_msg_level =  sm_logger.G_MSG_LEVEL_ORACLE THEN
      v_result  := 'Oracle Error';
    ELSIF i_msg_level =  sm_logger.G_MSG_LEVEL_INTERNAL THEN
      v_result  := 'Internal Error';
    END IF;

  RETURN v_result;
END msg_level_string;




 
FUNCTION unit_message_count(i_unit_id      IN NUMBER
                           ,i_msg_level    IN NUMBER) RETURN NUMBER IS
                           
  CURSOR cu_message_count(c_unit_id      NUMBER                         
                         ,c_msg_level    NUMBER) IS
  SELECT count(*)
  FROM   sm_call_message_vw
  WHERE  unit_id    =  c_unit_id
  AND    msg_level  =  c_msg_level; 
  
  l_result NUMBER;
  
BEGIN
  OPEN cu_message_count(c_unit_id      => i_unit_id
                       ,c_msg_level    => i_msg_level);
  FETCH cu_message_count INTO l_result;
  CLOSE cu_message_count;
  
  RETURN l_result;
  
END;  

 
FUNCTION unit_call_count(i_unit_id IN NUMBER ) RETURN NUMBER IS
                           
  CURSOR cu_call_count(c_unit_id NUMBER ) IS
  SELECT count(*)
  FROM  sm_call
  WHERE unit_id =  c_unit_id; 
  
  l_result NUMBER;
  
BEGIN
  OPEN cu_call_count(c_unit_id => i_unit_id );
  FETCH cu_call_count INTO l_result;
  CLOSE cu_call_count;
  
  RETURN l_result;
  
END;  


------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE  set_module_debug(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => sm_logger.G_MSG_MODE_DEBUG);
END; 

------------------------------------------------------------------------

PROCEDURE  set_module_normal(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
 sm_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => sm_logger.G_MSG_MODE_NORMAL);
END; 

------------------------------------------------------------------------

PROCEDURE  set_module_quiet(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => sm_logger.G_MSG_MODE_QUIET);
END; 
 
PROCEDURE  set_module_disabled(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => sm_logger.G_MSG_MODE_DISABLED);
END; 

------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE  set_unit_debug(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode     => sm_logger.G_MSG_MODE_DEBUG);
END; 

------------------------------------------------------------------------

PROCEDURE  set_unit_normal(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode     => sm_logger.G_MSG_MODE_NORMAL);
END; 

------------------------------------------------------------------------

PROCEDURE  set_unit_quiet(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode    => sm_logger.G_MSG_MODE_QUIET);
END; 
 
PROCEDURE  set_unit_disabled(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  sm_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode     => sm_logger.G_MSG_MODE_DISABLED);
END; 


--------------------------------------------------------------------
--purge_old_sessions
-------------------------------------------------------------------


PROCEDURE purge_old_sessions(i_keep_day_count IN NUMBER DEFAULT 1) IS

 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

  delete from sm_session 
  where  created_date < (SYSDATE - i_keep_day_count)
  and    keep_yn = 'N';
 
  COMMIT;
  
 END;
 
--------------------------------------------------------------------
--set_session_keep_flag
-------------------------------------------------------------------
PROCEDURE set_session_keep_flag(i_session_id IN NUMBER
                               ,i_keep_yn    IN VARCHAR2 DEFAULT 'Y') IS

 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

  update sm_session 
     set keep_yn = i_keep_yn
  where  session_id = i_session_id;
 
  COMMIT;
  
 END;


--------------------------------------------------------------------
--toggle_session_keep_flag
-------------------------------------------------------------------
PROCEDURE toggle_session_keep_flag(i_session_id IN NUMBER ) IS

 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

  update sm_session 
     set keep_yn = decode(keep_yn,'Y','N','N','Y','Y')
  where  session_id = i_session_id;
 
  COMMIT;
  
 END;

 
------------------------------------------------------------------------
-- get_plain_text_session_report
------------------------------------------------------------------------
 
FUNCTION get_plain_text_session_report(i_session_id IN NUMBER) RETURN CLOB IS
  l_report CLOB;
  l_session_id INTEGER := NVL(i_session_id, sm_logger.f_session_id);
BEGIN
 
	FOR l_line IN (SELECT lpad('+ ',(level-1)*2,'+ ')
                         ||module_name||'.'
                         ||unit_name
                         ||chr(10)||(SELECT listagg('**'||name||':'||value,chr(10)) within group (order by call_id) from sm_message where call_id = t.call_id and msg_type in ('Param','Note'))
                         ||chr(10)||(SELECT listagg('--'||message,chr(10)) within group (order by message_id) from sm_message where call_id = t.call_id and msg_type not in ('Param','Note')) as text
                   FROM sm_unit_call_vw t
                   WHERE session_id = l_session_id
                   START WITH parent_call_id IS NULL
                   CONNECT BY PRIOR call_id = parent_call_id
                   ORDER SIBLINGS BY call_id) LOOP
	
	 
	  l_report := l_report ||chr(10)||l_line.text;

	END LOOP;  
 
  RETURN l_report;

END;
 
------------------------------------------------------------------------
-- get_html_session_report
------------------------------------------------------------------------
FUNCTION get_html_session_report(i_session_id in integer DEFAULT NULL) RETURN CLOB IS

  l_node sm_logger.node_typ := sm_logger.new_func($$plsql_unit ,'get_html_session_report');
  l_report CLOB;
  
  G_COLOUR_PROG_UNIT  VARCHAR2(10) := '#6699FF';
  G_COLOUR_NOTE       VARCHAR2(10) := '#FFFF99';
  G_COLOUR_PARAM      VARCHAR2(10) := '#FF9999';
  G_COLOUR_COMMENT    VARCHAR2(10) := '#99FF99';
  G_COLOUR_INFO       VARCHAR2(10) := '#CCFF99';
  G_COLOUR_WARNING    VARCHAR2(10) := '#FF6600';
  G_COLOUR_ERROR      VARCHAR2(10) := '#FF0000';
  
  l_colour            VARCHAR2(10);  
  
  l_session_id INTEGER := NVL(i_session_id, sm_logger.f_session_id);
  
  PROCEDURE write(i_line IN VARCHAR2 DEFAULT NULL) IS

    l_node sm_logger.node_typ := sm_logger.new_proc($$plsql_unit ,'write');
 
  begin --write
    sm_logger.param(l_node,'i_line',i_line);

 BEGIN
    l_report := l_report||chr(10)||i_line;
  END;
  exception
    when others then
      sm_logger.warn_error(l_node);
      raise;
  end; --write

  
  
begin --get_html_session_report

BEGIN



  write('<HTML><BODY>');
  write('<BR><BR>');
  write(htf.tableopen(cattributes => 'width="1200px"'));
  
  --Level Unit Name    Name   Value   Message  Time 
  write(htf.tablerowopen);
    write(htf.tableheader('Level Unit Name'   ,calign=>'LEFT'));
	write(htf.tableheader('Name'              ,calign=>'LEFT'));
	write(htf.tableheader('Value'             ,calign=>'LEFT'));
	write(htf.tableheader('Message'           ,calign=>'LEFT'));
	write(htf.tableheader('Time'              ,calign=>'LEFT',cnowrap=> 'Y'));
  write(htf.tablerowclose);
 
	FOR l_line IN (
	   select a.* 
             ,m.MESSAGE_ID
             ,decode(instr(m.MESSAGE,chr(10)),0,m.MESSAGE,'<PRE>'||m.MESSAGE||'</PRE>')     MESSAGE
             ,m.MSG_LEVEL
             ,m.MSG_TYPE
             ,to_char(m.TIME_NOW,'DD-Mon-YYYY HH24:MI:SS') time_now
             ,m.MSG_LEVEL_TEXT
             ,m.name
             ,m.value
       from (
       select level
               ,ut.*
             ,'<span style="padding-left:'||LEVEL*10||'px;">'||ut.unit_name||'</span>' level_unit_name
         from sm_unit_call_vw ut
		 WHERE session_id = l_session_id 
         start with ut.PARENT_call_ID IS NULL
         connect by prior ut.call_ID = ut.PARENT_call_ID
         order siblings by ut.call_ID) a
         ,sm_message_vw m
       where m.call_id = a.call_id
	   order by message_id
	 ) LOOP
	
	   IF    l_line.MSG_TYPE       = 'Note'                      THEN l_colour := G_COLOUR_NOTE;
	   ELSIF l_line.MSG_TYPE       = 'Param'                     THEN l_colour := G_COLOUR_PARAM;   
	   ELSIF l_line.MSG_LEVEL_TEXT = 'Comment'                   THEN l_colour := G_COLOUR_COMMENT;  
	   ELSIF l_line.MSG_LEVEL_TEXT = 'Info'                      THEN l_colour := G_COLOUR_INFO;
	   ELSIF l_line.MSG_LEVEL_TEXT = 'Warning !'                 THEN l_colour := G_COLOUR_WARNING;
	   ELSIF l_line.MSG_LEVEL_TEXT IN ('Oracle Error','Fatal !') THEN l_colour := G_COLOUR_ERROR;
	   ELSE  l_colour := '#660066';
	   END IF; 	
	   
     --Level Unit Name    Name   Value   Message  Time_Now
     write(htf.tablerowopen);
       write(htf.tabledata('<span style="background-color:'||G_COLOUR_PROG_UNIT||';">'||l_line.Level_Unit_Name||'</span>'));
	   write(htf.tabledata('<span style="background-color:'||l_colour          ||';">'||l_line.Name           ||'</span>'));
	   write(htf.tabledata('<span style="background-color:'||l_colour          ||';">'||l_line.Value          ||'</span>'));
	   write(htf.tabledata('<span style="background-color:'||l_colour          ||';">'||l_line.Message        ||'</span>'));
	   write(htf.tabledata('<span style="background-color:'||l_colour          ||';">'||l_line.Time_Now       ||'</span>',cnowrap=> 'Y'));
     write(htf.tablerowclose);
 
  
	END LOOP;  
 
   write(htf.tableclose);
   write('</BODY></HTML>');
 
  RETURN l_report;

END;
exception
  when others then
    sm_logger.warn_error(l_node);
    raise;
end; --get_html_session_report


------------------------------------------------------------------------
-- prepare_URL
------------------------------------------------------------------------
FUNCTION prepare_URL(i_server_url    IN VARCHAR2 DEFAULT NULL
                    ,i_port          IN VARCHAR2 DEFAULT NULL
                    ,i_dir           IN VARCHAR2 DEFAULT NULL
                    ,i_app_no        IN VARCHAR2 DEFAULT NULL
                    ,i_page_no       IN VARCHAR2 DEFAULT NULL
                    ,i_session       IN VARCHAR2 DEFAULT NULL
                    ,i_request       IN VARCHAR2 DEFAULT NULL
                    ,i_clear_cache   IN VARCHAR2 DEFAULT NULL
                    ,i_param_names   IN VARCHAR2 DEFAULT NULL
                    ,i_param_values  IN VARCHAR2 DEFAULT NULL
                    ,i_checksum_type IN VARCHAR2 DEFAULT 'SESSION') RETURN VARCHAR2 IS

  --l_server_url VARCHAR2(200) := NVL(i_server_url, f_config_value(i_name => 'APEX_SERVER_URL') );
  --l_port       VARCHAR2(20)  := NVL(i_port,       f_config_value(i_name => 'APEX_PORT') );
  --l_dir        VARCHAR2(50)  := NVL(i_dir,        f_config_value(i_name => 'APEX_DIR') );
  l_app_no     VARCHAR2(20)  := NVL(i_app_no,  v('APP_ID'));
  l_page_no    VARCHAR2(20)  := NVL(i_page_no,  v('APP_PAGE_ID'));
  l_session    number        := NVL(i_session, v('APP_SESSION'));

BEGIN
  RETURN 
      ltrim(i_server_url
          ||case i_port
              when null then null
            else ':'||i_port
            end
          ||case i_dir
              when null then null
            else '/'||i_dir
            end
          ||'/','/')
      ||APEX_UTIL.PREPARE_URL('f?p='||l_app_no||':'||l_page_no||':'||l_session||':'
                                    ||i_request||'::'
                                    ||i_clear_cache||':'
                                    ||i_param_names||':'
                                    ||i_param_values
                              ,p_checksum_type => i_checksum_type);
 
END;  

------------------------------------------------------------------------
-- get_apex_page_URL
------------------------------------------------------------------------
FUNCTION get_apex_page_URL(i_server_url  IN VARCHAR2 DEFAULT NULL
                          ,i_port        IN VARCHAR2 DEFAULT NULL
                          ,i_dir         IN VARCHAR2 DEFAULT NULL
                          ,i_app_no      IN VARCHAR2
                          ,i_page_no     IN VARCHAR2
                          ,i_request     IN VARCHAR2
                          ,i_clear_cache IN VARCHAR2
                          ,i_param_names IN VARCHAR2
                          ,i_param_values IN VARCHAR2 ) RETURN VARCHAR2 IS

  l_server_url VARCHAR2(200) := NVL(i_server_url, f_config_value(i_name => 'APEX_SERVER_URL') );
  l_port       VARCHAR2(20)  := NVL(i_port,       f_config_value(i_name => 'APEX_PORT') );
  l_dir        VARCHAR2(50)  := NVL(i_dir,        f_config_value(i_name => 'APEX_DIR') );
 
  l_session number := null; --v('APP_SESSION');

BEGIN
  RETURN 
     --   l_server_url
     -- ||case l_port
     --     when null then null
     --   else ':'||l_port
     --   end
     -- ||case l_dir
     --     when null then null
     --   else '/'||l_dir
     --   end
     -- ||'/'
     -- ||
      APEX_UTIL.PREPARE_URL('f?p='||i_app_no||':'||i_page_no||':'||l_session||':'
                                    ||i_request||'::'
                                    ||i_clear_cache||':'
                                    ||i_param_names||':'
                                    ||i_param_values
                              ,p_checksum_type => 'PUBLIC_BOOKMARK');
 
END;  

 

------------------------------------------------------------------------
-- get_smartlogger_report_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_report_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                                   ,i_port         IN VARCHAR2 DEFAULT NULL
                                   ,i_dir          IN VARCHAR2 DEFAULT NULL
                                   ,i_page_no      IN VARCHAR2
                                   ,i_session_id   IN INTEGER   ) RETURN VARCHAR2 IS

  l_request     VARCHAR2(30);
 
BEGIN

  if i_session_id is null then 
    --There is no session to report on.
    return null;
  end if; 
  
  IF sm_logger.f_session_exceptions(i_session_id => i_session_id) THEN
    --Exceptions exist so lets show them.
    l_request := 'IR_REPORT_EXCEPTIONS';
  ELSE
    --No exceptions lets show normal messages.
    l_request := 'IR_REPORT_MESSAGES';
  END IF;
 
  RETURN get_apex_page_URL(i_server_url  => i_server_url
                          ,i_port        => i_port
                          ,i_dir         => i_dir
                          ,i_app_no      => f_config_value(i_name => 'LOGGER_APP_ALIAS')
                          ,i_page_no     => i_page_no
                          ,i_request     => l_request
                          ,i_clear_cache => 'RIR,RP,'||i_page_no
                          ,i_param_names => 'P'||i_page_no||'_SESSION_ID'
                          ,i_param_values => i_session_id);

END; 
 
------------------------------------------------------------------------
-- get_smartlogger_trace_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_trace_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                                  ,i_port         IN VARCHAR2 DEFAULT NULL
                                  ,i_dir          IN VARCHAR2 DEFAULT NULL
                                  ,i_session_id   IN INTEGER   ) RETURN VARCHAR2 IS
 
BEGIN

  RETURN get_smartlogger_report_URL(i_server_url  => i_server_url
                                   ,i_port        => i_port
                                   ,i_dir         => i_dir
                                   ,i_page_no     => G_SMARTLOGGER_TRACE_PAGE_NO
                                   ,i_session_id  => i_session_id);
 
END; 


------------------------------------------------------------------------
-- get_smartlogger_session_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_session_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                                    ,i_port         IN VARCHAR2 DEFAULT NULL
                                    ,i_dir          IN VARCHAR2 DEFAULT NULL
                                    ,i_session_id   IN INTEGER   ) RETURN VARCHAR2 IS
 
BEGIN

  RETURN get_smartlogger_report_URL(i_server_url  => i_server_url
                                   ,i_port        => i_port
                                   ,i_dir         => i_dir
                                   ,i_page_no     => G_SMARTLOGGER_SESSION_PAGE_NO
                                   ,i_session_id  => i_session_id);
 
END; 


 
 
------------------------------------------------------------------------
-- get_trace_URL - first checks session exists
------------------------------------------------------------------------
FUNCTION get_trace_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                      ,i_port         IN VARCHAR2 DEFAULT NULL
                      ,i_dir          IN VARCHAR2 DEFAULT NULL
                      ,i_session_id   IN INTEGER  DEFAULT NULL
                     -- ,i_ext_ref      IN VARCHAR2 DEFAULT NULL  
                      ) RETURN VARCHAR2 IS
 
  l_session_id INTEGER;
  l_result     VARCHAR2(2000);
  
 
BEGIN 

  l_session_id := sm_logger.f_session_id(i_session_id => i_session_id
                                       -- ,i_ext_ref    => i_ext_ref 
                                        );  
 
  IF sm_logger.f_session_logged(i_session_id => l_session_id) THEN
    l_result := get_smartlogger_trace_URL(i_server_url  => i_server_url
                                         ,i_port        => i_port
                                         ,i_dir         => i_dir      
                                         ,i_session_id  => l_session_id);
 
  END IF;
  
  RETURN l_result;
 
END;
 
 
------------------------------------------------------------------------
-- get_user_feedback_URL
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                              ,i_port         IN VARCHAR2 DEFAULT NULL
                              ,i_dir          IN VARCHAR2 DEFAULT NULL
                              ,i_session_id   IN NUMBER   DEFAULT NULL) RETURN VARCHAR2 IS
  l_session_id INTEGER;
BEGIN

  l_session_id := NVL(i_session_id, sm_logger.f_session_id);

  IF sm_logger.f_session_logged(i_session_id => l_session_id) THEN
  
    RETURN 'Click to view Trace:  '
            ||get_smartlogger_trace_URL(i_server_url  => i_server_url
                                       ,i_port        => i_port
                                       ,i_dir         => i_dir       
                                       ,i_session_id  => l_session_id);

  ELSE
    RETURN NULL;
  END IF;
 
END;
 
------------------------------------------------------------------------
-- get_user_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_anchor(i_server_url   IN VARCHAR2 DEFAULT NULL
                                 ,i_port         IN VARCHAR2 DEFAULT NULL
                                 ,i_dir          IN VARCHAR2 DEFAULT NULL
                                 ,i_session_id   IN NUMBER   DEFAULT NULL ) RETURN VARCHAR2 IS
  l_session_id INTEGER;
BEGIN

  l_session_id := NVL(i_session_id, sm_logger.f_session_id);

  IF sm_logger.f_session_logged(i_session_id => l_session_id) THEN
  
    return htf.anchor(curl        => get_smartlogger_trace_URL(i_server_url  => i_server_url
                                                              ,i_port        => i_port
                                                              ,i_dir         => i_dir       
                                                              ,i_session_id  => l_session_id)
                     ,ctext       => 'Click to view Trace'
                     ,cname       => NULL
                     ,cattributes => NULL);
  ELSE
    RETURN NULL;
  END IF;
 
END;
 
 
------------------------------------------------------------------------
-- get_support_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_support_feedback_anchor(i_server_url   IN VARCHAR2 DEFAULT NULL
                                    ,i_port         IN VARCHAR2 DEFAULT NULL
                                    ,i_dir          IN VARCHAR2 DEFAULT NULL
                                    ,i_session_id   IN NUMBER   DEFAULT NULL) RETURN VARCHAR2 IS
 --'http://soraempl002.au.fcl.internal:8080'
  l_session_id INTEGER;
BEGIN

  l_session_id := NVL(i_session_id, sm_logger.f_session_id);

  IF sm_logger.f_session_logged(i_session_id => l_session_id) THEN
  
    return htf.anchor(curl        => get_smartlogger_session_URL(i_server_url  => i_server_url
                                                                ,i_port        => i_port
                                                                ,i_dir         => i_dir      
                                                                ,i_session_id  => l_session_id)
                     ,ctext       => 'Click to view Debugging'
                     ,cname       => NULL
                     ,cattributes => NULL);
  ELSE
    RETURN NULL;
  END IF;
  
 
END; 
 
 
 
------------------------------------------------------------------------
-- smtp_mail
------------------------------------------------------------------------
 
PROCEDURE smtp_mail(i_email_to        IN VARCHAR2
              ,i_subject         IN VARCHAR2 
			        ,i_body_plain      IN CLOB     DEFAULT NULL
			        ,i_body_html       IN CLOB     DEFAULT NULL
              ,i_email_from      IN VARCHAR2 DEFAULT NULL
			        ,i_email_reply_to  IN VARCHAR2 DEFAULT NULL
			        ,i_mail_host       IN VARCHAR2 DEFAULT NULL ) IS
BEGIN
  NULL;
  /*  HIDE FROM XE11G  						  
  l_email_to       VARCHAR2(100) :=  i_email_to;
  l_email_from     VARCHAR2(100) :=  NVL(i_email_from    ,i_email_to);
  l_email_reply_to VARCHAR2(100) :=  NVL(i_email_reply_to,i_email_from);					  
 
  l_boundary       VARCHAR2(50) := 'random-sequence-of-chars';
  
  l_mail_conn      utl_smtp.connection;
  
  l_mail_host      VARCHAR2(300)  := NULL;
  
  
  FUNCTION get_char_set RETURN VARCHAR2 IS
    l_result             VARCHAR2(300)  := NULL;
  BEGIN
      SELECT value 
	  INTO l_result
	  FROM NLS_DATABASE_PARAMETERS
	  WHERE  parameter = 'NLS_CHARACTERSET';
  
    RETURN l_result;
  END;
 
  PROCEDURE write_line(i_line IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    UTL_SMTP.write_data(l_mail_conn, i_line||UTL_TCP.crlf);
  END;
 
  PROCEDURE write_clob(i_clob IN CLOB) IS
        l_len     INTEGER;
        l_index   INTEGER;
    BEGIN
        l_len      := DBMS_LOB.getlength(i_clob);
        l_index    := 1;

        WHILE l_index <= l_len
        LOOP
            UTL_SMTP.write_data(l_mail_conn,
                                DBMS_LOB.SUBSTR(i_clob, 32000, l_index)
                               );
            l_index    := l_index + 32000;
        END LOOP;
    END;
 
BEGIN

    -- Send the e-mail.

	l_mail_host := NVL(i_mail_host,'localhost');
 
    l_mail_conn := utl_smtp.open_connection(l_mail_host, 25);
    utl_smtp.helo(l_mail_conn, l_mail_host);
    utl_smtp.mail(l_mail_conn, l_email_to  );
    utl_smtp.rcpt(l_mail_conn, l_email_from);
    UTL_SMTP.open_data(l_mail_conn);
	write_line('Date: '     ||TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
	write_line('To: '       || l_email_to                               );
	write_line('From: '     || l_email_from                             );
	write_line('Subject: '  || i_subject                                );
	write_line('Reply-To: ' || l_email_reply_to                         );
--MULTI-PART START
	write_line('MIME-Version: 1.0'                                      );
    write_line('Content-Type: multipart/alternative; boundary="'||l_boundary ||'"');
	write_line;
	write_line('This is a multi-part message in MIME format.');
--PLAIN TEXT VERSION
	write_line;
    write_line('--' || l_boundary);	
	write_line('Content-Type: text/plain; charset="'||get_char_set||'"');
	--write_line('Content-Transfer-Encoding: quoted-printable');
	write_line;
    write_clob(i_body_plain);
--HTML MESSAGE VERSION	
	write_line;
    write_line('--' || l_boundary);	 
	write_line('Content-Type: text/html; charset="'||get_char_set||'"');  --Encoding=”base64″
	--write_line('Content-Transfer-Encoding: 7bit');
	write_line;
    write_clob(i_body_html);
--MULTI-PART END
	write_line;
    write_line('--' || l_boundary|| '--');	
	write_line;
	UTL_SMTP.close_data(l_mail_conn);
    utl_smtp.quit(l_mail_conn);
 */
END smtp_mail;
 
 
------------------------------------------------------------------------
-- trawl_log_for_errors
------------------------------------------------------------------------
PROCEDURE trawl_log_for_errors IS

  --Find all bad
  CURSOR cu_bad_sessiones IS
  SELECT * 
  FROM   sm_session_v2
  WHERE  (exception_count > 0 
      OR internal_error = 'Y')
  and    NVL(notified_flag,'N') = 'N';


  l_session_list clob;

  L_CRLF   CONSTANT VARCHAR2(2)   := CHR(13) || CHR(10);
  
  BR       CONSTANT VARCHAR2(10)  := '<BR>';
  INDENT   CONSTANT VARCHAR2(100) := '&'||'nbsp;&'||'nbsp;&'||'nbsp;&'||'nbsp;&'||'nbsp;&'||'nbsp;';



   l_body      clob := 'To view the content of this message, please use a HTML enabled mail client.';
   l_body_html clob;
   
   l_mail_id   number;
 
BEGIN
  
  FOR l_bad_session IN cu_bad_sessiones LOOP

    l_session_list := l_session_list 
      || '<LI> session '||l_bad_session.session_id ||' ' ||get_support_feedback_anchor(i_session_id => l_bad_session.session_id);
 
    UPDATE sm_session 
    set    notified_flag = 'Y'
    where  session_id = l_bad_session.session_id;

  END LOOP; 

  l_body_html := 'The following recent SmartLogger sessiones have produced errors :'
     ||BR
     ||BR||l_session_list; 

 
  IF l_session_list IS NOT NULL THEN

    IF f_config_value(i_name => 'SMTP_MAIL') = 'Y' THEN



      smtp_mail(i_email_to       => f_config_value(i_name => 'ADMIN_EMAIL')
               ,i_email_from     => f_config_value(i_name => 'EMAIL_FROM')
               ,i_subject        => f_config_value(i_name => 'TRAWLER_SUBJECT')
               ,i_body_plain     => l_body
               ,i_body_html      => l_body_html
               ,i_mail_host      => 'localhost'  );


    ELSIF f_config_value(i_name => 'APEX_MAIL') = 'Y' THEN


   --Ensure Apex Session Exists
   DECLARE
     l_workspace_id    number := null;
   BEGIN  
     --Create an Apex session
    l_workspace_id := apex_util.find_security_group_id (p_workspace => f_config_value(i_name => 'LOGGER_WORKSPACE'));
    apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
  END;
 
   -- construct the email
   l_mail_id      :=
      apex_mail.send(
         p_to        => f_config_value(i_name => 'ADMIN_EMAIL')
        --,p_cc        => f_config_value(i_name => 'EMAIL_CC')
        --,p_bcc       => f_config_value(i_name => 'EMAIL_BCC')
        ,p_from      => f_config_value(i_name => 'EMAIL_FROM')
        ,p_subj      => f_config_value(i_name => 'TRAWLER_SUBJECT')
        ,p_body      => l_body
        ,p_body_html => l_body_html
      );

   
   END IF;
 

  END IF;

  COMMIT;
 
END;  
 
  
end;
/
show error;
