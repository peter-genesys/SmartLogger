create or replace view aop_source_v as 
select 
 orig.name           name       
,orig.type           type 
,orig.valid_yn       orig_valid_yn
,orig.text           orig_text     
,orig.result         orig_result   
,orig.load_datetime  orig_load_datetime
,aop.valid_yn        aop_valid_yn
,aop_html.text       aop_text     
,aop.result          aop_result   
,aop.load_datetime   aop_load_datetime
from aop_source orig
    ,aop_source aop
	,aop_source aop_html
where orig.aop_ver = 'ORIG'
and   orig.name = aop.name  
and   orig.type = aop.type  
and   NVL(aop.aop_ver,'AOP') = 'AOP'
and   orig.name = aop_html.name  
and   orig.type = aop_html.type  
and   NVL(aop_html.aop_ver,'AOP_HTML') = 'AOP_HTML';