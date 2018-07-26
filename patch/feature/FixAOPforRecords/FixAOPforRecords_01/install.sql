PROMPT LOG TO FixAOPforRecords_01.log
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

define patch_name = 'FixAOPforRecords_01'
define patch_desc = 'Introducing PLScope'
define patch_path = 'feature/FixAOPforRecords/FixAOPforRecords_01/'
SPOOL FixAOPforRecords_01.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'FixAOPforRecords_01' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&LOGGER_user' -
 ,i_branch_name        => 'feature/FixAOPforRecords' -
 ,i_tag_from           => 'FixAOPforRecords.01A' -
 ,i_tag_to             => 'FixAOPforRecords.01B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Introducing PLScope' -
 ,i_patch_componants   => 'ms_process_01.tab' -
||',ms_logger.pks' -
||',ms_api.pks' -
||',aop_processor.pks' -
||',aop_test.pks' -
||',aop_test2.pks' -
||',aop_source_v.vw' -
||',ms_logger.pkb' -
||',ms_api.pkb' -
||',aop_processor.pkb' -
||',aop_test.pkb' -
||',aop_test2.pkb' -
 ,i_patch_create_date  => '06-01-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => 'Improve support for record types' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'FixAOPforRecords_01' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT ms_process_01.tab 
@&&patch_path.ms_process_01.tab;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT PACKAGE SPECS

PROMPT ms_logger.pks 
@&&patch_path.ms_logger.pks;
Show error;

PROMPT ms_api.pks 
@&&patch_path.ms_api.pks;
Show error;

WHENEVER SQLERROR CONTINUE
PROMPT aop_processor.pks 
@&&patch_path.aop_processor.pks;
Show error;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT aop_test.pks 
@&&patch_path.aop_test.pks;
Show error;

PROMPT aop_test2.pks 
@&&patch_path.aop_test2.pks;
Show error;

PROMPT VIEWS

PROMPT aop_source_v.vw 
@&&patch_path.aop_source_v.vw;
Show error;

PROMPT PACKAGE BODIES

PROMPT ms_logger.pkb 
@&&patch_path.ms_logger.pkb;
Show error;

PROMPT ms_api.pkb 
@&&patch_path.ms_api.pkb;
Show error;

WHENEVER SQLERROR CONTINUE
PROMPT aop_processor.pkb 
@&&patch_path.aop_processor.pkb;
Show error;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT aop_test.pkb 
@&&patch_path.aop_test.pkb;
Show error;

PROMPT aop_test2.pkb 
@&&patch_path.aop_test2.pkb;
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

