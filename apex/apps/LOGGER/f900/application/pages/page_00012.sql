prompt --application/pages/page_00012
begin
wwv_flow_api.create_page(
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Internal Failures - Logger Sessions'
,p_page_mode=>'MODAL'
,p_step_title=>'Internal Failures - Logger Sessions'
,p_step_sub_title=>'Internal Failures - Logger Sessions'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'1500'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20190319113407'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110756476679921892)
,p_plug_name=>'&P12_USERNAME. &P12_SESSION_ID.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * from sm_session_v2',
'where username = NVL(:P12_USERNAME, username)',
'and   session_id = NVL(:P12_SESSION_ID, session_id)',
'and internal_error = ''Y''',
'and app_session is null'))
,p_plug_source_type=>'NATIVE_IR'
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
 p_id=>wwv_flow_api.id(97855056122359710)
,p_max_row_count=>'1000000'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'BURGPETE'
,p_internal_uid=>97855056122359710
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55415690807731004)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Session Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55416050111731005)
,p_db_column_name=>'ORIGIN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Origin'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55416448190731005)
,p_db_column_name=>'USERNAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Username'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55416879048731006)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Internal Error'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55417274863731006)
,p_db_column_name=>'NOTIFIED_FLAG'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notified Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55417655336731006)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Error Message'
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
 p_id=>wwv_flow_api.id(55418065067731007)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created Date'
,p_column_html_expression=>'<span class="datetime-nowrap">#CREATED_DATE#</span>'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55418431718731007)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_html_expression=>'<span class="datetime-nowrap">#UPDATED_DATE#</span>'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55418841244731007)
,p_db_column_name=>'KEEP_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Keep Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55419238653731007)
,p_db_column_name=>'APP_USER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'App User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55419666997731008)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'App User Fullname'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55420023839731008)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'App User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55420485590731009)
,p_db_column_name=>'APP_SESSION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'App Session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55420840036731009)
,p_db_column_name=>'PARENT_APP_SESSION'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Parent App Session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55421212314731009)
,p_db_column_name=>'APP_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'App Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55421694308731010)
,p_db_column_name=>'APP_ALIAS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'App Alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55421921614731010)
,p_db_column_name=>'APP_TITLE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'App Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55422307264731010)
,p_db_column_name=>'APP_PAGE_ID'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'App Page Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55422744488731010)
,p_db_column_name=>'APP_PAGE_ALIAS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'App Page Alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55423112834731011)
,p_db_column_name=>'APEX_CONTEXT_ID'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Apex Context Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55423537817731011)
,p_db_column_name=>'TOP_CALL_ID'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Top Call Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55423902462731011)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Warning Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55424305587731012)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Exception Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55424722245731012)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Message Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110788893129962389)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'554251'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SESSION_ID:ERROR_MESSAGE:NOTIFIED_FLAG:CREATED_DATE:'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55426334202731021)
,p_name=>'P12_USERNAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(110756476679921892)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55426728882731022)
,p_name=>'P12_SESSION_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(110756476679921892)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
end;
/
