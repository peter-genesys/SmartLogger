prompt --application/pages/page_00009
begin
wwv_flow_api.create_page(
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(13227173141283158)
,p_tab_set=>'TS1'
,p_name=>'Logger Control'
,p_page_mode=>'NORMAL'
,p_step_title=>'Logger Control'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Modules Registry'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_nav_list_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_cache_timeout_seconds=>21600
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180717012907'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(28512300429694668)
,p_name=>'Modules'
,p_template=>wwv_flow_api.id(10806409948342898)
,p_display_sequence=>15
,p_include_in_reg_disp_sel_yn=>'N'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY_3'
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
'from "#OWNER#"."MS_MODULE"',
'where owner = :P9_OWNER',
''))
,p_source_type=>'NATIVE_TABFORM'
,p_ajax_enabled=>'N'
,p_fixed_header=>'NONE'
,p_query_row_template=>wwv_flow_api.id(10826985361342911)
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
 p_id=>wwv_flow_api.id(28512589710694668)
,p_query_column_id=>1
,p_column_alias=>'MODULE_ID'
,p_column_display_sequence=>2
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_display_as=>'HIDDEN'
,p_pk_col_source_type=>'S'
,p_pk_col_source=>'MS_MODULE_SEQ'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_MODULE'
,p_ref_column_name=>'MODULE_ID'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28512699453694668)
,p_query_column_id=>2
,p_column_alias=>'MODULE_ID_DISPLAY'
,p_column_display_sequence=>10
,p_column_heading=>'Edit Units'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_MODULE_ID,P10_MODULE_NAME:#MODULE_ID#,#MODULE_NAME#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#ed-item.gif" alt="">'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_table_name=>'MS_MODULE'
,p_ref_column_name=>'MODULE_ID_DISPLAY'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28512793332694668)
,p_query_column_id=>3
,p_column_alias=>'MODULE_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Module Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_MODULE'
,p_ref_column_name=>'MODULE_NAME'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28512880226694668)
,p_query_column_id=>4
,p_column_alias=>'REVISION'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_MODULE'
,p_ref_column_name=>'REVISION'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28512998195694668)
,p_query_column_id=>5
,p_column_alias=>'MODULE_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Module Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:Package;PACKAGE,Procedure;PROCEDURE,Function;FUNCTION,Trigger;TRIGGER,Oracle Report;REPORT,Oracle Form;FORM,Oracle Report PLSQL Library;REPORT_LIB,Oracle Form PLSQL Library;FORM_LIB,Apex App;APEX'
,p_lov_show_nulls=>'NO'
,p_derived_column=>'N'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
,p_ref_table_name=>'MS_MODULE'
,p_ref_column_name=>'MODULE_TYPE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(24213987203111202)
,p_query_column_id=>6
,p_column_alias=>'AUTO_WAKE'
,p_column_display_sequence=>7
,p_column_heading=>'Auto Wake'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:No;N,Yes;Y,Force;F'
,p_lov_show_nulls=>'YES'
,p_derived_column=>'N'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(24214031200111203)
,p_query_column_id=>7
,p_column_alias=>'AUTO_MSG_MODE'
,p_column_display_sequence=>8
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
 p_id=>wwv_flow_api.id(24214180227111204)
,p_query_column_id=>8
,p_column_alias=>'MANUAL_MSG_MODE'
,p_column_display_sequence=>9
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
 p_id=>wwv_flow_api.id(28512505668694668)
,p_query_column_id=>9
,p_column_alias=>'CHECK$01'
,p_column_display_sequence=>1
,p_column_heading=>'&nbsp;'
,p_heading_alignment=>'LEFT'
,p_display_as=>'CHECKBOX'
,p_derived_column=>'Y'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850371029878067)
,p_column_sequence=>1
,p_query_column_name=>'MODULE_ID'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850443841878068)
,p_column_sequence=>2
,p_query_column_name=>'MODULE_ID_DISPLAY'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850555324878068)
,p_column_sequence=>3
,p_query_column_name=>'MODULE_NAME'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850658651878068)
,p_column_sequence=>4
,p_query_column_name=>'REVISION'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850744446878068)
,p_column_sequence=>5
,p_query_column_name=>'MODULE_TYPE'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850859156878068)
,p_column_sequence=>6
,p_query_column_name=>'MSG_MODE'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(13850962940878068)
,p_column_sequence=>7
,p_query_column_name=>'OPEN_PROCESS'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28543981361063381)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10815618593342902)
,p_plug_display_sequence=>1
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'BELOW'
,p_menu_id=>wwv_flow_api.id(28477486146604596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10852781594342929)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28513690915694676)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28513890966694677)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'MULTI_ROW_DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''MULTI_ROW_DELETE'');'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28513286908694669)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'SUBMIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28513487704694676)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'PURGE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Purge Old Processes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14235457907208928)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'ALL_QUIET'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10852003520342929)
,p_button_image_alt=>'All Quiet'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14235643147214082)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'ALL_NORMAL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10852003520342929)
,p_button_image_alt=>'All Normal'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14235864618220338)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'ALL_DEBUG'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10852003520342929)
,p_button_image_alt=>'All Debug'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14236073968222976)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'REPORT_STD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Report Std'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14307668419947508)
,p_button_sequence=>85
,p_button_plug_id=>wwv_flow_api.id(28512300429694668)
,p_button_name=>'ALL_DISABLED'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'All Disabled'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(28514976475694681)
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
,p_save_state_before_branch_yn=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14194454278764113)
,p_name=>'P9_NUM_ROWS'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_api.id(28512300429694668)
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
,p_field_template=>wwv_flow_api.id(10851401898342926)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14304565739796821)
,p_name=>'P9_OWNER'
,p_item_sequence=>2
,p_item_plug_id=>wwv_flow_api.id(28512300429694668)
,p_prompt=>'Owner'
,p_source=>'select min(owner) from ms_module where owner <> ''LOGGER'''
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT initcap(OWNER) display, OWNER value',
'from MS_MODULE',
''))
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_alignment=>'LEFT-CENTER'
,p_field_template=>wwv_flow_api.id(10851401898342926)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28514293615694680)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(28512300429694668)
,p_process_type=>'NATIVE_TABFORM_UPDATE'
,p_process_name=>'ApplyMRU'
,p_attribute_02=>'MS_MODULE'
,p_attribute_03=>'MODULE_ID'
,p_process_error_message=>'Unable to process update.'
,p_process_when_button_id=>wwv_flow_api.id(28513286908694669)
,p_process_success_message=>'#MRU_COUNT# row(s) updated, #MRI_COUNT# row(s) inserted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28514505884694680)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(28512300429694668)
,p_process_type=>'NATIVE_TABFORM_DELETE'
,p_process_name=>'ApplyMRD'
,p_attribute_02=>'MS_MODULE'
,p_attribute_03=>'MODULE_ID'
,p_process_error_message=>'Unable to process delete.'
,p_process_when=>'MULTI_ROW_DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'#MRD_COUNT# row(s) deleted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28514690853694680)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldProcesses'
,p_process_sql_clob=>'ms_api.purge_old_processes(i_keep_day_count => 1);'
,p_process_when_button_id=>wwv_flow_api.id(28513487704694676)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14229160537774428)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllDebug'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update ms_module',
'set auto_msg_mode    = ms_logger.G_MSG_MODE_DEBUG ',
' -- auto_wake        = ms_logger.G_AUTO_WAKE_NO      --don''t change',
' --,manual_msg_mode  = ms_logger.G_MSG_MODE_DISABLED --don''t change',
'where owner = :P9_OWNER',
';',
'',
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)',
';',
'commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. modules to Debug mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(14235864618220338)
,p_process_success_message=>'All &P9_OWNER. Modules are now in Debug mode. Open Process settings are unchanged.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14230346731798903)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllQuiet'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'update ms_module',
'set auto_msg_mode    = ms_logger.G_MSG_MODE_QUIET ',
' -- auto_wake        = ms_logger.G_AUTO_WAKE_NO      --don''t change',
' --,manual_msg_mode  = ms_logger.G_MSG_MODE_DISABLED --don''t change',
'where owner = :P9_OWNER',
';',
'',
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)',
';',
' ',
'Commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. modules to Quiet mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(14235457907208928)
,p_process_success_message=>'All &P9_OWNER. Modules are now in Quiet mode.  No Processes will start.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14230966040823368)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllNormal'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'update ms_module',
'set auto_msg_mode    = ms_logger.G_MSG_MODE_NORMAL ',
' -- auto_wake        = ms_logger.G_AUTO_WAKE_NO      --don''t change',
' --,manual_msg_mode  = ms_logger.G_MSG_MODE_DISABLED --don''t change',
'where owner = :P9_OWNER',
';',
'',
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)',
';',
'',
'commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. modules to Normal mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(14235643147214082)
,p_process_success_message=>'All &P9_OWNER. Modules are now in Normal mode. Open Process settings are unchanged.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14232360509897394)
,p_process_sequence=>70
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetReportsStd'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--Set Report Modules to Normal',
'update ms_module',
'set auto_msg_mode    = ms_logger.G_MSG_MODE_NORMAL ',
'   ,auto_wake        = ms_logger.G_AUTO_WAKE_YES ',
' --,manual_msg_mode  = ms_logger.G_MSG_MODE_DISABLED --don''t change',
'where module_type = ''REPORT''',
'and   owner = :P9_OWNER',
';',
'',
'--Set Report Units to Overridden',
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from ms_module where module_type = ''REPORT'' and owner = :P9_OWNER)',
';',
' ',
' ',
'--Set Reports Parameter routine to debug.',
'update ms_unit',
'set  auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'    ,auto_msg_mode    = ms_logger.G_MSG_MODE_DEBUG ',
'  -- ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where unit_name  = ''get_parameters''',
'and module_id in (select module_id from ms_module where module_type = ''REPORT'' and owner = :P9_OWNER);',
'',
' ',
'',
'--Set Report Library Modules to Disabled',
'update ms_module',
'set auto_msg_mode    = ms_logger.G_MSG_MODE_DISABLED ',
'   ,auto_wake        = ms_logger.G_AUTO_WAKE_NO',
' --,manual_msg_mode  = ms_logger.G_MSG_MODE_DISABLED --don''t change',
'where module_type = ''REPORT_LIB''',
'and   owner = :P9_OWNER;',
'',
' ',
'',
'--Set Report Library Units to Overridden',
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'  -- ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN  --don''t change',
'where module_id in (select module_id from ms_module where module_type = ''REPORT_LIB'' and owner = :P9_OWNER)',
';',
' ',
'commit;'))
,p_process_error_message=>'Failed to set &P9_OWNER. Reports to Standard mode.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(14236073968222976)
,p_process_success_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'&P9_OWNER. Reports are now in Standard mode. <BR>',
'Reports will open processes in Normal message mode, with ''get_parameters'' unit set to Debug.<BR>',
'Report Libraries are set to Disabled, to keep the tree neater. '))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14307866529951901)
,p_process_sequence=>80
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllDisabled'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update ms_module',
'set auto_wake        = ms_logger.G_AUTO_WAKE_NO',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_DISABLED ',
'--   ,manual_msg_mode  = ms_logger.G_MSG_MODE_DISABLED  --Don''t change',
'where owner = :P9_OWNER',
';',
'',
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'--   ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN --Don''t change',
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)',
';',
'',
'Commit;'))
,p_process_error_message=>'Failed to Disable &P9_OWNER. modules.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(14307668419947508)
,p_process_success_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'All &P9_OWNER. Modules are Disabled.  No Processes will start.<BR>',
'No nodes, messages, or references are recorded for Disabled module/units. '))
);
end;
/
