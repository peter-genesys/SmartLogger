PROMPT LOG TO LOG-01_01A_09B_SYS.log
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

SPOOL LOG-01_01A_09B_SYS.log
CONNECT APEX_SYS/&&APEX_SYS_password@&&database as sysdba
set serveroutput on;
execute patch_admin.patch_installer.patch_started( -
  i_patch_name         => 'LOG-01_01A_09B_SYS' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'SYS' -
 ,i_branch_name        => 'feature/logger/LOG-01' -
 ,i_tag_from           => 'LOG-01.01A' -
 ,i_tag_to             => 'LOG-01.09B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Create Logger user' -
 ,i_patch_componants   => 'logger.user' -
 ,i_patch_create_date  => '06-06-2014' -
 ,i_patch_created_by   => 'burgessp' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute patch_admin.patch_installer.add_patch_prereq( -
i_patch_name     => 'LOG-01_01A_09B_SYS' -
,i_prereq_patch  => 'PRJROV-206_06A_06B_PATCH_ADMIN' );
select user||'@'||global_name Connection from global_name;


PROMPT USERS

PROMPT logger.user 
@feature\logger\LOG-01\LOG-01_01A_09B_SYS\logger.user;

COMMIT;
PROMPT Compiling objects in schema SYS
execute patch_admin.patch_invoker.compile_post_patch;
execute patch_admin.patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
