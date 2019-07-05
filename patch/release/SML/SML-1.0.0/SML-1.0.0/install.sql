PROMPT LOG TO SML-1.0.0.log
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

SPOOL SML-1.0.0.log
CONNECT &&APEXRM_user/&&APEXRM_password@&&database
set serveroutput on;
execute &&APEXRM_user..arm_installer.patch_started( -
  i_patch_name         => 'SML-1.0.0' -
 ,i_patch_type         => 'release' -
 ,i_db_schema          => 'APEXRM' -
 ,i_app_code           => 'SML' -
 ,i_branch_name        => 'release/SML/SML-1.0.0' -
 ,i_tag_from           => 'release/SML/SML-0.0.2' -
 ,i_tag_to             => 'release/SML/SML-1.0.0' -
 ,i_suffix             => '' -
 ,i_patch_desc         => 'Initial Major Release' -
 ,i_patch_components   => 'feature\SDEPLOY-41\SDEPLOY-41.01.LOGGER' -
||',feature\QHIDS-2650\QHIDS-2650.01.APEXRM' -
||',feature\SML-001\SML-001.01.LOGGER' -
 ,i_patch_create_date  => '07-05-2019' -
 ,i_patch_created_by   => 'BurgPete' -
 ,i_note               => 'NB Not a full release.  Depends on SML-0.0.2' -
 ,i_rerunnable_yn      => 'N' -
 ,i_tracking_yn        => 'Y' -
 ,i_alt_schema_yn      => 'Y' -
 ,i_retired_yn         => 'N'); 

PROMPT
PROMPT Checking Prerequisite patch SML-0.0.2
execute &&APEXRM_user..arm_installer.add_patch_prereq( -
i_patch_name     => 'SML-1.0.0' -
,i_prereq_patch  => 'SML-0.0.2' );
PROMPT Check ARM version supports this patch.
execute &&APEXRM_user..arm_installer.add_patch_prereq( -
i_patch_name     => 'SML-1.0.0' -
,i_prereq_patch  => 'SDEPLOY-30.01.APEXRM' );
select user||'@'||global_name Connection from global_name;
COMMIT;
Prompt installing PATCHES
spool off;

SPOOL SML-1.0.0.log APPEND
PROMPT feature\SDEPLOY-41\SDEPLOY-41.01.LOGGER 
spool off;
@feature\SDEPLOY-41\SDEPLOY-41.01.LOGGER\install.sql;
SPOOL SML-1.0.0.log APPEND
PROMPT feature\QHIDS-2650\QHIDS-2650.01.APEXRM 
spool off;
@feature\QHIDS-2650\QHIDS-2650.01.APEXRM\install.sql;
SPOOL SML-1.0.0.log APPEND
PROMPT feature\SML-001\SML-001.01.LOGGER 
spool off;
@feature\SML-001\SML-001.01.LOGGER\install.sql;
SPOOL SML-1.0.0.log APPEND
execute &&APEXRM_user..arm_installer.patch_completed(i_patch_name  => 'SML-1.0.0');
COMMIT;
spool off;
SPOOL SML-1.0.0.log APPEND
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;
