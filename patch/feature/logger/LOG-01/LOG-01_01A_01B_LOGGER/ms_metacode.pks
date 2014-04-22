CREATE OR REPLACE PACKAGE ms_metacode IS
------------------------------------------------------------------
-- Program  : ms_metacode  
-- Name     : Metacode for PL/SQL
-- Author   : P.Burgess
-- Date     : 23/10/2006
-- Purpose  : Logging and error handling for PL/SQL 
------------------------------------------------------------------------

 
-- Global Exceptions (Public )
 
x_error              EXCEPTION;
G_ERROR_CODE         CONSTANT NUMBER := -20999;
PRAGMA EXCEPTION_INIT(x_error,   -20999);

TYPE node_typ IS RECORD
  (module_name    ms_module.module_name%TYPE
  ,unit_name      ms_unit.unit_name%TYPE
  ,unit_type      ms_unit.unit_type%TYPE
  ,node_level     BINARY_INTEGER
  ,internal_error BOOLEAN DEFAULT NULL --start undefined, set to false by an ENTER routine.
  ,pass_count     NUMBER  DEFAULT 0    --initialised at 0 
  ,call_stack     varchar2(2000));  


 TYPE traversal_list_typ IS TABLE OF NUMBER;  

/* 
------------------------------------------------------------------------
-- Expose constants via functions for UT_LIB(Public) 
------------------------------------------------------------------------ 
  
FUNCTION f_unit_type_form_trigger   RETURN VARCHAR2; 
FUNCTION f_unit_type_block_trigger  RETURN VARCHAR2; 
FUNCTION f_unit_type_record_trigger RETURN VARCHAR2; 
FUNCTION f_unit_type_item_trigger   RETURN VARCHAR2; 
*/ 
 
------------------------------------------------------------------------
-- Node Typ API functions (Public)
------------------------------------------------------------------------

FUNCTION new_node(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
				 ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;
 
------------------------------------------------------------------------
-- new_node API functions for ORACLE FORMS (Public)
------------------------------------------------------------------------
 
--FORM TRIGGER NODE
FUNCTION form_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL)  RETURN ms_metacode.node_typ;

--BLOCK TRIGGER NODE
FUNCTION block_trigger_node(i_module_name IN VARCHAR2
                           ,i_unit_name   IN VARCHAR2
						   ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;

--RECORD TRIGGER NODE
FUNCTION record_trigger_node(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
						    ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;
 
--ITEM TRIGGER NODE
FUNCTION item_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;
 
------------------------------------------------------------------------
-- Internal debugging routines (public)
------------------------------------------------------------------------
 
PROCEDURE set_internal_debug;

PROCEDURE reset_internal_debug;

------------------------------------------------------------------------
-- METACODE ROUTINES (Public)
------------------------------------------------------------------------
PROCEDURE new_process(i_module_name  IN VARCHAR2 DEFAULT NULL
                     ,i_unit_name    IN VARCHAR2 DEFAULT NULL
                     ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                     ,i_comments     IN VARCHAR2 DEFAULT NULL); 
------------------------------------------------------------------------    
 
PROCEDURE comment( i_message         IN VARCHAR2 DEFAULT NULL
                  ,i_raise_app_error IN BOOLEAN  DEFAULT FALSE
				  ,i_node            IN ms_metacode.node_typ DEFAULT NULL );
------------------------------------------------------------------------                  
PROCEDURE info( i_message         IN     VARCHAR2 DEFAULT NULL 
               ,i_node      IN ms_metacode.node_typ DEFAULT NULL	);
------------------------------------------------------------------------
PROCEDURE warning( i_message      IN     VARCHAR2 DEFAULT NULL
                  ,i_node      IN ms_metacode.node_typ DEFAULT NULL );
------------------------------------------------------------------------
PROCEDURE fatal( i_message         IN     VARCHAR2 DEFAULT NULL
                ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
			    ,i_node            IN ms_metacode.node_typ DEFAULT NULL);
				
PROCEDURE raise_fatal( i_message         IN     VARCHAR2 DEFAULT NULL
                      ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
				      ,i_node            IN ms_metacode.node_typ DEFAULT NULL);

------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL 
                   ,i_node      IN ms_metacode.node_typ DEFAULT NULL);
                   
PROCEDURE invariant(i_value     IN VARCHAR2
                   ,i_node      IN ms_metacode.node_typ DEFAULT NULL);

------------------------------------------------------------------------

PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL );
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL
                   ,i_node      IN ms_metacode.node_typ DEFAULT NULL );

------------------------------------------------------------------------ 
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL );
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL
                   ,i_node      IN ms_metacode.node_typ DEFAULT NULL				   );
------------------------------------------------------------------------
PROCEDURE param ( i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL );

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL );
------------------------------------------------------------------------
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN 
				 ,i_node      IN ms_metacode.node_typ DEFAULT NULL				 );
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_name      IN VARCHAR2
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL);
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_name      IN VARCHAR2
                        ,i_node      IN ms_metacode.node_typ DEFAULT NULL );
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_name      IN VARCHAR2
                         ,i_node      IN ms_metacode.node_typ DEFAULT NULL ) RETURN NUMBER;
------------------------------------------------------------------------
PROCEDURE note_length( i_name  IN VARCHAR2
                      ,i_node      IN ms_metacode.node_typ DEFAULT NULL );
 
PROCEDURE note_error(i_node      IN ms_metacode.node_typ DEFAULT NULL);
 
------------------------------------------------------------------------
-- Log Register operations (PUBLIC) Overloaded on private routine register_module
-- 
--   register_package
--   register_form
--   register_report
--   register_standalone_procedure
--   register_standalone_function
------------------------------------------------------------------------

 
PROCEDURE  register_package(i_name      IN VARCHAR2
                           ,i_revision  IN VARCHAR2 DEFAULT NULL);
------------------------------------------------------------------------
 
PROCEDURE  register_form(i_name     IN VARCHAR2
                        ,i_revision IN VARCHAR2);

------------------------------------------------------------------------ 
PROCEDURE  register_report(i_name     IN VARCHAR2
                          ,i_revision IN VARCHAR2);
------------------------------------------------------------------------ 
PROCEDURE  register_standalone_procedure(i_name     IN VARCHAR2
                                        ,i_revision IN VARCHAR2);
------------------------------------------------------------------------ 
PROCEDURE  register_standalone_function(i_name     IN VARCHAR2
                                       ,i_revision IN VARCHAR2);
------------------------------------------------------------------------
PROCEDURE  register_SQL_script(i_name     IN VARCHAR2
                              ,i_revision IN VARCHAR2);

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
-- ENTER UNIT operations (PUBLIC)
------------------------------------------------------------------------
 

PROCEDURE enter_proc(io_node IN OUT ms_metacode.node_typ);
------------------------------------------------------------------------

PROCEDURE enter_func(io_node IN OUT ms_metacode.node_typ);

------------------------------------------------------------------------

PROCEDURE enter_loop(io_node IN OUT ms_metacode.node_typ);

------------------------------------------------------------------------

PROCEDURE enter_block(io_node IN OUT ms_metacode.node_typ);

------------------------------------------------------------------------

PROCEDURE enter_trigger(io_node IN OUT ms_metacode.node_typ);

------------------------------------------------------------------------

PROCEDURE enter_sql_script(io_node IN OUT ms_metacode.node_typ);

------------------------------------------------------------------------
-- EXIT UNIT operations (PUBLIC)
------------------------------------------------------------------------
PROCEDURE exit_proc(  io_node IN OUT  ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE exit_func(io_node IN OUT  ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE exit_loop(  io_node IN OUT  ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE exit_block(  io_node IN OUT  ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE exit_trigger( io_node IN OUT  ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE exit_sql_script(io_node IN OUT ms_metacode.node_typ);
------------------------------------------------------------------------
-- PASS operations (PUBLIC)
------------------------------------------------------------------------
PROCEDURE do_pass(io_node IN OUT  ms_metacode.node_typ
                 ,i_pass_name IN VARCHAR2 DEFAULT NULL);
------------------------------------------------------------------------
PROCEDURE trap_pass_error(io_node IN OUT ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE raise_pass_error(io_node IN OUT ms_metacode.node_typ);
------------------------------------------------------------------------
PROCEDURE ignore_pass_error(io_node IN OUT ms_metacode.node_typ);
------------------------------------------------------------------------
-- EXCEPTION HANDLERS  (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE ignore_error(io_node        IN OUT      ms_metacode.node_typ
                      ,i_error_name   IN VARCHAR2 DEFAULT NULL
                      ,i_message      IN VARCHAR2 DEFAULT NULL);
  --ignore an expected named error - continue normal processing
------------------------------------------------------------------------

PROCEDURE handled_error(io_node        IN OUT      ms_metacode.node_typ
                       ,i_error_name   IN VARCHAR2 DEFAULT NULL
                       ,i_message      IN VARCHAR2 DEFAULT NULL);
------------------------------------------------------------------------
 
PROCEDURE trap_error(io_node    IN OUT ms_metacode.node_typ
                    ,i_message  IN     VARCHAR2 DEFAULT NULL);
--trap x_error or oracle error, and return to normal processing 

------------------------------------------------------------------------

PROCEDURE raise_error(io_node    IN OUT ms_metacode.node_typ
                     ,i_message  IN     VARCHAR2 DEFAULT NULL);
--trap x_error or oracle error, and return re-raise x_error 

------------------------------------------------------------------------
 
/*********************************************************************
* MODULE:  MSG_LEVEL Functions
* PURPOSE: retrieval of global variables.
* RETURNS: NUMBER
* NOTES:
*********************************************************************/

FUNCTION msg_level_info     RETURN NUMBER;
FUNCTION msg_level_comment  RETURN NUMBER;
FUNCTION msg_level_warning  RETURN NUMBER;
FUNCTION msg_level_fatal    RETURN NUMBER;
FUNCTION msg_level_oracle   RETURN NUMBER;

/*********************************************************************
* MODULE:  msg_level_string
* PURPOSE: A string to represent the message level.
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 05-DEC-2001 PAB       Original version
*********************************************************************/
FUNCTION msg_level_string (i_msg_level    IN NUMBER) RETURN VARCHAR2;



/*********************************************************************
* MODULE:  f_is_metacode_pkg_silent
* PURPOSE: tells if we have the null package or not
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 17/03/2005   PAB       Original version
*********************************************************************/
FUNCTION f_is_metacode_pkg_silent RETURN BOOLEAN;

----------------------------------------------------------------------
-- f_is_metacode_pkg_silent_YN
----------------------------------------------------------------------
FUNCTION f_is_metacode_pkg_silent_YN RETURN VARCHAR2;
 
/*********************************************************************
* MODULE:  get_traversal_id_list
* PURPOSE: client-side form cannot use EXECUTE IMMEDIATE
*          so this procedure will support UT002
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 16/12/2006   PAB       Original version
*********************************************************************/

FUNCTION get_traversal_id_list(i_node_SQL IN VARCHAR2) RETURN traversal_list_typ;
/*********************************************************************
* MODULE:  unit_message_count
* PURPOSE: used for ms_unit_vw
*          so this view will support UT003
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 21/12/2006   PAB       Original version
*********************************************************************/
 
FUNCTION unit_message_count(i_unit_id IN NUMBER
                           ,i_msg_level    IN NUMBER) RETURN NUMBER;

/*********************************************************************
* MODULE:  unit_traversal_count
* PURPOSE: used for ms_unit_vw
*          so this view will support UT003
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 21/12/2006   PAB       Original version
*********************************************************************/
 
FUNCTION unit_traversal_count(i_unit_id IN NUMBER ) RETURN NUMBER;

/*********************************************************************
* MODULE:  concat_messages
* PURPOSE: Returns the concatonation of messages for the traversal
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 22/05/2004  pab       Original version
*********************************************************************/
FUNCTION concat_messages(i_traversal_id IN NUMBER)
RETURN VARCHAR2;

/*********************************************************************
* MODULE:  concat_references
* PURPOSE: Returns the concatonation of references for the traversal
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 22/05/2004  pab       Original version
*********************************************************************/
FUNCTION concat_references(i_traversal_id IN NUMBER)
RETURN VARCHAR2;


  --------------------------------------------------------------------
  --purge_old_processes
  -------------------------------------------------------------------


PROCEDURE purge_old_processes(i_keep_day_count IN NUMBER DEFAULT 1);

--------------------------------------------------------------------
--oracle_error - now exposed for ms_logger.
-------------------------------------------------------------------
PROCEDURE oracle_error( i_message         IN     VARCHAR2 DEFAULT NULL
                       ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
					   ,i_node            IN ms_metacode.node_typ DEFAULT NULL);

 
--  --------------------------------------------------------------------
--  --notify_oracle_errors
--  -------------------------------------------------------------------
--
-- 
--PROCEDURE notify_oracle_errors;
-- 
--  --------------------------------------------------------------------
--  --notify_internal_errors
--  -------------------------------------------------------------------
--
-- 
--PROCEDURE notify_internal_errors;

END ms_metacode;
/

