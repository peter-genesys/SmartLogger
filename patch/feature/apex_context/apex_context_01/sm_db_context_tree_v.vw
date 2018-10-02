create or replace view sm_db_context_tree_v as
select 
  'TOPCALL'                                                                       node_type    
  ,apex_context_id                                                                parent_id   
  ,'C'||call_id||'_'||to_char(app_session)||'_'||app_id||'_'||app_page_id         id     
  ,case 
    when APEX_UTIL.GET_PREFERENCE('LONG_NAMES') = 'Y' then
      unit_name||' ('||module_name||')'                                           
    else 
      unit_name                                                                   
   end                                                                            title
  ,'fa fa-folder'                                                                 icon
  ,s.created_date                                                                 session_date
  ,s.*  
  from sm_session_call_v s
  where (username = UPPER(v('SM_DB_USER')) OR session_id = v('SM_DB_SESSION'))
  and parent_call_id is null 
union all
select 
  'CALL'                                                                          node_type    
  ,'C'||PARENT_CALL_ID||'_'||to_char(app_session)||'_'||APP_ID||'_'||APP_PAGE_ID  parent_id    
  ,'C'||CALL_ID||'_'||to_char(app_session)||'_'||APP_ID||'_'||APP_PAGE_ID         id  
  ,case 
    when APEX_UTIL.GET_PREFERENCE('LONG_NAMES') = 'Y' then
      unit_name||' ('||module_name||')'                                           
    else 
      unit_name                                                                   
   end                                                                            title
  ,'fa fa-folder-o'                                                               icon
  ,s.created_date                                                                 session_date
  ,s.*     
  from sm_session_call_v s
  where (username = UPPER(v('SM_DB_USER')) OR session_id = v('SM_DB_SESSION'))
  and PARENT_CALL_ID is not null;


desc sm_db_context_tree_v;
