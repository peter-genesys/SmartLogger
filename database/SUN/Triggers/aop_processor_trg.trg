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
  ms_logger.note(l_node,'logger.aop_processor.during_advise',logger.aop_processor.during_advise);
  
  if ora_dict_obj_type = 'PACKAGE BODY'  then
    IF not logger.aop_processor.during_advise then
	  ms_logger.info(l_node,'About to create a job to weave this package body.');
 	  dbms_output.enable(1000000);
	  dbms_output.put_line('AOP_PROCESSOR_TRG: Creating AOP_PROCESSOR Job for '||ora_dict_obj_type||' '||ora_dict_obj_owner||'.'||ora_dict_obj_name); 
 
      -- submit a job to weave new aspects and recompile the package 
      -- as direct compilation is not a legal operation from a system event trigger 
      dbms_job.submit
        ( JOB  => l_job
        , WHAT => 'begin     
                     logger.aop_processor.advise_package
                     ( p_object_name   => '''||ora_dict_obj_name ||''' 
                     , p_object_type   => '''||ora_dict_obj_type ||'''
                     , p_object_owner  => '''||ora_dict_obj_owner||'''
                     );
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
