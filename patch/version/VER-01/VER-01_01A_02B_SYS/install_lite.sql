PROMPT LOG TO VER-01_01A_02B_SYS.log
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

define patch_name = 'VER-01_01A_02B_SYS'
define patch_desc = ''
define patch_path = 'feature/log/VER-01/VER-01_01A_02B_SYS/'
SPOOL VER-01_01A_02B_SYS.log
CONNECT &&SYS_user/&&SYS_password@&&database as sysdba
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT USERS

PROMPT logger.user 
@&&patch_path.logger.user;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

