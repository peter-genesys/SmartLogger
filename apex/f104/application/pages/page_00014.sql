--application/pages/page_00014
prompt  ...PAGE 14: AOP Step 1
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 14
 ,p_user_interface_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_tab_set => 'TS1'
 ,p_name => 'AOP Step 1'
 ,p_step_title => 'AOP Step 1'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'NO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_javascript_code => 
'function textarea_clob_set(i_field_name){'||unistr('\000a')||
'  //alert(''textarea_clob_set'');'||unistr('\000a')||
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
'  var l_plain_text = $v(i_field_name);'||unistr('\000a')||
'  //alert(l_pl'||
'ain_text);'||unistr('\000a')||
'  if (l_plain_text){'||unistr('\000a')||
'    clob_ob._set(l_plain_text);'||unistr('\000a')||
'  } else {'||unistr('\000a')||
'    l_plain_text = '' '''||unistr('\000a')||
'    clob_ob._set(l_plain_text);'||unistr('\000a')||
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
 ,p_last_upd_yyyymmddhh24miss => '20140509114410'
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
  p_id=> 2737732239876009 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 14,
  p_plug_name=> 'Step 1 Input',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 2738014889876010 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 14,
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
  p_id             => 2738331805876011 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 14,
  p_button_sequence=> 10,
  p_button_plug_id => 2737732239876009+wwv_flow_api.g_id_offset,
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
  p_id             => 2738624792876011 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 14,
  p_button_sequence=> 30,
  p_button_plug_id => 2737732239876009+wwv_flow_api.g_id_offset,
  p_button_name    => 'NEXT',
  p_button_action  => 'DEFINED_BY_DA',
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
  p_id=>2739004586876011 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 14,
  p_branch_name=> '',
  p_branch_action=> 'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>2738624792876011+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2748600272890215 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 14,
  p_name=>'P14_ORIG_TEXT',
  p_data_type=> '',
  p_is_required=> true,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 2737732239876009+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Original Text',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_TEXTAREA',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 120,
  p_cMaxlength=> 128000,
  p_cHeight=> 40,
  p_new_grid=> false,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> null,
  p_rowspan=> null,
  p_grid_column=> null,
  p_label_alignment=> 'ABOVE',
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
  p_id => 2748922090937821 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 14
 ,p_name => 'TextareaToClob'
 ,p_event_sequence => 10
 ,p_triggering_element_type => 'BUTTON'
 ,p_triggering_button_id => 2738624792876011 + wwv_flow_api.g_id_offset
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'click'
  );
wwv_flow_api.create_page_da_action (
  p_id => 2749204089937821 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 14
 ,p_event_id => 2748922090937821 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_JAVASCRIPT_CODE'
 ,p_attribute_01 => 'textarea_clob_set(''P14_ORIG_TEXT'');'
 ,p_stop_execution_on_error => 'Y'
 );
wwv_flow_api.create_page_da_action (
  p_id => 2749421788941055 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 14
 ,p_event_id => 2748922090937821 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 20
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_SUBMIT_PAGE'
 ,p_attribute_01 => 'NEXT'
 ,p_attribute_02 => 'Y'
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
'  dbms_lob.createtemporary( l_clob, false, dbms_lob.SESSION );'||unistr('\000a')||
''||unistr('\000a')||
'  if apex_collection.collection_exists(p_collection_name=>''CLOB_CONTENT'') then'||unistr('\000a')||
'    SELECT clob001 INTO l_clob'||unistr('\000a')||
'    FROM APEX_collections'||unistr('\000a')||
'    WHERE collection_name = ''CLOB_CONTENT'';'||unistr('\000a')||
''||unistr('\000a')||
'    apex_collection.delete_collection(p_collection_name=>''CLOB_CONTENT'');'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  apex';

p:=p||'_collection.create_or_truncate_collection(p_collection_name=>''CLOB_CONTENT'');'||unistr('\000a')||
''||unistr('\000a')||
' '||unistr('\000a')||
' -- l_clob  := :P6_ORIG_TEXT;'||unistr('\000a')||
' l_woven := aop_processor.weave(l_clob, ''Adhoc'',TRUE);'||unistr('\000a')||
''||unistr('\000a')||
'  l_clob := REPLACE(REPLACE(l_clob,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');'||unistr('\000a')||
'  l_clob := REGEXP_REPLACE(l_clob,''(ms_logger)(.+)(;)'',''<B>\1\2\3</B>'');'||unistr('\000a')||
'  l_clob := ''<PRE>''||l_clob||''</PRE>'';'||unistr('\000a')||
' '||unistr('\000a')||
' --l_clob  := ''<PRE>''||logger.aop_processor.get_b';

p:=p||'ody'||unistr('\000a')||
' -- ( p_object_name  => ''MS_LOGGER'''||unistr('\000a')||
' -- , p_object_owner => ''LOGGER'')||''</PRE>'';'||unistr('\000a')||
''||unistr('\000a')||
'  apex_collection.add_member(p_collection_name => ''CLOB_CONTENT'',p_clob001 => l_clob);'||unistr('\000a')||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 2751913058058218 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 14,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'PerformAOP',
  p_process_sql_clob => p,
  p_process_error_message=> 'AOP Failed.',
  p_error_display_location=> 'INLINE_IN_NOTIFICATION',
  p_process_when_button_id=>2738624792876011 + wwv_flow_api.g_id_offset,
  p_only_for_changed_rows=> 'Y',
  p_process_success_message=> 'AOP Successful.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 14
--
 
begin
 
null;
end;
null;
 
end;
/

 
