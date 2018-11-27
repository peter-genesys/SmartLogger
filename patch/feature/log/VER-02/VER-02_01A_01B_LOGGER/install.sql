PROMPT LOG TO VER-02_01A_01B_LOGGER.log
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

define patch_name = 'VER-02_01A_01B_LOGGER'
define patch_desc = 'Install Logger objects'
define patch_path = 'feature/log/VER-02/VER-02_01A_01B_LOGGER/'
SPOOL VER-02_01A_01B_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'VER-02_01A_01B_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/log/VER-02' -
 ,i_tag_from           => 'VER-02.01A' -
 ,i_tag_to             => 'VER-02.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Install Logger objects' -
 ,i_patch_componants   => 'sm_rebuild_tables.sql' -
||',sm_call_tree_parent_id.fnc' -
||',ins_upd_sm_source.prc' -
||',sm_api.pks' -
||',sm_jotter.pks' -
||',sm_logger.pks' -
||',sm_weaver.pks' -
||',dba_objects.vw' -
||',dba_objects_v_alt.vw' -
||',dba_source.vw' -
||',dba_source_v_alt.vw' -
||',dba_tab_columns.vw' -
||',dba_tables.vw' -
||',sm_views.vw' -
||',sm_source_v.vw' -
||',sm_session_v2.vw' -
||',sm_session_v3.vw' -
||',sm_apex_context_collection_v.vw' -
||',sm_context_tree_v.vw' -
||',sm_db_context_tree_v.vw' -
||',enduser.grt' -
||',logger.pub.syn' -
||',sm_api.pkb' -
||',sm_jotter.pkb' -
||',sm_logger.pkb' -
||',sm_weaver.pkb' -
||',sm_config_pop.sql' -
||',aop_processor.pts' -
||',sm_call.tab' -
||',sm_config.tab' -
||',sm_log.tab' -
||',sm_message.tab' -
||',sm_module.tab' -
||',sm_session.tab' -
||',sm_source.tab' -
||',sm_unit.tab' -
||',sm_apex_context.tab' -
 ,i_patch_create_date  => '11-27-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch VER-02_01A_01B_SYS
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-02_01A_01B_LOGGER' -
,i_prereq_patch  => 'VER-02_01A_01B_SYS' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-02_01A_01B_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_rebuild_tables.sql 
@&&patch_path.sm_rebuild_tables.sql;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT FUNCTIONS

WHENEVER SQLERROR CONTINUE
PROMPT sm_call_tree_parent_id.fnc 
@&&patch_path.sm_call_tree_parent_id.fnc;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
Show error;

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

WHENEVER SQLERROR CONTINUE
PROMPT sm_logger.pks 
@&&patch_path.sm_logger.pks;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
Show error;

PROMPT sm_weaver.pks 
@&&patch_path.sm_weaver.pks;
Show error;

PROMPT VIEWS

PROMPT dba_objects.vw 
@&&patch_path.dba_objects.vw;
Show error;

PROMPT dba_objects_v_alt.vw 
@&&patch_path.dba_objects_v_alt.vw;
Show error;

PROMPT dba_source.vw 
@&&patch_path.dba_source.vw;
Show error;

PROMPT dba_source_v_alt.vw 
@&&patch_path.dba_source_v_alt.vw;
Show error;

PROMPT dba_tab_columns.vw 
@&&patch_path.dba_tab_columns.vw;
Show error;

PROMPT dba_tables.vw 
@&&patch_path.dba_tables.vw;
Show error;

PROMPT sm_views.vw 
@&&patch_path.sm_views.vw;
Show error;

PROMPT sm_source_v.vw 
@&&patch_path.sm_source_v.vw;
Show error;

PROMPT sm_session_v2.vw 
@&&patch_path.sm_session_v2.vw;
Show error;

PROMPT sm_session_v3.vw 
@&&patch_path.sm_session_v3.vw;
Show error;

PROMPT sm_apex_context_collection_v.vw 
@&&patch_path.sm_apex_context_collection_v.vw;
Show error;

PROMPT sm_context_tree_v.vw 
@&&patch_path.sm_context_tree_v.vw;
Show error;

PROMPT sm_db_context_tree_v.vw 
@&&patch_path.sm_db_context_tree_v.vw;
Show error;

PROMPT GRANTS

PROMPT enduser.grt 
@&&patch_path.enduser.grt;

PROMPT SYNONYMS

PROMPT logger.pub.syn 
@&&patch_path.logger.pub.syn;

PROMPT PACKAGE BODIES

PROMPT sm_api.pkb 
@&&patch_path.sm_api.pkb;
Show error;

PROMPT sm_jotter.pkb 
@&&patch_path.sm_jotter.pkb;
Show error;

WHENEVER SQLERROR CONTINUE
PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
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

