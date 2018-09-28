create or replace view sm_context_tree_v as
select 
   a.apex_context_type                                                              node_type    
  ,case 
    when a.apex_context_type = 'SESSION' then a.parent_context_id
    when a.apex_context_type = 'CLONE'   and v('SM_APP_SESSION') =  a.app_session then null
    when a.apex_context_type = 'CLONE'   then a.parent_context_id
    when a.apex_context_type = 'APP'     then a.parent_context_id 
    when a.apex_context_type = 'PAGE'    then a.parent_context_id 
   end                                                                              parent_id 
  ,a.apex_context_id                                                                id 
  ,case 
    when a.apex_context_type = 'SESSION' then 'Session '||a.app_session
    when a.apex_context_type = 'CLONE'   and v('SM_APP_SESSION') =  a.app_session then 'Session '      ||a.app_session
    when a.apex_context_type = 'CLONE'                                            then 'Child Session '||a.app_session
    when a.apex_context_type = 'APP'     then 'F'||a.app_id 
    when a.apex_context_type = 'PAGE'    then 'P'||a.app_page_id  
   end                                                                               short_name
  ,case 
    when a.apex_context_type = 'SESSION' then 'Session '||a.app_session
    when a.apex_context_type = 'CLONE'   and v('SM_APP_SESSION') =  a.app_session then 'Session '      ||a.app_session
    when a.apex_context_type = 'CLONE'                                            then 'Child Session '||a.app_session
    when a.apex_context_type = 'APP'     then 'App '||a.app_id||' '||a.app_alias
    when a.apex_context_type = 'PAGE'    then 'Page '||a.app_page_id||' '||a.app_page_alias 
   end                                                                               long_name
  ,a.created_date                                                                    session_date
  ,s.* --all null columns
from sm_apex_context   a
    ,sm_session_call_v s
where a.app_session = s.module_name (+) --fake outer join, always joins to null sm_session_call_v
and  (a.app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (a.app_session, a.parent_app_session))
union all
select 
  'TOPCALL'                                                                       node_type    
  ,apex_context_id                                                                parent_id   
  ,'C'||call_id||'+'||to_char(app_session)||'+'||app_id||'+'||app_page_id         id       
  ,unit_name                                                                      short_name
  ,unit_name||' ('||module_name||')'                                              long_name 
  ,s.created_date                                                                 session_date
  ,s.*  
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and parent_call_id is null 
union all
select 
  'CALL'                                                                          node_type    
  ,'C'||PARENT_CALL_ID||'+'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID  parent_id    
  ,'C'||CALL_ID||'+'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID         id    
  ,unit_name                                      short_name
  ,unit_name||' ('||module_name||')'              long_name 
  ,s.created_date                                                                 session_date
  ,s.*     
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and PARENT_CALL_ID is not null;


