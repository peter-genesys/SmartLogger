--Testing the logger can trap errors in Quiet Mode

alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool sm_test_quiet_mode.log

declare
 
 l_node sm_logger.node_typ := sm_logger.new_script('sm_test_quiet_mode' ,'anon');

begin 
 
 sm_api.set_module_quiet(i_module_name => 'sm_log_test');
 
 sm_log_test.test_quiet_mode;
					  

end;	
/	
spool off;
alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  