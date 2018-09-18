PROMPT LOG TO F900_00_LOGGER.log
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

define patch_name = 'F900_00_LOGGER'
define patch_desc = 'Substitute views required for embedded install.'
define patch_path = 'feature/F900/F900_00_LOGGER/'
SPOOL F900_00_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'F900_00_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/F900' -
 ,i_tag_from           => 'F900.02A' -
 ,i_tag_to             => 'F900.02B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Substitute views required for embedded install.' -
 ,i_patch_componants   => 'dba_objects.vw' -
||',dba_source.vw' -
||',dba_tab_columns.vw' -
||',dba_tables.vw' -
 ,i_patch_create_date  => '09-19-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'F900_00_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT VIEWS

PROMPT dba_objects.vw 
@&&patch_path.dba_objects.vw;
Show error;

PROMPT dba_source.vw 
@&&patch_path.dba_source.vw;
Show error;

PROMPT dba_tab_columns.vw 
@&&patch_path.dba_tab_columns.vw;
Show error;

PROMPT dba_tables.vw 
@&&patch_path.dba_tables.vw;
Show error;

COMMIT;
PROMPT Compiling objects in schema &&LOGGER_user
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

