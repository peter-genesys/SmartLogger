PROMPT LOG TO VER-02_01A_01B_LOGGER.log
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

define patch_name = 'VER-02_01A_01B_LOGGER'
define patch_desc = 'Install Logger objects'
define patch_path = 'feature/log/VER-02/VER-02_01A_01B_LOGGER/'
SPOOL VER-02_01A_01B_LOGGER.log
CONNECT &&LOGGER_user/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_rebuild_tables.sql 
@&&patch_path.sm_rebuild_tables.sql;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT FUNCTIONS

WHENEVER SQLERROR CONTINUE
PROMPT sm_call_tree_parent_id.fnc 
@&&patch_path.sm_call_tree_parent_id.fnc;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
Show error;

PROMPT PROCEDURES

PROMPT ins_upd_sm_source.prc 
@&&patch_path.ins_upd_sm_source.prc;
Show error;

PROMPT PACKAGE SPECS

PROMPT sm_api.pks 
@&&patch_path.sm_api.pks;
Show error;

PROMPT sm_jotter.pks 
@&&patch_path.sm_jotter.pks;
Show error;

WHENEVER SQLERROR CONTINUE
PROMPT sm_logger.pks 
@&&patch_path.sm_logger.pks;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
Show error;

PROMPT sm_weaver.pks 
@&&patch_path.sm_weaver.pks;
Show error;

PROMPT VIEWS

PROMPT dba_objects.vw 
@&&patch_path.dba_objects.vw;
Show error;

PROMPT dba_objects_v_alt.vw 
@&&patch_path.dba_objects_v_alt.vw;
Show error;

PROMPT dba_source.vw 
@&&patch_path.dba_source.vw;
Show error;

PROMPT dba_source_v_alt.vw 
@&&patch_path.dba_source_v_alt.vw;
Show error;

PROMPT dba_tab_columns.vw 
@&&patch_path.dba_tab_columns.vw;
Show error;

PROMPT dba_tables.vw 
@&&patch_path.dba_tables.vw;
Show error;

PROMPT sm_views.vw 
@&&patch_path.sm_views.vw;
Show error;

PROMPT sm_source_v.vw 
@&&patch_path.sm_source_v.vw;
Show error;

PROMPT sm_session_v2.vw 
@&&patch_path.sm_session_v2.vw;
Show error;

PROMPT sm_session_v3.vw 
@&&patch_path.sm_session_v3.vw;
Show error;

PROMPT sm_apex_context_collection_v.vw 
@&&patch_path.sm_apex_context_collection_v.vw;
Show error;

PROMPT sm_context_tree_v.vw 
@&&patch_path.sm_context_tree_v.vw;
Show error;

PROMPT sm_db_context_tree_v.vw 
@&&patch_path.sm_db_context_tree_v.vw;
Show error;

PROMPT GRANTS

PROMPT enduser.grt 
@&&patch_path.enduser.grt;

PROMPT SYNONYMS

PROMPT logger.pub.syn 
@&&patch_path.logger.pub.syn;

PROMPT PACKAGE BODIES

PROMPT sm_api.pkb 
@&&patch_path.sm_api.pkb;
Show error;

PROMPT sm_jotter.pkb 
@&&patch_path.sm_jotter.pkb;
Show error;

WHENEVER SQLERROR CONTINUE
PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
Show error;

PROMPT sm_weaver.pkb 
@&&patch_path.sm_weaver.pkb;
Show error;

PROMPT MISCELLANEOUS

PROMPT sm_config_pop.sql 
@&&patch_path.sm_config_pop.sql;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

