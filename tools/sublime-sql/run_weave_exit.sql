--run_weave_exit.sql
select user||' : '||global_name "User Database"  from global_name

prompt
prompt Running &1
prompt
@@&1 
prompt
show error;

set verify off 
COLUMN the_object NEW_VALUE object_name
--remove file path and file extension, set to uppercase.
SELECT upper(regexp_substr(regexp_substr('&1', '[^\\]+$'),'(\w*)'))  the_object from dual;

prompt Weaving &object_name
execute sm_weaver.reapply_aspect(i_object_name=> '&object_name');

prompt Exiting SQL
prompt
exit;