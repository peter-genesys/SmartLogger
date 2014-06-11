CREATE OR REPLACE FUNCTION F_AOP_TEST(i_module ms_module%ROWTYPE
                                     ,o_unit   out ms_unit%ROWTYPE) return varchar2 is
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
execute logger.aop_processor.reapply_aspect(i_object_name=> 'F_AOP_TEST');