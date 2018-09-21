--alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool sm_test_ondemand_mode.log

declare

 
 
begin 

  sm_api.set_module_debug(i_module_name => 'sm_log_test');
 
  sm_log_test.test(i_logger_debug => false);

end;	
/	
spool off;
--alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  