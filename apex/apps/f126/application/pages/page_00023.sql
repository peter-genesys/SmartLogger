prompt --application/pages/page_00023
begin
wwv_flow_api.create_page(
 p_id=>23
,p_user_interface_id=>wwv_flow_api.id(13227173141283158)
,p_name=>'Compare Source'
,p_page_mode=>'NORMAL'
,p_step_title=>'Compare Source'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Compare Source'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_nav_list_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_cache_timeout_seconds=>21600
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20171003210027'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10925695467601905)
,p_plug_name=>'Tabs'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_api.id(10813095165342901)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY_3'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14432373762922736)
,p_plug_name=>'Original'
,p_parent_plug_id=>wwv_flow_api.id(10925695467601905)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10806409948342898)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_query_row_template=>1
,p_plug_query_headings_type=>'QUERY_COLUMNS'
,p_plug_query_num_rows=>15
,p_plug_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14432553115926237)
,p_plug_name=>'Weave Highlighted'
,p_parent_plug_id=>wwv_flow_api.id(10925695467601905)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10806409948342898)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_query_row_template=>1
,p_plug_query_headings_type=>'QUERY_COLUMNS'
,p_plug_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14453059723668795)
,p_plug_name=>'Weave Plain'
,p_parent_plug_id=>wwv_flow_api.id(10925695467601905)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10806409948342898)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_query_row_template=>1
,p_plug_query_headings_type=>'QUERY_COLUMNS'
,p_plug_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(215650816128691844)
,p_plug_name=>'Installed Now'
,p_parent_plug_id=>wwv_flow_api.id(10925695467601905)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10806409948342898)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11190637052761645)
,p_name=>'Original'
,p_template=>wwv_flow_api.id(10806409948342898)
,p_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_display_point=>'BODY_3'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select NAME',
'      ,TYPE',
'      ,VALID_YN ',
'      ,RESULT ',
'      ,LOAD_DATETIME ',
' from AOP_SOURCE AOP_SOURCE',
' where name = :P23_NAME ',
'   and type = :P23_TYPE',
'   and aop_ver = ''ORIG'''))
,p_source_type=>'NATIVE_SQL_REPORT'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(10829972915342913)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'ROW_RANGES_IN_SELECT_LIST'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11191007725761649)
,p_query_column_id=>1
,p_column_alias=>'NAME'
,p_column_display_sequence=>1
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11191129293761650)
,p_query_column_id=>2
,p_column_alias=>'TYPE'
,p_column_display_sequence=>2
,p_column_heading=>'Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11190761692761646)
,p_query_column_id=>3
,p_column_alias=>'VALID_YN'
,p_column_display_sequence=>4
,p_column_heading=>'Valid'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11190814549761647)
,p_query_column_id=>4
,p_column_alias=>'RESULT'
,p_column_display_sequence=>5
,p_column_heading=>'Result'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11190903073761648)
,p_query_column_id=>5
,p_column_alias=>'LOAD_DATETIME'
,p_column_display_sequence=>3
,p_column_heading=>'Load datetime'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11261931007697501)
,p_name=>'Woven'
,p_template=>wwv_flow_api.id(10806409948342898)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'N'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--fixedLabelSmall:t-AVPList--leftAligned'
,p_new_grid_row=>false
,p_display_point=>'BODY_3'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select NAME',
'      ,TYPE',
'      ,VALID_YN ',
'      ,RESULT ',
'      ,LOAD_DATETIME ',
' from AOP_SOURCE AOP_SOURCE',
' where name = :P23_NAME ',
'   and type = :P23_TYPE',
'   and aop_ver = ''AOP'''))
,p_source_type=>'NATIVE_SQL_REPORT'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(10829972915342913)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'ROW_RANGES_IN_SELECT_LIST'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11262396060697505)
,p_query_column_id=>1
,p_column_alias=>'NAME'
,p_column_display_sequence=>1
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11262448195697506)
,p_query_column_id=>2
,p_column_alias=>'TYPE'
,p_column_display_sequence=>2
,p_column_heading=>'Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11262093514697502)
,p_query_column_id=>3
,p_column_alias=>'VALID_YN'
,p_column_display_sequence=>4
,p_column_heading=>'Valid'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11262123644697503)
,p_query_column_id=>4
,p_column_alias=>'RESULT'
,p_column_display_sequence=>5
,p_column_heading=>'Result'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11262215496697504)
,p_query_column_id=>5
,p_column_alias=>'LOAD_DATETIME'
,p_column_display_sequence=>3
,p_column_heading=>'Load datetime'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14428255545700995)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10815618593342902)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(28477486146604596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10852781594342929)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14425044611700977)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11190637052761645)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14434772050237191)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(11190637052761645)
,p_button_name=>'QUICK_WEAVE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Quick Weave'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(14429254845700999)
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(14425044611700977)
,p_branch_sequence=>1
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(14435260164256560)
,p_branch_name=>'GoQuickAOP'
,p_branch_action=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(14434772050237191)
,p_branch_sequence=>11
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14425248382700979)
,p_name=>'P23_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11190637052761645)
,p_use_cache_before_default=>'NO'
,p_source=>'NAME'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14425470216700981)
,p_name=>'P23_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11190637052761645)
,p_use_cache_before_default=>'NO'
,p_source=>'TYPE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14429642134734642)
,p_name=>'P23_ORIG_TEXT_DISPLAY'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(14432373762922736)
,p_prompt=>'Orig Text'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>128000
,p_cHeight=>40
,p_field_template=>wwv_flow_api.id(10851543190342926)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14429961100740971)
,p_name=>'P23_HTML_TEXT_DISPLAY'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(14432553115926237)
,p_prompt=>'AOP HTML Text'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>150
,p_cMaxlength=>128000
,p_cHeight=>40
,p_field_template=>wwv_flow_api.id(10851543190342926)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'Full'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14453545990718909)
,p_name=>'P23_AOP_TEXT_DISPLAY'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(14453059723668795)
,p_prompt=>'Pure AOP Text'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>128000
,p_cHeight=>40
,p_field_template=>wwv_flow_api.id(10851543190342926)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71094211525207352)
,p_name=>'P23_INSTALLED_TEXT_DISPLAY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(215650816128691844)
,p_prompt=>'Installed Now Text'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>128000
,p_cHeight=>40
,p_field_template=>wwv_flow_api.id(10851543190342926)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14430054482775295)
,p_name=>'onLoadPopTextDisplays'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14430367472775310)
,p_event_id=>wwv_flow_api.id(14430054482775295)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_ORIG_TEXT_DISPLAY'
,p_attribute_01=>'RENDER'
,p_attribute_02=>'SQL_QUERY'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select orig_text ',
'from aop_source_v',
'where name = :P23_name ',
'and type = :P23_type'))
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14431169831873619)
,p_event_id=>wwv_flow_api.id(14430054482775295)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_AOP_TEXT_DISPLAY'
,p_attribute_01=>'RENDER'
,p_attribute_02=>'SQL_QUERY'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select aop_text ',
'from aop_source_v',
'where name = :P23_name ',
'and type = :P23_type'))
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14454260846742471)
,p_event_id=>wwv_flow_api.id(14430054482775295)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_HTML_TEXT_DISPLAY'
,p_attribute_01=>'RENDER'
,p_attribute_02=>'SQL_QUERY'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select html_text ',
'from aop_source_v',
'where name = :P23_name ',
'and type = :P23_type'))
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(69286693224639330)
,p_event_id=>wwv_flow_api.id(14430054482775295)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_INSTALLED_TEXT_DISPLAY'
,p_attribute_01=>'RENDER'
,p_attribute_02=>'SQL_QUERY'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select installed_text ',
'from aop_source_v',
'where name = :P23_name ',
'and type = :P23_type',
''))
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14433954473213125)
,p_name=>'beforeBranchtoQuickAOPUploadOrigTextToRawInput'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(14434772050237191)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_da_event_comment=>'This extra upload is here to stop a server error that occurs when the page implicitly submits and the value is otherwise too big.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14434273328213131)
,p_event_id=>wwv_flow_api.id(14433954473213125)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_ORIG_TEXT_DISPLAY'
,p_attribute_01=>'SUBMIT'
,p_attribute_05=>'RAW_INPUT'
,p_attribute_06=>'N'
,p_attribute_07=>'Y'
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
,p_da_action_comment=>'RAW_INPUT will be loaded by the Quick AOP Input Page'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14436254520304799)
,p_event_id=>wwv_flow_api.id(14433954473213125)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'QUICK_WEAVE'
,p_attribute_02=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14428953350700998)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'reset page'
,p_attribute_01=>'CLEAR_CACHE_FOR_PAGES'
,p_attribute_04=>'4'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
end;
/
