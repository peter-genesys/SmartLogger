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
  

  
  procedure cat1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure cat1a(i_param1a1 in varchar2) is
      procedure cat1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  cat1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	cat1a(i_param1a1 => i_param11);
	
	cat1a(i_param1a1 => i_param12);
	
	cat1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure cat2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function cat3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure dog1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure dog1a(i_param1a1 in varchar2) is
      procedure dog1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  dog1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	dog1a(i_param1a1 => i_param11);
	
	dog1a(i_param1a1 => i_param12);
	
	dog1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure dog2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function dog3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure elephant1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure elephant1a(i_param1a1 in varchar2) is
      procedure elephant1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  elephant1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	elephant1a(i_param1a1 => i_param11);
	
	elephant1a(i_param1a1 => i_param12);
	
	elephant1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure elephant2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function elephant3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  
  procedure kitty1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure kitty1a(i_param1a1 in varchar2) is
      procedure kitty1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  kitty1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	kitty1a(i_param1a1 => i_param11);
	
	kitty1a(i_param1a1 => i_param12);
	
	kitty1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure kitty2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function kitty3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure doggy1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure doggy1a(i_param1a1 in varchar2) is
      procedure doggy1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  doggy1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	doggy1a(i_param1a1 => i_param11);
	
	doggy1a(i_param1a1 => i_param12);
	
	doggy1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure doggy2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function doggy3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure pakky1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure pakky1a(i_param1a1 in varchar2) is
      procedure pakky1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  pakky1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	pakky1a(i_param1a1 => i_param11);
	
	pakky1a(i_param1a1 => i_param12);
	
	pakky1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure pakky2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function pakky3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
procedure wrapper1 is
 
  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
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
  
  function test3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure cat1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure cat1a(i_param1a1 in varchar2) is
      procedure cat1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  cat1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	cat1a(i_param1a1 => i_param11);
	
	cat1a(i_param1a1 => i_param12);
	
	cat1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure cat2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function cat3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure dog1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure dog1a(i_param1a1 in varchar2) is
      procedure dog1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  dog1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	dog1a(i_param1a1 => i_param11);
	
	dog1a(i_param1a1 => i_param12);
	
	dog1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure dog2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function dog3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure elephant1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure elephant1a(i_param1a1 in varchar2) is
      procedure elephant1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  elephant1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	elephant1a(i_param1a1 => i_param11);
	
	elephant1a(i_param1a1 => i_param12);
	
	elephant1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure elephant2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function elephant3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  
  procedure kitty1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure kitty1a(i_param1a1 in varchar2) is
      procedure kitty1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  kitty1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	kitty1a(i_param1a1 => i_param11);
	
	kitty1a(i_param1a1 => i_param12);
	
	kitty1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure kitty2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function kitty3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure doggy1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure doggy1a(i_param1a1 in varchar2) is
      procedure doggy1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  doggy1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	doggy1a(i_param1a1 => i_param11);
	
	doggy1a(i_param1a1 => i_param12);
	
	doggy1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure doggy2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function doggy3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
  procedure pakky1(i_param11 in varchar2
                 ,i_param12 in varchar2
				 ,i_param13 in varchar2) is
  
    procedure pakky1a(i_param1a1 in varchar2) is
      procedure pakky1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin
 
        null;
      end;
	
    begin
 

      null;
	  
	  pakky1aa(i_param1aa1 => i_param1a1
	         ,i_param1aa2 => 'DUMMY');
 
    end;
 
  begin
 
	pakky1a(i_param1a1 => i_param11);
	
	pakky1a(i_param1a1 => i_param12);
	
	pakky1a(i_param1a1 => i_param13);
 
  
    null;
  end;
  
  procedure pakky2(i_param21 in varchar2
                 ,i_param22 in varchar2) is
  begin
    null;
  end;
  
  function pakky3(i_param31 in varchar2) return varchar2 is
  begin
    null;
	return i_param31;
  end;
  
begin
  null;
end;  
  
  
end; 
/