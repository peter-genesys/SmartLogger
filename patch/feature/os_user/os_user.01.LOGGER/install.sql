PROMPT LOG TO os_user.01.LOGGER.log
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

define patch_name = 'os_user.01.LOGGER'
define patch_desc = 'OS_USER and HOST'
define patch_path = 'feature/os_user/os_user.01.LOGGER/'
SPOOL os_user.01.LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&APEXRM_user..arm_installer.patch_started( -
  i_patch_name         => 'os_user.01.LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_app_code           => 'SML' -
 ,i_branch_name        => 'feature/os_user' -
 ,i_tag_from           => 'os_user.01A' -
 ,i_tag_to             => 'os_user.01B' -
 ,i_suffix             => '' -
 ,i_patch_desc         => 'OS_USER and HOST' -
 ,i_patch_components   => 'sm_session.tab' -
||',sm_views.vw' -
||',sm_logger.pkb' -
 ,i_patch_create_date  => '03-20-2019' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_tracking_yn        => 'Y' -
 ,i_alt_schema_yn      => 'Y' -
 ,i_retired_yn         => 'N' -
 ,i_remove_prereqs     => 'N' );

PROMPT
PROMPT Checking Prerequisite patch SDEPLOY-41.01.LOGGER
execute &&APEXRM_user..arm_installer.add_prereq_best_order( -
i_patch_name     => 'os_user.01.LOGGER' -
,i_prereq_patch  => 'SDEPLOY-41.01.LOGGER' );
PROMPT Ensure ARM is late enough for this patch
execute &&APEXRM_user..arm_installer.add_prereq_best_order( -
i_patch_name     => 'os_user.01.LOGGER' -
,i_prereq_patch  => 'ARM-01.02.APEXRM' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_session.tab 
@&&patch_path.sm_session.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT VIEWS

PROMPT sm_views.vw 
@&&patch_path.sm_views.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

COMMIT;
PROMPT Compiling objects in schema &&LOGGER_user
execute &&APEXRM_user..arm_invoker.compile_post_patch;
execute &&APEXRM_user..arm_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

