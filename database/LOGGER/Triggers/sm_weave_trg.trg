prompt Enable trigger sm_weave_trg only with care.  Can produce unexpected results. 

CREATE OR REPLACE TRIGGER sm_weave_trg
AFTER CREATE
ON SCHEMA
declare
  l_node sm_logger.node_typ := sm_logger.new_trig('sm_weaver','sm_weave_trg');
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_job number;
 
BEGIN
  sm_logger.note(l_node,'ora_dict_obj_name',ora_dict_obj_name);
  sm_logger.note(l_node,'ora_dict_obj_type',ora_dict_obj_type);
  sm_logger.note(l_node,'ora_dict_obj_owner',ora_dict_obj_owner);
  sm_logger.note(l_node,'sm_weaver.during_advise',sm_weaver.during_advise);

  if ora_dict_obj_type  IN ('FUNCTION'
                           ,'PACKAGE BODY'
                           ,'PROCEDURE'
                           ,'TRIGGER'
                           ,'TYPE BODY')  and 
     ora_dict_obj_name NOT IN ('SM_WEAVER','SM_LOGGER','SM_API','SM_JOTTER') then

    IF not sm_weaver.during_advise and
           sm_weaver.source_weave_now(i_owner => ora_dict_obj_owner
                                         ,i_name  => ora_dict_obj_name
                                         ,i_type  => ora_dict_obj_type) then

      dbms_output.enable(1000000);
      dbms_output.put_line('sm_weave_trg: Creating SM_WEAVER Job for '||ora_dict_obj_type||' '||ora_dict_obj_owner||'.'||ora_dict_obj_name); 
      sm_logger.comment(l_node,'Creating SM_WEAVER Job');
 
      -- submit a job to weave new aspects and recompile the package 
      -- as direct compilation is not a legal operation from a system event trigger 
      dbms_job.submit
        ( JOB  => l_job
        , WHAT => 'begin     
                     sm_weaver.reapply_aspect(i_object_name => '''||ora_dict_obj_name ||''' );
                   end;'
        );
      commit;
      dbms_output.put_line('sm_weave_trg: Successfully created Job.'); 
      sm_logger.info(l_node,'Successfully created Job.');
    else
      sm_logger.comment(l_node,'No SM_WEAVER Job required.');  
    end if;
  end if;
  exception
    when others then
      sm_logger.warn_error(l_node);
    dbms_output.put_line('sm_weave_trg: '||SQLERRM); 
      raise;
END sm_weave_trg;
/

show error;
