prompt --application/pages/page_00040
begin
wwv_flow_api.create_page(
 p_id=>40
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Messages'
,p_page_mode=>'NORMAL'
,p_step_title=>'Messages'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Messages'
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
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180928152639'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78757513162525146)
,p_plug_name=>'&P40_LOG_CONTEXT.'
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
'  from sm_context_tree_v ct',
'  start with id = :P40_ID',
'  connect by prior id = parent_id',
'  order siblings by id, session_date) a',
'  ,sm_message_vw m',
'where m.call_id = a.call_id',
'and   a.node_type IN (''TOPCALL'',''CALL'')     '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(78757698824525147)
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
,p_internal_uid=>78757698824525147
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25507076272902862)
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
 p_id=>wwv_flow_api.id(25507423231902862)
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
 p_id=>wwv_flow_api.id(25507847056902862)
,p_db_column_name=>'UNIT_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Unit Name'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_format_mask=>'<span style="padding-left:#LEVEL*10#px;">#UNIT_NAME#</span>'
,p_tz_dependent=>'N'
,p_static_id=>'UNIT_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25508242186902863)
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
 p_id=>wwv_flow_api.id(25508607781902863)
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
 p_id=>wwv_flow_api.id(25509050441902863)
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
 p_id=>wwv_flow_api.id(25509479423902864)
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
 p_id=>wwv_flow_api.id(25509846254902864)
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
 p_id=>wwv_flow_api.id(25510242070902865)
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
 p_id=>wwv_flow_api.id(25510656350902865)
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
 p_id=>wwv_flow_api.id(25511001474902865)
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
 p_id=>wwv_flow_api.id(25511425489902866)
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
 p_id=>wwv_flow_api.id(25511810050902867)
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
 p_id=>wwv_flow_api.id(25512248728902867)
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
 p_id=>wwv_flow_api.id(25512643270902867)
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
 p_id=>wwv_flow_api.id(25513055032902868)
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
 p_id=>wwv_flow_api.id(25506682564902861)
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
 p_id=>wwv_flow_api.id(25505421755902858)
,p_db_column_name=>'CALL_ID'
,p_display_order=>33
,p_column_identifier=>'X'
,p_column_label=>'Call id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25505851639902861)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>43
,p_column_identifier=>'Y'
,p_column_label=>'Session id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25506231375902861)
,p_db_column_name=>'PARENT_CALL_ID'
,p_display_order=>53
,p_column_identifier=>'Z'
,p_column_label=>'Parent call id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724191478302130)
,p_db_column_name=>'NODE_TYPE'
,p_display_order=>63
,p_column_identifier=>'AA'
,p_column_label=>'Node type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724249568302131)
,p_db_column_name=>'PARENT_ID'
,p_display_order=>73
,p_column_identifier=>'AB'
,p_column_label=>'Parent id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724334151302132)
,p_db_column_name=>'ID'
,p_display_order=>83
,p_column_identifier=>'AC'
,p_column_label=>'Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724450865302133)
,p_db_column_name=>'SHORT_NAME'
,p_display_order=>93
,p_column_identifier=>'AD'
,p_column_label=>'Short name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724504255302134)
,p_db_column_name=>'LONG_NAME'
,p_display_order=>103
,p_column_identifier=>'AE'
,p_column_label=>'Long name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724645617302135)
,p_db_column_name=>'ORIGIN'
,p_display_order=>113
,p_column_identifier=>'AF'
,p_column_label=>'Origin'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724700898302136)
,p_db_column_name=>'USERNAME'
,p_display_order=>123
,p_column_identifier=>'AG'
,p_column_label=>'Username'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724885939302137)
,p_db_column_name=>'INTERNAL_ERROR'
,p_display_order=>133
,p_column_identifier=>'AH'
,p_column_label=>'Internal error'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57724949913302138)
,p_db_column_name=>'NOTIFIED_FLAG'
,p_display_order=>143
,p_column_identifier=>'AI'
,p_column_label=>'Notified flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725033264302139)
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
 p_id=>wwv_flow_api.id(57725134018302140)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>163
,p_column_identifier=>'AK'
,p_column_label=>'Created date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725270457302141)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>173
,p_column_identifier=>'AL'
,p_column_label=>'Updated date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725314114302142)
,p_db_column_name=>'KEEP_YN'
,p_display_order=>183
,p_column_identifier=>'AM'
,p_column_label=>'Keep yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725467603302143)
,p_db_column_name=>'APP_USER'
,p_display_order=>193
,p_column_identifier=>'AN'
,p_column_label=>'App user'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725533022302144)
,p_db_column_name=>'APP_USER_FULLNAME'
,p_display_order=>203
,p_column_identifier=>'AO'
,p_column_label=>'App user fullname'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725695795302145)
,p_db_column_name=>'APP_USER_EMAIL'
,p_display_order=>213
,p_column_identifier=>'AP'
,p_column_label=>'App user email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725758851302146)
,p_db_column_name=>'APP_SESSION'
,p_display_order=>223
,p_column_identifier=>'AQ'
,p_column_label=>'App session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725896345302147)
,p_db_column_name=>'APP_ID'
,p_display_order=>233
,p_column_identifier=>'AR'
,p_column_label=>'App id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57725968385302148)
,p_db_column_name=>'APP_ALIAS'
,p_display_order=>243
,p_column_identifier=>'AS'
,p_column_label=>'App alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57726079505302149)
,p_db_column_name=>'APP_TITLE'
,p_display_order=>253
,p_column_identifier=>'AT'
,p_column_label=>'App title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57726103008302150)
,p_db_column_name=>'APP_PAGE_ID'
,p_display_order=>263
,p_column_identifier=>'AU'
,p_column_label=>'App page id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(57763824814829401)
,p_db_column_name=>'APP_PAGE_ALIAS'
,p_display_order=>273
,p_column_identifier=>'AV'
,p_column_label=>'App page alias'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2043939264971425)
,p_db_column_name=>'PARENT_APP_SESSION'
,p_display_order=>293
,p_column_identifier=>'AX'
,p_column_label=>'Parent app session'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27235819232775014)
,p_db_column_name=>'APEX_CONTEXT_ID'
,p_display_order=>303
,p_column_identifier=>'AY'
,p_column_label=>'Apex context id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27235912167775015)
,p_db_column_name=>'SESSION_DATE'
,p_display_order=>313
,p_column_identifier=>'AZ'
,p_column_label=>'Session date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(25776510135874735)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Warnings and Errors'
,p_report_seq=>10
,p_report_alias=>'WARN_ERROR'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:MESSAGE:TIME_NOW:APEX_CONTEXT_ID:SESSION_DATE'
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
,p_break_on=>'LEVEL_UNIT_NAME:0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26611215275584433)
,p_report_id=>wwv_flow_api.id(25776510135874735)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#99CCFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26611696298584433)
,p_report_id=>wwv_flow_api.id(25776510135874735)
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
 p_id=>wwv_flow_api.id(26612034614584434)
,p_report_id=>wwv_flow_api.id(25776510135874735)
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
,p_row_bg_color=>'#FF3333'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26610869191584432)
,p_report_id=>wwv_flow_api.id(25776510135874735)
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
 p_id=>wwv_flow_api.id(64289969548278625)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Params and Notes'
,p_report_seq=>10
,p_report_alias=>'PARAM_NOTE'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:APEX_CONTEXT_ID:SESSION_DATE'
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
 p_id=>wwv_flow_api.id(26607834301583763)
,p_report_id=>wwv_flow_api.id(64289969548278625)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26608288856583764)
,p_report_id=>wwv_flow_api.id(64289969548278625)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26608605418583764)
,p_report_id=>wwv_flow_api.id(64289969548278625)
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
 p_id=>wwv_flow_api.id(26609003697583764)
,p_report_id=>wwv_flow_api.id(64289969548278625)
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
 p_id=>wwv_flow_api.id(26609460091583765)
,p_report_id=>wwv_flow_api.id(64289969548278625)
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
 p_id=>wwv_flow_api.id(26609825259583766)
,p_report_id=>wwv_flow_api.id(64289969548278625)
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
 p_id=>wwv_flow_api.id(26610222407583766)
,p_report_id=>wwv_flow_api.id(64289969548278625)
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
 p_id=>wwv_flow_api.id(26607494673583762)
,p_report_id=>wwv_flow_api.id(64289969548278625)
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
 p_id=>wwv_flow_api.id(64292596213286296)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Messages'
,p_report_seq=>10
,p_report_alias=>'MESSAGE'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:APEX_CONTEXT_ID:SESSION_DATE'
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
 p_id=>wwv_flow_api.id(26600664744581937)
,p_report_id=>wwv_flow_api.id(64292596213286296)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26601092691581937)
,p_report_id=>wwv_flow_api.id(64292596213286296)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26601463455581938)
,p_report_id=>wwv_flow_api.id(64292596213286296)
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
 p_id=>wwv_flow_api.id(26601828813581939)
,p_report_id=>wwv_flow_api.id(64292596213286296)
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
 p_id=>wwv_flow_api.id(26602226132581939)
,p_report_id=>wwv_flow_api.id(64292596213286296)
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
 p_id=>wwv_flow_api.id(26602624769581940)
,p_report_id=>wwv_flow_api.id(64292596213286296)
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
 p_id=>wwv_flow_api.id(26603091704581940)
,p_report_id=>wwv_flow_api.id(64292596213286296)
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
 p_id=>wwv_flow_api.id(26600298694581936)
,p_report_id=>wwv_flow_api.id(64292596213286296)
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
 p_id=>wwv_flow_api.id(64614072833203427)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'No Debugging'
,p_report_seq=>10
,p_report_alias=>'NO_DEBUG'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:APEX_CONTEXT_ID:SESSION_DATE'
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
,p_break_on=>'LEVEL_UNIT_NAME:0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26604418768583089)
,p_report_id=>wwv_flow_api.id(64614072833203427)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26604863329583090)
,p_report_id=>wwv_flow_api.id(64614072833203427)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26605293806583090)
,p_report_id=>wwv_flow_api.id(64614072833203427)
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
 p_id=>wwv_flow_api.id(26605692090583090)
,p_report_id=>wwv_flow_api.id(64614072833203427)
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
 p_id=>wwv_flow_api.id(26606014406583091)
,p_report_id=>wwv_flow_api.id(64614072833203427)
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
 p_id=>wwv_flow_api.id(26606445006583092)
,p_report_id=>wwv_flow_api.id(64614072833203427)
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
 p_id=>wwv_flow_api.id(26606870003583092)
,p_report_id=>wwv_flow_api.id(64614072833203427)
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
 p_id=>wwv_flow_api.id(26603694155583088)
,p_report_id=>wwv_flow_api.id(64614072833203427)
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
 p_id=>wwv_flow_api.id(26604088833583089)
,p_report_id=>wwv_flow_api.id(64614072833203427)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_TYPE'
,p_operator=>'='
,p_expr=>'Message'
,p_condition_sql=>'"MSG_TYPE" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Message''  '
,p_enabled=>'Y'
);
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(78760927027525149)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'PRIMARY'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:APEX_CONTEXT_ID:SESSION_DATE'
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
 p_id=>wwv_flow_api.id(26595164350579455)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
 p_id=>wwv_flow_api.id(26595562633579456)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
 p_id=>wwv_flow_api.id(26596359731579457)
,p_report_id=>wwv_flow_api.id(78760927027525149)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>4
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26595966348579457)
,p_report_id=>wwv_flow_api.id(78760927027525149)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26596707038579457)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
 p_id=>wwv_flow_api.id(26597104706579457)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
 p_id=>wwv_flow_api.id(26597584313579458)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
 p_id=>wwv_flow_api.id(26597906318579458)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
 p_id=>wwv_flow_api.id(26598385845579459)
,p_report_id=>wwv_flow_api.id(78760927027525149)
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(78761705844525150)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Errors'
,p_report_seq=>10
,p_report_alias=>'ERROR'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'APP_ID:APP_PAGE_ID:LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:TIME_NOW:MESSAGE:APEX_CONTEXT_ID:SESSION_DATE'
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
 p_id=>wwv_flow_api.id(26599303454580827)
,p_report_id=>wwv_flow_api.id(78761705844525150)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26599771903580827)
,p_report_id=>wwv_flow_api.id(78761705844525150)
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
,p_row_bg_color=>'#FF3333'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26598902394580826)
,p_report_id=>wwv_flow_api.id(78761705844525150)
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
 p_id=>wwv_flow_api.id(54839417648170381)
,p_application_user=>'HEWETTJ'
,p_name=>'Primary Detail'
,p_report_seq=>10
,p_report_alias=>'548395'
,p_status=>'PUBLIC'
,p_is_default=>'N'
,p_display_rows=>1000
,p_report_columns=>'MODULE_NAME:LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE'
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
 p_id=>wwv_flow_api.id(54839801652170389)
,p_report_id=>wwv_flow_api.id(54839417648170381)
,p_name=>'Unit Name'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'LEVEL_UNIT_NAME'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("LEVEL_UNIT_NAME" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#BEB7B7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54840236657170389)
,p_report_id=>wwv_flow_api.id(54839417648170381)
,p_name=>'Comment'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'='
,p_expr=>'Comment'
,p_condition_sql=>' (case when ("MSG_LEVEL_TEXT" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Comment''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54840693805170390)
,p_report_id=>wwv_flow_api.id(54839417648170381)
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
 p_id=>wwv_flow_api.id(54841041696170391)
,p_report_id=>wwv_flow_api.id(54839417648170381)
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
 p_id=>wwv_flow_api.id(54841482735170392)
,p_report_id=>wwv_flow_api.id(54839417648170381)
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
 p_id=>wwv_flow_api.id(54841848522170393)
,p_report_id=>wwv_flow_api.id(54839417648170381)
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
 p_id=>wwv_flow_api.id(54842226945170393)
,p_report_id=>wwv_flow_api.id(54839417648170381)
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
 p_id=>wwv_flow_api.id(78763716783525152)
,p_plug_name=>'Session Calls - &SM_APP_SESSION. &P40_APP_USER.'
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
'       ,DECODE(:P40_SHOW_MODULE_YN,''N'',short_name,long_name) title  ',
'       ,case ',
'         when node_type = ''SESSION'' then ''fa fa-user-circle''',
'         when node_type = ''CLONE''   then ''fa fa-user-circle-o''',
'         when node_type = ''APP''     then ''fa fa-book''',
'         when node_type = ''PAGE''    then ''fa fa-file-o''',
'         else                            ''fa fa-folder-o''',
'       end      as icon',
'       ,ID as value  ',
'       ,null as tooltip  ',
'       ,''f?p=&APP_ID.:40:&SESSION.::&DEBUG.::P40_ID,P40_LOG_CONTEXT:''||ID||'',''||long_name  as link',
'from sm_context_tree_v',
'start with parent_id is null',
'connect by prior id = parent_id',
'order siblings by id, session_date'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'S'
,p_attribute_03=>'P40_ID'
,p_attribute_04=>'DB'
,p_attribute_06=>'tree28505803386649319'
,p_attribute_07=>'APEX_TREE'
,p_attribute_08=>'fa'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(90412496270654385)
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
 p_id=>wwv_flow_api.id(25530417755902900)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(78763716783525152)
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
 p_id=>wwv_flow_api.id(25530800719902902)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(78763716783525152)
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
 p_id=>wwv_flow_api.id(25531220153902902)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(78763716783525152)
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
 p_id=>wwv_flow_api.id(25537811130902911)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(78763716783525152)
,p_button_name=>'PURGE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge Old Sessions'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25538211591902911)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(78763716783525152)
,p_button_name=>'PURGE_ALL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_image_alt=>'Purge All Sessions'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition_type=>'NEVER'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25538644623902911)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(78763716783525152)
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
 p_id=>wwv_flow_api.id(2044017331971426)
,p_name=>'P40_APP_USER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(78763716783525152)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25532082624902903)
,p_name=>'P40_SHOW_MODULE_YN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(78763716783525152)
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
 p_id=>wwv_flow_api.id(25735448588759242)
,p_name=>'P40_LOG_CONTEXT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(78757513162525146)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(57764038684829403)
,p_name=>'P40_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(78763716783525152)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25540979339902921)
,p_name=>'HideControlPanel'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(78757513162525146)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25541457171902925)
,p_event_id=>wwv_flow_api.id(25540979339902921)
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
 p_id=>wwv_flow_api.id(25338323920260732)
,p_name=>'Collapse'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25530417755902900)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25338478681260733)
,p_event_id=>wwv_flow_api.id(25338323920260732)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_COLLAPSE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(78763716783525152)
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25338561471260734)
,p_name=>'Expand'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25530800719902902)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25338640282260735)
,p_event_id=>wwv_flow_api.id(25338561471260734)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_EXPAND'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(78763716783525152)
,p_stop_execution_on_error=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25540101724902920)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 1);'
,p_process_when_button_id=>wwv_flow_api.id(25537811130902911)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25540583374902921)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeAllSessions'
,p_process_sql_clob=>'sm_api.purge_old_sessions(i_keep_day_count => 0);'
,p_process_when_button_id=>wwv_flow_api.id(25538211591902911)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25539783648902919)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ToggleKeep'
,p_process_sql_clob=>'sm_api.toggle_session_keep_flag(i_session_id => :P40_SESSION_ID);'
,p_process_when_button_id=>wwv_flow_api.id(27703875164900726)
,p_process_success_message=>'Toggled Keep Flag on Process &P40_SESSION_ID.'
);
end;
/
