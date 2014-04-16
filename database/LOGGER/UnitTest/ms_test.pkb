prompt $Id: ms_test.pkb 758 2008-04-29 04:37:49Z Peter $

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
 * MODULE:       check_messages_state
 * PURPOSE:      fail if doing a full run and message_pkg is active.
 * RETURNS:
 * NOTES:
 * HISTORY:
 * When        Who       What
 * ----------- --------- ----------------------------------------------
 * 17/03/2005 pab       Original version
 *********************************************************************/
 PROCEDURE check_messages_state(i_max_records IN NUMBER)
 IS
     l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'check_messages_state');
 BEGIN

    IF i_max_records > 100 AND
       NOT ms_metacode.f_is_metacode_pkg_silent THEN
       ms_logger.fatal(l_node, 'Messages should NOT be active for a full run'); RAISE NO_DATA_FOUND;
    END IF;
 END;
 
   /*********************************************************************
   * MODULE:       output_message_status
   * PURPOSE:      output message status with dbms_output
   * RETURNS:
   * NOTES:
   * HISTORY:
   * When        Who       What
   * ----------- --------- ----------------------------------------------
   * 28/07/2005 pab       Original version
   *********************************************************************/


   PROCEDURE output_message_status
   IS
     l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'output_message_status');
   BEGIN

     IF ms_metacode.f_is_metacode_pkg_silent THEN
       dbms_output.put_line( 'Messages are NOT active');
     ELSE
       ms_logger.info(l_node,  'Messages are active');
     END IF;

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
      ms_logger.oracle_error(l_node); RAISE;

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

    output_message_status;

    l_start_time := SYSDATE;

    error_node(i_node_count => 5);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info(l_node,  'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);

    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); --DO NOT RAISE;

  END test_exception_propagation;


  --------------------------------------------------------------------
  --test_node
  --------------------------------------------------------------------

  PROCEDURE test_node(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_node');

  BEGIN

    
    ms_logger.param(l_node, 'i_node_count'      ,i_node_count   );


    IF i_node_count > 0 THEN
      ms_logger.info(l_node, 'Call recursively to create another node');
      test_node(i_node_count => i_node_count - 1);
    END IF;

    ms_logger.comment(l_node,'Dropping out');
    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); RAISE;

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

    output_message_status;

    l_start_time := SYSDATE;

    test_node(i_node_count => 5);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info(l_node,  'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);

    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); --DO NOT RAISE;

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

    output_message_status;

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


    
 
    output_message_status;

    l_start_time := SYSDATE;

    test_node(i_node_count => 30);

    l_stop_time := SYSDATE;

    l_elapsed_time_display := f_elapsed_time(i_date1 => l_start_time
                                            ,i_date2 => l_stop_time  );

    ms_logger.info(l_node,  'Elapsed time: ' ||l_elapsed_time_display);
    dbms_output.put_line('Elapsed time: ' ||l_elapsed_time_display);

    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); --DO NOT RAISE;

  END test_internal_error;


  --------------------------------------------------------------------
  --msg_mode_node
  --------------------------------------------------------------------

  PROCEDURE msg_mode_node(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'msg_mode_node');

  BEGIN

    
    ms_logger.param(l_node,'i_node_count',i_node_count );

    ms_logger.comment(l_node,'Comment is not suppressed.');
    ms_logger.info(   l_node,'Info is not suppressed.');
    ms_logger.warning(l_node,'Warning is not suppressed.');
    ms_logger.fatal(  l_node,'Fatal is not suppressed.'); RAISE NO_DATA_FOUND;
 
  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); RAISE;

  END msg_mode_node;
  
  
  --------------------------------------------------------------------
  --max_nest_test
  --------------------------------------------------------------------

  PROCEDURE max_nest_test(i_node_count IN  NUMBER)  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'max_nest_test');

  BEGIN

    
    ms_logger.param(l_node,'i_node_count',i_node_count );
 
    IF i_node_count > 0  THEN
      ms_logger.comment(l_node,'Call recursively to create another node');
      max_nest_test(i_node_count => i_node_count - 1);
    END IF;

    ms_logger.comment(l_node,'Dropping out');
    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); RAISE;

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


    msg_mode_node(i_node_count => 5);

    max_nest_test(i_node_count => 5);

    max_nest_test(i_node_count => 25);

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); --DO NOT RAISE;

  END test_unit_msg_mode;
  
 
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
       ms_logger.oracle_error(l_node); RAISE;
    END;
 
     
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node); --DO NOT RAISE;
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
       ms_logger.oracle_error(l_node); RAISE;
    END;
 
     
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node); --DO NOT RAISE;
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
           ms_logger.oracle_error(l_node); --DO NOT RAISE;
           
        END;
      END LOOP;
      
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node); RAISE;
    END;
 
     
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node); --DO NOT RAISE;
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
           ms_logger.oracle_error(l_node); RAISE;
      END;
      END LOOP;
      
    EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node); RAISE;
    END;
 
   EXCEPTION
     WHEN OTHERS THEN
       ms_logger.oracle_error(l_node); --DO NOT RAISE;
  END;
  
  
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
        ms_logger.oracle_error(l_node); RAISE;
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
        ms_logger.oracle_error(l_node); --DO NOT RAISE;
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
        ms_logger.oracle_error(l_node); --DO NOT RAISE;
  END raise_then_trap_oracle_error;
 
 
  
  --------------------------------------------------------------------
  --test_unit_types
  --------------------------------------------------------------------

  PROCEDURE test_unit_types  IS

    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'test_unit_types');
 
  BEGIN


    
    
    std_single_loop_proc;
    std_loop_fatal;
    special_loop_trap;
    special_loop_raise;
    
    
    
    --BLOCKS
    DECLARE
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'exit_a_block');
 
    BEGIN
    
      
      
      ms_logger.comment(l_node,'Test that popping the block works');
      
      
 
    END; --exit_block_works
    
    DECLARE 
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'block_error_detection');
 
    BEGIN
    
      
      
      ms_logger.fatal(l_node,'Test that error detection in the block works');
      
      
    
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node); --DO NOT RAISE;

    END; --block_error_detection
    
    DECLARE 
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'unit_type_detection');
    
    BEGIN
    
      
      
      ms_logger.comment(l_node,'Test incorrect unit_type is detected.');
      
       
    
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node); --DO NOT RAISE;

    END; --unit_type_detection
    
    DECLARE 
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'unhandled_user_defined_error');
      x_user_def EXCEPTION;

    BEGIN
 
      ms_logger.comment(l_node,'Test an unhandled user defined error is treated differently to the x_error');
      RAISE x_user_def;

      

    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node); --DO NOT RAISE;
    
    END; --unhandled_user_defined_error');
    
    DECLARE 
      l_node ms_logger.node_typ := ms_logger.new_block(g_package_name,'missing_exit_recovery');

    BEGIN
 
      ms_logger.comment(l_node,'Test code recovers when a pop is MISSING.');
 
    EXCEPTION
      WHEN OTHERS THEN
        ms_logger.oracle_error(l_node); --DO NOT RAISE;
    
    END; --missing_exit_recovery');
 
    

  EXCEPTION
    WHEN OTHERS THEN
      ms_logger.oracle_error(l_node); --DO NOT RAISE;
  
  END test_unit_types;
 
END ms_test;
/
show errors;
