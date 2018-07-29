prompt --application/pages/page_00021
begin
wwv_flow_api.create_page(
 p_id=>21
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Quick Weave'
,p_page_mode=>'NORMAL'
,p_step_title=>'Quick Weave'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Plugin Step 1'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180718111238'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46700349771834332)
,p_plug_name=>'Original'
,p_region_template_options=>'#DEFAULT#:t-Wizard--hideStepsXSmall'
,p_plug_template=>wwv_flow_api.id(35570409143315927)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(35720076658393451)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(35604144641315949)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38242834867087334)
,p_plug_name=>'Original PL/SQL'
,p_parent_plug_id=>wwv_flow_api.id(46700349771834332)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(35733463000413903)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(46700349771834332)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(35733903882413904)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(46700349771834332)
,p_button_name=>'NEXT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-chevron-right'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(38245133488087339)
,p_branch_name=>'Go To Page 22'
,p_branch_action=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:RP,22::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(35733903882413904)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38245320135098986)
,p_name=>'P21_RAW_INPUT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Raw Input'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>4000
,p_cHeight=>40
,p_field_template=>wwv_flow_api.id(35605504533315950)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Paste unwoven pl/sql from forms or reports program units, into this window.',
'<BR><BR>',
'The text will be "woven" using the AOP_PROCESSOR, employing the same process used on the database.',
'<BR><BR>',
'SPECIAL COMMENTS',
'These special comments can be added to the code to be exposed in the trace.',
'<BR><BR>',
'<UL>',
'<LI>--"" Comment</LI>',
'<LI>--?? Info</LI>',
'<LI>--!! Warning</LI>',
'<LI>--## Fatal</LI>',
'<LI>--^^ Note</LI>',
'<LI>--@@ Show me - the preceding text on this line.</LI>',
'</UL>',
''))
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38380022896556239)
,p_name=>'P21_PACKAGE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Module Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_restricted_characters=>'NO_SPECIAL_CHAR_NL'
,p_help_text=>'Package Name or Report Name'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38959622107040621)
,p_name=>'P21_SCHEMA'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Schema'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48968558788084232)
,p_name=>'P21_NOTE_PARAMS'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Note Parameters'
,p_source=>'Y'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Debug the value of an incoming parameter.'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48968563646084233)
,p_name=>'P21_NOTE_VARS'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Note Variables'
,p_source=>'Y'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Debug the value of a variable assignment.'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48968671960084234)
,p_name=>'P21_NOTE_EX_HANDLERS'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Note Exception Handlers'
,p_source=>'Y'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Debug the triggering of an Explicit Exception Handler'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48968856936084235)
,p_name=>'P21_UNHANDLED_ERRORS'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(38242834867087334)
,p_prompt=>'Unhandled Errors'
,p_source=>'1'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Ignore;0,Note;1,Warning;3,Fatal;5'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'Choose the importance of Unhandled Errors.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(39190804205298358)
,p_validation_name=>'P21_RAW_INPUT'
,p_validation_sequence=>10
,p_validation=>'P21_RAW_INPUT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'#LABEL# must be supplied for conversion.'
,p_always_execute=>'N'
,p_validation_condition_type=>'NEVER'
,p_associated_item=>wwv_flow_api.id(38245320135098986)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38245608032137944)
,p_name=>'beforeSubmitUploadRawInput'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38626216013502286)
,p_name=>'onLoadPopRawInput'
,p_event_sequence=>30
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38626534651502288)
,p_event_id=>wwv_flow_api.id(38626216013502286)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_RAW_INPUT'
,p_attribute_01=>'RENDER'
,p_attribute_02=>'COLLECTION'
,p_attribute_03=>'RAW_INPUT'
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(35795362286215744)
,p_name=>'Submit with Processing'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(35733903882413904)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38245910257137944)
,p_event_id=>wwv_flow_api.id(35795362286215744)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_RAW_INPUT'
,p_attribute_01=>'SUBMIT'
,p_attribute_05=>'RAW_INPUT'
,p_attribute_06=>'N'
,p_attribute_07=>'Y'
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(35795833096215744)
,p_event_id=>wwv_flow_api.id(35795362286215744)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'NEXT'
,p_attribute_02=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38244205520087336)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PerformAOP'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_clob clob:= empty_clob();',
'  l_woven boolean;',
'begin',
'',
'  dbms_lob.createtemporary( l_clob, false, dbms_lob.SESSION );',
'',
'  SELECT clob001 INTO l_clob',
'  FROM APEX_collections',
'  WHERE collection_name = ''RAW_INPUT'';',
' ',
'  if apex_collection.collection_exists(p_collection_name=>''AOP_OUTPUT'') then',
'    apex_collection.delete_collection(p_collection_name=>''AOP_OUTPUT'');',
'  end if;',
'  apex_collection.create_or_truncate_collection(p_collection_name=>''AOP_OUTPUT'');',
' ',
'  l_woven := aop_processor.weave( io_code         => l_clob',
'                                , i_package_name => :P21_PACKAGE_NAME',
'                                , i_for_html     => TRUE',
'                                , i_end_user     => :P21_SCHEMA',
'                                , i_note_params             =>    :P21_NOTE_PARAMS = ''Y''',
'                                , i_note_vars               =>    :P21_NOTE_VARS   = ''Y''',
'                                , i_note_unhandled_errors   =>    :P21_UNHANDLED_ERRORS = ms_logger.G_MSG_LEVEL_COMMENT',
'                                , i_warn_unhandled_errors   =>    :P21_UNHANDLED_ERRORS = ms_logger.G_MSG_LEVEL_WARNING',
'                                , i_fatal_unhandled_errors  =>    :P21_UNHANDLED_ERRORS = ms_logger.G_MSG_LEVEL_ORACLE',
'                                , i_note_exception_handlers =>    :P21_NOTE_EX_HANDLERS  = ''Y''',
' );',
' ',
'    apex_collection.add_member(p_collection_name => ''AOP_OUTPUT'',p_clob001 => l_clob);',
'  if l_woven then',
'    apex_application.g_print_success_message := ''AOP Successful.'';',
'  else',
'    apex_application.g_print_success_message := ''AOP Failed.'';',
'  end if;',
'  ',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
end;
/
