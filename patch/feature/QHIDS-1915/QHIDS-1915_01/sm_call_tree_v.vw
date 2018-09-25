create or replace view sm_call_tree_v as
with call_nodes as (
select 
  'TOPCALL'                                                                       node_type    
  ,to_char(null)                                                                  parent_id  --determine later  
  ,'C'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||CALL_ID         id 
  ,to_char(null)                                                                  grp_id            
  ,unit_name                                      short_name
  ,unit_name||' ('||module_name||')'              long_name 
  ,s.*  
  ,to_char(null)                                                                  lag_grp_id   
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and PARENT_CALL_ID is null 
union all
select 
  'CALL'                                                                          node_type    
  ,'C'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||PARENT_CALL_ID  parent_id    
  ,'C'||to_char(app_session)||'+'||APP_ID||'+'||APP_PAGE_ID||'+'||CALL_ID         id    
  ,to_char(null)                                                                  grp_id  
  ,unit_name                                      short_name
  ,unit_name||' ('||module_name||')'              long_name 
  ,s.*     
  ,to_char(null)                                                                  lag_grp_id   
  from sm_session_call_v s
  where (app_user = UPPER(v('SM_APP_USER')) OR v('SM_APP_SESSION') in (app_session, parent_app_session))
  and PARENT_CALL_ID is not null 
  )
, all_nodes as (  
select * 
from sm_extra_nodes_v
union all
select * from call_nodes)
select 
 node_type    
,sm_call_tree_parent_id(i_node_type   => node_type  
                       ,i_app_session => app_session 
                       ,i_app_id      => app_id      
                       ,i_app_page_id => app_page_id 
                       ,i_call_id     => call_id     
                       ,i_parent_id   => parent_id    ) parent_id    
,id    
,short_name
,long_name 
,session_id        
,origin            
,username          
,internal_error    
,notified_flag     
,error_message     
,created_date      
,updated_date      
,keep_yn           
,app_user          
,app_user_fullname 
,app_user_email    
,app_session       
,app_id            
,app_alias         
,app_title         
,app_page_id       
,app_page_alias    
,parent_app_session
,call_id           
,unit_id           
,parent_call_id    
,msg_mode          
,module_id         
,module_name       
,module_type       
,unit_name         
,unit_type   
from all_nodes;      