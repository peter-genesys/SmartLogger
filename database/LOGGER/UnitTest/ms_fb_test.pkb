create or replace package body ms_fb_test as 

  procedure test1 is
  begin
    ms_feedback.comment('test1');
  end;

  procedure test2 is
  begin
    test1;
    ms_feedback.comment('test2');
  end;

  procedure test3 is
  begin
    test2;
    ms_feedback.comment('test3');
  end;
 
end ms_fb_test;
/

execute ms_fb_test.test3;