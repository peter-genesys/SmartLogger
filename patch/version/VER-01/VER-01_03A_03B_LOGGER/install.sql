PROMPT LOG TO VER-01_03A_03B_LOGGER.log
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

define patch_name = 'VER-01_03A_03B_LOGGER'
define patch_desc = 'Escape HTML in coloured strings, reduce padding in param names'
define patch_path = 'feature/log/VER-01/VER-01_03A_03B_LOGGER/'
SPOOL VER-01_03A_03B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'VER-01_03A_03B_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'LOGGER' -
 ,i_branch_name        => 'feature/log/VER-01' -
 ,i_tag_from           => 'VER-01.03A' -
 ,i_tag_to             => 'VER-01.03B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Escape HTML in coloured strings, reduce padding in param names' -
 ,i_patch_componants   => 'aop_processor.pkb' -
 ,i_patch_create_date  => '02-16-2015' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch VER-01_02A_02B_LOGGER
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_03A_03B_LOGGER' -
,i_prereq_patch  => 'VER-01_02A_02B_LOGGER' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_03A_03B_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@&&patch_path.aop_processor.pkb;
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

