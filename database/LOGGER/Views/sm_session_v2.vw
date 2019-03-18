create or replace view sm_session_v2 as 
select s.* 
      ,(select min(call_id) from sm_call where parent_call_id is null and session_id = s.session_id) top_call_id
,(select count(*)
from sm_call t
    ,sm_message m
where t.session_id = s.session_id
and m.call_id = t.call_id
and m.msg_level = 3) warning_count  
,(select count(*)
from sm_call t
    ,sm_message m
where t.session_id = s.session_id
and m.call_id = t.call_id
and m.msg_level > 3) exception_count
,(select count(*)
from sm_call t
    ,sm_message m
where t.session_id = s.session_id
and m.call_id = t.call_id ) message_count
from sm_session s;

