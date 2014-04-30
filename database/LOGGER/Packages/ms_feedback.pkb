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
PROCEDURE comment( i_message         IN VARCHAR2)
IS
BEGIN NULL; /*
    log_message(
       i_message  => i_message
      ,i_comment  => TRUE
      ,i_raise_app_error => i_raise_app_error
	  ,i_node     => i_node);
 
*/ END comment;

------------------------------------------------------------------------
PROCEDURE info( i_message         IN VARCHAR2)
IS
BEGIN NULL; /*
 
  log_message(
    i_message  => i_message
   ,i_info     => TRUE
   ,i_node     => i_node);
 
*/ END info;

------------------------------------------------------------------------

PROCEDURE warning( i_message         IN VARCHAR2)
IS
BEGIN NULL; /*
 
  log_message(
    i_message  => i_message
   ,i_warning  => TRUE
   ,i_node     => i_node);
 
*/ END warning;

------------------------------------------------------------------------

PROCEDURE fatal( i_message         IN VARCHAR2)
IS
BEGIN NULL; /*
 
  log_message(
    i_message         => i_message
   ,i_fatal           => TRUE
   ,i_raise_app_error => i_raise_app_error
   ,i_node     => i_node);
 
*/ END fatal;

------------------------------------------------------------------------

PROCEDURE oracle_error 
IS
BEGIN NULL; /*

  note ( i_name       => 'SQLERRM'
        ,i_value      => SQLERRM
        ,i_node     => i_node  );
 
*/ END oracle_error;  


------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL
                   			   )
IS

BEGIN NULL; /*

  create_ref ( i_name       => i_name
              ,i_value      => i_value
              ,i_descr      => i_descr
              ,i_is_param   => FALSE
              ,i_node       => i_node);

*/ END note   ;
 
 
------------------------------------------------------------------------

PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN NULL; /*
  create_ref ( i_name      => i_name
              ,i_value     => i_value
              ,i_descr     => i_descr
              ,i_is_param  => TRUE
              ,i_node      => i_node
		      );

*/ END param;
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN NULL; /*

  create_ref ( i_name       => i_name
           ,i_value      => TO_CHAR(ROUND(i_num_value,15))
           ,i_descr      => i_descr
           ,i_is_param   => FALSE
           ,i_node     => i_node);

*/ END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL 				 )
IS

BEGIN NULL; /*
  create_ref ( i_name       => i_name
           ,i_value      => TO_CHAR(ROUND(i_num_value,15))
           ,i_descr      => i_descr
           ,i_is_param   => TRUE
           ,i_node     => i_node);

*/ END param;
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL )
IS

BEGIN NULL; /*
  IF i_date_value = TRUNC(i_date_value) THEN

    create_ref ( i_name       => i_name
                ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY')
                ,i_descr      => i_descr
                ,i_is_param   => FALSE
                ,i_node     => i_node);
  ELSE
    create_ref ( i_name       => i_name
                ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY HH24MI')
                ,i_descr      => i_descr
                ,i_is_param   => FALSE
                ,i_node     => i_node);

  END IF;

*/ END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL 			 )
IS

BEGIN NULL; /*
  IF i_date_value = TRUNC(i_date_value) THEN

    create_ref ( i_name       => i_name
             ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY')
             ,i_descr      => i_descr
             ,i_is_param   => TRUE
             ,i_node     => i_node);
  ELSE
    create_ref ( i_name       => i_name
             ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY HH24MI')
             ,i_descr      => i_descr
             ,i_is_param   => TRUE
             ,i_node     => i_node);

  END IF;

*/ END param;

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note  ( i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  )
IS

BEGIN NULL; /*

  create_ref ( i_name       => i_name
           ,i_value      => f_tf(i_bool_value)
           ,i_descr      => NULL
           ,i_is_param   => FALSE
           ,i_node     => i_node);

*/END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN )
IS

BEGIN NULL; /*
  create_ref ( i_name        => i_name
           ,i_value       => f_tf(i_bool_value)
           ,i_descr       => NULL
           ,i_is_param     => TRUE
           ,i_node     => i_node);

*/ END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_name      IN VARCHAR2 )
IS
BEGIN NULL; /*
  create_ref(i_name       => i_name
         ,i_value      => TO_CHAR(NULL) 
         ,i_descr      => NULL
         ,i_is_param   => FALSE
         ,i_node     => i_node);

*/ END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_name      IN VARCHAR2 ) IS
BEGIN NULL; /*

  note ( i_name       => i_name
        ,i_value      => SQL%ROWCOUNT
        ,i_node       => i_node  );

*/ END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_name      IN VARCHAR2  ) RETURN NUMBER IS
  l_rowcount NUMBER := SQL%ROWCOUNT;
BEGIN NULL; /*

  note ( i_name       => i_name
        ,i_value      => l_rowcount
        ,i_node     => i_node  );
  RETURN l_rowcount;

*/ END f_note_rowcount;
 
------------------------------------------------------------------------
PROCEDURE note_length( i_name  IN VARCHAR2  ) IS
BEGIN NULL; /*

  note ( i_name       => 'LENGTH('||i_name||')'
        ,i_value      => LENGTH(i_name)
        ,i_node     => i_node);

*/ END note_length;


  
end;
/