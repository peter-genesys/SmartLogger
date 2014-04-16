CREATE OR REPLACE TRIGGER aop_processor_trg
AFTER CREATE
ON SCHEMA
declare
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_job number;
BEGIN
  if ora_dict_obj_type = 'PACKAGE BODY' and 
     ora_dict_obj_name NOT IN ('AOP_PROCESSOR','MS_LOGGER','MS_METACODE','MS_TEST') then
    add_log('NAME '||ora_dict_obj_name||'TYPE '||ora_dict_obj_type||'OWNER '||ora_dict_obj_owner);
    IF not aop_processor.during_advise then
 
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
