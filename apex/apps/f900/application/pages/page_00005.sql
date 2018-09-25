prompt --application/pages/page_00005
begin
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'User Activity'
,p_page_mode=>'NORMAL'
,p_step_title=>'User Activity'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180925115049'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2044159942971427)
,p_plug_name=>'User Sessions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_column=>9
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select id                                                      value',
'      ,DECODE(''&P5_SHOW_LONG_NAME.'',''N'',short_name,long_name)  name',
'      ,''''                                                      tooltip',
'      ,case ',
'         when node_type = ''SESSION'' then ''fa fa-user-circle''',
'         when node_type = ''CLONE''   then ''fa fa-user-circle-o''',
'         when node_type = ''APP''     then ''fa fa-book''',
'         when node_type = ''PAGE''    then ''fa fa-file-o''',
'         else                            ''fa fa-folder-o''',
'       end      as icon',
'      ,null as link',
'      ,level as lvl',
'      ,parent_id as parent_id ',
'from sm_call_tree_v',
'start with parent_id is null',
'connect by prior id = parent_id',
'order siblings by call_id'))
,p_plug_source_type=>'PLUGIN_COM.MTAG.APEX.FANCYTREEV1.1'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_05=>'P5_SELECTED_NODE'
,p_attribute_06=>'P5_SELECTED_NODE_PARENT'
,p_attribute_07=>'P5_SELECTED_NODE_OLD_PARENT'
,p_attribute_16=>'N'
,p_attribute_19=>'N'
,p_attribute_21=>'N'
,p_attribute_22=>'N'
,p_attribute_23=>'N'
,p_attribute_24=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26684462065153888)
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
 p_id=>wwv_flow_api.id(50970920155756445)
,p_plug_name=>'User Activity'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'  APP_USER			 		   ',
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
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P5_APP_SESSION'
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
 p_id=>wwv_flow_api.id(26756887726645245)
,p_db_column_name=>'APP_USER'
,p_display_order=>20
,p_column_identifier=>'M'
,p_column_label=>'App User'
,p_column_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:RP:SM_APP_USER,SM_APP_SESSION:#APP_USER#,'
,p_column_linktext=>'#APP_USER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26757221944645245)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>30
,p_column_identifier=>'N'
,p_column_label=>'App user fullname'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26757698781645245)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>40
,p_column_identifier=>'O'
,p_column_label=>'App user email'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26756483890645244)
,p_db_column_name=>'MESSAGE_COUNT'
,p_display_order=>60
,p_column_identifier=>'L'
,p_column_label=>'All Messages'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP,40:SM_APP_SESSION,P40_ID,P40_APP_USER:#APPSESSION#,#APPSESSION#,#APP_USER#'
,p_column_linktext=>'#MESSAGE_COUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26758429341645246)
,p_db_column_name=>'WARNING_COUNT'
,p_display_order=>70
,p_column_identifier=>'V'
,p_column_label=>'Warnings'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26756086688645244)
,p_db_column_name=>'EXCEPTION_COUNT'
,p_display_order=>80
,p_column_identifier=>'K'
,p_column_label=>'Errors'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2044633681971432)
,p_db_column_name=>'LATEST_SESSION'
,p_display_order=>90
,p_column_identifier=>'Z'
,p_column_label=>'Latest session'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2044714912971433)
,p_db_column_name=>'SESSION_COUNT'
,p_display_order=>100
,p_column_identifier=>'AA'
,p_column_label=>'Total Session Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(52114923921944293)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'267596'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'APP_USER:MESSAGE_COUNT:WARNING_COUNT:EXCEPTION_COUNT::LATEST_SESSION:SESSION_COUNT'
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
 p_id=>wwv_flow_api.id(26760057794645252)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26760422861645256)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(50970920155756445)
,p_button_name=>'PURGE_OLD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge Old Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26760893592645257)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(50970920155756445)
,p_button_name=>'PURGE_ALL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge All Sessions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2044209955971428)
,p_name=>'P5_SELECTED_NODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2044159942971427)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2044333731971429)
,p_name=>'P5_SELECTED_NODE_PARENT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(2044159942971427)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2044412033971430)
,p_name=>'P5_SELECTED_NODE_OLD_PARENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2044159942971427)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26695051799253546)
,p_name=>'P5_SHOW_LONG_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(2044159942971427)
,p_item_default=>'Y'
,p_prompt=>'Show Long Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26761268230645258)
,p_name=>'P5_APP_SESSION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(50970920155756445)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26761636192645261)
,p_name=>'P5_LOG_CONTEXT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(50970920155756445)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
end;
/
