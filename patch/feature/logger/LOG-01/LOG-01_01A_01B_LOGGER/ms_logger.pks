create or replace package ms_logger is
 
------------------------------------------------------------------------
-- Node Typ API functions (Public)
------------------------------------------------------------------------


SUBTYPE node_typ IS ms_metacode.node_typ;
 
FUNCTION new_proc(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
				 ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;


FUNCTION new_func(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
				 ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;
				   
  FUNCTION new_block(i_module_name IN VARCHAR2
                    ,i_unit_name   IN VARCHAR2
				    ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ;	   
				   
------------------------------------------------------------------------
-- PASS operations (PUBLIC)
-- Pass is a metacoding shortcut.  
-- Creates and uses nodes that don't really exist, by adding 1 to the node_level
------------------------------------------------------------------------
PROCEDURE do_pass(io_node     IN OUT  ms_metacode.node_typ
                 ,i_pass_name IN VARCHAR2 DEFAULT NULL);
------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

------------------------------------------------------------------------ 
PROCEDURE comment( i_node            IN ms_metacode.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL
                  ,i_raise_app_error IN BOOLEAN  DEFAULT FALSE);

------------------------------------------------------------------------
PROCEDURE info( i_node            IN ms_metacode.node_typ 
               ,i_message         IN     VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------

PROCEDURE warning( i_node            IN ms_metacode.node_typ 
                  ,i_message      IN     VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN ms_metacode.node_typ 
                ,i_message         IN     VARCHAR2 DEFAULT NULL
                ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE);
  
------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_metacode.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL );
 
PROCEDURE invariant(i_node      IN ms_metacode.node_typ 
                   ,i_value     IN VARCHAR2);

------------------------------------------------------------------------

PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL );
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_metacode.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------ 
PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL );
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_node      IN ms_metacode.node_typ 
                   ,i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL );
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL );

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_node      IN ms_metacode.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN );
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 , i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  );
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_node      IN ms_metacode.node_typ 
                 ,i_name      IN VARCHAR2);
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN ms_metacode.node_typ 
                        ,i_name      IN VARCHAR2 );

------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN ms_metacode.node_typ 
                         ,i_name      IN VARCHAR2 ) RETURN NUMBER;

------------------------------------------------------------------------

PROCEDURE note_error(i_node      IN ms_metacode.node_typ );

------------------------------------------------------------------------
PROCEDURE note_length( i_node   IN ms_metacode.node_typ 
                      ,i_name   IN VARCHAR2 );
 
 
 
------------------------------------------------------------------------
-- EXCEPTION HANDLERS  (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE oracle_error( i_node            IN ms_metacode.node_typ
                       ,i_message         IN VARCHAR2 DEFAULT NULL );
 
END;
/