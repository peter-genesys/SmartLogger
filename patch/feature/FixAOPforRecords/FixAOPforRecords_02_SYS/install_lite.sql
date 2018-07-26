PROMPT LOG TO FixAOPforRecords_02_SYS.log
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

define patch_name = 'FixAOPforRecords_02_SYS'
define patch_desc = 'Allow logger files to be installed in schema with any name'
define patch_path = 'feature/FixAOPforRecords/FixAOPforRecords_02_SYS/'
SPOOL FixAOPforRecords_02_SYS.log
CONNECT SYS/&&SYS_password@&&database as sysdba
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT USERS

WHENEVER SQLERROR CONTINUE
PROMPT logger.user 
@&&patch_path.logger.user;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

