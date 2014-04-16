create or replace package body ms_logger is
  -- @AOP_NEVER
  l_current_node  ms_metacode.node_typ; 	

  ------------------------------------------------------------------------
  -- Node Typ API functions (Public)
  ------------------------------------------------------------------------
  
  FUNCTION new_proc(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2
				   ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS

    l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
    l_current_node ms_metacode.node_typ; 
  BEGIN
    
	l_current_node  := ms_metacode.new_node(i_module_name => i_module_name
                                           ,i_unit_name   => i_unit_name
										   ,i_call_stack  => l_call_stack );

    --now lets automatically start this node as a proc.
    ms_metacode.enter_proc(io_node => l_current_node); 
	
	--ms_metacode.comment(i_call_stack);
 
    return l_current_node;
 
  END;
  
  
  FUNCTION new_func(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2
				   ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS
 				   
    l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
    l_current_node ms_metacode.node_typ; 
  BEGIN
    
	l_current_node  := ms_metacode.new_node(i_module_name => i_module_name
                                           ,i_unit_name   => i_unit_name
										   ,i_call_stack  => l_call_stack );

    --now lets automatically start this node as a function.
    ms_metacode.enter_func(io_node => l_current_node); 
	--ms_metacode.comment(i_call_stack);
    return l_current_node;
 
  END;
  
  FUNCTION new_block(i_module_name IN VARCHAR2
                   ,i_unit_name   IN VARCHAR2
				   ,i_call_stack  IN VARCHAR2 DEFAULT NULL) RETURN ms_metacode.node_typ IS
 				   
    l_call_stack  VARCHAR2(2000) := NVL(i_call_stack, dbms_utility.format_call_stack);
    l_current_node ms_metacode.node_typ; 
  BEGIN
    
	l_current_node  := ms_metacode.new_node(i_module_name => i_module_name
                                           ,i_unit_name   => i_unit_name
										   ,i_call_stack  => l_call_stack );

    --now lets automatically start this node as a block.
    ms_metacode.enter_block(io_node => l_current_node); 
	--ms_metacode.comment(i_call_stack);
    return l_current_node;
 
  END;
  
  
------------------------------------------------------------------------
-- PASS operations (PUBLIC)
-- Pass is a metacoding shortcut.  
-- Creates and uses nodes that don't really exist, by adding 1 to the node_level
------------------------------------------------------------------------
PROCEDURE do_pass(io_node     IN OUT  ms_metacode.node_typ
                 ,i_pass_name IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  ms_metacode.do_pass(io_node     => io_node    
                     ,i_pass_name => i_pass_name);

END;
  
  
------------------------------------------------------------------------
-- Message ROUTINES (Public)
------------------------------------------------------------------------

------------------------------------------------------------------------ 
PROCEDURE comment( i_node            IN ms_metacode.node_typ 
                  ,i_message         IN VARCHAR2 DEFAULT NULL
                  ,i_raise_app_error IN BOOLEAN  DEFAULT FALSE)
IS
BEGIN

  ms_metacode.comment( i_node            => i_node            
                      ,i_message         => i_message        
                      ,i_raise_app_error => i_raise_app_error);
 
END comment;

------------------------------------------------------------------------
PROCEDURE info( i_node            IN ms_metacode.node_typ 
               ,i_message         IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
  ms_metacode.info( i_node            => i_node            
                   ,i_message         => i_message );

END info;

------------------------------------------------------------------------

PROCEDURE warning( i_node            IN ms_metacode.node_typ 
                  ,i_message      IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
  ms_metacode.warning( i_node            => i_node            
                   ,i_message         => i_message );
END warning;

------------------------------------------------------------------------

PROCEDURE fatal( i_node            IN ms_metacode.node_typ 
                ,i_message         IN     VARCHAR2 DEFAULT NULL
                ,i_raise_app_error IN     BOOLEAN  DEFAULT FALSE)
IS
BEGIN
 
  ms_metacode.fatal ( i_node            => i_node            
                     ,i_message         => i_message        
                     ,i_raise_app_error => i_raise_app_error);

END fatal;  
  
------------------------------------------------------------------------
-- Reference operations (PUBLIC)
------------------------------------------------------------------------

--overloaded name, value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_metacode.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_value     IN VARCHAR2
                   ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN
  
  ms_metacode.note( i_node   => i_node  
                   ,i_name   => i_name  
                   ,i_value  => i_value 
                   ,i_descr  => i_descr );
 
END note   ;
 
PROCEDURE invariant(i_node      IN ms_metacode.node_typ 
                   ,i_value     IN VARCHAR2)
IS

BEGIN

  ms_metacode.invariant(i_node  => i_node 
                       ,i_value => i_value );

END invariant   ;

------------------------------------------------------------------------

PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_value     IN VARCHAR2
                 ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN
 
  ms_metacode.param( i_node   => i_node  
                    ,i_name   => i_name  
                    ,i_value  => i_value 
                    ,i_descr  => i_descr );
 
END param;
------------------------------------------------------------------------
--overloaded name, num_value | [id, descr] 
PROCEDURE note    ( i_node      IN ms_metacode.node_typ 
                   ,i_name      IN VARCHAR2
                   ,i_num_value IN NUMBER
                   ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN

  ms_metacode.note( i_node       => i_node  
                   ,i_name       => i_name  
                   ,i_num_value  => i_num_value 
                   ,i_descr      => i_descr );

END note   ;

------------------------------------------------------------------------ 
PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 ,i_name      IN VARCHAR2
                 ,i_num_value IN NUMBER
                 ,i_descr     IN VARCHAR2 DEFAULT NULL )
IS

BEGIN
  ms_metacode.param( i_node       => i_node  
                    ,i_name       => i_name  
                    ,i_num_value  => i_num_value 
                    ,i_descr      => i_descr );

END param;
------------------------------------------------------------------------
--overloaded name, date_value , descr] 
PROCEDURE note    ( i_node      IN ms_metacode.node_typ 
                   ,i_name       IN VARCHAR2
                   ,i_date_value IN DATE
                   ,i_descr      IN VARCHAR2 DEFAULT NULL )
IS

BEGIN
  ms_metacode.note( i_node       => i_node  
                   ,i_name       => i_name  
                   ,i_date_value => i_date_value 
                   ,i_descr      => i_descr );

END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_date_value IN DATE
                 ,i_descr      IN VARCHAR2 DEFAULT NULL )
IS

BEGIN
  ms_metacode.param( i_node       => i_node  
                   ,i_name       => i_name  
                   ,i_date_value => i_date_value 
                   ,i_descr      => i_descr );

END param;

------------------------------------------------------------------------
--overloaded name, bool_value 
PROCEDURE note   (i_node      IN ms_metacode.node_typ 
                 ,i_name       IN VARCHAR2
                 ,i_bool_value IN BOOLEAN )
IS

BEGIN

  ms_metacode.note( i_node       => i_node  
                   ,i_name       => i_name  
                   ,i_bool_value => i_bool_value  );
 
END note   ;
------------------------------------------------------------------------
PROCEDURE param ( i_node      IN ms_metacode.node_typ 
                 , i_name      IN VARCHAR2
                 ,i_bool_value IN BOOLEAN  )
IS

BEGIN
  ms_metacode.param( i_node       => i_node  
                   ,i_name       => i_name  
                   ,i_bool_value => i_bool_value  );

END param;
------------------------------------------------------------------------
--overloaded name
PROCEDURE note   (i_node      IN ms_metacode.node_typ 
                 ,i_name      IN VARCHAR2)
IS
BEGIN
  ms_metacode.note( i_node       => i_node  
                   ,i_name       => i_name  );

END note   ;
------------------------------------------------------------------------
PROCEDURE note_rowcount( i_node      IN ms_metacode.node_typ 
                        ,i_name      IN VARCHAR2 ) IS
BEGIN

  ms_metacode.note_rowcount( i_node       => i_node  
                            ,i_name       => i_name  );

END note_rowcount;

------------------------------------------------------------------------
FUNCTION f_note_rowcount( i_node      IN ms_metacode.node_typ 
                         ,i_name      IN VARCHAR2 ) RETURN NUMBER IS
 
BEGIN
 
  RETURN ms_metacode.f_note_rowcount( i_node       => i_node  
                                     ,i_name       => i_name  );
 
END f_note_rowcount;

------------------------------------------------------------------------

PROCEDURE note_error(i_node      IN ms_metacode.node_typ )
IS
BEGIN

  ms_metacode.note_error( i_node       => i_node); 
  
END note_error;

------------------------------------------------------------------------
PROCEDURE note_length( i_node  IN ms_metacode.node_typ 
                      ,i_name  IN VARCHAR2 ) IS
BEGIN

  ms_metacode.note_length( i_node       => i_node  
                            ,i_name       => i_name  );

END note_length;

 
------------------------------------------------------------------------
-- EXCEPTION HANDLERS  (PUBLIC)
------------------------------------------------------------------------
 
--PROCEDURE ignore_error(io_node        IN OUT      ms_metacode.node_typ
--                      ,i_error_name   IN VARCHAR2 DEFAULT NULL
--                      ,i_message      IN VARCHAR2 DEFAULT NULL) IS
--  --ignore an expected named error - continue normal processing
--  --error ignored regardless of error_code but x_error provokes a warning
--BEGIN
--
--  ms_metacode.ignore_error(io_node      => io_node     
--                          ,i_error_name => i_error_name
--                          ,i_message    => i_message );  
-- 
--
--END ignore_error;
--
--------------------------------------------------------------------------
--
--PROCEDURE handled_error(io_node        IN OUT      ms_metacode.node_typ
--                       ,i_error_name   IN VARCHAR2 DEFAULT NULL
--                       ,i_message      IN VARCHAR2 DEFAULT NULL) IS
--                       
--BEGIN
--
--  ms_metacode.ignore_error(io_node      => io_node     
--                          ,i_error_name => i_error_name
--                          ,i_message    => i_message );  
-- 
--END handled_error;                   
-- 
--------------------------------------------------------------------------
-- 
--PROCEDURE trap_error(io_node    IN OUT ms_metacode.node_typ
--                    ,i_message  IN     VARCHAR2 DEFAULT NULL)
----trap x_error or oracle error, and resume normal processing                    
--IS
--BEGIN
--  ms_metacode.trap_error(io_node      => io_node     
--                        ,i_message    => i_message );  
--
--
--END trap_error;
-- 
--------------------------------------------------------------------------
--
--PROCEDURE raise_error(io_node    IN OUT ms_metacode.node_typ
--                     ,i_message  IN     VARCHAR2 DEFAULT NULL)
----trap x_error or oracle error, and return re-raise x_error                
--IS
--BEGIN
--  ms_metacode.raise_error(io_node      => io_node     
--                        ,i_message    => i_message );  
--
--END raise_error;

 
 
------------------------------------------------------------------------

PROCEDURE oracle_error( i_node            IN ms_metacode.node_typ
                       ,i_message         IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
 
  ms_metacode. oracle_error( i_node     => i_node   
              			    ,i_message  => i_message);


END oracle_error;
 
 
PROCEDURE  register_package(i_name      IN VARCHAR2
                           ,i_revision  IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  ms_metacode.register_package(i_name     =>  i_name    
                              ,i_revision =>  i_revision);
  
END;
 
end;
/