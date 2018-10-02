prompt --application/pages/page_00046
begin
wwv_flow_api.create_page(
 p_id=>46
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'DB Messages'
,p_alias=>'DB_MESSAGES'
,p_page_mode=>'NORMAL'
,p_step_title=>'Messages'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'DB Messages'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'body.t-PageBody.js-rightCollapsed .t-Body-actions {',
'    -webkit-transform: translate3d(400px, 0, 0);',
'    -ms-transform: translate(400px);',
'    transform: translate3d(400px, 0, 0);',
'}',
'',
'.t-Body .t-Body-actions {',
'    width: 400px;',
'}',
'',
'.t-PageBody.js-rightExpanded.t-PageBody--hideLeft .t-Body-main {',
'    margin-right: 100px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20181002234804'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(107327673714059651)
,p_plug_name=>'&P46_MESSAGES_HEADING.'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY_3'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select a.* ',
'      ,m.MESSAGE_ID',
'      ,decode(instr(m.MESSAGE,chr(10)),0,m.MESSAGE,''<PRE>''||m.MESSAGE||''</PRE>'')     MESSAGE',
'      ,m.MSG_LEVEL',
'      ,m.MSG_TYPE',
'      ,m.TIME_NOW',
'      ,m.MSG_LEVEL_TEXT',
'      ,m.name',
'      ,m.value',
'from (',
'select level',
'        ,ct.*',
'      ,''<span style="padding-left:''||LEVEL*10||''px;">''||ct.unit_name||''</span>'' level_unit_name',
'  from sm_db_context_tree_v ct',
'  start with ct.id = :P46_ID',
'  connect by prior ct.id = ct.parent_id',
'  order siblings by ct.session_date, ct.id) a',
'  ,sm_message_vw m',
'where m.call_id = a.call_id',
'and   a.node_type IN (''TOPCALL'',''CALL'')     '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(107327859376059652)
,p_name=>'Traversal Messages'
,p_max_row_count=>'10000'
,p_max_row_count_message=>'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_allow_report_categories=>'N'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'NONE'
,p_show_detail_link=>'N'
,p_show_rows_per_page=>'N'
,p_show_pivot=>'N'
,p_show_notify=>'Y'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML:EMAIL'
,p_allow_exclude_null_values=>'N'
,p_allow_hide_extra_columns=>'N'
,p_icon_view_columns_per_row=>1
,p_owner=>'PBURGESS'
,p_internal_uid=>107327859376059652
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28572851111534536)
,p_db_column_name=>'UNIT_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Unit Id'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'UNIT_ID'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28573245701534536)
,p_db_column_name=>'MODULE_NAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Module Name'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'MODULE_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28573662357534537)
,p_db_column_name=>'UNIT_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Unit Name'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_format_mask=>'<span style="padding-left:#LEVEL*20#px;">#UNIT_NAME#</span>'
,p_static_id=>'UNIT_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28574063705534537)
,p_db_column_name=>'UNIT_TYPE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Unit Type'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'UNIT_TYPE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28574480903534537)
,p_db_column_name=>'MESSAGE_ID'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Message Id'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'MESSAGE_ID'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28574810362534538)
,p_db_column_name=>'MSG_LEVEL'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Msg Level'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'MSG_LEVEL'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28575289439534538)
,p_db_column_name=>'TIME_NOW'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Time'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_static_id=>'TIME_NOW'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28575679098534538)
,p_db_column_name=>'MSG_LEVEL_TEXT'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Msg Level Text'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'MSG_LEVEL_TEXT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28576090813534538)
,p_db_column_name=>'LEVEL'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Level'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'LEVEL'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28576483864534539)
,p_db_column_name=>'MODULE_ID'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Module Id'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'MODULE_ID'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28576805615534539)
,p_db_column_name=>'MODULE_TYPE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Module Type'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'MODULE_TYPE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28577249781534540)
,p_db_column_name=>'MSG_MODE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Msg Mode'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'MSG_MODE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28577676502534541)
,p_db_column_name=>'LEVEL_UNIT_NAME'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Level Unit Name'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:RP,RIR,,40:P40_ID:#ID#'
,p_column_linktext=>'#LEVEL_UNIT_NAME#'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_static_id=>'LEVEL_UNIT_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28578026428534541)
,p_db_column_name=>'MSG_TYPE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Msg Type'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'MSG_TYPE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28578494685534541)
,p_db_column_name=>'NAME'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Name'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28578891061534541)
,p_db_column_name=>'VALUE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Value'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'VALUE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28572442494534536)
,p_db_column_name=>'MESSAGE'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Message'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'CLOB'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_tz_dependent=>'N'
,p_static_id=>'MESSAGE'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28571286194534535)
,p_db_column_name=>'CALL_ID'
,p_display_order=>33
,p_column_identifier=>'X'
,p_column_label=>'Call id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28571693951534535)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>43
,p_column_identifier=>'Y'
,p_column_label=>'Session id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28572021608534535)
,p_db_column_name=>'PARENT_CALL_ID'
,p_display_order=>53
,p_column_identifier=>'Z'
,p_column_label=>'Parent call id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28580450641534543)
,p_db_column_name=>'NODE_TYPE'
,p_display_order=>63
,p_column_identifier=>'AA'
,p_column_label=>'Node type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28580855226534543)
,p_db_column_name=>'PARENT_ID'
,p_display_order=>73
,p_column_identifier=>'AB'
,p_column_label=>'Parent id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28581231423534543)
,p_db_column_name=>'ID'
,p_display_order=>83
,p_column_identifier=>'AC'
,p_column_label=>'Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28581604085534544)
,p_db_column_name=>'ORIGIN'
,p_display_order=>113
,p_column_identifier=>'AF'
,p_column_label=>'Origin'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28582047339534544)
,p_db_column_name=>'USERNAME'
,p_display_order=>123
,p_column_identifier=>'AG'
,p_column_label=>'Username'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28582453807534545)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>133
,p_column_identifier=>'AH'
,p_column_label=>'Internal error'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28582846678534545)
,p_db_column_name=>'NOTIFIED_FLAG'
,p_display_order=>143
,p_column_identifier=>'AI'
,p_column_label=>'Notified flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28583298146534545)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>153
,p_column_identifier=>'AJ'
,p_column_label=>'Error message'
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
 p_id=>wwv_flow_api.id(28583628122534546)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>163
,p_column_identifier=>'AK'
,p_column_label=>'Created date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28584003511534546)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>173
,p_column_identifier=>'AL'
,p_column_label=>'Updated date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28584464245534546)
,p_db_column_name=>'KEEP_YN'
,p_display_order=>183
,p_column_identifier=>'AM'
,p_column_label=>'Keep yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28584874165534547)
,p_db_column_name=>'APP_USER'
,p_display_order=>193
,p_column_identifier=>'AN'
,p_column_label=>'App user'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28585243788534547)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>203
,p_column_identifier=>'AO'
,p_column_label=>'App user fullname'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28585653536534548)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>213
,p_column_identifier=>'AP'
,p_column_label=>'App user email'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28586051514534548)
,p_db_column_name=>'APP_SESSION'
,p_display_order=>223
,p_column_identifier=>'AQ'
,p_column_label=>'App session'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28586480401534548)
,p_db_column_name=>'APP_ID'
,p_display_order=>233
,p_column_identifier=>'AR'
,p_column_label=>'App id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28586859365534548)
,p_db_column_name=>'APP_ALIAS'
,p_display_order=>243
,p_column_identifier=>'AS'
,p_column_label=>'App alias'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28587240090534549)
,p_db_column_name=>'APP_TITLE'
,p_display_order=>253
,p_column_identifier=>'AT'
,p_column_label=>'App title'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28587674131534549)
,p_db_column_name=>'APP_PAGE_ID'
,p_display_order=>263
,p_column_identifier=>'AU'
,p_column_label=>'App page id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28588042217534549)
,p_db_column_name=>'APP_PAGE_ALIAS'
,p_display_order=>273
,p_column_identifier=>'AV'
,p_column_label=>'App page alias'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28570822790534532)
,p_db_column_name=>'PARENT_APP_SESSION'
,p_display_order=>293
,p_column_identifier=>'AX'
,p_column_label=>'Parent app session'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28579209753534541)
,p_db_column_name=>'APEX_CONTEXT_ID'
,p_display_order=>303
,p_column_identifier=>'AY'
,p_column_label=>'Apex context id'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28579692185534542)
,p_db_column_name=>'SESSION_DATE'
,p_display_order=>313
,p_column_identifier=>'AZ'
,p_column_label=>'Session date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28580077088534543)
,p_db_column_name=>'TITLE'
,p_display_order=>323
,p_column_identifier=>'BA'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28340667240107111)
,p_db_column_name=>'ICON'
,p_display_order=>333
,p_column_identifier=>'BB'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57084404805993280)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Errors'
,p_report_seq=>10
,p_report_alias=>'285928'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'TIME_NOW:APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE::ICON'
,p_sort_column_1=>'MESSAGE_ID'
,p_sort_direction_1=>'ASC'
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
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28597251154534565)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Time'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TIME_NOW'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("TIME_NOW" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>0
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28593673006534561)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'AppId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>1
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28594039230534562)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'PageId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_PAGE_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_PAGE_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>2
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28594471616534562)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>3
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28594872114534563)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>5
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28595238328534563)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Info'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Info ?'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Info ?''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28595640328534563)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Warning'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Warning !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Warning !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF9900'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28596001799534564)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Error'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Oracle Error,Fatal !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F24343'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28596467492534564)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Note'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Note'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Note''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28596833516534564)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_name=>'Param'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Param'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Param''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFCCCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28593220645534561)
,p_report_id=>wwv_flow_api.id(57084404805993280)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Internal Error,Fatal !'
,p_condition_sql=>'"MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Internal Error, Fatal !''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57095472133004657)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Messages'
,p_report_seq=>10
,p_report_alias=>'285976'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'TIME_NOW:APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE::ICON'
,p_sort_column_1=>'MESSAGE_ID'
,p_sort_direction_1=>'ASC'
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
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28602010884534568)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Time'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TIME_NOW'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("TIME_NOW" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>0
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28598400078534566)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'AppId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>1
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28598813281534566)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'PageId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_PAGE_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_PAGE_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>2
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28599243508534566)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>3
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28599694530534567)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>5
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28600053989534567)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Info'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Info ?'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Info ?''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28600485523534568)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Warning'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Warning !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Warning !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF9900'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28600886440534568)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Error'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Oracle Error,Fatal !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F24343'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28601260901534568)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Note'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Note'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Note''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28601617199534568)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_name=>'Param'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Param'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Param''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFCCCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28598022056534565)
,p_report_id=>wwv_flow_api.id(57095472133004657)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Message'
,p_condition_sql=>'"MSG_TYPE" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Message''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57107408974021349)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'No Debug'
,p_report_seq=>10
,p_report_alias=>'286072'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'TIME_NOW:APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE::ICON'
,p_sort_column_1=>'MESSAGE_ID'
,p_sort_direction_1=>'ASC'
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
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28612077316534578)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Time'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TIME_NOW'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("TIME_NOW" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>0
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28608483875534574)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'AppId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>1
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28608865803534575)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'PageId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_PAGE_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_PAGE_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>2
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28609294817534575)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>3
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28609670744534576)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>5
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28610006544534576)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Info'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Info ?'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Info ?''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28610483560534577)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Warning'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Warning !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Warning !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF9900'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28610873435534577)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Error'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Oracle Error,Fatal !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F24343'
);
end;
/
begin
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28611234575534577)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Note'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Note'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Note''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28611668042534578)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_name=>'Param'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Param'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Param''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFCCCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28607625370534574)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'!='
,p_expr=>'Comment'
,p_condition_sql=>'"MSG_LEVEL_TEXT" != #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# != ''Comment''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28608091927534574)
,p_report_id=>wwv_flow_api.id(57107408974021349)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Message'
,p_condition_sql=>'"MSG_TYPE" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Message''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57119014765031017)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Params and Notes'
,p_report_seq=>10
,p_report_alias=>'286124'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'TIME_NOW:APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE::ICON'
,p_sort_column_1=>'MESSAGE_ID'
,p_sort_direction_1=>'ASC'
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
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28616892795534583)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Time'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TIME_NOW'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("TIME_NOW" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>0
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28613212231534579)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'AppId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>1
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28613694372534580)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'PageId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_PAGE_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_PAGE_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>2
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28614018097534580)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>3
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28614459959534581)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>5
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28614852624534581)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Info'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Info ?'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Info ?''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28615257919534582)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Warning'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Warning !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Warning !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF9900'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28615696400534582)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Error'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Oracle Error,Fatal !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F24343'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28616077467534582)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Note'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Note'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Note''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28616444613534583)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_name=>'Param'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Param'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Param''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFCCCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28612846155534578)
,p_report_id=>wwv_flow_api.id(57119014765031017)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'in'
,p_expr=>'Param,Note'
,p_condition_sql=>'"MSG_TYPE" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Param, Note''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57129686152037639)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Warnings and Errors'
,p_report_seq=>10
,p_report_alias=>'286024'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'TIME_NOW:APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE::ICON'
,p_sort_column_1=>'MESSAGE_ID'
,p_sort_direction_1=>'ASC'
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
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28606850206534573)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Time'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TIME_NOW'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("TIME_NOW" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>0
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28603238934534570)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'AppId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>1
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28603669640534570)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'PageId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_PAGE_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_PAGE_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>2
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28604098994534571)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>3
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28604423632534571)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>5
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28604861626534571)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Info'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Info ?'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Info ?''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28605201129534571)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Warning'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Warning !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Warning !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF9900'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28605678276534571)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Error'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Oracle Error,Fatal !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F24343'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28606032122534572)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Note'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Note'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Note''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28606445468534572)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_name=>'Param'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Param'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Param''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFCCCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28602834062534569)
,p_report_id=>wwv_flow_api.id(57129686152037639)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Internal Error,Warning !,Fatal !'
,p_condition_sql=>'"MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Internal Error, Warning !, Fatal !''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(107331087579059654)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'285884'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'TIME_NOW:APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE::ICON'
,p_sort_column_1=>'MESSAGE_ID'
,p_sort_direction_1=>'ASC'
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
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28592476043534559)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Time'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TIME_NOW'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("TIME_NOW" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>0
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28588843174534556)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'AppId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>1
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28589242097534556)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'PageId'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APP_PAGE_ID'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("APP_PAGE_ID" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>2
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28589664533534557)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>3
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28590025816534557)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>5
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28590473663534557)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Info'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Info ?'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Info ?''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28590832460534557)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Warning'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Warning !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Warning !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FF9900'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28591262237534558)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Error'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Oracle Error,Fatal !'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Oracle Error, Fatal !''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F24343'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28591602586534558)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Note'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Note'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Note''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28592080177534558)
,p_report_id=>wwv_flow_api.id(107331087579059654)
,p_name=>'Param'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Param'
,p_condition_sql=>' (case when ("MSG_TYPE" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Param''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFCCCC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(107333877335059657)
,p_plug_name=>'&P46_TREE_HEADING.'
,p_region_name=>'call_tree'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_grid_column_span=>3
,p_plug_display_point=>'BODY_3'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when connect_by_isleaf = 1 then 0',
'            when level = 1             then 1',
'            else                           -1',
'       end as status  ',
'       ,level   ',
'       ,title  ',
'       ,icon',
'       ,ID as value  ',
'       ,null as tooltip  ',
'       ,''f?p=&APP_ID.:46:&SESSION.::&DEBUG.::P46_ID,P46_MESSAGES_HEADING:''||ID||'',''||title  as link',
'from sm_db_context_tree_v',
'start with parent_id is null',
'connect by prior id = parent_id',
'order siblings by session_date, id;'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'S'
,p_attribute_03=>'P46_ID'
,p_attribute_04=>'DB'
,p_attribute_06=>'tree28505803386649319'
,p_attribute_07=>'APEX_TREE'
,p_attribute_08=>'fa'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(118982656822188890)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35569579936315926)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'BELOW'
,p_menu_id=>wwv_flow_api.id(53231447489577620)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(35606742937315953)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28617935891534590)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(107333877335059657)
,p_button_name=>'COLLAPSE_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Collapse All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28618313328534593)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(107333877335059657)
,p_button_name=>'EXPAND_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Expand All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28618767540534593)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(107333877335059657)
,p_button_name=>'KEEP'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Keep'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28619979286534593)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(107333877335059657)
,p_button_name=>'REFRESH'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(35605964863315953)
,p_button_image_alt=>'Refresh'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28617267139534585)
,p_name=>'P46_MESSAGES_HEADING'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(107327673714059651)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28620398898534594)
,p_name=>'P46_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(107333877335059657)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
,p_item_comment=>'Used for Current Node'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28620782003534594)
,p_name=>'P46_TREE_HEADING'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(107333877335059657)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(28622956264534616)
,p_name=>'HideControlPanel'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(107327673714059651)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28623447889534618)
,p_event_id=>wwv_flow_api.id(28622956264534616)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'//If Control Panel is visible , toggle it off.',
'if(!($(''#apexir_CONTROL_PANEL_COMPLETE'').css(''display'') == ''none'') ){',
'   gReport.toggle_controls( $x(''apexir_CONTROL_PANEL_CONTROL'') );',
'    return false;',
'}'))
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(28623865285534619)
,p_name=>'Collapse'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(28617935891534590)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28624331901534620)
,p_event_id=>wwv_flow_api.id(28623865285534619)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_COLLAPSE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(107333877335059657)
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(28624738083534621)
,p_name=>'Expand'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(28618313328534593)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28625287114534621)
,p_event_id=>wwv_flow_api.id(28624738083534621)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_EXPAND'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(107333877335059657)
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28621736287534613)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ToggleKeep'
,p_process_sql_clob=>'sm_api.toggle_session_keep_flag(i_session_id => :P46_SESSION_ID);'
,p_process_when_button_id=>wwv_flow_api.id(27703875164900726)
,p_process_success_message=>'Toggled Keep Flag on Process &P46_SESSION_ID.'
);
end;
/
