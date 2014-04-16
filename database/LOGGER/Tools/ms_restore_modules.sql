update ms_module m
set msg_mode = 1,open_process = 'C'
where exists
(select 1 from ms_module_backup
where module_id = m.module_id
and msg_mode = 1 and open_process = 'C');