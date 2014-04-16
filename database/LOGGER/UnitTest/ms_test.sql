prompt $Id: ms_test.sql 986 2009-03-25 02:28:50Z Demo $
prompt ms_test
 
set pages 1000;

prompt register this script  and the test package
execute ms_metacode.register_sql_script('ms_test.sql','10.0');  
execute ms_metacode.register_package('ms_test','10.0');
 
prompt start test of internal debugging
set serveroutput on;
execute dbms_output.enable(null);

--execute ms_metacode.set_internal_debug;
--execute ms_test.test_unit_types;
--execute ms_metacode.reset_internal_debug;
 
 
execute ms_test.trap_an_oracle_error;

WHENEVER SQLERROR CONTINUE;

execute ms_test.raise_an_oracle_error;

prompt THERE SHOULD BE AN ERROR [ORA-01403: no data found] ABOVE THIS LINE.

WHENEVER SQLERROR EXIT;

execute ms_test.raise_then_trap_oracle_error;



 
prompt test max recursion raises error and disables package 
execute ms_test.test_node(i_node_count => 22);
 
--execute ms_metacode.reset_internal_debug;
 
prompt Executing test_exception_propagation
execute ms_test.test_exception_propagation(i_number   => 1234    -
                                          ,i_varchar2 => 'ABCD'  -
                                          ,i_date     => SYSDATE -
                                          ,i_boolean  => FALSE);
prompt end test of internal debugging

prompt Setting message level at QUIET - test that exceptions still work
prompt Enabling test_unit_msg_mode
execute ms_metacode.set_unit_quiet(i_module_name => 'ms_test'   -
                                  ,i_unit_name   => 'error_node');
  
prompt Executing test_exception_propagation
execute ms_test.test_exception_propagation(  i_number   => 1234    -
                                            ,i_varchar2 => 'ABCD'  -
                                            ,i_date     => SYSDATE -
                                            ,i_boolean  => FALSE);
 
column my_unique_id_var noprint new_val my_unique_id
undefine my_unique_id

select 'MSTEST.'||ltrim(apex_access_control_seq.nextval) my_unique_id_var from dual;
 
prompt new_process 
execute ms_metacode.set_internal_debug;
execute ms_metacode.new_process(i_module_name => 'ms_test.sql'  -
                               ,i_unit_name   => 'ms_test.sql' -
                               ,i_ext_ref     => '&&my_unique_id' -
                               ,i_comments    => 'Testing the metacode package');

--set serveroutput on;
 
DECLARE
  l_node ms_logger.node_typ := ms_logger.new_block('ms_test.sql','master_block');  
 
BEGIN
 
  ms_metacode.set_unit_debug(i_module_name => 'ms_test'                
                            ,i_unit_name   => 'error_node');
                                  


  ms_test.test_message_tree(i_number   => 1234     
                          ,i_varchar2 => 'ABCD'  
                          ,i_date     => SYSDATE  
                          ,i_boolean  => FALSE);
                                  
  ms_metacode.set_unit_debug(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;

 
  ms_metacode.set_unit_normal(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;
 


  ms_metacode.set_unit_quiet(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;
 

  --ms_metacode.set_internal_debug;
  ms_test.test_unit_types;
  --ms_metacode.reset_internal_debug;
  
  --PRISM SPECIFIC (add_log)
  --add_log('MS_TEST.SQL: '||dbms_utility.format_call_stack);
   
  ms_test.test_internal_error;
 

EXCEPTION
  WHEN OTHERS THEN
    ms_logger.oracle_error(l_node); --DO NOT RAISE;
END;
/
execute ms_metacode.reset_internal_debug;

--execute ms_test.test_internal_error;
 
prompt Ext Ref is &&my_unique_id

SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
FROM ms_unit_traversal_vw
WHERE ext_ref = '&&my_unique_id'
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id;

prompt Show all
SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
||chr(10)||(SELECT listagg('**'||name||':'||value,chr(10)) within group (order by traversal_id) from ms_reference where traversal_id = t.traversal_id)
||chr(10)||(SELECT listagg('--'||message,chr(10)) within group (order by message_id) from ms_message where traversal_id = t.traversal_id)
FROM ms_unit_traversal_vw t
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id; 
 

