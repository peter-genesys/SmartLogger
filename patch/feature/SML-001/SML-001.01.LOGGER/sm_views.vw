prompt $Id: ms_views.sql 811 2008-05-29 00:40:32Z Demo $

CREATE OR REPLACE VIEW sm_message_vw
AS 
SELECT  m.message_id
       ,m.call_id
       ,m.name
       ,m.value
       ,substr(m.message,1,32000) message --Fix for display in Apex App 
       ,m.msg_type
       ,m.msg_level
       ,m.time_now      
       ,sm_api.msg_level_string(msg_level)  msg_level_text  
       ,CASE msg_type 
          WHEN 'Message' THEN message
          ELSE RPAD(msg_type,6)||m.name||'=['||m.message||']'
       END                                  message_output
FROM sm_message m
/
 
CREATE OR REPLACE VIEW sm_call_v
AS 
SELECT c.call_id               
      ,c.session_id   
      ,c.unit_id               
      ,c.parent_call_id  
      ,c.msg_mode  
      ,m.module_id
      ,m.module_name 
      ,INITCAP(m.module_type)  module_type
      ,u.unit_name          
      ,INITCAP(u.unit_type)    unit_type 
FROM sm_module    m
    ,sm_unit      u
    ,sm_call      c
WHERE m.module_id   = u.module_id
AND   u.unit_id     = c.unit_id
/
 
CREATE OR REPLACE VIEW sm_unit_call_vw --DEPRECATED
AS 
SELECT * 
from sm_call_v
/
 
CREATE OR REPLACE VIEW sm_session_call_v
AS 
SELECT s.*
      ,c.call_id               
      ,c.unit_id               
      ,c.parent_call_id  
      ,c.msg_mode  
      ,c.module_id
      ,c.module_name 
      ,c.module_type
      ,c.unit_name          
      ,c.unit_type 
FROM sm_call_v       c
    ,sm_session       s
WHERE s.session_id  = c.session_id
/
 
 
CREATE OR REPLACE VIEW sm_call_message_vw
AS 
SELECT c.*       
      ,m.message_id
      ,m.name
      ,m.value
      ,m.message  
      ,m.msg_type
      ,m.msg_level
      ,m.time_now      
      ,m.msg_level_text  
      ,m.message_output
FROM sm_message_vw   m
    ,sm_call_v    c
WHERE m.call_id = c.call_id
/

CREATE OR REPLACE VIEW sm_session_message_v
AS 
SELECT sc.*       
      ,m.message_id
      ,m.name
      ,m.value
      ,m.message  
      ,m.msg_type
      ,m.msg_level
      ,m.time_now      
      ,m.msg_level_text  
      ,m.message_output
FROM sm_message_vw   m
    ,sm_session_call_v    sc
WHERE m.call_id = sc.call_id
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
select s.*
      ,sm_api.get_plain_text_session_report(i_session_id=>session_id) log_listing
from sm_session s
order by session_id
/




