--ms_uninstall.sql

set feedback off
set head off
set arraysize 1
set trims on
set linesize 1000
set pagesize 0
set termout on
set verify off
set scan on

spool ms_uninstall_1.sql
prompt prompt Dropping Tables
select 'DROP TABLE MS_INTERNAL_ERROR;' from dual where exists (select 1 from user_tables where table_name = 'MS_INTERNAL_ERROR');
select 'DROP TABLE MS_LARGE_MESSAGE;'  from dual where exists (select 1 from user_tables where table_name = 'MS_LARGE_MESSAGE' );
select 'DROP TABLE MS_MESSAGE;'        from dual where exists (select 1 from user_tables where table_name = 'MS_MESSAGE'       );
select 'DROP TABLE MS_REFERENCE;'      from dual where exists (select 1 from user_tables where table_name = 'MS_REFERENCE'     );
select 'DROP TABLE MS_TRAVERSAL;'      from dual where exists (select 1 from user_tables where table_name = 'MS_TRAVERSAL'     );
select 'DROP TABLE MS_UNIT;'           from dual where exists (select 1 from user_tables where table_name = 'MS_UNIT'          );
select 'DROP TABLE MS_MODULE;'         from dual where exists (select 1 from user_tables where table_name = 'MS_MODULE'        );
select 'DROP TABLE MS_PROCESS;'        from dual where exists (select 1 from user_tables where table_name = 'MS_PROCESS'       );

prompt prompt Dropping Synonyms
select 'DROP SEQUENCE MS_PROCESS_SEQ;'   from dual where exists (select 1 from user_sequences where SEQUENCE_NAME = 'MS_PROCESS_SEQ'  );
select 'DROP SEQUENCE MS_MESSAGE_SEQ;'   from dual where exists (select 1 from user_sequences where SEQUENCE_NAME = 'MS_MESSAGE_SEQ'  );
select 'DROP SEQUENCE MS_TRAVERSAL_SEQ;' from dual where exists (select 1 from user_sequences where SEQUENCE_NAME = 'MS_TRAVERSAL_SEQ');
select 'DROP SEQUENCE MS_MODULE_SEQ;'    from dual where exists (select 1 from user_sequences where SEQUENCE_NAME = 'MS_MODULE_SEQ'   );
select 'DROP SEQUENCE MS_UNIT_SEQ;'      from dual where exists (select 1 from user_sequences where SEQUENCE_NAME = 'MS_UNIT_SEQ'     );

prompt prompt Dropping Views
select 'DROP VIEW MS_MESSAGE_VW;'             from dual where exists (select 1 from user_views where view_NAME = 'MS_MESSAGE_VW'  );
select 'DROP VIEW MS_UNIT_TRAVERSAL_VW;'      from dual where exists (select 1 from user_views where view_NAME = 'MS_UNIT_TRAVERSAL_VW'  );
select 'DROP VIEW MS_UNIT_VW;'                from dual where exists (select 1 from user_views where view_NAME = 'MS_UNIT_VW'  );
select 'DROP VIEW MS_MODULE_VW;'              from dual where exists (select 1 from user_views where view_NAME = 'MS_MODULE_VW'  );
select 'DROP VIEW MS_TRAVERSAL_MESSAGE_VW;'   from dual where exists (select 1 from user_views where view_NAME = 'MS_TRAVERSAL_MESSAGE_VW'  );
select 'DROP VIEW MS_TRAVERSAL_REFERENCE_VW;' from dual where exists (select 1 from user_views where view_NAME = 'MS_TRAVERSAL_REFERENCE_VW'  );

prompt prompt Dropping Table APIs
select 'DROP PACKAGE '||OBJECT_NAME||';'     from user_objects where OBJECT_NAME IN ( 'MS_METACODE','MS_TEST') and object_type = 'PACKAGE' ;

spool off;

prompt execute the line below if satisified with the list of objects to drop
prompt @ms_uninstall_1.sql;
