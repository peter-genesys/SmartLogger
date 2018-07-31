prompt --application/pages/page_00101
begin
wwv_flow_api.create_page(
 p_id=>101
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Login'
,p_alias=>'LOGIN'
,p_page_mode=>'NORMAL'
,p_step_title=>'Login'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(35522151442315895)
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_nav_list_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_cache_timeout_seconds=>21600
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180409221932'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53230650992577616)
,p_plug_name=>'SmartLogger &PROMO_LEVEL.'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35559904151315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY_3'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53230938507577619)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(53230650992577616)
,p_button_name=>'P101_LOGIN'
,p_button_static_id=>'P101_LOGIN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Login'
,p_button_position=>'BODY'
,p_request_source=>'LOGIN'
,p_request_source_type=>'STATIC'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53230760396577618)
,p_name=>'P101_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53230650992577616)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53230861898577619)
,p_name=>'P101_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(53230650992577616)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53231161592577620)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'owa_util.mime_header(''text/html'', FALSE);',
'owa_cookie.send(',
'    name=>''LOGIN_USERNAME_COOKIE'',',
'    value=>lower(:P101_USERNAME));',
'exception when others then null;',
'end;'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53231058205577620)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Login'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'wwv_flow_custom_auth_std.login(',
'    P_UNAME       => :P101_USERNAME,',
'    P_PASSWORD    => :P101_PASSWORD,',
'    P_SESSION_ID  => v(''APP_SESSION''),',
'    P_FLOW_PAGE   => :APP_ID||'':1''',
'    );'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53231346891577620)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53231241616577620)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    v varchar2(255) := null;',
'    c owa_cookie.cookie;',
'begin',
'   c := owa_cookie.get(''LOGIN_USERNAME_COOKIE'');',
'   :P101_USERNAME := c.vals(1);',
'exception when others then null;',
'end;'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(182662502981190425)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetPromoLevel'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF V(''APP_ALIAS'') LIKE ''%DEV'' THEN ',
'  :PROMO_LEVEL := ''DEV'';',
'ELSIF V(''APP_ALIAS'') LIKE ''%TEST'' THEN ',
'  :PROMO_LEVEL := ''TEST'';',
'ELSIF V(''APP_ALIAS'') LIKE ''%PROD'' THEN ',
'  :PROMO_LEVEL := ''PROD'';',
'ELSE',
'  :PROMO_LEVEL := ''?'';',
'END IF;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
end;
/
