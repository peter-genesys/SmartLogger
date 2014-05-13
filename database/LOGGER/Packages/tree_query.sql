select case when connect_by_isleaf = 1 then 0
            when level = 1             then 1
            else                           -1
       end as status, 
       level, 
       "MESSAGE" as title, 
       null as icon, 
       "TRAVERSAL_ID" as value, 
       null as tooltip, 
       null as link 
from "MS_TRAVERSAL_MESSAGE_REF_VW"
start with "PARENT_TRAVERSAL_ID" is null
connect by prior "TRAVERSAL_ID" = "PARENT_TRAVERSAL_ID"
order siblings by "MESSAGE_ID"


select case when connect_by_isleaf = 1 then 0
            when level = 1             then 1
            else                           -1
       end as status, 
       level, 
       "MESSAGE" as title, 
       null as icon, 
       "TRAVERSAL_ID" as value, 
       null as tooltip, 
       null as link 
from "#OWNER#"."MS_TRAVERSAL_MESSAGE_REF_VW"
where :P860_START_MESSAGE_ID is null or message_id > (:P860_START_MESSAGE_ID - :P860_MESSAGE_OFFSET)
start with "PARENT_TRAVERSAL_ID" is null
connect by prior "TRAVERSAL_ID" = "PARENT_TRAVERSAL_ID"
order siblings by "MESSAGE_ID"

select case when connect_by_isleaf = 1 then 0
            when level = 1             then 1
            else                           -1
       end as status, 
       level, 
       MESSAGE as title, 
       null as icon, 
       TRAVERSAL_ID as value, 
       null as tooltip, 
       null as link, 
       message_id,
       TRAVERSAL_ID,
       PARENT_TRAVERSAL_ID
from MS_TRAVERSAL_MESSAGE_REF_VW
start with PARENT_TRAVERSAL_ID = 4356 and process_id = 992 and TRAVERSAL_ID = 4357
connect by prior TRAVERSAL_ID = PARENT_TRAVERSAL_ID
order siblings by MESSAGE_ID


SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
FROM ms_unit_traversal_vw
WHERE ext_ref = '&&my_unique_id'
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id;