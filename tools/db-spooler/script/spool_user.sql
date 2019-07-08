-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/user_ddl.sql
-- Author       : Tim Hall
-- Description  : Displays the DDL for a specific user.
-- Call Syntax  : @user_ddl (username)
-- Last Modified: 07/08/2018
-- -----------------------------------------------------------------------------------

set long 20000 longchunksize 20000 pagesize 0 linesize 1000 feedback off verify off trimspool on
column ddl format a1000

define the_user='SECOWN';

prompt spooling &&the_user..usr
spool &&the_user..usr;

begin
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
end;
/

 

select dbms_metadata.get_ddl('USER', u.username) AS ddl
from   dba_users u
where  u.username = '&&the_user'
union all
select dbms_metadata.get_granted_ddl('TABLESPACE_QUOTA', tq.username) AS ddl
from   dba_ts_quotas tq
where  tq.username = '&&the_user'
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('ROLE_GRANT', rp.grantee) AS ddl
from   dba_role_privs rp
where  rp.grantee = '&&the_user'
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('SYSTEM_GRANT', sp.grantee) AS ddl
from   dba_sys_privs sp
where  sp.grantee = '&&the_user'
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('OBJECT_GRANT', tp.grantee) AS ddl
from   dba_tab_privs tp
where  tp.grantee = '&&the_user'
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('DEFAULT_ROLE', rp.grantee) AS ddl
from   dba_role_privs rp
where  rp.grantee = '&&the_user'
and    rp.default_role = 'YES'
and    rownum = 1
union all
select to_clob('/* Start profile creation script in case they are missing') AS ddl
from   dba_users u
where  u.username = '&&the_user'
and    u.profile <> 'DEFAULT'
and    rownum = 1
union all
select dbms_metadata.get_ddl('PROFILE', u.profile) AS ddl
from   dba_users u
where  u.username = '&&the_user'
and    u.profile <> 'DEFAULT'
union all
select to_clob('End profile creation script */') AS ddl
from   dba_users u
where  u.username = '&&the_user'
and    u.profile <> 'DEFAULT'
and    rownum = 1
/

set linesize 80 pagesize 14 feedback on trimspool on verify on

spool off;
