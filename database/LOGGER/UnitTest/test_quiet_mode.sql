alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;
set serveroutput on;

spool test_quiet_mode.log

prompt testing quiet
prompt quiet
execute ms_api.set_module_quiet(i_module_name => 'MS_TEST5');
select MS_TEST5.test_for_quiet_mode from dual;
 
spool off;
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings;		