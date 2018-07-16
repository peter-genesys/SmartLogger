alter session set plsql_ccflags = 'intlog:false';
--alter package ms_feedback compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package ms_feedback compile PLSQL_CCFlags = 'intlog:false' reuse settings 

create or replace package body ms_feedback is
------------------------------------------------------------------
-- Program  : ms_feedback  
-- Name     : Simple feedback from PL/SQL
-- Author   : P.Burgess
-- Purpose  : This package works in partnership for ms_logger.
--            It provides a simple syntax to allow developers to create feedback 
--            about the activities of PLSQL.
--            When processed by the AOP_PROCESSOR, this syntax is translated to 
--            the more complex ms_logger syntax, used to detailed debugging.
------------------------------------------------------------------------
-- This package is not to be instrumented by the AOP_PROCESSOR
-- @AOP_NEVER 
l_node ms_logger.node_typ := ms_logger.new_proc('ms_feedback','package');
  
------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

--NEED TO ADD IT HERE - THE CODE THAT WILL DO THE SIMPLE VERSION OF 
--MESSAGING AND REFERENCES.
--
--SHOULD IT HAVE A HTML VERSION?  EG FOR SIMPLE FEEBACK IN APEX.
--
--WHAT SHOULD IT LOOK LIKE FOR FORMS OR REPORTS.




------------------------------------------------------------------------ 
PROCEDURE comment( i_message         IN VARCHAR2 DEFAULT NULL)
IS
BEGIN  
   ms_logger.comment(l_node,i_message);
END comment;

------------------------------------------------------------------------
PROCEDURE info( i_message         IN VARCHAR2 DEFAULT NULL)
IS
BEGIN  
  ms_logger.info(l_node,i_message);
END info;


------------------------------------------------------------------------
PROCEDURE warning( i_message         IN VARCHAR2 DEFAULT NULL)
IS
BEGIN  
  ms_logger.warning(l_node,i_message);
END warning;
------------------------------------------------------------------------

 
------------------------------------------------------------------------
PROCEDURE fatal( i_message         IN VARCHAR2 DEFAULT NULL)
IS
BEGIN  
  ms_logger.fatal(l_node,i_message);
END fatal;

------------------------------------------------------------------------
PROCEDURE oracle_error( i_message         IN VARCHAR2 DEFAULT NULL)
IS
BEGIN  
  ms_logger.oracle_error(l_node,i_message);
END oracle_error;
------------------------------------------------------------------------

 
/* 
------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL
                   			   )
IS

BEGIN NULL;  

 
  END note   ;
 
 
------------------------------------------------------------------------

PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN NULL;  
 

  END param;
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN NULL;  END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL 				 )
IS

BEGIN NULL;  END param;
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL )
IS

BEGIN NULL;   END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL 			 )
IS

BEGIN NULL;   END param;

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note  ( i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  )
IS

BEGIN NULL; END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN )
IS

BEGIN NULL;   END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_name      IN VARCHAR2 )
IS
BEGIN NULL;   END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_name      IN VARCHAR2 ) IS
BEGIN NULL; END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_name      IN VARCHAR2  ) RETURN NUMBER IS
  l_rowcount NUMBER := SQL%ROWCOUNT;
BEGIN NULL;   END f_note_rowcount;
 
------------------------------------------------------------------------
PROCEDURE note_length( i_name  IN VARCHAR2  ) IS
BEGIN NULL;  END note_length;

*/

  
end;
/