prompt Enable trigger aop_processor_trg only with care.  Can produce unexpected results. 
/*
CREATE OR REPLACE TRIGGER aop_processor_trg
AFTER CREATE
ON SCHEMA
declare
  l_node ms_logger.node_typ := ms_logger.new_trig('aop_processor','aop_processor_trg');
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_job number;
BEGIN
  ms_logger.note(l_node,'ora_dict_obj_name',ora_dict_obj_name);
  ms_logger.note(l_node,'ora_dict_obj_type',ora_dict_obj_type);
  ms_logger.note(l_node,'ora_dict_obj_owner',ora_dict_obj_owner);
  ms_logger.note(l_node,'aop_processor.during_advise',aop_processor.during_advise);
 
  if ora_dict_obj_type  IN ('FUNCTION'
                           ,'PACKAGE BODY'
                           ,'PROCEDURE'
                           ,'TRIGGER'
                           ,'TYPE BODY')  and 
     ora_dict_obj_name NOT IN ('AOP_PROCESSOR','MS_LOGGER','MS_METACODE','MS_TEST') then

    IF not aop_processor.during_advise then
    dbms_output.enable(1000000);
    dbms_output.put_line('AOP_PROCESSOR_TRG: Creating AOP_PROCESSOR Job for '||ora_dict_obj_type||' '||ora_dict_obj_owner||'.'||ora_dict_obj_name); 
 
      -- submit a job to weave new aspects and recompile the package 
      -- as direct compilation is not a legal operation from a system event trigger 
      dbms_job.submit
        ( JOB  => l_job
        , WHAT => 'begin     
                     aop_processor.reapply_aspect(i_object_name => '''||ora_dict_obj_name ||''' );
                   end;'
        );
      commit;
    dbms_output.put_line('AOP_PROCESSOR_TRG: Successfully created Job.'); 
    end if;
  end if;
  exception
    when others then
      ms_logger.warn_error(l_node);
    dbms_output.put_line('AOP_PROCESSOR_TRG: '||SQLERRM); 
      raise;
END aop_processor_trg;
/
*/
