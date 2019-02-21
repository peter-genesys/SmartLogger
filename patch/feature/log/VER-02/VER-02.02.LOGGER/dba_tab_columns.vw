create or replace view dba_tab_columns as 
--This version is for an embedded schema install
select 
  user  as OWNER
 ,utc.*
from user_tab_columns utc;

desc dba_tab_columns
