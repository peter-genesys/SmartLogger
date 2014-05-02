alter session set plsql_ccflags = 'intlog:false';
--alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings 

create or replace package body ms_logger is
------------------------------------------------------------------
-- Program  : ms_logger  
-- Name     : Smart logger for PL/SQL
-- Author   : P.Burgess
-- Originally developed as MS_METACODE Date : 23/10/2006
-- Purpose  : Logging for PL/SQL 
--            Smart logger has a reduced instruction set, that is appropriate for use with 
--            the AOP_PROCESSOR for automated instrumentation of code.
--
------------------------------------------------------------------------
-- This package is not to be instrumented by the AOP_PROCESSOR
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
 
 
  g_debug_mode         BOOLEAN := FALSE;
  g_debug_indent       INTEGER;
 
  G_MODULE_NAME_WIDTH     CONSTANT NUMBER := 50;
  G_UNIT_NAME_WIDTH       CONSTANT NUMBER := 50;
  G_REF_NAME_WIDTH        CONSTANT NUMBER := 30;
  G_REF_DATA_WIDTH        CONSTANT NUMBER := 100;
  G_MESSAGE_WIDTH         CONSTANT NUMBER := 200;
  G_INTERNAL_ERROR_WIDTH  CONSTANT NUMBER := 200;
  G_LARGE_MESSAGE_WIDTH   CONSTANT NUMBER := 4000;
  G_CALL_STACK_WIDTH      CONSTANT NUMBER := 2000;
  
 
TYPE node_stack_typ IS
  TABLE OF node_typ
  INDEX BY BINARY_INTEGER;
 
  l_current_node  ms_logger.node_typ; 	
  
 

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

g_nodes                 node_stack_typ;
 


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
-- Internal logging routines (private)
-- ms_logger cannot be used to log itself, so an alternative internal syntax exists
-- Output is designed for the unit test "ms_test.sql".
------------------------------------------------------------------------
 
PROCEDURE intlog_putline(i_line IN VARCHAR2 ) IS
--Don't call this directly.
BEGIN 
  IF g_debug_mode THEN
    dbms_output.put_line(LPAD('+ ',g_debug_indent*2,'+ ')||i_line);
  END IF;
END; 

 
PROCEDURE intlog_start(i_message IN VARCHAR2 ) IS
BEGIN 
  intlog_putline('BEGAN: '||i_message);
  g_debug_indent := g_debug_indent + 1;
END;

PROCEDURE intlog_end(i_message IN VARCHAR2 ) IS
BEGIN
  g_debug_indent := g_debug_indent - 1; 
  intlog_putline('ENDED: '||i_message);
  
END; 

PROCEDURE err_set_process_internal_error IS
  --set internal error
  --create_ref, create_traversal, log_message will not start 
  --while this flag is set.  
  --These procedures are the ONLY gateways to the LOG and PUSH routines
  
   PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 
 
  g_internal_error := TRUE; 
  $if $$intlog $then intlog_putline('INTERNAL ERROR'); $end
 
  UPDATE ms_process 
  SET internal_error = 'Y'
  WHERE process_id   = g_process_id
  AND internal_error = 'N';
  
  COMMIT;

END; 
 



PROCEDURE err_create_internal_error(i_message IN VARCHAR2 ) IS
   
   PRAGMA AUTONOMOUS_TRANSACTION;

   l_internal_error     ms_internal_error%ROWTYPE;

BEGIN 

  err_set_process_internal_error;

  $if $$intlog $then intlog_putline('* '||i_message);  $end
 
  l_internal_error.message      := SUBSTR(i_message,1,G_INTERNAL_ERROR_WIDTH);
  l_internal_error.msg_level    := G_MSG_LEVEL_INTERNAL;
  l_internal_error.message_id   := new_message_id;
  l_internal_error.traversal_id := NVL(f_current_traversal_id,0); -- dummy traversal_id if none current
  l_internal_error.process_id   := g_process_id;
  l_internal_error.time_now     := SYSDATE;

  INSERT INTO ms_internal_error VALUES l_internal_error;
  
  COMMIT;

END; 

 
PROCEDURE err_warn_oracle_error(i_message IN VARCHAR2 ) IS
BEGIN 
  $if $$intlog $then intlog_putline(i_message||':');     $end
  err_create_internal_error(SQLERRM);
  $if $$intlog $then intlog_end(i_message => i_messagntlog_end(i_message => i_message); $end --extra call to intlog_end closes the program unit.

END;




PROCEDURE intlog_debug(i_message IN VARCHAR2 ) IS
BEGIN 
  intlog_putline('!'||i_message);
END;

PROCEDURE intlog_note(i_name  IN VARCHAR2
                       ,i_value IN VARCHAR2) IS
BEGIN 
  intlog_putline('.'||i_name||':'||i_value);
END;

------------------------------------------------------------------------
-- Internal debugging routines (public)
------------------------------------------------------------------------
 
PROCEDURE set_internal_debug IS
BEGIN 
  
  DBMS_OUTPUT.ENABLE(null);
  g_debug_mode := TRUE;
  g_debug_indent := 0;
  
END;  

PROCEDURE reset_internal_debug IS
BEGIN 
  g_debug_mode := FALSE;
  DBMS_OUTPUT.DISABLE;
END;

  
------------------------------------------------------------------------
-- Get Enitity operations (private)
------------------------------------------------------------------------


FUNCTION get_module(i_module_name  IN VARCHAR2) RETURN ms_module%ROWTYPE RESULT_CACHE RELIES_ON (ms_module)
IS

  CURSOR cu_module(c_module_name  VARCHAR2)
  IS
  SELECT *
  FROM   ms_module
  WHERE  module_name = c_module_name;
 
  l_module ms_module%ROWTYPE;
 
BEGIN
 
  OPEN cu_module(c_module_name  => i_module_name  );
  FETCH cu_module INTO l_module;
  CLOSE cu_module;
 
  RETURN l_module;
 
END get_module;



 
FUNCTION find_module(i_module_name  IN VARCHAR2
                    ,i_module_type  IN VARCHAR2 DEFAULT 'UNKNOWN'
                    ,i_revision     IN VARCHAR2 DEFAULT 'UNKNOWN')
RETURN ms_module%ROWTYPE
IS
 
  l_module ms_module%ROWTYPE;
 
  l_module_exists BOOLEAN;
  
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN 
  $if $$intlog $then intlog_start('find_module');                 $end
  $if $$intlog $then intlog_note('i_module_name',i_module_name);  $end
  $if $$intlog $then intlog_note('i_module_type',i_module_type);  $end
  $if $$intlog $then intlog_note('i_revision   ',i_revision   );  $end
  
  l_module := get_module(i_module_name => i_module_name  );
  l_module_exists := l_module.module_id IS NOT NULL;

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
  
  $if $$intlog $then intlog_end('find_module'); $end

  RETURN l_module;
  
EXCEPTION

  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('find_module');
	raise;
  

END find_module;

------------------------------------------------------------------------
FUNCTION get_unit(i_module_id    IN NUMBER
                 ,i_unit_name    IN VARCHAR2) RETURN ms_unit%ROWTYPE RESULT_CACHE RELIES_ON (ms_unit)
IS
 
  CURSOR cu_unit(c_module_id    NUMBER
                ,c_unit_name    VARCHAR2)
  IS
  SELECT *
  FROM   ms_unit
  WHERE  module_id   = c_module_id
  AND    unit_name   = c_unit_name;

  l_unit ms_unit%ROWTYPE;
 
BEGIN
  OPEN cu_unit(c_module_id  => i_module_id
              ,c_unit_name  => i_unit_name  );
  FETCH cu_unit INTO l_unit;
  CLOSE cu_unit;
 
  RETURN l_unit;
 
END get_unit;


FUNCTION find_unit(i_module_id    IN NUMBER
                 ,i_unit_name    IN VARCHAR2
                 ,i_unit_type    IN VARCHAR2 DEFAULT NULL
                 ,i_create       IN BOOLEAN  DEFAULT TRUE)
RETURN ms_unit%ROWTYPE
IS
 
  l_unit ms_unit%ROWTYPE;
  l_unit_exists BOOLEAN;
  
  PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN
  $if $$intlog $then intlog_start('find_unit'); $end
  
  l_unit := get_unit(i_module_id => i_module_id
                    ,i_unit_name => i_unit_name);
  l_unit_exists := l_unit.unit_id IS NOT NULL;
 
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

  $if $$intlog $then intlog_end('find_unit'); $end
  RETURN l_unit;
  
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('find_unit');
	raise;

END find_unit;

------------------------------------------------------------------------

FUNCTION find_unit(i_module_name  IN VARCHAR2
                  ,i_unit_name    IN VARCHAR2
                  ,i_unit_type    IN VARCHAR2 DEFAULT NULL
                  ,i_create       IN BOOLEAN  DEFAULT TRUE)
RETURN ms_unit%ROWTYPE
IS
BEGIN
  RETURN find_unit(i_module_id  => find_module(i_module_name => i_module_name).module_id
                  ,i_unit_name  => i_unit_name  
                  ,i_unit_type  => i_unit_type
                  ,i_create     => i_create); 

END;

 

 


/*

--BLOCK TRIGGER NODE
FUNCTION block_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_logger.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_logger.node_typ := ms_logger.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
  l_node.unit_type := G_UNIT_TYPE_BLOCK_TRIGGER;
 
  RETURN l_node;
                           
END; 

--RECORD TRIGGER NODE
FUNCTION record_trigger_node(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
							,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_logger.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_logger.node_typ := ms_logger.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_RECORD_TRIGGER;
 
  RETURN l_node;
                           
END; 
 
--ITEM TRIGGER NODE
FUNCTION item_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_logger.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node ms_logger.node_typ := ms_logger.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_ITEM_TRIGGER;
 
  RETURN l_node;
                           
END; 

*/




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
-- Node Stack operations (private)
------------------------------------------------------------------------

PROCEDURE init_node_stack  
IS
BEGIN

  g_nodes.DELETE;  
  g_nodes(0).traversal.traversal_id := NULL;
  g_nodes(0).logged := FALSE;
 
END init_node_stack;
------------------------------------------------------------------------
 
FUNCTION f_index
  RETURN BINARY_INTEGER IS
BEGIN

  --ensure stack is initialised
  IF g_nodes.LAST IS NULL THEN
    init_node_stack;
  END IF;
  
  RETURN g_nodes.LAST;
END;


FUNCTION f_current_traversal_id RETURN NUMBER IS 
BEGIN
  RETURN g_nodes(f_index).traversal.traversal_id;
END;
 
------------------------------------------------------------------------
FUNCTION f_current_traversal_msg_mode RETURN NUMBER IS 
BEGIN
  RETURN g_nodes(f_index).traversal.msg_mode;
END;

FUNCTION f_is_stack_empty RETURN BOOLEAN IS 
BEGIN
  RETURN f_index = 0;
END;



 
------------------------------------------------------------------------
PROCEDURE pop_to_parent_node(i_node IN node_typ) IS
--Pop any node that is not an ancestor of this node.
BEGIN
  $if $$intlog $then intlog_start('pop_to_parent_node');                                $end
  $if $$intlog $then intlog_note('current call_stack_level',i_node.call_stack_level );  $end
  --remove from the stack any node with a call_stack_level equal to or greater than the new node.
  while f_index > 0 and
        g_nodes(f_index).call_stack_level >= i_node.call_stack_level  loop
	   $if $$intlog $then intlog_note('last call_stack_level',g_nodes(f_index).call_stack_level ); $end
	   $if $$intlog $then intlog_debug('pop_to_parent_node: removing top node '||f_index );        $end
       g_nodes.DELETE( f_index );

  end loop;
  $if $$intlog $then intlog_end('pop_to_parent_node'); $end
 
EXCEPTION

  WHEN OTHERS THEN
    err_warn_oracle_error('pop_to_parent_node');
END; 


------------------------------------------------------------------------
PROCEDURE pop_descendent_nodes(i_node IN node_typ) IS
--Pop any node that is not a descendent of this node.
BEGIN
  $if $$intlog $then intlog_start('pop_descendent_nodes');                              $end         
  $if $$intlog $then intlog_note('current call_stack_level',i_node.call_stack_level );  $end
  --remove from the stack any node with a call_stack_level equal to or greater than the new node.
  while f_index > 0 and
        g_nodes(f_index).call_stack_level > i_node.call_stack_level  loop
	   $if $$intlog $then intlog_note('last call_stack_level',g_nodes(f_index).call_stack_level ); $end
	   $if $$intlog $then intlog_debug('pop_descendent_nodes: removing top node '||f_index );      $end
       g_nodes.DELETE( f_index );
  end loop;
  $if $$intlog $then intlog_end('pop_descendent_nodes'); $end
  
  --SHOULD WE PUT INTERNAL DEBUGGING HERE TO CHECK WE HAVE THE RIGHT NODE.
 
EXCEPTION

  WHEN OTHERS THEN
    err_warn_oracle_error('pop_descendent_nodes');
END; 

 


 
------------------------------------------------------------------------
PROCEDURE push_node(io_node  IN OUT node_typ) IS
  l_next_index          BINARY_INTEGER;    
  x_too_deeply_nested   EXCEPTION;
 
BEGIN
  $if $$intlog $then intlog_start('push_node'); $end
 
  --Next index is last index + 1
  l_next_index := NVL(f_index,0) + 1;
  $if $$intlog $then intlog_note('l_next_index',l_next_index ); $end
  IF l_next_index > g_max_nested_units THEN
    RAISE x_too_deeply_nested;
  END IF;
  --add to the top of the stack             
  g_nodes(l_next_index ) := io_node;
  $if $$intlog $then intlog_end('push_node'); $end

EXCEPTION
  WHEN x_too_deeply_nested THEN
    warning(g_nodes(f_index),'ms_logger Internal Error');
    warning(g_nodes(f_index),'push_node: exceeded ' ||g_max_nested_units||' nested procs.');
    err_create_internal_error('push_node: exceeded ' ||g_max_nested_units||' nested procs.');
    $if $$intlog $then intlog_end('push_node'); $end
  WHEN OTHERS THEN
    err_warn_oracle_error('push_node');
END;

 

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
    $if $$intlog $then intlog_start('log_process'); $end
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
    
    init_node_stack;
	
	$if $$intlog $then intlog_end('log_process'); $end

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_process');
    
END log_process;

------------------------------------------------------------------------

PROCEDURE log_ref(i_reference  IN ms_reference%ROWTYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
	l_ref ms_reference%ROWTYPE := i_reference;
BEGIN
  $if $$intlog $then intlog_start('log_ref'); $end
  l_ref.message_id := new_message_id;
  
  $if $$intlog $then intlog_note('message_id'  ,l_ref.message_id);   $end
  $if $$intlog $then intlog_note('traversal_id',l_ref.traversal_id); $end
  $if $$intlog $then intlog_note('name        ',l_ref.name        ); $end
  $if $$intlog $then intlog_note('value       ',l_ref.value       ); $end
  $if $$intlog $then intlog_note('descr       ',l_ref.descr       ); $end
  $if $$intlog $then intlog_note('param_ind   ',l_ref.param_ind   ); $end
 
  INSERT INTO ms_reference VALUES l_ref;
 
  COMMIT;
  $if $$intlog $then intlog_end('log_ref'); $end
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_ref');
END;

------------------------------------------------------------------------

PROCEDURE log_node(io_node  IN OUT node_typ ) IS
 
  l_ref_index BINARY_INTEGER;
  x_too_deeply_nested   EXCEPTION;
  PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN
  $if $$intlog $then intlog_start('log_node'); $end
  IF f_index = g_max_nested_units THEN
    RAISE x_too_deeply_nested;
  END IF;
 
  --should we start a new process
  IF  io_node.open_process = G_OPEN_PROCESS_ALWAYS    OR 
     (io_node.open_process = G_OPEN_PROCESS_IF_CLOSED AND 
      f_process_is_closed) THEN
   
  
    --if the procedure stack if empty then we'll start a new process
    log_process(i_module_name  => io_node.module.module_name
               ,i_unit_name    => io_node.unit.unit_name  );
  END IF;

  --fill in the NULLs
  io_node.traversal.traversal_id        := new_traversal_id; 
  io_node.traversal.parent_traversal_id := f_current_traversal_id;
  io_node.traversal.process_id          := g_process_id;
  
  $if $$intlog $then intlog_note('module_name        ',io_node.module.module_name );           $end
  $if $$intlog $then intlog_note('unit_name          ',io_node.unit.unit_name  );              $end
  $if $$intlog $then intlog_note('traversal_id       ',io_node.traversal.traversal_id       ); $end
  $if $$intlog $then intlog_note('unit_id            ',io_node.traversal.unit_id);             $end
  $if $$intlog $then intlog_note('parent_traversal_id',io_node.traversal.parent_traversal_id); $end
  $if $$intlog $then intlog_note('process_id         ',io_node.traversal.process_id         ); $end
  $if $$intlog $then intlog_note('msg_mode           ',io_node.traversal.msg_mode);            $end

  INSERT INTO ms_traversal VALUES io_node.traversal; 
  COMMIT;  --commit prior to logging refs
   
  IF io_node.traversal.msg_mode = G_MSG_MODE_DEBUG THEN
    --incase there are any unlogged refs attached,
    --log them all.
    l_ref_index := io_node.unlogged_refs.FIRST;
    WHILE l_ref_index IS NOT NULL LOOP
      io_node.unlogged_refs(l_ref_index).traversal_id := 
        io_node.traversal.traversal_id;
      log_ref(i_reference => io_node.unlogged_refs(l_ref_index));
    
      l_ref_index := io_node.unlogged_refs.NEXT(l_ref_index);
    END LOOP;
    --clear unlogged refs
    io_node.unlogged_refs.DELETE;
 
  END IF;
  
  io_node.logged := TRUE;
  $if $$intlog $then intlog_end('log_node'); $end
  
EXCEPTION
  WHEN x_too_deeply_nested THEN
    ROLLBACK;
    warning(g_nodes(f_index),'ms_logger Internal Error');
    warning(g_nodes(f_index),'log_node: exceeded ' ||g_max_nested_units||' nested procs.');
    err_create_internal_error('log_node: exceeded ' ||g_max_nested_units||' nested procs.');
	$if $$intlog $then intlog_end('log_node');  $end                   
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_node');
 
 
END; 

------------------------------------------------------------------------

PROCEDURE dump_nodes(i_index    IN BINARY_INTEGER
                    ,i_msg_mode IN NUMBER)IS
 
  --Log traversals that have not yet been logged, using the given msg_mode 
  --search back recursively to first logged traversal
  --log traversals and change msg_mode while dropping out.
  l_traversal_index BINARY_INTEGER;
BEGIN
  $if $$intlog $then intlog_start('dump_nodes'); $end
  IF i_index > 0 AND NOT g_nodes(i_index).logged THEN
    --dump any previous traversals too
    dump_nodes(i_index    => g_nodes.PRIOR(i_index)
              ,i_msg_mode => i_msg_mode);
  
    g_nodes(i_index).traversal.msg_mode := i_msg_mode;
    log_node(io_node   => g_nodes(i_index));
  END IF;
  $if $$intlog $then intlog_end('dump_nodes'); $end
 
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('dump_nodes');
END;

PROCEDURE synch_node_stack( i_node IN ms_logger.node_typ) IS
BEGIN
	--Is the node on the stack??
	IF i_node.node_level is not null then
	  --ENSURE traversals point to current node.
	  pop_descendent_nodes(i_node => i_node);
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
		   ,i_node            IN ms_logger.node_typ     -- if an initialised node is passed then check its current
           )


IS

   l_message     ms_large_message%ROWTYPE;
   l_message_split NUMBER := 0;
   l_large_message VARCHAR2(32000);
   l_message_parts NUMBER;

   PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  $if $$intlog $then intlog_start('log_message'); $end
  IF NOT g_internal_error THEN

    --intlog_note('i_message        ',i_message        );
	
	--ms_logger passes node as origin of message  
	synch_node_stack( i_node => i_node);
 
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
       dump_nodes(i_index    => f_index
                 ,i_msg_mode => G_MSG_MODE_DEBUG);
    END IF;

    --Messsage is NOT logged if unlogged traversals were not dumped
    --Module and Unit mode are sourced from the DB
    --By default this is Normal mode, meaning that any message of level info and up is reported.
    --Even in Quiet mode, Fatal and Oracle errors will be recorded
    IF g_nodes(f_index).logged AND --NOT f_unlogged_traversals_exist     AND
        --f_current_traversal_id IS NOT NULL AND
        l_message.msg_level >= f_current_traversal_msg_mode THEN
        $if $$intlog $then intlog_note('l_message.msg_level',l_message.msg_level);                   $end
        $if $$intlog $then intlog_note('f_current_traversal_msg_mode',f_current_traversal_msg_mode); $end

        l_message.message_id   := new_message_id;
        l_message.traversal_id := f_current_traversal_id;
        l_message.time_now     := SYSDATE;

        IF l_message.message IS NULL THEN
          $if $$intlog $then intlog_debug('Empty Message'); $end
		  NULL;
          
        ELSIF LENGTH(l_message.message) <= G_MESSAGE_WIDTH THEN
          $if $$intlog $then intlog_note('l_message.message',l_message.message); $end
          INSERT INTO ms_message VALUES l_message;
          
        ELSE
          $if $$intlog $then intlog_debug('This is a LARGE message'); $end 
          l_large_message  := SUBSTR(i_message,1,32000);
          l_message_parts  := CEIL(LENGTH(l_large_message)/4000);
          
          LOOP
            l_message_split := l_message_split + 1;
            
            INSERT INTO ms_large_message VALUES l_message;
            $if $$intlog $then intlog_debug('Large message inserted'); $end
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
  $if $$intlog $then intlog_end('log_message'); $end
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_message');
 

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
 

PROCEDURE warn_user_source_error_lines( i_node       IN ms_logger.node_typ
                                       ,i_prev_lines IN NUMBER
                                       ,i_post_lines IN NUMBER) IS
                                  
  l_backtrace VARCHAR2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;  
  
  --Eg 'ORA-06512: at "ALESCO.UT_RULE_PKG", line 502'
  
  l_package_name VARCHAR2(100);
  l_error_line   NUMBER;

  l_result       VARCHAR2(4000);
  l_user_source  user_source%ROWTYPE;
  l_line_numbersYN VARCHAR2(1) := 'Y';
   
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
 
 
    IF l_line_numbersYN = 'Y' THEN
	l_line_no := l_line||' ';
    ELSE
      l_line_no := NULL;
    END IF;
 
	l_message := l_line_no||' '||RTRIM(l_user_source.text,chr(10));
	
	if l_line = l_error_line then
	  warning(i_node,l_message);
	else
	  comment(i_node,l_message);
	end if;
	
 


  END LOOP;
 
 
EXCEPTION
  WHEN OTHERS THEN
    NULL;
 
END;
 

------------------------------------------------------------------------

PROCEDURE debug_error( i_node            IN ms_logger.node_typ 
                       ,i_warning         IN BOOLEAN  DEFAULT FALSE
                       ,i_oracle          IN BOOLEAN  DEFAULT FALSE
                       ,i_message         IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN
 
  log_message( i_message  => LTRIM(i_message ||' '||SQLERRM
                                         ||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE --show the original error line number
                                  )
              ,i_warning  => i_warning
			  ,i_oracle   => i_oracle
			  ,i_node     => i_node );
  
  warn_user_source_error_lines(i_prev_lines => 5
                              ,i_post_lines => 5
							  ,i_node     => i_node);


END debug_error;


PROCEDURE oracle_error( i_node            IN ms_logger.node_typ 
                       ,i_message         IN     VARCHAR2 DEFAULT NULL  )
IS
BEGIN

  debug_error( i_node             => i_node  
               ,i_oracle           => TRUE      
               ,i_message          => i_message );
 
END oracle_error;

--cannot actually raise the error. will need to have a raise in the exception block.
PROCEDURE warn_error( i_node            IN ms_logger.node_typ 
                     ,i_message         IN     VARCHAR2 DEFAULT NULL  )
IS
BEGIN
 
  debug_error( i_node             => i_node  
               ,i_warning          => TRUE      
               ,i_message          => i_message );


END warn_error;


 

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
                      ,i_node      IN ms_logger.node_typ DEFAULT NULL					  )
IS

  l_param_ind VARCHAR2(1) := f_yn(i_is_param); 
  l_reference MS_REFERENCE%ROWTYPE;

BEGIN
  $if $$intlog $then intlog_start('create_ref'); $end
  IF NOT g_internal_error THEN

    IF LENGTH(i_value) > G_REF_DATA_WIDTH THEN
      --create a comment instead
      comment(i_message => i_name||chr(10)||i_value       
	         ,i_node    => i_node);      
 
    ELSE
 
	  --ms_logger passes node as origin of message  
	  synch_node_stack( i_node => i_node);

      
      l_reference.traversal_id := NULL;         
      l_reference.name         := SUBSTR(i_name ,1,G_REF_NAME_WIDTH);
      l_reference.value        := SUBSTR(i_value,1,G_REF_DATA_WIDTH);
      l_reference.descr        := SUBSTR(i_descr,1,G_REF_DATA_WIDTH);
      l_reference.param_ind    := l_param_ind; 

      IF NOT g_nodes(f_index).logged THEN
        --push onto unlogged refs
        push_ref(
         io_refs     => g_nodes(f_index).unlogged_refs 
        ,i_reference => l_reference); 

      ELSE
        --log it, don't need to push it
        l_reference.traversal_id := f_current_traversal_id;
        log_ref(i_reference => l_reference ); 
      END IF;   
    END IF;  

  END IF;   
  $if $$intlog $then intlog_end('create_ref'); $end
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('create_ref');

END create_ref;

------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ 	
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL
                   			   )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => i_value
              ,i_descr      => i_descr
              ,i_is_param   => FALSE
              ,i_node       => i_node);

END note   ;
 
/* 
PROCEDURE invariant(i_value     IN VARCHAR2
                   ,i_node      IN ms_logger.node_typ DEFAULT NULL)
IS

BEGIN

  note(i_name      => 'invariant'
      ,i_value     => i_value
      ,i_node     => i_node );

END invariant   ;
*/

------------------------------------------------------------------------

PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN
  create_ref ( i_name      => i_name
              ,i_value     => i_value
              ,i_descr     => i_descr
              ,i_is_param  => TRUE
              ,i_node      => i_node
		      );

END param;
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN

  create_ref ( i_name       => i_name
           ,i_value      => TO_CHAR(ROUND(i_num_value,15))
           ,i_descr      => i_descr
           ,i_is_param   => FALSE
           ,i_node     => i_node);

END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL 				 )
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
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
                   ,i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL )
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
PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL 			 )
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
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  )
IS

BEGIN

  create_ref ( i_name       => i_name
           ,i_value      => f_tf(i_bool_value)
           ,i_descr      => NULL
           ,i_is_param   => FALSE
           ,i_node     => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN )
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
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2 )
IS
BEGIN
  create_ref(i_name       => i_name
         ,i_value      => TO_CHAR(NULL) 
         ,i_descr      => NULL
         ,i_is_param   => FALSE
         ,i_node     => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN ms_logger.node_typ 
                        ,i_name      IN VARCHAR2 ) IS
BEGIN

  note ( i_name       => i_name
        ,i_value      => SQL%ROWCOUNT
        ,i_node       => i_node  );

END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN ms_logger.node_typ 
                         ,i_name      IN VARCHAR2  ) RETURN NUMBER IS
  l_rowcount NUMBER := SQL%ROWCOUNT;
BEGIN

  note ( i_name       => i_name
        ,i_value      => l_rowcount
        ,i_node     => i_node  );
  RETURN l_rowcount;

END f_note_rowcount;

------------------------------------------------------------------------

PROCEDURE note_error(i_node      IN ms_logger.node_typ )
IS
BEGIN

  note ( i_name       => 'SQLERRM'
        ,i_value      => SQLERRM
        ,i_node     => i_node  );
 
END note_error;

------------------------------------------------------------------------
PROCEDURE note_length( i_node      IN ms_logger.node_typ 
                      ,i_name  IN VARCHAR2  ) IS
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
  $if $$intlog $then intlog_start('register_module');            $end
  $if $$intlog $then intlog_note('i_module_name',i_module_name); $end
  $if $$intlog $then intlog_note('i_module_type',i_module_type); $end
  $if $$intlog $then intlog_note('i_revision',i_revision);       $end

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
  $if $$intlog $then intlog_end('register_module'); $end

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('register_module');
  
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
  $if $$intlog $then intlog_start('set_unit_msg_mode');    $end
  $if $$intlog $then intlog_note('i_unit_id',i_unit_id);   $end
  $if $$intlog $then intlog_note('i_msg_mode',i_msg_mode); $end

  UPDATE ms_unit
  SET    msg_mode  = i_msg_mode
  WHERE  unit_id   = i_unit_id;

  COMMIT;
  $if $$intlog $then intlog_end('set_unit_msg_mode'); $end
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      err_warn_oracle_error('set_unit_msg_mode');
END;
 

------------------------------------------------------------------------
  
PROCEDURE  set_unit_msg_mode(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
                            ,i_msg_mode   IN NUMBER ) IS
                             
BEGIN


  set_unit_msg_mode(i_unit_id  => find_unit(i_module_name => i_module_name
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

PROCEDURE create_traversal(io_node     IN OUT ms_logger.node_typ )
IS

BEGIN
  $if $$intlog $then intlog_start('create_traversal'); $end
  IF NOT g_internal_error THEN
 
    --Messages and references, in the SCOPE of this traversal, will be stored.
    io_node.traversal.traversal_id        := NULL;
    io_node.traversal.process_id          := NULL;
    io_node.traversal.unit_id             := io_node.unit.unit_id;
    io_node.traversal.parent_traversal_id := NULL;
    io_node.traversal.msg_mode            := NVL(io_node.unit.msg_mode    ,io_node.module.msg_mode);      --unit override module, unless null

	
    io_node.open_process                  := NVL(io_node.unit.open_process,io_node.module.open_process);  --unit override module, unless null
    io_node.logged                        := FALSE;

	--Use the call stack to remove any nodes from the stack that are not ancestors
    pop_to_parent_node(i_node => io_node);
 
    IF io_node.traversal.msg_mode <> G_MSG_MODE_QUIET THEN 
	  --Log this node, but first log any ancestors that are not yet logged.
      --dump any unlogged traversals in QUIET MODE
      dump_nodes(i_index    => f_index
                ,i_msg_mode => G_MSG_MODE_QUIET);
      --log the traversal and push it on the traversal stack
      log_node(io_node   => io_node);
 
    END IF;
	
	--push the traversal onto the stack
    push_node(io_node  => io_node);
    

    IF NOT g_internal_error THEN
      io_node.node_level := f_index; --meaningless if g_internal_error is TRUE
    END IF;
    
	
  END IF;
  
  io_node.internal_error := g_internal_error;
  
  $if $$intlog $then intlog_end('create_traversal'); $end
  
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('create_traversal');
 
END create_traversal;



------------------------------------------------------------------------
-- Node Typ API functions (Public)
------------------------------------------------------------------------

FUNCTION new_node(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
				 ,i_unit_type   IN VARCHAR2 ) RETURN ms_logger.node_typ IS
				 
  --When upgraded to 12C may not need to pass any params				 

  --must work in SILENT MODE, incase somebody write logic on the app side that depends
  --on l_node                
  l_node ms_logger.node_typ;  
  
  l_module_name ms_module.module_name%TYPE := LTRIM(RTRIM(SUBSTR(i_module_name,1,G_MODULE_NAME_WIDTH)));
  l_unit_name   ms_unit.unit_name%TYPE     := LTRIM(RTRIM(SUBSTR(i_unit_name  ,1,G_UNIT_NAME_WIDTH)));  
				 
  FUNCTION f_call_stack_level RETURN NUMBER IS
    l_lines   APEX_APPLICATION_GLOBAL.VC_ARR2;
  BEGIN
    --Indicative only. Absolute value doesn't matter so much, used for comparison only.
    --first 4 lines are not real levels so subtract 4.
  
    l_lines := APEX_UTIL.STRING_TO_TABLE(dbms_utility.format_call_stack,chr(10));
   
    return l_lines.count -4;
     
  END;	 
 
BEGIN
  
  --get a registered module or register this one
  l_node.module := find_module(i_module_name => i_module_name); 

  --get a registered unit or register this one
  l_node.unit := find_unit(i_module_id   => l_node.module.module_id
                          ,i_unit_name   => i_unit_name  
                          ,i_unit_type   => i_unit_type);
 
  l_node.call_stack_level := f_call_stack_level; --simplify after 12C with additional functions
 
  create_traversal(io_node => l_node);
 
  RETURN l_node;
  
END;


------------------------------------------------------------------------
 
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
 
  

  ------------------------------------------------------------------------
  -- Node Typ API functions (Public)
  ------------------------------------------------------------------------
  
  FUNCTION new_proc(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ IS
 
  BEGIN
    
	RETURN ms_logger.new_node(i_module_name => i_module_name
                             ,i_unit_name   => i_unit_name
							 ,i_unit_type   => G_UNIT_TYPE_PROCEDURE );
 
  END;
  
  
  FUNCTION new_func(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ IS
 
  BEGIN
    
	RETURN ms_logger.new_node(i_module_name => i_module_name
                             ,i_unit_name   => i_unit_name
							 ,i_unit_type   => G_UNIT_TYPE_FUNCTION );
 
  END;
  
 -- FUNCTION new_block(i_module_name IN VARCHAR2
 --                  ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ IS
 --
 -- BEGIN
 --   
--	RETURN ms_logger.new_node(i_module_name => i_module_name
 --                            ,i_unit_name   => i_unit_name
--							 ,i_unit_type   => G_UNIT_TYPE_BLOCK );
 --
 -- END;
  
/*  
------------------------------------------------------------------------
-- PASS operations (PUBLIC)
-- Pass is a metacoding shortcut.  
-- Creates and uses nodes that don't really exist, by adding 1 to the node_level
------------------------------------------------------------------------
PROCEDURE do_pass(io_node     IN OUT  ms_logger.node_typ
                 ,i_pass_name IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  ms_metacode.do_pass(io_node     => io_node    
                     ,i_pass_name => i_pass_name);

END;
  
*/  
  
------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

------------------------------------------------------------------------ 
PROCEDURE comment( i_node            IN ms_logger.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL
                  ,i_raise_app_error IN BOOLEAN  DEFAULT FALSE)
IS
BEGIN
 
    log_message(
       i_message  => i_message
      ,i_comment  => TRUE
      ,i_raise_app_error => i_raise_app_error
	  ,i_node     => i_node);
 
END comment;

------------------------------------------------------------------------
PROCEDURE info( i_node            IN ms_logger.node_typ 
               ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
 
  log_message(
    i_message  => i_message
   ,i_info     => TRUE
   ,i_node     => i_node);
 
END info;

------------------------------------------------------------------------

PROCEDURE warning( i_node         IN ms_logger.node_typ 
                  ,i_message      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
 
  log_message(
    i_message  => i_message
   ,i_warning  => TRUE
   ,i_node     => i_node);
 
END warning;

------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN     ms_logger.node_typ 
                ,i_message         IN     VARCHAR2 DEFAULT NULL
                ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE)
IS
BEGIN
 
  log_message(
    i_message         => i_message
   ,i_fatal           => TRUE
   ,i_raise_app_error => i_raise_app_error
   ,i_node     => i_node);
 
END fatal;  

------------------------------------------------------------------------ 
/* 
PROCEDURE raise_fatal( i_node            IN     ms_logger.node_typ 
                      ,i_message         IN     VARCHAR2 DEFAULT NULL
                      ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE
				      )
IS
BEGIN
 
  fatal( i_message         => i_message         
        ,i_raise_app_error => i_raise_app_error 
        ,i_node            => i_node);      
 
  RAISE x_error;

END raise_fatal; 
*/
  
end;
/