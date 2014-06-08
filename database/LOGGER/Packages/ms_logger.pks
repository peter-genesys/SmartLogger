create or replace package ms_logger is
 
------------------------------------------------------------------------
-- Node Typ API functions (Public)
------------------------------------------------------------------------

 
TYPE message_list     IS TABLE OF ms_message%ROWTYPE INDEX BY BINARY_INTEGER;  
  
TYPE node_typ IS RECORD
  (traversal        ms_traversal%ROWTYPE
  ,module           ms_module%ROWTYPE
  ,unit             ms_unit%ROWTYPE
  ,open_process     ms_unit.open_process%TYPE
  ,node_level       BINARY_INTEGER
  ,logged           BOOLEAN
  ,unlogged_messages message_list
  ,internal_error   BOOLEAN DEFAULT NULL --start undefined, set to false by an ENTER routine.
  ,call_stack_level BINARY_INTEGER
  ,call_stack_hist  VARCHAR2(32000));  

  
G_MSG_LEVEL_IGNORE      CONSTANT NUMBER(2) := 0;
G_MSG_LEVEL_COMMENT     CONSTANT NUMBER(2) := 1;
G_MSG_LEVEL_INFO        CONSTANT NUMBER(2) := 2;
G_MSG_LEVEL_WARNING     CONSTANT NUMBER(2) := 3;
G_MSG_LEVEL_FATAL       CONSTANT NUMBER(2) := 4;
G_MSG_LEVEL_ORACLE      CONSTANT NUMBER(2) := 5;
G_MSG_LEVEL_INTERNAL    CONSTANT NUMBER(2) := 6;
 
G_MSG_MODE_DEBUG        CONSTANT NUMBER(2) := G_MSG_LEVEL_COMMENT; 
G_MSG_MODE_NORMAL       CONSTANT NUMBER(2) := G_MSG_LEVEL_INFO;
G_MSG_MODE_QUIET        CONSTANT NUMBER(2) := G_MSG_LEVEL_FATAL;
G_MSG_MODE_DISABLED     CONSTANT NUMBER(2) := 99; 
G_MSG_MODE_DEFAULT      CONSTANT NUMBER(2) := NULL;

G_MSG_TYPE_PARAM        CONSTANT VARCHAR2(10) := 'PARAM';
G_MSG_TYPE_NOTE         CONSTANT VARCHAR2(10) := 'NOTE';
G_MSG_TYPE_MESSAGE      CONSTANT VARCHAR2(10) := 'MESSAGE';

 
G_OPEN_PROCESS_ALWAYS     CONSTANT ms_unit.open_process%TYPE := 'Y'; 
G_OPEN_PROCESS_IF_CLOSED  CONSTANT ms_unit.open_process%TYPE := 'C';
G_OPEN_PROCESS_NEVER      CONSTANT ms_unit.open_process%TYPE := 'N';
G_OPEN_PROCESS_DEFAULT    CONSTANT ms_unit.open_process%TYPE := NULL;

--FUNCTION new_process(i_module_name IN VARCHAR2
--                    ,i_unit_name   IN VARCHAR2
--                    ,i_ext_ref     IN VARCHAR2 DEFAULT NULL
--                    ,i_comments    IN VARCHAR2 DEFAULT NULL       ) RETURN ms_logger.node_typ;
 
 
FUNCTION new_process(i_process_name IN VARCHAR2 DEFAULT NULL
                    ,i_process_type IN VARCHAR2 DEFAULT NULL
                    ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                    ,i_module_name  IN VARCHAR2 DEFAULT NULL
                    ,i_unit_name    IN VARCHAR2 DEFAULT NULL
          --,i_msg_mode     IN INTEGER  DEFAULT G_MSG_MODE_NORMAL
                    ,i_comments     IN VARCHAR2 DEFAULT NULL       ) RETURN INTEGER; 
 
 
FUNCTION new_pkg(i_module_name IN VARCHAR2
                ,i_unit_name   IN VARCHAR2 DEFAULT 'Initialisation' ) RETURN ms_logger.node_typ;
 
 
FUNCTION new_proc(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ;


FUNCTION new_func(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ;
				 
FUNCTION new_trig(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ;		 

FUNCTION new_script(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ;  
				   
 
 

------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
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
 
------------------------------------------------------------------------
-- Internal debugging routines (public)
------------------------------------------------------------------------
 
PROCEDURE set_internal_debug;

PROCEDURE reset_internal_debug;
 
 
--------------------------------------------------------------------
--purge_old_processes
-------------------------------------------------------------------


PROCEDURE purge_old_processes(i_keep_day_count IN NUMBER DEFAULT 1);
 
 
----------------------------------------------------------------------
-- EXPOSED FOR THE MS_API
----------------------------------------------------------------------

----------------------------------------------------------------------
-- f_process_traced
----------------------------------------------------------------------
FUNCTION f_process_traced(i_process_id IN INTEGER) RETURN BOOLEAN;

FUNCTION f_process_id(i_process_id IN INTEGER  DEFAULT NULL
                     ,i_ext_ref    IN VARCHAR2 DEFAULT NULL) RETURN INTEGER; 

FUNCTION f_process_is_closed RETURN BOOLEAN;

FUNCTION f_process_is_open RETURN BOOLEAN;


------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

------------------------------------------------------------------------
-- comment 
------------------------------------------------------------------------
PROCEDURE comment( i_node            IN ms_logger.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
-- info 
------------------------------------------------------------------------
PROCEDURE info( i_node            IN ms_logger.node_typ 
               ,i_message         IN VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
-- warning  
------------------------------------------------------------------------

PROCEDURE warning( i_node         IN ms_logger.node_typ 
                  ,i_message      IN VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
-- fatal  
------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN     ms_logger.node_typ 
                ,i_message         IN     VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
-- oracle_error 
------------------------------------------------------------------------

PROCEDURE oracle_error( i_node            IN ms_logger.node_typ 
                       ,i_message         IN VARCHAR2 DEFAULT NULL  );
------------------------------------------------------------------------
-- warn_error  
------------------------------------------------------------------------

PROCEDURE warn_error( i_node            IN ms_logger.node_typ 
                     ,i_message         IN VARCHAR2 DEFAULT NULL  );

------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ   
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2 );

------------------------------------------------------------------------

PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2  );

------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER );

------------------------------------------------------------------------ 
PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER    );
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
                   ,i_name       IN VARCHAR2
                   ,i_date_value IN DATE );
------------------------------------------------------------------------
PROCEDURE param ( i_node       IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_date_value IN DATE   );

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  );
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN );
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2 );
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN ms_logger.node_typ 
                        ,i_name      IN VARCHAR2 );
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN ms_logger.node_typ 
                         ,i_name      IN VARCHAR2  ) RETURN NUMBER;

------------------------------------------------------------------------

PROCEDURE note_error(i_node      IN ms_logger.node_typ );
------------------------------------------------------------------------
PROCEDURE note_length( i_node  IN ms_logger.node_typ 
                      ,i_name  IN VARCHAR2 
                      ,i_value IN CLOB        ) ;
 

FUNCTION msg_level_string (i_msg_level    IN NUMBER) RETURN VARCHAR2;

END;
/