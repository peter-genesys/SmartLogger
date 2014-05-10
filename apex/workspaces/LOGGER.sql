set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
begin
select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';
execute immediate 'alter session set nls_numeric_characters=''.,''';
end;
/
prompt  WORKSPACE 2336619886530720
--
-- Workspace, User Group, User, and Team Development Export:
--   Date and Time:   15:22 Friday May 9, 2014
--   Exported By:     ADMIN
--   Export Type:     Workspace Export
--   Version:         4.2.5.00.08
--   Instance ID:     69419748294856
--
-- Import:
--   Using Instance Administration / Manage Workspaces
--   or
--   Using SQL*Plus as the Oracle user APEX_040200
 
begin
    wwv_flow_api.set_security_group_id(p_security_group_id=>2336619886530720);
end;
/
----------------
-- W O R K S P A C E
-- Creating a workspace will not create database schemas or objects.
-- This API creates only the meta data for this APEX workspace
prompt  Creating workspace LOGGER...
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
end;
/
begin
wwv_flow_fnd_user_api.create_company (
  p_id => 2336718759530739
 ,p_provisioning_company_id => 2336619886530720
 ,p_short_name => 'LOGGER'
 ,p_display_name => 'LOGGER'
 ,p_first_schema_provisioned => 'LOGGER'
 ,p_company_schemas => 'LOGGER'
 ,p_ws_schema => 'LOGGER'
 ,p_account_status => 'ASSIGNED'
 ,p_allow_plsql_editing => 'Y'
 ,p_allow_app_building_yn => 'Y'
 ,p_allow_sql_workshop_yn => 'Y'
 ,p_allow_websheet_dev_yn => 'Y'
 ,p_allow_team_development_yn => 'Y'
 ,p_allow_to_be_purged_yn => 'Y'
 ,p_allow_restful_services_yn => 'Y'
 ,p_source_identifier => 'LOGGER'
 ,p_path_prefix => 'LOGGER'
 ,p_workspace_image => wwv_flow_api.g_varchar2_table
);
end;
/
----------------
-- G R O U P S
--
prompt  Creating Groups...
----------------
-- U S E R S
-- User repository for use with APEX cookie-based authentication.
--
prompt  Creating Users...
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id      => '2336530070530720',
  p_user_name    => 'ADMIN',
  p_first_name   => 'Kevin',
  p_last_name    => 'Hand',
  p_description  => '',
  p_email_address=> 'kevin.hand@flightcentre.com.au',
  p_web_password => '700E49BCDBBC84AECA091565C1E0C9A0',
  p_web_password_format => 'HEX_ENCODED_DIGEST_V2',
  p_group_ids                    => '',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => 'LOGGER',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('201405051359','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'Y',
  p_first_password_use_occurred  => 'Y',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_websheet_dev_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id      => '2457015213655872',
  p_user_name    => 'HANDK',
  p_first_name   => 'Kevin',
  p_last_name    => 'Hand',
  p_description  => '',
  p_email_address=> 'kevin.hand@flightcentre.com.au',
  p_web_password => '0EAB8714E1E4F972050799D9FCBFD412',
  p_web_password_format => 'HEX_ENCODED_DIGEST_V2',
  p_group_ids                    => '',
  p_developer_privs              => 'CREATE:EDIT:HELP:MONITOR:SQL:MONITOR:DATA_LOADER',
  p_default_schema               => 'LOGGER',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('201405050000','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'Y',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_websheet_dev_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id      => '2456532398651363',
  p_user_name    => 'PBURGESS',
  p_first_name   => 'Peter',
  p_last_name    => 'Burgess',
  p_description  => '',
  p_email_address=> 'peter.a.burgess@gmail.com',
  p_web_password => '6F7B59F140C257210FA4DAD33DF09BEC',
  p_web_password_format => 'HEX_ENCODED_DIGEST_V2',
  p_group_ids                    => '',
  p_developer_privs              => 'CREATE:EDIT:HELP:MONITOR:SQL:MONITOR:DATA_LOADER',
  p_default_schema               => 'LOGGER',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('201405050000','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_websheet_dev_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
----------------
--Application Builder Preferences
--
----------------
--Click Count Logs
--
----------------
--csv data loading
--
----------------
--mail
--
----------------
--mail log
--
----------------
--app models
--
----------------
--password history
--
begin
  wwv_flow_api.create_password_history (
    p_id => 2336812089530745,
    p_user_id => 2336530070530720,
    p_password => 'D5A55D3FC44ED6F7D5B1B559A5B9FFC8');
end;
/
begin
  wwv_flow_api.create_password_history (
    p_id => 2450606715539897,
    p_user_id => 2336530070530720,
    p_password => 'C3955427D1A47C745883F3763609F09A');
end;
/
begin
  wwv_flow_api.create_password_history (
    p_id => 2456632128651364,
    p_user_id => 2456532398651363,
    p_password => '84B922E79197D8A08CC3940BBDB75608');
end;
/
begin
  wwv_flow_api.create_password_history (
    p_id => 2457122423655872,
    p_user_id => 2457015213655872,
    p_password => 'A9ABE95C6931B78755F047380C795250');
end;
/
----------------
--preferences
--
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2455703685634101,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP_IR_104_P2_W2570108625994254',
    p_attribute_value => '2570813248994452____2570813248994452');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2455912299645290,
    p_user_id => 'ADMIN',
    p_preference_name => 'PERSISTENT_ITEM_P1_DISPLAY_MODE',
    p_attribute_value => 'ICONS');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2456004292645306,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP_IR_4000_P1_W3326806401130228',
    p_attribute_value => '3328003692130542____3328003692130542');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2456120533645329,
    p_user_id => 'ADMIN',
    p_preference_name => 'FB_FLOW_ID',
    p_attribute_value => '104');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2732707827403905,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P300_R274135113431934049_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2732810597404703,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P423_R172114705298474212_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2732913367405565,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P653_R172116901966482713_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2733022025408008,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P675_R172118613741486068_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2735707265763283,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P796_R185991323167292111_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2456310790646063,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP_IR_4350_P55_W10236304983033455',
    p_attribute_value => '10238325656034902____10238325656034902');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2457403055699668,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP104_P9_R17797158749021547_SORT',
    p_attribute_value => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2457504440700055,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP104_P8_R17791439222976199_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2458332609700058,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_104_P8_W17784432860976193',
    p_attribute_value => '17788439880976196____17787661063976195');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2458521739701719,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_104_P2_W2570108625994254',
    p_attribute_value => '2570813248994452____2570813248994452');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2516824202711586,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_4000_P1500_W3519715528105919',
    p_attribute_value => '3521529006112497____3521529006112497');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2517023771711740,
    p_user_id => 'PBURGESS',
    p_preference_name => 'PERSISTENT_ITEM_P1_DISPLAY_MODE',
    p_attribute_value => 'ICONS');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2517123798711754,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_4000_P1_W3326806401130228',
    p_attribute_value => '3328003692130542____3328003692130542');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2517210627711762,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FB_FLOW_ID',
    p_attribute_value => '104');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2517418810714023,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_4000_P4047_W184800502564237029',
    p_attribute_value => '184804717913266027____184804717913266027');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2603013628983343,
    p_user_id => 'PBURGESS',
    p_preference_name => 'USE_TREE_ON_P4150',
    p_attribute_value => 'N');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2728201360910110,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P582_R108017116347018440_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2762017195974895,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P195_R225787614827384691_SORT',
    p_attribute_value => 'fsp_sort_2_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2770107629331669,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P4410_R48467930491898431_SORT',
    p_attribute_value => 'fsp_sort_2_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2770216347331672,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P4410_R29873113508481210_SORT',
    p_attribute_value => 'fsp_sort_2_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2770300595331682,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P4410_R48655727964692661_SORT',
    p_attribute_value => 'fsp_sort_4_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2450907857541079,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP_IR_4000_P1500_W3519715528105919',
    p_attribute_value => '3521529006112497____3521529006112497');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2770016994331434,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_4000_P4400_W27796519609844319',
    p_attribute_value => '27798220762844327____27798220762844327');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2454604562633788,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP104_P9_R17797158749021547_SORT',
    p_attribute_value => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2454704908633942,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP104_P8_R17791439222976199_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2455515763633952,
    p_user_id => 'ADMIN',
    p_preference_name => 'FSP_IR_104_P8_W17784432860976193',
    p_attribute_value => '17787661063976195____17787661063976195');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2479222476282333,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP104_P10_R17802441101031118_SORT',
    p_attribute_value => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2702312719392763,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_104_P1_W',
    p_attribute_value => '____');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2735807957763501,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P797_R186034418786574670_SORT',
    p_attribute_value => 'fsp_sort_1_desc');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2769812046318514,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP_IR_4000_P4445_W14886206368621919',
    p_attribute_value => '14887631485621929____');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 2733526873409486,
    p_user_id => 'PBURGESS',
    p_preference_name => 'FSP4000_P591_R168263311862841256_SORT',
    p_attribute_value => 'fsp_sort_3');
end;
/
----------------
--service mods
--
----------------
--query builder
--
----------------
--sql scripts
--
----------------
--sql commands
--
----------------
--user access log
--
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405061326','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405051426','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405061408','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'ADMIN',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405051359','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405060954','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'ADMIN',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405051359','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 5,
    p_custom_status_text => 'Invalid Login Credentials');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405051425','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 4,
    p_custom_status_text => 'Invalid Login Credentials');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405060921','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405061721','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log1$ (
    p_login_name => 'ADMIN',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405051415','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405071618','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405081328','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405081721','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405090858','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405091406','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405080915','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405081723','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405071024','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405081730','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405091403','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405081107','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405081254','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405081734','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405090906','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Application Express',
    p_app => 104,
    p_owner => 'LOGGER',
    p_access_date => to_date('201405070930','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405071314','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'PBURGESS',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_040200',
    p_access_date => to_date('201405080841','YYYYMMDDHH24MI'),
    p_ip_address => '10.27.142.51',
    p_remote_user => 'ANONYMOUS',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
prompt Check Compatibility...
begin
-- This date identifies the minimum version required to import this file.
wwv_flow_team_api.check_version(p_version_yyyy_mm_dd=>'2010.05.13');
end;
/
 
begin wwv_flow.g_import_in_progress := true; wwv_flow.g_user := USER; end; 
/
 
--
prompt ...news
--
begin
null;
end;
/
--
prompt ...links
--
begin
null;
end;
/
--
prompt ...bugs
--
begin
null;
end;
/
--
prompt ...events
--
begin
null;
end;
/
--
prompt ...features
--
begin
null;
end;
/
--
prompt ...tasks
--
begin
null;
end;
/
--
prompt ...feedback
--
begin
null;
end;
/
--
prompt ...task defaults
--
begin
null;
end;
/
 
prompt ...RESTful Services
 
 
begin
 
wwv_flow_api.remove_restful_service (
  p_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_name => 'oracle.example.hr'
  );
 
null;
 
end;
/

prompt  ...restful service
--
--application/restful_services/oracle_example_hr
 
begin
 
wwv_flow_api.create_restful_module (
  p_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_name => 'oracle.example.hr'
 ,p_uri_prefix => 'hr/'
 ,p_parsing_schema => 'LOGGER'
 ,p_items_per_page => 10
 ,p_status => 'PUBLISHED'
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2338525615530777 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'empinfo/'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2338602419530777 + wwv_flow_api.g_id_offset
 ,p_template_id => 2338525615530777 + wwv_flow_api.g_id_offset
 ,p_source_type => 'QUERY'
 ,p_format => 'CSV'
 ,p_method => 'GET'
 ,p_require_https => 'NO'
 ,p_source => 
'select * from emp'
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2337225403530776 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'employees/'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2337328432530776 + wwv_flow_api.g_id_offset
 ,p_template_id => 2337225403530776 + wwv_flow_api.g_id_offset
 ,p_source_type => 'QUERY'
 ,p_format => 'DEFAULT'
 ,p_method => 'GET'
 ,p_items_per_page => 7
 ,p_require_https => 'NO'
 ,p_source => 
'select empno "$uri", empno, ename'||unistr('\000a')||
'  from ('||unistr('\000a')||
'       select emp.*'||unistr('\000a')||
'            , row_number() over (order by empno) rn'||unistr('\000a')||
'         from emp'||unistr('\000a')||
'       ) tmp'||unistr('\000a')||
' where rn between :row_offset and :row_count '
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2337423820530776 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'employees/{id}'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2337514947530776 + wwv_flow_api.g_id_offset
 ,p_template_id => 2337423820530776 + wwv_flow_api.g_id_offset
 ,p_source_type => 'QUERY_1_ROW'
 ,p_format => 'DEFAULT'
 ,p_method => 'GET'
 ,p_require_https => 'NO'
 ,p_source => 
'select * from emp'||unistr('\000a')||
' where empno = :id'
  );
 
wwv_flow_api.create_restful_param (
  p_id => 2337611357530777 + wwv_flow_api.g_id_offset
 ,p_handler_id => 2337514947530776 + wwv_flow_api.g_id_offset
 ,p_name => 'ID'
 ,p_bind_variable_name => 'ID'
 ,p_source_type => 'HEADER'
 ,p_access_method => 'IN'
 ,p_param_type => 'STRING'
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2337726071530777 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'employeesfeed/'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2337818166530777 + wwv_flow_api.g_id_offset
 ,p_template_id => 2337726071530777 + wwv_flow_api.g_id_offset
 ,p_source_type => 'FEED'
 ,p_format => 'DEFAULT'
 ,p_method => 'GET'
 ,p_items_per_page => 25
 ,p_require_https => 'NO'
 ,p_source => 
'select empno, ename from emp order by deptno, ename'
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2337910291530777 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'employeesfeed/{id}'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2338010305530777 + wwv_flow_api.g_id_offset
 ,p_template_id => 2337910291530777 + wwv_flow_api.g_id_offset
 ,p_source_type => 'QUERY'
 ,p_format => 'CSV'
 ,p_method => 'GET'
 ,p_require_https => 'NO'
 ,p_source => 
'select * from emp where empno = :id'
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2338120722530777 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'empsec/{empname}'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2338225705530777 + wwv_flow_api.g_id_offset
 ,p_template_id => 2338120722530777 + wwv_flow_api.g_id_offset
 ,p_source_type => 'QUERY'
 ,p_format => 'DEFAULT'
 ,p_method => 'GET'
 ,p_require_https => 'NO'
 ,p_source => 
'select empno, ename, deptno, job from emp '||unistr('\000a')||
'	where ((select job from emp where ename = :empname) IN (''PRESIDENT'', ''MANAGER'')) '||unistr('\000a')||
'    OR  '||unistr('\000a')||
'    (deptno = (select deptno from emp where ename = :empname)) '||unistr('\000a')||
'order by deptno, ename'||unistr('\000a')||
''
  );
 
wwv_flow_api.create_restful_template (
  p_id => 2338320610530777 + wwv_flow_api.g_id_offset
 ,p_module_id => 2337113679530775 + wwv_flow_api.g_id_offset
 ,p_uri_template => 'empsecformat/{empname}'
 ,p_priority => 0
 ,p_etag_type => 'HASH'
  );
 
wwv_flow_api.create_restful_handler (
  p_id => 2338409610530777 + wwv_flow_api.g_id_offset
 ,p_template_id => 2338320610530777 + wwv_flow_api.g_id_offset
 ,p_source_type => 'PLSQL'
 ,p_format => 'DEFAULT'
 ,p_method => 'GET'
 ,p_require_https => 'NO'
 ,p_source => 
'DECLARE'||unistr('\000a')||
'  prevdeptno   number;'||unistr('\000a')||
'  deptloc      varchar2(30);'||unistr('\000a')||
'  deptname     varchar2(30);'||unistr('\000a')||
'  CURSOR getemps IS select * from emp '||unistr('\000a')||
'                     where ((select job from emp where ename = :empname)  IN (''PRESIDENT'', ''MANAGER'')) '||unistr('\000a')||
'                        or deptno = (select deptno from emp where ename = :empname) '||unistr('\000a')||
'                     order by deptno, ename;'||unistr('\000a')||
'BEGIN'||unistr('\000a')||
'  sys.htp.htmlopen;'||unistr('\000a')||
'  sys.htp.he'||
'adopen;'||unistr('\000a')||
'  sys.htp.title(''Departments'');'||unistr('\000a')||
'  sys.htp.headclose;'||unistr('\000a')||
'  sys.htp.bodyopen;'||unistr('\000a')||
' '||unistr('\000a')||
'  for emprecs in getemps'||unistr('\000a')||
'  loop'||unistr('\000a')||
''||unistr('\000a')||
'      if emprecs.deptno != prevdeptno or prevdeptno is null then'||unistr('\000a')||
'          select dname, loc into deptname, deptloc '||unistr('\000a')||
'            from dept where deptno = (select deptno from emp where ename = emprecs.ename);'||unistr('\000a')||
'          if prevdeptno is not null then'||unistr('\000a')||
'              sys.htp.print(''</ul>'''||
');'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'          sys.htp.print(''Department '' || deptname || '' located in '' || deptloc || ''<p/>'');'||unistr('\000a')||
'          sys.htp.print(''<ul>'');'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      sys.htp.print(''<li>'' || emprecs.ename || '', '' || emprecs.job || '', '' || emprecs.sal || ''</li>'');'||unistr('\000a')||
''||unistr('\000a')||
'      prevdeptno := emprecs.deptno;'||unistr('\000a')||
''||unistr('\000a')||
'  end loop;'||unistr('\000a')||
'  sys.htp.print(''</ul>'');'||unistr('\000a')||
'  sys.htp.bodyclose;'||unistr('\000a')||
'  sys.htp.htmlclose;'||unistr('\000a')||
'END;'||unistr('\000a')||
''
  );
 
null;
 
end;
/

-- SET SCHEMA
 
begin
 
   wwv_flow_api.g_id_offset := 0;
   wwv_flow_hint.g_schema   := 'LOGGER';
   wwv_flow_hint.check_schema_privs;
 
end;
/

 
--------------------------------------------------------------------
prompt  SCHEMA LOGGER - User Interface Defaults, Table Defaults
--
-- Import using sqlplus as the Oracle user: APEX_040200
-- Exported 15:22 Friday May 9, 2014 by: ADMIN
--
 
--------------------------------------------------------------------
prompt User Interface Defaults, Attribute Dictionary
--
-- Exported 15:22 Friday May 9, 2014 by: ADMIN
--
-- SHOW EXPORTING WORKSPACE
 
begin
 
   wwv_flow_api.g_id_offset := 0;
   wwv_flow_hint.g_exp_workspace := 'LOGGER';
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
