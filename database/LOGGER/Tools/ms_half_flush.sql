prompt $Id: ms_half_flush.sql 422 2007-11-17 02:47:50Z Peter $
--delete from  ms_reference;
--delete from  ms_message;
--delete from  ms_traversal;
prompt delete process will remove related ms_reference, ms_message, ms_large_message, ms_traversal by cascade delete
delete from  ms_process;

delete from ms_internal_error;


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
CACHE 20
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
CACHE 20
NOCYCLE
NOORDER
/



commit;