create or replace procedure ins_upd_sm_source(i_sm_source IN sm_source%ROWTYPE) IS
  l_node sm_logger.node_typ := sm_logger.new_proc('aop_processor','ins_upd_sm_source');   
begin
    --update original source
    UPDATE sm_source
    SET   text          = i_sm_source.text  
         ,load_datetime = sysdate
		     ,valid_yn      = i_sm_source.valid_yn    
         ,result        = i_sm_source.result
    WHERE name    = i_sm_source.name
	  AND   type    = i_sm_source.type
    AND   aop_ver = i_sm_source.aop_ver;
 
    IF SQL%ROWCOUNT = 0 THEN
    
      --insert original source
      INSERT INTO sm_source VALUES i_sm_source;
	    sm_logger.comment(l_node, 'Inserted sm_source');
	  
	ELSE
      sm_logger.comment(l_node, 'Updated sm_source');
    
    END IF;
exception
  when others then
    sm_logger.warn_error(l_node);
    raise;
end;
/