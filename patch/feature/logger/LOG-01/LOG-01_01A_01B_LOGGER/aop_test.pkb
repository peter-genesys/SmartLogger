create or replace package body aop_test is
  --@AOP_LOG
 
  function test3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
 
 
  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
	l_test varchar2(100) := test3(i_param31 => 'X'); 
  
    procedure test1a(i_param1a1 in varchar2) is
      procedure test1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
 
    begin
 

      null;
	  
	  test1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	test1a(i_param1a1 => i_param11);
	
	test1a(i_param1a1 => i_param12);
	
	test1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure test2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  
end; 
/