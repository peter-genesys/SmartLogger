create or replace view sm_db_context_tree_v as
select 
   decode(parent_call_id,null,'TOPCALL','CALL')                                   node_type    
  ,parent_call_id                                                                 parent_id   
  ,call_id                                                                        id     
  ,case 
    when APEX_UTIL.GET_PREFERENCE('LONG_NAMES') = 'Y' then
      unit_name||' ('||module_name||')'                                           
    else 
      unit_name                                                                   
   end                                                                            title
  ,decode(parent_call_id,null,'fa fa-folder','fa fa-folder-o')                   icon
  ,s.created_date                                                                 session_date
  ,s.*  
from sm_session_call_v s
where (username = lower(v('SM_DB_USER')) OR session_id = v('SM_DB_SESSION'));
 
desc sm_db_context_tree_v;
