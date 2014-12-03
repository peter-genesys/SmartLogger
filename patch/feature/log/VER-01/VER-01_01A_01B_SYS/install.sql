PROMPT LOG TO VER-01_01A_01B_SYS.log
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

define patch_name = 'VER-01_01A_01B_SYS'
define patch_desc = 'Create LOGGER schema'
define patch_path = 'feature/log/VER-01/VER-01_01A_01B_SYS/'
SPOOL VER-01_01A_01B_SYS.log
CONNECT &&SYS_user/&&SYS_password@&&database as sysdba
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'VER-01_01A_01B_SYS' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&SYS_user' -
 ,i_branch_name        => 'feature/log/VER-01' -
 ,i_tag_from           => 'VER-01.01A' -
 ,i_tag_to             => 'VER-01.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Create LOGGER schema' -
 ,i_patch_componants   => 'logger.user' -
 ,i_patch_create_date  => '12-03-2014' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_01A_01B_SYS' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT USERS

WHENEVER SQLERROR CONTINUE
PROMPT logger.user 
@&&patch_path.logger.user;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

COMMIT;
PROMPT Compiling objects in schema SYS
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

