create or replace view dba_source_v as 
select 
  user  as OWNER
 ,us.*
from user_source us;

desc dba_source_v
