create or replace package aop_processor
is
  function during_advise return boolean;
  
  --procedure save_source(i_object_name IN VARCHAR2
  --                    , i_log_flag    IN VARCHAR2
  --                    , i_text        IN CLOB );
  
  procedure advise_package
  ( p_object_name   in varchar2
  , p_object_type   in varchar2
  , p_object_owner  in varchar2
  );
  
  procedure reapply_aspect
  ( p_aspect in varchar2 -- for example LOG
  );


end aop_processor;
/
