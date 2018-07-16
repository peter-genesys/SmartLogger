alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool ms_test_ondemand_mode.log

declare

 
 
begin 

 ms_api.set_module_quiet(i_module_name => 'ms_test');
 
 ms_test.test(i_logger_debug => true);


					  

end;	
/	
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  