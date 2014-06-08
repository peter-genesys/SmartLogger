--prompt new_process 
alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;
spool c:\ms_test.log;
declare
  l_process_id NUMBER :=  ms_logger.new_process(i_process_name => 'ms_test.sql'  
                                               ,i_process_type   => 'SQL SCRIPT' 
                                               ,i_ext_ref     => null
                                               ,i_comments    => 'Testing the ms_logger package'); 
  l_node ms_logger.node_typ := ms_logger.new_script('ms_test' ,'anon');										   
											   
BEGIN
  
  ms_logger.set_unit_quiet(i_module_name => 'ms_test'                 
                          ,i_unit_name   => 'msg_mode_node');
  ms_logger.set_unit_quiet(i_module_name => 'ms_test'                 
                          ,i_unit_name   => 'test_unit_msg_mode');
  ms_logger.set_unit_quiet(i_module_name => 'ms_test'                 
                          ,i_unit_name   => 'max_nest_test');

							
  ms_logger.set_internal_debug;
  ms_test.test_unit_msg_mode;

  ms_logger.set_unit_debug(i_module_name => 'ms_test'                 
                          ,i_unit_name   => 'msg_mode_node');
  ms_logger.set_unit_debug(i_module_name => 'ms_test'                 
                          ,i_unit_name   => 'test_unit_msg_mode');
  ms_logger.set_unit_debug(i_module_name => 'ms_test'                 
                          ,i_unit_name   => 'max_nest_test');
 
  ms_test.test_unit_msg_mode;
END;
/
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;
  