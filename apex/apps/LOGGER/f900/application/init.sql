set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.05.24'
,p_release=>'18.2.0.00.12'
,p_default_workspace_id=>12287443100895424
,p_default_application_id=>900
,p_default_owner=>'LOGGEROWN'
);
end;
/
 
prompt APPLICATION 900 - SmartLogger
--
-- Application Export:
--   Application:     900
--   Name:            SmartLogger
--   Exported By:     LOGGEROWN
--   Flashback:       0
--   Export Type:     Application Export
--   Version:         18.2.0.00.12
--   Instance ID:     248249685159480
--

-- Application Statistics:
--   Pages:                     22
--     Items:                   52
--     Validations:              1
--     Processes:               44
--     Regions:                 60
--     Buttons:                 63
--     Dynamic Actions:         27
--   Shared Components:
--     Logic:
--       Items:                  8
--     Navigation:
--       Lists:                  2
--       Breadcrumbs:            1
--         Entries:             17
--       NavBar Entries:         2
--     Security:
--       Authentication:         3
--     User Interface:
--       Themes:                 1
--       Templates:
--         Page:                 9
--         Region:              15
--         Label:                5
--         List:                11
--         Popup LOV:            1
--         Calendar:             1
--         Breadcrumb:           1
--         Button:               3
--         Report:               9
--       Shortcuts:              5
--       Plug-ins:               6
--     Globalization:
--     Reports:
--     E-Mail:
--   Supporting Objects:  Excluded

