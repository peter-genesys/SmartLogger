CREATE OR REPLACE FUNCTION f_sm_weave_test(i_module sm_module%ROWTYPE
                                          ,o_unit   out sm_unit%ROWTYPE) return varchar2 is
   --@AOP_LOG
  l_var number;
begin
  null;

  --i_module.module_name := 'X';

  FOR l_record IN (select 1 from dual) LOOP
    l_var := 1;
  END LOOP;

  IF l_var = 0 then
    l_var := 1;

  else
    IF l_var = 0 then  
      l_var := 1;
    elsif l_var = 0 then 
      l_var := 1;
    end if;
    l_var := 1;
  end if;

  o_unit.unit_name := 'X';
end;
/
show errors;
execute sm_weaver.reapply_aspect(i_object_name=> 'f_sm_weave_test');