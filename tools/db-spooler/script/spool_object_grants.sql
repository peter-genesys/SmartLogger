--spool_object_grants.sql
whenever sqlerror continue;

SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
spool call_spool_object_grants.lst

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT '@spool_dep_ddl '||owner||' '||object_type||' '||object_name||' '||'OBJECT_GRANT' spool_cmd
FROM   dba_objects
WHERE  owner IN ('GNOWN','QHOWN','QHIDSOWN','SECOWN') 
and    object_type IN ('PACKAGE','TYPE','FUNCTION','PROCEDURE','VIEW')
order by owner, object_type, object_name;


spool off;
SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON

 


