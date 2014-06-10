
prompt ms_test

set timing on
 
set pages 1000;
 
spool ms_test.log

alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings 

 
prompt start test of internal debugging
set serveroutput on;
 
column my_unique_id_var noprint new_val my_unique_id
undefine my_unique_id

select 'MSTEST.'||ltrim(ms_process_seq.nextval) my_unique_id_var from dual;
 DECLARE

l_process_id number :=  ms_logger.new_process(i_process_name   => 'ms_test.sql'  
                                             ,i_process_type   => 'SQL SCRIPT' 
                                             ,i_ext_ref        => '&&my_unique_id' 
                                             ,i_comments       => 'Testing the ms_logger package');  

   l_node ms_logger.node_typ := ms_logger.new_script('ms_test' ,'anon');      
BEGIN


  ms_test.test_unit_types;

  ms_test.test_call_stack;
  
 
 
  ms_test.test_traversal_tree(i_node_count => 20);
  
  ms_test.test_tree;
 
  ms_logger.set_unit_debug(i_module_name => 'ms_test'                
                            ,i_unit_name   => 'error_node');
                                  


  ms_test.test_message_tree(i_number   => 1234     
                          ,i_varchar2 => 'ABCD'  
                          ,i_date     => SYSDATE  
                          ,i_boolean  => FALSE);
                                  
  ms_logger.set_unit_debug(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;

 
  ms_logger.set_unit_normal(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;
 


  ms_logger.set_unit_quiet(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;
 

  ms_test.test_unit_types;
 
  ms_test.test_internal_error;
 
 
END;
/
 
 
prompt Ext Ref is &&my_unique_id

SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
FROM ms_unit_traversal_vw
WHERE ext_ref = '&&my_unique_id'
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id;

prompt Show all
SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
||chr(10)||(SELECT listagg('**'||name||':'||value,chr(10)) within group (order by traversal_id) from ms_message where traversal_id = t.traversal_id and msg_type in ('PARAM','NOTE'))
||chr(10)||(SELECT listagg('--'||message,chr(10)) within group (order by message_id) from ms_message where traversal_id = t.traversal_id and msg_type not in ('PARAM','NOTE')) as text             
FROM ms_unit_traversal_vw t
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id; 


alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings  
 
spool off;
