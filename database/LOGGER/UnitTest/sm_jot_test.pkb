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
    x number;
    y number;
  begin
    test2;
    sm_jotter.comment('test3');

    select 1 into x from dual;
    
    y := sm_jotter.f_note_rowcount( i_name => 'select 1 into x from dual');
    sm_jotter.note_rowcount( i_name => 'select 1 into x from dual');
    

  end;

  procedure manual_jotting is
  BEGIN
    
    --This test demonstrates that the on_demand calls starts a new logger session each time. 
    sm_jotter.on_demand(i_debug => true);
    sm_jotter.comment('Manual');
    sm_jotter.on_demand(i_quiet => true);
    sm_jotter.comment('Quiet');
    sm_jotter.on_demand(i_debug => true);
    sm_jotter.comment('Comment');

  END;



 
end sm_jot_test;
/

execute sm_jot_test.test3;