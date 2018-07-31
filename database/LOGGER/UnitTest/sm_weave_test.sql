alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool sm_weave_test.log

declare

--l_process_id number :=  sm_logger.new_process(i_process_name => 'sm_weave_test.sql'  
--                                             ,i_process_type   => 'SQL SCRIPT' 
--                                             ,i_ext_ref     => 1 
--                                             ,i_comments    => 'Testing the results of the aop_processor package');

 l_node sm_logger.node_typ := sm_logger.new_script('sm_weave_test' ,'anon');			

 l_test varchar2(2000);	
 l_test2 varchar2(2000);	
begin 

 sm_api.set_module_debug(i_module_name => 'sm_weave_test');
 
 sm_weave_test.test1('A','B','C');
					  
					  
 sm_weave_test.test2('A','B',l_test,l_test2,'C');
 
   l_test := sm_weave_test.test3(i_param31 => 'A');
end;	
/	
spool off;
alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  