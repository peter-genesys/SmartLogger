PROMPT LOG TO FixAOPforRecords_02_LOGGER.log
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

define patch_name = 'FixAOPforRecords_02_LOGGER'
define patch_desc = 'Introducing PLScope'
define patch_path = 'feature/FixAOPforRecords/FixAOPforRecords_02_LOGGER/'
SPOOL FixAOPforRecords_02_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

PROMPT ms_tables.tab 
@&&patch_path.ms_tables.tab;

PROMPT PACKAGE SPECS

PROMPT ms_logger.pks 
@&&patch_path.ms_logger.pks;
Show error;

PROMPT ms_api.pks 
@&&patch_path.ms_api.pks;
Show error;

PROMPT sm_jotter.pks 
@&&patch_path.sm_jotter.pks;
Show error;

PROMPT aop_processor.pks 
@&&patch_path.aop_processor.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@&&patch_path.aop_source_v.vw;
Show error;

PROMPT dba_objects_v.vw 
@&&patch_path.dba_objects_v.vw;
Show error;

PROMPT dba_source_v.vw 
@&&patch_path.dba_source_v.vw;
Show error;

PROMPT ms_views.vw 
@&&patch_path.ms_views.vw;
Show error;

PROMPT GRANTS

PROMPT enduser.grt 
@&&patch_path.enduser.grt;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@&&patch_path.aop_processor.pkb;
Show error;

PROMPT ms_api.pkb 
@&&patch_path.ms_api.pkb;
Show error;

PROMPT ms_logger.pkb 
@&&patch_path.ms_logger.pkb;
Show error;

PROMPT sm_jotter.pkb 
@&&patch_path.sm_jotter.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT ms_config_pop.sql 
@&&patch_path.ms_config_pop.sql;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

