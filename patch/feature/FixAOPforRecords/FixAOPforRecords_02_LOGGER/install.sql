PROMPT LOG TO FixAOPforRecords_02_LOGGER.log
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

define patch_name = 'FixAOPforRecords_02_LOGGER'
define patch_desc = 'Introducing PLScope'
define patch_path = 'feature/FixAOPforRecords/FixAOPforRecords_02_LOGGER/'
SPOOL FixAOPforRecords_02_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'FixAOPforRecords_02_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/FixAOPforRecords' -
 ,i_tag_from           => 'FixAOPforRecords.02A' -
 ,i_tag_to             => 'FixAOPforRecords.02B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Introducing PLScope' -
 ,i_patch_componants   => 'ms_tables.tab' -
||',ms_logger.pks' -
||',ms_api.pks' -
||',sm_jotter.pks' -
||',aop_processor.pks' -
||',aop_source_v.vw' -
||',dba_objects_v.vw' -
||',dba_source_v.vw' -
||',ms_views.vw' -
||',enduser.grt' -
||',aop_processor.pkb' -
||',ms_api.pkb' -
||',ms_logger.pkb' -
||',sm_jotter.pkb' -
||',ms_config_pop.sql' -
||',aop_processor.pts' -
 ,i_patch_create_date  => '07-26-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch FixAOPforRecords_01
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'FixAOPforRecords_02_LOGGER' -
,i_prereq_patch  => 'FixAOPforRecords_01' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'FixAOPforRecords_02_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

PROMPT ms_tables.tab 
@&&patch_path.ms_tables.tab;

PROMPT PACKAGE SPECS

PROMPT ms_logger.pks 
@&&patch_path.ms_logger.pks;
Show error;

PROMPT ms_api.pks 
@&&patch_path.ms_api.pks;
Show error;

PROMPT sm_jotter.pks 
@&&patch_path.sm_jotter.pks;
Show error;

PROMPT aop_processor.pks 
@&&patch_path.aop_processor.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@&&patch_path.aop_source_v.vw;
Show error;

PROMPT dba_objects_v.vw 
@&&patch_path.dba_objects_v.vw;
Show error;

PROMPT dba_source_v.vw 
@&&patch_path.dba_source_v.vw;
Show error;

PROMPT ms_views.vw 
@&&patch_path.ms_views.vw;
Show error;

PROMPT GRANTS

PROMPT enduser.grt 
@&&patch_path.enduser.grt;

PROMPT PACKAGE BODIES

PROMPT aop_processor.pkb 
@&&patch_path.aop_processor.pkb;
Show error;

PROMPT ms_api.pkb 
@&&patch_path.ms_api.pkb;
Show error;

PROMPT ms_logger.pkb 
@&&patch_path.ms_logger.pkb;
Show error;

PROMPT sm_jotter.pkb 
@&&patch_path.sm_jotter.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT ms_config_pop.sql 
@&&patch_path.ms_config_pop.sql;

COMMIT;
PROMPT Compiling objects in schema &&LOGGER_user
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

