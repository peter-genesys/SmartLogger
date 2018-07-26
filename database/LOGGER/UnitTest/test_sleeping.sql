alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool test_sleep_mode.log

prompt testing sleeping
prompt quiet
execute ms_api.set_module_debug(i_module_name => 'MS_TEST5');

BEGIN
  ms_test5.test_sleeping1; --one session
  ms_test5.test_sleeping2; --another session
  ms_test5.test_sleeping ; --another session
 
END;
/
 
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;		