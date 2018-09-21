--alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool test_quiet_mode.log

prompt testing quiet
prompt quiet
execute sm_api.set_module_quiet(i_module_name => 'sm_log_test5');
select sm_log_test5.test_for_quiet_mode from dual;
 
spool off;
--alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;		