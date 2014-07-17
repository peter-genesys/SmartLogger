alter session set plsql_ccflags = 'intlog:false';
--alter package ms_api compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package ms_api compile PLSQL_CCFlags = 'intlog:false' reuse settings 

--Ensure no inlining so ms_api can be used
alter session set plsql_optimize_level = 1;

create or replace package body ms_api is
------------------------------------------------------------------
-- Program  : ms_api  
-- Name     : SmartLoggerAPI 
-- Author   : P.Burgess
-- Purpose  : API providing interaction with the logger
-- Since the AOP_PROCESSOR can now instrument code for the SmartLogger (ms_logger),
-- ms_logger will contain only commands that the AOP_PROCESSOR produces.
-- Other commands that control the SmartLogger, its modes, perhaps registry changes,
-- and requests for output, will generally be hand-coded into the target application.
-- These commands will form the SmartLoggerAPI.

------------------------------------------------------------------------
-- This package is not to be instrumented by the AOP_PROCESSOR
-- @AOP_NEVER 
------------------------------------------------------------------------


G_SMARTLOGGER_APP_NO          CONSTANT NUMBER := 104;
G_SMARTLOGGER_PROCESS_PAGE_NO CONSTANT NUMBER := 8;
G_SMARTLOGGER_TRACE_PAGE_NO   CONSTANT NUMBER := 24;
 

------------------------------------------------------------------------ 
-- FUNCTIONS USED IN VIEWS
------------------------------------------------------------------------ 
 
FUNCTION msg_level_string (i_msg_level    IN NUMBER) RETURN VARCHAR2
IS
  v_result VARCHAR2(100) := NULL;
BEGIN
    IF i_msg_level = ms_logger.G_MSG_LEVEL_INFO THEN
      v_result  := 'Info ?';
    ELSIF i_msg_level =  ms_logger.G_MSG_LEVEL_COMMENT THEN
      v_result  := 'Comment';
    ELSIF i_msg_level =  ms_logger.G_MSG_LEVEL_WARNING THEN
      v_result  := 'Warning !';
    ELSIF i_msg_level =  ms_logger.G_MSG_LEVEL_FATAL THEN
      v_result  := 'Fatal !';
    ELSIF i_msg_level =  ms_logger.G_MSG_LEVEL_ORACLE THEN
      v_result  := 'Oracle Error';
    ELSIF i_msg_level =  ms_logger.G_MSG_LEVEL_INTERNAL THEN
      v_result  := 'Internal Error';
    END IF;

  RETURN v_result;
END msg_level_string;




 
FUNCTION unit_message_count(i_unit_id      IN NUMBER
                           ,i_msg_level    IN NUMBER) RETURN NUMBER IS
                           
  CURSOR cu_message_count(c_unit_id      NUMBER                         
                         ,c_msg_level    NUMBER) IS
  SELECT count(*)
  FROM   ms_traversal_message_vw
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

 
FUNCTION unit_traversal_count(i_unit_id IN NUMBER ) RETURN NUMBER IS
                           
  CURSOR cu_traversal_count(c_unit_id NUMBER ) IS
  SELECT count(*)
  FROM  ms_traversal
  WHERE unit_id =  c_unit_id; 
  
  l_result NUMBER;
  
BEGIN
  OPEN cu_traversal_count(c_unit_id => i_unit_id );
  FETCH cu_traversal_count INTO l_result;
  CLOSE cu_traversal_count;
  
  RETURN l_result;
  
END;  


------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE  set_module_debug(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => ms_logger.G_MSG_MODE_DEBUG);
END; 

------------------------------------------------------------------------

PROCEDURE  set_module_normal(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
 ms_logger. set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => ms_logger.G_MSG_MODE_NORMAL);
END; 

------------------------------------------------------------------------

PROCEDURE  set_module_quiet(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => ms_logger.G_MSG_MODE_QUIET);
END; 
 
PROCEDURE  set_module_disabled(i_module_name IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_module_msg_mode(i_module_name  => i_module_name
                               ,i_msg_mode    => ms_logger.G_MSG_MODE_DISABLED);
END; 

------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE  set_unit_debug(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode     => ms_logger.G_MSG_MODE_DEBUG);
END; 

------------------------------------------------------------------------

PROCEDURE  set_unit_normal(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode     => ms_logger.G_MSG_MODE_NORMAL);
END; 

------------------------------------------------------------------------

PROCEDURE  set_unit_quiet(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode    => ms_logger.G_MSG_MODE_QUIET);
END; 
 
PROCEDURE  set_unit_disabled(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  ms_logger.set_unit_msg_mode(i_module_name  => i_module_name
                             ,i_unit_name    => i_unit_name  
                             ,i_msg_mode     => ms_logger.G_MSG_MODE_DISABLED);
END; 


--------------------------------------------------------------------
--purge_old_processes
-------------------------------------------------------------------


PROCEDURE purge_old_processes(i_keep_day_count IN NUMBER DEFAULT 1) IS

 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

  delete from ms_process        where created_date < (SYSDATE - i_keep_day_count);
 
  COMMIT;
  
 END;
 
  
 
------------------------------------------------------------------------
-- get_plain_text_process_report
------------------------------------------------------------------------
 
FUNCTION get_plain_text_process_report RETURN CLOB IS
  l_report CLOB;
  l_process_id INTEGER := ms_logger.f_process_id;
BEGIN
 
	FOR l_line IN (SELECT lpad('+ ',(level-1)*2,'+ ')
                         ||module_name||'.'
                         ||unit_name
                         ||chr(10)||(SELECT listagg('**'||name||':'||value,chr(10)) within group (order by traversal_id) from ms_message where traversal_id = t.traversal_id and msg_type in ('PARAM','NOTE'))
                         ||chr(10)||(SELECT listagg('--'||message,chr(10)) within group (order by message_id) from ms_message where traversal_id = t.traversal_id and msg_type not in ('PARAM','NOTE')) as text
                   FROM ms_unit_traversal_vw t
                   WHERE process_id = l_process_id
                   START WITH parent_traversal_id IS NULL
                   CONNECT BY PRIOR traversal_id = parent_traversal_id
                   ORDER SIBLINGS BY traversal_id) LOOP
	
	 
	  l_report := l_report ||chr(10)||l_line.text;

	END LOOP;  
 
  RETURN l_report;

END;
 
------------------------------------------------------------------------
-- get_html_process_report
------------------------------------------------------------------------
FUNCTION get_html_process_report RETURN CLOB IS

  l_node ms_logger.node_typ := ms_logger.new_func($$plsql_unit ,'get_html_process_report');
  l_report CLOB;
  
  G_COLOUR_PROG_UNIT  VARCHAR2(10) := '#6699FF';
  G_COLOUR_NOTE       VARCHAR2(10) := '#FFFF99';
  G_COLOUR_PARAM      VARCHAR2(10) := '#FF9999';
  G_COLOUR_COMMENT    VARCHAR2(10) := '#99FF99';
  G_COLOUR_INFO       VARCHAR2(10) := '#CCFF99';
  G_COLOUR_WARNING    VARCHAR2(10) := '#FF6600';
  G_COLOUR_ERROR      VARCHAR2(10) := '#FF0000';
  
  l_colour            VARCHAR2(10);  
  
  l_process_id INTEGER := ms_logger.f_process_id;
  
  PROCEDURE write(i_line IN VARCHAR2 DEFAULT NULL) IS

    l_node ms_logger.node_typ := ms_logger.new_proc($$plsql_unit ,'write');
 
  begin --write
    ms_logger.param(l_node,'i_line',i_line);

 BEGIN
    l_report := l_report||chr(10)||i_line;
  END;
  exception
    when others then
      ms_logger.warn_error(l_node);
      raise;
  end; --write

  
  
begin --get_html_process_report

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
         from ms_unit_traversal_vw ut
		 WHERE process_id = l_process_id 
         start with ut.PARENT_TRAVERSAL_ID IS NULL
         connect by prior ut.TRAVERSAL_ID = ut.PARENT_TRAVERSAL_ID
         order siblings by ut.TRAVERSAL_ID) a
         ,ms_message_vw m
       where m.traversal_id = a.traversal_id
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
    ms_logger.warn_error(l_node);
    raise;
end; --get_html_process_report




------------------------------------------------------------------------
-- get_apex_page_URL
------------------------------------------------------------------------
FUNCTION get_apex_page_URL(i_server_url  IN VARCHAR2
                          ,i_port        IN VARCHAR2
                          ,i_app_no      IN VARCHAR2
                          ,i_page_no     IN VARCHAR2
                          ,i_request     IN VARCHAR2
                          ,i_clear_cache IN VARCHAR2
                          ,i_param_names IN VARCHAR2
                          ,i_param_values IN VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  RETURN i_server_url||':'||i_port
      ||'/apex/f?p='||i_app_no||':'||i_page_no||'::'
      ||i_request||'::'
      ||i_clear_cache||':'
      ||i_param_names||':'
      ||i_param_values;
END;  

 

------------------------------------------------------------------------
-- get_smartlogger_trace_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_report_URL(i_server_url   IN VARCHAR2
                                   ,i_port         IN VARCHAR2
                                   ,i_page_no      IN VARCHAR2
                                   ,i_process_id   IN INTEGER   ) RETURN VARCHAR2 IS

  l_request     VARCHAR2(30);
 
BEGIN

   
  
  IF ms_logger.f_process_exceptions(i_process_id => i_process_id) THEN
    --Exceptions exist so lets show them.
    l_request := 'IR_REPORT_EXCEPTIONS';
  ELSE
    --No exceptions lets show normal messages.
    l_request := 'IR_REPORT_MESSAGES';
  END IF;
 
  RETURN get_apex_page_URL(i_server_url  => i_server_url
                          ,i_port        => i_port
                          ,i_app_no      => G_SMARTLOGGER_APP_NO
                          ,i_page_no     => i_page_no
                          ,i_request     => l_request
                          ,i_clear_cache => 'RIR,RP,'||i_page_no
                          ,i_param_names => 'P'||i_page_no||'_PROCESS_ID'
                          ,i_param_values => i_process_id);

END; 
 
------------------------------------------------------------------------
-- get_smartlogger_trace_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_trace_URL(i_server_url   IN VARCHAR2
                                  ,i_port         IN VARCHAR2
                                  ,i_process_id   IN INTEGER   ) RETURN VARCHAR2 IS
 
BEGIN

  RETURN get_smartlogger_report_URL(i_server_url  => i_server_url
                                   ,i_port        => i_port
                                   ,i_page_no     => G_SMARTLOGGER_TRACE_PAGE_NO
                                   ,i_process_id  => i_process_id);
 
END; 


------------------------------------------------------------------------
-- get_smartlogger_process_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_process_URL(i_server_url   IN VARCHAR2
                                    ,i_port         IN VARCHAR2
                                    ,i_process_id   IN INTEGER   ) RETURN VARCHAR2 IS
 
BEGIN

  RETURN get_smartlogger_report_URL(i_server_url  => i_server_url
                                   ,i_port        => i_port
                                   ,i_page_no     => G_SMARTLOGGER_PROCESS_PAGE_NO
                                   ,i_process_id  => i_process_id);
 
END; 


 
 
------------------------------------------------------------------------
-- get_trace_URL
------------------------------------------------------------------------
FUNCTION get_trace_URL(i_server_url IN VARCHAR2
                      ,i_port       IN VARCHAR2
                      ,i_process_id IN INTEGER  DEFAULT NULL
                      ,i_ext_ref    IN VARCHAR2 DEFAULT NULL  ) RETURN VARCHAR2 IS
 
  l_process_id INTEGER;
  l_result     VARCHAR2(2000);
  
 
BEGIN 

  l_process_id := ms_logger.f_process_id(i_process_id => i_process_id
                                        ,i_ext_ref    => i_ext_ref );  
 
  IF ms_logger.f_process_traced(i_process_id => l_process_id) THEN
    l_result := get_smartlogger_trace_URL(i_server_url  => i_server_url
                                         ,i_port        => i_port      
                                         ,i_process_id  => l_process_id);
 
  END IF;
  
  RETURN l_result;
 
END;
 
 
------------------------------------------------------------------------
-- get_user_feedback_URL
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_URL(i_server_url IN VARCHAR2
                              ,i_port       IN VARCHAR2) RETURN VARCHAR2 IS
  l_process_id INTEGER;
BEGIN

  l_process_id := ms_logger.f_process_id;

  IF ms_logger.f_process_traced(i_process_id => l_process_id) THEN
  
    RETURN 'Click to view Trace:  '
            ||get_smartlogger_trace_URL(i_server_url  => i_server_url
                                       ,i_port        => i_port      
                                       ,i_process_id  => l_process_id);

  ELSE
    RETURN NULL;
  END IF;
 
END;
 
------------------------------------------------------------------------
-- get_user_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_anchor(i_server_url IN VARCHAR2
                                 ,i_port       IN VARCHAR2)  RETURN VARCHAR2 IS
  l_process_id INTEGER;
BEGIN

  l_process_id := ms_logger.f_process_id;

  IF ms_logger.f_process_traced(i_process_id => l_process_id) THEN
  
    return htf.anchor(curl        => get_smartlogger_trace_URL(i_server_url  => i_server_url
                                                              ,i_port        => i_port      
                                                              ,i_process_id  => l_process_id)
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
 
FUNCTION get_support_feedback_anchor(i_server_url IN VARCHAR2
                                    ,i_port       IN VARCHAR2) RETURN VARCHAR2 IS
 --'http://soraempl002.au.fcl.internal:8080'
  l_process_id INTEGER;
BEGIN

  l_process_id := ms_logger.f_process_id;

  IF ms_logger.f_process_traced(i_process_id => l_process_id) THEN
  
    return htf.anchor(curl        => get_smartlogger_process_URL(i_server_url  => i_server_url
                                                                ,i_port        => i_port      
                                                                ,i_process_id  => l_process_id)
                     ,ctext       => 'Click to view Debugging'
                     ,cname       => NULL
                     ,cattributes => NULL);
  ELSE
    RETURN NULL;
  END IF;
  
 
END; 
 
 
 
------------------------------------------------------------------------
-- mail
------------------------------------------------------------------------
 
PROCEDURE mail(i_email_to        IN VARCHAR2
              ,i_subject         IN VARCHAR2 
			        ,i_body_plain      IN CLOB     DEFAULT NULL
			        ,i_body_html       IN CLOB     DEFAULT NULL
              ,i_email_from      IN VARCHAR2 DEFAULT NULL
			        ,i_email_reply_to  IN VARCHAR2 DEFAULT NULL
			        ,i_mail_host       IN VARCHAR2 DEFAULT NULL ) IS
						  
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
 
END mail;
 
 
  
end;
/
show error;
