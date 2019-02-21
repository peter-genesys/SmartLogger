PROMPT LOG TO VER-02.02.LOGGER.END_USER.log
PROMPT .
SET AUTOCOMMIT OFF
SET AUTOPRINT ON
SET ECHO ON
SET FEEDBACK ON
SET PAUSE OFF
SET SERVEROUTPUT ON SIZE 1000000
SET TERMOUT ON
SET TRIMOUT ON
SET VERIFY ON
SET trims on pagesize 3000
SET auto off
SET verify off echo off define on
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

define patch_name = 'VER-02.02.LOGGER.END_USER'
define patch_desc = 'Grant to an end user'
define patch_path = 'feature/log/VER-02/VER-02.02.LOGGER.END_USER/'
SPOOL VER-02.02.LOGGER.END_USER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT GRANTS

PROMPT enduser.grt 
@&&patch_path.enduser.grt;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

