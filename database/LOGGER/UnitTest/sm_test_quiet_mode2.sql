--alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool sm_test_quiet_mode.log

declare

 
 
begin 

  sm_api.set_module_debug(i_module_name => 'sm_log_test');
 
  sm_log_test.test_quiet_mode(i_param1 => 'DEBUG');

end;	
/	


begin 

  sm_api.set_module_normal(i_module_name => 'sm_log_test');
 
  sm_log_test.test_quiet_mode(i_param1 => 'NORMAL');

end;  
/ 


begin 

  sm_api.set_module_quiet(i_module_name => 'sm_log_test');
 
  sm_log_test.test_quiet_mode(i_param1 => 'QUIET');

end;  
/ 

begin 

  sm_api.set_module_quiet(i_module_name => 'sm_log_test');
 
  sm_log_test.test_quiet_mode_oe(i_param1 => 'QUIET');

end;  
/ 
spool off;
--alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  