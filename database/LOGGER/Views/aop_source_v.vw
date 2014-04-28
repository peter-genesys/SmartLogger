create or replace view aop_source_v as 
select 
 orig.name           name       
,orig.type           type 
,orig.valid_yn       orig_valid_yn
,orig.text           orig_text     
,orig.result         orig_result   
,orig.load_datetime  orig_load_datetime
,aop.valid_yn        aop_valid_yn
,aop.text            aop_text     
,aop.result          aop_result   
,aop.load_datetime   aop_load_datetime
from aop_source orig
    ,aop_source aop
where orig.name = aop.name (+)
and   orig.type = aop.type (+)
and   orig.aop_yn = 'N'
and   NVL(aop.aop_yn,'Y') = 'Y';