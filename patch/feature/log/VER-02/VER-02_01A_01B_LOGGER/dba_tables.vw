create or replace view dba_tables as 
--This version is for an embedded schema install
select 
  user  as OWNER
 ,ut.*
from user_tables ut;

desc dba_tables
