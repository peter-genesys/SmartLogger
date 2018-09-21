create or replace view sm_call_tree_v as
with extra_nodes as (
select
   'SESSION'                                   node_type
  ,to_char(null)                               parent_id
  ,to_char(app_session)                        id
  ,'Session '||app_session                     short_name
  ,'Session '||app_session  ||' '||lower(max(replace(APP_USER,'nobody','NOBODY'))) long_name --pick "nobody" last  
  ,min(s.call_id)                              call_id      
  from sm_session_call_v s
  where app_session = v('SM_APP_SESSION')
  group by app_session, 'SESSION', to_char(null), to_char(app_session), 'Session '||app_session
  union all
  select
   'APP'                                       node_type
  ,to_char(app_session)                        parent_id
  ,to_char(APP_ID)                             id
  ,'F'||APP_ID                                 short_name
  ,'F'||APP_ID||' '||APP_ALIAS                 long_name
  ,s.call_id                                   call_id     
  from sm_session_call_v s
  where app_session = v('SM_APP_SESSION')
  and PARENT_CALL_ID is null 
  union all
  select
   'PAGE'                                       node_type                      
  ,to_char(APP_ID)                              parent_id               
  ,APP_ID||'+'||APP_PAGE_ID||'+'                id               
  ,'P'||APP_PAGE_ID                             short_name                
  ,'P'||APP_PAGE_ID||' '||APP_PAGE_ALIAS        long_name                           
  ,s.call_id                                    call_id      
  from sm_session_call_v s
  where app_session = v('SM_APP_SESSION')
  and PARENT_CALL_ID is null )
, call_nodes as (
select 
  'CALL'                                          node_type    
  ,APP_ID||'+'||APP_PAGE_ID||'+'||PARENT_CALL_ID  parent_id    
  ,APP_ID||'+'||APP_PAGE_ID||'+'||CALL_ID         id           
  ,unit_name                                      short_name
  ,unit_name||' ('||module_name||')'              long_name 
  ,s.call_id                                      call_id  
  ,to_char(null)                                  lag_id         
  from sm_session_call_v s
  where app_session = v('SM_APP_SESSION'))
select * 
from (
select x.*
      ,LAG(x.id ,1,-1) OVER (ORDER BY x.node_type, x.call_id) lag_id
from extra_nodes x
)
where id <> lag_id
union all
select * from call_nodes;
 