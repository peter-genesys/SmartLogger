create or replace view ms_process_v2 as 
select p.* 
      ,(select min(traversal_id) from ms_traversal where parent_traversal_id is null and process_id = p.process_id) top_traversal_id
,(select count(*)
from ms_traversal t
    ,ms_message m
where t.process_id = p.process_id
and m.traversal_id = t.traversal_id
and m.msg_level > 2) exception_count
,(select count(*)
from ms_traversal t
    ,ms_message m
where t.process_id = p.process_id
and m.traversal_id = t.traversal_id ) message_count
from ms_process p;
