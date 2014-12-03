CREATE OR REPLACE PACKAGE  ms_test AS
-- $Id: ms_test.pks 758 2008-04-29 04:37:49Z Peter $

 --PROCEDURE PLSQL_UNIT_test;
 
  PROCEDURE error_node(i_node_count IN  NUMBER) ;
  
  PROCEDURE test_node(i_node_count IN  NUMBER);
 
  --------------------------------------------------------------------
  --test_exception_propagation
  --------------------------------------------------------------------
  PROCEDURE test_exception_propagation(i_number   IN NUMBER
                                      ,i_varchar2 IN VARCHAR2
                                      ,i_date     IN DATE
                                      ,i_boolean  IN BOOLEAN);
  --------------------------------------------------------------------
  --test_message_tree
  --------------------------------------------------------------------

  PROCEDURE test_message_tree(i_number   IN NUMBER
                             ,i_varchar2 IN VARCHAR2
                             ,i_date     IN DATE
                             ,i_boolean  IN BOOLEAN);

  --------------------------------------------------------------------
  --test_logger_tree
  --------------------------------------------------------------------

  PROCEDURE test_logger_tree(i_number   IN NUMBER
                               ,i_varchar2 IN VARCHAR2
                               ,i_date     IN DATE
                               ,i_boolean  IN BOOLEAN);	 
							 
  --------------------------------------------------------------------
  --test_internal_error
  --------------------------------------------------------------------

  PROCEDURE test_internal_error;
  --------------------------------------------------------------------
  --test_unit_msg_mode
  --------------------------------------------------------------------

  PROCEDURE test_unit_msg_mode;
  
  --PROCEDURE exit_a_proc(x in number);   
    
   --------------------------------------------------------------------
   --trap_an_oracle_error
   --------------------------------------------------------------------
 
   PROCEDURE trap_an_oracle_error;
   
   --------------------------------------------------------------------
   --raise_an_oracle_error
   --------------------------------------------------------------------
 
   PROCEDURE raise_an_oracle_error;
  
   --------------------------------------------------------------------
   --raise_then_trap_an_oracle_error
   --------------------------------------------------------------------
 
   PROCEDURE raise_then_trap_oracle_error;
    
    
 
  --------------------------------------------------------------------
  --test_unit_types
  --------------------------------------------------------------------

  PROCEDURE test_unit_types;
  
  
  
  --------------------------------------------------------------------
  --test_traversal_tree
  --------------------------------------------------------------------

  PROCEDURE test_traversal_tree(i_node_count IN  NUMBER);
  --------------------------------------------------------------------
  --test_tree
  --------------------------------------------------------------------

  PROCEDURE test_tree;
  
  PROCEDURE test_call_stack;
 

END ms_test;
/
show errors;
