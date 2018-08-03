prompt $Id: ms_views.sql 811 2008-05-29 00:40:32Z Demo $

CREATE OR REPLACE VIEW sm_message_vw
AS 
SELECT  message_id     
       ,call_id
       ,name
       ,value
       ,substr(message,1,32000) message --Fix for display in Apex App  
       ,msg_type
       ,msg_level  
       ,time_now       
       ,sm_api.msg_level_string(msg_level)  msg_level_text  
FROM sm_message m
/

CREATE OR REPLACE VIEW sm_unit_call_vw
AS 
SELECT t.call_id               
      ,t.session_id   
      ,t.unit_id               
      ,t.parent_call_id  
      ,m.module_id
      ,m.module_name 
      ,INITCAP(m.module_type)  module_type
      ,u.unit_name          
      ,INITCAP(u.unit_type)    unit_type 
      ,t.msg_mode  msg_mode 
FROM sm_module    m
    ,sm_unit      u
    ,sm_call t
    ,sm_session   p
WHERE m.module_id   = u.module_id
AND   u.unit_id     = t.unit_id
AND   p.session_id  = t.session_id
/

 

CREATE OR REPLACE VIEW sm_call_message_vw
AS 
SELECT t.call_id               
      ,t.session_id   
      ,t.unit_id               
      ,t.parent_call_id   
      ,t.module_name       
      ,t.unit_name         
      ,t.unit_type         
      ,m.message_id       
      ,m.name      
      ,substr(m.message,1,32000) message --Fix for display in Apex App     
      ,m.msg_type      
      ,m.msg_level   
      ,m.time_now    
      ,sm_api.msg_level_string(msg_level)  msg_level_text  
      ,CASE msg_type 
        WHEN 'Message' THEN message
        ELSE RPAD(msg_type,6)||m.name||'=['||m.message||']'
      END                                       message_output
FROM sm_message         m
    ,sm_unit_call_vw  t
WHERE m.call_id = t.call_id
/

 
                                                                                                                           

CREATE OR REPLACE VIEW sm_unit_vw
AS 
SELECT u.* 
      ,DECODE(unit_type,'PROC' ,'Procedure'
                       ,'LOOP' ,'Loop'
                       ,'BLOCK','Block'
                       ,'METH' ,'Method'
                       ,'FUNC' ,'Function'
                       ,'TRIG' ,'Trigger'
                               ,'Unknown') unit_type_desc 
     ,sm_api.unit_call_count(unit_id)                      call_count
     ,sm_api.unit_message_count(unit_id,1)  comment_count
     ,sm_api.unit_message_count(unit_id,2)     info_count                              
     ,sm_api.unit_message_count(unit_id,3)  warning_count  
     ,sm_api.unit_message_count(unit_id,4)    fatal_count                              
     ,sm_api.unit_message_count(unit_id,5)   oracle_count
 FROM sm_unit u
/
 

CREATE OR REPLACE VIEW sm_module_vw
AS 
SELECT  m.module_id      
       ,m.module_name    
       ,m.revision       
       ,m.module_type    
       ,m.auto_wake
       ,m.auto_msg_mode
       ,m.manual_msg_mode
       ,SUM(u.call_count) call_count
       ,SUM(u.comment_count)   comment_count
       ,SUM(u.info_count)      info_count 
       ,SUM(u.warning_count)   warning_count
       ,SUM(u.fatal_count)     fatal_count 
       ,SUM(u.oracle_count)    oracle_count                             
FROM sm_unit_vw  u
    ,sm_module   m
where u.module_id (+) = m.module_id
GROUP BY m.module_id      
        ,m.module_name    
        ,m.revision       
        ,m.module_type    
        ,m.auto_wake
        ,m.auto_msg_mode
        ,m.manual_msg_mode
/

create or replace view sm_session_vw as
select p.*
      ,sm_api.get_plain_text_session_report(i_session_id=>session_id) log_listing
from sm_session p
order by session_id
/




