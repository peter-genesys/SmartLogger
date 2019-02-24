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
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'VER-01_01A_01B_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/log/VER-01' -
 ,i_tag_from           => 'VER-01.01A' -
 ,i_tag_to             => 'VER-01.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Main installation' -
 ,i_patch_componants   => 'aop_source.tab' -
||',ms_tables.tab' -
||',ms_seqs.seq' -
||',aop_processor.pks' -
||',ms_api.pks' -
||',ms_logger.pks' -
||',aop_test.pks' -
||',ms_test.pks' -
||',ins_upd_aop_source.prc' -
||',aop_source_v.vw' -
||',ms_views.vw' -
||',dba_source.syn' -
||',aop_processor.pkb' -
||',ms_api.pkb' -
||',ms_logger.pkb' -
||',aop_test.pkb' -
||',ms_test.pkb' -
||',aop_test.sql' -
||',ms_test.sql' -
 ,i_patch_create_date  => '12-03-2014' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch VER-01_01A_01B_SYS
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_01A_01B_LOGGER' -
,i_prereq_patch  => 'VER-01_01A_01B_SYS' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_01A_01B_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
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
PROMPT Compiling objects in schema LOGGER
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

