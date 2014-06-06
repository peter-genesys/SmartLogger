CREATE OR REPLACE PACKAGE BODY ms_metacode IS
------------------------------------------------------------------
-- Program  : ms_metacode  
-- Name     : Metacode for PL/SQL
-- Author   : P.Burgess
-- Date     : 23/10/2006
-- Purpose  : Logging and error handling for PL/SQL 
------------------------------------------------------------------------
-- @AOP_NEVER

-- Quiet Mode
-- Any unit set to msg_mode QUIET will not cause traversals to be logged unless:
-- A. An exception occurs in the traversal, or a later unlogged traversal
--    In this case the traversal is logged with msg_mode DEBUG
-- B. A later traversal is to be logged for a DEBUG or NORMAL unit.
--    In this case the traversal is logged with msg_mode QUIET
------------------------------------------------------------------------
-- Internal Errors 
-- If an internal error is detected (internal to this package), then the internal error flag
-- is set, and further logs and pushes are not attempted until the process has finished.
------------------------------------------------------------------------
-- 
--
--MANAGEMENT OF INTERNAL ERRORS
--=============================
--Any node that is created when the system is not in an internal error, 
--will have the internal error flag set at false, and will have a nesting level.
--Once the system hits an internal error, no nodes are created or logged.
--System will wait for the code to drop out again.
------------------------------------------------------------------------
 
------------------------------------------------------------------------
  g_debug_mode         BOOLEAN := FALSE;

  g_package_name       VARCHAR2(30)  := 'ms_metacode';
  g_package_revision   VARCHAR2(30)  := '10.14';


G_MODULE_NAME_WIDTH     CONSTANT NUMBER := 50;
G_UNIT_NAME_WIDTH       CONSTANT NUMBER := 50;
G_REF_NAME_WIDTH        CONSTANT NUMBER := 30;
G_REF_DATA_WIDTH        CONSTANT NUMBER := 100;
G_MESSAGE_WIDTH         CONSTANT NUMBER := 200;
G_INTERNAL_ERROR_WIDTH  CONSTANT NUMBER := 200;
G_LARGE_MESSAGE_WIDTH   CONSTANT NUMBER := 4000;
G_CALL_STACK_WIDTH      CONSTANT NUMBER := 2000;
        
--TYPE ms_reference%ROWTYPE IS RECORD
--  (unit_index       NUMBER      --pointer to a unit_stack
--  ,reference        ms_reference%ROWTYPE 
--  ,logged           BOOLEAN);

TYPE ref_list IS TABLE OF ms_reference%ROWTYPE INDEX BY BINARY_INTEGER;


--PAB 22/08/2013 (should this be an object with an attached node?)
TYPE traversal_item_type IS RECORD
  (traversal      ms_traversal%ROWTYPE
  ,module_name    ms_module.module_name%TYPE
  ,unit_name      ms_unit.unit_name%TYPE
  ,unit_type      ms_unit.unit_type%TYPE
  ,open_process   ms_unit.open_process%TYPE
  ,logged         BOOLEAN
  ,unlogged_refs  ref_list
  ,call_stack     varchar2(2000) 
  ); 

TYPE traversal_stack_type IS
  TABLE OF traversal_item_type
  INDEX BY BINARY_INTEGER;

 
  
  

G_YES                   CONSTANT VARCHAR2(20) := 'Y';
G_NO                    CONSTANT VARCHAR2(20) := 'N';
G_TRUE                  CONSTANT VARCHAR2(20) := 'TRUE';
G_FALSE                 CONSTANT VARCHAR2(20) := 'FALSE';
G_NULL                  CONSTANT VARCHAR2(20) := 'NULL';
G_NL                    CONSTANT VARCHAR2(2)  := CHR(10);

--NEW CONTROLS
g_process_id            NUMBER;

--g_dumping               BOOLEAN := FALSE;
g_internal_error        BOOLEAN := FALSE;


--extra controls
g_time                  DATE    := NULL;
--g_unit_stack            unit_stack_type;
--g_unit_index            NUMBER  := 0;

g_traversals             traversal_stack_type;
 


g_max_nested_units      NUMBER   := 20;   --sx_lookup_pkg.lookup_desc('MAX_DEPTH','MESSAGE_PARAM');

G_MSG_LEVEL_IGNORE      CONSTANT NUMBER(2) := 0;
G_MSG_LEVEL_COMMENT     CONSTANT NUMBER(2) := 1;
G_MSG_LEVEL_INFO        CONSTANT NUMBER(2) := 2;
G_MSG_LEVEL_WARNING     CONSTANT NUMBER(2) := 3;
G_MSG_LEVEL_FATAL       CONSTANT NUMBER(2) := 4;
G_MSG_LEVEL_ORACLE      CONSTANT NUMBER(2) := 5;
G_MSG_LEVEL_INTERNAL    CONSTANT NUMBER(2) := 6;

G_MSG_MODE_DEBUG        CONSTANT NUMBER(2) := G_MSG_LEVEL_COMMENT; 
G_MSG_MODE_NORMAL       CONSTANT NUMBER(2) := G_MSG_LEVEL_INFO;
G_MSG_MODE_QUIET        CONSTANT NUMBER(2) := G_MSG_LEVEL_FATAL;
G_MSG_MODE_DEFAULT      CONSTANT NUMBER(2) := NULL;
 
 
 
--Node Types
--Root Only  - Will end current process and start a new one.
--Root Never - Will not start a process
--Either will start a process if none started and Normal, or Debug msg_mode.

--Open Process  open_process
--Always        Y
--If Closed     C
--Never         N 
 
G_OPEN_PROCESS_ALWAYS     CONSTANT ms_unit.open_process%TYPE := 'Y'; 
G_OPEN_PROCESS_IF_CLOSED  CONSTANT ms_unit.open_process%TYPE := 'C';
G_OPEN_PROCESS_NEVER      CONSTANT ms_unit.open_process%TYPE := 'N';
G_OPEN_PROCESS_DEFAULT    CONSTANT ms_unit.open_process%TYPE := NULL;
 
------------------------------------------------------------------------
-- UNIT TYPES (Private)
------------------------------------------------------------------------
--GENERAL UNIT TYPES 
G_UNIT_TYPE_PROCEDURE     CONSTANT ms_unit.unit_type%TYPE := 'PROC';
G_UNIT_TYPE_FUNCTION      CONSTANT ms_unit.unit_type%TYPE := 'FUNC';
G_UNIT_TYPE_LOOP          CONSTANT ms_unit.unit_type%TYPE := 'LOOP';
G_UNIT_TYPE_BLOCK         CONSTANT ms_unit.unit_type%TYPE := 'BLOCK';
G_UNIT_TYPE_TRIGGER       CONSTANT ms_unit.unit_type%TYPE := 'TRIGGER';
G_UNIT_TYPE_SQL           CONSTANT ms_unit.unit_type%TYPE := 'SQL_SCRIPT';
G_UNIT_TYPE_PASS          CONSTANT ms_unit.unit_type%TYPE := 'PASS';
 
--FORM TRIGGER UNIT TYPES 
G_UNIT_TYPE_FORM_TRIGGER   CONSTANT ms_unit.unit_type%TYPE := 'FORM_TRIG'; 
G_UNIT_TYPE_BLOCK_TRIGGER  CONSTANT ms_unit.unit_type%TYPE := 'BLOCK_TRIG'; 
G_UNIT_TYPE_RECORD_TRIGGER CONSTANT ms_unit.unit_type%TYPE := 'REC_TRIG'; 
G_UNIT_TYPE_ITEM_TRIGGER   CONSTANT ms_unit.unit_type%TYPE := 'ITEM_TRIG'; 

--REPORT TRIGGER UNIT TYPES
G_UNIT_TYPE_REPORT_TRIGGER  CONSTANT ms_unit.unit_type%TYPE := 'REP_TRIG'; 
G_UNIT_TYPE_FORMAT_TRIGGER  CONSTANT ms_unit.unit_type%TYPE := 'FORMAT_TRG'; 
G_UNIT_TYPE_GROUP_FILTER    CONSTANT ms_unit.unit_type%TYPE := 'GRP_FILTER'; 
 
G_MODULE_TYPE_PACKAGE     CONSTANT ms_module.module_type%TYPE := 'PACKAGE';
G_MODULE_TYPE_PROCEDURE   CONSTANT ms_module.module_type%TYPE := 'PROCEDURE';
G_MODULE_TYPE_FUNCTION    CONSTANT ms_module.module_type%TYPE := 'FUNCTION';
G_MODULE_TYPE_FORM        CONSTANT ms_module.module_type%TYPE := 'FORM';
G_MODULE_TYPE_REPORT      CONSTANT ms_module.module_type%TYPE := 'REPORT';
G_MODULE_TYPE_SQL         CONSTANT ms_module.module_type%TYPE := 'SQL_SCRIPT';
G_MODULE_TYPE_DBTRIGGER   CONSTANT ms_module.module_type%TYPE := 'DB_TRIG';
 
/* 
------------------------------------------------------------------------
-- Expose constants via functions for UT_LIB(Public)
------------------------------------------------------------------------
 
FUNCTION F_UNIT_TYPE_FORM_TRIGGER   RETURN VARCHAR2 IS BEGIN RETURN G_UNIT_TYPE_FORM_TRIGGER  ; END;  
FUNCTION F_UNIT_TYPE_BLOCK_TRIGGER  RETURN VARCHAR2 IS BEGIN RETURN G_UNIT_TYPE_BLOCK_TRIGGER ; END;
FUNCTION F_UNIT_TYPE_RECORD_TRIGGER RETURN VARCHAR2 IS BEGIN RETURN G_UNIT_TYPE_RECORD_TRIGGER; END;
FUNCTION F_UNIT_TYPE_ITEM_TRIGGER   RETURN VARCHAR2 IS BEGIN RETURN G_UNIT_TYPE_ITEM_TRIGGER  ; END;
*/ 
 
--PRIVATE FUNCTIONS
 
--  --------------------------------------------------------------------
--  --insert_reminder
--  -------------------------------------------------------------------- 
-- 
--PROCEDURE insert_reminder( i_reminders IN reminders%ROWTYPE) IS
-- 
--  l_reminders reminders%ROWTYPE;
--  
--  PRAGMA AUTONOMOUS_TRANSACTION;
--
--BEGIN
--
--  l_reminders := i_reminders;
--
--  l_reminders.reminder_to          := nvl(nvl(i_reminders.reminder_to  ,concept_general.get_code_desc('CON_DEF','MAIL_ADMIN')),'NO-ADMIN-ADDRESS');
--  l_reminders.reminder_from        := nvl(nvl(i_reminders.reminder_from,concept_general.get_code_desc('CON_DEF','MAIL_FROM')) ,'NO-FROM-ADDRESS') ;
--
--  l_reminders.reminder_date        := NVL(i_reminders.reminder_date  , trunc(sysdate))                                             ;
--  l_reminders.reminder_time        := NVL(i_reminders.reminder_time  , to_number(to_char(sysdate,'HH24MI')))                      ;
--                                                            
--  insert into reminders values l_reminders;
--  commit;
--
--END;
   
   
--  --------------------------------------------------------------------
--  --insert_reminder
--  -------------------------------------------------------------------- 
-- 
--PROCEDURE insert_reminder( i_reminder_to          IN   VARCHAR2 DEFAULT NULL
--                          ,i_reminder_from        IN   VARCHAR2 DEFAULT NULL
--                          ,i_reminder_type        IN   VARCHAR2 DEFAULT 'REM'
--                          ,i_reminder_message     IN   VARCHAR2 DEFAULT NULL
--                          ,i_reminder_date        IN   DATE     DEFAULT NULL
--                          ,i_reminder_time        IN   NUMBER   DEFAULT NULL
--                          ,i_processed            IN   VARCHAR2 DEFAULT 'N'
--                          ,i_reminder_time_char   IN   VARCHAR2 DEFAULT NULL
--                          ,i_reminder_id          IN   NUMBER   DEFAULT NULL
--                          ,i_transn_pending_id    IN   NUMBER   DEFAULT NULL
--                          ,i_email_addr_type_to   IN   VARCHAR2 DEFAULT NULL
--                          ,i_email_addr_type_cc   IN   VARCHAR2 DEFAULT NULL
--                          ,i_reminder_cc          IN   VARCHAR2 DEFAULT NULL
--                          ,i_notify_id            IN   VARCHAR2 DEFAULT NULL
--                          ,i_append_sid           IN   BOOLEAN  DEFAULT FALSE
--                          ) IS
--          
--
--  l_reminders reminders%ROWTYPE;
-- 
--
--BEGIN
--
--  l_reminders.reminder_to          := i_reminder_to     ;
--  l_reminders.reminder_from        := i_reminder_from   ;
--  l_reminders.reminder_type        := i_reminder_type   ;
--  l_reminders.reminder_message     := i_reminder_message;
--  IF i_append_sid THEN
--    l_reminders.reminder_message     := l_reminders.reminder_message ||' - '||concept_general.get_code_desc('REP_DEF','ALESCO_SID');
--  END IF;
--  l_reminders.reminder_date        := i_reminder_date       ;
--  l_reminders.reminder_time        := NVL(i_reminder_time,i_reminder_time_char) ;
--  l_reminders.processed            := i_processed           ;
--  l_reminders.reminder_id          := i_reminder_id         ; 
--  l_reminders.transn_pending_id    := i_transn_pending_id   ;
--  l_reminders.email_addr_type_to   := i_email_addr_type_to  ;
--  l_reminders.email_addr_type_cc   := i_email_addr_type_cc  ;
--  l_reminders.reminder_cc          := i_reminder_cc         ;
--  l_reminders.notify_id            := i_notify_id           ;
--                                                             
--  insert_reminder( i_reminders => l_reminders);
--
--END; 
--   
----------------------------------------------------------------------
---- send_reminder
---------------------------------------------------------------------- 
-- 
--PROCEDURE send_reminder (i_reminder_type        IN   VARCHAR2 DEFAULT 'REM'
--                        ,i_reminder_message     IN   VARCHAR2 DEFAULT NULL
--                        ,i_package_name         IN   VARCHAR2 DEFAULT NULL
--                        ,i_package_revision     IN   VARCHAR2 DEFAULT NULL
--                        ,i_program_unit         IN   VARCHAR2 DEFAULT NULL  ) IS
-- 
--BEGIN
--
--  insert_reminder( i_reminder_type     =>  i_reminder_type   
--                  ,i_reminder_message  =>  i_reminder_message
--                                    ||' '||i_package_name
--                                    ||' '||i_package_revision 
--                                    ||' '||i_program_unit
--                                    ||' - '||concept_general.get_code_desc('REP_DEF','ALESCO_SID')
--                  ,i_append_sid        =>  TRUE);
-- 
--END send_reminder;
   
 
------------------------------------------------------------------------
-- Forward Declarations (Private)
------------------------------------------------------------------------
FUNCTION get_module(i_module_name  IN VARCHAR2
                   ,i_module_type  IN VARCHAR2 DEFAULT 'UNKNOWN'
                   ,i_revision     IN VARCHAR2 DEFAULT 'UNKNOWN')
RETURN ms_module%ROWTYPE;
 
 
/* 
 CREATE OR REPLACE FUNCTION f_split (
    p_list VARCHAR2,
    p_del VARCHAR2 := ','
) RETURN split_tbl pipelined
IS
    l_idx    PLS_INTEGER;
    l_list    VARCHAR2(32767) := p_list;
    l_value VARCHAR2(32767);
BEGIN
    LOOP
        l_idx := INSTR(l_list,p_del);
        IF l_idx > 0 THEN
            pipe ROW(LTRIM(RTRIM(SUBSTR(l_list,1,l_idx-1))));
            l_list := SUBSTR(l_list,l_idx+LENGTH(p_del));
        ELSE
            pipe ROW(LTRIM(RTRIM(l_list)));
            EXIT;
        END IF;
    END LOOP;
    RETURN;
END f_split;
*/ 
 
 

--FUNCTION abbreviate_call_stack(i_call_stack IN VARCHAR2) RETURN VARCHAR2 IS
--  l_lines        APEX_APPLICATION_GLOBAL.VC_ARR2;
--  l_result       VARCHAR2(2000);
--BEGIN
--  --first 3 lines are discarded
--  --creates a set of separated ids on a single line
--  --each id really only indicates the package, but importantly there is one level 
--  --for each nested procedure/function
--  --it will be ordered oldest to latest, left to right
--  --0x349b540c|0x2afa9a38|0x2afa9a38|0x2afa9a38
--  l_lines := APEX_UTIL.STRING_TO_TABLE(i_call_stack,chr(10));
--  FOR i IN REVERSE 4..l_lines.count LOOP
--    l_result := l_result||substr(l_lines(i),1,10)||'|';
--  END LOOP;
--  return l_result;
--   
--END;

FUNCTION abbreviate_call_stack(i_call_stack IN VARCHAR2) RETURN VARCHAR2 IS
  l_lines        APEX_APPLICATION_GLOBAL.VC_ARR2;
  l_result       VARCHAR2(2000);
BEGIN
  --first 4 lines are discarded
  --creates a set of separated ids on a single line
  --each id really only indicates the package, but importantly there is one level 
  --for each nested procedure/function
  --it will be ordered oldest to latest, left to right
  --0x349b540c|0x2afa9a38|0x2afa9a38|0x2afa9a38
  l_lines := APEX_UTIL.STRING_TO_TABLE(i_call_stack,chr(10));
  FOR i IN REVERSE 5..l_lines.count LOOP
    l_result := l_result||substr(l_lines(i),1,10)||'|';
  END LOOP;
  return l_result;
   
END;
 
------------------------------------------------------------------------
-- Node Typ API functions (Public)
------------------------------------------------------------------------

FUNCTION new_node(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
				 ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS
  --must work in SILENT MODE, incase somebody write logic on the app side that depends
  --on l_node                
  l_node ms_metacode.node_typ;  
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
BEGIN

  l_node.module_name := LTRIM(RTRIM(SUBSTR(i_module_name,1,G_MODULE_NAME_WIDTH)));
  l_node.unit_name   := LTRIM(RTRIM(SUBSTR(i_unit_name  ,1,G_UNIT_NAME_WIDTH)));
  l_node.call_stack   := LTRIM(RTRIM(SUBSTR(abbreviate_call_stack(i_call_stack => l_call_stack)  ,1,G_CALL_STACK_WIDTH)));
 
  RETURN l_node;
  
END;

------------------------------------------------------------------------
-- new_node API functions for ORACLE FORMS (Public)
------------------------------------------------------------------------
 
--FORM TRIGGER NODE
FUNCTION form_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL)  RETURN ms_metacode.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_metacode.node_typ := ms_metacode.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_FORM_TRIGGER;
 
  RETURN l_node;
                           
END;

--BLOCK TRIGGER NODE
FUNCTION block_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_metacode.node_typ := ms_metacode.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
  l_node.unit_type := G_UNIT_TYPE_BLOCK_TRIGGER;
 
  RETURN l_node;
                           
END; 

--RECORD TRIGGER NODE
FUNCTION record_trigger_node(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
							,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_metacode.node_typ := ms_metacode.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_RECORD_TRIGGER;
 
  RETURN l_node;
                           
END; 
 
--ITEM TRIGGER NODE
FUNCTION item_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_metacode.node_typ := ms_metacode.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_ITEM_TRIGGER;
 
  RETURN l_node;
                           
END; 

----------------------------------------------------------------------
-- NEW ID's   
-- Get an ID from a sequence (private)
----------------------------------------------------------------------

FUNCTION new_module_id RETURN NUMBER IS
 
BEGIN
 
  RETURN ms_module_seq.NEXTVAL;

END new_module_id;

----------------------------------------------------------------------
 
FUNCTION new_unit_id RETURN NUMBER IS
 
BEGIN
 
  RETURN ms_unit_seq.NEXTVAL;

END new_unit_id;

----------------------------------------------------------------------

FUNCTION new_traversal_id RETURN NUMBER IS
 
BEGIN
 
  RETURN ms_traversal_seq.NEXTVAL;
  
END new_traversal_id;

----------------------------------------------------------------------

FUNCTION new_message_id RETURN NUMBER IS
 
BEGIN
 
  RETURN ms_message_seq.NEXTVAL;

END new_message_id;


------------------------------------------------------------------------
FUNCTION f_current_traversal_id RETURN NUMBER;  -- FORWARD DECLARATION
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Internal debugging routines (private)
-- MS_METACODE cannot reliably log itself. 
-- Output is designed for the unit test "ms_test.sql".
------------------------------------------------------------------------
 
PROCEDURE metacode_putline(i_line IN VARCHAR2 ) IS
--Don't call this directly.
BEGIN 
  IF g_debug_mode THEN
    dbms_output.put_line(i_line);
  END IF;
END; 

PROCEDURE set_internal_error IS
  --set internal error
  --create_ref, create_traversal, log_message will not start 
  --while this flag is set.  
  --These procedures are the ONLY gateways to the LOG and PUSH routines
  
   PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 
 
  g_internal_error := TRUE; 
  metacode_putline('INTERNAL ERROR');
 
  UPDATE ms_process 
  SET internal_error = 'Y'
  WHERE process_id   = g_process_id
  AND internal_error = 'N';
  
  COMMIT;

END; 
 
PROCEDURE metacode_error(i_message IN VARCHAR2 ) IS
   
   PRAGMA AUTONOMOUS_TRANSACTION;

   l_internal_error     ms_internal_error%ROWTYPE;

BEGIN 

  set_internal_error;

  metacode_putline('* '||i_message);
 
  l_internal_error.message      := SUBSTR(i_message,1,G_INTERNAL_ERROR_WIDTH);
  l_internal_error.msg_level    := G_MSG_LEVEL_INTERNAL;
  l_internal_error.message_id   := new_message_id;
  l_internal_error.traversal_id := NVL(f_current_traversal_id,0); -- dummy traversal_id if none current
  l_internal_error.process_id   := g_process_id;
  l_internal_error.time_now     := SYSDATE;

  INSERT INTO ms_internal_error VALUES l_internal_error;
  
  COMMIT;

END; 
 
 
PROCEDURE metacode_ora_error(i_message IN VARCHAR2 ) IS
BEGIN 
  metacode_putline(i_message||':');
  metacode_error(SQLERRM);

END;


PROCEDURE metacode_start(i_message IN VARCHAR2 ) IS
BEGIN 
  metacode_putline('START: '||i_message);
END;

PROCEDURE metacode_debug(i_message IN VARCHAR2 ) IS
BEGIN 
  metacode_putline('!'||i_message);
END;

PROCEDURE metacode_note(i_name  IN VARCHAR2
                       ,i_value IN VARCHAR2) IS
BEGIN 
  metacode_putline('.'||i_name||':'||i_value);
END;

------------------------------------------------------------------------
-- Internal debugging routines (public)
------------------------------------------------------------------------
 
PROCEDURE set_internal_debug IS
BEGIN 
  
  DBMS_OUTPUT.ENABLE(null);
  g_debug_mode := TRUE;
  
END;  

PROCEDURE reset_internal_debug IS
BEGIN 
  g_debug_mode := FALSE;
  DBMS_OUTPUT.DISABLE;
END;

--PUBLIC MODE PROCEDURES
 
--
--                       PRIVATE MODULES

----------------------------------------------------------------------
-- Type Conversion functions (private)
----------------------------------------------------------------------

/*********************************************************************
* MODULE:       f_boolean
* PURPOSE:      Converts a Y/N variable to a boolean TRUE/FALSE.
*               NULL means FALSE.
* RETURNS:
* NOTES:
*********************************************************************/
FUNCTION f_boolean (i_yn IN VARCHAR2)
RETURN BOOLEAN IS
BEGIN
  RETURN NVL(i_yn,g_no) = g_yes;
END f_boolean;


/*********************************************************************
* MODULE:       f_yn
* PURPOSE:      Converts a boolean TRUE/FALSE to a Y/N variable
*               NULL converts to N.
* RETURNS:
* NOTES:
*********************************************************************/
FUNCTION f_yn (i_boolean IN BOOLEAN)
RETURN VARCHAR2 IS
 
BEGIN
 
  IF i_boolean THEN
    RETURN g_yes;
  ELSE
    RETURN g_no;
  END IF;
 
END f_yn;

/*********************************************************************
* MODULE:       f_tf
* PURPOSE:      Converts a boolean TRUE/FALSE to a T/F sting variable
*               NULL converts to F.
* RETURNS:
* NOTES:
*********************************************************************/
FUNCTION f_tf (i_boolean IN BOOLEAN)
RETURN VARCHAR2 IS
BEGIN
  IF i_boolean THEN
    RETURN G_TRUE;
    
  ELSIF NOT i_boolean THEN
    RETURN G_FALSE;
    
  ELSE 
    RETURN G_NULL;
  END IF;
END f_tf;

 
----------------------------------------------------------------------
-- DERIVATION RULES (private)
----------------------------------------------------------------------
FUNCTION f_process_is_closed RETURN BOOLEAN IS
BEGIN
  RETURN g_process_id IS NULL;
END f_process_is_closed;

FUNCTION f_process_is_open RETURN BOOLEAN IS
BEGIN
  RETURN NOT f_process_is_closed;
END f_process_is_open;

 
 
------------------------------------------------------------------------
-- Process operations (private)
------------------------------------------------------------------------ 
PROCEDURE close_process  
IS
BEGIN

    g_process_id := NULL;
    --Reset the internal error flag.  This will reactivate the package.
    g_internal_error := FALSE;
 
END close_process;




------------------------------------------------------------------------
-- Traversal Stack operations (private)
------------------------------------------------------------------------

PROCEDURE init_traversal_stack  
IS
BEGIN

  g_traversals.DELETE;  
  g_traversals(0).traversal.traversal_id := NULL;
  g_traversals(0).logged := FALSE;
 
END init_traversal_stack;
------------------------------------------------------------------------
 
FUNCTION f_index
  RETURN BINARY_INTEGER IS
BEGIN

  --ensure stack is initialised
  IF g_traversals.LAST IS NULL THEN
    init_traversal_stack;
  END IF;
  
  RETURN g_traversals.LAST;
END;
 
------------------------------------------------------------------------
--FUNCTION f_top_traversal 
--  RETURN traversal_item_type IS
--BEGIN
--  RETURN g_traversals(f_index);
--END;
------------------------------------------------------------------------
FUNCTION f_current_traversal_id RETURN NUMBER IS 
BEGIN
  RETURN g_traversals(f_index).traversal.traversal_id;
END;
 
------------------------------------------------------------------------
FUNCTION f_current_traversal_msg_mode RETURN NUMBER IS 
BEGIN
  RETURN g_traversals(f_index).traversal.msg_mode;
END;

FUNCTION f_is_stack_empty RETURN BOOLEAN IS 
BEGIN
  RETURN f_index = 0;
END;
 
 
------------------------------------------------------------------------
PROCEDURE pop_traversals_by_call_stack(io_traversal_item  IN OUT traversal_item_type) IS
 
  l_safety_counter       BINARY_INTEGER := 1;   
  
BEGIN
  metacode_start('pop_traversals_by_call_stack');
  --check that traversal level is "likely" correct using call stack
  metacode_note('current call_stack',io_traversal_item.call_stack );
  while f_index > 0 and l_safety_counter < g_max_nested_units loop
    --A nested traversal should have a call stack similar to the current one, but longer.
	--It should not be the same either.
    if io_traversal_item.call_stack = g_traversals(f_index).call_stack OR
	   io_traversal_item.call_stack NOT LIKE g_traversals(f_index).call_stack||'%' then
	   metacode_note('last call_stack',g_traversals(f_index).call_stack );
	   metacode_debug('pop_traversals_by_call_stack: removing top traversal '||f_index ); 
       g_traversals.DELETE( f_index );
    end if;	
	l_safety_counter := l_safety_counter + 1;
  end loop;
 
EXCEPTION

  WHEN OTHERS THEN
    metacode_ora_error('pop_traversals_by_call_stack');
END; 
 
------------------------------------------------------------------------
PROCEDURE push_traversal(io_traversal_item  IN OUT traversal_item_type) IS
  l_next_index          BINARY_INTEGER;    
  x_too_deeply_nested   EXCEPTION;
 
BEGIN
  metacode_start('push_traversal');
 
  --Next index is last index + 1
  l_next_index := NVL(f_index,0) + 1;
  metacode_note('l_next_index',l_next_index );
  IF l_next_index > g_max_nested_units THEN
    RAISE x_too_deeply_nested;
  END IF;
  --add to the top of the stack             
  g_traversals(l_next_index ) := io_traversal_item;

EXCEPTION
  WHEN x_too_deeply_nested THEN
    warning('ms_metacode Internal Error');
    warning('push_traversal: exceeded ' ||g_max_nested_units||' nested procs.');
    metacode_error('push_traversal: exceeded ' ||g_max_nested_units||' nested procs.');
  WHEN OTHERS THEN
    metacode_ora_error('push_traversal');
END;

------------------------------------------------------------------------
PROCEDURE pop_to_traversal(i_node IN ms_metacode.node_typ) IS
 
  x_empty_traversal_stack        EXCEPTION;
  --x_item_missing                 EXCEPTION;
  x_node_already_popped          EXCEPTION;
 
  
BEGIN
  metacode_start('pop_to_traversal');
  metacode_note('i_node.node_level',i_node.node_level );
  
  --pre loop error checks
  IF i_node.node_level IS NULL THEN
    RAISE x_node_already_popped;
  ELSIF f_is_stack_empty THEN
    RAISE x_empty_traversal_stack;
  END IF;  
 
  --loop thru any missed exits
  WHILE f_index > i_node.node_level LOOP     
  metacode_note('f_index',f_index);
    metacode_debug('Simulating exit_'||LOWER(g_traversals(f_index).unit_type)||' for '
       ||g_traversals(f_index).module_name||'.'||g_traversals(f_index).unit_name);
    g_traversals.DELETE( f_index );
  END LOOP;    
  
  ----post loop error checks
  --IF f_index < io_node.node_level THEN
  --  RAISE x_item_missing;
  --END IF;
  --
  ----f_index equals io_node.node_level
  --g_traversals.DELETE( f_index );
  ----set the node level to NULL so it can't be popped again thru poor app coding
  --io_node.node_level := NULL;
  --
  ----post pop stack check
  --IF f_is_stack_empty THEN
  --  metacode_debug('All traversals popped');
  --  close_process;
  --END IF;

EXCEPTION
  WHEN x_node_already_popped THEN
    --node_level was set to NULL when the node was popped.
    --cannot be popped again
    metacode_debug('pop_to_traversal: Node already popped.' );  
  --WHEN x_item_missing THEN
  --  metacode_debug('pop_traversal: Traversal not found on stack.' );  
  WHEN x_empty_traversal_stack THEN
    metacode_debug('pop_to_traversal: Traversal not found, stack is empty.' );
  WHEN OTHERS THEN
    metacode_ora_error('pop_to_traversal');
END;

------------------------------------------------------------------------
PROCEDURE pop_traversal(io_node IN OUT ms_metacode.node_typ) IS
 
  --x_empty_traversal_stack        EXCEPTION;
  x_item_missing                 EXCEPTION;
  --x_node_already_popped          EXCEPTION;
 
  
BEGIN
  metacode_start('pop_traversal');
  metacode_note('io_node.node_level',io_node.node_level );
  
  pop_to_traversal(i_node => io_node);
 
  --post loop error checks
  IF f_index < io_node.node_level THEN
    RAISE x_item_missing;
  END IF;
  
  --f_index equals io_node.node_level
  g_traversals.DELETE( f_index );
  --set the node level to NULL so it can't be popped again thru poor app coding
  io_node.node_level := NULL;
 
  --post pop stack check
  IF f_is_stack_empty THEN
    metacode_debug('All traversals popped');
    close_process;
  END IF;

EXCEPTION
  --WHEN x_node_already_popped THEN
  --  --node_level was set to NULL when the node was popped.
  --  --cannot be popped again
  --  metacode_debug('pop_traversal: Node already popped.' );  
  WHEN x_item_missing THEN
    metacode_debug('pop_traversal: Traversal not found on stack.' );  
  --WHEN x_empty_traversal_stack THEN
  --  metacode_debug('pop_traversal: Traversal not found, stack is empty.' );
  WHEN OTHERS THEN
    metacode_ora_error('pop_traversal');
END;
 
------------------------------------------------------------------------
--FUNCTION f_unlogged_traversals_exist RETURN BOOLEAN IS
--BEGIN
--  RETURN f_index( io_traversal_stack => g_unlogged_traversals ) > 0;
--END;

------------------------------------------------------------------------
-- Independent error handler (private)
-- for when this package errors
------------------------------------------------------------------------
 
PROCEDURE app_error(i_message IN VARCHAR2 ) IS
BEGIN 
  RAISE_APPLICATION_ERROR(-20000,i_message||':'||chr(10)
                             ||'* '||SQLERRM);
END;


 
------------------------------------------------------------------------
-- LOGGING ROUTINES (private)
-- These routines write to the logging tables
------------------------------------------------------------------------

PROCEDURE log_process(i_module_name  IN VARCHAR2 DEFAULT NULL
                     ,i_unit_name    IN VARCHAR2 DEFAULT NULL
                     ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                     ,i_comments     IN VARCHAR2 DEFAULT NULL)

IS
  l_username VARCHAR2(30);

  PRAGMA AUTONOMOUS_TRANSACTION;
  
  l_process ms_process%ROWTYPE;

BEGIN
    metacode_start('log_process');
    --reset internal error for the new process
    g_internal_error := FALSE;
 
    SELECT ms_process_seq.NEXTVAL INTO g_process_id FROM DUAL;
    
    l_process.process_id   := g_process_id;
    l_process.origin       := i_module_name
                       ||' '||i_unit_name
                       ||' '||get_module(i_module_name=>i_module_name).revision;
    l_process.ext_ref        := i_ext_ref;
    l_process.username       := USER;
    l_process.created_date   := SYSDATE; 
    l_process.comments       := i_comments;
    l_process.internal_error := 'N';
 
    --insert a new process
    INSERT INTO ms_process VALUES l_process;
 
    COMMIT;
    
    init_traversal_stack;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('log_process');
    
END log_process;

------------------------------------------------------------------------

PROCEDURE log_ref(i_reference  IN ms_reference%ROWTYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
	l_ref ms_reference%ROWTYPE := i_reference;
BEGIN
  metacode_start('log_ref');
  l_ref.message_id := new_message_id;
  
  metacode_note('message_id'  ,l_ref.message_id);
  metacode_note('traversal_id',l_ref.traversal_id);
  metacode_note('name        ',l_ref.name        );
  metacode_note('value       ',l_ref.value       );
  metacode_note('descr       ',l_ref.descr       );
  metacode_note('param_ind   ',l_ref.param_ind   );
 
  INSERT INTO ms_reference VALUES l_ref;
 
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('log_ref');
END;

------------------------------------------------------------------------

PROCEDURE log_traversal(io_traversal_item  IN OUT traversal_item_type ) IS
 
  l_ref_index BINARY_INTEGER;
  x_too_deeply_nested   EXCEPTION;
  PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN
  metacode_start('log_traversal');
  IF f_index = g_max_nested_units THEN
    RAISE x_too_deeply_nested;
  END IF;
 
  --should we start a new process
  IF  io_traversal_item.open_process = G_OPEN_PROCESS_ALWAYS    OR 
     (io_traversal_item.open_process = G_OPEN_PROCESS_IF_CLOSED AND 
      f_process_is_closed) THEN
   
  
    --if the procedure stack if empty then we'll start a new process
    log_process(i_module_name  => io_traversal_item.module_name
               ,i_unit_name    => io_traversal_item.unit_name  );
  END IF;

  --fill in the NULLs
  io_traversal_item.traversal.traversal_id        := new_traversal_id; 
  io_traversal_item.traversal.parent_traversal_id := f_current_traversal_id;
  io_traversal_item.traversal.process_id          := g_process_id;
  
  metacode_note('module_name        ',io_traversal_item.module_name );
  metacode_note('unit_name          ',io_traversal_item.unit_name  );
  metacode_note('traversal_id       ',io_traversal_item.traversal.traversal_id       );
  metacode_note('unit_id            ',io_traversal_item.traversal.unit_id);
  metacode_note('parent_traversal_id',io_traversal_item.traversal.parent_traversal_id);
  metacode_note('process_id         ',io_traversal_item.traversal.process_id         );
  metacode_note('msg_mode           ',io_traversal_item.traversal.msg_mode);

  INSERT INTO ms_traversal VALUES io_traversal_item.traversal; 
  COMMIT;  --commit prior to logging refs
   
  IF io_traversal_item.traversal.msg_mode = G_MSG_MODE_DEBUG THEN
    --incase there are any unlogged refs attached,
    --log them all.
    l_ref_index := io_traversal_item.unlogged_refs.FIRST;
    WHILE l_ref_index IS NOT NULL LOOP
      io_traversal_item.unlogged_refs(l_ref_index).traversal_id := 
        io_traversal_item.traversal.traversal_id;
      log_ref(i_reference => io_traversal_item.unlogged_refs(l_ref_index));
    
      l_ref_index := io_traversal_item.unlogged_refs.NEXT(l_ref_index);
    END LOOP;
    --clear unlogged refs
    io_traversal_item.unlogged_refs.DELETE;
 
  END IF;
  
EXCEPTION
  WHEN x_too_deeply_nested THEN
    ROLLBACK;
    warning('ms_metacode Internal Error');
    warning('log_traversal: exceeded ' ||g_max_nested_units||' nested procs.');
    metacode_error('log_traversal: exceeded ' ||g_max_nested_units||' nested procs.');
  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('log_traversal');
 
 
END; 

------------------------------------------------------------------------

PROCEDURE dump_traversal(i_index    IN BINARY_INTEGER
                        ,i_msg_mode IN NUMBER)IS
 
  --Log traversals that have not yet been logged, using the given msg_mode 
  --search back recursively to first logged traversal
  --log traversals and change msg_mode while dropping out.
  l_traversal_index BINARY_INTEGER;
BEGIN
  metacode_start('dump_traversal');
  IF i_index > 0 AND NOT g_traversals(i_index).logged THEN
    --dump any previous traversals too
    dump_traversal(i_index    => g_traversals.PRIOR(i_index)
                  ,i_msg_mode => i_msg_mode);
  
    g_traversals(i_index).traversal.msg_mode := i_msg_mode;
    log_traversal(io_traversal_item   => g_traversals(i_index));
  END IF;
 
EXCEPTION
  WHEN OTHERS THEN
    metacode_ora_error('dump_traversal');
END;

PROCEDURE synchronise_traversal_to_node( i_node IN ms_metacode.node_typ) IS
BEGIN
	--Is the node on the stack??
	IF i_node.node_level is not null then
	  --ENSURE traversals point to current node.
	  pop_to_traversal(i_node => i_node);
	end if;

END;

------------------------------------------------------------------------

PROCEDURE  log_message(
            i_message         IN VARCHAR2 DEFAULT NULL    -- message
           ,i_comment         IN BOOLEAN  DEFAULT FALSE
           ,i_info            IN BOOLEAN  DEFAULT FALSE   -- BOOLEAN shortcuts to set error level
           ,i_warning         IN BOOLEAN  DEFAULT FALSE   -- use 1 of these
           ,i_fatal           IN BOOLEAN  DEFAULT FALSE
           ,i_oracle          IN BOOLEAN  DEFAULT FALSE   -- find oracle error message and code
           ,i_raise_app_error IN BOOLEAN  DEFAULT FALSE   -- raise an application error
		   ,i_node            IN ms_metacode.node_typ     -- if an initialised node is passed then check its current
           )


IS

   l_message     ms_large_message%ROWTYPE;
   l_message_split NUMBER := 0;
   l_large_message VARCHAR2(32000);
   l_message_parts NUMBER;

   PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  IF NOT g_internal_error THEN
    metacode_start('log_message');
    --metacode_note('i_message        ',i_message        );
	
	--ms_logger passes node as origin of message  
	synchronise_traversal_to_node( i_node => i_node);
 
    l_message.message      := SUBSTR(i_message,1,G_LARGE_MESSAGE_WIDTH);
 
    --encode the message level
    l_message.msg_level := CASE 
                             WHEN i_comment THEN G_MSG_LEVEL_COMMENT
                             WHEN i_info    THEN G_MSG_LEVEL_INFO 
                             WHEN i_warning THEN G_MSG_LEVEL_WARNING  
                             WHEN i_fatal   THEN G_MSG_LEVEL_FATAL 
                             WHEN i_oracle  THEN G_MSG_LEVEL_ORACLE  
                           END;

    IF l_message.msg_level >= G_MSG_LEVEL_FATAL THEN -- message is fatal or worse
       --log all unlogged traversals using debug mode
       dump_traversal(i_index    => f_index
                     ,i_msg_mode => G_MSG_MODE_DEBUG);
    END IF;

    --Messsage is NOT logged if unlogged traversals were not dumped
    --Module and Unit mode are sourced from the DB
    --By default this is Normal mode, meaning that any message of level info and up is reported.
    --Even in Quiet mode, Fatal and Oracle errors will be recorded
    IF g_traversals(f_index).logged AND --NOT f_unlogged_traversals_exist     AND
        --f_current_traversal_id IS NOT NULL AND
        l_message.msg_level >= f_current_traversal_msg_mode THEN
        metacode_note('l_message.msg_level',l_message.msg_level);
        metacode_note('f_current_traversal_msg_mode',f_current_traversal_msg_mode);

        l_message.message_id   := new_message_id;
        l_message.traversal_id := f_current_traversal_id;
        l_message.time_now     := SYSDATE;

        IF l_message.message IS NULL THEN
          metacode_debug('Empty Message');
          
        ELSIF LENGTH(l_message.message) <= G_MESSAGE_WIDTH THEN
          metacode_note('l_message.message',l_message.message);
          INSERT INTO ms_message VALUES l_message;
          
        ELSE
          metacode_debug('This is a LARGE message');   
          l_large_message  := SUBSTR(i_message,1,32000);
          l_message_parts  := CEIL(LENGTH(l_large_message)/4000);
          
          LOOP
            l_message_split := l_message_split + 1;
            
            INSERT INTO ms_large_message VALUES l_message;
            metacode_debug('Large message inserted');
            --warning('Message '||l_message_split||'/'||l_message_parts||' Id:'||l_message.message_id);
            --note('large message_id',l_message.message_id);
          
            l_large_message    := SUBSTR(l_large_message,G_LARGE_MESSAGE_WIDTH+1);
            l_message.message  := SUBSTR(l_large_message,1,G_LARGE_MESSAGE_WIDTH);
 
            EXIT WHEN l_message.message IS NULL OR l_message_split > 8;
            
            l_message.message_id   := new_message_id;
 
          END LOOP;
 
        END IF;
       
        COMMIT;

    END IF;

    IF i_raise_app_error THEN
      app_error(i_message => l_message.message);
    END IF;
  END IF;
  
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('log_message');
 

END log_message;

--------------------------------------------------------------------
--f_user_source
--returns user_source record from user_source table
--------------------------------------------------------------------

FUNCTION f_user_source( i_name   IN   VARCHAR2
                       ,i_type   IN   VARCHAR2
                       ,i_line   IN   NUMBER)
  RETURN user_source%ROWTYPE IS
  CURSOR cu_user_source(
    c_name   VARCHAR2
   ,c_type   VARCHAR2
   ,c_line   NUMBER) IS
    SELECT *
      FROM user_source
     WHERE NAME = c_name
       AND TYPE = c_type
       AND line = c_line;

  l_result   user_source%ROWTYPE;
BEGIN
  OPEN cu_user_source(c_name => i_name
                    , c_type => i_type
                    , c_line => i_line);

  FETCH cu_user_source
   INTO l_result;

  CLOSE cu_user_source;

  RETURN l_result;
END f_user_source;

--------------------------------------------------------------------
--warn_user_source_error_lines
--write user source lines as warnings.
--------------------------------------------------------------------
 

PROCEDURE warn_user_source_error_lines(i_prev_lines IN NUMBER
                                      ,i_post_lines IN NUMBER) IS
                                  
  l_backtrace VARCHAR2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;  
  
  --Eg 'ORA-06512: at "ALESCO.UT_RULE_PKG", line 502'
  
  l_package_name VARCHAR2(100);
  l_error_line   NUMBER;

  l_result       VARCHAR2(4000);
  l_user_source  user_source%ROWTYPE;
  l_line_numbersYN VARCHAR2(1) := 'Y';
  
  l_warn     BOOLEAN;
  l_fatal    BOOLEAN;
  l_message  VARCHAR2(2000);
  l_line_no  VARCHAR2(100);
 
BEGIN
  
  l_package_name := SUBSTR(l_backtrace,INSTR(l_backtrace,'.')+1
                                      ,INSTR(l_backtrace,'"',1,2) - INSTR(l_backtrace,'.')-1);
 
  FOR l_digit_count IN 1 .. 6 LOOP      
    --try successively larger numbers, exits loop by failure
   BEGIN
     l_error_line := SUBSTR(l_backtrace,INSTR(l_backtrace,'line ')+5
                                       ,l_digit_count); 

   EXCEPTION
     WHEN VALUE_ERROR THEN
       EXIT;                                                              
   END;                                 

  END LOOP;                                  


  FOR l_line IN l_error_line - i_prev_lines .. l_error_line + i_post_lines LOOP
  
    l_user_source := f_user_source( i_name => l_package_name
                                   ,i_type => 'PACKAGE BODY'
                                   ,i_line => l_line);
 
		  
 
    l_fatal := l_line = l_error_line;
    l_warn  := NOT l_fatal;
 
    IF l_line_numbersYN = 'Y' THEN
	l_line_no := l_line||' ';
    ELSE
      l_line_no := NULL;
    END IF;
 
	l_message := l_line_no||' '||RTRIM(l_user_source.text,chr(10));
	
	if l_line = l_error_line then
	  warning(l_message);
	else
	  comment(l_message);
	end if;
	
 


  END LOOP;
 
 
EXCEPTION
  WHEN OTHERS THEN
    NULL;
 
END;
 

------------------------------------------------------------------------

PROCEDURE oracle_error( i_message         IN     VARCHAR2 DEFAULT NULL
                       ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
					   ,i_node            IN ms_metacode.node_typ DEFAULT NULL)
IS
BEGIN
 
  log_message( i_message  => LTRIM(i_message ||' '||SQLERRM
                                         ||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE --show the original error line number
                                  )
              ,i_oracle   => TRUE
              ,i_raise_app_error => i_raise_app_error
			  ,i_node     => i_node );
  
  warn_user_source_error_lines(i_prev_lines => 5
                              ,i_post_lines => 5);


END oracle_error;

 
------------------------------------------------------------------------
-- Get Enitity operations (private)
------------------------------------------------------------------------
 
FUNCTION get_module(i_module_name  IN VARCHAR2
                   ,i_module_type  IN VARCHAR2 DEFAULT 'UNKNOWN'
                   ,i_revision     IN VARCHAR2 DEFAULT 'UNKNOWN')
RETURN ms_module%ROWTYPE
IS

  CURSOR cu_module(c_module_name  VARCHAR2)
  IS
  SELECT *
  FROM   ms_module
  WHERE  module_name = c_module_name;
 
  l_module ms_module%ROWTYPE;
 
  l_module_exists BOOLEAN;
  
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  metacode_start('get_module');
  --metacode_note('i_module_name',i_module_name);
  --metacode_note('i_module_type',i_module_type);
  --metacode_note('i_revision   ',i_revision   );
  
  OPEN cu_module(c_module_name  => i_module_name  );
  FETCH cu_module INTO l_module;
  l_module_exists := cu_module%FOUND;
  CLOSE cu_module;

  IF NOT l_module_exists THEN

    --create the new module record
    l_module.module_id       := new_module_id;
    l_module.module_name     := i_module_name;
    l_module.revision        := i_revision;
    l_module.module_type     := i_module_type;
    --l_module.msg_mode        := G_MSG_MODE_DEBUG; 
    --l_module.open_process    := G_OPEN_PROCESS_IF_CLOSED;  
    l_module.msg_mode        := G_MSG_MODE_QUIET; 
    l_module.open_process    := G_OPEN_PROCESS_NEVER;     
 
    --insert a new module instance
    INSERT INTO ms_module VALUES l_module; 
    

  END IF;
  COMMIT;

  RETURN l_module;
  
EXCEPTION

  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('get_module');
  

END get_module;

------------------------------------------------------------------------

FUNCTION get_unit(i_module_id    IN NUMBER
                 ,i_unit_name    IN VARCHAR2
                 ,i_unit_type    IN VARCHAR2 DEFAULT NULL
                 ,i_create       IN BOOLEAN  DEFAULT TRUE)
RETURN ms_unit%ROWTYPE
IS
 
  CURSOR cu_unit(c_module_id    NUMBER
                ,c_unit_name    VARCHAR2)
  IS
  SELECT *
  FROM   ms_unit
  WHERE  module_id   = c_module_id
  AND    unit_name   = c_unit_name;

  l_unit ms_unit%ROWTYPE;
  l_unit_exists BOOLEAN;
  
  PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN
  metacode_start('get_unit');
  OPEN cu_unit(c_module_id  => i_module_id
              ,c_unit_name  => i_unit_name  );
  FETCH cu_unit INTO l_unit;
  l_unit_exists := cu_unit%FOUND;
  CLOSE cu_unit;

  IF NOT l_unit_exists AND i_create THEN

    --create the new procedure record
    l_unit.unit_id         := new_unit_id;
    l_unit.module_id       := i_module_id;
    l_unit.unit_name       := i_unit_name;
    l_unit.unit_type       := i_unit_type;
    l_unit.msg_mode        := G_MSG_MODE_DEFAULT;     --unit is overridden by module when set to DEFAULT 
    l_unit.open_process    := G_OPEN_PROCESS_DEFAULT; --unit is overridden by module when set to DEFAULT   

    --insert a new procedure instance
    INSERT INTO ms_unit VALUES l_unit;  

  END IF;

  COMMIT;

  RETURN l_unit;
  
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('get_unit');

END get_unit;

------------------------------------------------------------------------

FUNCTION get_unit(i_module_name  IN VARCHAR2
                 ,i_unit_name    IN VARCHAR2
                 ,i_unit_type    IN VARCHAR2 DEFAULT NULL
                 ,i_create       IN BOOLEAN  DEFAULT TRUE)
RETURN ms_unit%ROWTYPE
IS
BEGIN
  RETURN get_unit(i_module_id  => get_module(i_module_name => i_module_name).module_id
                 ,i_unit_name  => i_unit_name  
                 ,i_unit_type  => i_unit_type
                 ,i_create     => i_create); 

END;

 
------------------------------------------------------------------------
-- METACODE ROUTINES (Public)
------------------------------------------------------------------------

PROCEDURE new_process(i_module_name  IN VARCHAR2 DEFAULT NULL
                     ,i_unit_name    IN VARCHAR2 DEFAULT NULL
                     ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                     ,i_comments     IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  log_process(i_module_name  => i_module_name
             ,i_unit_name    => i_unit_name  
             ,i_ext_ref      => i_ext_ref    
             ,i_comments     => i_comments);   
END;
------------------------------------------------------------------------ 
PROCEDURE comment( i_message         IN VARCHAR2 DEFAULT NULL
                  ,i_raise_app_error IN BOOLEAN  DEFAULT FALSE
				  ,i_node            IN ms_metacode.node_typ DEFAULT NULL ) IS
BEGIN
    log_message(
       i_message  => i_message
      ,i_comment  => TRUE
      ,i_raise_app_error => i_raise_app_error
	  ,i_node     => i_node);
END comment;

------------------------------------------------------------------------
PROCEDURE info( i_message         IN VARCHAR2 DEFAULT NULL
			   ,i_node            IN ms_metacode.node_typ DEFAULT NULL )
IS
BEGIN
  log_message(
    i_message  => i_message
   ,i_info     => TRUE
   ,i_node     => i_node);

END info;

------------------------------------------------------------------------

PROCEDURE warning( i_message      IN     VARCHAR2 DEFAULT NULL
                  ,i_node            IN ms_metacode.node_typ DEFAULT NULL )
IS
BEGIN
  log_message(
    i_message  => i_message
   ,i_warning  => TRUE
   ,i_node     => i_node);
END warning;

------------------------------------------------------------------------
PROCEDURE fatal( i_message         IN     VARCHAR2 DEFAULT NULL
                ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
			    ,i_node            IN ms_metacode.node_typ DEFAULT NULL)
IS
BEGIN
 
  log_message(
    i_message         => i_message
   ,i_fatal           => TRUE
   ,i_raise_app_error => i_raise_app_error
   ,i_node     => i_node);
 
END fatal;

 
PROCEDURE raise_fatal( i_message         IN     VARCHAR2 DEFAULT NULL
                      ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
				      ,i_node            IN ms_metacode.node_typ DEFAULT NULL)
IS
BEGIN
 
  fatal( i_message         => i_message         
        ,i_raise_app_error => i_raise_app_error 
        ,i_node            => i_node);      
 
  RAISE x_error;

END raise_fatal; 
 
------------------------------------------------------------------------
-- Reference operations (private)
------------------------------------------------------------------------
PROCEDURE push_ref(io_refs      IN OUT ref_list
                  ,i_reference  IN     ms_reference%ROWTYPE ) IS
  l_next_index               BINARY_INTEGER;    
 
BEGIN
 
  --Next index is last index + 1
  l_next_index := NVL(io_refs.LAST,0) + 1;

  --add to the stack             
  io_refs( l_next_index ) := i_reference;

END;

------------------------------------------------------------------------
 
PROCEDURE create_ref ( i_name      IN VARCHAR2
                      ,i_value     IN VARCHAR2
                      ,i_descr     IN VARCHAR2 
                      ,i_is_param  IN BOOLEAN
                      ,i_node      IN ms_metacode.node_typ DEFAULT NULL					  )
IS

  l_param_ind VARCHAR2(1) := f_yn(i_is_param); 
  l_reference MS_REFERENCE%ROWTYPE;

BEGIN
  IF NOT g_internal_error THEN
    IF LENGTH(i_value) > G_REF_DATA_WIDTH THEN
      --create a comment instead
      comment(i_message => i_name||chr(10)||i_value       
	         ,i_node    => i_node);      
 
    ELSE
 
	  --ms_logger passes node as origin of message  
	  synchronise_traversal_to_node( i_node => i_node);

      metacode_start('create_ref');
      l_reference.traversal_id := NULL;         
      l_reference.name         := SUBSTR(i_name ,1,G_REF_NAME_WIDTH);
      l_reference.value        := SUBSTR(i_value,1,G_REF_DATA_WIDTH);
      l_reference.descr        := SUBSTR(i_descr,1,G_REF_DATA_WIDTH);
      l_reference.param_ind    := l_param_ind; 

      IF NOT g_traversals(f_index).logged THEN
        --push onto unlogged refs
        push_ref(
         io_refs     => g_traversals(f_index).unlogged_refs 
        ,i_reference => l_reference); 

      ELSE
        --log it, don't need to push it
        l_reference.traversal_id := f_current_traversal_id;
        log_ref(i_reference => l_reference ); 
      END IF;   
    END IF;   
  END IF;   
EXCEPTION
  WHEN OTHERS THEN
    metacode_ora_error('create_ref');

END create_ref;

------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL
                   ,i_node      IN ms_metacode.node_typ DEFAULT NULL				   )
IS

BEGIN

  create_ref ( i_name       => i_name
           ,i_value      => i_value
           ,i_descr      => i_descr
           ,i_is_param   => FALSE
           ,i_node       => i_node);

END note   ;
 
PROCEDURE invariant(i_value     IN VARCHAR2
                   ,i_node      IN ms_metacode.node_typ DEFAULT NULL)
IS

BEGIN

  note(i_name      => 'invariant'
      ,i_value     => i_value
      ,i_node     => i_node );

END invariant   ;

------------------------------------------------------------------------

PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL )
IS

BEGIN
  create_ref ( i_name      => i_name
           ,i_value     => i_value
           ,i_descr     => i_descr
           ,i_is_param  => TRUE
           ,i_node     => i_node
		   );

END param;
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL 
				   ,i_node      IN ms_metacode.node_typ DEFAULT NULL)
IS

BEGIN

  create_ref ( i_name       => i_name
           ,i_value      => TO_CHAR(ROUND(i_num_value,15))
           ,i_descr      => i_descr
           ,i_is_param   => FALSE
           ,i_node     => i_node);

END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL				 )
IS

BEGIN
  create_ref ( i_name       => i_name
           ,i_value      => TO_CHAR(ROUND(i_num_value,15))
           ,i_descr      => i_descr
           ,i_is_param   => TRUE
           ,i_node     => i_node);

END param;
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL 
				   ,i_node      IN ms_metacode.node_typ DEFAULT NULL)
IS

BEGIN
  IF i_date_value = TRUNC(i_date_value) THEN

    create_ref ( i_name       => i_name
             ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY')
             ,i_descr      => i_descr
             ,i_is_param   => FALSE
             ,i_node     => i_node);
  ELSE
    create_ref ( i_name       => i_name
             ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY HH24MI')
             ,i_descr      => i_descr
             ,i_is_param   => FALSE
             ,i_node     => i_node);

  END IF;

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL				 )
IS

BEGIN
  IF i_date_value = TRUNC(i_date_value) THEN

    create_ref ( i_name       => i_name
             ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY')
             ,i_descr      => i_descr
             ,i_is_param   => TRUE
             ,i_node     => i_node);
  ELSE
    create_ref ( i_name       => i_name
             ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY HH24MI')
             ,i_descr      => i_descr
             ,i_is_param   => TRUE
             ,i_node     => i_node);

  END IF;

END param;

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN 
				 ,i_node      IN ms_metacode.node_typ DEFAULT NULL)
IS

BEGIN

  create_ref ( i_name       => i_name
           ,i_value      => f_tf(i_bool_value)
           ,i_descr      => NULL
           ,i_is_param   => FALSE
           ,i_node     => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL				 )
IS

BEGIN
  create_ref ( i_name        => i_name
           ,i_value       => f_tf(i_bool_value)
           ,i_descr       => NULL
           ,i_is_param     => TRUE
           ,i_node     => i_node);

END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_name      IN VARCHAR2
                 ,i_node      IN ms_metacode.node_typ DEFAULT NULL)
IS
BEGIN
  create_ref(i_name       => i_name
         ,i_value      => TO_CHAR(NULL) 
         ,i_descr      => NULL
         ,i_is_param   => FALSE
         ,i_node     => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_name      IN VARCHAR2
                        ,i_node      IN ms_metacode.node_typ DEFAULT NULL ) IS
BEGIN

  note ( i_name       => i_name
        ,i_value      => SQL%ROWCOUNT
        ,i_node       => i_node  );

END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_name      IN VARCHAR2 
                         ,i_node      IN ms_metacode.node_typ DEFAULT NULL) RETURN NUMBER IS
  l_rowcount NUMBER := SQL%ROWCOUNT;
BEGIN

  note ( i_name       => i_name
        ,i_value      => l_rowcount
        ,i_node     => i_node  );
  RETURN l_rowcount;

END f_note_rowcount;

------------------------------------------------------------------------

PROCEDURE note_error(i_node      IN ms_metacode.node_typ DEFAULT NULL)
IS
BEGIN

  note ( i_name       => 'SQLERRM'
        ,i_value      => SQLERRM
        ,i_node     => i_node  );
 
END note_error;

------------------------------------------------------------------------
PROCEDURE note_length( i_name  IN VARCHAR2
                      ,i_node      IN ms_metacode.node_typ DEFAULT NULL ) IS
BEGIN

  note ( i_name       => 'LENGTH('||i_name||')'
        ,i_value      => LENGTH(i_name)
        ,i_node     => i_node);

END note_length;

------------------------------------------------------------------------
-- Log Register operations (private)
------------------------------------------------------------------------
 
PROCEDURE  register_module(i_module_name  IN VARCHAR2
                          ,i_module_type  IN VARCHAR2
                          ,i_revision     IN VARCHAR2
						  ,i_msg_mode     IN NUMBER   DEFAULT G_MSG_MODE_DEBUG  
						  ,i_open_process IN VARCHAR2 DEFAULT G_OPEN_PROCESS_IF_CLOSED 
						  )
IS
 
  l_module       ms_module%ROWTYPE ;
  l_module_name  ms_module.module_name%TYPE := LTRIM(RTRIM(SUBSTR(i_module_name,1,G_MODULE_NAME_WIDTH)));
 
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  metacode_start('register_module');
  --metacode_note('i_module_name',i_module_name);
  --metacode_note('i_module_type',i_module_type);
  --metacode_note('i_revision',i_revision);

  --get a registered module or register this one
  l_module := get_module(i_module_name => l_module_name); 

  IF l_module.revision     <> i_revision     OR
     l_module.module_type  <> i_module_type  OR 
	 l_module.msg_mode     <> i_msg_mode     OR
	 l_module.open_process <> i_open_process THEN
 
     UPDATE ms_module 
     SET revision     = i_revision     
        ,module_type  = i_module_type 
		,msg_mode     = i_msg_mode    
		,open_process = i_open_process
     WHERE module_id = l_module.module_id;

  END IF;

  
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    metacode_ora_error('register_module');
  
END;  

------------------------------------------------------------------------
-- Log Register operations (PUBLIC) Overloaded on private routine register_module
-- 
--   register_package
--   register_form
--   register_report
--   register_standalone_procedure
--   register_standalone_function
------------------------------------------------------------------------

 
PROCEDURE  register_package(i_name      IN VARCHAR2
                           ,i_revision  IN VARCHAR2  DEFAULT NULL) IS
BEGIN
  register_module(i_module_name => i_name
                 ,i_module_type => G_MODULE_TYPE_PACKAGE
                 ,i_revision    => i_revision);
END;
------------------------------------------------------------------------
 
PROCEDURE  register_form(i_name     IN VARCHAR2
                        ,i_revision IN VARCHAR2) IS
BEGIN
  register_module(i_module_name => i_name
                 ,i_module_type => G_MODULE_TYPE_FORM
                 ,i_revision    => i_revision);
END;

------------------------------------------------------------------------ 
PROCEDURE  register_report(i_name     IN VARCHAR2
                          ,i_revision IN VARCHAR2) IS
BEGIN
  register_module(i_module_name => i_name
                 ,i_module_type => G_MODULE_TYPE_REPORT
                 ,i_revision    => i_revision);
END;

------------------------------------------------------------------------ 
PROCEDURE  register_standalone_procedure(i_name     IN VARCHAR2
                                        ,i_revision IN VARCHAR2) IS
BEGIN
  register_module(i_module_name => i_name
                 ,i_module_type => G_MODULE_TYPE_PROCEDURE
                 ,i_revision    => i_revision);
END;

------------------------------------------------------------------------ 
PROCEDURE  register_standalone_function(i_name     IN VARCHAR2
                                       ,i_revision IN VARCHAR2) IS
BEGIN
  register_module(i_module_name => i_name
                 ,i_module_type => G_MODULE_TYPE_FUNCTION
                 ,i_revision    => i_revision);
END;
------------------------------------------------------------------------
PROCEDURE  register_SQL_script(i_name     IN VARCHAR2
                              ,i_revision IN VARCHAR2) IS
BEGIN
  register_module(i_module_name => i_name
                 ,i_module_type => G_MODULE_TYPE_SQL
                 ,i_revision    => i_revision);
END;

------------------------------------------------------------------------
-- Message Mode operations (private)
------------------------------------------------------------------------
 
PROCEDURE  set_unit_msg_mode(i_unit_id   IN NUMBER
                            ,i_msg_mode IN NUMBER )
IS
  pragma autonomous_transaction;
BEGIN

  metacode_note('i_unit_id',i_unit_id);
  metacode_note('i_msg_mode',i_msg_mode);

  UPDATE ms_unit
  SET    msg_mode  = i_msg_mode
  WHERE  unit_id   = i_unit_id;

  COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      metacode_ora_error('set_unit_msg_mode');
END;
 

------------------------------------------------------------------------
  
PROCEDURE  set_unit_msg_mode(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
                            ,i_msg_mode   IN NUMBER ) IS
                             
BEGIN


  set_unit_msg_mode(i_unit_id  => get_unit(i_module_name => i_module_name
                                          ,i_unit_name   => i_unit_name
                                          ,i_create      => FALSE).unit_id
                   ,i_msg_mode => i_msg_mode);
 
END; 

------------------------------------------------------------------------
-- Message Mode operations (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE  set_unit_debug(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  set_unit_msg_mode(i_module_name  => i_module_name
                    ,i_unit_name   => i_unit_name  
                    ,i_msg_mode    => G_MSG_MODE_DEBUG);
END; 

------------------------------------------------------------------------

PROCEDURE  set_unit_normal(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  set_unit_msg_mode(i_module_name  => i_module_name
                    ,i_unit_name   => i_unit_name  
                    ,i_msg_mode    => G_MSG_MODE_NORMAL);
END; 

------------------------------------------------------------------------

PROCEDURE  set_unit_quiet(i_module_name IN VARCHAR2
                         ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  set_unit_msg_mode(i_module_name  => i_module_name
                    ,i_unit_name    => i_unit_name  
                    ,i_msg_mode    => G_MSG_MODE_QUIET);
END; 
 
------------------------------------------------------------------------
-- Traversal operations (private)
------------------------------------------------------------------------

PROCEDURE create_traversal(io_node     IN OUT ms_metacode.node_typ )
IS
 
  l_module              ms_module%ROWTYPE ;
  l_unit                ms_unit%ROWTYPE ;
 
 
  l_traversal       ms_traversal%ROWTYPE ;
  l_traversal_item  traversal_item_type;
 
BEGIN
 
  IF NOT g_internal_error THEN
    metacode_start('create_traversal');
 
    --get a registered module or register this one
    l_module := get_module(i_module_name => io_node.module_name); 

    --get a registered unit or register this one
    l_unit := get_unit(i_module_id   => l_module.module_id
                      ,i_unit_name   => io_node.unit_name  
                      ,i_unit_type   => io_node.unit_type);
 
    --Messages and references, in the SCOPE of this traversal, will be stored.
    l_traversal.traversal_id        := NULL;
    l_traversal.process_id          := NULL;
    l_traversal.unit_id             := l_unit.unit_id;
    l_traversal.parent_traversal_id := NULL;
    l_traversal.msg_mode            := NVL(l_unit.msg_mode    ,l_module.msg_mode);      --unit override module, unless null

    l_traversal_item.traversal      := l_traversal;
    
    l_traversal_item.open_process   := NVL(l_unit.open_process,l_module.open_process);  --unit override module, unless null
    l_traversal_item.module_name    := io_node.module_name;
    l_traversal_item.unit_name      := io_node.unit_name;
    l_traversal_item.unit_type      := l_unit.unit_type;
	
	l_traversal_item.call_stack     := io_node.call_stack;
 
    l_traversal_item.logged         := l_traversal.msg_mode <> G_MSG_MODE_QUIET;

	
	--Use the call stack to remove any traversals from the stack that are not ancestors
    pop_traversals_by_call_stack(io_traversal_item  => l_traversal_item);
 
    IF l_traversal_item.logged THEN
      --dump any unlogged traversals in QUIET MODE
      dump_traversal(i_index    => f_index
                    ,i_msg_mode => G_MSG_MODE_QUIET);
      --log the traversal and push it on the traversal stack
      log_traversal(io_traversal_item   => l_traversal_item);
 
    END IF;
	
	--push the traversal onto the stack
    push_traversal(io_traversal_item  => l_traversal_item);
    

    IF NOT g_internal_error THEN
      io_node.node_level := f_index; --meaningless if g_internal_error is TRUE
    END IF;
    
  END IF;
  
  io_node.internal_error := g_internal_error;
 
EXCEPTION
  WHEN OTHERS THEN
    metacode_ora_error('create_traversal');
 
END create_traversal;

------------------------------------------------------------------------

PROCEDURE dispose_traversal(io_node IN OUT ms_metacode.node_typ )
IS
  x_never_entered EXCEPTION;
  x_never_created EXCEPTION;
BEGIN
  metacode_start('dispose_traversal');
  
  
  IF io_node.internal_error IS NULL THEN
    RAISE x_never_entered;
  ELSIF io_node.internal_error THEN
    RAISE x_never_created;
  END IF;
  
  metacode_debug('pop a traversal');
  pop_traversal(io_node => io_node);
 
  
EXCEPTION
  WHEN x_never_entered THEN
    metacode_debug('this node was never entered');
  WHEN x_never_created THEN
    metacode_debug('this node was never created');
  WHEN OTHERS THEN
    metacode_ora_error('dispose_traversal' );

END dispose_traversal;


------------------------------------------------------------------------
-- ENTER UNIT operations (PUBLIC)
------------------------------------------------------------------------
 
 

PROCEDURE enter_proc(io_node IN OUT ms_metacode.node_typ)
IS
BEGIN
  io_node.unit_type := G_UNIT_TYPE_PROCEDURE;
  create_traversal(io_node => io_node);

END enter_proc;

PROCEDURE enter_func(io_node IN OUT ms_metacode.node_typ)
IS
BEGIN
  io_node.unit_type := G_UNIT_TYPE_FUNCTION;
  create_traversal(io_node => io_node);

END enter_func;

------------------------------------------------------------------------

PROCEDURE enter_loop(io_node IN OUT ms_metacode.node_typ)
IS
BEGIN
  io_node.unit_type := G_UNIT_TYPE_LOOP;
  create_traversal(io_node => io_node);

END enter_loop;

------------------------------------------------------------------------

PROCEDURE enter_block(io_node IN OUT ms_metacode.node_typ)
IS
BEGIN
  io_node.unit_type := G_UNIT_TYPE_BLOCK;
  create_traversal(io_node => io_node);
 
END enter_block;

------------------------------------------------------------------------

PROCEDURE enter_trigger(io_node IN OUT ms_metacode.node_typ)
IS
BEGIN
  
  io_node.unit_type := NVL(io_node.unit_type
                          ,G_UNIT_TYPE_TRIGGER);
  create_traversal(io_node => io_node);
 
END enter_trigger;

------------------------------------------------------------------------

PROCEDURE enter_sql_script(io_node IN OUT ms_metacode.node_typ)
IS
BEGIN
  io_node.unit_type := G_UNIT_TYPE_SQL;
  create_traversal(io_node => io_node);

END enter_sql_script;

------------------------------------------------------------------------
-- EXIT UNIT operations (PUBLIC)
------------------------------------------------------------------------
PROCEDURE exit_proc(io_node IN OUT  ms_metacode.node_typ)
IS
BEGIN
  dispose_traversal(io_node => io_node);
END exit_proc;

PROCEDURE exit_func(io_node IN OUT  ms_metacode.node_typ)
IS
BEGIN
  dispose_traversal(io_node => io_node);
END exit_func;

------------------------------------------------------------------------
PROCEDURE exit_loop(io_node IN OUT  ms_metacode.node_typ)
IS
BEGIN
  dispose_traversal(io_node => io_node);
END exit_loop;

------------------------------------------------------------------------
PROCEDURE exit_block(io_node IN OUT  ms_metacode.node_typ)
IS
BEGIN
  dispose_traversal(io_node => io_node);
END exit_block;

------------------------------------------------------------------------
PROCEDURE exit_trigger(io_node IN OUT  ms_metacode.node_typ)
IS
BEGIN
  dispose_traversal(io_node => io_node);
END exit_trigger;

------------------------------------------------------------------------

PROCEDURE exit_sql_script(io_node IN OUT  ms_metacode.node_typ)
IS
BEGIN
  dispose_traversal(io_node => io_node);

END exit_sql_script;

------------------------------------------------------------------------
-- PASS operations (PUBLIC)
-- Pass is a metacoding shortcut.  
-- Creates and uses nodes that don't really exist, by adding 1 to the node_level
------------------------------------------------------------------------

PROCEDURE do_pass(io_node     IN OUT  ms_metacode.node_typ
                 ,i_pass_name IN VARCHAR2 DEFAULT NULL)
IS
  l_node ms_metacode.node_typ := io_node;

BEGIN
  metacode_start('do_pass');
  --metacode_note('i_pass_name' ,i_pass_name); 
  
  l_node.unit_type  := G_UNIT_TYPE_PASS;
  l_node.unit_name  := '['||to_char(io_node.pass_count +1)||'] '||NVL(i_pass_name,l_node.unit_name);
  l_node.node_level := l_node.node_level + 1;

  --metacode_note('pass_name' ,l_node.unit_name); 
 
  dispose_traversal(io_node => l_node);
  create_traversal(io_node  => l_node);
  
  metacode_debug('param pass_count');
  io_node.pass_count := io_node.pass_count +1;  
  param('pass_count',io_node.pass_count);
 
END do_pass;

------------------------------------------------------------------------
 
PROCEDURE trap_pass_error(io_node IN OUT ms_metacode.node_typ)
--trap x_error or oracle error, and return to normal processing                    
IS
  l_node ms_metacode.node_typ := io_node;

BEGIN
  metacode_start('trap_pass_error');
  l_node.unit_type  := G_UNIT_TYPE_PASS;
  l_node.unit_name  := l_node.unit_name||'_pass';
  l_node.node_level := l_node.node_level + 1;
  
  trap_error(io_node => l_node);

END trap_pass_error;

------------------------------------------------------------------------

PROCEDURE raise_pass_error(io_node IN OUT ms_metacode.node_typ)
--trap x_error or oracle error, and return re-raise x_error                
IS
  l_node ms_metacode.node_typ := io_node;

BEGIN
  metacode_start('raise_pass_error');
  l_node.unit_type  := G_UNIT_TYPE_PASS;
  l_node.unit_name  := l_node.unit_name||'_pass';
  l_node.node_level := l_node.node_level + 1;
  
  raise_error(io_node => l_node);

END raise_pass_error;



------------------------------------------------------------------------

PROCEDURE ignore_pass_error(io_node IN OUT ms_metacode.node_typ)
--ignore a non metacode error               
IS
  l_node ms_metacode.node_typ := io_node;

BEGIN
  metacode_start('ignore_pass_error');
  l_node.unit_type  := G_UNIT_TYPE_PASS;
  l_node.unit_name  := l_node.unit_name||'_pass';
  l_node.node_level := l_node.node_level + 1;
 
END ignore_pass_error;
 
/*********************************************************************
* MODULE:  empty_messages
* PURPOSE: Empty the message table, and create a new process
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 10-AUG-2001 PAB       Original version
*********************************************************************
PROCEDURE empty_messages
IS

  pragma autonomous_transaction;

BEGIN

    DELETE FROM ms_reference;
    DELETE FROM ms_message;    
    DELETE FROM ms_traversal;
    DELETE FROM ms_process;

    COMMIT;
    log_process('ANONYMOUS','ANONYMOUS');

END empty_messages;
*/

------------------------------------------------------------------------
-- EXCEPTION HANDLERS  (PUBLIC)
------------------------------------------------------------------------
 
PROCEDURE ignore_error(io_node        IN OUT      ms_metacode.node_typ
                      ,i_error_name   IN VARCHAR2 DEFAULT NULL
                      ,i_message      IN VARCHAR2 DEFAULT NULL) IS
  --ignore an expected named error - continue normal processing
  --error ignored regardless of error_code but x_error provokes a warning
BEGIN

   IF SQLCODE = G_ERROR_CODE THEN
     warning('Incorrect metacode: x_error should not be caught by ignore_error/handled_error');
     comment('use: WHEN OTHERS THEN trap_error.');

     trap_error(io_node   => io_node
               ,i_message => i_message);

   ELSE
     note('User Defined Error'  ,i_error_name);
     note('User Defined Message',i_message);
     
   END IF;
   
   warning('User Defined Error - Handled');
   dispose_traversal(io_node => io_node);

END ignore_error;

------------------------------------------------------------------------

PROCEDURE handled_error(io_node        IN OUT      ms_metacode.node_typ
                       ,i_error_name   IN VARCHAR2 DEFAULT NULL
                       ,i_message      IN VARCHAR2 DEFAULT NULL) IS
                       
BEGIN

   ignore_error(io_node       => io_node     
               ,i_error_name  => i_error_name
               ,i_message     => i_message);
 
END handled_error;                   
 
------------------------------------------------------------------------
 
PROCEDURE trap_error(io_node    IN OUT ms_metacode.node_typ
                    ,i_message  IN     VARCHAR2 DEFAULT NULL)
--trap x_error or oracle error, and resume normal processing                    
IS
BEGIN
   IF SQLCODE = G_ERROR_CODE THEN
     comment(i_message  => 'Trapped x_error'
	        ,i_node     => io_node);
   ELSE
      --new oracle error
      oracle_error(i_message  => i_message
	              ,i_node     => io_node);
      comment(i_message  => 'Trapped ORACLE error'
	         ,i_node     => io_node);
   END IF;
 
   comment('Resume normal processing.');
   dispose_traversal(io_node => io_node);


END trap_error;



------------------------------------------------------------------------

PROCEDURE raise_error(io_node    IN OUT ms_metacode.node_typ
                     ,i_message  IN     VARCHAR2 DEFAULT NULL)
--trap x_error or oracle error, and return re-raise x_error                
IS
BEGIN

  IF SQLCODE = G_ERROR_CODE THEN
    warning( i_message  => 'Re-raise Error'
	        ,i_node     => io_node);
  ELSE
    oracle_error(i_message  => i_message
	            ,i_node     => io_node);
  END IF;

  dispose_traversal(io_node => io_node);
  RAISE x_error;

END raise_error;
 

/*********************************************************************
* MODULE:  MSG_LEVEL Functions
* PURPOSE: retrieval of global variables.
* RETURNS: NUMBER
* NOTES:
*********************************************************************/

FUNCTION msg_level_info     RETURN NUMBER
IS
BEGIN
RETURN G_MSG_LEVEL_INFO;
END msg_level_info;

FUNCTION msg_level_comment     RETURN NUMBER
IS
BEGIN
RETURN G_MSG_LEVEL_COMMENT;
END msg_level_comment;

FUNCTION msg_level_warning  RETURN NUMBER
IS
BEGIN
RETURN G_MSG_LEVEL_WARNING;
END msg_level_warning;

FUNCTION msg_level_fatal    RETURN NUMBER
IS
BEGIN
RETURN G_MSG_LEVEL_FATAL;
END msg_level_fatal;

FUNCTION msg_level_oracle    RETURN NUMBER
IS
BEGIN
RETURN G_MSG_LEVEL_ORACLE;
END msg_level_oracle;

FUNCTION msg_level_internal    RETURN NUMBER
IS
BEGIN
RETURN G_MSG_LEVEL_INTERNAL;
END msg_level_internal;

/*********************************************************************
* MODULE:  msg_level_string
* PURPOSE: A string to represent the message level.
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 05-DEC-2001 PAB       Original version
*********************************************************************/
FUNCTION msg_level_string (i_msg_level    IN NUMBER) RETURN VARCHAR2
IS
  v_result VARCHAR2(100) := NULL;
BEGIN
    IF i_msg_level = G_MSG_LEVEL_INFO THEN
      v_result  := 'Info ?';
    ELSIF i_msg_level = G_MSG_LEVEL_COMMENT THEN
      v_result  := 'Comment';
    ELSIF i_msg_level = G_MSG_LEVEL_WARNING THEN
      v_result  := 'Warning !';
    ELSIF i_msg_level = G_MSG_LEVEL_FATAL THEN
      v_result  := 'Fatal !';
    ELSIF i_msg_level = G_MSG_LEVEL_ORACLE THEN
      v_result  := 'Oracle Error';
    ELSIF i_msg_level = G_MSG_LEVEL_INTERNAL THEN
      v_result  := 'Internal Error';
    END IF;

  RETURN v_result;
END msg_level_string;

 
/*********************************************************************
* MODULE:  get_traversal_id_list
* PURPOSE: client-side form cannot use EXECUTE IMMEDIATE
*          so this procedure will support UT002
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 16/12/2006   PAB       Original version
*********************************************************************/

FUNCTION get_traversal_id_list(i_node_SQL IN VARCHAR2) RETURN traversal_list_typ IS
  l_traversal_id_list  traversal_list_typ;
BEGIN
  EXECUTE IMMEDIATE i_node_SQL BULK COLLECT INTO l_traversal_id_list;
  RETURN l_traversal_id_list;
END;
/*********************************************************************
* MODULE:  unit_message_count
* PURPOSE: used for ms_unit_vw
*          so this view will support UT003
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 21/12/2006   PAB       Original version
*********************************************************************/
 
FUNCTION unit_message_count(i_unit_id IN NUMBER
                           ,i_msg_level    IN NUMBER) RETURN NUMBER IS
                           
  CURSOR cu_message_count(c_unit_id NUMBER                         
                         ,c_msg_level    NUMBER) IS
  SELECT count(*)
  FROM  ms_traversal_message_vw
  WHERE unit_id =  c_unit_id
  AND   msg_level    =  c_msg_level; 
  
  l_result NUMBER;
  
BEGIN
  OPEN cu_message_count(c_unit_id      => i_unit_id
                       ,c_msg_level    => i_msg_level);
  FETCH cu_message_count INTO l_result;
  CLOSE cu_message_count;
  
  RETURN l_result;
  
END;  

/*********************************************************************
* MODULE:  unit_traversal_count
* PURPOSE: used for ms_unit_vw
*          so this view will support UT003
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 21/12/2006   PAB       Original version
*********************************************************************/
 
FUNCTION unit_traversal_count(i_unit_id IN NUMBER ) RETURN NUMBER IS
                           
  CURSOR cu_traversal_count(c_unit_id NUMBER ) IS
  SELECT count(*)
  FROM  ms_traversal
  WHERE unit_id =  c_unit_id; 
  
  l_result NUMBER;
  
BEGIN
  OPEN cu_traversal_count(c_unit_id => i_unit_id );
  FETCH cu_traversal_count INTO l_result;
  CLOSE cu_traversal_count;
  
  RETURN l_result;
  
END;  

/*********************************************************************
* MODULE:  concat_messages
* PURPOSE: Returns the concatonation of messages for the traversal
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 22/05/2004  pab       Original version
*********************************************************************/
FUNCTION concat_messages(i_traversal_id IN NUMBER)
RETURN VARCHAR2
IS
  l_result   VARCHAR2(2000);
 
  CURSOR cu_messages(c_traversal_id NUMBER) IS
  SELECT SUBSTR(listagg(m.message,',') within group (order by message_id),2000)
  FROM   ms_message   m
  WHERE  m.traversal_id = c_traversal_id;
 
BEGIN

 
  OPEN  cu_messages(c_traversal_id => i_traversal_id);
  FETCH cu_messages INTO l_result;
  CLOSE cu_messages;

  RETURN l_result;

EXCEPTION
  WHEN OTHERS THEN
    IF cu_messages%ISOPEN THEN
      CLOSE cu_messages;
    END IF;
    RETURN 'concat_messages: '||SQLERRM;

END concat_messages;

/*********************************************************************
* MODULE:  concat_references
* PURPOSE: Returns the concatonation of references for the traversal
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 22/05/2004  pab       Original version
*********************************************************************/
FUNCTION concat_references(i_traversal_id IN NUMBER)
RETURN VARCHAR2
IS
  l_result VARCHAR2(2000);


  CURSOR cu_references(c_traversal_id NUMBER) IS
  SELECT SUBSTR(listagg(r.name||'='||r.value,',') within group (order by traversal_id),2000)
  FROM   ms_reference   r
  WHERE  r.traversal_id = i_traversal_id;
 
BEGIN
 
  OPEN  cu_references(c_traversal_id => i_traversal_id);
  FETCH cu_references INTO l_result;
  CLOSE cu_references;

  RETURN l_result;

EXCEPTION
  WHEN OTHERS THEN
    IF cu_references%ISOPEN THEN
      CLOSE cu_references;
    END IF;
    RETURN 'concat_references: '||SQLERRM;
 
END concat_references;

  --------------------------------------------------------------------
  --purge_old_processes
  -------------------------------------------------------------------


PROCEDURE purge_old_processes(i_keep_day_count IN NUMBER DEFAULT 1) IS

 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

  delete from ms_process        where created_date < (SYSDATE - i_keep_day_count);
  delete from ms_internal_error where time_now     < (SYSDATE - i_keep_day_count);
  delete from ms_large_message  where time_now     < (SYSDATE - i_keep_day_count);

  COMMIT;
  
 END;
 
--  --------------------------------------------------------------------
--  --notify_oracle_errors
--  -------------------------------------------------------------------
--
-- 
--PROCEDURE notify_oracle_errors IS
--
--  
--   CURSOR cu_module_vw IS
--   SELECT *
--   FROM   ms_module_vw
--   WHERE  ORACLE_COUNT > 0 OR FATAL_COUNT > 0;
-- 
--  l_reminder_message reminders.reminder_message%TYPE;
--  l_CR VARCHAR2(1) := chr(10);
-- 
-- 
--BEGIN 
--
--  FOR l_module_vw IN cu_module_vw LOOP
--     
--    l_reminder_message := SUBSTR(
--                          l_reminder_message 
--          ||'Module_id      :'||l_module_vw.module_id      
--    ||l_CR||'Module_name    :'||l_module_vw.module_name    
--    ||l_CR||'Revision       :'||l_module_vw.revision       
--    ||l_CR||'Module_type    :'||l_module_vw.module_type    
--    ||l_CR||'Msg_mode       :'||l_module_vw.msg_mode       
--    ||l_CR||'Open_process   :'||l_module_vw.open_process   
--    ||l_CR||'Traversal_count:'||l_module_vw.traversal_count
--    ||l_CR||'Comment_count  :'||l_module_vw.comment_count  
--    ||l_CR||'Info_count     :'||l_module_vw.info_count     
--    ||l_CR||'Warning_count  :'||l_module_vw.warning_count  
--    ||l_CR||'Fatal_count    :'||l_module_vw.fatal_count    
--    ||l_CR||'Oracle_count   :'||l_module_vw.oracle_count 
--    ||l_CR
--    ||l_CR
--    ||l_CR,1,2000);
--  
--  END LOOP;
--
--
--   IF l_reminder_message IS NOT NULL THEN
--     l_reminder_message := SUBSTR('The following modules have generated errors:'||l_CR||l_CR|| l_reminder_message,1,2000); 
--   
--   
--     ut_reminders_pkg.send_reminder (i_reminder_type    => 'MS'
--                                    ,i_reminder_message => l_reminder_message
--                                    ,i_package_name     => g_package_name     
--                                    ,i_package_revision => g_package_revision
--                                    ,i_program_unit     => 'notify_oracle_errors'); 
--   
--   
--   END IF;  
-- 
--  
-- END;
 
--  --------------------------------------------------------------------
--  --notify_internal_errors
--  -------------------------------------------------------------------
--
-- 
--PROCEDURE notify_internal_errors IS
-- 
--   CURSOR cu_process IS
--    SELECT *
--    FROM   ms_process
--    WHERE  internal_error = 'Y'
--    and    notified_flag  = 'N'
--    FOR UPDATE NOWAIT;
-- 
-- 
--  l_reminder_message reminders.reminder_message%TYPE;
--  l_CR VARCHAR2(1) := chr(10);
--  l_one_hour  NUMBER := 1/24;
-- 
--BEGIN 
--
--  FOR l_process IN cu_process LOOP
--     
--    l_reminder_message := SUBSTR(
--                          l_reminder_message 
--          ||'Process_id    :'||l_process.PROCESS_ID    
--    ||l_CR||'Ext_ref       :'||l_process.EXT_REF       
--    ||l_CR||'Origin        :'||l_process.ORIGIN        
--    ||l_CR||'Username      :'||l_process.USERNAME      
--    ||l_CR||'Created_date  :'||l_process.CREATED_DATE  
--    ||l_CR||'Comments      :'||l_process.COMMENTS      
--    ||l_CR||'Internal_error:'||l_process.INTERNAL_ERROR
--    ||l_CR
--    ||l_CR
--    ||l_CR ,1,2000);
--    
--    update ms_process 
--    set notified_flag  = 'Y'
--    where current of cu_process
--    ;
--  
--  END LOOP;
--
--  COMMIT;
--
--  IF l_reminder_message IS NOT NULL THEN
--    l_reminder_message := SUBSTR('The following processes have generated internal errors:'||l_CR||l_CR|| l_reminder_message,1,2000); 
-- 
--
--    send_reminder (i_reminder_type    => 'MS'
--                  ,i_reminder_message => l_reminder_message
--                  ,i_package_name     => g_package_name     
--                  ,i_package_revision => g_package_revision
--                  ,i_program_unit     => 'notify_internal_errors'); 
--    
--    --since most internal errors are caused by the message tablespace filling
--    --emtpy this leaving the last hour only.
--    purge_old_processes(l_one_hour);                               
--                                   
-- 
--  END IF;  
-- 
--  
-- END;
 

/*********************************************************************
* MODULE:  f_is_metacode_pkg_silent
* PURPOSE: tells if we have the null package or not
* NOTES:
* HISTORY:
* When        Who       What
* ----------- --------- ----------------------------------------------
* 17/03/2005   PAB       Original version
*********************************************************************/
FUNCTION f_is_metacode_pkg_silent
RETURN BOOLEAN
IS

BEGIN

  RETURN FALSE;

END f_is_metacode_pkg_silent;


----------------------------------------------------------------------
-- f_is_metacode_pkg_silent_YN
----------------------------------------------------------------------
FUNCTION f_is_metacode_pkg_silent_YN RETURN VARCHAR2 IS

BEGIN

  RETURN 'N';

END f_is_metacode_pkg_silent_YN;
 
BEGIN

  init_traversal_stack;
  close_process;

 
END ms_metacode;
/
 