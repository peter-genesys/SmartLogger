prompt --application/pages/page_00010
begin
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_tab_set=>'TS1'
,p_name=>'Unit Registry'
,p_page_mode=>'NORMAL'
,p_step_title=>'Unit Registry'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Unit Registry'
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
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180729012936'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(53271544124677263)
,p_name=>'Units of Module &P10_MODULE_NAME.'
,p_template=>wwv_flow_api.id(35560371291315922)
,p_display_sequence=>15
,p_include_in_reg_disp_sel_yn=>'N'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY_3'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'"UNIT_ID",',
'"UNIT_ID" UNIT_ID_DISPLAY,',
'"UNIT_NAME",',
'"UNIT_TYPE",',
'"MODULE_ID",',
'auto_wake,',
'auto_msg_mode,',
'manual_msg_mode',
'from "#OWNER#"."SM_UNIT"',
'where module_id = :P10_MODULE_ID',
''))
,p_source_type=>'NATIVE_TABFORM'
,p_ajax_enabled=>'N'
,p_fixed_header=>'NONE'
,p_query_row_template=>wwv_flow_api.id(35580946704315935)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'(null)'
,p_query_break_cols=>'0'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_item=>'P10_NUM_ROWS'
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
 p_id=>wwv_flow_api.id(53271838997677263)
,p_query_column_id=>1
,p_column_alias=>'UNIT_ID'
,p_column_display_sequence=>2
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_display_as=>'HIDDEN'
,p_pk_col_source_type=>'S'
,p_pk_col_source=>'MS_UNIT_SEQ'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_UNIT'
,p_ref_column_name=>'UNIT_ID'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53271955570677263)
,p_query_column_id=>2
,p_column_alias=>'UNIT_ID_DISPLAY'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_UNIT'
,p_ref_column_name=>'UNIT_ID_DISPLAY'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53272067039677263)
,p_query_column_id=>3
,p_column_alias=>'UNIT_NAME'
,p_column_display_sequence=>4
,p_column_heading=>'Unit Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_UNIT'
,p_ref_column_name=>'UNIT_NAME'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53272160792677263)
,p_query_column_id=>4
,p_column_alias=>'UNIT_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Unit Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV'
,p_inline_lov=>'STATIC:Procedure;PROC,Function;FUNC,Script;SCRIPT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_UNIT'
,p_ref_column_name=>'UNIT_TYPE'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(53272257349677263)
,p_query_column_id=>5
,p_column_alias=>'MODULE_ID'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_ref_schema=>'TPDS'
,p_ref_table_name=>'MS_UNIT'
,p_ref_column_name=>'MODULE_ID'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(48968253876084229)
,p_query_column_id=>6
,p_column_alias=>'AUTO_WAKE'
,p_column_display_sequence=>7
,p_column_heading=>'Auto Wake'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'SELECT_LIST'
,p_inline_lov=>'STATIC:Overridden;,No;N,Yes;Y,Force;F'
,p_lov_show_nulls=>'NO'
,p_derived_column=>'N'
,p_lov_display_extra=>'NO'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(48968272180084230)
,p_query_column_id=>7
,p_column_alias=>'AUTO_MSG_MODE'
,p_column_display_sequence=>8
,p_column_heading=>'Auto Mode'
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
 p_id=>wwv_flow_api.id(48968435217084231)
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
 p_id=>wwv_flow_api.id(53271744798677263)
,p_query_column_id=>9
,p_column_alias=>'CHECK$01'
,p_column_display_sequence=>1
,p_column_heading=>'&nbsp;'
,p_heading_alignment=>'LEFT'
,p_display_as=>'CHECKBOX'
,p_derived_column=>'Y'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603310818845920)
,p_column_sequence=>1
,p_query_column_name=>'UNIT_ID'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603430711845923)
,p_column_sequence=>2
,p_query_column_name=>'UNIT_ID_DISPLAY'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603506751845923)
,p_column_sequence=>3
,p_query_column_name=>'UNIT_NAME'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603627628845924)
,p_column_sequence=>4
,p_query_column_name=>'UNIT_TYPE'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603712444845924)
,p_column_sequence=>5
,p_query_column_name=>'MODULE_ID'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603832702845924)
,p_column_sequence=>6
,p_query_column_name=>'MSG_MODE'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_region_rpt_cols(
 p_id=>wwv_flow_api.id(38603915831845927)
,p_column_sequence=>7
,p_query_column_name=>'OPEN_PROCESS'
,p_display_as=>'TEXT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53298356556040343)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35569579936315926)
,p_plug_display_sequence=>1
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'BELOW'
,p_menu_id=>wwv_flow_api.id(53231447489577620)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(35606742937315953)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53272753818677263)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(53271544124677263)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53272951545677263)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(53271544124677263)
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
 p_id=>wwv_flow_api.id(53272551619677263)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(53271544124677263)
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
 p_id=>wwv_flow_api.id(38988211107141713)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(53271544124677263)
,p_button_name=>'OVERRIDDEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_image_alt=>'Overridden'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(53274040913677264)
,p_branch_action=>'f?p=&APP_ID.:10:&SESSION.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
,p_save_state_before_branch_yn=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38603117719842713)
,p_name=>'P10_MODULE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(53271544124677263)
,p_display_as=>'NATIVE_HIDDEN'
,p_cMaxlength=>4000
,p_label_alignment=>'RIGHT'
,p_field_alignment=>'LEFT-CENTER'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38949614721783142)
,p_name=>'P10_NUM_ROWS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(53271544124677263)
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
 p_id=>wwv_flow_api.id(53273161492677263)
,p_name=>'P10_MODULE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53271544124677263)
,p_display_as=>'NATIVE_HIDDEN'
,p_cMaxlength=>4000
,p_cAttributes=>'nowrap="nowrap"'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53273759924677264)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(53271544124677263)
,p_process_type=>'NATIVE_TABFORM_UPDATE'
,p_process_name=>'ApplyMRU'
,p_attribute_02=>'MS_UNIT'
,p_attribute_03=>'UNIT_ID'
,p_process_error_message=>'Unable to process update.'
,p_process_when_button_id=>wwv_flow_api.id(53272551619677263)
,p_process_success_message=>'#MRU_COUNT# row(s) updated, #MRI_COUNT# row(s) inserted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53273546657677264)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(53271544124677263)
,p_process_type=>'NATIVE_TABFORM_DELETE'
,p_process_name=>'ApplyMRD'
,p_attribute_02=>'MS_UNIT'
,p_attribute_03=>'UNIT_ID'
,p_process_error_message=>'Unable to process delete.'
,p_process_when=>'MULTI_ROW_DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'#MRD_COUNT# row(s) deleted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38987919372115725)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SetAllOverridden'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update ms_unit',
'set auto_wake        = ms_logger.G_MSG_MODE_OVERRIDDEN',
'   ,auto_msg_mode    = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'   ,manual_msg_mode  = ms_logger.G_MSG_MODE_OVERRIDDEN ',
'where module_id = :P10_MODULE_ID',
';',
'',
'Commit;'))
,p_process_error_message=>'Failed to set units to Overridden.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(38988211107141713)
,p_process_success_message=>'All units (of this module) are now Overridden, by the module''s settings.'
);
end;
/
