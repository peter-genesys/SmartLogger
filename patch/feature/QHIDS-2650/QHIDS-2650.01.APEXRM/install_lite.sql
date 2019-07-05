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
select user||'@'||global_name Connection from global_name;


COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

