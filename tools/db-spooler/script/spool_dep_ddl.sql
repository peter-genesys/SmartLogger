--spool_dep_ddl.sql

SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

define owner='&1'
define object_type='&2'
define object_name='&3'
define dep_ddl_type='&4'

spool &OWNER._&OBJECT_TYPE._dep_ddl.lst append

BEGIN

   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'EMIT_SCHEMA'         , false); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'PRETTY'              , true ); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'SQLTERMINATOR'       , true ); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES'  , false); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'CONSTRAINTS'         , false); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'REF_CONSTRAINTS'     , false); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'CONSTRAINTS_AS_ALTER', false); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'STORAGE'             , false); 
   DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'TABLESPACE'          , false); 

END;
/

prompt prompt &DEP_DDL_TYPE for &OBJECT_TYPE &OWNER..&OBJECT_NAME
 
SELECT to_char(dbms_metadata.get_dependent_ddl('&DEP_DDL_TYPE',object_name,owner)) ddl
FROM   dba_objects
WHERE  owner       = '&OWNER' 
and    object_type = '&OBJECT_TYPE'
and    object_name = '&OBJECT_NAME';

spool off;
SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON

 


