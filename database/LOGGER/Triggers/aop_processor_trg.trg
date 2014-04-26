CREATE OR REPLACE TRIGGER aop_processor_trg
AFTER CREATE
ON SCHEMA
declare
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_job number;
BEGIN
  if ora_dict_obj_type = 'PACKAGE BODY' and 
     ora_dict_obj_name NOT IN ('AOP_PROCESSOR','MS_LOGGER','MS_METACODE','MS_TEST') then

    IF not aop_processor.during_advise then
 	  dbms_output.enable(1000000);
	  dbms_output.put_line('AOP_PROCESSOR_TRG Create AOP_PROCESSOR Job for '||ora_dict_obj_type||' '||ora_dict_obj_name); 
 
      -- submit a job to weave new aspects and recompile the package 
      -- as direct compilation is not a legal operation from a system event trigger 
      dbms_job.submit
        ( JOB  => l_job
        , WHAT => 'begin     
                     aop_processor.advise_package
                     ( p_object_name   => '''||ora_dict_obj_name ||''' 
                     , p_object_type   => '''||ora_dict_obj_type ||'''
                     , p_object_owner  => '''||ora_dict_obj_owner||'''
                     );
                   end;'
        );
      commit;
    end if;
  end if;
END aop_processor_trg;
/
