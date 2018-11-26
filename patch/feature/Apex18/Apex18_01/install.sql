PROMPT LOG TO Apex18_01.log
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

define patch_name = 'Apex18_01'
define patch_desc = 'Do not recompile APEX objects'
define patch_path = 'feature/Apex18/Apex18_01/'
SPOOL Apex18_01.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'Apex18_01' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'LOGGER' -
 ,i_branch_name        => 'feature/Apex18' -
 ,i_tag_from           => 'Apex18.01A' -
 ,i_tag_to             => 'Apex18.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Do not recompile APEX objects' -
 ,i_patch_componants   => 'sm_apex_context.tab' -
||',sm_logger.pkb' -
||',sm_weaver.pkb' -
 ,i_patch_create_date  => '11-26-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'Apex18_01' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_apex_context.tab 
@&&patch_path.sm_apex_context.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT PACKAGE BODIES

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

PROMPT sm_weaver.pkb 
@&&patch_path.sm_weaver.pkb;
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

