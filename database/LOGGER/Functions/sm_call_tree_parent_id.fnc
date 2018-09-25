create or replace function sm_call_tree_parent_id(i_node_type       in varchar2
                                                 ,i_app_id          in number
                                                 ,i_app_page_id     in number
                                                 ,i_call_id         in number
                                                 ,i_parent_id       in varchar2  ) return varchar2 is
  cursor cu_parent_app is
  select id 
  from  sm_extra_nodes_v
  where node_type = 'APP'
  and   app_id   = i_app_id
  and   call_id  <= i_call_id
  order by call_id desc ;

  cursor cu_parent_page is
  select id 
  from  sm_extra_nodes_v
  where node_type = 'PAGE'
  and   app_id       = i_app_id
  and   app_page_id  = i_app_page_id
  and   call_id  <= i_call_id
  order by call_id desc ;

  l_parent_id varchar2(100);
  l_call_id   number;

begin
  CASE 
    WHEN i_node_type IN ('SESSION','CLONE','APP','CALL') then 
      --Parent Id is already correct for these.
      return i_parent_id;

    WHEN i_node_type = 'PAGE' then 
      --Get id from the latest app for this call_id
      open cu_parent_app;
      fetch cu_parent_app into l_parent_id;
      close cu_parent_app;

      return l_parent_id;
  
    WHEN i_node_type = 'TOPCALL' then 
      --Get id the latest page for this call_id
      open cu_parent_page;
      fetch cu_parent_page into l_parent_id;
      close cu_parent_page;

      return l_parent_id;

    ELSE 
      raise_application_error(-20000,'Unknown node type: '||i_node_type);
  END CASE;    
 
end;
/