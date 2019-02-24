PROMPT LOG TO SML-02.02.SYS.log
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

define patch_name = 'SML-02.02.SYS'
define patch_desc = 'Create logger user'
define patch_path = 'version/SML-02/SML-02.02.SYS/'
SPOOL SML-02.02.SYS.log
CONNECT &&SYS_user/&&SYS_password@&&database as sysdba
set serveroutput on;
execute &&APEXRM_user..arm_installer.patch_started( -
  i_patch_name         => 'SML-02.02.SYS' -
 ,i_patch_type         => 'version' -
 ,i_db_schema          => '&&SYS_user' -
 ,i_app_code           => 'SML' -
 ,i_branch_name        => 'version/SML-02' -
 ,i_tag_from           => 'SML-02.02A' -
 ,i_tag_to             => 'SML-02.02B' -
 ,i_suffix             => '' -
 ,i_patch_desc         => 'Create logger user' -
 ,i_patch_components   => 'logger.user' -
 ,i_patch_create_date  => '02-21-2019' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_tracking_yn        => 'Y' -
 ,i_alt_schema_yn      => 'Y' -
 ,i_retired_yn         => 'N' -
 ,i_remove_prereqs     => 'N' );

PROMPT Ensure ARM is late enough for this patch
execute &&APEXRM_user..arm_installer.add_prereq_best_order( -
i_patch_name     => 'SML-02.02.SYS' -
,i_prereq_patch  => 'ARM-01.02.APEXRM' );
select user||'@'||global_name Connection from global_name;


PROMPT USERS

WHENEVER SQLERROR CONTINUE
PROMPT logger.user 
@&&patch_path.logger.user;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

COMMIT;
PROMPT Compiling objects in schema &&SYS_user
execute &&APEXRM_user..arm_invoker.compile_post_patch;
execute &&APEXRM_user..arm_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

