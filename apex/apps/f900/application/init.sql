set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
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
--   Version:         5.1.4.00.08
--   Instance ID:     63712309566204
--

-- Application Statistics:
--   Pages:                     19
--     Items:                   44
--     Validations:              1
--     Processes:               39
--     Regions:                 53
--     Buttons:                 59
--     Dynamic Actions:         24
--   Shared Components:
--     Logic:
--       Items:                  5
--     Navigation:
--       Lists:                  2
--       Breadcrumbs:            1
--         Entries:             16
--       NavBar Entries:         1
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
--       Plug-ins:               5
--     Globalization:
--     Reports:
--   Supporting Objects:  Excluded

