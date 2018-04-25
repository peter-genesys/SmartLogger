alter trigger aop_processor_trg disable;

create or replace package aop_processor AUTHID CURRENT_USER 
is

  --------------------------------------------------------------------
  -- source_weave_now
  --------------------------------------------------------------------
  function source_weave_now(i_owner varchar2
                           ,i_name  varchar2
                           ,i_type  varchar2) return boolean;
  --------------------------------------------------------------------
  -- source_reg_mode_debug
  --------------------------------------------------------------------
  function source_reg_mode_debug(i_owner varchar2
                           ,i_name  varchar2
                           ,i_type  varchar2) return boolean;

  function during_advise return boolean;
 
  function weave
  ( p_code         in out clob
  , p_package_name in varchar2
  , p_for_html     in boolean default false
  , p_end_user     in varchar2 default null
  ) return boolean; 
 
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL
                         , i_versions    in varchar2 default 'AOP,HTML');

 function using_aop(i_object_name IN VARCHAR2
                   ,i_object_type IN VARCHAR2 DEFAULT 'PACKAGE BODY') return varchar2;
 
end aop_processor;
/
show error;

alter trigger aop_processor_trg enable;