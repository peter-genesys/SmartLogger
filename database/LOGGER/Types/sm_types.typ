CREATE OR REPLACE TYPE sm_ref as object (
 name        VARCHAR2(30)
,value       VARCHAR2(100)
,param_ind   VARCHAR2(1))
/
 
CREATE OR REPLACE TYPE sm_ref_list AS TABLE OF sm_ref
/
  
  
CREATE OR REPLACE TYPE sm_unit as object (
 unit_name                                          VARCHAR2(50)
,unit_type                                          VARCHAR2(10)
,msg_mode                                           NUMBER
,open_process                                       VARCHAR2(1))
/  
  
CREATE OR REPLACE TYPE sm_node as object (  
   unit           sm_unit
  ,ref_list       sm_ref_list
  ,node_level     NUMBER
  ,logged         VARCHAR2(1)
  ,internal_error VARCHAR2(1)       --start undefined, set to false by an ENTER routine.
  ,pass_count     NUMBER            --initialised at 0 
  ,call_stack     varchar2(2000))
/  

 
create table sm_units of sm_unit nested table 

/*
  
  
  
  
CREATE OR REPLACE TYPE sm_node as object (  
   unit           sm_unit
  ,ref_list       sm_ref_list
  ,node_level     BINARY_INTEGER
  ,logged         BOOLEAN
  ,internal_error BOOLEAN DEFAULT NULL --start undefined, set to false by an ENTER routine.
  ,pass_count     NUMBER  DEFAULT 0    --initialised at 0 
  ,call_stack     varchar2(2000));  
 
 
  
  
  
TYPE sm_node  IS RECORD
  (traversal      ms_traversal%ROWTYPE
  ,module         ms_module%ROWTYPE
  ,unit           ms_unit%ROWTYPE
  ,msg_mode       number
  ,open_process   ms_unit.open_process%TYPE
  ,node_level     BINARY_INTEGER
  ,logged         BOOLEAN
  ,unlogged_refs  ref_list
  ,internal_error BOOLEAN DEFAULT NULL --start undefined, set to false by an ENTER routine.
  ,pass_count     NUMBER  DEFAULT 0    --initialised at 0 
  ,call_stack     varchar2(2000));  
  
*/  