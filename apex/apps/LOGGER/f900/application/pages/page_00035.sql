prompt --application/pages/page_00035
begin
wwv_flow_api.create_page(
 p_id=>35
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Logger Sessions'
,p_step_title=>'Logger Sessions'
,p_step_sub_title=>'Logger Sessions'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20190318043552'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51129564379178574)
,p_plug_name=>'Logger Sessions &SM_DB_USER.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>38
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'   session_id				',
'  ,origin 				',
'  ,username				',
'  ,internal_error 		',
'  ,notified_flag			',
'  ,error_message			',
'  ,created_date			',
'  ,updated_date			',
'  ,keep_yn				',
'  ,apex_context_id		',
'  ,top_call_id			',
'  ,warning_count			',
'  ,exception_count		',
'  ,message_count			',
'  ,top_call_id     id     ',
'  ,case ',
'     when APEX_UTIL.GET_PREFERENCE(''LONG_NAMES'') = ''Y'' then',
'       origin                                           ',
'     else ',
'       origin                                                                   ',
'   end                                                                            title',
'  ,''fa fa-folder''                                                                 icon',
' ,''Session Calls - ''||s.username||'' ''||s.session_id                               tree_heading_user_session	',
' ,''Session Calls - ''||s.username                                                  tree_heading_user	',
' ,INTERNAL_ERROR      FAILED',
' ,decode(INTERNAL_ERROR,''Y'',1,0)      FAIL_COUNT',
'from sm_session_v2      s',
'where apex_context_id is null',
'and username = NVL(:SM_DB_USER,username)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'SM_DB_USER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':SM_DB_USER IS NOT NULL OR APEX_UTIL.GET_PREFERENCE(''FLAT_VIEW'') = ''Y'''
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
,p_show_detail_link=>'C'
,p_show_rows_per_page=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.:RP:P46_TREE_HEADING,P46_MESSAGES_HEADING,P46_ID,SM_DB_USER,SM_DB_SESSION:#TREE_HEADING_USER_SESSION#,#TITLE#,#ID#,,#SESSION_ID#'
,p_detail_link_text=>'<span class="#ICON#" title="#TITLE#"></span> '
,p_owner=>'PETER'
,p_internal_uid=>51129651416178575
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25801024148917948)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Session ID'
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
,p_column_link=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.:RP:P46_TREE_HEADING,P46_MESSAGES_HEADING,P46_ID,SM_DB_USER,SM_DB_SESSION:#TREE_HEADING_USER#,Choose a Session,,#USERNAME#,'
,p_column_linktext=>'#USERNAME#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_display_condition_type=>'USER_PREF_IN_COND_EQ_COND2'
,p_display_condition=>'FLAT_VIEW'
,p_display_condition2=>'Y'
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
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25805053129917952)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28339650370107101)
,p_db_column_name=>'APEX_CONTEXT_ID'
,p_display_order=>270
,p_column_identifier=>'Y'
,p_column_label=>'Apex Context Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340052348107105)
,p_db_column_name=>'TITLE'
,p_display_order=>310
,p_column_identifier=>'AC'
,p_column_label=>'Call'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340142095107106)
,p_db_column_name=>'ICON'
,p_display_order=>320
,p_column_identifier=>'AD'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340245659107107)
,p_db_column_name=>'TREE_HEADING_USER_SESSION'
,p_display_order=>330
,p_column_identifier=>'AE'
,p_column_label=>'Tree heading user session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340346719107108)
,p_db_column_name=>'TREE_HEADING_USER'
,p_display_order=>340
,p_column_identifier=>'AF'
,p_column_label=>'Tree heading user'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55281486409101037)
,p_db_column_name=>'ID'
,p_display_order=>350
,p_column_identifier=>'AG'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1937924890495606)
,p_db_column_name=>'FAILED'
,p_display_order=>360
,p_column_identifier=>'AH'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1938002001495607)
,p_db_column_name=>'FAIL_COUNT'
,p_display_order=>370
,p_column_identifier=>'AI'
,p_column_label=>'Fail Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1954275535644869)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Internal Failure'
,p_report_seq=>10
,p_report_alias=>'19543'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORIGIN:FAILED:FAIL_COUNT:CREATED_DATE:'
,p_sort_column_1=>'SESSION_ID'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51207415759423443)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'258102'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORIGIN:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT:CREATED_DATE:'
,p_sort_column_1=>'SESSION_ID'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76379921232239828)
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
 p_id=>wwv_flow_api.id(79424603443274654)
,p_plug_name=>'Database User Activity'
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
'  username 			 		 ',
' ,max(CREATED_DATE)    latest_session	',
' ,count(session_id)    db_session_count',
' ,sum(WARNING_COUNT)   WARNING_COUNT				 ',
' ,sum(EXCEPTION_COUNT) EXCEPTION_COUNT			 ',
' ,sum(MESSAGE_COUNT)   MESSAGE_COUNT	',
' ,max(INTERNAL_ERROR)      FAILED',
' ,sum(decode(INTERNAL_ERROR,''Y'',1,0))      FAIL_COUNT',
'from sm_session_v2 s ',
'where apex_context_id is null',
'group by username'))
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
 p_id=>wwv_flow_api.id(79424606207274655)
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
,p_internal_uid=>79424606207274655
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340427803107109)
,p_db_column_name=>'USERNAME'
,p_display_order=>10
,p_column_identifier=>'AC'
,p_column_label=>'Username'
,p_column_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:RP:SM_DB_USER,SM_DB_SESSION:#USERNAME#,'
,p_column_linktext=>'#USERNAME#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340506741107110)
,p_db_column_name=>'DB_SESSION_COUNT'
,p_display_order=>20
,p_column_identifier=>'AD'
,p_column_label=>'Database Sessions'
,p_column_link=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.:RP:P46_TREE_HEADING,P46_MESSAGES_HEADING,P46_ID,SM_DB_USER,SM_DB_SESSION:Logger Session #USERNAME#,Choose a Session,,#USERNAME#,'
,p_column_linktext=>'#DB_SESSION_COUNT#'
,p_column_link_attr=>'class="t-Button t-Button--primary t-Button--simple t-Button--small  t-Button--stretch"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28455110017518243)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>30
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28456340318518245)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>40
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28454740310518242)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>50
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28453968862518240)
,p_db_column_name=>'LATEST_SESSION'
,p_display_order=>60
,p_column_identifier=>'Z'
,p_column_label=>'Most Recent Activity'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_column_comment=>'Latest logger session CREATED_DATE, not latest apex session CREATED_DATE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1937763016495604)
,p_db_column_name=>'FAILED'
,p_display_order=>70
,p_column_identifier=>'AE'
,p_column_label=>'Failed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1937805810495605)
,p_db_column_name=>'FAIL_COUNT'
,p_display_order=>80
,p_column_identifier=>'AF'
,p_column_label=>'Fail Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1952139618608562)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Internal Failure'
,p_report_seq=>10
,p_report_alias=>'19522'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USERNAME:DB_SESSION_COUNT:FAILED:FAIL_COUNT:LATEST_SESSION:'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(80568607209462502)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'284571'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USERNAME:DB_SESSION_COUNT:MESSAGE_COUNT:EXCEPTION_COUNT:WARNING_COUNT:LATEST_SESSION:'
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
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25339347496260742)
,p_name=>'Reset Primary Report Name'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(51129564379178574)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25339456528260743)
,p_event_id=>wwv_flow_api.id(25339347496260742)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var my_primary_report_name = ''1. Logger Sessions without Apex Context'';',
' ',
'$(''#''+this.triggeringElement.id+'' .a-IRR-selectList'').find(''option'').each(function(index,elem){',
'  $(elem).text(function(i,text){',
'    return text.replace(''1. Primary Report'',my_primary_report_name);',
'  }); // end of text change',
'}); // end of option walk'))
,p_stop_execution_on_error=>'Y'
);
end;
/
