prompt testing logger modes

prompt CLOBS

prompt disabled
execute ms_api.set_module_disabled(i_module_name => 'MS_TEST5');
select MS_TEST5.test_clob_debugging from dual;

prompt debug
execute ms_api.set_module_debug(i_module_name => 'MS_TEST5');
select MS_TEST5.test_clob_debugging from dual;

prompt normal
execute ms_api.set_module_normal(i_module_name => 'MS_TEST5');
select MS_TEST5.test_clob_debugging from dual;

prompt quiet
execute ms_api.set_module_quiet(i_module_name => 'MS_TEST5');
select MS_TEST5.test_clob_debugging from dual;

prompt VARCHARS
prompt disabled
execute ms_api.set_module_disabled(i_module_name => 'MS_TEST5');
select MS_TEST5.test_varchar2_debugging from dual;

prompt debug
execute ms_api.set_module_debug(i_module_name => 'MS_TEST5');
select MS_TEST5.test_varchar2_debugging from dual;

prompt normal
execute ms_api.set_module_normal(i_module_name => 'MS_TEST5');
select MS_TEST5.test_varchar2_debugging from dual;

prompt quiet
execute ms_api.set_module_quiet(i_module_name => 'MS_TEST5');
select MS_TEST5.test_varchar2_debugging from dual;