alter session set plsql_ccflags = 'intlog:false';
--alter package sm_jotter compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package sm_jotter compile PLSQL_CCFlags = 'intlog:false' reuse settings 

create or replace package body sm_jotter is
------------------------------------------------------------------
-- Program  : sm_jotter  
-- Name     : Simple overloaded package for ms_logger
-- Author   : P.Burgess
-- Purpose  : This package works in partnership for ms_logger.
--            It provides a simple syntax to allow developers to use the logger
--            with less investment of time when manually logging.
--            Additionally, when processed by the AOP_PROCESSOR, 
--            this syntax is translated to the equivalent ms_logger syntax, 
--            used for detailed debugging.
------------------------------------------------------------------------
-- This package is not to be instrumented by the AOP_PROCESSOR
-- @AOP_NEVER 
g_node ms_logger.node_typ := ms_logger.new_proc('sm_jotter','package');
  
------------------------------------------------------------------------
-- MESSAGE ROUTINES (Public)
------------------------------------------------------------------------
 
------------------------------------------------------------------------ 
PROCEDURE comment( i_message         IN VARCHAR2 DEFAULT NULL) IS
BEGIN  
   ms_logger.comment(g_node,i_message);
END comment;

------------------------------------------------------------------------
PROCEDURE info( i_message         IN VARCHAR2 DEFAULT NULL) IS
BEGIN  
  ms_logger.info(g_node,i_message);
END info;


------------------------------------------------------------------------
PROCEDURE warning( i_message         IN VARCHAR2 DEFAULT NULL) IS
BEGIN  
  ms_logger.warning(g_node,i_message);
END warning;
------------------------------------------------------------------------

 
------------------------------------------------------------------------
PROCEDURE fatal( i_message         IN VARCHAR2 DEFAULT NULL) IS
BEGIN  
  ms_logger.fatal(g_node,i_message);
END fatal;

------------------------------------------------------------------------
PROCEDURE oracle_error( i_message         IN VARCHAR2 DEFAULT NULL) IS
BEGIN  
  ms_logger.oracle_error(g_node,i_message);
END oracle_error;
------------------------------------------------------------------------
 
------------------------------------------------------------------------
-- warn_error  
------------------------------------------------------------------------

PROCEDURE warn_error( i_message         IN VARCHAR2 DEFAULT NULL  ) IS
BEGIN  
  ms_logger.warn_error(g_node,i_message);
END warn_error;

------------------------------------------------------------------------
-- note_error  
------------------------------------------------------------------------
PROCEDURE note_error( i_message         IN VARCHAR2 DEFAULT NULL  )  is
BEGIN  
  ms_logger.note_error(g_node,i_message);
END note_error;

------------------------------------------------------------------------
-- PARAMS AND NOTES (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note(i_name      IN VARCHAR2
              ,i_value     IN VARCHAR2
              ,i_descr     IN VARCHAR2 DEFAULT NULL  ) IS
BEGIN  
  ms_logger.note(i_node     => g_node 
                ,i_name     => i_name 
                ,i_value    => i_value
                ,i_descr    => i_descr);
END note;

 
------------------------------------------------------------------------

PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2  ) IS
BEGIN  
  ms_logger.param(i_node     => g_node 
                 ,i_name     => i_name 
                 ,i_value    => i_value);
END param;


--overloaded name, value | [id, descr] FOR CLOB
PROCEDURE note_clob( i_name      IN VARCHAR2
                    ,i_value     IN CLOB ) IS
BEGIN  
  ms_logger.note_clob(i_node     => g_node 
                     ,i_name     => i_name 
                     ,i_value    => i_value);
END note_clob;
 
 
------------------------------------------------------------------------

PROCEDURE param_clob( i_name      IN VARCHAR2
                     ,i_value     IN CLOB  ) IS
BEGIN  

  ms_logger.param_clob(i_node     => g_node 
                      ,i_name     => i_name 
                      ,i_value    => i_value);
END param_clob;


------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER ) IS
BEGIN  
  ms_logger.note(i_node      => g_node 
                ,i_name      => i_name 
                ,i_num_value => i_num_value);
END note;

------------------------------------------------------------------------ 
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER    ) IS
BEGIN  
  ms_logger.param(i_node       => g_node 
                 ,i_name       => i_name 
                 ,i_num_value  => i_num_value);
END param;


------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_name       IN VARCHAR2
                   ,i_date_value IN DATE ) IS
BEGIN  
  ms_logger.note(i_node      => g_node 
                ,i_name      => i_name 
                ,i_date_value => i_date_value);
END note;
 
------------------------------------------------------------------------
PROCEDURE param ( i_name       IN VARCHAR2
                 ,i_date_value IN DATE   ) IS
BEGIN  
  ms_logger.param(i_node      => g_node 
                ,i_name      => i_name 
                ,i_date_value => i_date_value);
END param;

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN ) IS
BEGIN  
  ms_logger.note(i_node      => g_node 
                ,i_name      => i_name 
                ,i_bool_value => i_bool_value);
END note;
------------------------------------------------------------------------
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  ) IS
BEGIN  
  ms_logger.param(i_node      => g_node 
                 ,i_name      => i_name 
                 ,i_bool_value => i_bool_value);
END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_name      IN VARCHAR2) is
BEGIN  
  ms_logger.note(i_node      => g_node 
                ,i_name      => i_name );
END note;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_name      IN VARCHAR2 ) is
BEGIN  
  ms_logger.note_rowcount(i_node      => g_node 
                         ,i_name      => i_name );
END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_name      IN VARCHAR2 ) RETURN NUMBER IS
BEGIN  
  return ms_logger.f_note_rowcount(i_node      => g_node 
                                  ,i_name      => i_name );
END f_note_rowcount;

------------------------------------------------------------------------

PROCEDURE note_sqlerrm is
BEGIN  
  ms_logger.note_sqlerrm(i_node      => g_node);
END note_sqlerrm;

------------------------------------------------------------------------
PROCEDURE note_length( i_name  IN VARCHAR2 
                      ,i_value IN CLOB        ) IS
BEGIN  
  ms_logger.note_length(i_node     => g_node 
                       ,i_name     => i_name 
                       ,i_value    => i_value);
END note_length;

 
------------------------------------------------------------------------ 
FUNCTION get_jotter_id return number is
BEGIN
  return g_node.traversal.process_id;
end;

------------------------------------------------------------------------
FUNCTION get_jotter_url return varchar2 is
BEGIN
  return ms_api.get_smartlogger_trace_URL(i_process_id  => get_jotter_id);
end;
 
end;
/