REM INSERTING into sm_config
DELETE FROM sm_config;
--ACCEPT example CHAR PROMPT "Enter something for this example dynamic config"
--Insert into sm_config (NAME,VALUE) values ('EXAMPLE','&&example');
 
Insert into sm_config (NAME,VALUE) values ('ADMIN_EMAIL'        ,'myemail@mail.com');
Insert into sm_config (NAME,VALUE) values ('EMAIL_FROM'         ,'myemail@mail.com');
 
Insert into sm_config (NAME,VALUE) values ('TRAWLER_SUBJECT','SmartLogger Error Report');
 
Insert into sm_config (NAME,VALUE) values ('APEX_SERVER_URL','http://10.10.10.22');
Insert into sm_config (NAME,VALUE) values ('APEX_PORT'      ,'8080');
Insert into sm_config (NAME,VALUE) values ('APEX_DIR'       ,'ords');
Insert into sm_config (NAME,VALUE) values ('KEEP_DAY_COUNT' ,'1');

Insert into sm_config (NAME,VALUE) values ('SMTP_MAIL' ,'N');
Insert into sm_config (NAME,VALUE) values ('APEX_MAIL' ,'Y');

Insert into sm_config (NAME,VALUE) values ('LOGGER_WORKSPACE' ,'LOGGER');
Insert into sm_config (NAME,VALUE) values ('LOGGER_APP_ALIAS' ,'SMARTLOGGER_DEV');
Insert into sm_config (NAME,VALUE) values ('PROMO_LEVEL' ,''); 

Insert into sm_config (NAME,VALUE) values ('DEFAULT_AUTO_DEBUG'    ,'Y');
Insert into sm_config (NAME,VALUE) values ('DEFAULT_AUTO_NORMAL'   ,'N');
Insert into sm_config (NAME,VALUE) values ('DEFAULT_AUTO_QUIET'    ,'N');
Insert into sm_config (NAME,VALUE) values ('DEFAULT_AUTO_DISABLED' ,'N');
 
COMMIT;
