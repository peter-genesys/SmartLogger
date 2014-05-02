create or replace package body aop_test is
  --@AOP_LOG
 
  function test3(i_param31 in varchar2) return varchar2 is
  begin
    null;
    ms_feedback.comment('Eg of debugging message added by a developer');
    
    <<anon1>>
    declare
      l_temp varchar2(1);
    begin
      null;
      ms_feedback.comment('anon block1');
    end anon1;  
    
    <<anon2>>
    declare
      l_temp varchar2(1);
        
      procedure testz(i_paramz in varchar2 ) is
      begin
        null;
        ms_feedback.comment('testz is nested in anon block2');
      end testz;
        
    begin
      null;
      ms_feedback.comment('anon block2');
      
      testz(i_paramz => 'Z');
      
      declare
        l_temp varchar2(1);
      begin
        null;
        ms_feedback.comment('nested anon block3');
      end;
        
    end;
 
    return i_param31;
  end test3;
 
 
  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
                 ,i_param13 in varchar2) is
  
    l_test varchar2(100) := test3(i_param31 => 'X'); 
  
    procedure test1a(i_param1a1 in varchar2) is
      procedure test1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
        ms_feedback.comment('Should see this comment a 3 times');
      end test1aa;
 
    begin
 
      null;
 
      --This is a single comment with an ignored multi-line comment open /*
      declare
        l_temp varchar2(1);
      begin
        null;
        ms_feedback.comment('anon block');
      end;    
      --This is a single comment with an active multi-line comment close */
 
      test1aa(i_param1aa1 => i_param1a1
             ,i_param1aa2 => 'DUMMY');
 
    end test1a;
 
  begin

    test1a(i_param1a1 => i_param11);
    
    test1a(i_param1a1 => i_param12);
    
    test1a(i_param1a1 => i_param13);
    ms_feedback.info('Routine finished successfully');
 
    null;
  exception
    when others then
      ms_feedback.oracle_error;  
  end test1;
  
  
  procedure test2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
    ms_feedback.comment('About to raise an error');
    raise no_data_found;
    ms_feedback.warning('Should not have reached here.');
  exception
    when others then
      ms_feedback.oracle_error; 
  end test2;
  
  /*
  This is 
  a multi-line comment
  --This is a single comment with an active multi-line comment close */
  
end; 
/