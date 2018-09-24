create or replace view sm_call_tree_v as
with extra_nodes as (
select
   'SESSION'                                   node_type
  ,null                                        parent_id
  ,'S'||to_char(app_session)                   id
  ,'Session '||app_session                     short_name
  ,'Session '||app_session                     long_name   
  ,s.*     
  from sm_session_call_v s
  where v('SM_APP_SESSION') = app_session
  union all
select
   'CLONE'                                     node_type
  ,'S'||to_char(parent_app_session)            parent_id
  ,'S'||to_char(app_session)                   id
  ,'Child Session '||app_session               short_name
  ,'Child Session '||app_session               long_name   
  ,s.*     
  from sm_session_call_v s
  where v('SM_APP_SESSION') = parent_app_session
  union all
  select
   'APP'                                            node_type
  ,'S'||to_char(app_session)                        parent_id
  ,'A'||to_char(app_session)||'+'||to_char(APP_ID)  id
  ,'F'||APP_ID                                      short_name
  ,'App '||APP_ID||' '||APP_ALIAS                      long_name
  ,s.*   
  from sm_session_call_v s
  where v('SM_APP_SESSION') in (app_session, parent_app_session)
  and PARENT_CALL_ID is null 
  union all
  select
   'PAGE'                                       node_type                      
  ,'A'||to_char(app_session)||'+'||to_char(APP_ID)   parent_id               
  ,'P'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||CALL_ID   id               
  ,'P'||APP_PAGE_ID                             short_name                
  ,'Page '||APP_PAGE_ID||' '||APP_PAGE_ALIAS        long_name                           
  ,s.*    
  from sm_session_call_v s
  where v('SM_APP_SESSION') in (app_session, parent_app_session)
  and PARENT_CALL_ID is null )
, call_nodes as (
select 
  'CALL'                                          node_type    
  ,'P'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||NVL(PARENT_CALL_ID,CALL_ID)  parent_id    
  ,'C'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||CALL_ID         id           
  ,unit_name                                      short_name
  ,unit_name||' ('||module_name||')'              long_name 
  ,s.* 
  ,to_char(null)                                  lag_id         
  from sm_session_call_v s
  where v('SM_APP_SESSION') in (app_session, parent_app_session))
select * 
from (
select x.*
      ,LAG(x.id ,1,-1) OVER (ORDER BY x.node_type, x.call_id) lag_id
from extra_nodes x
)
where id <> lag_id
union all
select * from call_nodes;