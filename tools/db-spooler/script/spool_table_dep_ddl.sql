--spool_table_dep_ddl.sql
whenever sqlerror continue;

SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
spool call_spool_table_ddl.lst

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT '@spool_dep_ddl '||owner||' '||object_type||' '||object_name||' '||'CONSTRAINT'      ||chr(10)
     ||'@spool_dep_ddl '||owner||' '||object_type||' '||object_name||' '||'REF_CONSTRAINT'   spool_cmd
FROM   dba_objects
WHERE  owner IN ('GNOWN','QHOWN','QHIDSOWN','SECOWN') 
and    object_type IN ('TABLE')
order by owner, object_type, object_name;


spool off;
SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON

 


