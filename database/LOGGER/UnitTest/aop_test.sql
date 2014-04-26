prompt aop_test.sql

spool F:\SmartLogger\database\LOGGER\UnitTest\aop_test.log

prompt register this script  and the test package (may not need to reg package)
execute ms_logger.register_sql_script('aop_test.sql','10.0');  
execute ms_logger.register_package('aop_test','10.0');

execute aop_test.test1('A','B','C');
					  
					  
execute aop_test.test2('A','B');
	
declare l_test varchar2(2000);	
begin

   l_test := aop_test.test3(i_param31 => 'A');
end;	
/				  
					  