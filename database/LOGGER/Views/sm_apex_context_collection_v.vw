create or replace view sm_apex_context_collection_v as 
--Matches structure of table sm_apex_context
select c001  apex_context_id  
      ,c002  apex_context_type
      ,c003  parent_context_id 
      ,c004  app_user          
      ,c005  app_user_fullname 
      ,c006  app_user_email    
      ,c007  app_session    
      ,c008  parent_app_session
      ,c009  app_id            
      ,c010  app_alias         
      ,c011  app_title         
      ,c012  app_page_id       
      ,c013  app_page_alias  
      ,d001  created_date
      ,d002  updated_date
from apex_collections
where collection_name = 'APEX_CONTEXT';
