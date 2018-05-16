alter trigger aop_processor_trg disable;

create or replace package aop_processor AUTHID CURRENT_USER 
is
/** 
* AOP Processor - Aspect Orientated Programming Processor<br/>
* Purpose is to weaving the logging instrumentation into valid plsql progam units.<br/> 
*/
 



 
--TYPE identifier_rec is record (field_name    all_identifiers.name%TYPE 
--                              ,data_type     all_identifiers.name%TYPE 
--                              ,data_class    all_identifiers.type%TYPE 
--                              ,ref_signature all_identifiers.signature%TYPE);
TYPE identifier_rec is record (col_name    varchar2(128) 
                              ,data_type   varchar2(128) 
                              ,data_class  varchar2(18)  
                              ,signature   varchar2(32));

--TYPE identifier_tab IS table of all_identifiers%ROWTYPE;
TYPE identifier_tab IS table of identifier_rec index by BINARY_INTEGER;
 
  ----------------------------------------------------------------------------
  -- COLOUR CODES
  ----------------------------------------------------------------------------
 
  G_COLOUR_PROG_UNIT        CONSTANT VARCHAR2(10) := '#9999FF';
  G_COLOUR_BLOCK            CONSTANT VARCHAR2(10) := '#FFCC99';
  G_COLOUR_COMMENT          CONSTANT VARCHAR2(10) := '#FFFF99';
  G_COLOUR_QUOTE            CONSTANT VARCHAR2(10) := '#99CCFF';
  G_COLOUR_PARAM            CONSTANT VARCHAR2(10) := '#FF99FF';
  G_COLOUR_NODE             CONSTANT VARCHAR2(10) := '#66FFFF';
  G_COLOUR_ERROR            CONSTANT VARCHAR2(10) := '#FF6600';
  G_COLOUR_SPLICE           CONSTANT VARCHAR2(10) := '#FFCC66';
  G_COLOUR_PU_NAME          CONSTANT VARCHAR2(10) := '#99FF99';
  G_COLOUR_OBJECT_NAME      CONSTANT VARCHAR2(10) := '#FFCC00';
  G_COLOUR_PKG_BEGIN        CONSTANT VARCHAR2(10) := '#CCCC00'; 
  G_COLOUR_GO_PAST          CONSTANT VARCHAR2(10) := '#FF9999'; 
  G_COLOUR_BRACKETS         CONSTANT VARCHAR2(10) := '#FF5050'; 
  G_COLOUR_EXCEPTION_BLOCK  CONSTANT VARCHAR2(10) := '#FF9933'; 
  G_COLOUR_JAVA             CONSTANT VARCHAR2(10) := '#33CCCC'; 
  G_COLOUR_UNSUPPORTED      CONSTANT VARCHAR2(10) := '#999966'; 
  G_COLOUR_ANNOTATION       CONSTANT VARCHAR2(10) := '#FFCCFF'; 
  G_COLOUR_BIND_VAR         CONSTANT VARCHAR2(10) := '#FFFF00';
  G_COLOUR_VAR              CONSTANT VARCHAR2(10) := '#99FF66';
  G_COLOUR_NOTE             CONSTANT VARCHAR2(10) := '#00FF99';
  G_COLOUR_VAR_LINE         CONSTANT VARCHAR2(10) := '#00CCFF';

  TYPE var_list_typ IS TABLE OF VARCHAR2(32) INDEX BY VARCHAR2(106);  

  TYPE param_list_typ IS TABLE OF VARCHAR2(106) INDEX BY BINARY_INTEGER;  
 
  --------------------------------------------------------------------
  -- source_weave_now
----------------------------------------------------------------------------------------------- 
/** PUBLIC
* Check existence of @AOP_LOG_WEAVE_NOW tag within the source text of an object
* @param i_owner Object Owner 
* @param i_name  Object Name 
* @param i_type  Object Type 
*/
  function source_weave_now(i_owner varchar2
                           ,i_name  varchar2
                           ,i_type  varchar2) return boolean;


-----------------------------------------------------------------------------------------------
  -- source_reg_mode_debug
----------------------------------------------------------------------------------------------- 
/** PUBLIC
* Check existence of @AOP_REG_MODE_DEBUG tag within the source text of an object
* @param i_owner Object Owner 
* @param i_name  Object Name 
* @param i_type  Object Type 
*/
  function source_reg_mode_debug(i_owner varchar2
                           ,i_name  varchar2
                           ,i_type  varchar2) return boolean;

 
-----------------------------------------------------------------------------------------------
-- during_advise
----------------------------------------------------------------------------------------------- 
/** PUBLIC
* Is the weaver currently performing a weave.
* This function is used purely by the trigger aop_processor_trg to ensure it is NOT triggered by the weaver itself.
* @return TRUE when weaving.
*/
  function during_advise return boolean;
 

-----------------------------------------------------------------------------------------------
-- weave
----------------------------------------------------------------------------------------------- 
/** PUBLIC
* Calls the private weave function with an empty p_var_list
* So that the Apex app can call this for Quick Weave without sending p_var_list          
* @param p_code         source code
* @param p_package_name name of package (optional)
* @param p_for_html     flag to add HTML style tags for apex pretty print
* @param p_end_user     object owner
* @return TRUE if woven successfully.
*/
  function weave ( p_code         in out clob
                 , p_package_name in varchar2
                 , p_for_html     in boolean      default false
                 , p_end_user     in varchar2     default null
                 ) return boolean; 
  
--------------------------------------------------------------------
-- reapply_aspect
--------------------------------------------------------------------  
/** PUBLIC
* Reweave the object
* @param i_object_name  Object Name 
* @param i_versions     Versions of Logger weaving required 'AOP,HTML' or 'HTML,AOP', or 'HTML' or 'AOP'
*/
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL
                         , i_versions    in varchar2 default 'AOP,HTML');

--------------------------------------------------------------------
-- using_aop
--------------------------------------------------------------------  
/** PUBLIC
* Determine whether the woven version is currently installed in the database.
* @return Yes/No
*/
 function using_aop(i_object_name IN VARCHAR2
                   ,i_object_type IN VARCHAR2 DEFAULT 'PACKAGE BODY') return varchar2;
 
end aop_processor;
/
show error;

alter trigger aop_processor_trg enable;