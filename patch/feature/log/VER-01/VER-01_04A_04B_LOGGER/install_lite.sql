PROMPT LOG TO VER-01_04A_04B_LOGGER.log
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

define patch_name = 'VER-01_04A_04B_LOGGER'
define patch_desc = 'Fix for quiet mode'
define patch_path = 'feature/log/VER-01/VER-01_04A_04B_LOGGER/'
SPOOL VER-01_04A_04B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT PACKAGE SPECS

PROMPT ms_test.pks 
@&&patch_path.ms_test.pks;
Show error;

PROMPT PACKAGE BODIES

PROMPT ms_logger.pkb 
@&&patch_path.ms_logger.pkb;
Show error;

PROMPT ms_test.pkb 
@&&patch_path.ms_test.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

