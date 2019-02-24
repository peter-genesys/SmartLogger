PROMPT LOG TO VER-01_01A_01B_LOGGER.log
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

define patch_name = 'VER-01_01A_01B_LOGGER'
define patch_desc = 'Main installation'
define patch_path = 'feature/log/VER-01/VER-01_01A_01B_LOGGER/'
SPOOL VER-01_01A_01B_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT aop_source.tab 
@&&patch_path.aop_source.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

WHENEVER SQLERROR CONTINUE
PROMPT ms_tables.tab 
@&&patch_path.ms_tables.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT SEQUENCES

WHENEVER SQLERROR CONTINUE
PROMPT ms_seqs.seq 
@&&patch_path.ms_seqs.seq;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

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

PROMPT ms_views.vw 
@&&patch_path.ms_views.vw;
Show error;

PROMPT SYNONYMS

WHENEVER SQLERROR CONTINUE
PROMPT dba_source.syn 
@&&patch_path.dba_source.syn;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

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

