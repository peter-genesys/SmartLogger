create or replace package aop_test is
  --@AOP_LOG


    TYPE test_typ IS RECORD (
       num      number
      ,name     varchar2(50));


  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2);
  
  procedure test2(i_param21 in varchar2
                 ,i_param22 in varchar2
				         ,o_param23 out varchar2
				         ,io_param24 in out varchar2
				         ,i_param25 varchar2);
  
  function test3(i_param31 in varchar2) return varchar2 RESULT_CACHE;
 
  FUNCTION test5 RETURN VARCHAR2;

end; 
/

