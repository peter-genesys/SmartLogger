alter session set plsql_ccflags = 'intlog:false';  
--alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package sm_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings 
 
--Ensure no inlining so sm_logger can be used
alter session set plsql_optimize_level = 1;

create or replace package body sm_logger is
------------------------------------------------------------------
-- Program  : sm_logger  
-- Name     : Smart logger for PL/SQL
-- Author   : P.Burgess
-- Purpose  : Logging for PL/SQL 
--            Smart logger has a reduced instruction set, that is appropriate for use with 
--            the SM_WEAVER for automated instrumentation of code.
--
------------------------------------------------------------------------
-- This package is not to be instrumented by the SM_WEAVER
-- @AOP_NEVER 

-- Quiet Mode
-- Any unit set to msg_mode QUIET will not cause calls to be logged unless:
-- A. An exception occurs in the call, or a later unlogged call
--    In this case the call is logged with msg_mode DEBUG
-- B. A later call is to be logged for a DEBUG or NORMAL unit.
--    In this case the call is logged with msg_mode QUIET
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
 
  
  g_debug_indent          INTEGER;
 
  G_MODULE_NAME_WIDTH     CONSTANT NUMBER := 50;
  G_UNIT_NAME_WIDTH       CONSTANT NUMBER := 50;
  G_REF_NAME_WIDTH        CONSTANT NUMBER := 100;
  G_REF_VALUE_WIDTH       CONSTANT NUMBER := 30;
  G_CALL_STACK_WIDTH      CONSTANT NUMBER := 2000;

  G_MAX_UNLOGGED_MSG_COUNT  CONSTANT NUMBER := 100;

  G_APEX_CONTEXT_COLLECTION       CONSTANT VARCHAR2(30) :=  'APEX_CONTEXT';
 
TYPE node_stack_typ IS
  TABLE OF node_typ
  INDEX BY BINARY_INTEGER;
 
  l_current_node  sm_logger.node_typ; 	
  
 

G_YES                   CONSTANT VARCHAR2(20) := 'Y';
G_NO                    CONSTANT VARCHAR2(20) := 'N';
G_TRUE                  CONSTANT VARCHAR2(20) := 'TRUE';
G_FALSE                 CONSTANT VARCHAR2(20) := 'FALSE';
G_NULL                  CONSTANT VARCHAR2(20) := 'NULL';
G_NL                    CONSTANT VARCHAR2(2)  := CHR(10);

--Practical limit of 1900 chars from dbms_utility.format_call_stack is reached at 30 nested nodes.
--The result is that the logger will not nest nodes greater than 30 levels.
--This limit, is not expected to be encountered unless the logger is broken by some future bug. 
G_MAX_NESTED_NODES      CONSTANT NUMBER       := 1000;  


--NEW CONTROLS

g_empty_session                  sm_session%ROWTYPE; --constant
g_session                        sm_session%ROWTYPE;
         
g_nodes                          node_stack_typ;
 
g_logger_msg_mode integer := G_MSG_MODE_OVERRIDDEN;

--Node Types
--Root Only  - Will end current process and start a new one.
--Root Never - Will not start a process
--Either will start a process if none started and Normal, or Debug msg_mode.

--Auto Wake     auto_wake
--Yes           Y         - wake if asleep
--No            N         - never wake
--Force         F         - wake (new process) even if already awake
 
------------------------------------------------------------------------
-- UNIT TYPES (Private)
------------------------------------------------------------------------
--GENERAL UNIT TYPES 
G_UNIT_TYPE_PACKAGE       CONSTANT sm_unit.unit_type%TYPE := 'PKG';
G_UNIT_TYPE_PROCEDURE     CONSTANT sm_unit.unit_type%TYPE := 'PROC';
G_UNIT_TYPE_FUNCTION      CONSTANT sm_unit.unit_type%TYPE := 'FUNC';
--G_UNIT_TYPE_LOOP          CONSTANT sm_unit.unit_type%TYPE := 'LOOP';
--G_UNIT_TYPE_BLOCK         CONSTANT sm_unit.unit_type%TYPE := 'BLOCK';
G_UNIT_TYPE_TRIGGER       CONSTANT sm_unit.unit_type%TYPE := 'TRIGGER';
G_UNIT_TYPE_SCRIPT        CONSTANT sm_unit.unit_type%TYPE := 'SCRIPT';
--G_UNIT_TYPE_PASS          CONSTANT sm_unit.unit_type%TYPE := 'PASS';
 
--FORM TRIGGER UNIT TYPES 
G_UNIT_TYPE_FORM_TRIGGER   CONSTANT sm_unit.unit_type%TYPE := 'FORM_TRIG'; 
G_UNIT_TYPE_BLOCK_TRIGGER  CONSTANT sm_unit.unit_type%TYPE := 'BLOCK_TRIG'; 
G_UNIT_TYPE_RECORD_TRIGGER CONSTANT sm_unit.unit_type%TYPE := 'REC_TRIG'; 
G_UNIT_TYPE_ITEM_TRIGGER   CONSTANT sm_unit.unit_type%TYPE := 'ITEM_TRIG'; 

--REPORT TRIGGER UNIT TYPES
G_UNIT_TYPE_REPORT_TRIGGER  CONSTANT sm_unit.unit_type%TYPE := 'REP_TRIG'; 
G_UNIT_TYPE_FORMAT_TRIGGER  CONSTANT sm_unit.unit_type%TYPE := 'FORMAT_TRG'; 
G_UNIT_TYPE_GROUP_FILTER    CONSTANT sm_unit.unit_type%TYPE := 'GRP_FILTER'; 
 
G_MODULE_TYPE_PACKAGE     CONSTANT sm_module.module_type%TYPE := 'PACKAGE';
G_MODULE_TYPE_PROCEDURE   CONSTANT sm_module.module_type%TYPE := 'PROCEDURE';
G_MODULE_TYPE_FUNCTION    CONSTANT sm_module.module_type%TYPE := 'FUNCTION';
G_MODULE_TYPE_FORM        CONSTANT sm_module.module_type%TYPE := 'FORM';
G_MODULE_TYPE_REPORT      CONSTANT sm_module.module_type%TYPE := 'REPORT';
G_MODULE_TYPE_SCRIPT      CONSTANT sm_module.module_type%TYPE := 'SCRIPT';
G_MODULE_TYPE_DBTRIGGER   CONSTANT sm_module.module_type%TYPE := 'DB_TRIG';
  
G_AUTO_WAKE_DEFAULT        sm_unit.auto_wake%TYPE;
G_AUTO_MSG_MODE_DEFAULT    NUMBER(2);

G_MANUAL_MSG_MODE_DEFAULT  NUMBER(2) := G_MSG_MODE_OVERRIDDEN;

G_PARENT_APP_SESSION_VAR   VARCHAR2(50);

--------------------------------------------------------------------------------
--f_config_value
--------------------------------------------------------------------------------
function f_config_value(i_name IN VARCHAR2) return VARCHAR2 result_cache IS

  cursor cu_config(c_name IN VARCHAR2) is
  select value
  from   sm_config
  where  name = c_name;

  l_result  sm_config.value%type;
 
begin
  open  cu_config(c_name => i_name);
  fetch cu_config into l_result;
  close cu_config;

  return l_result;
 
end; 

 
FUNCTION f_logger_is_asleep RETURN BOOLEAN IS
BEGIN
  --start_datetime is null when logger is asleep
  --(logger is asleep when the logger package initilises)
  RETURN g_session.created_date IS NULL;

END f_logger_is_asleep; 

FUNCTION f_logger_is_awake RETURN BOOLEAN IS
BEGIN   
  RETURN NOT f_logger_is_asleep;
END f_logger_is_awake; 

FUNCTION f_logger_is_quiet RETURN BOOLEAN IS
BEGIN
  --Process is cached, but not logged.
  --All nodes have been disabled or quiet.
  RETURN g_session.session_id is null;
END f_logger_is_quiet; 

FUNCTION f_logger_is_active RETURN BOOLEAN IS
BEGIN
  RETURN NOT f_logger_is_quiet;
END f_logger_is_active; 


FUNCTION f_internal_error return boolean is
BEGIN
  return  g_session.internal_error = 'Y'; 
END f_internal_error;
 
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
* MODULE:       f_true_false
* PURPOSE:      Converts a boolean TRUE/FALSE to a TRUE/FALSE sting variable
* RETURNS:
* NOTES:
*********************************************************************/
FUNCTION f_true_false (i_boolean IN BOOLEAN)
RETURN VARCHAR2 IS
BEGIN
  IF i_boolean THEN
    RETURN G_TRUE;
    
  ELSIF NOT i_boolean THEN
    RETURN G_FALSE;
    
  ELSE 
    RETURN G_NULL;
  END IF;
END f_true_false;  
  
----------------------------------------------------------------------
-- NEW ID's   
-- Get an ID from a sequence (private)
----------------------------------------------------------------------

FUNCTION new_module_id RETURN NUMBER IS
 
BEGIN
 
  RETURN sm_module_seq.NEXTVAL;

END new_module_id;

----------------------------------------------------------------------
 
FUNCTION new_unit_id RETURN NUMBER IS
 
BEGIN
 
  RETURN sm_unit_seq.NEXTVAL;

END new_unit_id;

----------------------------------------------------------------------

FUNCTION new_call_id RETURN NUMBER IS
 
BEGIN
 
  RETURN sm_call_seq.NEXTVAL;
  
END new_call_id;

----------------------------------------------------------------------

FUNCTION new_message_id RETURN NUMBER IS
 
BEGIN
 
  RETURN sm_message_seq.NEXTVAL;

END new_message_id;


------------------------------------------------------------------------
FUNCTION f_current_call_id RETURN NUMBER;  -- FORWARD DECLARATION
------------------------------------------------------------------------

  
------------------------------------------------------------------------
-- Internal logging routines (private)
-- sm_logger cannot be used to log itself, so an alternative internal syntax exists
-- Output is designed for the unit test "ms_test.sql".
-- These routines are includes in the package only when compiled with intlog:true
------------------------------------------------------------------------
 
--COMPILER FLAGGED PROCEDURES - START
$if $$intlog $then 

PROCEDURE intlog_putline(i_line IN VARCHAR2 ) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
--Don't call this directly.
  l_text varchar2(1000) := SUBSTR(LPAD('+ ',g_debug_indent*2,'+ ')||i_line,1,1000);
BEGIN 
    dbms_output.put_line(l_text);
    insert into sm_log (text) values (l_text);
    commit;
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

PROCEDURE intlog_debug(i_message IN VARCHAR2 ) IS
BEGIN 
  intlog_putline('!'||i_message);
END;

PROCEDURE intlog_note(i_name  IN VARCHAR2
                     ,i_value IN VARCHAR2) IS
BEGIN 
  intlog_putline('.'||i_name||':'||i_value);
END;

PROCEDURE intlog_note(i_name  IN VARCHAR2
                     ,i_value IN BOOLEAN) IS					 
BEGIN 
  intlog_putline('.'||i_name||':'||f_true_false(i_value));
END;
 


PROCEDURE intlog_error(i_message IN VARCHAR2 ) IS
BEGIN 
  intlog_putline('##'||i_message);
END;
 
$end           
--COMPILER FLAGGED PROCEDURES - FINISH


PROCEDURE err_set_session_internal_error(i_error_message IN VARCHAR2) IS
  --set internal error
  --create_ref, create_call, log_message will not start 
  --while this flag is set.  
  --These procedures are the ONLY gateways to the LOG and PUSH routines
  
   PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 
 
  $if $$intlog $then intlog_debug('INTERNAL ERROR'); $end
  $if $$intlog $then intlog_error(i_error_message);  $end

  --fatal(g_nodes(f_index)  ,'sm_logger Internal Error');
  --warning(g_nodes(f_index),'log_node: exceeded ' ||G_MAX_NESTED_NODES||' nested procs.');

  g_session.internal_error := 'Y'; 
  g_session.error_message  := i_error_message; 
  g_session.updated_date   := SYSDATE; 
 
  --NB if g_session_id is NULL,this will do nothing and raise no error, but that is ok.
  UPDATE sm_session 
  SET ROW = g_session
  WHERE session_id   = g_session.session_id
  AND   internal_error = 'N';

  if sql%rowcount = 0 then
    insert into sm_session values g_session;
  end if;
 
  COMMIT;

END; 
 
 
PROCEDURE err_raise_internal_error(i_prog_unit IN VARCHAR2 
                                  ,i_message   IN CLOB ) IS
 
BEGIN 
 
  err_set_session_internal_error(i_error_message => i_prog_unit||': '||i_message) ;
 
END; 

 
PROCEDURE err_warn_oracle_error(i_prog_unit IN VARCHAR2 ) IS
BEGIN 
  $if $$intlog $then intlog_putline(i_prog_unit||':');     $end
  err_raise_internal_error(i_prog_unit => i_prog_unit
                          ,i_message   => SQLERRM);
  $if $$intlog $then intlog_end(i_prog_unit); $end --extra call to intlog_end closes the program unit.

END;


------------------------------------------------------------------------
-- Get Enitity operations (private)
------------------------------------------------------------------------


FUNCTION get_module(i_module_name  IN VARCHAR2) RETURN sm_module%ROWTYPE RESULT_CACHE RELIES_ON (sm_module)
IS

  CURSOR cu_module(c_module_name  VARCHAR2)
  IS
  SELECT *
  FROM   sm_module
  WHERE  module_name = c_module_name;
 
  l_module sm_module%ROWTYPE;
 
BEGIN
 
  OPEN cu_module(c_module_name  => i_module_name  );
  FETCH cu_module INTO l_module;
  CLOSE cu_module;
 
  RETURN l_module;
 
END get_module;

--------------------------------------------------------------------
-- object_owner
--------------------------------------------------------------------
FUNCTION object_owner(i_object_name IN VARCHAR2) RETURN VARCHAR2 IS
  
  -- find the most appropriate object owner.
  -- Of DBA OBJECTS  
  -- Select 1 owner, with preference to the user
  CURSOR cu_owner IS
  select owner
  from   dba_objects
  where  object_name = UPPER(i_object_name)
  and    object_type <> 'SYNONYM'
  order by decode(owner,USER,1,2);

  l_result VARCHAR2(30);

BEGIN
  OPEN cu_owner;
  FETCH cu_owner INTO l_result;
  CLOSE cu_owner;

  RETURN NVL(l_result,USER);

END;


  --------------------------------------------------------------------
  -- object_type
  --------------------------------------------------------------------
  FUNCTION object_type(i_object_name  IN VARCHAR2
                      ,i_owner        IN VARCHAR2) RETURN VARCHAR2 IS
    
 
    CURSOR cu_type IS
    select object_type
    from   dba_objects
    where  object_name = UPPER(i_object_name)
    and    object_type <> 'SYNONYM'
    and    owner       = i_owner;

    l_result VARCHAR2(30);

  BEGIN
    OPEN cu_type;
    FETCH cu_type INTO l_result;
    CLOSE cu_type;

    RETURN l_result;
 
  END;


  --------------------------------------------------------------------
  -- find_module
  --------------------------------------------------------------------
FUNCTION find_module(i_module_name  IN VARCHAR2
                    ,i_module_type  IN VARCHAR2 DEFAULT NULL
                    ,i_revision     IN VARCHAR2 DEFAULT NULL
                    ,i_unit_name    IN VARCHAR2 DEFAULT NULL
                    ,i_create       IN BOOLEAN  DEFAULT TRUE)
RETURN sm_module%ROWTYPE
IS
 
  l_module sm_module%ROWTYPE;
 
  l_module_exists BOOLEAN;
 
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN 
  $if $$intlog $then intlog_start('find_module');                 $end
  $if $$intlog $then intlog_note('i_module_name',i_module_name);  $end
  $if $$intlog $then intlog_note('i_module_type',i_module_type);  $end
  $if $$intlog $then intlog_note('i_revision   ',i_revision   );  $end
  $if $$intlog $then intlog_note('i_unit_name  ',i_unit_name  );  $end
  $if $$intlog $then intlog_note('i_create  '   ,i_create     );  $end
  
  l_module := get_module(i_module_name => LOWER(i_module_name)  );
  l_module_exists := l_module.module_id IS NOT NULL;

  IF NOT l_module_exists AND i_create THEN
    $if $$intlog $then intlog_debug('Create a new module');  $end
	
    IF i_module_type IS NULL THEN 
      --Derive module type
      $if $$intlog $then intlog_debug('Derive module type');  $end
      CASE 
        --Legacy support for Oracle Reports - may not bother supporting in future.
        WHEN i_unit_name IN ('beforepform'
                            ,'afterpform'
                            ,'afterreport') THEN 
          --These program units are assumed to be reoprts.
          $if $$intlog $then intlog_debug('assumed to be reoprts');  $end
          l_module.owner        := USER;
          l_module.module_type  := G_MODULE_TYPE_REPORT;

        ELSE 
          --Look up the module in the data dictionary
          $if $$intlog $then intlog_debug('Look up data dictionary');  $end
          l_module.owner       :=  object_owner(i_object_name => i_module_name);
          $if $$intlog $then intlog_note('l_module.owner'   ,l_module.owner );  $end
          IF l_module.owner = 'ANONYMOUS' THEN
            l_module.module_type := 'APEX';
          ELSE
            l_module.module_type :=  object_type(i_object_name  => i_module_name
                                                ,i_owner        => l_module.owner);
          END IF;
          $if $$intlog $then intlog_note('l_module.module_type'   ,l_module.module_type );  $end
      END CASE;
      
    ELSE
      l_module.module_type := i_module_type;
    END IF;  

    --create the new module record
    $if $$intlog $then intlog_debug('create the new module record');  $end
    l_module.module_id       := new_module_id;
    l_module.module_name     := LOWER(i_module_name);
    l_module.revision        := i_revision;
    l_module.auto_wake       := G_AUTO_WAKE_DEFAULT;
    l_module.auto_msg_mode   := G_AUTO_MSG_MODE_DEFAULT;      
    l_module.manual_msg_mode := G_MANUAL_MSG_MODE_DEFAULT; 
 
    --insert a new module instance
    $if $$intlog $then intlog_debug('insert module');  $end
    INSERT INTO sm_module VALUES l_module; 
 
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
                 ,i_unit_name    IN VARCHAR2) RETURN sm_unit%ROWTYPE RESULT_CACHE RELIES_ON (sm_unit)
IS
 
  CURSOR cu_unit(c_module_id    NUMBER
                ,c_unit_name    VARCHAR2)
  IS
  SELECT *
  FROM   sm_unit
  WHERE  module_id   = c_module_id
  AND    unit_name   = c_unit_name;

  l_unit sm_unit%ROWTYPE;
 
BEGIN
  OPEN cu_unit(c_module_id  => i_module_id
              ,c_unit_name  => i_unit_name  );
  FETCH cu_unit INTO l_unit;
  CLOSE cu_unit;
 
  RETURN l_unit;
 
END get_unit;

------------------------------------------------------------------------
FUNCTION find_unit(i_module_id    IN NUMBER
                 ,i_unit_name    IN VARCHAR2
                 ,i_unit_type    IN VARCHAR2 DEFAULT NULL
                 ,i_create       IN BOOLEAN  DEFAULT TRUE)
RETURN sm_unit%ROWTYPE
IS
 
  l_unit sm_unit%ROWTYPE;
  l_unit_exists BOOLEAN;
  
  PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN
  $if $$intlog $then intlog_start('find_unit'); $end
  $if $$intlog $then intlog_note('i_module_id  ',i_module_id  );  $end
  $if $$intlog $then intlog_note('i_unit_name  ',i_unit_name  );  $end
  $if $$intlog $then intlog_note('i_unit_type  ',i_unit_type  );  $end
  $if $$intlog $then intlog_note('i_create  '   ,i_create     );  $end
 
  l_unit := get_unit(i_module_id => i_module_id
                    ,i_unit_name => i_unit_name);
  l_unit_exists := l_unit.unit_id IS NOT NULL;
 
  IF NOT l_unit_exists AND i_create THEN
    $if $$intlog $then intlog_debug('Create a new unit');  $end
    --create the new procedure record
    l_unit.unit_id         := new_unit_id;
    l_unit.module_id       := i_module_id;
    l_unit.unit_name       := i_unit_name;
    l_unit.unit_type       := i_unit_type;
    l_unit.auto_wake       := G_AUTO_WAKE_OVERRIDDEN; --overridden by module auto_wake
    l_unit.auto_msg_mode   := G_MSG_MODE_OVERRIDDEN;  --overridden by module auto_msg_mode      
    l_unit.manual_msg_mode := G_MSG_MODE_OVERRIDDEN;  --overridden by module manual_msg_mod

    --insert a new procedure instance
    INSERT INTO sm_unit VALUES l_unit;  

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
RETURN sm_unit%ROWTYPE
IS
BEGIN
  RETURN find_unit(i_module_id  => find_module(i_module_name => i_module_name
                                              ,i_unit_name   => i_unit_name).module_id
                  ,i_unit_name  => i_unit_name  
                  ,i_unit_type  => i_unit_type
                  ,i_create     => i_create); 

END;

 

 


/*

--BLOCK TRIGGER NODE
FUNCTION block_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN sm_logger.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node sm_logger.node_typ := sm_logger.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
  l_node.unit_type := G_UNIT_TYPE_BLOCK_TRIGGER;
 
  RETURN l_node;
                           
END; 

--RECORD TRIGGER NODE
FUNCTION record_trigger_node(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
							,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN sm_logger.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node sm_logger.node_typ := sm_logger.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_RECORD_TRIGGER;
 
  RETURN l_node;
                           
END; 
 
--ITEM TRIGGER NODE
FUNCTION item_trigger_node(i_module_name IN VARCHAR2
                          ,i_unit_name   IN VARCHAR2
						  ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN sm_logger.node_typ IS
  l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
  l_node sm_logger.node_typ := sm_logger.new_node(i_module_name,i_unit_name,l_call_stack);
BEGIN
 
  l_node.unit_type := G_UNIT_TYPE_ITEM_TRIGGER;
 
  RETURN l_node;
                           
END; 

*/




--PUBLIC MODE PROCEDURES
 
--
--                       PRIVATE MODULES



----------------------------------------------------------------------
-- EXPOSED FOR THE MS_API
----------------------------------------------------------------------


----------------------------------------------------------------------
-- f_session_logged
----------------------------------------------------------------------
FUNCTION f_session_logged(i_session_id IN INTEGER) RETURN BOOLEAN IS
  CURSOR cu_call IS
  SELECT 1
  FROM   sm_call t  
  WHERE  t.session_id = i_session_id ;  
 				 
  l_dummy  INTEGER;	
  l_result BOOLEAN;  
				 
BEGIN
 
    OPEN cu_call;
    FETCH cu_call INTO l_dummy;
	l_result := cu_call%FOUND;
    CLOSE cu_call;
    
    RETURN l_result;
   
END f_session_logged;

----------------------------------------------------------------------
-- f_session_exceptions - TRUE if any exceptions
----------------------------------------------------------------------
FUNCTION f_session_exceptions(i_session_id IN INTEGER) RETURN BOOLEAN IS
  CURSOR cu_error_message IS
  SELECT 1
  FROM   sm_call c
        ,sm_message   m  
  WHERE  c.session_id   = i_session_id 
  and    m.call_id = c.call_id
  and    m.msg_level   >= G_MSG_LEVEL_WARNING;
         
  l_dummy  INTEGER; 
  l_result BOOLEAN;  
         
BEGIN
 
    OPEN cu_error_message;
    FETCH cu_error_message INTO l_dummy;
    l_result := cu_error_message%FOUND;
    CLOSE cu_error_message;
    
    RETURN l_result;
   
END f_session_exceptions;

 
----------------------------------------------------------------------
-- f_session_id
----------------------------------------------------------------------
FUNCTION f_session_id(i_session_id IN INTEGER  DEFAULT NULL
                   --  ,i_ext_ref    IN VARCHAR2 DEFAULT NULL
                   ) RETURN INTEGER IS
					 
  CURSOR cu_process IS
  SELECT session_id
  FROM   sm_session   p
  WHERE  p.session_id = i_session_id;
    -- OR  p.ext_ref    = i_ext_ref;  
 				 
  l_result INTEGER;				 
				 
BEGIN
  IF i_session_id IS NOT NULL 
  -- OR i_ext_ref IS NOT NULL 
THEN
    OPEN cu_process;
    FETCH cu_process INTO l_result;
    CLOSE cu_process;
    
    RETURN l_result;
   
  ELSE
   
    RETURN g_session.session_id;
    
  END IF;  
  
END f_session_id;
 
 
FUNCTION f_process_is_closed RETURN BOOLEAN IS
BEGIN
  RETURN g_session.session_id IS NULL;
END f_process_is_closed;

FUNCTION f_process_is_open RETURN BOOLEAN IS
BEGIN
  RETURN NOT f_process_is_closed;
END f_process_is_open; 
 




----------------------------------------------------------------------
-- DERIVATION RULES (private)
----------------------------------------------------------------------
 
------------------------------------------------------------------------
-- Process operations (private)
------------------------------------------------------------------------ 
PROCEDURE snooze_logger  
IS
BEGIN
 
    g_session := g_empty_session;
    --Logger is now asleep. 
    --Internal error flag is reset.
    --Logger can be re-awoken.
 
END snooze_logger;
 

------------------------------------------------------------------------
-- Node Stack operations (private)
------------------------------------------------------------------------

PROCEDURE init_node_stack  
IS
BEGIN

  g_nodes.DELETE;  
  g_nodes(0).call.call_id := NULL;
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


FUNCTION f_current_call_id RETURN NUMBER IS 
BEGIN
  RETURN g_nodes(f_index).call.call_id;
END;
 
------------------------------------------------------------------------
FUNCTION f_current_call_msg_mode RETURN NUMBER IS 
BEGIN
  RETURN g_nodes(f_index).call.msg_mode;
END;

FUNCTION f_is_stack_empty RETURN BOOLEAN IS 
BEGIN
  RETURN f_index = 0;
END;

 
------------------------------------------------------------------------
PROCEDURE pop_to_parent_node(i_node IN node_typ) IS
--Pop any node that is not an ancestor of this node.
BEGIN
  $if $$intlog $then intlog_start('pop_to_parent_node');                            $end
  $if $$intlog $then intlog_note('i_node.unit.unit_name',i_node.unit.unit_name );   $end
  
  $if $$intlog $then intlog_note('current call_stack_level',i_node.call_stack_level );  $end
  $if $$intlog $then intlog_note('f_index',f_index );                                   $end
  $if $$intlog $then intlog_note('g_nodes(f_index).unit.unit_name',g_nodes(f_index).unit.unit_name );   $end


  --remove from the stack any node with a call_stack_level equal to or greater than the new node.
  --also remove any node that does not have common grandparent
  while f_index > 0 and
        i_node.call_stack_level <=           g_nodes(f_index).call_stack_level --TEMP TEST
		--OOPS My call_stack_hist clause does not seem to be reliable. Not sure why need to sort out.
		--There were issues with the SUN.Rep_Pb_Pack package at runtime.
        --(i_node.call_stack_level <=           g_nodes(f_index).call_stack_level OR   --ORIG
		-- i_node.call_stack_hist NOT LIKE '%'||g_nodes(f_index).call_stack_hist )     --ORIG
	    --(i_node.call_stack_level <=           g_nodes(f_index).call_stack_level OR  
		-- i_node.call_stack_hist NOT LIKE      g_nodes(f_index).call_stack_hist||'%' )
 
  loop
 
	   $if $$intlog $then intlog_note('last call_stack_level',g_nodes(f_index).call_stack_level ); $end
	   $if $$intlog $then intlog_note('last call_stack_hist' ,g_nodes(f_index).call_stack_hist ); $end
	   $if $$intlog $then intlog_debug('pop_to_parent_node: removing top node '||f_index );        $end
       g_nodes.DELETE( f_index );

  end loop;

  if f_is_stack_empty then 
    $if $$intlog $then intlog_debug('pop_to_parent_node: no parents left.  Put logger to sleep.'); $end
    snooze_logger;
  end if;

  $if $$intlog $then intlog_end('pop_to_parent_node'); $end
 
EXCEPTION

  WHEN OTHERS THEN
    err_warn_oracle_error('pop_to_parent_node');
END; 


------------------------------------------------------------------------
PROCEDURE pop_descendent_nodes(i_node IN node_typ) IS
--Pop any node that is not a ancestor of this node.
BEGIN
  $if $$intlog $then intlog_start('pop_descendent_nodes');                              $end     
  $if $$intlog $then intlog_note('i_node.unit.unit_name',i_node.unit.unit_name );   $end
  
  $if $$intlog $then intlog_note('current call_stack_level',i_node.call_stack_level );  $end
  $if $$intlog $then intlog_note('f_index',f_index );                                   $end
  $if $$intlog $then intlog_note('g_nodes(f_index).unit.unit_name',g_nodes(f_index).unit.unit_name );   $end

  --remove from the stack any node with a call_stack_level equal to or greater than the new node.
  while f_index > 0 and
        g_nodes(f_index).call_stack_level > i_node.call_stack_level  loop
	   $if $$intlog $then intlog_note('last call_stack_level',g_nodes(f_index).call_stack_level ); $end
	   $if $$intlog $then intlog_debug('pop_descendent_nodes: removing top node '||f_index );      $end
 
       g_nodes.DELETE( f_index );
  end loop;
  $if $$intlog $then intlog_end('pop_descendent_nodes'); $end
 
EXCEPTION

  WHEN OTHERS THEN
    err_warn_oracle_error('pop_descendent_nodes');
END; 

 
------------------------------------------------------------------------
PROCEDURE push_node(io_node  IN OUT node_typ) IS
  l_next_index          BINARY_INTEGER;    

BEGIN
  $if $$intlog $then intlog_start('push_node'); $end
  $if $$intlog $then intlog_note('io_node.unit.unit_name',io_node.unit.unit_name );   $end
 
  --Next index is last index + 1
  l_next_index := NVL(f_index,0) + 1;
  $if $$intlog $then intlog_note('l_next_index',l_next_index ); $end

  --add to the top of the stack             
  g_nodes(l_next_index ) := io_node;
  $if $$intlog $then intlog_end('push_node'); $end

EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('push_node');
END;

------------------------------------------------------------------------
-- synch_node_stack
------------------------------------------------------------------------
 
PROCEDURE synch_node_stack( i_node IN sm_logger.node_typ) IS
BEGIN 
  --Is the node on the stack??
  IF i_node.node_level is not null then
    --ENSURE calls point to current node.
    pop_descendent_nodes(i_node => i_node);
  end if;

END;

------------------------------------------------------------------------
-- dump_nodes - forward declaration
------------------------------------------------------------------------
PROCEDURE dump_nodes(i_index    IN BINARY_INTEGER
                    ,i_msg_mode IN NUMBER);

 

------------------------------------------------------------------------
--CACHING ROUTINES
------------------------------------------------------------------------

PROCEDURE create_session(io_node  IN OUT node_typ) IS
  --Logger is now awake
BEGIN
    $if $$intlog $then intlog_start('create_session'); $end
    $if $$intlog $then intlog_note('io_node.module.module_name',io_node.module.module_name );   $end
    $if $$intlog $then intlog_note('io_node.unit.unit_name'    ,io_node.unit.unit_name );   $end
    $if $$intlog $then intlog_note('io_node.call_stack_hist'   ,io_node.call_stack_hist );   $end
    $if $$intlog $then intlog_note('io_node.call_stack_level'   ,io_node.call_stack_level );   $end
    $if $$intlog $then intlog_note('io_node.call_stack_parent'   ,io_node.call_stack_parent );   $end

    --$if $$intlog $then intlog_note('format_call_stack'   ,dbms_utility.format_call_stack );   $end
    

    g_session.session_id     := null;
    if io_node.module.module_name = 'sm_jotter' then
      g_session.origin       := io_node.call_stack_parent;
    else  
      g_session.origin         := io_node.module.module_name||'.'||io_node.unit.unit_name;
    end if;
    g_session.username       := lower(USER);
    g_session.created_date   := SYSDATE;      --This is when the process is cached, rather than when inserted.
    g_session.internal_error := 'N';  --reset internal error for the new process
    g_session.keep_yn        := 'N';
    g_session.app_user       := lower(v('APP_USER'));
    --APP_USER_FULLNAME
    --APP_USER_EMAIL
    g_session.app_session         := v('APP_SESSION');
    g_session.parent_app_session  := v(G_PARENT_APP_SESSION_VAR);
    IF g_session.parent_app_session = g_session.app_session then
      --Ensure parent_app_session IS NEVER SAME app_session
      --Root session must have no parent session.
      g_session.parent_app_session := null;
    END IF;
    g_session.app_id              := v('APP_ID');
    g_session.app_alias           := v('APP_ALIAS');
    g_session.app_title           := v('APP_TITLE');
    g_session.app_page_id         := v('APP_PAGE_ID');
    g_session.app_page_alias      := v('APP_PAGE_ALIAS');
 
    init_node_stack; --remove all nodes from the stack.

    $if $$intlog $then intlog_debug('Logger Session created, but not yet logged.');   $end 
 

    --@TODO Either log the process now - if the unit is set to DEBUGGING or NORMAL
    --OR wait unit attempt to log node. 
 
    $if $$intlog $then intlog_end('create_session'); $end

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('create_session');
    
END create_session;

 

------------------------------------------------------------------------
-- LOGGING ROUTINES (private)
-- These routines write to the logging tables
------------------------------------------------------------------------


------------------------------------------------------------------------
-- add_node (private)
-- Add a node to the node stack
------------------------------------------------------------------------
procedure add_node( i_apex_context_id    in varchar2 
                  ,i_apex_context_type   in varchar2 
                  ,i_parent_context_id   in varchar2 default null
                  ,i_app_user            in varchar2 default null
                  ,i_app_user_fullname   in varchar2 default null
                  ,i_app_user_email      in varchar2 default null
                  ,i_app_session         in varchar2 default null
                  ,i_parent_app_session  in varchar2 default null
                  ,i_app_id              in varchar2 default null     
                  ,i_app_alias           in varchar2 default null  
                  ,i_app_title           in varchar2 default null 
                  ,i_app_page_id         in varchar2 default null
                  ,i_app_page_alias      in varchar2 default null
                  ,i_created_date        in date 
                  ,i_updated_date        in date     default null) is
BEGIN
  $if $$intlog $then intlog_start('add_node'); $end
    
    APEX_COLLECTION.ADD_MEMBER (
         p_collection_name => G_APEX_CONTEXT_COLLECTION
        ,p_c001            => i_apex_context_id  
        ,p_c002            => i_apex_context_type
        ,p_c003            => i_parent_context_id 
        ,p_c004            => i_app_user          
        ,p_c005            => i_app_user_fullname 
        ,p_c006            => i_app_user_email    
        ,p_c007            => i_app_session     
        ,p_c008            => i_parent_app_session   
        ,p_c009            => i_app_id            
        ,p_c010            => i_app_alias         
        ,p_c011            => i_app_title         
        ,p_c012            => i_app_page_id       
        ,p_c013            => i_app_page_alias    
        ,p_d001            => i_created_date
        ,p_d002            => i_updated_date
      );
  $if $$intlog $then intlog_start('add_node'); $end
END add_node; 

------------------------------------------------------------------------
-- check_node_exists (private)
-- Test node exists in the stack
------------------------------------------------------------------------
function check_node_exists(i_app_session in varchar2 default null
                          ,i_app_id      in varchar2 default null
                          ,i_app_page_id in varchar2 default null) return boolean is

  cursor cu_node is
  select * from sm_apex_context_collection_v
  where  (app_session = i_app_session and apex_context_type IN ('SESSION','CLONE'))
      or (app_id      = i_app_id      and apex_context_type = 'APP')
      or (app_page_id = i_app_page_id and apex_context_type = 'PAGE');

  l_dummy  cu_node%ROWTYPE;
  l_result boolean;

BEGIN
  $if $$intlog $then intlog_start('check_node_exists'); $end
  open cu_node;
  fetch cu_node into l_dummy;
  l_result := cu_node%FOUND;
  close cu_node;
  $if $$intlog $then intlog_end('check_node_exists'); $end
  return l_result;

end;
 

------------------------------------------------------------------------
-- get_apex_context_id (private)
-- Finds the node and returns its ID.
------------------------------------------------------------------------
function get_apex_context_id(i_app_session in varchar2 default null
                            ,i_app_id      in varchar2 default null
                            ,i_app_page_id in varchar2 default null) return varchar2 is

  cursor cu_node is
  select * from sm_apex_context_collection_v
  where  (app_session = i_app_session and apex_context_type IN ('SESSION','CLONE'))
      or (app_id      = i_app_id      and apex_context_type = 'APP')
      or (app_page_id = i_app_page_id and apex_context_type = 'PAGE');

  l_app_context  SM_APEX_CONTEXT%ROWTYPE;
 
BEGIN
  $if $$intlog $then intlog_start('get_apex_context_id'); $end
  open cu_node;
  fetch cu_node into l_app_context;
  close cu_node;
  $if $$intlog $then intlog_end('get_apex_context_id'); $end
  return l_app_context.APEX_CONTEXT_ID;

end;

procedure delete_nodes(i_keep_count in integer) is
  l_count integer;
BEGIN
  $if $$intlog $then intlog_start('delete_nodes'); $end
 loop 
   l_count := APEX_COLLECTION.COLLECTION_MEMBER_COUNT( p_collection_name => G_APEX_CONTEXT_COLLECTION);
   exit when l_count <= i_keep_count;
   apex_collection.delete_member( p_collection_name => G_APEX_CONTEXT_COLLECTION, p_seq => l_count);
 end loop;
 $if $$intlog $then intlog_end('delete_nodes'); $end

END;



------------------------------------------------------------------------
-- construct_apex_context (private)
-- Setup the apex context node collection
------------------------------------------------------------------------

Procedure construct_apex_context is
  
  l_session_apex_context_id varchar2(50);
  l_app_apex_context_id     varchar2(50);
  l_node sm_logger.node_typ;  
 
begin  
  $if $$intlog $then intlog_start('construct_apex_context'); $end

  $if $$intlog $then intlog_note('g_session.app_session',g_session.app_session);   $end
  $if $$intlog $then intlog_note('g_session.app_id',g_session.app_id);   $end
  $if $$intlog $then intlog_note('g_session.app_page_id',g_session.app_page_id);   $end
 
    if g_session.app_session is not null then
      --Setup the apex context node collection
      if not apex_collection.collection_exists(p_collection_name => G_APEX_CONTEXT_COLLECTION) then
        --Create the node collection
        apex_collection.create_collection(p_collection_name => G_APEX_CONTEXT_COLLECTION);
      end if;  

      l_session_apex_context_id := get_apex_context_id(i_app_session => g_session.app_session);
      if l_session_apex_context_id is null then

        l_session_apex_context_id := 'S'||g_session.app_session;
        --NB i do not prepend session_id which would be useful for ordering 
        --because the clone session would not be able to identify the parent without doing a lookup.

        $if $$intlog $then intlog_debug('Session not found');   $end

        --Delete all nodes
        $if $$intlog $then intlog_debug('Delete all nodes');   $end
        delete_nodes(i_keep_count => 0);
 
        --Create App Session node
        IF g_session.parent_app_session is null then

          add_node( i_apex_context_id   => l_session_apex_context_id
                   ,i_apex_context_type => 'SESSION'
                   ,i_parent_context_id => null
                   ,i_app_user          => g_session.app_user 
                   ,i_app_user_fullname => g_session.app_user_fullname 
                   ,i_app_user_email    => g_session.app_user_email 
                   ,i_app_session       => g_session.app_session
                   ,i_parent_app_session=> g_session.parent_app_session
                   ,i_created_date      => g_session.created_date);

        else
        
          add_node( i_apex_context_id   => l_session_apex_context_id
                   ,i_apex_context_type => 'CLONE'
                   ,i_parent_context_id => 'S'||g_session.parent_app_session
                   ,i_app_user          => g_session.app_user 
                   ,i_app_user_fullname => g_session.app_user_fullname 
                   ,i_app_user_email    => g_session.app_user_email 
                   ,i_app_session       => g_session.app_session
                   ,i_parent_app_session=> g_session.parent_app_session
                   ,i_created_date      => g_session.created_date );
 
        end if;  
 
      end if;
 
      l_app_apex_context_id := get_apex_context_id(i_app_id =>  g_session.app_id);
      if l_app_apex_context_id is null then
        l_app_apex_context_id := 'A'||g_session.session_id
                               ||'_'||g_session.app_session
                               ||'_'||g_session.app_id;
 
        $if $$intlog $then intlog_debug('App not found');   $end
        --Delete ndoes 2 and 3
        $if $$intlog $then intlog_debug('Delete App and Page nodes');   $end
        delete_nodes(i_keep_count => 1);
 
        --get a registered module or register this one
        l_node.module := find_module(i_module_name => g_session.app_id||':'||g_session.app_alias 
                                    ,i_module_type => 'APEX_APP'); 
        --store something in the node eg module_id
 
         --Create App node 
          add_node( i_apex_context_id   => l_app_apex_context_id
                   ,i_apex_context_type => 'APP'
                   ,i_parent_context_id => l_session_apex_context_id
                   ,i_app_user          => g_session.app_user 
                   ,i_app_user_fullname => g_session.app_user_fullname 
                   ,i_app_user_email    => g_session.app_user_email 
                   ,i_app_session       => g_session.app_session
                   ,i_parent_app_session=> g_session.parent_app_session
                   ,i_app_id            => g_session.app_id 
                   ,i_app_alias         => g_session.app_alias
                   ,i_app_title         => g_session.app_title
                   ,i_created_date      => g_session.created_date  );   
 
      end if;
 
      --Set the actual apex context for every sm_session to the page apex_context
      g_session.apex_context_id := get_apex_context_id(i_app_page_id => g_session.app_page_id);

      if g_session.apex_context_id is null then
        --Create the apex conext ID
        g_session.apex_context_id := 'P'||g_session.session_id
                                   ||'_'||g_session.app_session
                                   ||'_'||g_session.app_id
                                   ||'_'||g_session.app_page_id;
    
        $if $$intlog $then intlog_debug('Page not found');   $end
 
        --Delete node 3
        $if $$intlog $then intlog_debug('Delete Page node');   $end
        delete_nodes(i_keep_count => 2);

        --get a registered unit or register this one
        l_node.unit := find_unit(i_module_id   => l_node.module.module_id
                                ,i_unit_name   => g_session.app_page_id||':'||g_session.app_page_alias 
                                ,i_unit_type   => 'APEX_PAGE');
        --store something in the node eg unit_id
        --Make sure this plays a part in waking the logger.
 
        --Create App Page node
          add_node( i_apex_context_id   => g_session.apex_context_id
                   ,i_apex_context_type => 'PAGE'
                   ,i_parent_context_id => l_app_apex_context_id
                   ,i_app_user          => g_session.app_user 
                   ,i_app_user_fullname => g_session.app_user_fullname 
                   ,i_app_user_email    => g_session.app_user_email 
                   ,i_app_session       => g_session.app_session
                   ,i_parent_app_session=> g_session.parent_app_session
                   ,i_app_id            => g_session.app_id 
                   ,i_app_alias         => g_session.app_alias
                   ,i_app_title         => g_session.app_title     
                   ,i_app_page_id       => g_session.app_page_id   
                   ,i_app_page_alias    => g_session.app_page_alias
                   ,i_created_date      => g_session.created_date );
 
      end if;
   end if;

   $if $$intlog $then intlog_end('construct_apex_context'); $end
end construct_apex_context;


------------------------------------------------------------------------
-- write_apex_context (private)
-- Write any new context records to the context table
------------------------------------------------------------------------
procedure write_apex_context  is
 
  l_apex_context SM_APEX_CONTEXT%ROWTYPE;

  cursor cu_get_node is
    select *
    from  sm_apex_context_collection_v;
 
BEGIN
  $if $$intlog $then intlog_start('write_apex_context'); $end
  open cu_get_node;
  loop 
    fetch cu_get_node into l_apex_context;
    exit when cu_get_node%notfound;

    begin
      insert into SM_APEX_CONTEXT values l_apex_context;
    exception
      when dup_val_on_index then
        null;  
    end;

  end loop;

  
  --Update the app_user on any existing context still showing nobody.
  update SM_APEX_CONTEXT
    set app_user = g_session.app_user
  where app_session = g_session.app_session
  and   LOWER(app_user) = 'nobody';
 
  $if $$intlog $then intlog_end('write_apex_context'); $end

END write_apex_context;
 
 
------------------------------------------------------------------------
-- log_session (private)
-- Write the session to the database
------------------------------------------------------------------------
PROCEDURE log_session is 

  PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN
    $if $$intlog $then intlog_start('log_session'); $end
    --$if $$intlog $then intlog_note('i_origin  ',i_origin   );   $end
    --$if $$intlog $then intlog_note('i_ext_ref ',i_ext_ref  );   $end
    --$if $$intlog $then intlog_note('i_comments',i_comments );   $end
 
    --Set the session_id
    g_session.session_id := sm_session_seq.NEXTVAL;
	  $if $$intlog $then intlog_note('g_session.session_id',g_session.session_id);           $end

    construct_apex_context;

    write_apex_context;
 
    --insert a new logger session
    INSERT INTO sm_session VALUES g_session;
 
    COMMIT;
 
  	$if $$intlog $then intlog_end('log_session'); $end

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_session');
    
END log_session;


------------------------------------------------------------------------
-- Message operations (private)
------------------------------------------------------------------------


------------------------------------------------------------------------
-- push_message
------------------------------------------------------------------------
PROCEDURE push_message(io_messages  IN OUT NOCOPY message_list
                      ,i_message    IN            sm_message%ROWTYPE ) IS
  l_next_index               BINARY_INTEGER;    
 
BEGIN
 
  $if $$intlog $then intlog_start('push_message');   $end

  IF io_messages.count > G_MAX_UNLOGGED_MSG_COUNT then
    $if $$intlog $then intlog_note('io_messages.count',io_messages.count);   $end
    $if $$intlog $then intlog_debug('TOO MANY MESSAGES');   $end
    --G_MAX_UNLOGGED_MSG_COUNT protects again excessive memory use
    --Must remove a message before we can add another
    declare
      l_non_param_index BINARY_INTEGER;    
    BEGIN
      --Find the first message that is not a parameter
      --(Assumes will be less than 100 params in a routine)
      l_non_param_index := io_messages.first;
      while io_messages( l_non_param_index ).MSG_TYPE = G_MSG_TYPE_PARAM LOOP
        l_non_param_index := io_messages.next( l_non_param_index );
      END LOOP;
      --Delete it.
      $if $$intlog $then intlog_note('l_non_param_index  ',l_non_param_index   );   $end
      io_messages.delete( l_non_param_index );
    END;

  END IF;  
 
  --Next index is last index + 1
  l_next_index := NVL(io_messages.LAST,0) + 1;
  $if $$intlog $then intlog_note('l_next_index  ',l_next_index   );   $end
  
  --add to the stack             
  io_messages( l_next_index ) := i_message;

  $if $$intlog $then intlog_end('push_message');   $end

END;



------------------------------------------------------------------------
-- log_message
------------------------------------------------------------------------
 
FUNCTION log_message(i_message  IN sm_message%ROWTYPE
                    ,i_node     IN sm_logger.node_typ) RETURN BOOLEAN IS
    PRAGMA AUTONOMOUS_TRANSACTION;

  l_message        sm_message%ROWTYPE := i_message;
  l_logged_message BOOLEAN := FALSE;
BEGIN
  $if $$intlog $then intlog_start('log_message'); $end
  l_message.message_id := new_message_id;
  
  $if $$intlog $then intlog_note('l_message.msg_level',l_message.msg_level);  $end
  $if $$intlog $then intlog_note('i_node.call.msg_mode'    ,i_node.call.msg_mode);      $end
 
  IF i_node.logged AND 
     l_message.msg_level >= i_node.call.msg_mode THEN
     --Node is logged and the message's msg_level is at least as great as node's msg_mode
     $if $$intlog $then intlog_debug('Loggable, so log it.' );        $end
 
     l_message.message_id   := new_message_id;
     l_message.call_id := i_node.call.call_id;
 
     $if $$intlog $then intlog_note('message_id  ',l_message.message_id  ); $end
     $if $$intlog $then intlog_note('call_id'    ,l_message.call_id); $end
     $if $$intlog $then intlog_note('name        ',l_message.name        ); $end
	   $if $$intlog $then intlog_note('value       ',l_message.value        ); $end
     $if $$intlog $then intlog_note('message     ',l_message.message     ); $end
     $if $$intlog $then intlog_note('msg_type    ',l_message.msg_type    ); $end
     $if $$intlog $then intlog_note('msg_level   ',l_message.msg_level   ); $end
     $if $$intlog $then intlog_note('time_now    ',l_message.time_now   ); $end
    
     INSERT INTO sm_message VALUES l_message;

     l_logged_message := TRUE;
  
  END IF;
 
  COMMIT;
 
  $if $$intlog $then intlog_end('log_message'); $end

  RETURN l_logged_message;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_message');
    RETURN FALSE;
END;


------------------------------------------------------------------------
-- create_message
------------------------------------------------------------------------

PROCEDURE create_message ( i_name      IN VARCHAR2 DEFAULT NULL
                          ,i_value     IN VARCHAR2 DEFAULT NULL
                          ,i_message   IN CLOB     DEFAULT NULL
                          ,i_msg_type  IN VARCHAR2
                          ,i_msg_level IN INTEGER
                          ,i_node      IN sm_logger.node_typ ) IS
 
  l_message sm_message%ROWTYPE;

BEGIN
  $if $$intlog $then intlog_start('create_message'); $end
  IF     g_session.internal_error  = 'N' and 
     NOT i_node.call.msg_mode = G_MSG_MODE_DISABLED THEN 
 
      --sm_logger passes node as origin of message  
      synch_node_stack( i_node => i_node);

      l_message.message_id   := NULL; 
      l_message.call_id      := NULL;         
      l_message.name         := SUBSTR(i_name ,1,G_REF_NAME_WIDTH);
      l_message.value        := SUBSTR(i_value ,1,G_REF_VALUE_WIDTH);
      l_message.message      := i_message;
      l_message.msg_type     := i_msg_type; 
      l_message.msg_level    := i_msg_level; 
      l_message.time_now     := SYSTIMESTAMP;

      IF l_message.msg_level >= G_MSG_LEVEL_FATAL THEN -- message is fatal or worse
         --log all unlogged calls using debug mode
         dump_nodes(i_index    => f_index
                   ,i_msg_mode => G_MSG_MODE_DEBUG);
      END IF;

      IF log_message(i_message => l_message
                    ,i_node    => g_nodes(f_index)) THEN
        --logged it, don't need to push it
        NULL;
      ELSE
        --Not currently loggable.
        $if $$intlog $then intlog_debug('Not yet loggable, so push it.' );        $end
        --Node is unlogged or not set to low enough message mode, yet..
        --push onto unlogged messages
        push_message(io_messages     => g_nodes(f_index).unlogged_messages 
                    ,i_message       => l_message); 
 
      END IF;   
     

  END IF;   
  $if $$intlog $then intlog_end('create_message'); $end
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('create_message');

END create_message;


------------------------------------------------------------------------
-- log_node
------------------------------------------------------------------------

PROCEDURE log_node(io_node        IN OUT node_typ
                  ,i_parent_index IN INTEGER) IS
--Log call or update it if already logged.
--Log any unlogged refs.

  l_message_index     BINARY_INTEGER;
  l_del_message_index BINARY_INTEGER;

  x_too_deeply_nested   EXCEPTION;
  x_logger_asleep       EXCEPTION;
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_logged BOOLEAN;
 
BEGIN
  $if $$intlog $then intlog_start('log_node'); $end
  $if $$intlog $then intlog_note('unit_name          ',io_node.unit.unit_name  );              $end
  $if $$intlog $then intlog_note('i_parent_index     ',i_parent_index );              $end
  
  IF f_index > G_MAX_NESTED_NODES THEN
    RAISE x_too_deeply_nested;
  END IF;
 
  --Logger must be awake
  IF f_logger_is_asleep then
     raise x_logger_asleep;
  end if;

  --Ensure the current cached process has been logged.
  If f_logger_is_quiet then
    --Process is cached, but not logged.
    --Time to log the process.
    $if $$intlog $then intlog_debug('Log the process'); $end
    --??if the procedure stack is empty then we'll start a new process
    --PAB - doesn't seem to work like this anymore - but maybe it should.
    log_session;
  END IF;

  --Now that we can re-log a node, need to test if already logged.
  IF io_node.logged THEN
    $if $$intlog $then intlog_debug('Re-logging a Node'); $end
    $if $$intlog $then intlog_note('module_name        ',io_node.module.module_name );           $end
    $if $$intlog $then intlog_note('unit_name          ',io_node.unit.unit_name  );              $end
    $if $$intlog $then intlog_note('call_id       '     ,io_node.call.call_id       ); $end
    $if $$intlog $then intlog_note('unit_id            ',io_node.call.unit_id);             $end
    $if $$intlog $then intlog_note('parent_call_id'     ,io_node.call.parent_call_id); $end
    $if $$intlog $then intlog_note('session_id         ',io_node.call.session_id         ); $end
    $if $$intlog $then intlog_note('msg_mode           ',io_node.call.msg_mode);            $end

 
    UPDATE sm_call 
    SET ROW = io_node.call
    WHERE call_id = io_node.call.call_id;	
  
  ELSE
    $if $$intlog $then intlog_debug('Log a node first time'); $end
    --fill in the NULLs
    io_node.call.call_id        := new_call_id; 
    io_node.call.parent_call_id := g_nodes(i_parent_index).call.call_id; 
    io_node.call.session_id          := g_session.session_id;
    
    $if $$intlog $then intlog_note('module_name        ',io_node.module.module_name );           $end
    $if $$intlog $then intlog_note('unit_name          ',io_node.unit.unit_name  );              $end
    $if $$intlog $then intlog_note('call_id       '     ,io_node.call.call_id       ); $end
    $if $$intlog $then intlog_note('unit_id            ',io_node.call.unit_id);             $end
    $if $$intlog $then intlog_note('parent_call_id'     ,io_node.call.parent_call_id); $end
    $if $$intlog $then intlog_note('session_id         ',io_node.call.session_id         ); $end
    $if $$intlog $then intlog_note('msg_mode           ',io_node.call.msg_mode);            $end

    INSERT INTO sm_call VALUES io_node.call; 
  	io_node.logged := TRUE;
	
  END IF;
  
  COMMIT;  --commit prior to logging messages
 
  --Loop thru any unlogged messages, attempting to log each.  
  --if successful, then remove message from the list.
  l_message_index := io_node.unlogged_messages.FIRST;
  WHILE l_message_index IS NOT NULL LOOP
    $if $$intlog $then intlog_note('l_message_index',l_message_index);            $end
    
    IF log_message(i_message => io_node.unlogged_messages(l_message_index)
                  ,i_node    => io_node) THEN
      l_del_message_index := l_message_index;                             --remember message to delete
      l_message_index := io_node.unlogged_messages.NEXT(l_message_index); --next unlogged message 
      --Logged so now we can delete this message from the unlogged list.
      io_node.unlogged_messages.DELETE(l_del_message_index);
    ELSE
      l_message_index := io_node.unlogged_messages.NEXT(l_message_index); --next unlogged message
  END IF;
  
  END LOOP;
  
  $if $$intlog $then intlog_end('log_node'); $end
  
EXCEPTION
  WHEN x_logger_asleep THEN
    ROLLBACK;
    err_raise_internal_error(i_prog_unit => 'log_node'
                            ,i_message   => 'Logger is still asleep.  State should not occur.');
  WHEN x_too_deeply_nested THEN
    ROLLBACK;
    err_raise_internal_error(i_prog_unit => 'log_node'
                            ,i_message   => 'exceeded ' ||G_MAX_NESTED_NODES||' nested nodes.');
	  $if $$intlog $then intlog_end('log_node');  $end                   
  WHEN OTHERS THEN
    ROLLBACK;
    err_warn_oracle_error('log_node');
 
 
END log_node; 

------------------------------------------------------------------------

PROCEDURE dump_nodes(i_index    IN BINARY_INTEGER
                    ,i_msg_mode IN NUMBER)IS
 
  --Log calls (using the given msg_mode) that have not yet been logged,
  --or were logged at a higher msg_mode.
  --search back recursively to first logged call, at an equal msg_mode
  --log_node will update node with the new msg_mode
  --and log any remaining unlogged messages

  l_call_index BINARY_INTEGER;
BEGIN
  $if $$intlog $then intlog_start('dump_nodes'); $end
  $if $$intlog $then intlog_note('i_index'   ,i_index);     $end
  $if $$intlog $then intlog_note('i_msg_mode',i_msg_mode);  $end
 
  IF i_index > 0 AND ( 
          NOT g_nodes(i_index).logged 
	        OR  g_nodes(i_index).call.msg_mode > i_msg_mode)  THEN
    --dump any previous calls too
    dump_nodes(i_index    => g_nodes.PRIOR(i_index)
              ,i_msg_mode => i_msg_mode);
  
    g_nodes(i_index).call.msg_mode := i_msg_mode;
    log_node(io_node        => g_nodes(i_index)
            ,i_parent_index => g_nodes.PRIOR(i_index));
  END IF;
  $if $$intlog $then intlog_end('dump_nodes'); $end
 
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('dump_nodes');
END;

 
 
------------------------------------------------------------------------
-- call operations (private)
------------------------------------------------------------------------

------------------------------------------------------------------------
-- f_wake_logger (private)
-- The logger is either ASLEEP or AWAKE.
--  ASLEEP - When the logger package is initialised, it is ASLEEP
--  AWAKE  - When the logger encounters a node that may wake it, it will become AWAKE
-- Wake the logger, if allowed, and then return wake status.
-- (The logger will remain awake for the remainder of the session.)
------------------------------------------------------------------------

FUNCTION f_wake_logger(io_node IN OUT sm_logger.node_typ) RETURN BOOLEAN is
BEGIN
  --Open a new process 
  --  A If this unit always wakes the logger
  --    this is an atypical mode.  opens a new process, even if already awake.
  --  B If this unit may wake the logger, and the logger is asleep.

  IF  io_node.auto_wake = G_AUTO_WAKE_FORCE    OR   
     (io_node.auto_wake = G_AUTO_WAKE_YES AND f_logger_is_asleep) THEN
    --Exclude disabled nodes too.
    IF io_node.call.msg_mode <> G_MSG_MODE_DISABLED THEN
      $if $$intlog $then intlog_debug('Wake the logger'); $end
      create_session(io_node => io_node);
    END IF;
  END IF;

  return f_logger_is_awake;
 
END;  


PROCEDURE create_call(io_node     IN OUT sm_logger.node_typ ) IS
 
  x_internal_error    EXCEPTION;
  x_node_disabled     EXCEPTION;
  x_logger_asleep     EXCEPTION;

BEGIN
  $if $$intlog $then intlog_start('create_call'); $end
  $if $$intlog $then intlog_note('io_node.unit.unit_name',io_node.unit.unit_name); $end
  
 
  --Messages and references, in the SCOPE of this call, will be stored.
  io_node.call.call_id        := NULL;
  io_node.call.session_id          := NULL;
  io_node.call.unit_id             := io_node.unit.unit_id;
  io_node.call.parent_call_id := NULL;

  if g_logger_msg_mode is null then
    --AUTO
    --unit override module, unless null
    io_node.auto_wake                     := NVL(io_node.unit.auto_wake     ,io_node.module.auto_wake);  
    io_node.call.msg_mode            := NVL(io_node.unit.auto_msg_mode ,io_node.module.auto_msg_mode); 
       
  ELSE
    --MANUAL
    $if $$intlog $then intlog_debug('Manually set to wakeup, if asleep.'); $end
    io_node.auto_wake                     := G_AUTO_WAKE_YES;
    --unit has precedence over module, module has precedence over g_logger_msg_mode
    io_node.call.msg_mode            := COALESCE(io_node.unit.manual_msg_mode ,io_node.module.manual_msg_mode ,g_logger_msg_mode); 
    
  end if;  
 
  io_node.logged                        := FALSE;
  --DEPRECATED io_node.internal_error                := f_internal_error; g_session.internal_error = 'Y';
 
  --Use the call stack to remove any nodes from the stack that are not ancestors
  --This may put the logger to sleep.
  pop_to_parent_node(i_node => io_node);
 
  if NOT f_wake_logger(io_node => io_node) then
    raise x_logger_asleep;
  end if;

  IF f_internal_error then 
    raise x_internal_error;
  END IF;  
 
  IF io_node.call.msg_mode = G_MSG_MODE_DISABLED THEN  
    raise x_node_disabled;
  END IF;
 
  IF io_node.call.msg_mode IN (G_MSG_MODE_DEBUG, G_MSG_MODE_NORMAL)  THEN 
    --Log this node, but first log any ancestors that are not yet logged.
    --There may be cached nodes that are not yet logged.
    --Since this may be the first loggable node we've encountered since waking up,
    --need see if there are other nodes already encountered that were cached but not logged.
    --These will be any previous nodes that were set to Quiet Mode.
    --dump any unlogged calls in QUIET MODE
    dump_nodes(i_index    => f_index
              ,i_msg_mode => G_MSG_MODE_QUIET);
    --log the call and push it on the call stack
    log_node(io_node        => io_node
            ,i_parent_index => f_index);
  
  END IF;
    
  --Cache the call - may or may not already have been logged.
  --push the call onto the stack
  push_node(io_node  => io_node);
 
  io_node.node_level := f_index; 
 
  $if $$intlog $then intlog_end('create_call'); $end
  
EXCEPTION
  WHEN x_internal_error THEN
      -- internal error state, and not starting a new process yet
      $if $$intlog $then intlog_debug('SmartLogger inactive'); $end
      NULL;
  WHEN x_node_disabled THEN
      -- create disabled nodes, but don't log or cache them
      $if $$intlog $then intlog_debug('Disabled node'); $end
      NULL;

  WHEN x_logger_asleep THEN
      -- Logger still asleep - no need to log or cache
      $if $$intlog $then intlog_debug('Logger is Asleep'); $end
      NULL ;

  WHEN OTHERS THEN
    err_warn_oracle_error('create_call');
 
END create_call;



------------------------------------------------------------------------
-- Node Typ API functions (Private)
------------------------------------------------------------------------

FUNCTION new_node(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
                 ,i_unit_type   IN VARCHAR2
                 ,i_msg_mode    in integer  default null
                 ,i_disabled    in boolean  default false
                 ,i_debug       in boolean  default false
                 ,i_normal      in boolean  default false
                 ,i_quiet       in boolean  default false) RETURN sm_logger.node_typ IS
         
  --When upgraded to 12C may not need to pass any params      
  --In 11g i use function dbms_utility.format_call_stack   
  --12C includes new package UTL_CALL_STACK
 
  --must work in SILENT MODE, incase somebody write logic on the app side that depends
  --on l_node                
  l_node sm_logger.node_typ;  
  
  l_module_name sm_module.module_name%TYPE := LTRIM(RTRIM(SUBSTR(i_module_name,1,G_MODULE_NAME_WIDTH)));
  l_unit_name   sm_unit.unit_name%TYPE     := LTRIM(RTRIM(SUBSTR(i_unit_name  ,1,G_UNIT_NAME_WIDTH)));  
  
  FUNCTION f_call_stack_level RETURN NUMBER IS
    l_lines   APEX_APPLICATION_GLOBAL.VC_ARR2;
  BEGIN
    --Indicative only. Absolute value doesn't matter so much, used for comparison only.
    l_lines := APEX_UTIL.STRING_TO_TABLE(dbms_utility.format_call_stack,chr(10));
   
    return l_lines.count;
     
  END;   
  
  FUNCTION f_call_stack_hist RETURN CLOB IS
    l_lines   APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_call_stack_hist CLOB;
    l_grand_parent_index integer := 9;
  BEGIN
    --Indicative only. Absolute value doesn't matter so much, used for comparison only.
    l_lines := APEX_UTIL.STRING_TO_TABLE(dbms_utility.format_call_stack,chr(10));
  
    --Of these lines ignore the first 4 which are just headings, and
    --the next 2 which are the logger itself.
  --the next line is also not useful as it represents the line number in the current node
  --and unfortunately the next is not so useful either since it is the calling line number from the parent prog_unit, 
  --will differ in other calls from the same prog_unit
    --But whatever is left may be useful...  
  --Next line is the calling line number from the grand-parent prog_unit which is somewhat useful in determining parentage.
  
  FOR l_index IN l_grand_parent_index..l_lines.count LOOP 
    --UNFORMATTED
    --l_call_stack_hist := ltrim(l_call_stack_hist || chr(10) || l_lines(l_index), chr(10));
    
    --FORMATTED
    --Remove description and format unit id and line number for the history.
    l_call_stack_hist := ltrim(l_call_stack_hist || chr(10) || REGEXP_REPLACE(SUBSTR(l_lines(l_index),1,20),'(\w+)\s+?(\w+)','\1:\2'), chr(10));
    END LOOP;
   
    return l_call_stack_hist;
     
  END;  
 

  FUNCTION f_call_stack_parent RETURN varchar2 IS
    l_lines   APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_parent_index integer := 8;
  BEGIN
    --Separate the call stack into lines
    l_lines := APEX_UTIL.STRING_TO_TABLE(dbms_utility.format_call_stack,chr(10));
   
    return LOWER(REGEXP_SUBSTR(l_lines(l_parent_index),'\w*$')); 
     
  END;   
 
BEGIN

 
  g_logger_msg_mode := case 
                         when i_disabled then G_MSG_MODE_DISABLED
                         when i_debug    then G_MSG_MODE_DEBUG
                         when i_normal   then G_MSG_MODE_NORMAL
                         when i_quiet    then G_MSG_MODE_QUIET
                         when i_msg_mode is not null then i_msg_mode
                         ELSE g_logger_msg_mode
                        end;
 
  $if $$intlog $then intlog_note('g_logger_msg_mode',g_logger_msg_mode); $end

  --get a registered module or register this one
  l_node.module := find_module(i_module_name => i_module_name
                              ,i_unit_name   => i_unit_name); 

  --get a registered unit or register this one
  l_node.unit := find_unit(i_module_id   => l_node.module.module_id
                          ,i_unit_name   => i_unit_name  
                          ,i_unit_type   => i_unit_type);


  l_node.call_stack_level := f_call_stack_level; --simplify after 12C with additional functions
  l_node.call_stack_hist  := f_call_stack_hist;
  l_node.call_stack_parent  := f_call_stack_parent;
 
  create_call(io_node => l_node);
 
  RETURN l_node;
  
END;




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
--f_dba_source
--returns user_source record from user_source table
--------------------------------------------------------------------

FUNCTION f_dba_source( i_owner   IN   VARCHAR2
                       ,i_name   IN   VARCHAR2
                       ,i_type   IN   VARCHAR2
                       ,i_line   IN   NUMBER)
  RETURN dba_source%ROWTYPE IS
  CURSOR cu_dba_source(
    c_owner  VARCHAR2
   ,c_name   VARCHAR2
   ,c_type   VARCHAR2
   ,c_line   NUMBER) IS
    SELECT *
      FROM dba_source
     WHERE OWNER = c_owner
       AND NAME = c_name
       AND TYPE = c_type
       AND line = c_line;

  l_result   dba_source%ROWTYPE;
BEGIN
  OPEN cu_dba_source(c_owner => i_owner 
                    , c_name  => i_name
                    , c_type  => i_type
                    , c_line  => i_line);

  FETCH cu_dba_source
   INTO l_result;

  CLOSE cu_dba_source;

  RETURN l_result;
END f_dba_source;

--------------------------------------------------------------------
--warn_user_source_error_lines
--write user source lines as warnings.
--------------------------------------------------------------------
 

PROCEDURE warn_user_source_error_lines( i_node       IN sm_logger.node_typ
                                       ,i_prev_lines IN NUMBER
                                       ,i_post_lines IN NUMBER) IS
                                  
  l_backtrace VARCHAR2(32000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;  
  
  --Eg 'ORA-06512: at "ALESCO.UT_RULE_PKG", line 502'
  
  l_package_name VARCHAR2(100);
  l_error_line   NUMBER;

  l_result       VARCHAR2(4000);
  l_dba_source  dba_source%ROWTYPE;
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
  
    l_dba_source := f_dba_source(  i_owner => USER
	                               ,i_name => l_package_name
                                   ,i_type => 'PACKAGE BODY'
                                   ,i_line => l_line);
 
    --Write the source line to a message in the format "LINE NO"  X  TEXT
    --Highlight the error line as a WARNING, lines above and below as COMMENT
 
    create_message ( i_name      => 'LINE NO'
                    ,i_value     => l_line
                    ,i_message   => RTRIM(l_dba_source.text,chr(10))
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => CASE 
                                      WHEN l_line = l_error_line THEN G_MSG_LEVEL_WARNING
                                      ELSE                            G_MSG_LEVEL_COMMENT
                                    END 
                    ,i_node      => i_node);
 
  END LOOP;
 
 
EXCEPTION
  WHEN OTHERS THEN
    NULL;
 
END;
 

------------------------------------------------------------------------
-- debug_error - PRIVATE
------------------------------------------------------------------------

PROCEDURE debug_error( i_node            IN sm_logger.node_typ 
                      ,i_message         IN CLOB DEFAULT NULL
                      ,i_msg_level       IN INTEGER )
IS
BEGIN
 

  create_message ( i_message   => LTRIM(i_message ||' '||SQLERRM
                                ||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE )--show the original error line number
                  ,i_msg_type  => G_MSG_TYPE_MESSAGE
                  ,i_msg_level => i_msg_level
			  ,i_node     => i_node );
 
END debug_error;



 
------------------------------------------------------------------------
-- ROUTINES (Public)
------------------------------------------------------------------------
 
 
----------------------------------------------------------------------------
-- create_ref -  now merely calls create_message
----------------------------------------------------------------------------
 
 
PROCEDURE create_ref ( i_name      IN VARCHAR2
                      ,i_value     IN CLOB
                      ,i_descr     IN CLOB     default null
                      ,i_msg_type  IN VARCHAR2
                      ,i_node      IN sm_logger.node_typ ) IS

BEGIN
  $if $$intlog $then intlog_start('create_ref'); $end

    IF LENGTH(i_value) <= G_REF_VALUE_WIDTH and INSTR(i_value,chr(10))= 0 THEN
      --Short, single line value, so just put it in the value column
      create_message ( i_name      => i_name
                      ,i_value     => i_value
                      ,i_message   => i_descr
                      ,i_msg_type  => i_msg_type
                      ,i_msg_level => G_MSG_LEVEL_COMMENT
	                    ,i_node      => i_node);      
 
    ELSE
      --Longer or multi-line value, put it in the message column
      create_message ( i_name      => i_name
                      ,i_message   => i_value
                      ,i_msg_type  => i_msg_type
                      ,i_msg_level => G_MSG_LEVEL_COMMENT
                      ,i_node      => i_node);
      END IF;   

  $if $$intlog $then intlog_end('create_ref'); $end

END create_ref;





------------------------------------------------------------------------
-- Message Mode operations (private)
------------------------------------------------------------------------
 
PROCEDURE  set_module_msg_mode(i_module_id   IN NUMBER
                              ,i_msg_mode IN NUMBER )
IS
  pragma autonomous_transaction;
BEGIN
  $if $$intlog $then intlog_start('set_module_msg_mode');    $end
  $if $$intlog $then intlog_note('i_module_id',i_module_id);   $end
  $if $$intlog $then intlog_note('i_msg_mode',i_msg_mode); $end

  UPDATE sm_module
  SET    auto_msg_mode  = i_msg_mode
  WHERE  module_id = i_module_id;

  COMMIT;
  $if $$intlog $then intlog_end('set_module_msg_mode'); $end
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      err_warn_oracle_error('set_module_msg_mode');
END;

 
PROCEDURE  set_module_auto_wake(i_module_id IN NUMBER
                               ,i_auto_wake IN VARCHAR2 )
IS
  pragma autonomous_transaction;
BEGIN
  $if $$intlog $then intlog_start('set_module_auto_wake'); $end
  $if $$intlog $then intlog_note('i_module_id',i_module_id);   $end
  $if $$intlog $then intlog_note('i_auto_wake',i_auto_wake);     $end

  UPDATE sm_module
  SET    auto_wake  = i_auto_wake
  WHERE  module_id = i_module_id;

  COMMIT;
  $if $$intlog $then intlog_end('set_module_auto_wake'); $end
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      err_warn_oracle_error('set_module_auto_wake');
END;
 

PROCEDURE  set_unit_msg_mode(i_unit_id   IN NUMBER
                            ,i_msg_mode IN NUMBER )
IS
  pragma autonomous_transaction;
BEGIN
  $if $$intlog $then intlog_start('set_unit_msg_mode');    $end
  $if $$intlog $then intlog_note('i_unit_id',i_unit_id);   $end
  $if $$intlog $then intlog_note('i_msg_mode',i_msg_mode); $end

  UPDATE sm_unit
  SET    auto_msg_mode  = i_msg_mode
  WHERE  unit_id   = i_unit_id;

  COMMIT;
  $if $$intlog $then intlog_end('set_unit_msg_mode'); $end
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      err_warn_oracle_error('set_unit_msg_mode');
END;


PROCEDURE  set_unit_auto_wake(i_unit_id IN NUMBER
                               ,i_auto_wake IN VARCHAR2 )
IS
  pragma autonomous_transaction;
BEGIN
  $if $$intlog $then intlog_start('set_unit_auto_wake'); $end
  $if $$intlog $then intlog_note('i_unit_id',i_unit_id);   $end
  $if $$intlog $then intlog_note('i_auto_wake',i_auto_wake);     $end

  UPDATE sm_unit
  SET    auto_wake  = i_auto_wake
  WHERE  unit_id = i_unit_id;

  COMMIT;
  $if $$intlog $then intlog_end('set_unit_auto_wake'); $end
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      err_warn_oracle_error('set_unit_auto_wake');
END;

------------------------------------------------------------------------
-- Message Mode operations (exposed for ms_api only)
------------------------------------------------------------------------
 
  
PROCEDURE  set_module_msg_mode(i_module_name IN VARCHAR2
                              ,i_msg_mode   IN NUMBER ) IS
                             
BEGIN


  set_module_msg_mode(i_module_id  => find_module(i_module_name => i_module_name
                                                 ,i_create      => TRUE).module_id
                     ,i_msg_mode => i_msg_mode);
 
END; 

PROCEDURE  set_module_auto_wake(i_module_name IN VARCHAR2
                              ,i_auto_wake    IN VARCHAR2 ) IS
                             
BEGIN


  set_module_auto_wake(i_module_id  => find_module(i_module_name => i_module_name
                                                 ,i_create      => TRUE).module_id
                      ,i_auto_wake => i_auto_wake);
 
END; 





------------------------------------------------------------------------
  
PROCEDURE  set_unit_msg_mode(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2
                            ,i_msg_mode   IN NUMBER ) IS
                             
BEGIN


  set_unit_msg_mode(i_unit_id  => find_unit(i_module_name => i_module_name
                                           ,i_unit_name   => i_unit_name
                                           ,i_create      => FALSE).unit_id
                                           ,i_msg_mode    => i_msg_mode);
 
END; 

PROCEDURE  set_unit_auto_wake(i_module_name IN VARCHAR2
                             ,i_unit_name   IN VARCHAR2
                             ,i_auto_wake   IN VARCHAR2 ) IS
                             
BEGIN


  set_unit_auto_wake(i_unit_id  => find_unit(i_module_name => i_module_name
                                           ,i_unit_name   => i_unit_name
                                           ,i_create      => FALSE).unit_id
                                           ,i_auto_wake    => i_auto_wake);
 
END; 


PROCEDURE  set_logger_msg_mode(i_msg_mode   IN NUMBER ) IS
                             
BEGIN
  --Setting to other than G_MSG_MODE_OVERRIDDEN (null), implies the Logger will WAKE NOW.
  g_logger_msg_mode := i_msg_mode;
 
END; 


PROCEDURE  wake_logger(i_node      IN node_typ
                      ,i_msg_mode  IN NUMBER DEFAULT G_MSG_MODE_DEBUG) IS
                             
BEGIN

  set_logger_msg_mode(i_msg_mode => i_msg_mode);
 
END; 

 


------------------------------------------------------------------------
PROCEDURE test_internal_error(i_node IN node_typ) IS
--Facilitates testing of the internal error handling
BEGIN
  $if $$intlog $then intlog_start('test_internal_error');           $end
  $if $$intlog $then intlog_debug('About to raise an error to test handling');           $end
  raise no_data_found;
 
  $if $$intlog $then intlog_end('test_internal_error'); $end
 
EXCEPTION

  WHEN OTHERS THEN
    err_warn_oracle_error('test_internal_error');
END; 



------------------------------------------------------------------------
 
 PROCEDURE reset_sequence(i_sequence_name IN VARCHAR2
                         ,i_new_value     IN INTEGER  DEFAULT 0) IS
   PRAGMA AUTONOMOUS_TRANSACTION;	
   l_increment      INTEGER;   
   
   
   FUNCTION get_next_seq RETURN INTEGER IS
     l_next_val       INTEGER;
   BEGIN
     execute immediate 'select '||i_sequence_name||'.nextval into :l_next_val from dual' using out l_next_val;
	 RETURN l_next_val;
   END;
   
   
 BEGIN						 
     --RESET sequence back to i_new_value
    l_increment := i_new_value - get_next_seq - 1;
    --use increment by to reverse the sequence back to i_new_value
    execute immediate 'alter sequence '||i_sequence_name||' increment by ' || l_increment ||' minvalue 0';
    l_increment := get_next_seq; --should now be i_new_value
    --set increment back to normal
    execute immediate 'alter sequence '||i_sequence_name||' increment by 1 minvalue 0';    
 END;
 
 

------------------------------------------------------------------------
-- Node ROUTINES (Public)
-- @TODO - Deprecated - remove from spec
-- This is only used in the beforepform logic for reports in SM_WEAVER.
-- Do i even want to support oracle reports anymore?
-- There may be a better way to do this. Like simply adding an l_node and 
-- interogating the node after creation.
-- There are also examples of this in the test scripts. 
------------------------------------------------------------------------
/*
 
FUNCTION new_process(i_process_name IN VARCHAR2 DEFAULT NULL
                    ,i_process_type IN VARCHAR2 DEFAULT NULL
                    ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                    ,i_module_name  IN VARCHAR2 DEFAULT NULL
                    ,i_unit_name    IN VARCHAR2 DEFAULT NULL
                    ,i_comments     IN VARCHAR2 DEFAULT NULL       ) RETURN INTEGER IS
 
  l_origin sm_session.origin%TYPE;
  l_module sm_module%rowtype;
  l_unit   sm_unit%rowtype;

BEGIN
    
  IF i_process_name IS NOT NULL THEN
    l_origin  := i_process_type ||' '||  i_process_name;
  END IF;


  IF i_module_name IS NOT NULL THEN
    l_module := get_module(i_module_name => i_module_name);
    l_origin := l_module.module_type||' '||i_module_name;
 
    IF i_unit_name IS NOT NULL THEN
      l_unit := get_unit(i_module_id => l_module.module_id
                        ,i_unit_name => i_unit_name);
      l_origin := SUBSTR(l_origin||':'||l_unit.unit_type||' '||i_unit_name,1,100);
    END IF;
  END IF;

  l_origin := NVL(TRIM(l_origin),'UNKNOWN ORIGIN');
 
  log_session(i_origin      => l_origin
             ,i_ext_ref      => i_ext_ref    
             ,i_comments     => i_comments);  
 
  RETURN g_session.session_id;
					
 		 
END;
*/  
 
  FUNCTION new_pkg(i_module_name IN VARCHAR2
                  ,i_unit_name   IN VARCHAR2 DEFAULT 'init_package'
                  ,i_debug       in boolean  default false
                  ,i_normal      in boolean  default false
                  ,i_quiet       in boolean  default false
                  ,i_disabled    in boolean  default false
                  ,i_msg_mode    in integer  default null) RETURN sm_logger.node_typ IS
 
  BEGIN
    
	RETURN sm_logger.new_node(i_module_name => i_module_name
                           ,i_unit_name   => i_unit_name
						            	 ,i_unit_type   => G_UNIT_TYPE_PACKAGE 
                           ,i_debug       => i_debug   
                           ,i_normal      => i_normal  
                           ,i_quiet       => i_quiet   
                           ,i_disabled    => i_disabled
                           ,i_msg_mode    => i_msg_mode
                           );
  END;
  
  
  FUNCTION new_proc(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2 
                   ,i_debug       in boolean  default false
                   ,i_normal      in boolean  default false
                   ,i_quiet       in boolean  default false
                   ,i_disabled    in boolean  default false
                   ,i_msg_mode    in integer  default null) RETURN sm_logger.node_typ IS
 
  BEGIN
    
	RETURN sm_logger.new_node(i_module_name => i_module_name
                           ,i_unit_name   => i_unit_name
							             ,i_unit_type   => G_UNIT_TYPE_PROCEDURE
                           ,i_debug       => i_debug   
                           ,i_normal      => i_normal  
                           ,i_quiet       => i_quiet   
                           ,i_disabled    => i_disabled
                           ,i_msg_mode    => i_msg_mode
                           );
 
  END;
  
  
  FUNCTION new_func(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2
                   ,i_debug       in boolean  default false
                   ,i_normal      in boolean  default false
                   ,i_quiet       in boolean  default false
                   ,i_disabled    in boolean  default false
                   ,i_msg_mode    in integer  default null ) RETURN sm_logger.node_typ IS
 
  BEGIN
    
	RETURN sm_logger.new_node(i_module_name => i_module_name
                           ,i_unit_name   => i_unit_name
							             ,i_unit_type   => G_UNIT_TYPE_FUNCTION
                           ,i_debug       => i_debug   
                           ,i_normal      => i_normal  
                           ,i_quiet       => i_quiet   
                           ,i_disabled    => i_disabled
                           ,i_msg_mode    => i_msg_mode
                           );
 
  END;
  
  FUNCTION new_trig(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2
                   ,i_debug       in boolean  default false
                   ,i_normal      in boolean  default false
                   ,i_quiet       in boolean  default false
                   ,i_disabled    in boolean  default false
                   ,i_msg_mode    in integer  default null) RETURN sm_logger.node_typ IS
 
  BEGIN
    
	RETURN sm_logger.new_node(i_module_name => i_module_name
                           ,i_unit_name   => i_unit_name
							             ,i_unit_type   => G_UNIT_TYPE_TRIGGER 
                           ,i_debug       => i_debug   
                           ,i_normal      => i_normal  
                           ,i_quiet       => i_quiet   
                           ,i_disabled    => i_disabled
                           ,i_msg_mode    => i_msg_mode
                           );
 
  END;
  
  
  FUNCTION new_script(i_module_name IN VARCHAR2
                     ,i_unit_name   IN VARCHAR2
                     ,i_debug       in boolean  default false
                     ,i_normal      in boolean  default false
                     ,i_quiet       in boolean  default false
                     ,i_disabled    in boolean  default false
                     ,i_msg_mode    in integer  default null ) RETURN sm_logger.node_typ IS
  
  BEGIN
    
   RETURN sm_logger.new_node(i_module_name => i_module_name
                            ,i_unit_name   => i_unit_name
                					  ,i_unit_type   => G_UNIT_TYPE_SCRIPT 
                            ,i_debug       => i_debug   
                            ,i_normal      => i_normal  
                            ,i_quiet       => i_quiet   
                            ,i_disabled    => i_disabled
                            ,i_msg_mode    => i_msg_mode
                            );
  
  END;
  
 
  
------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

------------------------------------------------------------------------ 
-- comment 
------------------------------------------------------------------------
PROCEDURE comment( i_node            IN sm_logger.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_COMMENT
	                ,i_node     => i_node);
 
END comment;

PROCEDURE debug( i_node            IN sm_logger.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_COMMENT
                    ,i_node     => i_node);
 
END debug;


------------------------------------------------------------------------
-- info 
------------------------------------------------------------------------
PROCEDURE info( i_node            IN sm_logger.node_typ 
               ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_INFO
                    ,i_node     => i_node);
 
END info;

PROCEDURE information( i_node            IN sm_logger.node_typ 
                      ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_INFO
                    ,i_node     => i_node);
 
END information;

------------------------------------------------------------------------
-- warning  
------------------------------------------------------------------------

PROCEDURE warning( i_node         IN sm_logger.node_typ 
                  ,i_message      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_WARNING
                    ,i_node     => i_node);
 
END warning;

PROCEDURE warn( i_node         IN sm_logger.node_typ 
                  ,i_message      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_WARNING
   ,i_node     => i_node);
 
END warn;

------------------------------------------------------------------------
-- fatal  
------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN     sm_logger.node_typ 
                ,i_message         IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_FATAL
   ,i_node     => i_node);
 
END fatal;  

------------------------------------------------------------------------ 
-- oracle_error 
------------------------------------------------------------------------

PROCEDURE oracle_error( i_node            IN sm_logger.node_typ 
                       ,i_message         IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN
 
  debug_error( i_node             => i_node     
              ,i_message          => i_message
              ,i_msg_level        => G_MSG_LEVEL_ORACLE );

 
  warn_user_source_error_lines(i_prev_lines => 5
                              ,i_post_lines => 5
                              ,i_node     => i_node);
  
 
END oracle_error;
 
------------------------------------------------------------------------
-- warn_error  
------------------------------------------------------------------------

PROCEDURE warn_error( i_node            IN sm_logger.node_typ 
                     ,i_message         IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN

  debug_error( i_node             => i_node     
              ,i_message          => i_message
              ,i_msg_level        => G_MSG_LEVEL_WARNING );


END warn_error;


------------------------------------------------------------------------
-- note_error  
------------------------------------------------------------------------

PROCEDURE note_error( i_node            IN sm_logger.node_typ 
                     ,i_message         IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN

  debug_error( i_node             => i_node     
              ,i_message          => i_message
              ,i_msg_level        => G_MSG_LEVEL_COMMENT );


END note_error;

 
------------------------------------------------------------------------
-- Reference ROUTINES (Public)
------------------------------------------------------------------------


--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN sm_logger.node_typ   
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => i_value
              ,i_descr      => i_descr
              ,i_msg_type   => G_MSG_TYPE_NOTE
              ,i_node       => i_node);      
 
END note   ;

 
------------------------------------------------------------------------

PROCEDURE param ( i_node      IN sm_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2  )
IS
BEGIN
  create_ref ( i_name      => i_name
              ,i_value     => i_value
              ,i_msg_type  => G_MSG_TYPE_PARAM
              ,i_node      => i_node
          );

END param;


--overloaded name, value | [id, descr] FOR CLOB
PROCEDURE note_clob( i_node      IN sm_logger.node_typ   
                    ,i_name      IN VARCHAR2
                    ,i_value     IN CLOB )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => i_value
              ,i_msg_type   => G_MSG_TYPE_NOTE
              ,i_node       => i_node);      
 
END note_clob   ;

 
------------------------------------------------------------------------

PROCEDURE param_clob( i_node      IN sm_logger.node_typ 
                     ,i_name      IN VARCHAR2
                     ,i_value     IN CLOB  )
IS
BEGIN
  create_ref ( i_name      => i_name
              ,i_value     => i_value
              ,i_msg_type  => G_MSG_TYPE_PARAM
              ,i_node      => i_node
          );

END param_clob;

------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_node      IN sm_logger.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => TO_CHAR(ROUND(i_num_value,15))
              ,i_msg_type   => G_MSG_TYPE_NOTE
              ,i_node       => i_node);

END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_node      IN sm_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER    )
IS

BEGIN
  create_ref ( i_name       => i_name
           ,i_value         => TO_CHAR(ROUND(i_num_value,15))
           ,i_msg_type      => G_MSG_TYPE_PARAM
           ,i_node          => i_node);

END param;




------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_node       IN sm_logger.node_typ 
                   ,i_name       IN VARCHAR2
                   ,i_date_value IN DATE )
IS

BEGIN
  IF i_date_value = TRUNC(i_date_value) THEN

    create_ref ( i_name       => i_name
                ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY')
                ,i_msg_type   => G_MSG_TYPE_NOTE
                ,i_node       => i_node);
  ELSE
    create_ref ( i_name       => i_name
                ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY HH24MI')
                ,i_msg_type   => G_MSG_TYPE_NOTE
                ,i_node       => i_node);

  END IF;

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_node       IN sm_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_date_value IN DATE   )
IS

BEGIN
  IF i_date_value = TRUNC(i_date_value) THEN

    create_ref ( i_name       => i_name
                ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY')
                ,i_msg_type   => G_MSG_TYPE_PARAM
                ,i_node       => i_node);
  ELSE
    create_ref ( i_name       => i_name
                ,i_value      => TO_CHAR(i_date_value,'DD-MON-YYYY HH24MI')
                ,i_msg_type   => G_MSG_TYPE_PARAM
                ,i_node       => i_node);

  END IF;

END param;

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_node      IN sm_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => f_true_false(i_bool_value)
              ,i_msg_type   => G_MSG_TYPE_NOTE
              ,i_node       => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN sm_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN )
IS

BEGIN
  create_ref ( i_name        => i_name
              ,i_value       => f_true_false(i_bool_value)
              ,i_msg_type    => G_MSG_TYPE_PARAM
              ,i_node        => i_node);

END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_node      IN sm_logger.node_typ 
                 ,i_name      IN VARCHAR2 )
IS
BEGIN
  create_ref(i_name       => i_name
            ,i_value      => TO_CHAR(NULL) 
            ,i_msg_type   => G_MSG_TYPE_NOTE
            ,i_node       => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN sm_logger.node_typ 
                        ,i_name      IN VARCHAR2 ) IS
BEGIN

      create_message ( i_name      => 'SQL%ROWCOUNT'
                      ,i_value     => SQL%ROWCOUNT
                      ,i_message   => i_name
                      ,i_msg_type  => G_MSG_TYPE_NOTE
                      ,i_msg_level => G_MSG_LEVEL_COMMENT
                      ,i_node      => i_node);
 
END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN sm_logger.node_typ 
                         ,i_name      IN VARCHAR2   ) RETURN NUMBER IS
  l_rowcount NUMBER := SQL%ROWCOUNT;
BEGIN
      create_message ( i_name      => 'SQL%ROWCOUNT'
                      ,i_value     => l_rowcount
                      ,i_message   => i_name
                      ,i_msg_type  => G_MSG_TYPE_NOTE
                      ,i_msg_level => G_MSG_LEVEL_COMMENT
                      ,i_node      => i_node);
 
  RETURN l_rowcount;

END f_note_rowcount;

------------------------------------------------------------------------

PROCEDURE note_sqlerrm(i_node      IN sm_logger.node_typ )
IS
BEGIN

  note ( i_name       => 'SQLERRM'
        ,i_value      => SQLERRM
        ,i_node       => i_node  );
 
END note_sqlerrm;

------------------------------------------------------------------------
PROCEDURE note_length( i_node  IN sm_logger.node_typ 
                      ,i_name  IN VARCHAR2 
                      ,i_value IN CLOB        ) IS
BEGIN

  note ( i_node       => i_node
        ,i_name       => 'LENGTH('||i_name||')'
        ,i_num_value  => LENGTH(i_value)  );

END note_length;



FUNCTION get_session_id(i_node IN sm_logger.node_typ) return number is
BEGIN
  return i_node.call.session_id;
END;

------------------------------------------------------------------------
FUNCTION get_session_url(i_node IN sm_logger.node_typ) return varchar2 is
BEGIN
  return sm_api.get_smartlogger_trace_URL(i_session_id  => get_session_id(i_node => i_node));
end;


PROCEDURE on_demand(io_node       IN OUT sm_logger.node_typ
                   ,i_debug       in     boolean  default false
                   ,i_normal      in     boolean  default false
                   ,i_quiet       in     boolean  default false
                   ,i_disabled    in     boolean  default false
                   ,i_msg_mode    in     integer  default null ) is
BEGIN
  
  --Reinitialise the node with the requested mode.
  io_node := sm_logger.new_node(i_module_name => io_node.module.module_name
                               ,i_unit_name   => io_node.unit.unit_name
                               ,i_unit_type   => io_node.unit.unit_type 
                               ,i_debug       => i_debug   
                               ,i_normal      => i_normal  
                               ,i_quiet       => i_quiet   
                               ,i_disabled    => i_disabled
                               ,i_msg_mode    => i_msg_mode);

END;



BEGIN
  NULL;
  --Enable DBMS_OUTPUT when compiled for INTLOG
  $if $$intlog $then DBMS_OUTPUT.ENABLE(null); $end
  
  --Set G_AUTO_WAKE_DEFAULT and G_AUTO_MSG_MODE_DEFAULT
  --based on config settings
  if f_config_value('DEFAULT_AUTO_DEBUG') = 'Y' THEN
    G_AUTO_WAKE_DEFAULT          := G_AUTO_WAKE_YES;
    G_AUTO_MSG_MODE_DEFAULT      := G_MSG_MODE_DEBUG;
  elsif f_config_value('DEFAULT_AUTO_NORMAL') = 'Y' THEN
    G_AUTO_WAKE_DEFAULT          := G_AUTO_WAKE_YES;
    G_AUTO_MSG_MODE_DEFAULT      := G_MSG_MODE_NORMAL;
  elsif f_config_value('DEFAULT_AUTO_QUIET') = 'Y' THEN
    G_AUTO_WAKE_DEFAULT          := G_AUTO_WAKE_NO;
    G_AUTO_MSG_MODE_DEFAULT      := G_MSG_MODE_QUIET;
  elsif f_config_value('DEFAULT_AUTO_DISABLED') = 'Y' THEN
    G_AUTO_WAKE_DEFAULT          := G_AUTO_WAKE_NO;
    G_AUTO_MSG_MODE_DEFAULT      := G_MSG_MODE_DISABLED;
  END IF;  

  G_PARENT_APP_SESSION_VAR       := f_config_value('PARENT_APP_SESSION_VAR');
  
end;
/
show error;

--alter package sm_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings;