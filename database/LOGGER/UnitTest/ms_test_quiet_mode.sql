alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool ms_test_quiet_mode.log

declare

l_process_id number :=  ms_logger.new_process(i_process_name => 'ms_test_quiet_mode.sql'  
                                             ,i_process_type   => 'SQL SCRIPT' 
                                             ,i_ext_ref     => 1 
                                             ,i_comments    => 'Testing the logger can trap errors in Quite Mode');

 l_node ms_logger.node_typ := ms_logger.new_script('ms_test_quiet_mode' ,'anon');			

 
begin 

 ms_api.set_module_quiet(i_module_name => 'ms_test');
 
 ms_test.test_quiet_mode;
					  

end;	
/	
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  