create or replace package aop_test is
  --@AOP_LOG
  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2);
  
  procedure test2(i_param21 in varchar2
                 ,i_param22 in varchar2);
  
  function test3(i_param31 in varchar2) return varchar2;
 
end; 
/