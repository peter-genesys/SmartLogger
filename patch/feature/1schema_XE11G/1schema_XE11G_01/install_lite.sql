PROMPT LOG TO 1schema_XE11G_01.log
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

define patch_name = '1schema_XE11G_01'
define patch_desc = 'Single schema install - 11G XE'
define patch_path = 'feature/1schema_XE11G/1schema_XE11G_01/'
SPOOL 1schema_XE11G_01.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT aop_source.tab 
@&&patch_path.aop_source.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

WHENEVER SQLERROR CONTINUE
PROMPT ms_config.tab 
@&&patch_path.ms_config.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

WHENEVER SQLERROR CONTINUE
PROMPT ms_tables.tab 
@&&patch_path.ms_tables.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT SEQUENCES

PROMPT ms_seqs.seq 
@&&patch_path.ms_seqs.seq;



PROMPT PACKAGE SPECS

PROMPT aop_processor.pks 
@&&patch_path.aop_processor.pks;
Show error;

PROMPT ms_api.pks 
@&&patch_path.ms_api.pks;
Show error;

PROMPT ms_logger.pks 
@&&patch_path.ms_logger.pks;
Show error;

PROMPT aop_test.pks 
@&&patch_path.aop_test.pks;
Show error;

PROMPT ms_test.pks 
@&&patch_path.ms_test.pks;
Show error;

PROMPT PROCEDURES

PROMPT ins_upd_aop_source.prc 
@&&patch_path.ins_upd_aop_source.prc;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@&&patch_path.aop_source_v.vw;
Show error;

PROMPT ms_process_v2.vw 
@&&patch_path.ms_process_v2.vw;
Show error;

PROMPT ms_views.vw 
@&&patch_path.ms_views.vw;
Show error;

PROMPT SYNONYMS

PROMPT dba_source.syn 
@&&patch_path.dba_source.syn;

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

PROMPT aop_test.pkb 
@&&patch_path.aop_test.pkb;
Show error;

PROMPT ms_test.pkb 
@&&patch_path.ms_test.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT ms_config_pop.sql 
@&&patch_path.ms_config_pop.sql;

PROMPT aop_test.sql 
@&&patch_path.aop_test.sql;

PROMPT ms_test.sql 
@&&patch_path.ms_test.sql;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

