create or replace package sm_jotter is
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
 
------------------------------------------------------------------------
-- MESSAGE ROUTINES (Public)
------------------------------------------------------------------------
 
------------------------------------------------------------------------ 
PROCEDURE comment( i_message         IN VARCHAR2 DEFAULT NULL);

------------------------------------------------------------------------
PROCEDURE info( i_message         IN VARCHAR2 DEFAULT NULL);

------------------------------------------------------------------------
PROCEDURE warning( i_message         IN VARCHAR2 DEFAULT NULL);
------------------------------------------------------------------------

 
------------------------------------------------------------------------
PROCEDURE fatal( i_message         IN VARCHAR2 DEFAULT NULL);

------------------------------------------------------------------------
PROCEDURE oracle_error( i_message         IN VARCHAR2 DEFAULT NULL);
------------------------------------------------------------------------
 
------------------------------------------------------------------------
-- warn_error  
------------------------------------------------------------------------

PROCEDURE warn_error( i_message         IN VARCHAR2 DEFAULT NULL  );

------------------------------------------------------------------------
-- note_error  
------------------------------------------------------------------------
PROCEDURE note_error( i_message         IN VARCHAR2 DEFAULT NULL  );

------------------------------------------------------------------------
-- PARAMS AND NOTES (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note(i_name      IN VARCHAR2
              ,i_value     IN VARCHAR2
              ,i_descr     IN VARCHAR2 DEFAULT NULL  );
 
------------------------------------------------------------------------

PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2  );

--overloaded name, value | [id, descr] FOR CLOB
PROCEDURE note_clob( i_name      IN VARCHAR2
                    ,i_value     IN CLOB ) ;
 
 
------------------------------------------------------------------------

PROCEDURE param_clob( i_name      IN VARCHAR2
                     ,i_value     IN CLOB  );


------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER );

------------------------------------------------------------------------ 
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER    );

------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_name       IN VARCHAR2
                   ,i_date_value IN DATE );
 
------------------------------------------------------------------------
PROCEDURE param ( i_name       IN VARCHAR2
                 ,i_date_value IN DATE   );

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN );

------------------------------------------------------------------------
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  );
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_name      IN VARCHAR2);

------------------------------------------------------------------------
PROCEDURE note_rowcount( i_name      IN VARCHAR2 );

------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_name      IN VARCHAR2 ) RETURN NUMBER;

------------------------------------------------------------------------

PROCEDURE note_sqlerrm;

------------------------------------------------------------------------
PROCEDURE note_length( i_name  IN VARCHAR2 
                      ,i_value IN CLOB        );

------------------------------------------------------------------------
FUNCTION get_jotter_id return number;

------------------------------------------------------------------------
FUNCTION get_jotter_url return varchar2;

PROCEDURE on_demand(i_debug       in boolean  default false
                   ,i_normal      in boolean  default false
                   ,i_quiet       in boolean  default false
                   ,i_disabled    in boolean  default false
                   ,i_msg_mode    in integer  default null );
 
end;
/