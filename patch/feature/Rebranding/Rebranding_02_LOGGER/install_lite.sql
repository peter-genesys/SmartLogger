PROMPT LOG TO Rebranding_02_LOGGER.log
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

define patch_name = 'Rebranding_02_LOGGER'
define patch_desc = 'Rebranding for grants'
define patch_path = 'feature/Rebranding/Rebranding_02_LOGGER/'
SPOOL Rebranding_02_LOGGER.log
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

