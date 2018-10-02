PROMPT LOG TO apex_context_01.log
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

define patch_name = 'apex_context_01'
define patch_desc = 'Apex Context'
define patch_path = 'feature/apex_context/apex_context_01/'
SPOOL apex_context_01.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'apex_context_01' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'LOGGER' -
 ,i_branch_name        => 'feature/apex_context' -
 ,i_tag_from           => 'apex_context.01A' -
 ,i_tag_to             => 'apex_context.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Apex Context' -
 ,i_patch_componants   => 'sm_apex_context.tab' -
||',sm_log.tab' -
||',sm_session.tab' -
||',sm_apex_context_collection_v.vw' -
||',sm_context_tree_v.vw' -
||',sm_db_context_tree_v.vw' -
||',sm_session_v3.vw' -
||',sm_api.pkb' -
||',sm_logger.pkb' -
 ,i_patch_create_date  => '10-03-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => 'Support Clone as Sibling or Child' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'apex_context_01' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

PROMPT sm_apex_context.tab 
@&&patch_path.sm_apex_context.tab;

PROMPT sm_log.tab 
@&&patch_path.sm_log.tab;

PROMPT sm_session.tab 
@&&patch_path.sm_session.tab;

PROMPT VIEWS

PROMPT sm_apex_context_collection_v.vw 
@&&patch_path.sm_apex_context_collection_v.vw;
Show error;

PROMPT sm_context_tree_v.vw 
@&&patch_path.sm_context_tree_v.vw;
Show error;

PROMPT sm_db_context_tree_v.vw 
@&&patch_path.sm_db_context_tree_v.vw;
Show error;

PROMPT sm_session_v3.vw 
@&&patch_path.sm_session_v3.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT sm_api.pkb 
@&&patch_path.sm_api.pkb;
Show error;

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

COMMIT;
PROMPT Compiling objects in schema LOGGER
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

