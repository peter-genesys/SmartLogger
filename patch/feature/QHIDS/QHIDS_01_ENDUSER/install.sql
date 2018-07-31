PROMPT LOG TO QHIDS_01_ENDUSER.log
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

define patch_name = 'QHIDS_01_ENDUSER'
define patch_desc = 'QHIDS deploy'
define patch_path = 'feature/QHIDS/QHIDS_01_ENDUSER/'
SPOOL QHIDS_01_ENDUSER.log
CONNECT &&ENDUSER_user/&&ENDUSER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'QHIDS_01_ENDUSER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&ENDUSER_user' -
 ,i_branch_name        => 'feature/QHIDS' -
 ,i_tag_from           => 'QHIDS.01A' -
 ,i_tag_to             => 'QHIDS.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'QHIDS deploy' -
 ,i_patch_componants   => 'logger.syn' -
 ,i_patch_create_date  => '07-31-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch QHIDS_01_LOGGER
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'QHIDS_01_ENDUSER' -
,i_prereq_patch  => 'QHIDS_01_LOGGER' );
PROMPT
PROMPT Checking Prerequisite patch QHIDS_01_SYS
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'QHIDS_01_ENDUSER' -
,i_prereq_patch  => 'QHIDS_01_SYS' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'QHIDS_01_ENDUSER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT SYNONYMS

WHENEVER SQLERROR CONTINUE
PROMPT logger.syn 
@&&patch_path.logger.syn;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

COMMIT;
PROMPT Compiling objects in schema &&ENDUSER_user
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

