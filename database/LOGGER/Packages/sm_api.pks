alter session set plsql_ccflags = 'intlog:false';
--alter package sm_api compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package sm_api compile PLSQL_CCFlags = 'intlog:false' reuse settings 

--Ensure no inlining so sm_api can be used
alter session set plsql_optimize_level = 1;

create or replace package sm_api is
------------------------------------------------------------------
-- Program  : sm_api  
-- Name     : SmartLoggerAPI 
-- Author   : P.Burgess
-- Purpose  : API providing interaction with the logger
-- Since the SM_WEAVER can now instrument code for the SmartLogger (ms_logger),
-- ms_logger will contain only commands that the SM_WEAVER produces.
-- Other commands that control the SmartLogger, its modes, perhaps registry changes,
-- and requests for output, will generally be hand-coded into the target application.
-- These commands will form the SmartLoggerAPI.
------------------------------------------------------------------------
-- This package is not to be instrumented by the SM_WEAVER
------------------------------------------------------------------------
 

--------------------------------------------------------------------------------
--f_config_value
--------------------------------------------------------------------------------
function f_config_value(i_name IN VARCHAR2) return VARCHAR2;

------------------------------------------------------------------------ 
-- FUNCTIONS USED IN VIEWS
------------------------------------------------------------------------ 

FUNCTION msg_level_string (i_msg_level    IN NUMBER) RETURN VARCHAR2;
 
 
FUNCTION unit_message_count(i_unit_id      IN NUMBER
                           ,i_msg_level    IN NUMBER) RETURN NUMBER;

 
FUNCTION unit_call_count(i_unit_id IN NUMBER ) RETURN NUMBER;



------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE  set_module_debug(i_module_name IN VARCHAR2 );

------------------------------------------------------------------------

PROCEDURE  set_module_normal(i_module_name IN VARCHAR2 );

------------------------------------------------------------------------

PROCEDURE  set_module_quiet(i_module_name IN VARCHAR2 );
 
PROCEDURE  set_module_disabled(i_module_name IN VARCHAR2 );
 
PROCEDURE  set_unit_debug(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 );

------------------------------------------------------------------------

PROCEDURE  set_unit_normal(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 );

------------------------------------------------------------------------

PROCEDURE  set_unit_quiet(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 );

------------------------------------------------------------------------
PROCEDURE  set_unit_disabled(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2 ); 
 
--------------------------------------------------------------------
--purge_old_sessions
-------------------------------------------------------------------


PROCEDURE purge_old_sessions(i_keep_day_count IN NUMBER DEFAULT null);

--------------------------------------------------------------------
--set_session_keep_flag
-------------------------------------------------------------------
PROCEDURE set_session_keep_flag(i_session_id IN NUMBER
                               ,i_keep_yn    IN VARCHAR2 DEFAULT 'Y');

--------------------------------------------------------------------
--toggle_session_keep_flag
-------------------------------------------------------------------
PROCEDURE toggle_session_keep_flag(i_session_id IN NUMBER );

------------------------------------------------------------------------
-- get_plain_text_session_report
------------------------------------------------------------------------
 
FUNCTION get_plain_text_session_report(i_session_id IN NUMBER) RETURN CLOB;
 
------------------------------------------------------------------------
-- get_html_session_report
------------------------------------------------------------------------
FUNCTION get_html_session_report(i_session_id in integer DEFAULT NULL) RETURN CLOB;
 

------------------------------------------------------------------------
-- get_smartlogger_trace_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_trace_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                                  ,i_port         IN VARCHAR2 DEFAULT NULL
                                  ,i_dir          IN VARCHAR2 DEFAULT NULL
                                  ,i_session_id   IN INTEGER   ) RETURN VARCHAR2;

------------------------------------------------------------------------
-- get_smartlogger_session_URL
------------------------------------------------------------------------
FUNCTION get_smartlogger_session_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                                    ,i_port         IN VARCHAR2 DEFAULT NULL
                                    ,i_dir          IN VARCHAR2 DEFAULT NULL
                                    ,i_session_id   IN INTEGER   ) RETURN VARCHAR2;   

------------------------------------------------------------------------
-- get_trace_URL - first checks session exists
------------------------------------------------------------------------
FUNCTION get_trace_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                      ,i_port         IN VARCHAR2 DEFAULT NULL
                      ,i_dir          IN VARCHAR2 DEFAULT NULL
                      ,i_session_id   IN INTEGER  DEFAULT NULL
                     -- ,i_ext_ref      IN VARCHAR2 DEFAULT NULL 
                       ) RETURN VARCHAR2; 

------------------------------------------------------------------------
-- get_user_feedback_URL
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_URL(i_server_url   IN VARCHAR2 DEFAULT NULL
                              ,i_port         IN VARCHAR2 DEFAULT NULL
                              ,i_dir          IN VARCHAR2 DEFAULT NULL
                              ,i_session_id   IN NUMBER   DEFAULT NULL) RETURN VARCHAR2; 
 
  
------------------------------------------------------------------------
-- get_user_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_anchor(i_server_url   IN VARCHAR2 DEFAULT NULL
                                 ,i_port         IN VARCHAR2 DEFAULT NULL
                                 ,i_dir          IN VARCHAR2 DEFAULT NULL
                                 ,i_session_id   IN NUMBER   DEFAULT NULL ) RETURN VARCHAR2;  
  
------------------------------------------------------------------------
-- get_support_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_support_feedback_anchor(i_server_url   IN VARCHAR2 DEFAULT NULL
                                    ,i_port         IN VARCHAR2 DEFAULT NULL
                                    ,i_dir          IN VARCHAR2 DEFAULT NULL
                                    ,i_session_id   IN NUMBER   DEFAULT NULL) RETURN VARCHAR2;

  
------------------------------------------------------------------------
-- trawl_log_for_errors
------------------------------------------------------------------------
PROCEDURE trawl_log_for_errors;

end;
/