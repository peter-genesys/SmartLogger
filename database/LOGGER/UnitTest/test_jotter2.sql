alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool test_jotter2.log

prompt testing jottering
--prompt quiet
--execute ms_api.set_module_debug(i_module_name => 'SM_JOTTER');

BEGIN
  sm_jot_test.manual_jotting ;  
END;
/
 
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;		