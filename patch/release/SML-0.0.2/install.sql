PROMPT LOG TO SML-0.0.2.log
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

SPOOL SML-0.0.2.log
CONNECT &&APEXRM_user/&&APEXRM_password@&&database
set serveroutput on;
execute &&APEXRM_user..arm_installer.patch_started( -
  i_patch_name         => 'SML-0.0.2' -
 ,i_patch_type         => 'release' -
 ,i_db_schema          => 'APEXRM' -
 ,i_app_code           => 'SML' -
 ,i_branch_name        => 'release/SML-0.0.1' -
 ,i_tag_from           => 'VER-01.01B' -
 ,i_tag_to             => 'HEAD' -
 ,i_suffix             => '' -
 ,i_patch_desc         => 'Public Grants' -
 ,i_patch_components   => 'version\SML-02\SML-02.03.LOGGER' -
 ,i_patch_create_date  => '02-27-2019' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => 'Public Synonyms and Grants to Public' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_tracking_yn        => 'Y' -
 ,i_alt_schema_yn      => 'Y' -
 ,i_retired_yn         => 'N'); 

PROMPT
PROMPT Checking Prerequisite patch SML-0.0.1
execute &&APEXRM_user..arm_installer.add_patch_prereq( -
i_patch_name     => 'SML-0.0.2' -
,i_prereq_patch  => 'SML-0.0.1' );
PROMPT Check ARM version supports this patch.
execute &&APEXRM_user..arm_installer.add_patch_prereq( -
i_patch_name     => 'SML-0.0.2' -
,i_prereq_patch  => 'ARM-01.02.APEXRM' );
select user||'@'||global_name Connection from global_name;
COMMIT;
Prompt installing PATCHES

PROMPT version\SML-02\SML-02.03.LOGGER 
@version\SML-02\SML-02.03.LOGGER\install.sql;
execute &&APEXRM_user..arm_installer.patch_completed(i_patch_name  => 'SML-0.0.2');
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
