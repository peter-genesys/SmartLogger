--application/pages/page_00008
prompt  ...PAGE 8: Process Traces
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 8
 ,p_user_interface_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_tab_set => 'TS1'
 ,p_name => 'Process Traces'
 ,p_step_title => 'Process Traces'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'Traversal Tree'
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
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'PBURGESS'
 ,p_last_upd_yyyymmddhh24miss => '20140618101921'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 3604106040701866 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_plug_name=> 'Process',
  p_region_name=>'',
  p_escape_on_http_output=>'Y',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_new_grid         => true,
  p_plug_new_grid_row     => true,
  p_plug_new_grid_column  => true,
  p_plug_display_column=> null,
  p_plug_display_point=> 'BODY_3',
  p_plug_item_display_point=> 'ABOVE',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select case when connect_by_isleaf = 1 then 0'||unistr('\000a')||
'            when level = 1             then 1'||unistr('\000a')||
'            else                           -1'||unistr('\000a')||
'       end as status, '||unistr('\000a')||
'       level, '||unistr('\000a')||
'       "TRAVERSAL_ID" as title, '||unistr('\000a')||
'       null as icon, '||unistr('\000a')||
'       "TRAVERSAL_ID" as value, '||unistr('\000a')||
'       "TRAVERSAL_ID" as tooltip, '||unistr('\000a')||
'       null as link '||unistr('\000a')||
'from "#OWNER#"."MS_TRAVERSAL_MESSAGE_REF_VW"'||unistr('\000a')||
'start with "TRAVERSAL_ID" is null'||unistr('\000a')||
'c';

s:=s||'onnect by prior "TRAVERSAL_ID" = "TRAVERSAL_ID"'||unistr('\000a')||
'order siblings by "MESSAGE_ID"';

wwv_flow_api.create_page_plug (
  p_id=> 17790450819976198 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_plug_name=> 'Process &P8_PROCESS_ID. - Stack Trace',
  p_region_name=>'',
  p_parent_plug_id=>3604106040701866 + wwv_flow_api.g_id_offset,
  p_escape_on_http_output=>'N',
  p_plug_template=> 17755453133931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => true,
  p_plug_new_grid_column  => false,
  p_plug_display_column=> null,
  p_plug_display_point=> 'BODY_3',
  p_plug_item_display_point=> 'ABOVE',
  p_plug_source=> s,
  p_plug_source_type=> 'JSTREE',
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
a1:=a1||'select case when connect_by_isleaf = 1 then 0'||unistr('\000a')||
'            when level = 1             then 1'||unistr('\000a')||
'            else                           -1'||unistr('\000a')||
'       end as status, '||unistr('\000a')||
'       level, '||unistr('\000a')||
'       unit_name||DECODE(:P8_SHOW_MODULE_YN,''Y'','' (''||module_name||'')'')  as title, '||unistr('\000a')||
'       null as icon, '||unistr('\000a')||
'       TRAVERSAL_ID as value, '||unistr('\000a')||
'       null as tooltip, '||unistr('\000a')||
'	   ''f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_PROCESS_ID,P8_TRAVE';

a1:=a1||'RSAL_ID:&P8_PROCESS_ID.,''||TRAVERSAL_ID  as link, '||unistr('\000a')||
'       TRAVERSAL_ID,'||unistr('\000a')||
'       PARENT_TRAVERSAL_ID'||unistr('\000a')||
'from ms_unit_traversal_vw'||unistr('\000a')||
'start with PARENT_TRAVERSAL_ID is null and process_id = :P8_PROCESS_ID'||unistr('\000a')||
'connect by prior TRAVERSAL_ID = PARENT_TRAVERSAL_ID'||unistr('\000a')||
'order siblings by TRAVERSAL_ID';

wwv_flow_api.create_jstree(
  p_id => 17790661705976198+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 8,
  p_region_id => 17790450819976198+wwv_flow_api.g_id_offset,
  p_tree_template     =>'default',
  p_tree_source             =>'',
  p_tree_query             =>a1,
  p_tree_node_title   =>'TRAVERSAL_ID',
  p_tree_node_value   =>'TRAVERSAL_ID',
  p_tree_node_icon   =>'',
  p_tree_node_link   =>'',
  p_tree_node_hints   =>'TRAVERSAL_ID',
  p_tree_start_item   =>'TRAVERSAL_ID',
  p_tree_start_value   =>'',
  p_tree_button_option   =>'',
  p_show_node_link   =>'',
  p_node_link_checksum_type   =>null,
  p_tree_comment          =>'',
  p_show_hints          =>'DB',
  p_tree_has_focus          =>'N',
  p_tree_hint_text          =>'',
  p_tree_click_action          =>'S',
  p_selected_node          =>'P8_TRAVERSAL_ID');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select p.* '||unistr('\000a')||
'      ,(select min(traversal_id) from ms_traversal where parent_traversal_id is null and process_id = p.process_id) top_traversal_id'||unistr('\000a')||
',(select count(*)'||unistr('\000a')||
'from ms_traversal t'||unistr('\000a')||
'    ,ms_message m'||unistr('\000a')||
'where t.process_id = p.process_id'||unistr('\000a')||
'and m.traversal_id = t.traversal_id'||unistr('\000a')||
'and m.msg_level > 2) exception_count'||unistr('\000a')||
'from ms_process p';

wwv_flow_api.create_report_region (
  p_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_name=> 'Process Traces',
  p_region_name=>'',
  p_parent_plug_id=>3604106040701866 + wwv_flow_api.g_id_offset,
  p_template=> 17755453133931434+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 7,
  p_new_grid         => true,
  p_new_grid_row     => false,
  p_new_grid_column  => false,
  p_display_column=> null,
  p_display_point=> 'BODY_3',
  p_item_display_point=> 'ABOVE',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 17758952883931438+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '5',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Processes Found.',
  p_query_num_rows_item=> 'P8_NUM_ROWS',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_break_type_flag=> 'DEFAULT_BREAK_FORMATTING',
  p_csv_output=> 'N',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17791633229976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PROCESS_ID',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Process Id',
  p_use_as_row_header=> 'N',
  p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RIR:P8_PROCESS_ID,P8_TRAVERSAL_ID:#PROCESS_ID#,#TOP_TRAVERSAL_ID#',
  p_column_linktext=>'#PROCESS_ID#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>1,
  p_default_sort_dir=>'desc',
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17791733539976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'EXT_REF',
  p_column_display_sequence=> 3,
  p_column_heading=> 'External Ref',
  p_use_as_row_header=> 'N',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17791833023976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'ORIGIN',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Origin',
  p_use_as_row_header=> 'N',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17791951811976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'USERNAME',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Username',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17792137538976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'COMMENTS',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Comments',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17792246896976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'INTERNAL_ERROR',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Internal Error Flag',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17792335344976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'NOTIFIED_FLAG',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Notified Flag',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3690723041979477 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'ERROR_MESSAGE',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Internal Error Message',
  p_use_as_row_header=> 'N',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17792046024976200 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'CREATED_DATE',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Created DateTime',
  p_column_format=> 'DD-MON-YYYY HH24:MI',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3690816783979481 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'UPDATED_DATE',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Updated Date',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3416006315323711 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'TOP_TRAVERSAL_ID',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Top Traversal Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3656823687778930 + wwv_flow_api.g_id_offset,
  p_region_id=> 17791439222976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'EXCEPTION_COUNT',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Exception Count',
  p_use_as_row_header=> 'N',
  p_column_link=>'f?p=&APP_ID.:8:&SESSION.:IR_REPORT_EXCEPTIONS:&DEBUG.::P8_PROCESS_ID,P8_TRAVERSAL_ID:#PROCESS_ID#,#TOP_TRAVERSAL_ID#',
  p_column_linktext=>'#EXCEPTION_COUNT#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
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
'  star';

s:=s||'t with ut.traversal_id = :P8_TRAVERSAL_ID'||unistr('\000a')||
'  connect by prior ut.TRAVERSAL_ID = ut.PARENT_TRAVERSAL_ID'||unistr('\000a')||
'  order siblings by ut.TRAVERSAL_ID) a'||unistr('\000a')||
'  ,ms_message_vw m'||unistr('\000a')||
'where m.traversal_id = a.traversal_id';

wwv_flow_api.create_page_plug (
  p_id=> 17784247198976192 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_plug_name=> 'References and Messages',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17756239625931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => false,
  p_plug_new_grid_column  => true,
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
'  star';

a1:=a1||'t with ut.traversal_id = :P8_TRAVERSAL_ID'||unistr('\000a')||
'  connect by prior ut.TRAVERSAL_ID = ut.PARENT_TRAVERSAL_ID'||unistr('\000a')||
'  order siblings by ut.TRAVERSAL_ID) a'||unistr('\000a')||
'  ,ms_message_vw m'||unistr('\000a')||
'where m.traversal_id = a.traversal_id';

wwv_flow_api.create_worksheet(
  p_id=> 17784432860976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_region_id=> 17784247198976192+wwv_flow_api.g_id_offset,
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
  p_show_highlight=>'Y',
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
  p_internal_uid=> 17784432860976193);
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 17784535282976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17784654115976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17784746027976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17784835329976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17784954214976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785062291976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785145439976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785246723976193+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785353575976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785542306976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785652953976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785747455976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785856676976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17785948936976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17786041333976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17786156765976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17786248136976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17786361330976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17786440311976194+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 17786545775976195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 3603708621669536+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 3316703584729671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'Params and Notes',
  p_report_seq              =>10,
  p_report_alias            =>'33168',
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
  p_id => 3318628897734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3318717130734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3318820155734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3318929210734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3319015833734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3319131322734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3319213695734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
  p_id => 3318520207734502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3316703584729671+wwv_flow_api.g_id_offset,
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
rc1:=rc1||'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 3319330249737342+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'Messages',
  p_report_seq              =>10,
  p_report_alias            =>'33194',
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
  p_id => 3631918344620554+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3632007641620554+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3632112142620554+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3632222343620555+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3632321015620555+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3632408396620555+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3632501678620556+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3631820544620554+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3319330249737342+wwv_flow_api.g_id_offset,
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
  p_id => 3640806869654473+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'No Debugging',
  p_report_seq              =>10,
  p_report_alias            =>'36409',
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
  p_id => 3643812375660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3643927167660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3644012098660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3644125792660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3644228891660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3644330755660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3644414147660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3643626609660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 3643731247660195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 3640806869654473+wwv_flow_api.g_id_offset,
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
  p_id => 17787661063976195+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_report_alias            =>'76255',
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
  p_id => 3316007955721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
  p_id => 3316124165721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
  p_id => 3316215410721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
  p_id => 3316328131721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
  p_id => 3316431912721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
  p_id => 3316516085721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
  p_id => 3316612678721501+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17787661063976195+wwv_flow_api.g_id_offset,
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
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:TIME_NOW:MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 17788439880976196+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
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
  p_id => 3315622668706945+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17788439880976196+wwv_flow_api.g_id_offset,
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
  p_id => 3315714752706945+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17788439880976196+wwv_flow_api.g_id_offset,
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
  p_id => 3315820644706945+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17788439880976196+wwv_flow_api.g_id_offset,
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
  p_id => 3315523277706945+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_worksheet_id => 17784432860976193+wwv_flow_api.g_id_offset,
  p_report_id => 17788439880976196+wwv_flow_api.g_id_offset,
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 17792458353976200 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 8,
  p_button_sequence=> 20,
  p_button_plug_id => 17791439222976199+wwv_flow_api.g_id_offset,
  p_button_name    => 'PURGE',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Purge Old Processes',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17792645651976200 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 8,
  p_button_sequence=> 30,
  p_button_plug_id => 17791439222976199+wwv_flow_api.g_id_offset,
  p_button_name    => 'PURGE_ALL',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Purge All Processes',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17790836115976199 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 8,
  p_button_sequence=> 10,
  p_button_plug_id => 17790450819976198+wwv_flow_api.g_id_offset,
  p_button_name    => 'CONTRACT_ALL',
  p_button_action  => 'REDIRECT_URL',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Collapse All',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:apex.widget.tree.collapse_all(''tree'||to_char(14982333544675320+wwv_flow_api.g_id_offset)||''');',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17791055596976199 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 8,
  p_button_sequence=> 10,
  p_button_plug_id => 17790450819976198+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPAND_ALL',
  p_button_action  => 'REDIRECT_URL',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Expand All',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:apex.widget.tree.expand_all(''tree'||to_char(14982333544675320+wwv_flow_api.g_id_offset)||''');',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
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
  p_id=>3569513469627266 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 8,
  p_name=>'P8_SHOW_MODULE_YN',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 17790450819976198+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default=> 'N',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Show Module',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_SELECT_LIST',
  p_lov=> 'STATIC2:Yes;Y,No;N',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_new_grid=> false,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> null,
  p_rowspan=> null,
  p_grid_column=> null,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 17759655087931450+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'SUBMIT',
  p_attribute_03 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3595507707881333 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 8,
  p_name=>'P8_NUM_ROWS',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 17791439222976199+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rows',
  p_source=>'5',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_SELECT_LIST',
  p_lov=> 'STATIC2:1;1,5;5,10;10,15;15,20;20,25;25,30;30,50;50,100;100,200;200,500;500,1000;1000,5000;5000',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 3,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_new_grid=> false,
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> null,
  p_rowspan=> null,
  p_grid_column=> null,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 17759556027931449+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'SUBMIT',
  p_attribute_03 => 'N',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17790250937976197 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 8,
  p_name=>'P8_TRAVERSAL_ID',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 17784247198976192+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17791249826976199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 8,
  p_name=>'P8_PROCESS_ID',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 17790450819976198+wwv_flow_api.g_id_offset,
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
  p_id => 3336029669945308 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 8
 ,p_name => 'HideControlPanel'
 ,p_event_sequence => 10
 ,p_triggering_element_type => 'REGION'
 ,p_triggering_region_id => 17784247198976192 + wwv_flow_api.g_id_offset
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'apexafterrefresh'
  );
wwv_flow_api.create_page_da_action (
  p_id => 3336331655945314 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 8
 ,p_event_id => 3336029669945308 + wwv_flow_api.g_id_offset
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'ms_api.purge_old_processes(i_keep_day_count => 1);';

wwv_flow_api.create_page_process(
  p_id     => 17792862111976200 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 8,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'PurgeOldProcesses',
  p_process_sql_clob => p,
  p_process_error_message=> '',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when_button_id=>17792458353976200 + wwv_flow_api.g_id_offset,
  p_process_success_message=> 'Purged old messages',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'ms_api.purge_old_processes(i_keep_day_count => 0);';

wwv_flow_api.create_page_process(
  p_id     => 17793034406976201 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 8,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'PurgeAllProcesses',
  p_process_sql_clob => p,
  p_process_error_message=> '',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when_button_id=>17792645651976200 + wwv_flow_api.g_id_offset,
  p_process_success_message=> 'Purged old messages',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 8
--
 
begin
 
null;
end;
null;
 
end;
/

 
