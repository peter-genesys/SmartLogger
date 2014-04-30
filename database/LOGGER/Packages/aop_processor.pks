alter trigger aop_processor_trg disable;

create or replace package aop_processor
is
  function during_advise return boolean;
 
  function weave
  ( p_code in out clob
  , p_package_name in varchar2
  ) return boolean;
 
 
  procedure advise_package
  ( p_object_name   in varchar2
  , p_object_type   in varchar2
  , p_object_owner  in varchar2
  );
  
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL);


end aop_processor;
/
show error;

alter trigger aop_processor_trg enable;