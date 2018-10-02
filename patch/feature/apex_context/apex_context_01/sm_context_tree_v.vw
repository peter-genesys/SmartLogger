create or replace view sm_apex_context_v as
select 
   apex_context_type                                                              node_type    
  ,case 
    when apex_context_type = 'SESSION' then parent_context_id
    when apex_context_type = 'CLONE'   and v('SM_APP_SESSION') =  app_session then null
    when apex_context_type = 'CLONE'   and APEX_UTIL.GET_PREFERENCE('CLONE_AS_SIBLING') = 'Y' then null
    when apex_context_type = 'CLONE'   then parent_context_id
    when apex_context_type = 'APP'     then parent_context_id 
    when apex_context_type = 'PAGE'    then parent_context_id 
   end                                                                              parent_id 
  ,apex_context_id                                                                id 
  ,case 
    when APEX_UTIL.GET_PREFERENCE('LONG_NAMES') = 'Y' then
      case 
        when apex_context_type = 'SESSION' then 'Session '||app_session
        when apex_context_type = 'CLONE'   and v('SM_APP_SESSION') =  app_session               then 'Clone Session '||app_session
        when apex_context_type = 'CLONE'   and APEX_UTIL.GET_PREFERENCE('CLONE_AS_SIBLING') = 'Y' then 'Clone Session '||app_session
        when apex_context_type = 'CLONE'                                                          then 'Child Session '||app_session
        when apex_context_type = 'APP'     then 'App '||app_id||' '||app_alias
        when apex_context_type = 'PAGE'    then 'Page '||app_page_id||' '||app_page_alias 
      end                                                                                
    else  
      case 
        when apex_context_type = 'SESSION' then 'Session '||app_session
        when apex_context_type = 'CLONE'   and v('SM_APP_SESSION') =  app_session               then 'Clone Session '||app_session
        when apex_context_type = 'CLONE'   and APEX_UTIL.GET_PREFERENCE('CLONE_AS_SIBLING') = 'Y' then 'Clone Session '||app_session
        when apex_context_type = 'CLONE'                                                          then 'Child Session '||app_session
        when apex_context_type = 'APP'     then 'F'||app_id 
        when apex_context_type = 'PAGE'    then 'P'||app_page_id  
      end      
   end                                                                               title
  ,case 
     when apex_context_type = 'SESSION' then 'fa fa-user-circle'
     when apex_context_type = 'CLONE'   then 'fa fa-user-circle-o'
     when apex_context_type = 'APP'     then 'fa fa-book'
     when apex_context_type = 'PAGE'    then 'fa fa-file-o'
   end                                                                               icon
  ,created_date                                                                    session_date
from sm_apex_context   
where app_user = NVL(UPPER(v('SM_APP_USER')),app_user)
and   NVL(v('SM_APP_SESSION'),app_session) in (app_session, parent_app_session);


create or replace view sm_context_tree_v as
select 
   a.*
  ,s.* --all null columns
from sm_apex_context_v   a
    ,sm_session_call_v s
where a.node_type = s.module_type (+) --fake outer join, always joins to null sm_session_call_v
union all
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
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
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
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and PARENT_CALL_ID is not null;


desc sm_context_tree_v;
