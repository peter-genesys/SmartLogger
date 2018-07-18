create or replace package ms_logger is
 
------------------------------------------------------------------------
-- Node Typ API functions (Public)
------------------------------------------------------------------------

 
TYPE message_list     IS TABLE OF ms_message%ROWTYPE INDEX BY BINARY_INTEGER;  
  
TYPE node_typ IS RECORD
  (traversal        ms_traversal%ROWTYPE
  ,module           ms_module%ROWTYPE
  ,unit             ms_unit%ROWTYPE
  ,auto_wake        ms_unit.auto_wake%TYPE
  ,node_level       BINARY_INTEGER
  ,logged           BOOLEAN
  ,unlogged_messages message_list
 -- ,unlogged_size    integer --total size of all unlogged_messages (in chars)  
 -- ,internal_error   BOOLEAN DEFAULT NULL --start undefined, set to false by an ENTER routine.
  ,call_stack_level BINARY_INTEGER
  ,call_stack_hist  VARCHAR2(2000));  --limit of 2000 chars returned by dbms_utility.format_call_stack in 11g

  
G_MSG_LEVEL_IGNORE      CONSTANT NUMBER(2) := 0; --NOT USED
G_MSG_LEVEL_COMMENT     CONSTANT NUMBER(2) := 1;
G_MSG_LEVEL_INFO        CONSTANT NUMBER(2) := 2;
G_MSG_LEVEL_WARNING     CONSTANT NUMBER(2) := 3;
G_MSG_LEVEL_FATAL       CONSTANT NUMBER(2) := 4;
G_MSG_LEVEL_ORACLE      CONSTANT NUMBER(2) := 5;
G_MSG_LEVEL_INTERNAL    CONSTANT NUMBER(2) := 6;
 
G_MSG_MODE_DEBUG        CONSTANT NUMBER(2) := G_MSG_LEVEL_COMMENT; --1
G_MSG_MODE_NORMAL       CONSTANT NUMBER(2) := G_MSG_LEVEL_INFO;    --2
G_MSG_MODE_QUIET        CONSTANT NUMBER(2) := G_MSG_LEVEL_FATAL;   --4
G_MSG_MODE_DISABLED     CONSTANT NUMBER(2) := 99; 
G_MSG_MODE_OVERRIDDEN          CONSTANT NUMBER(2) := NULL;
G_AUTO_MSG_MODE_DEFAULT        CONSTANT NUMBER(2) := G_MSG_MODE_QUIET;
G_MANUAL_MSG_MODE_DEFAULT      CONSTANT NUMBER(2) := G_MSG_MODE_OVERRIDDEN;

G_MSG_TYPE_PARAM        CONSTANT VARCHAR2(10) := 'Param';
G_MSG_TYPE_NOTE         CONSTANT VARCHAR2(10) := 'Note';
G_MSG_TYPE_MESSAGE      CONSTANT VARCHAR2(10) := 'Message';
 
 
G_AUTO_WAKE_FORCE         CONSTANT ms_unit.auto_wake%TYPE := 'F'; 
G_AUTO_WAKE_YES           CONSTANT ms_unit.auto_wake%TYPE := 'Y';
G_AUTO_WAKE_NO            CONSTANT ms_unit.auto_wake%TYPE := 'N';
G_AUTO_WAKE_OVERRIDDEN    CONSTANT ms_unit.auto_wake%TYPE := NULL;
G_AUTO_WAKE_DEFAULT    CONSTANT ms_unit.auto_wake%TYPE := G_AUTO_WAKE_NO;
 
-- @TODO - Deprecated - remove
--FUNCTION new_process(i_process_name IN VARCHAR2 DEFAULT NULL
--                    ,i_process_type IN VARCHAR2 DEFAULT NULL
--                    ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
--                    ,i_module_name  IN VARCHAR2 DEFAULT NULL
--                    ,i_unit_name    IN VARCHAR2 DEFAULT NULL
--          --,i_msg_mode     IN INTEGER  DEFAULT G_MSG_MODE_NORMAL
--                    ,i_comments     IN VARCHAR2 DEFAULT NULL       ) RETURN INTEGER; 
 
 
FUNCTION new_pkg(i_module_name IN VARCHAR2
                ,i_unit_name   IN VARCHAR2 DEFAULT 'init_package' 
                ,i_debug       in boolean  default false
                ,i_normal      in boolean  default false
                ,i_quiet       in boolean  default false
                ,i_disabled    in boolean  default false
                ,i_msg_mode    in integer  default null
                ) RETURN ms_logger.node_typ;
 
 
FUNCTION new_proc(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2 
                 ,i_debug       in boolean  default false
                 ,i_normal      in boolean  default false
                 ,i_quiet       in boolean  default false
                 ,i_disabled    in boolean  default false
                 ,i_msg_mode    in integer  default null
                ) RETURN ms_logger.node_typ;


FUNCTION new_func(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2 
                 ,i_debug       in boolean  default false
                 ,i_normal      in boolean  default false
                 ,i_quiet       in boolean  default false
                 ,i_disabled    in boolean  default false
                 ,i_msg_mode    in integer  default null
                ) RETURN ms_logger.node_typ;
				 
FUNCTION new_trig(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
                 ,i_debug       in boolean  default false
                 ,i_normal      in boolean  default false
                 ,i_quiet       in boolean  default false
                 ,i_disabled    in boolean  default false
                 ,i_msg_mode    in integer  default null
                 ) RETURN ms_logger.node_typ;		 

FUNCTION new_script(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2
                   ,i_debug       in boolean  default false
                   ,i_normal      in boolean  default false
                   ,i_quiet       in boolean  default false
                   ,i_disabled    in boolean  default false
                   ,i_msg_mode    in integer  default null
                 ) RETURN ms_logger.node_typ;  
				   
 
 
 
----------------------------------------------------------------------
-- EXPOSED FOR THE MS_API
----------------------------------------------------------------------
------------------------------------------------------------------------
-- Message Mode operations 
------------------------------------------------------------------------
 
  
PROCEDURE  set_module_msg_mode(i_module_name IN VARCHAR2
                              ,i_msg_mode   IN NUMBER );

------------------------------------------------------------------------
  
PROCEDURE  set_unit_msg_mode(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
                            ,i_msg_mode   IN NUMBER );

PROCEDURE  set_logger_msg_mode(i_msg_mode   IN NUMBER );


PROCEDURE  wake_logger(i_node      IN node_typ
                      ,i_msg_mode  IN NUMBER DEFAULT G_MSG_MODE_DEBUG);

----------------------------------------------------------------------
-- f_process_traced
----------------------------------------------------------------------
FUNCTION f_process_traced(i_process_id IN INTEGER) RETURN BOOLEAN;

----------------------------------------------------------------------
-- f_process_exceptions - TRUE if any exceptions
----------------------------------------------------------------------
FUNCTION f_process_exceptions(i_process_id IN INTEGER) RETURN BOOLEAN;

FUNCTION f_process_id(i_process_id IN INTEGER  DEFAULT NULL
                  --   ,i_ext_ref    IN VARCHAR2 DEFAULT NULL
                     ) RETURN INTEGER; 

 
----------------------------------------------------------------------
-- USED IN INSTRUMENTATION BY AOP_PROCESSOR 
----------------------------------------------------------------------
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
               ,i_message         IN     VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
-- warning  
------------------------------------------------------------------------

PROCEDURE warning( i_node            IN ms_logger.node_typ 
                  ,i_message      IN     VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
-- fatal  
------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN ms_logger.node_typ 
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
-- note_error  
------------------------------------------------------------------------

PROCEDURE note_error( i_node            IN ms_logger.node_typ 
                     ,i_message         IN VARCHAR2 DEFAULT NULL  );
------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL  );
 
------------------------------------------------------------------------

PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2  );


--overloaded name, value | [id, descr] FOR CLOB
PROCEDURE note_clob( i_node      IN ms_logger.node_typ   
                    ,i_name      IN VARCHAR2
                    ,i_value     IN CLOB );

 
------------------------------------------------------------------------

PROCEDURE param_clob( i_node      IN ms_logger.node_typ 
                     ,i_name      IN VARCHAR2
                     ,i_value     IN CLOB  );


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
PROCEDURE note    ( i_node       IN ms_logger.node_typ 
                   ,i_name       IN VARCHAR2
                   ,i_date_value IN DATE );
------------------------------------------------------------------------
PROCEDURE param ( i_node       IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_date_value IN DATE   );

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_node       IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN );
------------------------------------------------------------------------
PROCEDURE param ( i_node       IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  );
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2);
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN ms_logger.node_typ 
                        ,i_name      IN VARCHAR2 );
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN ms_logger.node_typ 
                         ,i_name      IN VARCHAR2 ) RETURN NUMBER;

------------------------------------------------------------------------

PROCEDURE note_sqlerrm(i_node      IN ms_logger.node_typ );
------------------------------------------------------------------------
PROCEDURE note_length( i_node  IN ms_logger.node_typ 
                      ,i_name  IN VARCHAR2 
                      ,i_value IN CLOB        ) ;
 
 
END;
/
show error;
