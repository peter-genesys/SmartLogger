prompt $Id: ms_views.sql 811 2008-05-29 00:40:32Z Demo $

CREATE OR REPLACE VIEW ms_message_vw
AS 
SELECT  message_id     
       ,traversal_id
       ,name
       ,value
       ,message  
       ,msg_type
       ,msg_level  
       ,time_now       
       ,ms_api.msg_level_string(msg_level)  msg_level_text  
FROM ms_message m
/

CREATE OR REPLACE VIEW ms_unit_traversal_vw
AS 
SELECT t.traversal_id               
      ,t.process_id   
      ,p.ext_ref
      ,t.unit_id               
      ,t.parent_traversal_id  
      ,m.module_id
      ,m.module_name 
      ,INITCAP(m.module_type)  module_type
      ,u.unit_name          
      ,INITCAP(u.unit_type)    unit_type 
      ,t.msg_mode  msg_mode 
FROM ms_module    m
    ,ms_unit      u
    ,ms_traversal t
    ,ms_process   p
WHERE m.module_id   = u.module_id
AND   u.unit_id     = t.unit_id
AND   p.process_id  = t.process_id
/

 

CREATE OR REPLACE VIEW ms_traversal_message_vw
AS 
SELECT t.traversal_id               
      ,t.process_id   
      ,t.ext_ref
      ,t.unit_id               
      ,t.parent_traversal_id   
      ,t.module_name       
      ,t.unit_name         
      ,t.unit_type         
      ,m.message_id       
      ,m.name      
      ,m.message          
      ,m.msg_type      
      ,m.msg_level   
      ,m.time_now    
      ,ms_api.msg_level_string(msg_level)  msg_level_text  
      ,CASE msg_type 
        WHEN 'Message' THEN message
        ELSE RPAD(msg_type,6)||m.name||'=['||m.message||']'
      END                                       message_output
FROM ms_message         m
    ,ms_unit_traversal_vw  t
WHERE m.traversal_id = t.traversal_id
/

 
                                                                                                                           

CREATE OR REPLACE VIEW ms_unit_vw
AS 
SELECT u.* 
      ,DECODE(unit_type,'PROC' ,'Procedure'
                       ,'LOOP' ,'Loop'
                       ,'BLOCK','Block'
                       ,'METH' ,'Method'
                       ,'FUNC' ,'Function'
                       ,'TRIG' ,'Trigger'
                               ,'Unknown') unit_type_desc 
     ,ms_api.unit_traversal_count(unit_id)                      traversal_count
     ,ms_api.unit_message_count(unit_id,1)  comment_count
     ,ms_api.unit_message_count(unit_id,2)     info_count                              
     ,ms_api.unit_message_count(unit_id,3)  warning_count  
     ,ms_api.unit_message_count(unit_id,4)    fatal_count                              
     ,ms_api.unit_message_count(unit_id,5)   oracle_count
 FROM ms_unit u
/
 

CREATE OR REPLACE VIEW ms_module_vw
AS 
SELECT  m.module_id      
       ,m.module_name    
       ,m.revision       
       ,m.module_type    
       ,m.msg_mode
       ,m.open_process
       ,SUM(u.traversal_count) traversal_count
       ,SUM(u.comment_count)   comment_count
       ,SUM(u.info_count)      info_count 
       ,SUM(u.warning_count)   warning_count
       ,SUM(u.fatal_count)     fatal_count 
       ,SUM(u.oracle_count)    oracle_count                             
FROM ms_unit_vw  u
    ,ms_module   m
where u.module_id (+) = m.module_id
GROUP BY m.module_id      
        ,m.module_name    
        ,m.revision       
        ,m.module_type    
        ,m.msg_mode  
        ,m.open_process
/








