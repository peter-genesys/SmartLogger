prompt --application/pages/page_00005
begin
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Apex Sessions'
,p_alias=>'APEX_SESSIONS'
,p_step_title=>'Apex Sessions'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20190319112759'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26684462065153888)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35569579936315926)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(53231447489577620)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(35606742937315953)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(27237571483775031)
,p_plug_name=>'Apex Sessions &SM_APP_USER.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'  s.APP_SESSION		 appsession		 ',
' ,s.APP_USER		 appuser	 		   ',
' ,s.APP_USER_FULLNAME			 ',
' ,s.APP_USER_EMAIL 			 ',
' ,s.APP_ID 					   ',
' ,s.INTERNAL_ERROR 		',
'  ,INTERNAL_ERROR_COUNT   ',
' ,s.CREATED_DATE				 ',
' ,s.UPDATED_DATE				 ',
' ,s.WARNING_COUNT				 ',
' ,s.EXCEPTION_COUNT			 ',
' ,s.MESSAGE_COUNT	',
' ,s.PARENT_APP_SESSION',
' ,c.ID',
' ,c.title',
' ,c.icon',
' ,''Session Calls - ''||s.APP_USER||'' ''||s.APP_SESSION tree_heading	',
'from sm_apex_context_v  c',
'    ,sm_session_v3      s',
'where  c.parent_id is null',
'and  ''S''||s.app_session = c.id',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':SM_APP_USER IS NOT NULL OR APEX_UTIL.GET_PREFERENCE(''FLAT_VIEW'') = ''Y'''
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
 p_id=>wwv_flow_api.id(27238031169775036)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_rows_per_page=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP:P40_MESSAGES_HEADING,P40_ID,SM_APP_SESSION,SM_APP_USER,P40_TREE_HEADING:#TITLE#,#ID#,#APPSESSION#,,#TREE_HEADING#'
,p_detail_link_text=>'<span class="#ICON#" title="#TITLE#"></span> '
,p_owner=>'PETER'
,p_internal_uid=>27238031169775036
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28077650634555224)
,p_db_column_name=>'APPUSER'
,p_display_order=>10
,p_column_identifier=>'P'
,p_column_label=>'App User'
,p_column_type=>'STRING'
,p_display_condition_type=>'USER_PREF_IN_COND_EQ_COND2'
,p_display_condition=>'FLAT_VIEW'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27239145464775047)
,p_db_column_name=>'APPSESSION'
,p_display_order=>20
,p_column_identifier=>'K'
,p_column_label=>'appsession'
,p_column_type=>'STRING'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28077599264555223)
,p_db_column_name=>'TITLE'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'Apex Session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238158225775037)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>40
,p_column_identifier=>'A'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238279224775038)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>50
,p_column_identifier=>'B'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238338510775039)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>60
,p_column_identifier=>'C'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238441262775040)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>70
,p_column_identifier=>'D'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238510636775041)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>80
,p_column_identifier=>'E'
,p_column_label=>'All Messages'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238775099775043)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'App user fullname'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238883245775044)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'App user email'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27238900247775045)
,p_db_column_name=>'APP_ID'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'App ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27239049050775046)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>120
,p_column_identifier=>'J'
,p_column_label=>'Warnings'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27239321879775049)
,p_db_column_name=>'PARENT_APP_SESSION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Parent App Session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27239498528775050)
,p_db_column_name=>'ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28079998828555247)
,p_db_column_name=>'TREE_HEADING'
,p_display_order=>150
,p_column_identifier=>'Q'
,p_column_label=>'Tree heading'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28080058886555248)
,p_db_column_name=>'ICON'
,p_display_order=>160
,p_column_identifier=>'R'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1937623726495603)
,p_db_column_name=>'INTERNAL_ERROR_COUNT'
,p_display_order=>170
,p_column_identifier=>'S'
,p_column_label=>'Fail Count'
,p_column_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:RP,7:P7_APP_SESSION:#APPSESSION#'
,p_column_linktext=>'#INTERNAL_ERROR_COUNT#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1946436431535481)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Internal Failure'
,p_report_seq=>10
,p_report_alias=>'19465'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'TITLE:INTERNAL_ERROR:INTERNAL_ERROR_COUNT:CREATED_DATE:'
,p_sort_column_1=>'CREATED_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(55382593786374223)
,p_report_id=>wwv_flow_api.id(1946436431535481)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'INTERNAL_ERROR'
,p_operator=>'='
,p_expr=>'Y'
,p_condition_sql=>'"INTERNAL_ERROR" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Y''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(28069455129505930)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'280695'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'TITLE:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:CREATED_DATE:'
,p_sort_column_1=>'CREATED_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(55383186219375031)
,p_report_id=>wwv_flow_api.id(28069455129505930)
,p_name=>'Failure'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'INTERNAL_ERROR'
,p_operator=>'='
,p_expr=>'Y'
,p_condition_sql=>' (case when ("INTERNAL_ERROR" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Y''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF7755'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50970920155756445)
,p_plug_name=>'Apex User Activity'
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
' ,max(INTERNAL_ERROR)            INTERNAL_ERROR',
' ,sum(INTERNAL_ERROR_COUNT)      INTERNAL_ERROR_COUNT',
'from sm_session_v3 s ',
'group by ',
'  APP_USER			 		   ',
' ,APP_USER_FULLNAME			 ',
' ,APP_USER_EMAIL 	'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'USER_PREF_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'FLAT_VIEW'
,p_plug_display_when_cond2=>'Y'
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
 p_id=>wwv_flow_api.id(50970922919756446)
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
,p_internal_uid=>50970922919756446
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27237422161775030)
,p_db_column_name=>'APPUSER'
,p_display_order=>10
,p_column_identifier=>'AB'
,p_column_label=>'App User'
,p_column_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:RP:SM_APP_USER,SM_APP_SESSION:#APPUSER#,'
,p_column_linktext=>'#APPUSER#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26757221944645245)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>20
,p_column_identifier=>'N'
,p_column_label=>'App User Fullname'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26757698781645245)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'App User Email'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2044714912971433)
,p_db_column_name=>'SESSION_COUNT'
,p_display_order=>40
,p_column_identifier=>'AA'
,p_column_label=>'Apex Sessions'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP:P40_TREE_HEADING,P40_MESSAGES_HEADING,P40_ID,SM_APP_USER,SM_APP_SESSION:Apex Sessions #APPUSER#,Choose a Session,,#APPUSER#,'
,p_column_linktext=>'#SESSION_COUNT#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26756483890645244)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>50
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26758429341645246)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>60
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26756086688645244)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>70
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2044633681971432)
,p_db_column_name=>'LATEST_SESSION'
,p_display_order=>80
,p_column_identifier=>'Z'
,p_column_label=>'Most Recent Activity'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_column_comment=>'Latest logger session CREATED_DATE, not latest apex session CREATED_DATE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1937408565495601)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>90
,p_column_identifier=>'AC'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1937574591495602)
,p_db_column_name=>'INTERNAL_ERROR_COUNT'
,p_display_order=>100
,p_column_identifier=>'AD'
,p_column_label=>'Fail Count'
,p_column_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:RP,7:P7_APP_USER:#APPUSER#'
,p_column_linktext=>'#INTERNAL_ERROR_COUNT#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1943914801505762)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Internal Failure'
,p_report_seq=>10
,p_report_alias=>'19440'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'APPUSER:SESSION_COUNT:INTERNAL_ERROR:INTERNAL_ERROR_COUNT:LATEST_SESSION:'
,p_sort_column_1=>'LATEST_SESSION'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'CREATED_DATE'
,p_sort_direction_2=>'DESC'
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
 p_id=>wwv_flow_api.id(55379698423344163)
,p_report_id=>wwv_flow_api.id(1943914801505762)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'INTERNAL_ERROR'
,p_operator=>'='
,p_expr=>'Y'
,p_condition_sql=>'"INTERNAL_ERROR" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Y''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(55380058669344164)
,p_report_id=>wwv_flow_api.id(1943914801505762)
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
 p_id=>wwv_flow_api.id(52114923921944293)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'267596'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'APPUSER:SESSION_COUNT:MESSAGE_COUNT:EXCEPTION_COUNT:WARNING_COUNT:LATEST_SESSION:'
,p_sort_column_1=>'LATEST_SESSION'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'CREATED_DATE'
,p_sort_direction_2=>'DESC'
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
 p_id=>wwv_flow_api.id(55378989880333651)
,p_report_id=>wwv_flow_api.id(52114923921944293)
,p_name=>'Failure'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'INTERNAL_ERROR'
,p_operator=>'='
,p_expr=>'Y'
,p_condition_sql=>' (case when ("INTERNAL_ERROR" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Y''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF7755'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(55378577119333651)
,p_report_id=>wwv_flow_api.id(52114923921944293)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MESSAGE_COUNT'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"MESSAGE_COUNT" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
end;
/
