alter trigger aop_processor_trg disable;

create or replace package aop_processor AUTHID CURRENT_USER 
is
  function during_advise return boolean;
 
  function weave
  ( p_code in out clob
  , p_package_name in varchar2
  , p_for_html in boolean default false
  ) return boolean;
 
 
  procedure advise_package
  ( p_object_name   in varchar2
  , p_object_type   in varchar2
  , p_object_owner  in varchar2
  );
  
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL);
  
  
  --------------------------------------------------------------------
  -- remove_comments
  -- www.orafaq.com/forum/t/99722/2/ discussion of alternative methods.
  --------------------------------------------------------------------
  
    procedure remove_comments( io_code     in out clob );
	--function remove_comments( i_code in clob ) return clob;


end aop_processor;
/
show error;

alter trigger aop_processor_trg enable;