PROMPT LOG TO Apex18_01.log
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

define patch_name = 'Apex18_01'
define patch_desc = 'Do not recompile APEX objects'
define patch_path = 'feature/Apex18/Apex18_01/'
SPOOL Apex18_01.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_apex_context.tab 
@&&patch_path.sm_apex_context.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT PACKAGE BODIES

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

PROMPT sm_weaver.pkb 
@&&patch_path.sm_weaver.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

