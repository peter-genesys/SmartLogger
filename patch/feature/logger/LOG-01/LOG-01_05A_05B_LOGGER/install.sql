PROMPT LOG TO LOG-01_05A_05B_LOGGER.log
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

SPOOL LOG-01_05A_05B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT PACKAGE SPECS

PROMPT ms_logger.pks 
@feature\logger\LOG-01\LOG-01_05A_05B_LOGGER\ms_logger.pks;
Show error;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@feature\logger\LOG-01\LOG-01_05A_05B_LOGGER\aop_processor.pkb;
Show error;

PROMPT ms_logger.pkb 
@feature\logger\LOG-01\LOG-01_05A_05B_LOGGER\ms_logger.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
