alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool aop_test.log

declare

l_process_id number :=  ms_logger.new_process(i_process_name => 'aop_test.sql'  
                                             ,i_process_type   => 'SQL SCRIPT' 
                                             ,i_ext_ref     => 1 
                                             ,i_comments    => 'Testing the results of the aop_processor package');

 l_node ms_logger.node_typ := ms_logger.new_script('aop_test' ,'anon');			

 l_test varchar2(2000);	
 l_test2 varchar2(2000);	
begin 

 ms_logger.set_module_debug(i_module_name => 'aop_test');
 
 aop_test.test1('A','B','C');
					  
					  
 aop_test.test2('A','B',l_test,l_test2,'C');
 
   l_test := aop_test.test3(i_param31 => 'A');
end;	
/	
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;			  
					  