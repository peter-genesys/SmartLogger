create or replace view sm_session_v3 as
select  APP_SESSION
       ,PARENT_APP_SESSION                         
       ,lower(max(replace(APP_USER,'nobody','NOBODY'))) APP_USER --pick "nobody" last              
       ,min(APP_USER_FULLNAME)   APP_USER_FULLNAME         
       ,min(APP_USER_EMAIL)      APP_USER_EMAIL           
       ,(select FIRST_VALUE(app_id) IGNORE NULLS OVER (PARTITION BY app_session ORDER BY session_id) 
         from  sm_session_v2 x where x.APP_SESSION = s.APP_SESSION and rownum = 1) app_id
       ,max(INTERNAL_ERROR)      INTERNAL_ERROR   
       ,min(CREATED_DATE)        CREATED_DATE                    
       ,max(UPDATED_DATE)        UPDATED_DATE
       ,sum(WARNING_COUNT)         WARNING_COUNT           
       ,sum(EXCEPTION_COUNT)       EXCEPTION_COUNT
       ,sum(MESSAGE_COUNT)       MESSAGE_COUNT       
from  sm_session_v2   s 
where  APP_SESSION is not null
group by app_session,PARENT_APP_SESSION;



