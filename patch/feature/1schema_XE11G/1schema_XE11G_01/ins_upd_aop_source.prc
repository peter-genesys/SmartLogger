create or replace procedure ins_upd_aop_source(i_aop_source IN aop_source%ROWTYPE) IS
  l_node ms_logger.node_typ := ms_logger.new_proc('aop_processor','ins_upd_aop_source');   
begin
    --update original source
    UPDATE aop_source
    SET   text          = i_aop_source.text  
         ,load_datetime = sysdate
		 ,valid_yn      = i_aop_source.valid_yn    
         ,result        = i_aop_source.result
    WHERE name    = i_aop_source.name
	AND   type    = i_aop_source.type
    AND   aop_ver = i_aop_source.aop_ver;
 
    IF SQL%ROWCOUNT = 0 THEN
    
      --insert original source
      INSERT INTO aop_source VALUES i_aop_source;
	  ms_logger.comment(l_node, 'Inserted aop_source');
	  
	ELSE
      ms_logger.comment(l_node, 'Updated aop_source');
    
    END IF;
exception
  when others then
    ms_logger.warn_error(l_node);
    raise;
end;
/