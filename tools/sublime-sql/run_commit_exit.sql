--run_commit_exit.sql
select user||' : '||global_name "User Database"  from global_name

prompt
prompt Running &1
prompt
@@&1 
prompt
show error;
commit;
prompt Exiting SQL
prompt
exit;