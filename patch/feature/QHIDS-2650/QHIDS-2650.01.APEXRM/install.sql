PROMPT LOG TO QHIDS-2650.01.APEXRM.log
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

define patch_name = 'QHIDS-2650.01.APEXRM'
define patch_desc = 'QHIDS-2650 - Revert theme style to Vita (Apex Apps Only)'
define patch_path = 'feature/QHIDS-2650/QHIDS-2650.01.APEXRM/'
SPOOL QHIDS-2650.01.APEXRM.log
CONNECT APEXRM/&&APEXRM_password@&&database
set serveroutput on;
execute &&APEXRM_user..arm_installer.patch_started( -
  i_patch_name         => 'QHIDS-2650.01.APEXRM' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'APEXRM' -
 ,i_app_code           => 'SML' -
 ,i_branch_name        => 'feature/QHIDS-2650' -
 ,i_tag_from           => 'QHIDS-2650.01A' -
 ,i_tag_to             => 'QHIDS-2650.01B' -
 ,i_suffix             => '' -
 ,i_patch_desc         => 'QHIDS-2650 - Revert theme style to Vita (Apex Apps Only)' -
 ,i_patch_components   => '' -
 ,i_patch_create_date  => '05-13-2019' -
 ,i_patch_created_by   => 'BurgPete' -
 ,i_note               => 'f900 f900 ' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_tracking_yn        => 'Y' -
 ,i_alt_schema_yn      => 'N' -
 ,i_retired_yn         => 'N' -
 ,i_remove_prereqs     => 'Y' );

PROMPT Ensure ARM is late enough for this patch
execute &&APEXRM_user..arm_installer.add_prereq_best_order( -
i_patch_name     => 'QHIDS-2650.01.APEXRM' -
,i_prereq_patch  => 'SDEPLOY-30.01.APEXRM' );
select user||'@'||global_name Connection from global_name;


COMMIT;
PROMPT Compiling objects in schema APEXRM
execute &&APEXRM_user..arm_invoker.compile_post_patch;
PROMPT Enqueue Apex App 900
execute &&APEXRM_user..arm_installer.add_apex_app( -
i_patch_name     => 'QHIDS-2650.01.APEXRM' -
,i_app_id     => '900' -
,i_schema  => 'LOGGER' );
--APEXRM patches are likely to loose the session state of arm_installer, so complete using the patch_name parm.
execute &&APEXRM_user..arm_installer.patch_completed(i_patch_name  => 'QHIDS-2650.01.APEXRM');
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;
CONNECT &&APEXRM_user/&&APEXRM_password@&&database
script &&load_log_file &&patch_name
COMMIT;

