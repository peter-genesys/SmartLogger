alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;
spool  sm_log_test3.log;
declare
  --THIS IS A DEPRECATED METHOD
  --l_process_id NUMBER :=  sm_logger.new_process(i_process_name => 'sm_log_test3.sql'  
  --                                             ,i_process_type   => 'SQL SCRIPT' 
  --                                             ,i_ext_ref     => null
  --                                             ,i_comments    => 'Testing the sm_logger package'); 
  l_node sm_logger.node_typ := sm_logger.new_script('sm_log_test3' ,'anon');										   
											   
BEGIN
  --Test message modes
  sm_api.set_unit_quiet(i_module_name => 'sm_log_test'                 
                          ,i_unit_name   => 'msg_mode_node');
  sm_api.set_unit_quiet(i_module_name => 'sm_log_test'                 
                          ,i_unit_name   => 'test_unit_msg_mode');
  sm_api.set_unit_quiet(i_module_name => 'sm_log_test'                 
                          ,i_unit_name   => 'max_nest_test');

  sm_log_test.test_unit_msg_mode;

  sm_api.set_unit_debug(i_module_name => 'sm_log_test'                 
                          ,i_unit_name   => 'msg_mode_node');
  sm_api.set_unit_debug(i_module_name => 'sm_log_test'                 
                          ,i_unit_name   => 'test_unit_msg_mode');
  sm_api.set_unit_debug(i_module_name => 'sm_log_test'                 
                          ,i_unit_name   => 'max_nest_test');
 
  sm_log_test.test_unit_msg_mode;
END;
/
spool off;
alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;
  