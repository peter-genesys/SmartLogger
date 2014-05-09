--application/pages/page_00006
prompt  ...PAGE 6: Step 1
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 6
 ,p_user_interface_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_tab_set => 'TS1'
 ,p_name => 'Step 1'
 ,p_step_title => 'Step 1'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'NO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_javascript_code => 
'function clob_set(){'||unistr('\000a')||
'  alert(''clob_set'');'||unistr('\000a')||
'  var oEditor = FCKeditorAPI.GetInstance(''P6_DEMO_TEXT'');'||unistr('\000a')||
'  var clob_ob = new apex.ajax.clob('||unistr('\000a')||
'    function(){'||unistr('\000a')||
'      var rs = p.readyState'||unistr('\000a')||
'      if(rs == 1||rs == 2||rs == 3){'||unistr('\000a')||
'        $x_Show(''AjaxLoading'');'||unistr('\000a')||
'      }else if(rs == 4){'||unistr('\000a')||
'        //doSubmit(request);'||unistr('\000a')||
'        $x_Hide(''AjaxLoading'');'||unistr('\000a')||
'      }else{return false;}'||unistr('\000a')||
'    }'||unistr('\000a')||
'  );'||unistr('\000a')||
'  var p_html = oEditor.GetH'||
'TML();'||unistr('\000a')||
'alert(p_html);'||unistr('\000a')||
'  if (p_html){'||unistr('\000a')||
'    clob_ob._set(p_html);'||unistr('\000a')||
'  } else {'||unistr('\000a')||
'    p_html = '' '''||unistr('\000a')||
'    clob_ob._set(p_html);'||unistr('\000a')||
'  }'||unistr('\000a')||
'};'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function clob_set_plain(){'||unistr('\000a')||
'  alert(''clob_set_plain'');'||unistr('\000a')||
'  var clob_ob = new apex.ajax.clob('||unistr('\000a')||
'    function(){'||unistr('\000a')||
'      var rs = p.readyState'||unistr('\000a')||
'      if(rs == 1||rs == 2||rs == 3){'||unistr('\000a')||
'        $x_Show(''AjaxLoading'');'||unistr('\000a')||
'      }else if(rs == 4){'||unistr('\000a')||
'        //doSubmit(request);'||unistr('\000a')||
'        $x_Hide('''||
'AjaxLoading'');'||unistr('\000a')||
'      }else{return false;}'||unistr('\000a')||
'    }'||unistr('\000a')||
'  );'||unistr('\000a')||
'  var p_html = $v(''P6_ORIG_TEXT'');'||unistr('\000a')||
'alert(p_html);'||unistr('\000a')||
'  if (p_html){'||unistr('\000a')||
'    clob_ob._set(p_html);'||unistr('\000a')||
'  } else {'||unistr('\000a')||
'    p_html = '' '''||unistr('\000a')||
'    clob_ob._set(p_html);'||unistr('\000a')||
'  }'||unistr('\000a')||
'};'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'PBURGESS'
 ,p_last_upd_yyyymmddhh24miss => '20140508172637'
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
  p_id=> 2726522443084856 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Breadcrumb',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17755063450931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => true,
  p_plug_new_grid_column  => true,
  p_plug_display_column=> null,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_item_display_point=> 'ABOVE',
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
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 2749417042618839 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Step 1',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17756839023931435+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => true,
  p_plug_new_grid_column  => true,
  p_plug_display_column=> null,
  p_plug_display_point=> 'BODY_3',
  p_plug_item_display_point=> 'ABOVE',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'Paste unwoven pl/sql from forms or reports program units, into this window.'||unistr('\000a')||
'<BR><BR>'||unistr('\000a')||
'This code may contain ms_feedback calls.'||unistr('\000a')||
'<BR><BR>'||unistr('\000a')||
'The text will be "woven" using the AOP_PROCESSOR, employing the same process used on the database.';

wwv_flow_api.create_page_plug (
  p_id=> 2749714244618841 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Information',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17756562599931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => false,
  p_plug_new_grid_column  => true,
  p_plug_display_column=> null,
  p_plug_display_point=> 'BODY_3',
  p_plug_item_display_point=> 'ABOVE',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 2750001355618843 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 6,
  p_button_sequence=> 10,
  p_button_plug_id => 2749417042618839+wwv_flow_api.g_id_offset,
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
  p_id             => 2750320616618843 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 6,
  p_button_sequence=> 30,
  p_button_plug_id => 2749417042618839+wwv_flow_api.g_id_offset,
  p_button_name    => 'NEXT',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Next >',
  p_button_position=> 'REGION_TEMPLATE_NEXT',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>2750727157618845 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_branch_name=> '',
  p_branch_action=> 'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>2750320616618843+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2732506788403662 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_name=>'P6_COLLECT',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 2749417042618839+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_prompt=>'Collect Rich Text',
  p_display_as=> 'BUTTON',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_new_grid=> false,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> null,
  p_rowspan=> null,
  p_grid_column=> null,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'N',
  p_button_execute_validations=>'Y',
  p_button_action => 'DEFINED_BY_DA',
  p_button_is_hot=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2734308665643313 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_name=>'P6_DEMO_TEXT',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 2749417042618839+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Demo Text',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_RICH_TEXT_EDITOR',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 120,
  p_cMaxlength=> 64000,
  p_cHeight=> 20,
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
  p_attribute_01 => 'FCKEDITOR2',
  p_attribute_02 => 'Basic',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2735204447734052 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_name=>'P6_COLLECT_ORIG_TEXT',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 2749417042618839+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_prompt=>'Collect Orig Text',
  p_display_as=> 'BUTTON',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_new_grid=> false,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> null,
  p_rowspan=> null,
  p_grid_column=> null,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'N',
  p_button_execute_validations=>'Y',
  p_button_action => 'DEFINED_BY_DA',
  p_button_is_hot=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2749925220618842 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_name=>'P6_ORIG_TEXT',
  p_data_type=> '',
  p_is_required=> true,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2749417042618839+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Original Text',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_TEXTAREA',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 120,
  p_cHeight=> 30,
  p_new_grid=> false,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> null,
  p_rowspan=> null,
  p_grid_column=> null,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_field_template=> 17759837603931450+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'Y',
  p_attribute_02 => 'N',
  p_attribute_03 => 'N',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 2733123410408404 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 6
 ,p_name => 'CollectText'
 ,p_event_sequence => 10
 ,p_triggering_element_type => 'BUTTON'
 ,p_triggering_button_id => 2732506788403662 + wwv_flow_api.g_id_offset
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'click'
  );
wwv_flow_api.create_page_da_action (
  p_id => 2733417679408414 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 6
 ,p_event_id => 2733123410408404 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_JAVASCRIPT_CODE'
 ,p_attribute_01 => '//setApexCollectionClob (''TEST<BR>TEXT'', function(){alert(''Data saved to Apex Collection!'')});'||unistr('\000a')||
'clob_set();'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 2735913844765195 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 6
 ,p_name => 'CollectPlainText'
 ,p_event_sequence => 20
 ,p_triggering_element_type => 'BUTTON'
 ,p_triggering_button_id => 2735204447734052 + wwv_flow_api.g_id_offset
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'click'
  );
wwv_flow_api.create_page_da_action (
  p_id => 2736215026765196 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 6
 ,p_event_id => 2735913844765195 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_JAVASCRIPT_CODE'
 ,p_attribute_01 => 'clob_set_plain();'
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
p:=p||'declare'||unistr('\000a')||
'  l_clob clob:= empty_clob();'||unistr('\000a')||
'  l_woven boolean;'||unistr('\000a')||
'begin'||unistr('\000a')||
''||unistr('\000a')||
'  if apex_collection.collection_exists(p_collection_name=>''CLOB_CONTENT'') then'||unistr('\000a')||
'    apex_collection.delete_collection(p_collection_name=>''CLOB_CONTENT'');'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  apex_collection.create_or_truncate_collection(p_collection_name=>''CLOB_CONTENT'');'||unistr('\000a')||
'  dbms_lob.createtemporary( l_clob, false, dbms_lob.SESSION );'||unistr('\000a')||
' '||unistr('\000a')||
' -- l_clob  := :P6_ORIG';

p:=p||'_TEXT;'||unistr('\000a')||
'  --l_woven := aop_processor.weave(l_clob, ''Adhoc'',TRUE);'||unistr('\000a')||
''||unistr('\000a')||
' l_clob  := ''<PRE>''||logger.aop_processor.get_body'||unistr('\000a')||
'  ( p_object_name  => ''MS_LOGGER'''||unistr('\000a')||
'  , p_object_owner => ''LOGGER'')||''</PRE>'';'||unistr('\000a')||
' '||unistr('\000a')||
' '||unistr('\000a')||
'  apex_collection.add_member(p_collection_name => ''CLOB_CONTENT'',p_clob001 => l_clob);'||unistr('\000a')||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 2728801191947880 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 6,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'StoreResult',
  p_process_sql_clob => p,
  p_process_error_message=> '',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when=>'',
  p_process_when_type=>'NEVER',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 6
--
 
begin
 
null;
end;
null;
 
end;
/

 
