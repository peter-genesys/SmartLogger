create or replace view dba_objects_v as 
--This version is for a separate schema install
select *
from dba_objects;

desc dba_objects_v
