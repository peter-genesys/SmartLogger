PROMPT LOG TO QHIDS-1915_01.log
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

define patch_name = 'QHIDS-1915_01'
define patch_desc = 'DB Support for Cloned Apex Sessions'
define patch_path = 'feature/QHIDS-1915/QHIDS-1915_01/'
SPOOL QHIDS-1915_01.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'QHIDS-1915_01' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'LOGGER' -
 ,i_branch_name        => 'feature/QHIDS-1915' -
 ,i_tag_from           => 'QHIDS-1915.01A' -
 ,i_tag_to             => 'QHIDS-1915.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'DB Support for Cloned Apex Sessions' -
 ,i_patch_componants   => 'sm_session.tab' -
||',sm_extra_nodes_v.vw' -
||',sm_call_tree_parent_id.fnc' -
||',sm_api.pks' -
||',sm_call_tree_v.vw' -
||',sm_session_v3.vw' -
||',sm_api.pkb' -
||',sm_logger.pkb' -
||',purge_processes.job' -
||',sm_config_pop.sql' -
 ,i_patch_create_date  => '09-25-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'QHIDS-1915_01' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_session.tab 
@&&patch_path.sm_session.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT FUNCTIONS

PROMPT sm_extra_nodes_v.vw 
@&&patch_path.sm_extra_nodes_v.vw;
Show error;

PROMPT sm_call_tree_parent_id.fnc 
@&&patch_path.sm_call_tree_parent_id.fnc;
Show error;

PROMPT PACKAGE SPECS

PROMPT sm_api.pks 
@&&patch_path.sm_api.pks;
Show error;

PROMPT VIEWS

PROMPT sm_call_tree_v.vw 
@&&patch_path.sm_call_tree_v.vw;
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

PROMPT JOBS

PROMPT purge_processes.job 
@&&patch_path.purge_processes.job;

PROMPT MISCELLANEOUS

PROMPT sm_config_pop.sql 
@&&patch_path.sm_config_pop.sql;

COMMIT;
PROMPT Compiling objects in schema LOGGER
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

