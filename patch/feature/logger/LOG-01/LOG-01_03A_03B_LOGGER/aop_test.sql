prompt aop_test.sql

spool aop_test.log

prompt register this script  and the test package (may not need to reg package)
execute ms_logger.register_sql_script('aop_test.sql','10.0');  
execute ms_logger.register_package('aop_test','10.0');

column my_unique_id_var noprint new_val my_unique_id
undefine my_unique_id

select 'AOP_TEST.'||ltrim(ms_process_seq.nextval) my_unique_id_var from dual;
 
--prompt new_process 
set serveroutput on;
execute ms_logger.set_internal_debug;
execute ms_logger.new_process(i_module_name => 'aop_test.sql'  -
                               ,i_unit_name   => 'aop_test.sql' -
                               ,i_ext_ref     => '&&my_unique_id' -
                               ,i_comments    => 'Testing the results of the aop_processor package');

execute aop_test.test1('A','B','C');
					  
					  
execute aop_test.test2('A','B');
	
declare l_test varchar2(2000);	
begin

   l_test := aop_test.test3(i_param31 => 'A');
end;	
/				  
					  