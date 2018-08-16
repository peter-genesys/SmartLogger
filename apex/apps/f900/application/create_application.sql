prompt --application/create_application
begin
wwv_flow_api.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_display_id=>nvl(wwv_flow_application_install.get_application_id,900)
,p_owner=>nvl(wwv_flow_application_install.get_schema,'PACMAN')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'SmartLogger')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'SMARTLOGGER')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt_last_reset=>'20180816225722'
,p_bookmark_checksum_function=>'MD5'
,p_max_session_length_sec=>28800
,p_compatibility_mode=>'5.1'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'0'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication=>'PLUGIN'
,p_authentication_id=>wwv_flow_api.id(53230059095577613)
,p_logout_url=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1'
,p_application_tab_set=>0
,p_logo_image=>'TEXT:&APP_LOGO.'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=> nvl(wwv_flow_application_install.get_proxy,'')
,p_flow_version=>'release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_deep_linking=>'Y'
,p_runtime_api_usage=>'T:O:W'
,p_authorize_public_pages_yn=>'Y'
,p_rejoin_existing_sessions=>'P'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_substitution_string_01=>'ALIAS_DEV'
,p_substitution_value_01=>'SMARTLOGGER_DEV'
,p_substitution_string_02=>'ALIAS_TEST'
,p_substitution_value_02=>'SMARTLOGGER_TEST'
,p_substitution_string_03=>'ALIAS_PROD'
,p_substitution_value_03=>'SMARTLOGGER_PROD'
,p_substitution_string_04=>'APP_ID_DEV'
,p_substitution_value_04=>'900'
,p_substitution_string_05=>'APP_ID_TEST'
,p_substitution_value_05=>'901'
,p_substitution_string_06=>'APP_ID_PROD'
,p_substitution_value_06=>'902'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180816225722'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_ui_type_name => null
);
end;
/
