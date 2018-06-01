ALTER SESSION SET 
plscope_settings='IDENTIFIERS:NONE'
/

create or replace package aop_test is
  --@AOP_LOG


 

    TYPE test_typ IS RECORD (
       num      number
      ,name     varchar2(50));

    TYPE test_typ2 IS TABLE OF ms_message%ROWTYPE INDEX BY BINARY_INTEGER;  

    TYPE test_tab_typ IS TABLE of test_typ;


    g_test1 test_typ;
    g_test2 ms_logger.node_typ;
    g_test3 number;
    g_test4 varchar2(100);
    g_test5 ms_message%ROWTYPE;

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

  procedure name_resolution_simple_var;

end; 
/
set pages 1000;
SELECT *
  FROM all_identifiers ai
 WHERE ai.owner = USER 
 --AND ai.object_type = '<program_type>' 
  AND ai.object_name = 'AOP_TEST'
ORDER BY line;

SELECT PLSCOPE_SETTINGS
FROM USER_PLSQL_OBJECT_SETTINGS
 WHERE NAME='AOP_TEST' AND TYPE='PACKAGE';