--application/pages/page_00024
prompt  ...PAGE 24: User Feedback
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 24
 ,p_user_interface_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_name => 'User Feedback'
 ,p_step_title => 'User Feedback'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'User Feedback'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_html_page_header => 
'<script type="text/javascript"> '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function set_value(p_field,p_value) {'||unistr('\000a')||
'	document.getElementById(p_field).value=p_value;'||unistr('\000a')||
'}'||unistr('\000a')||
''||unistr('\000a')||
'	function view_any_page(p_page_no, p_page_name, p_id_field, p_id_value, p_id_name) {'||unistr('\000a')||
'		if ( p_id_value ) {'||unistr('\000a')||
'			// get the app items from the form vars'||unistr('\000a')||
'			var l_app_id = $v(''pFlowId'');'||unistr('\000a')||
'			var l_app_session = $v(''pInstance'');'||unistr('\000a')||
'			var l_debug = $v(''pdebug'');'||unistr('\000a')||
'			// open the tab'||unistr('\000a')||
'	'||
'		top.Ext.app.tabs.viewTab(p_page_no, p_id_value, p_page_name + '' - '' + p_id_name, ''f?p='' + l_app_id + '':'' + p_page_no + '':'' + l_app_session + ''::'' + l_debug + '':'' + p_page_no + '':'' + p_id_field + '':'' + p_id_value);'||unistr('\000a')||
'		}'||unistr('\000a')||
'	}'||unistr('\000a')||
''||unistr('\000a')||
'</script>'
 ,p_page_is_public_y_n => 'Y'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'PBURGESS'
 ,p_last_upd_yyyymmddhh24miss => '20140611105154'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select a.* '||unistr('\000a')||
'      ,m.MESSAGE_ID'||unistr('\000a')||
'      ,decode(instr(m.MESSAGE,chr(10)),0,m.MESSAGE,''<PRE>''||m.MESSAGE||''</PRE>'')     MESSAGE'||unistr('\000a')||
'      ,m.MSG_LEVEL'||unistr('\000a')||
'      ,m.MSG_TYPE'||unistr('\000a')||
'      ,m.TIME_NOW'||unistr('\000a')||
'      ,m.MSG_LEVEL_TEXT'||unistr('\000a')||
'      ,m.name'||unistr('\000a')||
'      ,m.value'||unistr('\000a')||
'from ('||unistr('\000a')||
'select level'||unistr('\000a')||
'        ,ut.*'||unistr('\000a')||
'      ,''<span style="padding-left:''||LEVEL*10||''px;">''||ut.unit_name||''</span>'' level_unit_name'||unistr('\000a')||
'  from ms_unit_traversal_vw ut'||unistr('\000a')||
'  WHER';

s:=s||'E process_id = :P24_process_id '||unistr('\000a')||
'  start with ut.PARENT_TRAVERSAL_ID IS NULL'||unistr('\000a')||
'  connect by prior ut.TRAVERSAL_ID = ut.PARENT_TRAVERSAL_ID'||unistr('\000a')||
'  order siblings by ut.TRAVERSAL_ID) a'||unistr('\000a')||
'  ,ms_message_vw m'||unistr('\000a')||
'where m.traversal_id = a.traversal_id';

wwv_flow_api.create_page_plug (
  p_id=> 3323316575771236 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_plug_name=> 'Process Trace',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17756239625931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => false,
  p_plug_new_grid_column  => false,
  p_plug_display_column=> null,
  p_plug_display_point=> 'BODY_3',
  p_plug_item_display_point=> 'ABOVE',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select a.* '||unistr('\000a')||
'      ,m.MESSAGE_ID'||unistr('\000a')||
'      ,decode(instr(m.MESSAGE,chr(10)),0,m.MESSAGE,''<PRE>''||m.MESSAGE||''</PRE>'')     MESSAGE'||unistr('\000a')||
'      ,m.MSG_LEVEL'||unistr('\000a')||
'      ,m.MSG_TYPE'||unistr('\000a')||
'      ,m.TIME_NOW'||unistr('\000a')||
'      ,m.MSG_LEVEL_TEXT'||unistr('\000a')||
'      ,m.name'||unistr('\000a')||
'      ,m.value'||unistr('\000a')||
'from ('||unistr('\000a')||
'select level'||unistr('\000a')||
'        ,ut.*'||unistr('\000a')||
'      ,''<span style="padding-left:''||LEVEL*10||''px;">''||ut.unit_name||''</span>'' level_unit_name'||unistr('\000a')||
'  from ms_unit_traversal_vw ut'||unistr('\000a')||
'  WHER';

a1:=a1||'E process_id = :P24_process_id '||unistr('\000a')||
'  start with ut.PARENT_TRAVERSAL_ID IS NULL'||unistr('\000a')||
'  connect by prior ut.TRAVERSAL_ID = ut.PARENT_TRAVERSAL_ID'||unistr('\000a')||
'  order siblings by ut.TRAVERSAL_ID) a'||unistr('\000a')||
'  ,ms_message_vw m'||unistr('\000a')||
'where m.traversal_id = a.traversal_id';

wwv_flow_api.create_worksheet(
  p_id=> 3323512923771237+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_region_id=> 3323316575771236+wwv_flow_api.g_id_offset,
  p_name=> 'Traversal Messages',
  p_folder_id=> null, 
  p_alias=> '',
  p_report_id_item=> '',
  p_max_row_count=> '10000',
  p_max_row_count_message=> 'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.',
  p_no_data_found_message=> 'No data found.',
  p_max_rows_per_page=>'',
  p_search_button_label=>'',
  p_sort_asc_image=>'',
  p_sort_asc_image_attr=>'',
  p_sort_desc_image=>'',
  p_sort_desc_image_attr=>'',
  p_sql_query => a1,
  p_status=>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving=>'Y',
  p_allow_save_rpt_public=>'Y',
  p_allow_report_categories=>'N',
  p_show_nulls_as=>'-',
  p_pagination_type=>'ROWS_X_TO_Y',
  p_pagination_display_pos=>'BOTTOM_RIGHT',
  p_show_finder_drop_down=>'Y',
  p_show_display_row_count=>'Y',
  p_show_search_bar=>'Y',
  p_show_search_textbox=>'Y',
  p_show_actions_menu=>'Y',
  p_report_list_mode=>'TABS',
  p_show_detail_link=>'N',
  p_show_select_columns=>'Y',
  p_show_rows_per_page=>'N',
  p_show_filter=>'Y',
  p_show_sort=>'Y',
  p_show_control_break=>'Y',
  p_show_highlight=>'N',
  p_show_computation=>'Y',
  p_show_aggregate=>'Y',
  p_show_chart=>'Y',
  p_show_group_by=>'Y',
  p_show_notify=>'Y',
  p_show_calendar=>'N',
  p_show_flashback=>'Y',
  p_show_reset=>'Y',
  p_show_download=>'Y',
  p_show_help=>'Y',
  p_download_formats=>'CSV:HTML:EMAIL',
  p_allow_exclude_null_values=>'N',
  p_allow_hide_extra_columns=>'N',
  p_icon_view_enabled_yn=>'N',
  p_icon_view_use_custom=>'N',
  p_icon_view_columns_per_row=>1,
  p_detail_view_enabled_yn=>'N',
  p_owner=>'PBURGESS',
  p_internal_uid=> 3323512923771237);
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3323617236771240+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TRAVERSAL_ID',
  p_display_order          =>1,
  p_column_identifier      =>'A',
  p_column_label           =>'Traversal Id',
  p_report_label           =>'Traversal Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3323718035771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'PROCESS_ID',
  p_display_order          =>2,
  p_column_identifier      =>'B',
  p_column_label           =>'Process Id',
  p_report_label           =>'Process Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3323816631771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'EXT_REF',
  p_display_order          =>3,
  p_column_identifier      =>'C',
  p_column_label           =>'External Ref',
  p_report_label           =>'External Ref',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3323920579771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'UNIT_ID',
  p_display_order          =>4,
  p_column_identifier      =>'D',
  p_column_label           =>'Unit Id',
  p_report_label           =>'Unit Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324028138771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'PARENT_TRAVERSAL_ID',
  p_display_order          =>5,
  p_column_identifier      =>'E',
  p_column_label           =>'Parent Traversal Id',
  p_report_label           =>'Parent Traversal Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324116285771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MODULE_NAME',
  p_display_order          =>6,
  p_column_identifier      =>'F',
  p_column_label           =>'Module Name',
  p_report_label           =>'Module Name',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324209577771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'UNIT_NAME',
  p_display_order          =>7,
  p_column_identifier      =>'G',
  p_column_label           =>'Unit Name',
  p_report_label           =>'Unit Name',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'<span style="padding-left:#LEVEL*10#px;">#UNIT_NAME#</span>',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324329687771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'UNIT_TYPE',
  p_display_order          =>8,
  p_column_identifier      =>'H',
  p_column_label           =>'Unit Type',
  p_report_label           =>'Unit Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324417664771241+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MESSAGE_ID',
  p_display_order          =>9,
  p_column_identifier      =>'I',
  p_column_label           =>'Message Id',
  p_report_label           =>'Message Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324622559771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MSG_LEVEL',
  p_display_order          =>11,
  p_column_identifier      =>'K',
  p_column_label           =>'Msg Level',
  p_report_label           =>'Msg Level',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324707816771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TIME_NOW',
  p_display_order          =>12,
  p_column_identifier      =>'L',
  p_column_label           =>'Time',
  p_report_label           =>'Time',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'DD-MON-YYYY HH24:MI:SS',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324831291771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MSG_LEVEL_TEXT',
  p_display_order          =>13,
  p_column_identifier      =>'M',
  p_column_label           =>'Msg Level Text',
  p_report_label           =>'Msg Level Text',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3324926612771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'LEVEL',
  p_display_order          =>14,
  p_column_identifier      =>'N',
  p_column_label           =>'Level',
  p_report_label           =>'Level',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325000510771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MODULE_ID',
  p_display_order          =>16,
  p_column_identifier      =>'P',
  p_column_label           =>'Module Id',
  p_report_label           =>'Module Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325123734771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MODULE_TYPE',
  p_display_order          =>17,
  p_column_identifier      =>'Q',
  p_column_label           =>'Module Type',
  p_report_label           =>'Module Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325215404771242+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MSG_MODE',
  p_display_order          =>18,
  p_column_identifier      =>'R',
  p_column_label           =>'Msg Mode',
  p_report_label           =>'Msg Mode',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325318056771243+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'LEVEL_UNIT_NAME',
  p_display_order          =>19,
  p_column_identifier      =>'S',
  p_column_label           =>'Level Unit Name',
  p_report_label           =>'Level Unit Name',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RIR,RP,8:P8_PROCESS_ID,P8_TRAVERSAL_ID:&P8_PROCESS_ID.,#TRAVERSAL_ID#',
  p_column_linktext        =>'#LEVEL_UNIT_NAME#',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325420306771243+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MSG_TYPE',
  p_display_order          =>20,
  p_column_identifier      =>'T',
  p_column_label           =>'Msg Type',
  p_report_label           =>'Msg Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325505839771243+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'NAME',
  p_display_order          =>21,
  p_column_identifier      =>'U',
  p_column_label           =>'Name',
  p_report_label           =>'Name',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3325624917771243+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'VALUE',
  p_display_order          =>22,
  p_column_identifier      =>'V',
  p_column_label           =>'Value',
  p_report_label           =>'Value',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 3633506052626262+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MESSAGE',
  p_display_order          =>23,
  p_column_identifier      =>'W',
  p_column_label           =>'Message',
  p_report_label           =>'Message',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_allow_group_by         =>'N',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'CLOB',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'N',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'Params and Notes',
  p_report_seq              =>10,
  p_report_alias            =>'PARAMS_NOTES',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>1000,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'MESSAGE_ID',
  p_sort_direction_1        =>'ASC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_break_on                =>'LEVEL_UNIT_NAME:0:0:0:0:0',
  p_break_enabled_on        =>'0:0:0:0:0',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326103449771244+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Unit Name',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'LEVEL_UNIT_NAME',
  p_operator                =>'is not null',
  p_condition_sql           =>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME#',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_column_bg_color         =>'#99CCFF',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326213326771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Comment',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Comment',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Comment''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#CCFFCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326326317771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Info',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Info ?',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Info ?''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#C77AC6',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326431021771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Warning',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Warning !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Warning !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF9900',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326515657771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Error',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'in',
  p_expr                    =>'Oracle Error,Fatal !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#F24343',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326613700771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Note',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Note',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Note''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFFF99',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326719415771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_name                    =>'Param',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Param',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Param''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFCCCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3326014948771244+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3325822136771244+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'in',
  p_expr                    =>'Param,Note',
  p_condition_sql           =>'"MSG_TYPE" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Param, Note''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'TIME_NOW:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'Messages',
  p_report_seq              =>10,
  p_report_alias            =>'MESSAGES',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>1000,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'MESSAGE_ID',
  p_sort_direction_1        =>'ASC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_break_on                =>'LEVEL_UNIT_NAME:0:0:0:0:0',
  p_break_enabled_on        =>'0:0:0:0:0',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635118763635596+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Unit Name',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'LEVEL_UNIT_NAME',
  p_operator                =>'is not null',
  p_condition_sql           =>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME#',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_column_bg_color         =>'#99CCFF',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635229790635596+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Comment',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Comment',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Comment''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#CCFFCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635302939635596+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Info',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Info ?',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Info ?''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#C77AC6',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635401582635596+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Warning',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Warning !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Warning !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF9900',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635528286635597+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Error',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'in',
  p_expr                    =>'Oracle Error,Fatal !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#F24343',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635607222635597+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Note',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Note',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Note''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFFF99',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635728579635597+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_name                    =>'Param',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Param',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Param''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFCCCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3635006953635596+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3326806431771245+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Message',
  p_condition_sql           =>'"MSG_TYPE" = #APXWS_EXPR#',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Message''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_report_alias            =>'PRIMARY',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>1000,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'MESSAGE_ID',
  p_sort_direction_1        =>'ASC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_break_on                =>'LEVEL_UNIT_NAME:0:0:0:0:0',
  p_break_enabled_on        =>'0:0:0:0:0',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328027640771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Unit Name',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'LEVEL_UNIT_NAME',
  p_operator                =>'is not null',
  p_condition_sql           =>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME#',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_column_bg_color         =>'#99CCFF',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328123175771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Comment',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Comment',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Comment''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#CCFFCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328220615771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Info',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Info ?',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Info ?''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#C77AC6',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328329214771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Warning',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Warning !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Warning !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF9900',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328411822771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Error',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'in',
  p_expr                    =>'Oracle Error,Fatal !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#F24343',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328517909771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Note',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Note',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Note''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFFF99',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328612157771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3327801164771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Param',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Param',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Param''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFCCCC',
  p_column_format           =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:TIME_NOW:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 3328714246771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'Exceptions',
  p_report_seq              =>10,
  p_report_alias            =>'EXCEPTIONS',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>100,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'MESSAGE_ID',
  p_sort_direction_1        =>'ASC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_break_on                =>'LEVEL_UNIT_NAME:0:0:0:0:0',
  p_break_enabled_on        =>'0:0:0:0:0',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3329009909771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3328714246771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Unit Name',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'LEVEL_UNIT_NAME',
  p_operator                =>'is not null',
  p_condition_sql           =>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME#',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_column_bg_color         =>'#99CCFF',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3329112401771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3328714246771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Warning',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Warning !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Warning !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF9900',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3329224312771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3328714246771246+wwv_flow_api.g_id_offset,
  p_name                    =>'Error',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'in',
  p_expr                    =>'Oracle Error,Fatal !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF3333',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3328919304771246+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3328714246771246+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'in',
  p_expr                    =>'Internal Error,Warning !,Fatal !',
  p_condition_sql           =>'"MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Internal Error, Warning !, Fatal !''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'TIME_NOW:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'No debugging',
  p_report_seq              =>10,
  p_report_alias            =>'35118',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>1000,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'MESSAGE_ID',
  p_sort_direction_1        =>'ASC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_break_on                =>'LEVEL_UNIT_NAME:0:0:0:0:0',
  p_break_enabled_on        =>'0:0:0:0:0',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637027454638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Unit Name',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'LEVEL_UNIT_NAME',
  p_operator                =>'is not null',
  p_condition_sql           =>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME#',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_column_bg_color         =>'#99CCFF',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637104191638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Comment',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Comment',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Comment''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#CCFFCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637222574638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Info',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Info ?',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Info ?''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#C77AC6',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637309570638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Warning',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'=',
  p_expr                    =>'Warning !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Warning !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF9900',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637425314638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Error',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'in',
  p_expr                    =>'Oracle Error,Fatal !',
  p_condition_sql           =>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#F24343',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637520080638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Note',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Note',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Note''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFFF99',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3637631473638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_name                    =>'Param',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Param',
  p_condition_sql           =>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Param''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFCCCC',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3636818381638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_LEVEL_TEXT',
  p_operator                =>'!=',
  p_expr                    =>'Comment',
  p_condition_sql           =>'"MSG_LEVEL_TEXT" != #APXWS_EXPR#',
  p_condition_display       =>'#APXWS_COL_NAME# != ''Comment''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 3636911646638897+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 24,
  p_worksheet_id => 3323512923771237+wwv_flow_api.g_id_offset,
  p_report_id => 3511709067041734+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'MSG_TYPE',
  p_operator                =>'=',
  p_expr                    =>'Message',
  p_condition_sql           =>'"MSG_TYPE" = #APXWS_EXPR#',
  p_condition_display       =>'#APXWS_COL_NAME# = ''Message''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3218020641999663 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 24,
  p_name=>'P24_PROCESS_ID',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select max(process_id) from ms_process',
  p_source_type=> 'QUERY',
  p_display_as=> 'NATIVE_HIDDEN',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_new_grid=> false,
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_grid_column=> null,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 3335616331903623 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 24
 ,p_name => 'HideControlPanel'
 ,p_event_sequence => 10
 ,p_triggering_element_type => 'REGION'
 ,p_triggering_region_id => 3323316575771236 + wwv_flow_api.g_id_offset
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'apexafterrefresh'
  );
wwv_flow_api.create_page_da_action (
  p_id => 3335927750903625 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 24
 ,p_event_id => 3335616331903623 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'Y'
 ,p_action => 'NATIVE_JAVASCRIPT_CODE'
 ,p_attribute_01 => '//If Control Panel is visible , toggle it off.'||unistr('\000a')||
'if(!($(''#apexir_CONTROL_PANEL_COMPLETE'').css(''display'') == ''none'') ){'||unistr('\000a')||
'   gReport.toggle_controls( $x(''apexir_CONTROL_PANEL_CONTROL'') );'||unistr('\000a')||
'    return false;'||unistr('\000a')||
'}'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 24
--
 
begin
 
null;
end;
null;
 
end;
/

 
