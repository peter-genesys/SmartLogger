PROMPT LOG TO FixAOPforRecords_02_ENDUSER.log
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

define patch_name = 'FixAOPforRecords_02_ENDUSER'
define patch_desc = 'Allow logger files to be installed in schema with any name'
define patch_path = 'feature/FixAOPforRecords/FixAOPforRecords_02_ENDUSER/'
SPOOL FixAOPforRecords_02_ENDUSER.log
CONNECT ENDUSER/&&ENDUSER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT SYNONYMS

PROMPT logger.syn 
@&&patch_path.logger.syn;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

