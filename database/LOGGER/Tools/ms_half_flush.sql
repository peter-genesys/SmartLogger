prompt $Id: ms_half_flush.sql 422 2007-11-17 02:47:50Z Peter $
--delete from  ms_reference;
--delete from  ms_message;
--delete from  ms_traversal;
alter table MS_MESSAGE disable constraint MESS_TRAV_FK;
truncate table ms_message;

alter table MS_TRAVERSAL disable constraint TRAV_UNIT_FK;
alter table MS_TRAVERSAL disable constraint TRAV_TRAV_FK;
alter table MS_TRAVERSAL disable constraint TRAV_PROCESS_FK;
truncate table ms_traversal;

truncate table ms_process;

--Re-enable constraints
alter table MS_MESSAGE enable constraint MESS_TRAV_FK;
alter table MS_TRAVERSAL enable constraint TRAV_UNIT_FK;
alter table MS_TRAVERSAL enable constraint TRAV_TRAV_FK;
alter table MS_TRAVERSAL enable constraint TRAV_PROCESS_FK;


PROMPT Creating Sequence 'MS_PROCESS_SEQ'
DROP SEQUENCE MS_PROCESS_SEQ
/
CREATE SEQUENCE MS_PROCESS_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOCACHE
NOCYCLE
NOORDER
/

PROMPT Creating Sequence 'MS_MESSAGE_SEQ'
DROP SEQUENCE MS_MESSAGE_SEQ
/
CREATE SEQUENCE MS_MESSAGE_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOCACHE
NOCYCLE
NOORDER
/

PROMPT Creating Sequence 'MS_TRAVERSAL_SEQ'
DROP SEQUENCE MS_TRAVERSAL_SEQ
/
CREATE SEQUENCE MS_TRAVERSAL_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOCACHE
NOCYCLE
NOORDER
/



commit;