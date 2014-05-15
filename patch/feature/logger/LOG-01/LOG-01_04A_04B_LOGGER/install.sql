PROMPT LOG TO LOG-01_04A_04B_LOGGER.log
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

SPOOL LOG-01_04A_04B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT PACKAGE SPECS

PROMPT aop_processor.pks 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\aop_processor.pks;
Show error;

PROMPT ms_logger.pks 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\ms_logger.pks;
Show error;

PROMPT aop_test.pks 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\aop_test.pks;
Show error;

PROMPT ms_test.pks 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\ms_test.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\aop_source_v.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\aop_processor.pkb;
Show error;

PROMPT ms_logger.pkb 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\ms_logger.pkb;
Show error;

PROMPT aop_test.pkb 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\aop_test.pkb;
Show error;

PROMPT ms_test.pkb 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\ms_test.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT ms_test.sql 
@feature\logger\LOG-01\LOG-01_04A_04B_LOGGER\ms_test.sql;

COMMIT;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
