prompt --application/pages/page_00030
begin
wwv_flow_api.create_page(
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Apex Sessions'
,p_page_mode=>'NORMAL'
,p_step_title=>'Apex Sessions'
,p_step_sub_title=>'Session Browser'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20180921012522'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24216799638111230)
,p_plug_name=>'Apex Sessions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>28
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'  APP_SESSION		 appsession		 ',
' ,APP_USER			 		   ',
' ,APP_USER_FULLNAME			 ',
' ,APP_USER_EMAIL 			 ',
' ,APP_ID 					   ',
' ,INTERNAL_ERROR 			 ',
' ,CREATED_DATE				 ',
' ,UPDATED_DATE				 ',
' ,WARNING_COUNT				 ',
' ,EXCEPTION_COUNT			 ',
' ,MESSAGE_COUNT	',
' ,APP_USER||'' ''||APP_SESSION LOG_CONTEXT			 ',
'from sm_session_v3 s '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P30_APP_SESSION'
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
 p_id=>wwv_flow_api.id(24216802402111231)
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
,p_internal_uid=>24216802402111231
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25338296842260731)
,p_db_column_name=>'APPSESSION'
,p_display_order=>10
,p_column_identifier=>'W'
,p_column_label=>'App Session'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:RP:P30_APP_SESSION,P30_LOG_CONTEXT,SM_APP_SESSION:#APPSESSION#,#LOG_CONTEXT#,#APPSESSION#'
,p_column_linktext=>'#APPSESSION#'
,p_column_type=>'STRING'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218103838111244)
,p_db_column_name=>'APP_USER'
,p_display_order=>20
,p_column_identifier=>'M'
,p_column_label=>'App User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218248839111245)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>30
,p_column_identifier=>'N'
,p_column_label=>'App user fullname'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218352647111246)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>40
,p_column_identifier=>'O'
,p_column_label=>'App user email'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218556516111248)
,p_db_column_name=>'APP_ID'
,p_display_order=>50
,p_column_identifier=>'Q'
,p_column_label=>'App ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218079727111243)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>60
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP,40:SM_APP_SESSION,P40_ID:#APPSESSION#,#APPSESSION#'
,p_column_linktext=>'#MESSAGE_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25335595877260704)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>70
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217950383111242)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>80
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217291606111235)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>90
,p_column_identifier=>'D'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217523127111238)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>100
,p_column_identifier=>'G'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217686108111239)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25338942362260738)
,p_db_column_name=>'LOG_CONTEXT'
,p_display_order=>120
,p_column_identifier=>'X'
,p_column_label=>'Log context'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(25360803404299078)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'253609'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'APPSESSION:APP_USER:APP_ID:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:INTERNAL_ERROR:CREATED_DATE::LOG_CONTEXT'
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
 p_id=>wwv_flow_api.id(54114983480220424)
,p_report_id=>wwv_flow_api.id(25360803404299078)
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
 p_id=>wwv_flow_api.id(25335787867260706)
,p_plug_name=>'&P30_LOG_CONTEXT. - Logger Sessions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>38
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.* ',
'      ,app_user||'' ''||app_session||'' ''||app_title||'' ''||app_page_id||'' ''||origin log_context',
'      ,app_id||''+''||app_page_id||''+''||top_call_id  id',
'from sm_session_v2 s ',
'where app_session = :P30_APP_SESSION'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P30_APP_SESSION'
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
 p_id=>wwv_flow_api.id(25335874904260707)
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
,p_internal_uid=>25335874904260707
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25335914892260708)
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
 p_id=>wwv_flow_api.id(25336017349260709)
,p_db_column_name=>'ORIGIN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Proc / Func'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336198350260710)
,p_db_column_name=>'USERNAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Username'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336240104260711)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336461199260713)
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
 p_id=>wwv_flow_api.id(25336326630260712)
,p_db_column_name=>'NOTIFIED_FLAG'
,p_display_order=>70
,p_column_identifier=>'E'
,p_column_label=>'Notified Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336598935260714)
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
 p_id=>wwv_flow_api.id(25336617187260715)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Updated date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336716165260716)
,p_db_column_name=>'KEEP_YN'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Keep Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336862866260717)
,p_db_column_name=>'TOP_CALL_ID'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Top call id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337001363260719)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP,RIR:P40_LOG_CONTEXT,P40_ID:#LOG_CONTEXT#,#ID#'
,p_column_linktext=>'#MESSAGE_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25338015634260729)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>140
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.:IR_REPORT_WARN_ERROR:&DEBUG.:RP:P40_LOG_CONTEXT,P40_ID:#LOG_CONTEXT#,#TOP_CALL_ID#'
,p_column_linktext=>'#WARNING_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25336949277260718)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.:IR_REPORT_ERROR:&DEBUG.:RP:P40_LOG_CONTEXT,P40_ID:#LOG_CONTEXT#,#TOP_CALL_ID#'
,p_column_linktext=>'#EXCEPTION_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337101114260720)
,p_db_column_name=>'APP_USER'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'App user'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337248641260721)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'App user fullname'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337369967260722)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>180
,p_column_identifier=>'O'
,p_column_label=>'App user email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337498797260723)
,p_db_column_name=>'APP_SESSION'
,p_display_order=>190
,p_column_identifier=>'P'
,p_column_label=>'App session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337571978260724)
,p_db_column_name=>'APP_ID'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'App ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337601741260725)
,p_db_column_name=>'APP_ALIAS'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'App Alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337772594260726)
,p_db_column_name=>'APP_TITLE'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'App Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337880106260727)
,p_db_column_name=>'APP_PAGE_ID'
,p_display_order=>230
,p_column_identifier=>'T'
,p_column_label=>'App Page ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25337904319260728)
,p_db_column_name=>'APP_PAGE_ALIAS'
,p_display_order=>240
,p_column_identifier=>'U'
,p_column_label=>'App Page Alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25339249138260741)
,p_db_column_name=>'LOG_CONTEXT'
,p_display_order=>250
,p_column_identifier=>'W'
,p_column_label=>'Log context'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57764108423829404)
,p_db_column_name=>'ID'
,p_display_order=>260
,p_column_identifier=>'X'
,p_column_label=>'Id'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(25413639247505575)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'254137'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'APP_TITLE:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:CREATED_DATE:'
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
 p_id=>wwv_flow_api.id(57852145145398428)
,p_report_id=>wwv_flow_api.id(25413639247505575)
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
 p_id=>wwv_flow_api.id(25598193212140909)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'More Detail'
,p_report_seq=>10
,p_report_alias=>'255982'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(54888563806420865)
,p_application_user=>'HEWETTJ'
,p_name=>'Primary with Messages'
,p_report_seq=>10
,p_report_alias=>'548886'
,p_status=>'PUBLIC'
,p_is_default=>'N'
,p_display_rows=>50
,p_report_columns=>'APP_TITLE:APP_ID:APP_PAGE_ID:ORIGIN:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:CREATED_DATE::LOG_CONTEXT'
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
 p_id=>wwv_flow_api.id(54888945888420867)
,p_report_id=>wwv_flow_api.id(54888563806420865)
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
 p_id=>wwv_flow_api.id(50586144720321960)
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
 p_id=>wwv_flow_api.id(93699876327193477)
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
 p_id=>wwv_flow_api.id(26084566721355504)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24216799638111230)
,p_button_name=>'PURGE_OLD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge Old Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53825679530327829)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(25335787867260706)
,p_button_name=>'APEX_SESSIONS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Apex sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26084851886357732)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(24216799638111230)
,p_button_name=>'PURGE_ALL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge All Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(53825923079327832)
,p_branch_name=>'Show Apex Sessions'
,p_branch_action=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:RP,30::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(53825679530327829)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25338102334260730)
,p_name=>'P30_APP_SESSION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(24216799638111230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25339098536260739)
,p_name=>'P30_LOG_CONTEXT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(24216799638111230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26085065131360431)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 1);'
,p_process_when_button_id=>wwv_flow_api.id(26084566721355504)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26085313419361625)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeAllSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 0);'
,p_process_when_button_id=>wwv_flow_api.id(26084851886357732)
,p_process_success_message=>'Purged all messages'
);
end;
/
