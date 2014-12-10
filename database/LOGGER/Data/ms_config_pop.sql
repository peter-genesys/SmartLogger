REM INSERTING into MS_CONFIG
DELETE FROM MS_CONFIG;
--ACCEPT example CHAR PROMPT "Enter something for this example dynamic config"
--Insert into MS_CONFIG (NAME,VALUE) values ('EXAMPLE','&&example');
 
Insert into MS_CONFIG (NAME,VALUE) values ('ADMIN_EMAIL'        ,'peter.a.burgess@gmail.com');
Insert into MS_CONFIG (NAME,VALUE) values ('EMAIL_FROM'         ,'peter.a.burgess@gmail.com');
 
Insert into MS_CONFIG (NAME,VALUE) values ('TRAWLER_SUBJECT','SmartLogger Error Report');
 
Insert into MS_CONFIG (NAME,VALUE) values ('APEX_SERVER_URL','http://10.10.10.22');
Insert into MS_CONFIG (NAME,VALUE) values ('APEX_PORT'      ,'8080');
Insert into MS_CONFIG (NAME,VALUE) values ('APEX_DIR'       ,'ords');
Insert into MS_CONFIG (NAME,VALUE) values ('KEEP_DAY_COUNT' ,'1');

Insert into MS_CONFIG (NAME,VALUE) values ('LOGGER_WORKSPACE' ,'LOGGER');
Insert into MS_CONFIG (NAME,VALUE) values ('SMTP_MAIL' ,'N');
Insert into MS_CONFIG (NAME,VALUE) values ('APEX_MAIL' ,'Y');


COMMIT;
