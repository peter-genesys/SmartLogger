--application/pages/page_00009
prompt  ...PAGE 9: Logger Control
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 9
 ,p_user_interface_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_tab_set => 'TS1'
 ,p_name => 'Logger Control'
 ,p_step_title => 'Logger Control'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'Modules Registry'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'NO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_javascript_code => 
'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'PBURGESS'
 ,p_last_upd_yyyymmddhh24miss => '20140716152334'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select '||unistr('\000a')||
'"MODULE_ID",'||unistr('\000a')||
'"MODULE_ID" MODULE_ID_DISPLAY,'||unistr('\000a')||
'"MODULE_NAME",'||unistr('\000a')||
'"REVISION",'||unistr('\000a')||
'"MODULE_TYPE",'||unistr('\000a')||
'"MSG_MODE",'||unistr('\000a')||
'"OPEN_PROCESS"'||unistr('\000a')||
'from "#OWNER#"."MS_MODULE"'||unistr('\000a')||
'where owner = :P9_OWNER'||unistr('\000a')||
'';

wwv_flow_api.create_report_region (
  p_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 9,
  p_name=> 'Modules',
  p_region_name=>'',
  p_template=> 17756349234931434+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 15,
  p_new_grid         => false,
  p_new_grid_row     => false,
  p_new_grid_column  => false,
  p_display_column=> 1,
  p_display_point=> 'BODY_3',
  p_item_display_point=> 'ABOVE',
  p_source=> s,
  p_source_type=> 'UPDATABLE_SQL_QUERY',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'N',
  p_query_row_template=> 17758952883931438+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> '(null)',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No data found.',
  p_query_num_rows_item=> 'P9_NUM_ROWS',
  p_query_num_rows_type=> 'ROW_RANGES_IN_SELECT_LIST',
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
  p_id=> 17797363988021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'CHECK$01',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'CHECKBOX',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_derived_column=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s:=s||'MS_MODULE_SEQ';

wwv_flow_api.create_report_columns (
  p_id=> 17797448030021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_ID',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Module Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'HIDDEN',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source_type=> 'S',
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_ID',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797557773021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_ID_DISPLAY',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Edit Units',
  p_use_as_row_header=> 'N',
  p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_MODULE_ID,P10_MODULE_NAME:#MODULE_ID#,#MODULE_NAME#',
  p_column_linktext=>'<img src="#IMAGE_PREFIX#ed-item.gif" alt="">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_ID_DISPLAY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797651652021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_NAME',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Module Name',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_NAME',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797738546021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'REVISION',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Revision',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'ESCAPE_SC',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'REVISION',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797856515021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_TYPE',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Module Type',
  p_use_as_row_header=> 'N',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'SELECT_LIST',
  p_inline_lov=> 'Package;PACKAGE,Procedure;PROCEDURE,Function;FUNCTION,Trigger;TRIGGER,Oracle Report;REPORT,Oracle Form;FORM,Oracle Report PLSQL Library;REPORT_LIB,Oracle Form PLSQL Library;FORM_LIB,Apex App;APEX',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '10',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_TYPE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797939356021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'MSG_MODE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Msg Mode',
  p_use_as_row_header=> 'N',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'SELECT_LIST',
  p_inline_lov=> 'Disabled;99,Quiet;4,Normal;2,Debug;1',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MSG_MODE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17798061923021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'OPEN_PROCESS',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Open Process',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'SELECT_LIST',
  p_inline_lov=> 'No;N,Yes;Y,If Closed;C',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '12',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'OPEN_PROCESS',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 17828839680390260 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 9,
  p_plug_name=> 'Breadcrumb',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17755063450931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => false,
  p_plug_new_grid_column  => false,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_item_display_point=> 'BELOW',
  p_plug_source=> s,
  p_plug_source_type=> 'M'|| to_char(17762344465931475 + wwv_flow_api.g_id_offset),
  p_menu_template_id=> 17759948703931450+ wwv_flow_api.g_id_offset,
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 17798145228021548 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 30,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'SUBMIT',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Submit',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17798346024021555 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 40,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
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
  p_id             => 3520316226535807 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 50,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'ALL_QUIET',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754539557931433+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'All Quiet',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3520501466540961 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 60,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'ALL_NORMAL',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754539557931433+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'All Normal',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3520722937547217 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 70,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'ALL_DEBUG',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754539557931433+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'All Debug',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3520932287549855 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 80,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'REPORT_STD',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Report Std',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3592526739274387 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 85,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'ALL_DISABLED',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754764340931433+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'All Disabled',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17798549235021555 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 10,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_action  => 'REDIRECT_PAGE',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17798749286021556 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 20,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'MULTI_ROW_DELETE',
  p_button_action  => 'REDIRECT_URL',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Delete',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:apex.confirm(htmldb_delete_message,''MULTI_ROW_DELETE'');',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>17799834795021560 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 9,
  p_branch_name=> '',
  p_branch_action=> 'f?p=&APP_ID.:9:&SESSION.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 1,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3479312598090992 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 9,
  p_name=>'P9_NUM_ROWS',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rows',
  p_source=>'20',
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
  p_id=>3589424059123700 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 9,
  p_name=>'P9_OWNER',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Owner',
  p_source=>'select min(owner) from ms_module where owner <> ''LOGGER''',
  p_source_type=> 'QUERY',
  p_display_as=> 'NATIVE_SELECT_LIST',
  p_lov=> 'select DISTINCT initcap(OWNER) display, OWNER value'||unistr('\000a')||
'from MS_MODULE'||unistr('\000a')||
'',
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
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'SUBMIT',
  p_attribute_03 => 'N',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 17799041238021557 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_tabular_form_region_id => 17797158749021547 + wwv_flow_api.g_id_offset,
  p_validation_name => 'MSG_MODE must be numeric',
  p_validation_sequence=> 60,
  p_validation => 'MSG_MODE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => '#COLUMN_HEADER# must be numeric.',
  p_when_button_pressed=> 17798145228021548 + wwv_flow_api.g_id_offset,
  p_associated_column=> 'MSG_MODE',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:MS_MODULE:MODULE_ID';

wwv_flow_api.create_page_process(
  p_id     => 17799151935021559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_process_type=> 'MULTI_ROW_UPDATE',
  p_process_name=> 'ApplyMRU',
  p_process_sql_clob => p,
  p_process_error_message=> 'Unable to process update.',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when_button_id=>17798145228021548 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '#MRU_COUNT# row(s) updated, #MRI_COUNT# row(s) inserted.',
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
p:=p||'#OWNER#:MS_MODULE:MODULE_ID';

wwv_flow_api.create_page_process(
  p_id     => 17799364204021559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_process_type=> 'MULTI_ROW_DELETE',
  p_process_name=> 'ApplyMRD',
  p_process_sql_clob => p,
  p_process_error_message=> 'Unable to process delete.',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when=>'MULTI_ROW_DELETE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '#MRD_COUNT# row(s) deleted.',
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
p:=p||'ms_api.purge_old_processes(i_keep_day_count => 1);';

wwv_flow_api.create_page_process(
  p_id     => 17799549173021559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'PurgeOldProcesses',
  p_process_sql_clob => p,
  p_process_error_message=> '',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when_button_id=>17798346024021555 + wwv_flow_api.g_id_offset,
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
p:=p||'update ms_module'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEBUG'||unistr('\000a')||
'--DONT CHANGE OPEN PROCESS   ,open_process = ms_logger.G_OPEN_PROCESS_IF_CLOSED'||unistr('\000a')||
'where owner = :P9_OWNER'||unistr('\000a')||
';'||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEFAULT '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_DEFAULT'||unistr('\000a')||
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
'commit;';

wwv_flow_api.create_page_process(
  p_id     => 3514018857101307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetAllDebug',
  p_process_sql_clob => p,
  p_process_error_message=> 'Failed to set &P9_OWNER. modules to Debug mode.',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when_button_id=>3520722937547217 + wwv_flow_api.g_id_offset,
  p_only_for_changed_rows=> 'Y',
  p_process_success_message=> 'All &P9_OWNER. Modules are now in Debug mode. Open Process settings are unchanged.',
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
p:=p||'update ms_module'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_QUIET '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_NEVER'||unistr('\000a')||
'where owner = :P9_OWNER'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEFAULT '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_DEFAULT'||unistr('\000a')||
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'Commit;';

wwv_flow_api.create_page_process(
  p_id     => 3515205051125782 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetAllQuiet',
  p_process_sql_clob => p,
  p_process_error_message=> 'Failed to set &P9_OWNER. modules to Quiet mode.',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when_button_id=>3520316226535807 + wwv_flow_api.g_id_offset,
  p_only_for_changed_rows=> 'Y',
  p_process_success_message=> 'All &P9_OWNER. Modules are now in Quiet mode.  No Processes will start.',
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
p:=p||'update ms_module'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_NORMAL'||unistr('\000a')||
'--DONT CHANGE OPEN_PROCESS   ,open_process = ms_logger.G_OPEN_PROCESS_IF_CLOSED'||unistr('\000a')||
'where owner = :P9_OWNER'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEFAULT '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_DEFAULT'||unistr('\000a')||
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'commit;';

wwv_flow_api.create_page_process(
  p_id     => 3515824360150247 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetAllNormal',
  p_process_sql_clob => p,
  p_process_error_message=> 'Failed to set &P9_OWNER. modules to Normal mode.',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when_button_id=>3520501466540961 + wwv_flow_api.g_id_offset,
  p_only_for_changed_rows=> 'Y',
  p_process_success_message=> 'All &P9_OWNER. Modules are now in Normal mode. Open Process settings are unchanged.',
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
p:=p||'--Set Report Modules to Normal'||unistr('\000a')||
'update ms_module'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_NORMAL'||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_IF_CLOSED'||unistr('\000a')||
'where module_type = ''REPORT'''||unistr('\000a')||
'and   owner = :P9_OWNER'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'--Set Report Units to Overridden'||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEFAULT '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_DEFAULT'||unistr('\000a')||
'where module_id in (select module_id from ms_m';

p:=p||'odule where module_type = ''REPORT'' and owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'--Set Reports Parameter routine to debug.'||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEBUG'||unistr('\000a')||
'where unit_name  = ''get_parameters'''||unistr('\000a')||
'and module_id in (select module_id from ms_module where module_type = ''REPORT'' and owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'--Set Report Library Modules to Disabled'||unistr('\000a')||
'update ms_module'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MO';

p:=p||'DE_DISABLED'||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_NEVER'||unistr('\000a')||
'where module_type = ''REPORT_LIB'''||unistr('\000a')||
'and   owner = :P9_OWNER'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'--Set Report Library Units to Overridden'||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEFAULT '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_DEFAULT'||unistr('\000a')||
'where module_id in (select module_id from ms_module where module_type = ''REPORT_LIB'' and owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
' '||unistr('\000a')||
'commit;';

wwv_flow_api.create_page_process(
  p_id     => 3517218829224273 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetReportsStd',
  p_process_sql_clob => p,
  p_process_error_message=> 'Failed to set &P9_OWNER. Reports to Standard mode.',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when_button_id=>3520932287549855 + wwv_flow_api.g_id_offset,
  p_only_for_changed_rows=> 'Y',
  p_process_success_message=> '&P9_OWNER. Reports are now in Standard mode. <BR>'||unistr('\000a')||
'Reports will open processes in Normal message mode, with ''get_parameters'' unit set to Debug.<BR>'||unistr('\000a')||
'Report Libraries are set to Disabled, to keep the tree neater. ',
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
p:=p||'update ms_module'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DISABLED '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_NEVER'||unistr('\000a')||
'where owner = :P9_OWNER'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'update ms_unit'||unistr('\000a')||
'set msg_mode     = ms_logger.G_MSG_MODE_DEFAULT '||unistr('\000a')||
'   ,open_process = ms_logger.G_OPEN_PROCESS_DEFAULT'||unistr('\000a')||
'where module_id in (select module_id from ms_module where owner = :P9_OWNER)'||unistr('\000a')||
';'||unistr('\000a')||
''||unistr('\000a')||
'Commit;';

wwv_flow_api.create_page_process(
  p_id     => 3592724849278780 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetAllDisabled',
  p_process_sql_clob => p,
  p_process_error_message=> 'Failed to Disable &P9_OWNER. modules.',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when_button_id=>3592526739274387 + wwv_flow_api.g_id_offset,
  p_only_for_changed_rows=> 'Y',
  p_process_success_message=> 'All &P9_OWNER. Modules are Disabled.  No Processes will start.<BR>'||unistr('\000a')||
'No nodes, messages, or references are recorded for Disabled module/units. ',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 9
--
 
begin
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135229349204946 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 1,
  p_query_column_name=> 'MODULE_ID',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135302161204947 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 2,
  p_query_column_name=> 'MODULE_ID_DISPLAY',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135413644204947 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 3,
  p_query_column_name=> 'MODULE_NAME',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135516971204947 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 4,
  p_query_column_name=> 'REVISION',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135602766204947 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 5,
  p_query_column_name=> 'MODULE_TYPE',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135717476204947 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 6,
  p_query_column_name=> 'MSG_MODE',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 3135821260204947 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 7,
  p_query_column_name=> 'OPEN_PROCESS',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
null;
end;
null;
 
end;
/

 
