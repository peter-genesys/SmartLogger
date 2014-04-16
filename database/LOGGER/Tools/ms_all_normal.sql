prompt reseting module msg_mode and open_process flags to default Normal, Never
update ms_module
set msg_mode     = 2 -- G_MSG_MODE_NORMAL
   ,open_process = 'N'  -- G_OPEN_PROCESS_NEVER
;

update ms_unit
set msg_mode     = NULL -- G_MSG_MODE_DEFAULT 
   ,open_process = NULL  -- G_OPEN_PROCESS_DEFAULT
;

commit;