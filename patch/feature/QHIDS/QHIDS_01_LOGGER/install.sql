PROMPT LOG TO QHIDS_01_LOGGER.log
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

define patch_name = 'QHIDS_01_LOGGER'
define patch_desc = 'QHIDS deploy'
define patch_path = 'feature/QHIDS/QHIDS_01_LOGGER/'
SPOOL QHIDS_01_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'QHIDS_01_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/QHIDS' -
 ,i_tag_from           => 'QHIDS.01A' -
 ,i_tag_to             => 'QHIDS.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'QHIDS deploy' -
 ,i_patch_componants   => 'sm_rebuild_tables.sql' -
||',ins_upd_sm_source.prc' -
||',sm_api.pks' -
||',sm_jotter.pks' -
||',sm_logger.pks' -
||',sm_weaver.pks' -
||',dba_objects_v_alt.vw' -
||',dba_source_v_alt.vw' -
||',sm_session_v2.vw' -
||',sm_source_v.vw' -
||',sm_views.vw' -
||',grant_to_SECOWN.sql' -
||',grant_to_QHOWN.sql' -
||',grant_to_QHIDSOWN.sql' -
||',sm_api.pkb' -
||',sm_jotter.pkb' -
||',sm_logger.pkb' -
||',sm_weaver.pkb' -
||',sm_config_pop.sql' -
||',sm_module.tab' -
||',sm_message.tab' -
||',sm_config.tab' -
||',sm_session.tab' -
||',sm_source.tab' -
||',sm_unit.tab' -
||',sm_call.tab' -
||',enduser.grt' -
 ,i_patch_create_date  => '07-31-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch QHIDS_01_SYS
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'QHIDS_01_LOGGER' -
,i_prereq_patch  => 'QHIDS_01_SYS' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'QHIDS_01_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_rebuild_tables.sql 
@&&patch_path.sm_rebuild_tables.sql;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT PROCEDURES

PROMPT ins_upd_sm_source.prc 
@&&patch_path.ins_upd_sm_source.prc;
Show error;

PROMPT PACKAGE SPECS

PROMPT sm_api.pks 
@&&patch_path.sm_api.pks;
Show error;

PROMPT sm_jotter.pks 
@&&patch_path.sm_jotter.pks;
Show error;

PROMPT sm_logger.pks 
@&&patch_path.sm_logger.pks;
Show error;

PROMPT sm_weaver.pks 
@&&patch_path.sm_weaver.pks;
Show error;

PROMPT VIEWS

PROMPT dba_objects_v_alt.vw 
@&&patch_path.dba_objects_v_alt.vw;
Show error;

PROMPT dba_source_v_alt.vw 
@&&patch_path.dba_source_v_alt.vw;
Show error;

PROMPT sm_session_v2.vw 
@&&patch_path.sm_session_v2.vw;
Show error;

PROMPT sm_source_v.vw 
@&&patch_path.sm_source_v.vw;
Show error;

PROMPT sm_views.vw 
@&&patch_path.sm_views.vw;
Show error;

PROMPT GRANTS

WHENEVER SQLERROR CONTINUE
PROMPT grant_to_SECOWN.sql 
@&&patch_path.grant_to_SECOWN.sql;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

WHENEVER SQLERROR CONTINUE
PROMPT grant_to_QHOWN.sql 
@&&patch_path.grant_to_QHOWN.sql;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

WHENEVER SQLERROR CONTINUE
PROMPT grant_to_QHIDSOWN.sql 
@&&patch_path.grant_to_QHIDSOWN.sql;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT PACKAGE BODIES

PROMPT sm_api.pkb 
@&&patch_path.sm_api.pkb;
Show error;

PROMPT sm_jotter.pkb 
@&&patch_path.sm_jotter.pkb;
Show error;

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

PROMPT sm_weaver.pkb 
@&&patch_path.sm_weaver.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT sm_config_pop.sql 
@&&patch_path.sm_config_pop.sql;

COMMIT;
PROMPT Compiling objects in schema &&LOGGER_user
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

