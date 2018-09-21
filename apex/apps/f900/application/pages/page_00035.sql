prompt --application/pages/page_00035
begin
wwv_flow_api.create_page(
 p_id=>35
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Logger Sessions'
,p_page_mode=>'NORMAL'
,p_step_title=>'Logger Sessions'
,p_step_sub_title=>'Logger Sessions'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20180921010006'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51129564379178574)
,p_plug_name=>'Logger Sessions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>38
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.* ',
'      ,app_user||'' ''||app_session||'' ''||app_title||'' ''||app_page_id||'' ''||origin log_context',
'from sm_session_v2 s ',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>8.5
,p_prn_height=>11
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#9bafde'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'normal'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#efefef'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(51129651416178575)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_rows_per_page=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'PETER'
,p_internal_uid=>51129651416178575
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25801024148917948)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Session ID'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP,RIR:P40_SESSION_ID:#SESSION_ID#'
,p_column_linktext=>'#SESSION_ID#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25801499686917948)
,p_db_column_name=>'ORIGIN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Proc / Func'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25801848889917949)
,p_db_column_name=>'USERNAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Username'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25802253016917950)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25803056579917950)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Failure Message'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'CLOB'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25802609323917950)
,p_db_column_name=>'NOTIFIED_FLAG'
,p_display_order=>70
,p_column_identifier=>'E'
,p_column_label=>'Notified Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25803407698917950)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Created date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25803847505917950)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Updated date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25804217157917951)
,p_db_column_name=>'KEEP_YN'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Keep Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25804675867917951)
,p_db_column_name=>'TOP_CALL_ID'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Top call id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25805405973917952)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_link=>'f?p=&APP_ID.:45:&SESSION.::&DEBUG.:RP,RIR:P45_SESSION_ID,P45_LOG_CONTEXT,P45_CALL_ID:#SESSION_ID#,#LOG_CONTEXT#,#TOP_CALL_ID#'
,p_column_linktext=>'#MESSAGE_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25809410155917956)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>140
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_link=>'f?p=&APP_ID.:45:&SESSION.:IR_REPORT_WARN_ERROR:&DEBUG.:RP:P45_SESSION_ID,P45_LOG_CONTEXT,P45_CALL_ID:#SESSION_ID#,#LOG_CONTEXT#,#TOP_CALL_ID#'
,p_column_linktext=>'#WARNING_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25805053129917952)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_link=>'f?p=&APP_ID.:45:&SESSION.:IR_REPORT_ERROR:&DEBUG.:RP:P45_SESSION_ID,P45_LOG_CONTEXT,P45_CALL_ID:#SESSION_ID#,#LOG_CONTEXT#,#TOP_CALL_ID#'
,p_column_linktext=>'#EXCEPTION_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25805865054917952)
,p_db_column_name=>'APP_USER'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'App User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25806283674917953)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'App User Fullname'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25806641071917953)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>180
,p_column_identifier=>'O'
,p_column_label=>'App User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25807060881917954)
,p_db_column_name=>'APP_SESSION'
,p_display_order=>190
,p_column_identifier=>'P'
,p_column_label=>'App Session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25807419178917954)
,p_db_column_name=>'APP_ID'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'App ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25807801442917954)
,p_db_column_name=>'APP_ALIAS'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'App Alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25808250100917955)
,p_db_column_name=>'APP_TITLE'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'App Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25808604798917955)
,p_db_column_name=>'APP_PAGE_ID'
,p_display_order=>230
,p_column_identifier=>'T'
,p_column_label=>'App Page ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25809059540917956)
,p_db_column_name=>'APP_PAGE_ALIAS'
,p_display_order=>240
,p_column_identifier=>'U'
,p_column_label=>'App Page Alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25809832213917957)
,p_db_column_name=>'LOG_CONTEXT'
,p_display_order=>250
,p_column_identifier=>'W'
,p_column_label=>'Log Context'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(25833682799956206)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Apex Logger Sessions'
,p_report_seq=>10
,p_report_alias=>'258337'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'APP_USER:APP_SESSION:APP_TITLE:APP_ID:APP_PAGE_ID:ORIGIN:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:CREATED_DATE:'
,p_sort_column_1=>'CREATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54116846038224923)
,p_report_id=>wwv_flow_api.id(25833682799956206)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APP_USER'
,p_operator=>'is not null'
,p_condition_sql=>'"APP_USER" is not null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54117242342224923)
,p_report_id=>wwv_flow_api.id(25833682799956206)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MESSAGE_COUNT'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"MESSAGE_COUNT" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51207415759423443)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'258102'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'USERNAME:ORIGIN:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:CREATED_DATE:'
,p_sort_column_1=>'CREATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54117805346225692)
,p_report_id=>wwv_flow_api.id(51207415759423443)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APP_USER'
,p_operator=>'is null'
,p_condition_sql=>'"APP_USER" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54118214067225693)
,p_report_id=>wwv_flow_api.id(51207415759423443)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MESSAGE_COUNT'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"MESSAGE_COUNT" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51391969724058777)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'More Detail'
,p_report_seq=>10
,p_report_alias=>'258106'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'APP_TITLE:APP_ID:APP_ALIAS:APP_PAGE_ID:APP_PAGE_ALIAS:ORIGIN:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:INTERNAL_ERROR:ERROR_MESSAGE:NOTIFIED_FLAG:KEEP_YN:CREATED_DATE::LOG_CONTEXT'
,p_sort_column_1=>'CREATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54115620795224224)
,p_report_id=>wwv_flow_api.id(51391969724058777)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MESSAGE_COUNT'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"MESSAGE_COUNT" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76379921232239828)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35569579936315926)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(53231447489577620)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(35606742937315953)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(119493652839111345)
,p_plug_name=>'Button Container'
,p_region_name=>'BUTTONS'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noBorder:t-Form--noPadding:margin-top-none:margin-bottom-none:margin-right-md'
,p_plug_template=>wwv_flow_api.id(35540283963315912)
,p_plug_display_sequence=>28
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'BELOW'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26103774515373236)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(51129564379178574)
,p_button_name=>'PURGE_OLD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge Old Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26104054304374699)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(51129564379178574)
,p_button_name=>'PURGE_ALL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge All Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25339347496260742)
,p_name=>'Reset Primary Report Name'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(51129564379178574)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25339456528260743)
,p_event_id=>wwv_flow_api.id(25339347496260742)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var my_primary_report_name = ''1. Standalone Logger Sessions'';',
' ',
'$(''#''+this.triggeringElement.id+'' .a-IRR-selectList'').find(''option'').each(function(index,elem){',
'  $(elem).text(function(i,text){',
'    return text.replace(''1. Primary Report'',my_primary_report_name);',
'  }); // end of text change',
'}); // end of option walk'))
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26104249044376255)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 1);'
,p_process_when_button_id=>wwv_flow_api.id(26103774515373236)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26104547677378207)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeAllSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 0);'
,p_process_when_button_id=>wwv_flow_api.id(26104054304374699)
,p_process_success_message=>'Purged all messages'
);
end;
/
