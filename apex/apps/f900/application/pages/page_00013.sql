prompt --application/pages/page_00013
begin
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'User Activity (with fancy tree plugin)'
,p_step_title=>'User Activity (with fancy tree plugin)'
,p_step_sub_title=>'User Activity (with fancy tree plugin)'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180929182542'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30061631027461838)
,p_plug_name=>'User Sessions : &SM_APP_USER.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'SM_APP_USER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30060886470461830)
,p_plug_name=>'User Sessions'
,p_parent_plug_id=>wwv_flow_api.id(30061631027461838)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select id                                                      value',
'      ,DECODE(APEX_UTIL.GET_PREFERENCE(''LONG_NAMES''),''N'',short_name,long_name)  name',
'      ,''''                                                      tooltip',
'      ,case ',
'         when node_type = ''SESSION'' then ''fa fa-user-circle''',
'         when node_type = ''CLONE''   then ''fa fa-user-circle-o''',
'         when node_type = ''APP''     then ''fa fa-book''',
'         when node_type = ''PAGE''    then ''fa fa-file-o''',
'         else                            ''fa fa-folder-o''',
'       end      as icon',
'      ,apex_page.get_url(p_page  => 40',
'                        ,p_items => ''P40_APP_USER,SM_APP_SESSION,SM_APP_USER''',
'                        ,p_values => app_user||'',''||app_session||'','') as link',
'      ,level as lvl',
'      ,parent_id as parent_id ',
'from sm_context_tree_v',
'start with parent_id is null',
'connect by prior id = parent_id',
'order siblings by session_date, id'))
,p_plug_source_type=>'PLUGIN_COM.MTAG.APEX.FANCYTREEV1.1'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_05=>'P13_SELECTED_NODE'
,p_attribute_06=>'P13_SELECTED_NODE_PARENT'
,p_attribute_07=>'P13_SELECTED_NODE_OLD_PARENT'
,p_attribute_16=>'N'
,p_attribute_19=>'Y'
,p_attribute_21=>'N'
,p_attribute_22=>'Y'
,p_attribute_23=>'N'
,p_attribute_24=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78987646683246848)
,p_plug_name=>'User Activity'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'  APP_USER           appuser	 		   ',
' ,APP_USER_FULLNAME			 ',
' ,APP_USER_EMAIL 			 		 ',
' ,max(CREATED_DATE)  latest_session	',
' ,count(APP_SESSION) session_count',
' ,sum(WARNING_COUNT) WARNING_COUNT				 ',
' ,sum(EXCEPTION_COUNT) EXCEPTION_COUNT			 ',
' ,sum(MESSAGE_COUNT) MESSAGE_COUNT	',
'from sm_session_v3 s ',
'group by ',
'  APP_USER			 		   ',
' ,APP_USER_FULLNAME			 ',
' ,APP_USER_EMAIL 	'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P13_APP_SESSION'
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
 p_id=>wwv_flow_api.id(78987649447246849)
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
,p_internal_uid=>78987649447246849
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28020417537490465)
,p_db_column_name=>'APPUSER'
,p_display_order=>10
,p_column_identifier=>'AB'
,p_column_label=>'App User'
,p_column_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:RP:SM_APP_USER,SM_APP_SESSION:#APPUSER#,'
,p_column_linktext=>'#APPUSER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28019284413490464)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>20
,p_column_identifier=>'N'
,p_column_label=>'App User Fullname'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28019612272490464)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'App User Email'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28018816733490463)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>40
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP,40:SM_APP_USER,P40_APP_USER,SM_APP_SESSION:#APPUSER#,#APPUSER#,'
,p_column_linktext=>'#MESSAGE_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28020010854490465)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>50
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28018481659490463)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>60
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28017796990490459)
,p_db_column_name=>'LATEST_SESSION'
,p_display_order=>70
,p_column_identifier=>'Z'
,p_column_label=>'Most Recent Activity'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
,p_column_comment=>'Latest logger session CREATED_DATE, not latest apex session CREATED_DATE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28018036389490463)
,p_db_column_name=>'SESSION_COUNT'
,p_display_order=>80
,p_column_identifier=>'AA'
,p_column_label=>'Apex Sessions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(80131650449434696)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'280208'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'APPUSER:SESSION_COUNT:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:LATEST_SESSION:'
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
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28021215648490470)
,p_report_id=>wwv_flow_api.id(80131650449434696)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MESSAGE_COUNT'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"MESSAGE_COUNT" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28021655376490472)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(78987646683246848)
,p_button_name=>'PURGE_OLD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge Old Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28022079941490474)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(78987646683246848)
,p_button_name=>'PURGE_ALL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge All Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28022483579490475)
,p_name=>'P13_APP_SESSION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(78987646683246848)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28022869725490478)
,p_name=>'P13_LOG_CONTEXT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(78987646683246848)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28023893881490480)
,p_name=>'P13_SELECTED_NODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(30060886470461830)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28024294516490480)
,p_name=>'P13_SELECTED_NODE_PARENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(30060886470461830)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28024620327490481)
,p_name=>'P13_SELECTED_NODE_OLD_PARENT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(30060886470461830)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28025361830490500)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions;'
,p_process_when_button_id=>wwv_flow_api.id(28021655376490472)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28025706957490501)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeAllSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 0);'
,p_process_when_button_id=>wwv_flow_api.id(28022079941490474)
,p_process_success_message=>'Purged all messages'
);
end;
/
