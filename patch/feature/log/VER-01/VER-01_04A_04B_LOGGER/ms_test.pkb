--Ensure no inlining so ms_logger can be used
alter session set plsql_optimize_level = 1;

CREATE OR REPLACE PACKAGE BODY ms_test AS
-- $Id: ms_test.pkb 758 2008-04-29 04:37:49Z Peter $
-- @AOP_NEVER
  g_package_name       VARCHAR2(30)  := 'ms_test';
  g_package_revision   VARCHAR2(30)  := '10.0';


   PROCEDURE PLSQL_UNIT_test
   IS
     l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'$$PLSQL_UNIT');
   BEGIN
 
     ms_logger.note(l_node,'$$PLSQL_UNIT','$$PLSQL_UNIT');
 
   END;
 
  

/*********************************************************************
* MODULE:       f_elapsed_time
* PURPOSE:      subtracts 2 dates and returns results in hrs:min:sec format
* RETURNS:      varchar2
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 7/03/2005 pab       Original version
*********************************************************************/
FUNCTION f_elapsed_time (i_date1 IN DATE
                        ,i_date2 IN DATE)
RETURN VARCHAR2
IS

  l_day_fraction NUMBER := i_date2 - i_date1;

  l_day_hrs       NUMBER := 24;
  l_day_mins      NUMBER := 24*60;
  l_day_secs      NUMBER := 24*60*60;

  l_hrs  NUMBER := TRUNC(l_day_fraction * l_day_hrs);
  l_mins NUMBER := MOD(TRUNC(l_day_fraction * l_day_mins),60);
  l_secs NUMBER := MOD(TRUNC(l_day_fraction * l_day_secs),60);

BEGIN

  RETURN TO_CHAR(l_hrs)||':'||TO_CHAR(l_mins )||':'||TO_CHAR(l_secs );

END f_elapsed_time;



  --------------------------------------------------------------------
  --error_node
  --------------------------------------------------------------------

  PROCEDURE error_node(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'error_node');

  BEGIN
 
    ms_logger.param(l_node, 'i_node_count'      ,i_node_count   );
 
    IF i_node_count > 0 THEN
      ms_logger.info(l_node, 'Call recursively to create another node');
      error_node(i_node_count => i_node_count - 1);
    ELSE
      ms_logger.warning(l_node,'Manufacture an error');
	  RAISE NO_DATA_FOUND;
    END IF;

    ms_logger.comment(l_node,'Dropping out');
    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.warn_error(l_node); RAISE;

  END error_node;



   --------------------------------------------------------------------
   --test_exception_propagation
   --------------------------------------------------------------------

  PROCEDURE test_exception_propagation(i_number   IN NUMBER
                                        ,i_varchar2 IN VARCHAR2
                                        ,i_date     IN DATE
                                        ,i_boolean  IN BOOLEAN) IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_exception_propagation');
 
    l_start_time DATE;
    l_stop_time  DATE;
    l_elapsed_time_display VARCHAR2(30);
 
  BEGIN
 
    

    ms_logger.param(l_node, 'i_number  ' ,i_number  );
    ms_logger.param(l_node, 'i_varchar2' ,i_varchar2);
    ms_logger.param(l_node, 'i_date    ' ,i_date    );
    ms_logger.param(l_node, 'i_boolean ' ,i_boolean );

    --output_message_status;

    l_start_time := SYSDATE;

    error_node(i_node_count => 5);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info(l_node,  'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);

    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node);

  END test_exception_propagation;


  --------------------------------------------------------------------
  --test_node
  --------------------------------------------------------------------

  PROCEDURE test_node(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_node');

  BEGIN

    
    ms_logger.param(l_node, 'i_node_count'      ,i_node_count   );
    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
    ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);


    IF i_node_count > 0 THEN
      ms_logger.info(l_node, 'Call recursively to create another node');
      test_node(i_node_count => i_node_count - 1);
    END IF;

    ms_logger.comment(l_node,'Dropping out');
    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.warn_error(l_node); RAISE;

  END test_node;



  --------------------------------------------------------------------
  --test_message_tree
  --------------------------------------------------------------------

  PROCEDURE test_message_tree(i_number   IN NUMBER
                               ,i_varchar2 IN VARCHAR2
                               ,i_date     IN DATE
                               ,i_boolean  IN BOOLEAN) IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_message_tree');
 
    l_start_time DATE;
    l_stop_time  DATE;
    l_elapsed_time_display VARCHAR2(30);


  BEGIN


    

    ms_logger.param(l_node, 'i_number  ' ,i_number  );
    ms_logger.param(l_node, 'i_varchar2' ,i_varchar2);
    ms_logger.param(l_node, 'i_date    ' ,i_date    );
    ms_logger.param(l_node, 'i_boolean ' ,i_boolean );

    --output_message_status;

    l_start_time := SYSDATE;

    test_node(i_node_count => 5);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info(l_node,  'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);

    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node);

  END test_message_tree;
  
  
  --------------------------------------------------------------------
  --test_logger_node
  --------------------------------------------------------------------

  PROCEDURE test_logger_node(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_logger_node');
 

  BEGIN
 
    ms_logger.param( l_node,'i_node_count'      ,i_node_count   );
 
    IF i_node_count > 0 THEN
      ms_logger.info(l_node,'Call recursively to create another node');
      test_logger_node(i_node_count => i_node_count - 1);
    END IF;
	
    IF i_node_count > 1 THEN
      ms_logger.info(l_node,'2nd recursive call');
      test_logger_node(i_node_count => i_node_count - 1);
    END IF;
 
    ms_logger.comment(l_node,'Dropping out');
 
  END test_logger_node;
  
  
  --------------------------------------------------------------------
  --test_logger_tree
  --------------------------------------------------------------------

  PROCEDURE test_logger_tree(i_number   IN NUMBER
                               ,i_varchar2 IN VARCHAR2
                               ,i_date     IN DATE
                               ,i_boolean  IN BOOLEAN) IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_logger_tree');
 
    l_start_time DATE;
    l_stop_time  DATE;
    l_elapsed_time_display VARCHAR2(30);
 
  BEGIN

 
    ms_logger.param( l_node, 'i_number  ' ,i_number  );
    ms_logger.param( l_node, 'i_varchar2' ,i_varchar2);
    ms_logger.param( l_node, 'i_date    ' ,i_date    );
    ms_logger.param( l_node, 'i_boolean ' ,i_boolean );

    --output_message_status;

    l_start_time := SYSDATE;

    test_logger_node(i_node_count => 5);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info( l_node,'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);
 

  END test_logger_tree;  
  
  --------------------------------------------------------------------
  --test_internal_error
  --------------------------------------------------------------------

  PROCEDURE test_internal_error IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_internal_error');
 
    l_start_time DATE;
    l_stop_time  DATE;
    l_elapsed_time_display VARCHAR2(30);


  BEGIN


    
 
    --output_message_status;

    l_start_time := SYSDATE;

    test_node(i_node_count => 120);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info(l_node,  'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);

    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node);

  END test_internal_error;


  --------------------------------------------------------------------
  --msg_mode_node
  --------------------------------------------------------------------

  PROCEDURE msg_mode_node(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'msg_mode_node');

  BEGIN

    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
    
    ms_logger.param(l_node,'i_node_count',i_node_count );

    ms_logger.comment(l_node,'Comment is not suppressed.');
    ms_logger.info(   l_node,'Info is not suppressed.');
    ms_logger.warning(l_node,'Warning is not suppressed.');
    ms_logger.fatal(  l_node,'Fatal is not suppressed.'); RAISE NO_DATA_FOUND;
 
  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.warn_error(l_node); RAISE;

  END msg_mode_node;
  
  
  --------------------------------------------------------------------
  --max_nest_test
  --------------------------------------------------------------------

  PROCEDURE max_nest_test(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'max_nest_test');

  BEGIN
  
    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);

    
    ms_logger.param(l_node,'i_node_count',i_node_count );
 
    IF i_node_count > 0  THEN
      ms_logger.comment(l_node,'Call recursively to create another node');
      max_nest_test(i_node_count => i_node_count - 1);
    END IF;

    ms_logger.comment(l_node,'Dropping out');
    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.warn_error(l_node); RAISE;

  END max_nest_test;  


  --------------------------------------------------------------------
  --test_unit_msg_mode
  --------------------------------------------------------------------

  PROCEDURE test_unit_msg_mode  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_unit_msg_mode');
 
    l_start_time DATE;
    l_stop_time  DATE;
    l_elapsed_time_display VARCHAR2(30);


  BEGIN
  
    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);

     ms_logger.comment(l_node,'Comment before call to quiet unit');
    max_nest_test(i_node_count => 5);
    msg_mode_node(i_node_count => 5); 


    max_nest_test(i_node_count => 25);

     ms_logger.comment(l_node,'Comment after - but probably skipped by exception');
	 
  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node);

  END test_unit_msg_mode;
  
 /*
  --------------------------------------------------------------------
  --std_single_loop_proc
  --------------------------------------------------------------------

  PROCEDURE std_single_loop_proc  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'std_single_loop_proc');
 
  BEGIN


    
    ms_logger.comment(l_node,'Test normal loop propagation');
    
    --LOOPS
    
    DECLARE
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'test_loop');
    BEGIN
      
 
      FOR l_index IN 1..3 LOOP

          ms_logger.do_pass(l_node);
          ms_logger.param(l_node,'l_index',l_index);
 
      END LOOP;
      
    EXCEPTION
     WHEN OTHERS THEN
       ms_logger.warn_error(l_node); RAISE;
    END;
 
     
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node);
  END;
  
  --------------------------------------------------------------------
  --std_loop_fatal
  --------------------------------------------------------------------

  PROCEDURE std_loop_fatal  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'std_loop_fatal');
 
  BEGIN


    
    ms_logger.comment(l_node,'Test error within loop, without specific WHEN OTHERS');
    
    DECLARE
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'test_loop');
    BEGIN
 
      FOR l_index IN 1..3 LOOP

          ms_logger.do_pass(l_node);
          ms_logger.param(l_node,'l_index',l_index);
          IF l_index = 2 then
            ms_logger.fatal(l_node,'Raising fatal error'); RAISE NO_DATA_FOUND;
          END IF;
 
      END LOOP;
      
    EXCEPTION
     WHEN OTHERS THEN
       ms_logger.warn_error(l_node); RAISE;
    END;
 
     
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node);
  END;
  
  --------------------------------------------------------------------
  --special_loop_trap
  --------------------------------------------------------------------

  PROCEDURE special_loop_trap  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'special_loop_trap');
 
  BEGIN


    
    ms_logger.comment(l_node,'Test error within loop, trapping at the pass');

    DECLARE
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'test_loop');
    BEGIN
 
      FOR l_index IN 1..3 LOOP
        BEGIN
          ms_logger.do_pass(l_node);
          ms_logger.param(l_node,'l_index',l_index);
          IF l_index = 2 then
            ms_logger.fatal(l_node,'Raising application error', TRUE);
          END IF;
        EXCEPTION
         WHEN OTHERS THEN
           ms_logger.oracle_error(l_node);
           
        END;
      END LOOP;
      
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.warn_error(l_node); RAISE;
    END;
 
     
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node);
  END;
  
  
  --------------------------------------------------------------------
  --special_loop_raise
  --------------------------------------------------------------------

  PROCEDURE special_loop_raise  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'special_loop_raise');
 
  BEGIN


    
    ms_logger.comment(l_node,'Test error within loop, raising at the pass');

    DECLARE
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'test_loop');
    BEGIN
 
      FOR l_index IN 1..3 LOOP
        BEGIN
          ms_logger.do_pass(l_node, 'my count '||l_index);
          ms_logger.param(l_node,'l_index',l_index);
          IF l_index = 2 then
            ms_logger.fatal(l_node,'Raise fatal error');  RAISE NO_DATA_FOUND;
          END IF;
        EXCEPTION
         WHEN OTHERS THEN
           ms_logger.warn_error(l_node); RAISE;
      END;
      END LOOP;
      
    EXCEPTION
     WHEN OTHERS THEN
       ms_logger.warn_error(l_node); RAISE;
    END;
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node);
  END;
 
  */
   --------------------------------------------------------------------
   --raise_an_oracle_error
   --------------------------------------------------------------------
 
   PROCEDURE raise_an_oracle_error  IS
 
     l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'raise_an_oracle_error');
  
   BEGIN
 
 
     
     ms_logger.comment(l_node,'Test handling on an Oracle Error - esp for the silent version');
     RAISE NO_DATA_FOUND;
 
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.warn_error(l_node); RAISE;
  END raise_an_oracle_error;
 
   --------------------------------------------------------------------
   --trap_an_oracle_error
   --------------------------------------------------------------------
 
   PROCEDURE trap_an_oracle_error  IS
 
     l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'trap_an_oracle_error');
  
   BEGIN
 
     ms_logger.comment(l_node,'Test handling on an Oracle Error - esp for the silent version');
 
     RAISE NO_DATA_FOUND;
 
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node);
  END trap_an_oracle_error;
 
   --------------------------------------------------------------------
   --raise_then_trap_oracle_error
   --------------------------------------------------------------------
 
   PROCEDURE raise_then_trap_oracle_error  IS
 
     l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'raise_then_trap_oracle_error');
  
   BEGIN
 
 
     
     ms_logger.comment(l_node,'Test handling on an Oracle Error - esp for the silent version');
 
     raise_an_oracle_error;
  
     
  
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node);
  END raise_then_trap_oracle_error;
 
  PROCEDURE exit_a_proc(x in number) IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'exit_a_proc');
  
  BEGIN
    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
    ms_logger.comment(l_node,'Test that popping the proc works');
  
  END exit_a_proc;  
  
  --------------------------------------------------------------------
  --test_unit_types
  --------------------------------------------------------------------

  PROCEDURE test_unit_types  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_unit_types');
    x_user_def EXCEPTION;
   

	
	
	
    PROCEDURE trap_unhandled_error IS
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'trap_unhandled_error');


    BEGIN
      ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
      ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
	  
      ms_logger.comment(l_node,'Test an unhandled user defined error');
      RAISE x_user_def;
 
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node);
    
    END trap_unhandled_error; 
	
	
    PROCEDURE raise_unhandled_error IS
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'raise_unhandled_error');


    BEGIN
      ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
      ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
	  
      ms_logger.comment(l_node,'Test an unhandled user defined error');
      RAISE x_user_def;
 
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.warn_error(l_node); RAISE;
    
    END raise_unhandled_error;
 
 
       PROCEDURE double_exit_recovery4 IS
        l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'double_exit_recovery4');
      
      BEGIN
      ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
      ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
        ms_logger.comment(l_node,'Level 4.');
		
      EXCEPTION
        WHEN OTHERS THEN
          ms_logger.oracle_error(l_node);
      
      END double_exit_recovery4; 
      PROCEDURE double_exit_recovery3A IS
        --l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'double_exit_recovery3');
      
      BEGIN
      
        double_exit_recovery4;
		
      --EXCEPTION
      -- WHEN OTHERS THEN
      --    ms_logger.oracle_error(l_node);
      
      END double_exit_recovery3A; 
 
      PROCEDURE double_exit_recovery3 IS
        l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'double_exit_recovery3');
      
      BEGIN
      
        double_exit_recovery3A;
		
      EXCEPTION
       WHEN OTHERS THEN
          ms_logger.oracle_error(l_node);
      
      END double_exit_recovery3; 
 
 
	
    PROCEDURE double_exit_recovery1 IS
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'double_exit_recovery1');

      PROCEDURE double_exit_recovery2 IS
        l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'double_exit_recovery2');
      
      PROCEDURE double_exit_recovery2A IS
        l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'double_exit_recovery2A');
      
      BEGIN
      ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
      ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
        ms_logger.comment(l_node,'Test Logger tracks node, next comment...');
      
      EXCEPTION
        WHEN OTHERS THEN
          ms_logger.oracle_error(l_node);
      
      END double_exit_recovery2A; 
	  
      BEGIN
      ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
      ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
        ms_logger.comment(l_node,'Test Logger tracks node, next comment...');
		double_exit_recovery2A;
      
      EXCEPTION
        WHEN OTHERS THEN
          ms_logger.oracle_error(l_node);
      
      END double_exit_recovery2;  
	  
    BEGIN
      ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
      ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	  ms_logger.note(l_node,'l_node.call_stack_hist',l_node.call_stack_hist );
	  ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
      double_exit_recovery2;
	  
	  double_exit_recovery3;
 
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node);
    
    END double_exit_recovery1;  
	
 
  BEGIN

    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
    
   double_exit_recovery1;
	
	
    /*
    std_single_loop_proc;
    std_loop_fatal;
    special_loop_trap;
    special_loop_raise;
    */
	begin
      exit_a_proc(1);
	end;
	ms_logger.comment(l_node,'Did it work?');
    

    /*
    DECLARE 
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'block_error_detection');
 
    BEGIN
    
      
      
      ms_logger.fatal(l_node,'Test that error detection in the block works');
      
      
    
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node);

    END; --block_error_detection
    */
	/*
    DECLARE 
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'unit_type_detection');
    
    BEGIN
    
      
      
      ms_logger.comment(l_node,'Test incorrect unit_type is detected.');
      
       
    
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node);

    END; --unit_type_detection
	*/
    
	BEGIN
      trap_unhandled_error;
	EXCEPTION
      when x_user_def then	
	    ms_logger.comment(l_node,'Explicitly handled');
    END;
	
	BEGIN
      raise_unhandled_error;
	EXCEPTION
      when x_user_def then	
	    ms_logger.comment(l_node,'Explicitly handled');
    END;
 
    ms_logger.comment(l_node,'..this comment to test_unit_types');

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node);
  
  END test_unit_types;
  
  
  
  
  
  --------------------------------------------------------------------
  --test_traversal_tree
  --------------------------------------------------------------------

  PROCEDURE test_traversal_tree(i_node_count IN  NUMBER) IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_traversal_tree');
 
  BEGIN
  
    ms_logger.note(l_node,'l_node.node_level',l_node.node_level );
    ms_logger.note(l_node,'l_node.call_stack_level',l_node.call_stack_level );
	ms_logger.note(l_node,'dbms_utility.format_call_stack',dbms_utility.format_call_stack);
 
  
    if l_node.node_level < 10 and i_node_count > 0 then
	  test_traversal_tree(i_node_count => i_node_count - 1);
    end if;
    ms_logger.comment(l_node,'dropping out');

  END test_traversal_tree; 
  
  --------------------------------------------------------------------
  --test_tree
  --------------------------------------------------------------------

  PROCEDURE test_tree is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_tree');
 
  BEGIN
    test_traversal_tree(i_node_count => 20);
  END test_tree; 
  
  PROCEDURE test_call_stack3 is
	x   VARCHAR2(4000);
  begin
    dbms_output.put_line('test_call_stack3');
	x := dbms_utility.format_call_stack;
	--x := replace(x, chr(10), ' ');
    dbms_output.put_line(x);  
 
  end;
  
  PROCEDURE test_call_stack2 is
  begin
    dbms_output.put_line('test_call_stack2');
    dbms_output.put_line(dbms_utility.format_call_stack);  
	test_call_stack3;
	dbms_output.put_line('test_call_stack2');
	dbms_output.put_line(dbms_utility.format_call_stack); 

  end;
  
  PROCEDURE test_call_stack is
  begin
    dbms_output.enable(10000000);
    dbms_output.put_line('test_call_stack');
    dbms_output.put_line(dbms_utility.format_call_stack);  
	test_call_stack2;
	dbms_output.put_line('test_call_stack');
	dbms_output.put_line(dbms_utility.format_call_stack); 
  end;
  

  PROCEDURE test_quiet_mode is
    l_node ms_logger.node_typ := ms_logger.new_proc($$plsql_unit ,'test_quiet_mode');
  begin --test_quiet_mode
  begin  
    ms_logger.comment(l_node,'About to error');
    raise NO_DATA_FOUND;
  END;
  exception
    when others then
      ms_logger.warn_error(l_node);
      raise;
  end; --test_quiet_mode

 
 
END ms_test;
/
show errors;
