REM INSERTING into MS_CONFIG
DELETE FROM MS_CONFIG;
--ACCEPT standalone CHAR DEFAULT true PROMPT "Is this a STANDALONE system (true/false)"
--Insert into MS_CONFIG (NAME,VALUE) values ('STANDALONE','&&standalone');
--ACCEPT doxxy CHAR DEFAULT false PROMPT "Is DOXXY fully installed and working (true/false)"
--Insert into MS_CONFIG (NAME,VALUE) values ('DOXXY','&&doxxy');
--ACCEPT email CHAR DEFAULT false PROMPT "Is EMAIL configured and working (true/false)"
--Insert into MS_CONFIG (NAME,VALUE) values ('EMAIL','&&email');
--ACCEPT jde_host CHAR DEFAULT ozetupp2 PROMPT "Enter the JDE host for TEST or PROD (ozetupp2/ozetupp)"
--Insert into MS_CONFIG (NAME,VALUE) values ('JDE_SERVICES_URL','http://&&jde_host:8500/TuppernetDBService/CustomerManagement');
--ACCEPT proxy_url CHAR PROMPT "Enter a proxy url ()"
--Insert into MS_CONFIG (NAME,VALUE) values ('PROXY_URL','&&proxy_url');
--
----Claim Status and Rule Decision Descriptions
--Insert into MS_CONFIG (NAME,VALUE) values ('REVIEW'  ,'For Review');
--Insert into MS_CONFIG (NAME,VALUE) values ('APPROVED','Claim Accepted');
--Insert into MS_CONFIG (NAME,VALUE) values ('REJECTED','Claim Declined');
--
----Progress Status Descriptions
--Insert into MS_CONFIG (NAME,VALUE) values ('CREATED'   ,'Claim Submitted');
--Insert into MS_CONFIG (NAME,VALUE) values ('AWAITING'  ,'Awaiting Review');
--Insert into MS_CONFIG (NAME,VALUE) values ('REVIEWED'  ,'Claim Reviewed');
--Insert into MS_CONFIG (NAME,VALUE) values ('PROCESSING','Accepted claim items are being Processed');
--Insert into MS_CONFIG (NAME,VALUE) values ('DISPATCHED','Accepted claim items have been Shipped');
--Insert into MS_CONFIG (NAME,VALUE) values ('COMPLETED' ,'Warranty Claim is Finalised');
--
--
--Insert into MS_CONFIG (NAME,VALUE) values ('OOPS' 
--	,'Oops!  This is embarrassing.  We''ve noted this error, and we''ll fix the problem ASAP.');

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
