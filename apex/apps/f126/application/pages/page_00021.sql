prompt --application/pages/page_00021
begin
wwv_flow_api.create_page(
 p_id=>21
,p_user_interface_id=>wwv_flow_api.id(13227173141283158)
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
,p_last_upd_yyyymmddhh24miss=>'20170506133412'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21946388428861308)
,p_plug_name=>'Original'
,p_region_template_options=>'#DEFAULT#:t-Wizard--hideStepsXSmall'
,p_plug_template=>wwv_flow_api.id(10816447800342903)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(10966115315420427)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(10850183298342925)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13488873524114310)
,p_plug_name=>'Original PL/SQL'
,p_parent_plug_id=>wwv_flow_api.id(21946388428861308)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10806409948342898)
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
 p_id=>wwv_flow_api.id(10979501657440879)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(21946388428861308)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10979942539440880)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(21946388428861308)
,p_button_name=>'NEXT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10852003520342929)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-chevron-right'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(13491172145114315)
,p_branch_name=>'Go To Page 22'
,p_branch_action=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:RP,22::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(10979942539440880)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13491358792125962)
,p_name=>'P21_RAW_INPUT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(13488873524114310)
,p_prompt=>'Raw Input'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>4000
,p_cHeight=>40
,p_field_template=>wwv_flow_api.id(10851543190342926)
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
 p_id=>wwv_flow_api.id(13626061553583215)
,p_name=>'P21_PACKAGE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13488873524114310)
,p_prompt=>'Module Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_api.id(10851543190342926)
,p_item_template_options=>'#DEFAULT#'
,p_restricted_characters=>'NO_SPECIAL_CHAR_NL'
,p_help_text=>'Package Name or Report Name'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14205660764067597)
,p_name=>'P21_SCHEMA'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_api.id(13488873524114310)
,p_prompt=>'Schema'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_api.id(10851543190342926)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(14436842862325334)
,p_validation_name=>'P21_RAW_INPUT'
,p_validation_sequence=>10
,p_validation=>'P21_RAW_INPUT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'#LABEL# must be supplied for conversion.'
,p_always_execute=>'N'
,p_validation_condition_type=>'NEVER'
,p_associated_item=>wwv_flow_api.id(13491358792125962)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13491646689164920)
,p_name=>'beforeSubmitUploadRawInput'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13872254670529262)
,p_name=>'onLoadPopRawInput'
,p_event_sequence=>30
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13872573308529264)
,p_event_id=>wwv_flow_api.id(13872254670529262)
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
 p_id=>wwv_flow_api.id(11041400943242720)
,p_name=>'Submit with Processing'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(10979942539440880)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13491948914164920)
,p_event_id=>wwv_flow_api.id(11041400943242720)
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
 p_id=>wwv_flow_api.id(11041871753242720)
,p_event_id=>wwv_flow_api.id(11041400943242720)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'NEXT'
,p_attribute_02=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13490244177114312)
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
'  l_woven := aop_processor.weave( p_code         => l_clob',
'                                , p_package_name => :P21_PACKAGE_NAME',
'                                , p_for_html     => TRUE',
'                                , p_end_user     => :P21_SCHEMA );',
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
