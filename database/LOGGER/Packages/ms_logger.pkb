alter session set plsql_ccflags = 'intlog:false';
--alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings 
--alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings 

--Ensure no inlining so ms_logger can be used
alter session set plsql_optimize_level = 1;

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
 
 
  g_debug_indent       INTEGER;
 
  G_MODULE_NAME_WIDTH     CONSTANT NUMBER := 50;
  G_UNIT_NAME_WIDTH       CONSTANT NUMBER := 50;
  G_REF_NAME_WIDTH        CONSTANT NUMBER := 100;
  G_REF_VALUE_WIDTH       CONSTANT NUMBER := 30;
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
 


g_max_nested_units      NUMBER   := 100;   --sx_lookup_pkg.lookup_desc('MAX_DEPTH','MESSAGE_PARAM');

 
--Node Types
--Root Only  - Will end current process and start a new one.
--Root Never - Will not start a process
--Either will start a process if none started and Normal, or Debug msg_mode.

--Open Process  open_process
--Always        Y
--If Closed     C
--Never         N 
 
------------------------------------------------------------------------
-- UNIT TYPES (Private)
------------------------------------------------------------------------
--GENERAL UNIT TYPES 
G_UNIT_TYPE_PACKAGE       CONSTANT ms_unit.unit_type%TYPE := 'PKG';
G_UNIT_TYPE_PROCEDURE     CONSTANT ms_unit.unit_type%TYPE := 'PROC';
G_UNIT_TYPE_FUNCTION      CONSTANT ms_unit.unit_type%TYPE := 'FUNC';
--G_UNIT_TYPE_LOOP          CONSTANT ms_unit.unit_type%TYPE := 'LOOP';
--G_UNIT_TYPE_BLOCK         CONSTANT ms_unit.unit_type%TYPE := 'BLOCK';
G_UNIT_TYPE_TRIGGER       CONSTANT ms_unit.unit_type%TYPE := 'TRIGGER';
G_UNIT_TYPE_SCRIPT        CONSTANT ms_unit.unit_type%TYPE := 'SCRIPT';
--G_UNIT_TYPE_PASS          CONSTANT ms_unit.unit_type%TYPE := 'PASS';
 
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
G_MODULE_TYPE_SCRIPT        CONSTANT ms_module.module_type%TYPE := 'SCRIPT';
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
-- These routines are includes in the package only when compiled with intlog:true
------------------------------------------------------------------------
 
--COMPILER FLAGGED PROCEDURES - START
$if $$intlog $then 

PROCEDURE intlog_putline(i_line IN VARCHAR2 ) IS
--Don't call this directly.
BEGIN 
    dbms_output.put_line(LPAD('+ ',g_debug_indent*2,'+ ')||i_line);
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


PROCEDURE intlog_error(i_message IN VARCHAR2 ) IS
BEGIN 
  intlog_putline('##'||i_message);
END;
 
$end           
--COMPILER FLAGGED PROCEDURES - FINISH


PROCEDURE err_set_process_internal_error IS
  --set internal error
  --create_ref, create_traversal, log_message will not start 
  --while this flag is set.  
  --These procedures are the ONLY gateways to the LOG and PUSH routines
  
   PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 
 
  g_internal_error := TRUE; 
  $if $$intlog $then intlog_debug('INTERNAL ERROR'); $end
 
  UPDATE ms_process 
  SET internal_error = 'Y'
  WHERE process_id   = g_process_id
  AND internal_error = 'N';
  
  COMMIT;

END; 
 
 
PROCEDURE err_create_internal_error(i_message IN CLOB ) IS
   
   PRAGMA AUTONOMOUS_TRANSACTION;

   l_internal_error     ms_message%ROWTYPE;

BEGIN 

  err_set_process_internal_error;

  $if $$intlog $then intlog_error(i_message);  $end
 
  l_internal_error.name         := 'PROCESS '||g_process_id;
  l_internal_error.message      := i_message;
  l_internal_error.msg_level    := G_MSG_LEVEL_INTERNAL;
  l_internal_error.message_id   := new_message_id;
  l_internal_error.traversal_id := NVL(f_current_traversal_id,0); -- dummy traversal_id if none current
  l_internal_error.time_now     := SYSTIMESTAMP;

  INSERT INTO ms_message VALUES l_internal_error;
  
  COMMIT;

END; 

 
PROCEDURE err_warn_oracle_error(i_message IN VARCHAR2 ) IS
BEGIN 
  $if $$intlog $then intlog_putline(i_message||':');     $end
  err_create_internal_error(SQLERRM);
  $if $$intlog $then intlog_end(i_message); $end --extra call to intlog_end closes the program unit.

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

    RETURN l_result;
 
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
                    ,i_unit_name    IN VARCHAR2 DEFAULT NULL)
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

    IF i_module_type IS NULL THEN 
      --Derive module type
      CASE 
        WHEN i_unit_name IN ('beforepform'
                            ,'afterpform'
                            ,'afterreport') THEN 
          --These program units are assumed to be reoprts.
          l_module.owner  := USER;
          l_module.module_type     := G_MODULE_TYPE_REPORT;

        ELSE 
          --Look up the module in the data dictionary
          l_module.owner       :=  object_owner(i_object_name => i_module_name);
          l_module.module_type :=  object_type(i_object_name  => i_module_name
                                              ,i_owner        => l_module.owner);
      END CASE;
      
    ELSE
      l_module.module_type := i_module_type;
    END IF;  

    --create the new module record
    l_module.module_id       := new_module_id;
    l_module.module_name     := i_module_name;
    l_module.revision        := i_revision;
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

------------------------------------------------------------------------
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
-- EXPOSED FOR THE MS_API
----------------------------------------------------------------------


----------------------------------------------------------------------
-- f_process_traced
----------------------------------------------------------------------
FUNCTION f_process_traced(i_process_id IN INTEGER) RETURN BOOLEAN IS
  CURSOR cu_traversal IS
  SELECT 1
  FROM   ms_traversal t  
  WHERE  t.process_id = i_process_id ;  
 				 
  l_dummy  INTEGER;	
  l_result BOOLEAN;  
				 
BEGIN
 
    OPEN cu_traversal;
    FETCH cu_traversal INTO l_dummy;
	l_result := cu_traversal%FOUND;
    CLOSE cu_traversal;
    
    RETURN l_result;
   
END f_process_traced;
 
----------------------------------------------------------------------
-- f_process_id
----------------------------------------------------------------------
FUNCTION f_process_id(i_process_id IN INTEGER  DEFAULT NULL
                     ,i_ext_ref    IN VARCHAR2 DEFAULT NULL) RETURN INTEGER IS
					 
  CURSOR cu_process IS
  SELECT process_id
  FROM   ms_process   p
  WHERE  p.process_id = i_process_id
     OR  p.ext_ref    = i_ext_ref;  
 				 
  l_result INTEGER;				 
				 
BEGIN
  IF i_process_id IS NOT NULL OR i_ext_ref IS NOT NULL THEN
    OPEN cu_process;
    FETCH cu_process INTO l_result;
    CLOSE cu_process;
    
    RETURN l_result;
   
  ELSE
   
    RETURN g_process_id;
    
  END IF;  
  
END f_process_id;
 
FUNCTION f_process_is_closed RETURN BOOLEAN IS
BEGIN
  RETURN g_process_id IS NULL;
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
  
	--comment(i_node,'pop_to_parent_node');
    --note(i_node,'i_node.unit.unit_name',i_node.unit.unit_name);                         --TESTING ONLY
    --note(i_node,'i_node.call_stack_level',i_node.call_stack_level);                     --TESTING ONLY
    --note(i_node,'i_node.call_stack_hist',i_node.call_stack_hist);                       --TESTING ONLY	
	--note(i_node,'f_index',f_index); 
    --note(i_node,'g_nodes(f_index).unit.unit_name',g_nodes(f_index).unit.unit_name);     --TESTING ONLY
	--note(i_node,'g_nodes(f_index).call_stack_level',g_nodes(f_index).call_stack_level); --TESTING ONLY
	--note(i_node,'g_nodes(f_index).call_stack_hist',g_nodes(f_index).call_stack_hist);   --TESTING ONLY
  
  
	   $if $$intlog $then intlog_note('last call_stack_level',g_nodes(f_index).call_stack_level ); $end
	   $if $$intlog $then intlog_note('last call_stack_hist' ,g_nodes(f_index).call_stack_hist ); $end
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
--Pop any node that is not a ancestor of this node.
BEGIN
  $if $$intlog $then intlog_start('pop_descendent_nodes');                              $end         
  $if $$intlog $then intlog_note('current call_stack_level',i_node.call_stack_level );  $end
  $if $$intlog $then intlog_note('f_index',f_index );                                   $end
  $if $$intlog $then intlog_note('g_nodes(f_index).unit.unit_name',g_nodes(f_index).unit.unit_name );   $end

  --remove from the stack any node with a call_stack_level equal to or greater than the new node.
  while f_index > 0 and
        g_nodes(f_index).call_stack_level > i_node.call_stack_level  loop
	   $if $$intlog $then intlog_note('last call_stack_level',g_nodes(f_index).call_stack_level ); $end
	   $if $$intlog $then intlog_debug('pop_descendent_nodes: removing top node '||f_index );      $end
	   
	--comment(i_node,'pop_descendent_nodes');
    --note(i_node,'i_node.unit.unit_name',i_node.unit.unit_name);                         --TESTING ONLY
    --note(i_node,'i_node.call_stack_level',i_node.call_stack_level);                     --TESTING ONLY
    --note(i_node,'i_node.call_stack_hist',i_node.call_stack_hist);                       --TESTING ONLY	
	--note(i_node,'f_index',f_index); 
    --note(i_node,'g_nodes(f_index).unit.unit_name',g_nodes(f_index).unit.unit_name);     --TESTING ONLY
	--note(i_node,'g_nodes(f_index).call_stack_level',g_nodes(f_index).call_stack_level); --TESTING ONLY
	--note(i_node,'g_nodes(f_index).call_stack_hist',g_nodes(f_index).call_stack_hist);   --TESTING ONLY
	   
	   
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
-- synch_node_stack
------------------------------------------------------------------------
 
PROCEDURE synch_node_stack( i_node IN ms_logger.node_typ) IS
BEGIN 
  --Is the node on the stack??
  IF i_node.node_level is not null then
    --ENSURE traversals point to current node.
    pop_descendent_nodes(i_node => i_node);
  end if;

END;

------------------------------------------------------------------------
-- dump_nodes - forward declaration
------------------------------------------------------------------------
PROCEDURE dump_nodes(i_index    IN BINARY_INTEGER
                    ,i_msg_mode IN NUMBER);

 
------------------------------------------------------------------------
-- LOGGING ROUTINES (private)
-- These routines write to the logging tables
------------------------------------------------------------------------

PROCEDURE log_process(i_origin       IN VARCHAR2 DEFAULT NULL
                     ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                     ,i_comments     IN VARCHAR2 DEFAULT NULL)

IS
 
  PRAGMA AUTONOMOUS_TRANSACTION;
  
  l_process ms_process%ROWTYPE;

BEGIN
    $if $$intlog $then intlog_start('log_process'); $end
    --reset internal error for the new process
    g_internal_error := FALSE;
 
    SELECT ms_process_seq.NEXTVAL INTO g_process_id FROM DUAL;
    
    l_process.process_id     := g_process_id;
    l_process.origin         := i_origin;
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
-- Message operations (private)
------------------------------------------------------------------------


------------------------------------------------------------------------
-- push_message
------------------------------------------------------------------------
PROCEDURE push_message(io_messages  IN OUT message_list
                      ,i_message    IN     ms_message%ROWTYPE ) IS
  l_next_index               BINARY_INTEGER;    
 
BEGIN
 
  --Next index is last index + 1
  l_next_index := NVL(io_messages.LAST,0) + 1;

  --add to the stack             
  io_messages( l_next_index ) := i_message;

END;

------------------------------------------------------------------------
-- log_message
------------------------------------------------------------------------
 
FUNCTION log_message(i_message  IN ms_message%ROWTYPE
                    ,i_node     IN ms_logger.node_typ) RETURN BOOLEAN IS
    PRAGMA AUTONOMOUS_TRANSACTION;

  l_message ms_message%ROWTYPE := i_message;
  l_logged BOOLEAN := FALSE;
BEGIN
  $if $$intlog $then intlog_start('log_message'); $end
  l_message.message_id := new_message_id;
  
  $if $$intlog $then intlog_note('l_message.msg_level',l_message.msg_level);  $end
  $if $$intlog $then intlog_note('i_node.traversal.msg_mode'    ,i_node.traversal.msg_mode);      $end
 
  IF i_node.logged AND 
     l_message.msg_level >= i_node.traversal.msg_mode THEN
     --Node is logged and the message's msg_level is at least as great as node's msg_mode
     $if $$intlog $then intlog_debug('Loggable, so log it.' );        $end
 
     l_message.message_id   := new_message_id;
     l_message.traversal_id := i_node.traversal.traversal_id;
 
     $if $$intlog $then intlog_note('message_id  ',l_message.message_id  ); $end
     $if $$intlog $then intlog_note('traversal_id',l_message.traversal_id); $end
     $if $$intlog $then intlog_note('name        ',l_message.name        ); $end
     $if $$intlog $then intlog_note('message     ',l_message.message     ); $end
     $if $$intlog $then intlog_note('msg_type    ',l_message.msg_type    ); $end
     $if $$intlog $then intlog_note('msg_level   ',l_message.msg_level   ); $end
     $if $$intlog $then intlog_note('time_now    ',l_message.time_now   ); $end
    
     INSERT INTO ms_message VALUES l_message;

     l_logged := TRUE;
  
  END IF;
 
  COMMIT;
 
  $if $$intlog $then intlog_end('log_message'); $end

  RETURN l_logged;
 
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
                          ,i_node      IN ms_logger.node_typ ) IS
 
  l_message ms_message%ROWTYPE;

BEGIN
  $if $$intlog $then intlog_start('create_message'); $end
  IF NOT g_internal_error and 
     NOT i_node.traversal.msg_mode = G_MSG_MODE_DISABLED THEN 
 
      --ms_logger passes node as origin of message  
      synch_node_stack( i_node => i_node);

      l_message.message_id   := NULL; 
      l_message.traversal_id := NULL;         
      l_message.name         := SUBSTR(i_name ,1,G_REF_NAME_WIDTH);
      l_message.value        := SUBSTR(i_value ,1,G_REF_VALUE_WIDTH);
      l_message.message      := i_message;
      l_message.msg_type     := i_msg_type; 
      l_message.msg_level    := i_msg_level; 
      l_message.time_now     := SYSTIMESTAMP;

      IF l_message.msg_level >= G_MSG_LEVEL_FATAL THEN -- message is fatal or worse
         --log all unlogged traversals using debug mode
         dump_nodes(i_index    => f_index
                   ,i_msg_mode => G_MSG_MODE_DEBUG);
      END IF;

      IF log_message(i_message => l_message
                    ,i_node    => g_nodes(f_index)) THEN
        --logged it, don't need to push it
        NULL;
      ELSE
        --Not loggable
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
--Log traversal or update it if already logged.
--Log any unlogged refs.

  l_message_index     BINARY_INTEGER;
  l_del_message_index BINARY_INTEGER;

  x_too_deeply_nested   EXCEPTION;
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_logged BOOLEAN;
 
BEGIN
  $if $$intlog $then intlog_start('log_node'); $end
  IF f_index = g_max_nested_units THEN
    RAISE x_too_deeply_nested;
  END IF;
 
  --should we start a new process
  IF  io_node.open_process = G_OPEN_PROCESS_ALWAYS    OR 
     (io_node.open_process = G_OPEN_PROCESS_IF_CLOSED AND f_process_is_closed) THEN
 
    --if the procedure stack if empty then we'll start a new process
    log_process(i_origin  => io_node.module.module_name||' '||io_node.unit.unit_name  );
  END IF;

  --Now that we can re-log a node, need to test if already logged.
  IF io_node.logged THEN
    $if $$intlog $then intlog_debug('Re-logging a Node'); $end
    $if $$intlog $then intlog_note('module_name        ',io_node.module.module_name );           $end
    $if $$intlog $then intlog_note('unit_name          ',io_node.unit.unit_name  );              $end
    $if $$intlog $then intlog_note('traversal_id       ',io_node.traversal.traversal_id       ); $end
    $if $$intlog $then intlog_note('unit_id            ',io_node.traversal.unit_id);             $end
    $if $$intlog $then intlog_note('parent_traversal_id',io_node.traversal.parent_traversal_id); $end
    $if $$intlog $then intlog_note('process_id         ',io_node.traversal.process_id         ); $end
    $if $$intlog $then intlog_note('msg_mode           ',io_node.traversal.msg_mode);            $end

 
    UPDATE ms_traversal 
    SET ROW = io_node.traversal
    WHERE traversal_id = io_node.traversal.traversal_id;	
  
  ELSE
    $if $$intlog $then intlog_debug('Log a node first time'); $end
    --fill in the NULLs
    io_node.traversal.traversal_id        := new_traversal_id; 
    io_node.traversal.parent_traversal_id := g_nodes(i_parent_index).traversal.traversal_id; 
    io_node.traversal.process_id          := g_process_id;
    
    $if $$intlog $then intlog_note('module_name        ',io_node.module.module_name );           $end
    $if $$intlog $then intlog_note('unit_name          ',io_node.unit.unit_name  );              $end
    $if $$intlog $then intlog_note('traversal_id       ',io_node.traversal.traversal_id       ); $end
    $if $$intlog $then intlog_note('unit_id            ',io_node.traversal.unit_id);             $end
    $if $$intlog $then intlog_note('parent_traversal_id',io_node.traversal.parent_traversal_id); $end
    $if $$intlog $then intlog_note('process_id         ',io_node.traversal.process_id         ); $end
    $if $$intlog $then intlog_note('msg_mode           ',io_node.traversal.msg_mode);            $end

    INSERT INTO ms_traversal VALUES io_node.traversal; 
  	io_node.logged := TRUE;
	
  END IF;
  
  COMMIT;  --commit prior to logging refs
 
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
 
  --Log traversals (using the given msg_mode) that have not yet been logged,
  --or were logged at a higher msg_mode.
  --search back recursively to first logged traversal, at an equal msg_mode
  --log_node will update node with the new msg_mode
  --and log any remaining unlogged refs.

  l_traversal_index BINARY_INTEGER;
BEGIN
  $if $$intlog $then intlog_start('dump_nodes'); $end
  IF i_index > 0 AND ( 
          NOT g_nodes(i_index).logged 
	  OR  g_nodes(i_index).traversal.msg_mode > i_msg_mode)  THEN
    --dump any previous traversals too
    dump_nodes(i_index    => g_nodes.PRIOR(i_index)
              ,i_msg_mode => i_msg_mode);
  
    g_nodes(i_index).traversal.msg_mode := i_msg_mode;
    log_node(io_node        => g_nodes(i_index)
            ,i_parent_index => g_nodes.PRIOR(i_index));
  END IF;
  $if $$intlog $then intlog_end('dump_nodes'); $end
 
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('dump_nodes');
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
 

PROCEDURE warn_user_source_error_lines( i_node       IN ms_logger.node_typ
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

PROCEDURE debug_error( i_node            IN ms_logger.node_typ 
                      ,i_message         IN CLOB DEFAULT NULL
                      ,i_msg_level       IN INTEGER )
IS
BEGIN
 

  create_message ( i_message   => LTRIM(i_message ||' '||SQLERRM
                                ||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE )--show the original error line number
                  ,i_msg_type  => G_MSG_TYPE_MESSAGE
                  ,i_msg_level => i_msg_level
			  ,i_node     => i_node );
  
  warn_user_source_error_lines(i_prev_lines => 5
                              ,i_post_lines => 5
							  ,i_node     => i_node);


END debug_error;



 
------------------------------------------------------------------------
-- ROUTINES (Public)
------------------------------------------------------------------------
 
 
----------------------------------------------------------------------------
-- create_ref -  now merely calls create_message
----------------------------------------------------------------------------
 
 
PROCEDURE create_ref ( i_name      IN VARCHAR2
                      ,i_value     IN VARCHAR2
                      ,i_msg_type  IN VARCHAR2
                      ,i_node      IN ms_logger.node_typ ) IS

BEGIN
  $if $$intlog $then intlog_start('create_ref'); $end

    IF LENGTH(i_value) <= G_REF_VALUE_WIDTH and INSTR(i_value,chr(10))= 0 THEN
      --Short, single line value, so just put it in the value column
      create_message ( i_name      => i_name
                      ,i_value     => i_value
                      ,i_msg_type  => i_msg_type
                      ,i_msg_level => G_MSG_LEVEL_COMMENT
	         ,i_node    => i_node);      
 
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
 
PROCEDURE  set_unit_disabled(i_module_name IN VARCHAR2
                            ,i_unit_name   IN VARCHAR2 ) IS
                             
BEGIN
  set_unit_msg_mode(i_module_name  => i_module_name
                    ,i_unit_name    => i_unit_name  
                    ,i_msg_mode    => G_MSG_MODE_DISABLED);
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

    IF io_node.traversal.msg_mode = G_MSG_MODE_DISABLED THEN  
      -- create disabled nodes, but don't log them or stack them
      $if $$intlog $then intlog_debug('Disabled node'); $end
      NULL;

    ELSE  

	    --Use the call stack to remove any nodes from the stack that are not ancestors
      pop_to_parent_node(i_node => io_node);
   
      IF io_node.traversal.msg_mode <> G_MSG_MODE_QUIET THEN 
	    --Log this node, but first log any ancestors that are not yet logged.
        --dump any unlogged traversals in QUIET MODE
        dump_nodes(i_index    => f_index
                  ,i_msg_mode => G_MSG_MODE_QUIET);
        --log the traversal and push it on the traversal stack
        log_node(io_node        => io_node
                ,i_parent_index => f_index);
   
      END IF;
	  
	--  push the traversal onto the stack
      push_node(io_node  => io_node);
      
  
      IF NOT g_internal_error THEN
        io_node.node_level := f_index; --meaningless if g_internal_error is TRUE
      END IF;

    END IF;
	
  END IF;
  
  io_node.internal_error := g_internal_error;
  
  $if $$intlog $then intlog_end('create_traversal'); $end
  
EXCEPTION
  WHEN OTHERS THEN
    err_warn_oracle_error('create_traversal');
 
END create_traversal;



------------------------------------------------------------------------
-- Node Typ API functions (Private)
------------------------------------------------------------------------

FUNCTION new_node(i_module_name IN VARCHAR2
                 ,i_unit_name   IN VARCHAR2
			         	 ,i_unit_type   IN VARCHAR2) RETURN ms_logger.node_typ IS
				 
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
    l_lines := APEX_UTIL.STRING_TO_TABLE(dbms_utility.format_call_stack,chr(10));
   
    return l_lines.count;
     
  END;	 
  
  FUNCTION f_call_stack_hist RETURN CLOB IS
    l_lines   APEX_APPLICATION_GLOBAL.VC_ARR2;
	l_call_stack_hist CLOB;
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
	
	FOR l_index IN 9..l_lines.count LOOP 
	  --UNFORMATTED
	  --l_call_stack_hist := ltrim(l_call_stack_hist || chr(10) || l_lines(l_index), chr(10));
	  
	  --FORMATTED
	  --Remove description and format unit id and line number for the history.
	  l_call_stack_hist := ltrim(l_call_stack_hist || chr(10) || REGEXP_REPLACE(SUBSTR(l_lines(l_index),1,20),'(\w+)\s+?(\w+)','\1:\2'), chr(10));
    END LOOP;
   
    return l_call_stack_hist;
     
  END;	
 
 
BEGIN
  
  --get a registered module or register this one
  l_node.module := find_module(i_module_name => i_module_name
                              ,i_unit_name   => i_unit_name); 

  --get a registered unit or register this one
  l_node.unit := find_unit(i_module_id   => l_node.module.module_id
                          ,i_unit_name   => i_unit_name  
                          ,i_unit_type   => i_unit_type);


  l_node.call_stack_level := f_call_stack_level; --simplify after 12C with additional functions
  l_node.call_stack_hist  := f_call_stack_hist;
 
  create_traversal(io_node => l_node);
 
  RETURN l_node;
  
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
 
 
  --------------------------------------------------------------------
  --purge_old_processes
  -------------------------------------------------------------------


PROCEDURE purge_old_processes(i_keep_day_count IN NUMBER DEFAULT 1) IS

 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

  delete from ms_process        where created_date < (SYSDATE - i_keep_day_count);

  COMMIT;
 
  /*
  IF i_keep_day_count = 0 THEN
    --Processes are all gone, so reset the sequences.
 
    reset_sequence(i_sequence_name => 'ms_message_seq');
	  reset_sequence(i_sequence_name => 'ms_traversal_seq');
	  reset_sequence(i_sequence_name => 'ms_process_seq');
	
  END IF;
  */
 
 
 END;
 
  

  ------------------------------------------------------------------------
  -- Node Typ API functions (Public)
  ------------------------------------------------------------------------
  
 
FUNCTION new_process(i_process_name IN VARCHAR2 DEFAULT NULL
                    ,i_process_type IN VARCHAR2 DEFAULT NULL
                    ,i_ext_ref      IN VARCHAR2 DEFAULT NULL
                    ,i_module_name  IN VARCHAR2 DEFAULT NULL
                    ,i_unit_name    IN VARCHAR2 DEFAULT NULL
					--,i_msg_mode     IN INTEGER  DEFAULT G_MSG_MODE_NORMAL
                    ,i_comments     IN VARCHAR2 DEFAULT NULL       ) RETURN INTEGER IS
 
  l_origin ms_process.origin%TYPE;
  l_module ms_module%rowtype;
  l_unit   ms_unit%rowtype;

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
 
  log_process(i_origin      =>l_origin
        --  ,i_msg_mode     => i_msg_mode
            ,i_ext_ref      => i_ext_ref    
            ,i_comments     => i_comments);  
 
  RETURN g_process_id;
					
 		 
END;
  
 
  FUNCTION new_pkg(i_module_name IN VARCHAR2
                  ,i_unit_name   IN VARCHAR2 DEFAULT 'Initialisation') RETURN ms_logger.node_typ IS
 
  BEGIN
    
	RETURN ms_logger.new_node(i_module_name => i_module_name
                           ,i_unit_name   => i_unit_name
						            	 ,i_unit_type   => G_UNIT_TYPE_PACKAGE );
 
  END;
  
  
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
  
  FUNCTION new_trig(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ IS
 
  BEGIN
    
	RETURN ms_logger.new_node(i_module_name => i_module_name
                           ,i_unit_name   => i_unit_name
							             ,i_unit_type   => G_UNIT_TYPE_TRIGGER );
 
  END;
  
  
  FUNCTION new_script(i_module_name IN VARCHAR2
                     ,i_unit_name   IN VARCHAR2 ) RETURN ms_logger.node_typ IS
  
  BEGIN
    
   RETURN ms_logger.new_node(i_module_name => i_module_name
                             ,i_unit_name   => i_unit_name
                						 ,i_unit_type   => G_UNIT_TYPE_SCRIPT );
  
  END;
  
 
  
------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

------------------------------------------------------------------------ 
-- comment 
------------------------------------------------------------------------
PROCEDURE comment( i_node            IN ms_logger.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_COMMENT
	  ,i_node     => i_node);
 
END comment;

------------------------------------------------------------------------
-- info 
------------------------------------------------------------------------
PROCEDURE info( i_node            IN ms_logger.node_typ 
               ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_INFO
   ,i_node     => i_node);
 
END info;

------------------------------------------------------------------------
-- warning  
------------------------------------------------------------------------

PROCEDURE warning( i_node         IN ms_logger.node_typ 
                  ,i_message      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    create_message ( i_message   => i_message
                    ,i_msg_type  => G_MSG_TYPE_MESSAGE
                    ,i_msg_level => G_MSG_LEVEL_WARNING
   ,i_node     => i_node);
 
END warning;

------------------------------------------------------------------------
-- fatal  
------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN     ms_logger.node_typ 
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

PROCEDURE oracle_error( i_node            IN ms_logger.node_typ 
                       ,i_message         IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN
 
  debug_error( i_node             => i_node     
              ,i_message          => i_message
              ,i_msg_level        => G_MSG_LEVEL_ORACLE );
 
END oracle_error;
------------------------------------------------------------------------
-- warn_error  
------------------------------------------------------------------------

PROCEDURE warn_error( i_node            IN ms_logger.node_typ 
                     ,i_message         IN VARCHAR2 DEFAULT NULL  )
IS
BEGIN

  debug_error( i_node             => i_node     
              ,i_message          => i_message
              ,i_msg_level        => G_MSG_LEVEL_WARNING );


END warn_error;



------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ   
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2 )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => i_value
              ,i_msg_type   => G_MSG_TYPE_NOTE
        ,i_node            => i_node);      
 
END note   ;

 
------------------------------------------------------------------------

PROCEDURE param ( i_node      IN ms_logger.node_typ 
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
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER )
IS

BEGIN

  create_ref ( i_name       => i_name
           ,i_value      => TO_CHAR(ROUND(i_num_value,15))
           ,i_msg_type   => G_MSG_TYPE_NOTE
           ,i_node     => i_node);

END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_node      IN ms_logger.node_typ 
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
PROCEDURE note    ( i_node      IN ms_logger.node_typ 
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
PROCEDURE param ( i_node       IN ms_logger.node_typ 
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
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  )
IS

BEGIN

  create_ref ( i_name       => i_name
              ,i_value      => f_tf(i_bool_value)
              ,i_msg_type   => G_MSG_TYPE_NOTE
              ,i_node       => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN )
IS

BEGIN
  create_ref ( i_name        => i_name
              ,i_value       => f_tf(i_bool_value)
              ,i_msg_type    => G_MSG_TYPE_PARAM
              ,i_node        => i_node);

END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_node      IN ms_logger.node_typ 
                 ,i_name      IN VARCHAR2 )
IS
BEGIN
  create_ref(i_name       => i_name
            ,i_value      => TO_CHAR(NULL) 
            ,i_msg_type   => G_MSG_TYPE_NOTE
            ,i_node       => i_node);

END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN ms_logger.node_typ 
                        ,i_name      IN VARCHAR2 ) IS
BEGIN

  note ( i_node       => i_node  
        ,i_name       => i_name
        ,i_num_value  => SQL%ROWCOUNT );

END note_rowcount;
------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN ms_logger.node_typ 
                         ,i_name      IN VARCHAR2  ) RETURN NUMBER IS
  l_rowcount NUMBER := SQL%ROWCOUNT;
BEGIN
  note ( i_node       => i_node  
        ,i_name       => i_name
        ,i_num_value  => l_rowcount );
 
  RETURN l_rowcount;

END f_note_rowcount;

------------------------------------------------------------------------

PROCEDURE note_error(i_node      IN ms_logger.node_typ )
IS
BEGIN

  note ( i_name       => 'SQLERRM'
        ,i_value      => SQLERRM
        ,i_node       => i_node  );
 
END note_error;

------------------------------------------------------------------------
PROCEDURE note_length( i_node  IN ms_logger.node_typ 
                      ,i_name  IN VARCHAR2 
                      ,i_value IN CLOB        ) IS
BEGIN

  note ( i_node       => i_node
        ,i_name       => 'LENGTH('||i_name||')'
        ,i_num_value  => LENGTH(i_value)  );

END note_length;

------------------------------------------------------------------------ 
-- FUNCTIONS USED IN VIEWS
------------------------------------------------------------------------ 
 
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




 
FUNCTION unit_message_count(i_unit_id      IN NUMBER
                           ,i_msg_level    IN NUMBER) RETURN NUMBER IS
                           
  CURSOR cu_message_count(c_unit_id      NUMBER                         
                         ,c_msg_level    NUMBER) IS
  SELECT count(*)
  FROM   ms_traversal_message_vw
  WHERE  unit_id    =  c_unit_id
  AND    msg_level  =  c_msg_level; 
  
  l_result NUMBER;
  
BEGIN
  OPEN cu_message_count(c_unit_id      => i_unit_id
                       ,c_msg_level    => i_msg_level);
  FETCH cu_message_count INTO l_result;
  CLOSE cu_message_count;
  
  RETURN l_result;
  
END;  

 
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

BEGIN
  NULL;
  --Enable DBMS_OUTPUT when compiled for INTLOG
  $if $$intlog $then DBMS_OUTPUT.ENABLE(null); $end
end;
/
show error;
