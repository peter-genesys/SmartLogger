PROMPT LOG TO FixAOPforRecords_01.log
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

define patch_name = 'FixAOPforRecords_01'
define patch_desc = 'Introducing PLScope'
define patch_path = 'feature/FixAOPforRecords/FixAOPforRecords_01/'
SPOOL FixAOPforRecords_01.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT ms_process_01.tab 
@&&patch_path.ms_process_01.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT PACKAGE SPECS

PROMPT ms_logger.pks 
@&&patch_path.ms_logger.pks;
Show error;

PROMPT ms_api.pks 
@&&patch_path.ms_api.pks;
Show error;

PROMPT aop_processor.pks 
@&&patch_path.aop_processor.pks;
Show error;

PROMPT aop_test.pks 
@&&patch_path.aop_test.pks;
Show error;

PROMPT aop_test2.pks 
@&&patch_path.aop_test2.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@&&patch_path.aop_source_v.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT ms_logger.pkb 
@&&patch_path.ms_logger.pkb;
Show error;

PROMPT ms_api.pkb 
@&&patch_path.ms_api.pkb;
Show error;

PROMPT aop_processor.pkb 
@&&patch_path.aop_processor.pkb;
Show error;

PROMPT aop_test.pkb 
@&&patch_path.aop_test.pkb;
Show error;

PROMPT aop_test2.pkb 
@&&patch_path.aop_test2.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

