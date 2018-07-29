--Testing the logger can trap errors in Quiet Mode

alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool sm_test_quiet_mode.log

declare

--_process_id number :=  sm_logger.new_process(i_process_name => 'sm_test_quiet_mode.sql'  
--                                            ,i_process_type   => 'SQL SCRIPT' 
--                                            ,i_ext_ref     => 1 
--                                            ,i_comments    => 'Testing the logger can trap errors in Quiet Mode');

 l_node sm_logger.node_typ := sm_logger.new_script('sm_test_quiet_mode' ,'anon');

begin 
 
 sm_api.set_module_quiet(i_module_name => 'sm_log_test');
 
 sm_log_test.test_quiet_mode;
					  

end;	
/	
spool off;
alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  