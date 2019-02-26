prompt --application/pages/page_00009
begin
wwv_flow_api.create_page(
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_tab_set=>'TS1'
,p_name=>'Logger Control'
,p_step_title=>'Logger Control'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Modules Registry'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_autocomplete_on_off=>'ON'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_nav_list_template_options=>'#DEFAULT#'
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180807143239'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(53266261772667692)
,p_name=>'Modules'
,p_template=>wwv_flow_api.id(35560371291315922)
,p_display_sequence=>15
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY_3'
,p_source_type=>'NATIVE_TABFORM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'"MODULE_ID",',
'"MODULE_ID" MODULE_ID_DISPLAY,',
'"MODULE_NAME",',
'"REVISION",',
'"MODULE_TYPE",',
'auto_wake,',
'auto_msg_mode,',
'manual_msg_mode',
'from "#OWNER#"."SM_MODULE"',
'where owner = :P9_OWNER',
''))
,p_fixed_header=>'NONE'
,p_query_row_template=>wwv_flow_api.id(35580946704315935)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'(null)'
,p_query_break_cols=>'0'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_item=>'P9_NUM_ROWS'
,p_query_num_rows_type=>'ROW_RANGES_IN_SELECT_LIST'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_break_type_flag=>'DEFAULT_BREAK_FORMATTING'
,p_csv_output=>'N'
,p_query_asc_image=>'apex/builder/dup.gif'
,p_query_asc_image_attr=>'width="16" height="16" alt="" '
,p_query_desc_image=>'apex/builder/ddown.gif'
,p_query_desc_image_attr=>'width="16" height="16" alt="" '
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53266551053667692)
,p_query_column_id=>1
,p_column_alias=>'MODULE_ID'
,p_column_display_sequence=>2
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_display_as=>'HIDDEN'
,p_pk_col_source_type=>'S'
,p_pk_col_source=>'SM_MODULE_SEQ'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_table_name=>'SM_MODULE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53266660796667692)
,p_query_column_id=>2
,p_column_alias=>'MODULE_ID_DISPLAY'
,p_column_display_sequence=>9
,p_column_heading=>'Edit Units'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_MODULE_ID,P10_MODULE_NAME:#MODULE_ID#,#MODULE_NAME#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#ed-item.gif" alt="">'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_table_name=>'SM_MODULE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53266754675667692)
,p_query_column_id=>3
,p_column_alias=>'MODULE_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Module Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_table_name=>'SM_MODULE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53266841569667692)
,p_query_column_id=>4
,p_column_alias=>'REVISION'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_ref_table_name=>'SM_MODULE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53266959538667692)
,p_query_column_id=>5
,p_column_alias=>'MODULE_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Module Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:Package;PACKAGE,Procedure;PROCEDURE,Function;FUNCTION,Trigger;TRIGGER,Oracle Report;REPORT,Oracle Form;FORM,Oracle Report PLSQL Library;REPORT_LIB,Oracle Form PLSQL Library;FORM_LIB,Apex App;APEX,Script;SCRIPT'
,p_lov_show_nulls=>'NO'
,p_derived_column=>'N'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
,p_ref_table_name=>'SM_MODULE'
,p_ref_column_name=>'MODULE_TYPE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(48967948546084226)
,p_query_column_id=>6
,p_column_alias=>'AUTO_WAKE'
,p_column_display_sequence=>6
,p_column_heading=>'Auto Wake'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:No;N,Yes;Y,Force;F'
,p_lov_show_nulls=>'NO'
,p_derived_column=>'N'
,p_lov_display_extra=>'NO'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(48967992543084227)
,p_query_column_id=>7
,p_column_alias=>'AUTO_MSG_MODE'
,p_column_display_sequence=>7
,p_column_heading=>'Auto Mode'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:Disabled;99,Quiet;4,Normal;2,Debug;1'
,p_lov_show_nulls=>'NO'
,p_derived_column=>'N'
,p_lov_display_extra=>'NO'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(48968141570084228)
,p_query_column_id=>8
,p_column_alias=>'MANUAL_MSG_MODE'
,p_column_display_sequence=>8
,p_column_heading=>'Manual Mode'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:Overridden;,Disabled;99,Quiet;4,Normal;2,Debug;1'
,p_lov_show_nulls=>'NO'
,p_derived_column=>'N'
,p_lov_display_extra=>'NO'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53266467011667692)
,p_query_column_id=>9
,p_column_alias=>'CHECK$01'
,p_column_display_sequence=>1
,p_column_heading=>'&nbsp;'
,p_heading_alignment=>'LEFT'
,p_display_as=>'CHECKBOX'
,p_derived_column=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53297942704036405)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35569579936315926)
,p_plug_display_sequence=>1
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'BELOW'
,p_menu_id=>wwv_flow_api.id(53231447489577620)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(35606742937315953)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53267652258667700)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53267852309667701)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'MULTI_ROW_DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''MULTI_ROW_DELETE'');'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53267248251667693)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'SUBMIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53267449047667700)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'PURGE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge Old Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38989825961193362)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'ALL_DEBUG'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_image_alt=>'All Debug'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38989604490187106)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'ALL_NORMAL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_image_alt=>'All Normal'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38989419250181952)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'ALL_QUIET'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_image_alt=>'All Quiet'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39061629762920532)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'ALL_DISABLED'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'All Disabled'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38990035311196000)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(53266261772667692)
,p_button_name=>'REPORT_STD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Report Std'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(53268937818667705)
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
,p_save_state_before_branch_yn=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38948415621737137)
,p_name=>'P9_NUM_ROWS'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_api.id(53266261772667692)
,p_prompt=>'Rows'
,p_source=>'20'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,5;5,10;10,15;15,20;20,25;25,30;30,50;50,100;100,200;200,500;500,1000;1000,5000;5000'
,p_cSize=>3
,p_cMaxlength=>4000
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_alignment=>'LEFT-CENTER'
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39058527082769845)
,p_name=>'P9_OWNER'
,p_item_sequence=>2
,p_item_plug_id=>wwv_flow_api.id(53266261772667692)
,p_prompt=>'Owner'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT initcap(OWNER) display, OWNER value',
'from SM_MODULE',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53268254958667704)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(53266261772667692)
,p_process_type=>'NATIVE_TABFORM_UPDATE'
,p_process_name=>'ApplyMRU'
,p_attribute_02=>'SM_MODULE'
,p_attribute_03=>'MODULE_ID'
,p_process_error_message=>'Unable to process update.'
,p_process_when_button_id=>wwv_flow_api.id(53267248251667693)
,p_process_success_message=>'#MRU_COUNT# row(s) updated, #MRI_COUNT# row(s) inserted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53268467227667704)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(53266261772667692)
,p_process_type=>'NATIVE_TABFORM_DELETE'
,p_process_name=>'ApplyMRD'
,p_attribute_02=>'SM_MODULE'
,p_attribute_03=>'MODULE_ID'
,p_process_error_message=>'Unable to process delete.'
,p_process_when=>'MULTI_ROW_DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'#MRD_COUNT# row(s) deleted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53268652196667704)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 1);'
,p_process_when_button_id=>wwv_flow_api.id(53267449047667700)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38983121880747452)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllDebug'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update sm_module',
'set auto_msg_mode    = sm_logger.G_MSG_MODE_DEBUG ',
'   ,auto_wake        = sm_logger.G_AUTO_WAKE_YES       ',
' --,manual_msg_mode  = sm_logger.G_MSG_MODE_DISABLED --don''t change',
'where owner = :P9_OWNER',
';',
'',
'update sm_unit',
'set auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from sm_module where owner = :P9_OWNER)',
';',
'commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. modules to Debug mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(38989825961193362)
,p_process_success_message=>'All &P9_OWNER. Modules are now in Debug mode. <BR>Auto Wake was enabled.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38984927383796392)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllNormal'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update sm_module',
'set auto_msg_mode    = sm_logger.G_MSG_MODE_NORMAL ',
'   ,auto_wake        = sm_logger.G_AUTO_WAKE_YES    ',
' --,manual_msg_mode  = sm_logger.G_MSG_MODE_DISABLED --don''t change',
'where owner = :P9_OWNER',
';',
'',
'update sm_unit',
'set auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from sm_module where owner = :P9_OWNER)',
';',
'',
'commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. modules to Normal mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(38989604490187106)
,p_process_success_message=>'All &P9_OWNER. Modules are now in Normal mode.<BR>Auto Wake was enabled.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38984308074771927)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllQuiet'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update sm_module',
'set auto_msg_mode    = sm_logger.G_MSG_MODE_QUIET ',
'   ,auto_wake        = sm_logger.G_AUTO_WAKE_NO       ',
' --,manual_msg_mode  = sm_logger.G_MSG_MODE_DISABLED --don''t change',
'where owner = :P9_OWNER',
';',
'',
'update sm_unit',
'set auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from sm_module where owner = :P9_OWNER)',
';',
' ',
'Commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. modules to Quiet mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(38989419250181952)
,p_process_success_message=>'All &P9_OWNER. Modules are now in Quiet mode.<BR>Auto Wake was disabled.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(39061827872924925)
,p_process_sequence=>70
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllDisabled'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update sm_module',
'set auto_wake        = sm_logger.G_AUTO_WAKE_NO',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_DISABLED ',
'--   ,manual_msg_mode  = sm_logger.G_MSG_MODE_DISABLED  --Don''t change',
'where owner = :P9_OWNER',
';',
'',
'update sm_unit',
'set auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_OVERRIDDEN ',
'--   ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN --Don''t change',
'where module_id in (select module_id from sm_module where owner = :P9_OWNER)',
';',
'',
'Commit;'))
,p_process_error_message=>'Failed to Disable &P9_OWNER. modules.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(39061629762920532)
,p_process_success_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'All &P9_OWNER. Modules are Disabled.<BR>Auto Wake was disabled.<BR>',
'Nothing will be logged for for Disabled module/units. '))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38986321852870418)
,p_process_sequence=>80
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetReportsStd'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--Set Report Modules to Normal',
'update sm_module',
'set auto_msg_mode    = sm_logger.G_MSG_MODE_NORMAL ',
'   ,auto_wake        = sm_logger.G_AUTO_WAKE_YES ',
' --,manual_msg_mode  = sm_logger.G_MSG_MODE_DISABLED --don''t change',
'where module_type = ''REPORT''',
'and   owner = :P9_OWNER',
';',
'',
'--Set Report Units to Overridden',
'update sm_unit',
'set auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from sm_module where module_type = ''REPORT'' and owner = :P9_OWNER)',
';',
' ',
' ',
'--Set Reports Parameter routine to debug.',
'update sm_unit',
'set  auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'    ,auto_msg_mode    = sm_logger.G_MSG_MODE_DEBUG ',
'  -- ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where unit_name  = ''get_parameters''',
'and module_id in (select module_id from sm_module where module_type = ''REPORT'' and owner = :P9_OWNER);',
'',
' ',
'',
'--Set Report Library Modules to Disabled',
'update sm_module',
'set auto_msg_mode    = sm_logger.G_MSG_MODE_DISABLED ',
'   ,auto_wake        = sm_logger.G_AUTO_WAKE_NO',
' --,manual_msg_mode  = sm_logger.G_MSG_MODE_DISABLED --don''t change',
'where module_type = ''REPORT_LIB''',
'and   owner = :P9_OWNER;',
'',
' ',
'',
'--Set Report Library Units to Overridden',
'update sm_unit',
'set auto_wake        = sm_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = sm_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = sm_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from sm_module where module_type = ''REPORT_LIB'' and owner = :P9_OWNER)',
';',
' ',
'commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. Reports to Standard mode.<BR>Auto Wake was enabled.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(38990035311196000)
,p_process_success_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'&P9_OWNER. Reports are now in Standard mode. <BR>',
'Reports will open processes in Normal message mode, with ''get_parameters'' unit set to Debug.<BR>',
'Report Libraries are set to Disabled, to keep the tree neater. '))
);
end;
/
