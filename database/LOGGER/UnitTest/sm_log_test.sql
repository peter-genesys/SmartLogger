
prompt sm_log_test

set timing on
 
set pages 1000;
 
spool sm_log_test.log

alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings 

 
prompt start test of internal debugging
set serveroutput on;
 
column my_unique_id_var noprint new_val my_unique_id
undefine my_unique_id

select 'MSTEST.'||ltrim(sm_session_seq.nextval) my_unique_id_var from dual;
 DECLARE

l_process_id number :=  sm_logger.new_session(i_process_name   => 'sm_log_test.sql'  
                                             ,i_process_type   => 'SQL SCRIPT' 
                                             ,i_ext_ref        => '&&my_unique_id' 
                                             ,i_comments       => 'Testing the sm_logger package');  

   l_node sm_logger.node_typ := sm_logger.new_script('sm_log_test' ,'anon');      
BEGIN

  sm_api.set_module_debug(i_module_name => 'sm_log_test');  

  sm_log_test.test_unit_types;

  sm_log_test.test_call_stack;
  
 
 
  sm_log_test.test_call_tree(i_node_count => 20);
  
  sm_log_test.test_tree;
 
  sm_api.set_unit_debug(i_module_name => 'sm_log_test'                
                       ,i_unit_name   => 'error_node');
                                  


  sm_log_test.test_message_tree(i_number   => 1234     
                          ,i_varchar2 => 'ABCD'  
                          ,i_date     => SYSDATE  
                          ,i_boolean  => FALSE);
                                  
  sm_api.set_unit_debug(i_module_name => 'sm_log_test'                 
                       ,i_unit_name   => 'msg_mode_node');
  sm_log_test.test_unit_msg_mode;

 
  sm_api.set_unit_normal(i_module_name => 'sm_log_test'                 
                        ,i_unit_name   => 'msg_mode_node');
  sm_log_test.test_unit_msg_mode;
 


  sm_api.set_unit_quiet(i_module_name => 'sm_log_test'                 
                       ,i_unit_name   => 'msg_mode_node');
  sm_log_test.test_unit_msg_mode;
 

  sm_log_test.test_unit_types;
 
  sm_log_test.test_internal_error;
 
 
END;
/
 
 
prompt Ext Ref is &&my_unique_id

SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
FROM sm_unit_call_vw
WHERE ext_ref = '&&my_unique_id'
START WITH parent_call_id IS NULL
CONNECT BY PRIOR call_id = parent_call_id
ORDER SIBLINGS BY call_id;

prompt Show all
SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
||chr(10)||(SELECT listagg('**'||name||':'||value,chr(10)) within group (order by call_id) from sm_message where call_id = t.call_id and msg_type in ('PARAM','NOTE'))
||chr(10)||(SELECT listagg('--'||message,chr(10)) within group (order by message_id) from sm_message where call_id = t.call_id and msg_type not in ('PARAM','NOTE')) as text             
FROM sm_unit_call_vw t
START WITH parent_call_id IS NULL
CONNECT BY PRIOR call_id = parent_call_id
ORDER SIBLINGS BY call_id; 


alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings  
 
spool off;
