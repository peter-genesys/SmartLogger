prompt resetting module msg_mode and open_process flags for quiet messaging
update ms_module
set msg_mode     = 4 -- G_MSG_MODE_QUIET 
   ,open_process = 'N'  -- G_OPEN_PROCESS_NEVER
;

update ms_unit
set msg_mode     = NULL -- G_MSG_MODE_DEFAULT 
   ,open_process = NULL  -- G_OPEN_PROCESS_DEFAULT
;

commit;