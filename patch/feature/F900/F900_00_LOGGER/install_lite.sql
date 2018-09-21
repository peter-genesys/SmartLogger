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
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

