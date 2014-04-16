prompt $Id: ms_views.sql 811 2008-05-29 00:40:32Z Demo $

CREATE OR REPLACE VIEW ms_message_vw
AS 
SELECT  message_id     
       ,traversal_id
       ,message  
       ,to_char(null) name
       ,to_char(null) value
       ,to_char(null) descr  
       ,msg_level  
       ,'Normal'   msg_type	  
       ,time_now       
       ,ms_metacode.msg_level_string(msg_level)   msg_level_text  
FROM ms_message m
UNION ALL
SELECT  message_id     
       ,traversal_id
       ,message  
       ,to_char(null) --name
       ,to_char(null) --value
       ,to_char(null) --descr  
       ,msg_level    
       ,'Large'   msg_type	     
       ,time_now       
       ,ms_metacode.msg_level_string(msg_level)   msg_level_text  
FROM ms_large_message m
UNION ALL
SELECT  message_id  
       ,traversal_id
       ,message  
       ,to_char(null) --name
       ,to_char(null) --value
       ,to_char(null) --descr  
       ,msg_level  
       ,'Internal'   msg_type	     
       ,time_now  
       ,ms_metacode.msg_level_string(msg_level)   msg_level_text  
FROM ms_internal_error e
UNION ALL
SELECT  message_id  
       ,traversal_id                                                                                                   
	   ,NULL
       ,r.name
	   ,r.value
	   ,r.descr  
       ,0                                                                     --msg_level comment	
       ,DECODE(r.param_ind,'Y','Param ','Note')                               --msg_type		   
       ,null                                                                  --time_now
       ,ms_metacode.msg_level_string(0)                                       --msg_level_text
FROM ms_reference r
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
     ,ms_metacode.unit_traversal_count(unit_id)                      traversal_count
     ,ms_metacode.unit_message_count(unit_id 
                                    ,ms_metacode.msg_level_comment)  comment_count
     ,ms_metacode.unit_message_count(unit_id 
                                    ,ms_metacode.msg_level_info)     info_count                              
     ,ms_metacode.unit_message_count(unit_id 
                                    ,ms_metacode.msg_level_warning)  warning_count  
     ,ms_metacode.unit_message_count(unit_id 
                                    ,ms_metacode.msg_level_fatal)    fatal_count                              
     ,ms_metacode.unit_message_count(unit_id 
                                    ,ms_metacode.msg_level_oracle)   oracle_count                                 
FROM ms_unit u
/
/*
CREATE OR REPLACE VIEW ms_module_vw
AS 
SELECT module_name          
      ,MAX(node_ind)      node_ind
      ,MAX(msg_level)       msg_level 
      ,SUM(traversal_count) traversal_count
      ,SUM(comment_count)   comment_count
      ,SUM(info_count)      info_count 
      ,SUM(warning_count)   warning_count
      ,SUM(fatal_count)     fatal_count 
      ,SUM(oracle_count)    oracle_count                             
FROM ms_unit_vw
GROUP BY module_name
/
*/

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
      ,m.message          
      ,m.msg_level   
      ,m.time_now    
      ,m.msg_level_text 
FROM ms_message_vw         m
    ,ms_unit_traversal_vw  t
WHERE m.traversal_id = t.traversal_id
/

CREATE OR REPLACE VIEW ms_traversal_reference_vw
AS 
SELECT t.traversal_id
      ,t.process_id   
      ,t.ext_ref
      ,t.unit_id
      ,t.parent_traversal_id
      ,t.module_name
      ,t.unit_name
      ,t.unit_type
	  ,r.message_id
      ,r.name           
      ,r.value          
      ,r.descr          
      ,r.param_ind            
FROM ms_reference          r
    ,ms_unit_traversal_vw  t
WHERE r.traversal_id = t.traversal_id
/
 
CREATE OR REPLACE VIEW ms_traversal_message_ref_vw
AS 
SELECT m.traversal_id               
      ,m.process_id   
      ,m.ext_ref
      ,m.unit_id               
      ,m.parent_traversal_id   
      ,m.module_name       
      ,m.unit_name         
      ,m.unit_type         
      ,m.message_id       
      ,m.message          
      ,m.msg_level   
      ,m.time_now    
      ,m.msg_level_text 
FROM ms_traversal_message_vw m
UNION ALL  
SELECT r.traversal_id                                                                                                       
      ,r.process_id                                                                                                        
      ,r.ext_ref                                                                                                           
      ,r.unit_id                                                                                                            
      ,r.parent_traversal_id                                                                                                
      ,r.module_name                                                                                                       
      ,r.unit_name                                                                                                         
      ,r.unit_type                                                                                                         
	  ,r.message_id                                                                                                        
      ,DECODE(r.param_ind,'Y','PARAM ','NOTE  ')||r.name||'['||r.value||']'||DECODE(r.descr,NULL,NULL,':'||r.descr)        
      ,1 --comment	     
      ,null
	  ,ms_metacode.msg_level_string (1)
FROM ms_traversal_reference_vw r;                                                                                          
                                                                                                                           












