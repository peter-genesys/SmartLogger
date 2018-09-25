create or replace view sm_extra_nodes_v as
with extra_nodes as (
  select
   'SESSION'                                   node_type
  ,null                                        parent_id
  ,'S'||app_session                            id
  ,'S'||app_session                            grp_id
  ,'Session '||app_session                     short_name
  ,'Session '||app_session                     long_name   
  ,s.*     
  from sm_session_call_v s
  where ((app_user = UPPER(v('SM_APP_USER')) and parent_app_session is null) OR v('SM_APP_SESSION') = app_session)
  and PARENT_CALL_ID is null 
  union all
  select
   'CLONE'                                     node_type
  ,'S'||parent_app_session                     parent_id
  ,'S'||app_session                            id
  ,'S'||app_session                            grp_id
  ,'Child Session '||app_session               short_name
  ,'Child Session '||app_session               long_name   
  ,s.*     
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') = parent_app_session)
  and PARENT_CALL_ID is null 
  and parent_app_session is not null
  union all
  select
   'APP'                                                 node_type
  ,'S'||app_session                                      parent_id
  ,'A'||app_session||'+'||to_char(APP_ID)||'+'||CALL_ID  id
  ,'A'||app_session||'+'||to_char(APP_ID)                grp_id
  ,'F'||APP_ID                                           short_name
  ,'App '||APP_ID||' '||APP_ALIAS                        long_name
  ,s.*   
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and PARENT_CALL_ID is null 
  union all
  select
   'PAGE'                                                          node_type                      
  ,to_char(null)                                                   parent_id  --determine later           
  ,'P'||app_session||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||CALL_ID   id 
  ,'P'||app_session||'+'||APP_ID||'+'||APP_PAGE_ID                 grp_id               
  ,'P'||APP_PAGE_ID                                                short_name                
  ,'Page '||APP_PAGE_ID||' '||APP_PAGE_ALIAS                       long_name                           
  ,s.*    
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and PARENT_CALL_ID is null )
select * 
from (
select x.*
      ,LAG(x.grp_id ,1,-1) OVER (ORDER BY x.node_type, x.call_id) lag_grp_id
from extra_nodes x
)
where grp_id <> lag_grp_id;