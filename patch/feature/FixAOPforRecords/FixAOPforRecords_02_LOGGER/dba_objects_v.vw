create or replace view dba_objects_v as 
--This version is for an embedded schema install
select 
  user  as OWNER
 ,uo.*	
from user_objects uo;

desc dba_objects_v
