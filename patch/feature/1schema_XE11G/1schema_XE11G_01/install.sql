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
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => '1schema_XE11G_01' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/1schema_XE11G' -
 ,i_tag_from           => '1schema_XE11G.01A' -
 ,i_tag_to             => '1schema_XE11G.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Single schema install - 11G XE' -
 ,i_patch_componants   => 'aop_source.tab' -
||',ms_config.tab' -
||',ms_tables.tab' -
||',ms_seqs.seq' -
||',ins_upd_aop_source.prc' -
||',aop_processor.pks' -
||',ms_api.pks' -
||',ms_logger.pks' -
||',aop_test.pks' -
||',ms_test.pks' -
||',aop_source_v.vw' -
||',ms_process_v2.vw' -
||',ms_views.vw' -
||',dba_source.syn' -
||',aop_processor.pkb' -
||',ms_api.pkb' -
||',ms_logger.pkb' -
||',aop_test.pkb' -
||',ms_test.pkb' -
||',ms_config_pop.sql' -
||',aop_test.sql' -
||',ms_test.sql' -
 ,i_patch_create_date  => '04-28-2017' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => '1schema_XE11G_01' -
,i_prereq_patch  => 'TRK-01_01' );
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
PROMPT Compiling objects in schema &&LOGGER_user
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

