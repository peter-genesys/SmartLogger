prompt reseting module msg_mode and open_process flags to default Normal, Never
update ms_module
set msg_mode     = 1 -- G_MSG_MODE_DEBUG
   ,open_process = 'C'  -- G_OPEN_IF_CLOSED
;

update ms_unit
set msg_mode     = NULL -- G_MSG_MODE_DEFAULT 
   ,open_process = NULL  -- G_OPEN_PROCESS_DEFAULT
;

commit;