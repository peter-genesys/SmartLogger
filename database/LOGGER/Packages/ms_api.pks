alter session set plsql_ccflags = 'intlog:false';
--alter package ms_api compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package ms_api compile PLSQL_CCFlags = 'intlog:false' reuse settings 

--Ensure no inlining so ms_api can be used
alter session set plsql_optimize_level = 1;

create or replace package ms_api is
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
------------------------------------------------------------------------
 
 
------------------------------------------------------------------------
-- get_plain_text_process_report
------------------------------------------------------------------------
 
FUNCTION get_plain_text_process_report RETURN CLOB;
 
------------------------------------------------------------------------
-- get_html_process_report
------------------------------------------------------------------------
FUNCTION get_html_process_report RETURN CLOB;
 
 
------------------------------------------------------------------------
-- get_user_feedback_URL
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_URL RETURN VARCHAR2; 
 
  
------------------------------------------------------------------------
-- get_user_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_user_feedback_anchor RETURN VARCHAR2;  
  
------------------------------------------------------------------------
-- get_support_feedback_anchor
------------------------------------------------------------------------
 
FUNCTION get_support_feedback_anchor RETURN VARCHAR2;

  
  
end;
/