PROMPT LOG TO LOG-01_06A_06B_LOGGER.log
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

SPOOL LOG-01_06A_06B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT FUNCTIONS

PROMPT supported_data_type.fnc 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\supported_data_type.fnc;
Show error;

PROMPT PACKAGE SPECS

PROMPT ms_api.pks 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\ms_api.pks;
Show error;

PROMPT ms_logger.pks 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\ms_logger.pks;
Show error;

PROMPT aop_test.pks 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\aop_test.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\aop_source_v.vw;
Show error;

PROMPT ms_views.vw 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\ms_views.vw;
Show error;

PROMPT SYNONYMS

PROMPT dba_source.syn 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\dba_source.syn;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\aop_processor.pkb;
Show error;

PROMPT ms_api.pkb 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\ms_api.pkb;
Show error;

PROMPT ms_logger.pkb 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\ms_logger.pkb;
Show error;

PROMPT aop_test.pkb 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\aop_test.pkb;
Show error;

PROMPT ms_test.pkb 
@feature\logger\LOG-01\LOG-01_06A_06B_LOGGER\ms_test.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
