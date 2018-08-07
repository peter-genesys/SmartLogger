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
,p_last_upd_yyyymmddhh24miss=>'20180807161226'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78757513162525146)
,p_plug_name=>'&P40_LOG_CONTEXT.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
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
'        ,ut.*',
'      ,''<span style="padding-left:''||LEVEL*10||''px;">''||ut.unit_name||''</span>'' level_unit_name',
'  from sm_unit_call_vw ut',
'  start with ut.call_id = :P40_call_ID',
'  connect by prior ut.call_ID = ut.PARENT_call_ID',
'  order siblings by ut.call_ID) a',
'  ,sm_message_vw m',
'where m.call_id = a.call_id'))
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
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RP,RIR,,8:P8_SESSION_ID,P8_CALL_ID:&P8_SESSION_ID.,#CALL_ID#'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(25776510135874735)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Warnings and Errors'
,p_report_seq=>10
,p_report_alias=>'WARN_ERROR'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:MESSAGE:TIME_NOW:'
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
 p_id=>wwv_flow_api.id(26137575146943237)
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
 p_id=>wwv_flow_api.id(26137978089943238)
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
 p_id=>wwv_flow_api.id(26138316552943238)
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
 p_id=>wwv_flow_api.id(26137170436943237)
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
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:'
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
 p_id=>wwv_flow_api.id(26047634885264550)
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
 p_id=>wwv_flow_api.id(26048085340264551)
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
 p_id=>wwv_flow_api.id(26048462323264552)
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
 p_id=>wwv_flow_api.id(26048895694264555)
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
 p_id=>wwv_flow_api.id(26049239902264556)
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
 p_id=>wwv_flow_api.id(26049677636264557)
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
 p_id=>wwv_flow_api.id(26050062285264558)
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
 p_id=>wwv_flow_api.id(26047218125264549)
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
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:'
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
 p_id=>wwv_flow_api.id(26014135784247441)
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
 p_id=>wwv_flow_api.id(26014575481247441)
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
 p_id=>wwv_flow_api.id(26014905043247442)
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
 p_id=>wwv_flow_api.id(26015314639247442)
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
 p_id=>wwv_flow_api.id(26015782014247443)
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
 p_id=>wwv_flow_api.id(26016148235247443)
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
 p_id=>wwv_flow_api.id(26016509342247444)
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
 p_id=>wwv_flow_api.id(26013851672247440)
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
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:'
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
 p_id=>wwv_flow_api.id(26004594965245342)
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
 p_id=>wwv_flow_api.id(26004934129245343)
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
 p_id=>wwv_flow_api.id(26005354376245343)
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
 p_id=>wwv_flow_api.id(26005720341245343)
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
 p_id=>wwv_flow_api.id(26006146735245344)
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
 p_id=>wwv_flow_api.id(26006522823245344)
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
 p_id=>wwv_flow_api.id(26006976523245345)
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
 p_id=>wwv_flow_api.id(26003805871245341)
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
 p_id=>wwv_flow_api.id(26004180271245342)
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(78760927027525149)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'PRIMARY'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE:'
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
 p_id=>wwv_flow_api.id(26023807361253925)
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
 p_id=>wwv_flow_api.id(26024213497253927)
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
,p_highlight_sequence=>10
,p_row_bg_color=>'#CCFFCC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26024633213253927)
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
 p_id=>wwv_flow_api.id(26025025254253928)
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
 p_id=>wwv_flow_api.id(26025487095253929)
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
 p_id=>wwv_flow_api.id(26025806718253930)
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
 p_id=>wwv_flow_api.id(26026204907253931)
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
,p_report_columns=>'LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:TIME_NOW:MESSAGE:'
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
 p_id=>wwv_flow_api.id(25987266095237426)
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
 p_id=>wwv_flow_api.id(25987622960237427)
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
end;
/
begin
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(25986801678237426)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78763716783525152)
,p_plug_name=>'Session Calls'
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
'       end as status, ',
'       level, ',
'       unit_name||DECODE(:P40_SHOW_MODULE_YN,''Y'','' (''||module_name||'')'')  as title, ',
'       null as icon, ',
'       CALL_ID as value, ',
'       null as tooltip, ',
'     ''f?p=&APP_ID.:40:&SESSION.::&DEBUG.::P40_SESSION_ID,P40_CALL_ID:&P40_SESSION_ID.,''||CALL_ID  as link',
'from sm_unit_call_vw',
'start with PARENT_CALL_ID is null and session_id = :P40_SESSION_ID',
'connect by prior CALL_ID = PARENT_CALL_ID',
'order siblings by CALL_ID'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'default'
,p_attribute_02=>'S'
,p_attribute_03=>'P40_CALL_ID'
,p_attribute_04=>'DB'
,p_attribute_06=>'tree28505803386649319'
,p_attribute_07=>'JSTREE'
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
 p_id=>wwv_flow_api.id(25529791450902895)
,p_name=>'P40_CALL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(78757513162525146)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25531659185902902)
,p_name=>'P40_SESSION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(78763716783525152)
,p_source=>'select max(session_id) from sm_session'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25532082624902903)
,p_name=>'P40_SHOW_MODULE_YN'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(78763716783525152)
,p_item_default=>'Y'
,p_prompt=>'Show Module'
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
