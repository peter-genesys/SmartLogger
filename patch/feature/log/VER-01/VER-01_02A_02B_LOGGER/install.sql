PROMPT LOG TO VER-01_02A_02B_LOGGER.log
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

define patch_name = 'VER-01_02A_02B_LOGGER'
define patch_desc = 'Smartlogger Log Trawler and Process Purging'
define patch_path = 'feature/log/VER-01/VER-01_02A_02B_LOGGER/'
SPOOL VER-01_02A_02B_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'VER-01_02A_02B_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/log/VER-01' -
 ,i_tag_from           => 'VER-01.02A' -
 ,i_tag_to             => 'VER-01.02B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Smartlogger Log Trawler and Process Purging' -
 ,i_patch_componants   => 'aop_source.tab' -
||',ms_config.tab' -
||',aop_processor.pks' -
||',ms_api.pks' -
||',aop_source_v.vw' -
||',ms_process_v2.vw' -
||',aop_processor.pkb' -
||',ms_api.pkb' -
||',log_trawler.job' -
||',purge_processes.job' -
||',ms_config_pop.sql' -
 ,i_patch_create_date  => '12-10-2014' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch VER-01_01A_01B_LOGGER
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_02A_02B_LOGGER' -
,i_prereq_patch  => 'VER-01_01A_01B_LOGGER' );
PROMPT
PROMPT Checking Prerequisite patch VER-01_01A_01B_LOGGER_A
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_02A_02B_LOGGER' -
,i_prereq_patch  => 'VER-01_01A_01B_LOGGER_A' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_02A_02B_LOGGER' -
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

PROMPT PACKAGE SPECS

PROMPT aop_processor.pks 
@&&patch_path.aop_processor.pks;
Show error;

PROMPT ms_api.pks 
@&&patch_path.ms_api.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@&&patch_path.aop_source_v.vw;
Show error;

PROMPT ms_process_v2.vw 
@&&patch_path.ms_process_v2.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@&&patch_path.aop_processor.pkb;
Show error;

PROMPT ms_api.pkb 
@&&patch_path.ms_api.pkb;
Show error;

PROMPT JOBS

PROMPT log_trawler.job 
@&&patch_path.log_trawler.job;

PROMPT purge_processes.job 
@&&patch_path.purge_processes.job;

PROMPT MISCELLANEOUS

PROMPT ms_config_pop.sql 
@&&patch_path.ms_config_pop.sql;

COMMIT;
PROMPT Compiling objects in schema LOGGER
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

