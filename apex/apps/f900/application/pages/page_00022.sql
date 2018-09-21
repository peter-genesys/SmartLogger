prompt --application/pages/page_00022
begin
wwv_flow_api.create_page(
 p_id=>22
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Weave Highlighted'
,p_page_mode=>'NORMAL'
,p_step_title=>'Weave Highlighted'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Plugin Step 2'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20180917134650'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46705851064840825)
,p_plug_name=>'Weave Highlighted'
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
 p_id=>wwv_flow_api.id(38255130085442144)
,p_plug_name=>'Woven for Logger (Highlighted)'
,p_parent_plug_id=>wwv_flow_api.id(46705851064840825)
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
 p_id=>wwv_flow_api.id(35735422399420388)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(46705851064840825)
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
 p_id=>wwv_flow_api.id(35736201965420388)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(46705851064840825)
,p_button_name=>'NEXT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-chevron-right'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38255723402442147)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(46705851064840825)
,p_button_name=>'FINISH'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Finish'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(35735791599420388)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(46705851064840825)
,p_button_name=>'PREVIOUS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605787489315951)
,p_button_image_alt=>'Previous'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_button_execute_validations=>'N'
,p_icon_css_classes=>'fa-chevron-left'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(38257020414442151)
,p_branch_name=>'Go To Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(38255723402442147)
,p_branch_sequence=>1
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(39004108723774563)
,p_branch_name=>'GoStep3'
,p_branch_action=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(35736201965420388)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(38256811895442150)
,p_branch_name=>'Go To Page 21'
,p_branch_action=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_VALIDATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(35735791599420388)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38257225720448541)
,p_name=>'P22_AOP_OUTPUT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(38255130085442144)
,p_prompt=>'AOP Output'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>150
,p_cMaxlength=>128000
,p_cHeight=>60
,p_field_template=>wwv_flow_api.id(35605504533315950)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The code should now be woven with sm_logger calls and exception blocks.',
'<BR><BR>',
'Cut then Paste this code back into your Forms or Reports for testing.'))
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38257329576449673)
,p_name=>'onLoadPopAopOutput'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38257624453449674)
,p_event_id=>wwv_flow_api.id(38257329576449673)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P22_AOP_OUTPUT'
,p_attribute_01=>'RENDER'
,p_attribute_02=>'COLLECTION'
,p_attribute_03=>'AOP_OUTPUT'
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38259308891500462)
,p_name=>'beforeSubmitUploadToNowhere'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
,p_da_event_comment=>'This extra upload is here to stop a server error that occurs when the page implicitly submits and the value is otherwise too big.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38259612944500462)
,p_event_id=>wwv_flow_api.id(38259308891500462)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX_CLOB_LOAD'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P22_AOP_OUTPUT'
,p_attribute_01=>'SUBMIT'
,p_attribute_05=>'NOWHERE'
,p_attribute_06=>'Y'
,p_attribute_07=>'Y'
,p_attribute_08=>'Y'
,p_stop_execution_on_error=>'Y'
,p_da_action_comment=>'NOWHERE is just a random collection name'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(35680233119574935)
,p_name=>'Submit with Processing'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(35736201965420388)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(35680335157574936)
,p_event_id=>wwv_flow_api.id(35680233119574935)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'NEXT'
,p_attribute_02=>'Y'
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(39003705555764530)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PerformAOPClean'
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
'  if apex_collection.collection_exists(p_collection_name=>''AOP_OUTPUT_CLEAN'') then',
'    apex_collection.delete_collection(p_collection_name=>''AOP_OUTPUT_CLEAN'');',
'  end if;',
'  apex_collection.create_or_truncate_collection(p_collection_name=>''AOP_OUTPUT_CLEAN'');',
'',
'                                ',
'  l_woven := sm_weaver.weave( io_code         => l_clob',
'                                , i_package_name => :P21_PACKAGE_NAME',
'                                , i_for_html     => FALSE',
'                                , i_end_user     => :P21_SCHEMA',
'                                , i_note_params             =>    :P21_NOTE_PARAMS = ''Y''',
'                                , i_note_vars               =>    :P21_NOTE_VARS   = ''Y''',
'                                , i_note_unhandled_errors   =>    :P21_UNHANDLED_ERRORS = sm_logger.G_MSG_LEVEL_COMMENT',
'                                , i_warn_unhandled_errors   =>    :P21_UNHANDLED_ERRORS = sm_logger.G_MSG_LEVEL_WARNING',
'                                , i_fatal_unhandled_errors  =>    :P21_UNHANDLED_ERRORS = sm_logger.G_MSG_LEVEL_ORACLE',
'                                , i_note_exception_handlers =>    :P21_NOTE_EX_HANDLERS  = ''Y''',
' );           ',
' ',
'    apex_collection.add_member(p_collection_name => ''AOP_OUTPUT_CLEAN'',p_clob001 => l_clob);',
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
