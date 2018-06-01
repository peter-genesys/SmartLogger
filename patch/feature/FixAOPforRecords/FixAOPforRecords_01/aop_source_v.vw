create or replace view aop_source_v as 
select 
 orig.name                name       
,orig.type                type 
,orig.valid_yn            orig_valid_yn
,orig.text                orig_text     
,orig.result              orig_result   
,orig.load_datetime       orig_load_datetime
,aop.valid_yn             aop_valid_yn
,aop.text                 aop_text     
,aop.result               aop_result   
,aop.load_datetime        aop_load_datetime
,aop_html.text            html_text  
,aop_html.load_datetime   html_load_datetime  
,aop_processor.using_aop(i_object_name => orig.name
                       , i_object_type => orig.type) using_aop
,DBMS_METADATA.GET_DDL (
    object_type => DECODE(orig.type,'PACKAGE BODY','PACKAGE_BODY',orig.type)
   ,name        => orig.name 
   ,schema      => orig.owner) installed_text
from aop_source orig
    ,aop_source aop
	,aop_source aop_html
where orig.aop_ver = 'ORIG'
and   orig.name = aop.name (+)
and   orig.type = aop.type (+)
and   NVL(aop.aop_ver (+),'AOP') = 'AOP'
and   orig.name = aop_html.name (+)  
and   orig.type = aop_html.type (+) 
and   NVL(aop_html.aop_ver (+),'AOP_HTML') = 'AOP_HTML';


