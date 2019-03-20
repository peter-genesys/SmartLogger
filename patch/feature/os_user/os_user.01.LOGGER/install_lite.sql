PROMPT LOG TO os_user.01.LOGGER.log
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

define patch_name = 'os_user.01.LOGGER'
define patch_desc = 'OS_USER and HOST'
define patch_path = 'feature/os_user/os_user.01.LOGGER/'
SPOOL os_user.01.LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_session.tab 
@&&patch_path.sm_session.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT VIEWS

PROMPT sm_views.vw 
@&&patch_path.sm_views.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

