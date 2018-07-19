create or replace package body sm_jot_test as 

  procedure test1 is
  begin
    sm_jotter.comment('test1');
  end;

  procedure test2 is
  begin
    test1;
    sm_jotter.comment('test2');
  end;

  procedure test3 is
  begin
    test2;
    sm_jotter.comment('test3');
  end;
 
end sm_jot_test;
/

execute sm_jot_test.test3;