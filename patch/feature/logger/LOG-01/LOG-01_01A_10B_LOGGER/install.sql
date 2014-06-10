PROMPT LOG TO LOG-01_01A_10B_LOGGER.log
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

SPOOL LOG-01_01A_10B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT aop_source.tab 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_source.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

WHENEVER SQLERROR CONTINUE
PROMPT ms_tables.tab 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_tables.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT SEQUENCES

PROMPT ms_seqs.seq 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_seqs.seq;

PROMPT PACKAGE SPECS

PROMPT aop_processor.pks 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_processor.pks;
Show error;

PROMPT ms_api.pks 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_api.pks;
Show error;

PROMPT ms_logger.pks 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_logger.pks;
Show error;

PROMPT aop_test.pks 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_test.pks;
Show error;

PROMPT ms_test.pks 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_test.pks;
Show error;

PROMPT PROCEDURES

PROMPT ins_upd_aop_source.prc 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ins_upd_aop_source.prc;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_source_v.vw;
Show error;

PROMPT ms_views.vw 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_views.vw;
Show error;

PROMPT GRANTS

PROMPT sun.grt 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\sun.grt;

PROMPT SYNONYMS

PROMPT dba_source.syn 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\dba_source.syn;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_processor.pkb;
Show error;

PROMPT ms_api.pkb 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_api.pkb;
Show error;

PROMPT ms_logger.pkb 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_logger.pkb;
Show error;

PROMPT aop_test.pkb 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_test.pkb;
Show error;

PROMPT ms_test.pkb 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_test.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT aop_test.sql 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\aop_test.sql;

PROMPT ms_test.sql 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_test.sql;

PROMPT ms_test3.sql 
@feature\logger\LOG-01\LOG-01_01A_10B_LOGGER\ms_test3.sql;

COMMIT;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
