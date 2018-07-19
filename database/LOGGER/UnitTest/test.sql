--test.sql
set serveroutput on;
DECLARE


  procedure nested_block_scope is
    l_var number;
  BEGIN
    
    l_var := 1;

    DECLARE  
      l_var number;
    BEGIN
      l_var := 1;
    END;

    <<test_block>>
    DECLARE  
      l_var number;
    BEGIN
      test_block.l_var := 1;
    END;

 
    <<test_block2>>
    if true then
      declare 
        x number;
      BEGIN
        test_block2.x := 2;
        dbms_output.put_line('test_block2.x='||test_block2.x);
      END;
    end if;  

    <<test_block2a>>
    null;
    <<test_block3>>
    declare
      l_var number;
    BEGIN
      test_block3.l_var := 1;
      dbms_output.put_line('test_block3.l_var='||test_block3.l_var);
      test_block2a.l_var := 2;
      dbms_output.put_line('test_block2a.l_var='||test_block2a.l_var);
      test_block2a.l_var := 2;
      --dbms_output.put_line('test_block2.l_var='||test_block2.l_var);
      --dbms_output.put_line('test_block.l_var='||test_block.l_var);
    END;

  END;

 BEGIN
   nested_block_scope;
 end;
 / 