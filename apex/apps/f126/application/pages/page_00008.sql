prompt --application/pages/page_00008
begin
wwv_flow_api.create_page(
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(13227173141283158)
,p_name=>'Process Browser'
,p_page_mode=>'NORMAL'
,p_step_title=>'Process Browser'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title=>'Traversal Tree'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_html_page_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<script type="text/javascript"> ',
'',
'',
'',
'function set_value(p_field,p_value) {',
'	document.getElementById(p_field).value=p_value;',
'}',
'',
'	function view_any_page(p_page_no, p_page_name, p_id_field, p_id_value, p_id_name) {',
'		if ( p_id_value ) {',
'			// get the app items from the form vars',
'			var l_app_id = $v(''pFlowId'');',
'			var l_app_session = $v(''pInstance'');',
'			var l_debug = $v(''pdebug'');',
'			// open the tab',
'			top.Ext.app.tabs.viewTab(p_page_no, p_id_value, p_page_name + '' - '' + p_id_name, ''f?p='' + l_app_id + '':'' + p_page_no + '':'' + l_app_session + ''::'' + l_debug + '':'' + p_page_no + '':'' + p_id_field + '':'' + p_id_value);',
'		}',
'	}',
'',
'</script>'))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'BURGPETE'
,p_last_upd_yyyymmddhh24miss=>'20180427113010'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14319247721374987)
,p_plug_name=>'Process'
,p_component_template_options=>'#DEFAULT#'
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY_3'
,p_plug_query_row_template=>1
,p_plug_query_headings_type=>'QUERY_COLUMNS'
,p_plug_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28499388879649313)
,p_plug_name=>'References and Messages'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10805366115342898)
,p_plug_display_sequence=>40
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
'  from ms_unit_traversal_vw ut',
'  start with ut.traversal_id = :P8_TRAVERSAL_ID',
'  connect by prior ut.TRAVERSAL_ID = ut.PARENT_TRAVERSAL_ID',
'  order siblings by ut.TRAVERSAL_ID) a',
'  ,ms_message_vw m',
'where m.traversal_id = a.traversal_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(28499574541649314)
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
,p_internal_uid=>17784432860976193
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28499676963649314)
,p_db_column_name=>'TRAVERSAL_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Traversal Id'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'TRAVERSAL_ID'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28499795796649314)
,p_db_column_name=>'PROCESS_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Process Id'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'PROCESS_ID'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28499887708649314)
,p_db_column_name=>'EXT_REF'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'External Ref'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'EXT_REF'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28499977010649314)
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
 p_id=>wwv_flow_api.id(28500095895649314)
,p_db_column_name=>'PARENT_TRAVERSAL_ID'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Parent Traversal Id'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_static_id=>'PARENT_TRAVERSAL_ID'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28500203972649314)
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
 p_id=>wwv_flow_api.id(28500287120649314)
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
 p_id=>wwv_flow_api.id(28500388404649314)
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
 p_id=>wwv_flow_api.id(28500495256649315)
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
 p_id=>wwv_flow_api.id(28500683987649315)
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
 p_id=>wwv_flow_api.id(28500794634649315)
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
 p_id=>wwv_flow_api.id(28500889136649315)
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
 p_id=>wwv_flow_api.id(28500998357649315)
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
 p_id=>wwv_flow_api.id(28501090617649315)
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
 p_id=>wwv_flow_api.id(28501183014649315)
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
 p_id=>wwv_flow_api.id(28501298446649315)
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
 p_id=>wwv_flow_api.id(28501389817649315)
,p_db_column_name=>'LEVEL_UNIT_NAME'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Level Unit Name'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RIR,RP,8:P8_PROCESS_ID,P8_TRAVERSAL_ID:&P8_PROCESS_ID.,#TRAVERSAL_ID#'
,p_column_linktext=>'#LEVEL_UNIT_NAME#'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_tz_dependent=>'N'
,p_static_id=>'LEVEL_UNIT_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28501503011649315)
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
 p_id=>wwv_flow_api.id(28501581992649315)
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
 p_id=>wwv_flow_api.id(28501687456649316)
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
 p_id=>wwv_flow_api.id(14318850302342657)
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(14031845265402792)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Params and Notes'
,p_report_seq=>10
,p_report_alias=>'33168'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE'
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
 p_id=>wwv_flow_api.id(14033770578407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14033858811407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14033961836407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14034070891407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14034157514407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14034273003407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14034355376407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
,p_row_bg_color=>'#C77AC6'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(14033661888407623)
,p_report_id=>wwv_flow_api.id(14031845265402792)
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
 p_id=>wwv_flow_api.id(14034471930410463)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Messages'
,p_report_seq=>10
,p_report_alias=>'33194'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE'
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
 p_id=>wwv_flow_api.id(14347060025293675)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14347149322293675)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14347253823293675)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
,p_row_bg_color=>'#C77AC6'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(14347364024293676)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14347462696293676)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14347550077293676)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14347643359293677)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14346962225293675)
,p_report_id=>wwv_flow_api.id(14034471930410463)
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
 p_id=>wwv_flow_api.id(14355948550327594)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'No Debugging'
,p_report_seq=>10
,p_report_alias=>'36409'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE'
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
 p_id=>wwv_flow_api.id(14358954056333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14359068848333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14359153779333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
,p_row_bg_color=>'#C77AC6'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(14359267473333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14359370572333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14359472436333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14359555828333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14358768290333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(14358872928333316)
,p_report_id=>wwv_flow_api.id(14355948550327594)
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
 p_id=>wwv_flow_api.id(28502802744649316)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'76255'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEVEL_UNIT_NAME:NAME:VALUE:MESSAGE'
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
 p_id=>wwv_flow_api.id(14031149636394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
 p_id=>wwv_flow_api.id(14031265846394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
 p_id=>wwv_flow_api.id(14031357091394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
 p_id=>wwv_flow_api.id(14031469812394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
 p_id=>wwv_flow_api.id(14031573593394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
 p_id=>wwv_flow_api.id(14031657766394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
 p_id=>wwv_flow_api.id(14031754359394622)
,p_report_id=>wwv_flow_api.id(28502802744649316)
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
,p_row_bg_color=>'#C77AC6'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(28503581561649317)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Exceptions'
,p_report_seq=>10
,p_report_alias=>'EXCEPTIONS'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'LEVEL_UNIT_NAME:LEVEL:NAME:VALUE:TIME_NOW:MESSAGE'
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
 p_id=>wwv_flow_api.id(14030764349380066)
,p_report_id=>wwv_flow_api.id(28503581561649317)
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
 p_id=>wwv_flow_api.id(14030856433380066)
,p_report_id=>wwv_flow_api.id(28503581561649317)
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
 p_id=>wwv_flow_api.id(14030962325380066)
,p_report_id=>wwv_flow_api.id(28503581561649317)
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
 p_id=>wwv_flow_api.id(14030664958380066)
,p_report_id=>wwv_flow_api.id(28503581561649317)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'MSG_LEVEL_TEXT'
,p_operator=>'in'
,p_expr=>'Internal Error,Warning !,Fatal !'
,p_condition_sql=>'"MSG_LEVEL_TEXT" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Internal Error, Warning !, Fatal !''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28505592500649319)
,p_plug_name=>'Process &P8_PROCESS_ID. - Stack Trace'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10806409948342898)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_grid_column_span=>4
,p_plug_display_point=>'BODY_3'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when connect_by_isleaf = 1 then 0',
'            when level = 1             then 1',
'            else                           -1',
'       end as status, ',
'       level, ',
'       unit_name||DECODE(:P8_SHOW_MODULE_YN,''Y'','' (''||module_name||'')'')  as title, ',
'       null as icon, ',
'       TRAVERSAL_ID as value, ',
'       null as tooltip, ',
'	   ''f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_PROCESS_ID,P8_TRAVERSAL_ID:&P8_PROCESS_ID.,''||TRAVERSAL_ID  as link, ',
'       TRAVERSAL_ID,',
'       PARENT_TRAVERSAL_ID',
'from ms_unit_traversal_vw',
'start with PARENT_TRAVERSAL_ID is null and process_id = :P8_PROCESS_ID',
'connect by prior TRAVERSAL_ID = PARENT_TRAVERSAL_ID',
'order siblings by TRAVERSAL_ID'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'default'
,p_attribute_02=>'S'
,p_attribute_03=>'P8_TRAVERSAL_ID'
,p_attribute_04=>'DB'
,p_attribute_06=>'tree28505803386649319'
,p_attribute_07=>'JSTREE'
);
end;
/
begin
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(28506580903649320)
,p_name=>'Process Traces'
,p_template=>wwv_flow_api.id(10806409948342898)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'N'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY_3'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select p.*  ',
'      ,(select min(traversal_id) from ms_traversal where parent_traversal_id is null and process_id = p.process_id) top_traversal_id',
',(select count(*)',
'from ms_traversal t',
'    ,ms_message m',
'where t.process_id = p.process_id',
'and m.traversal_id = t.traversal_id',
'and m.msg_level > 2) exception_count',
',(select count(*)',
'from ms_traversal t',
'    ,ms_message m',
'where t.process_id = p.process_id',
'and m.traversal_id = t.traversal_id ) message_count',
'from ms_process p'))
,p_source_type=>'NATIVE_SQL_REPORT'
,p_ajax_enabled=>'Y'
,p_fixed_header=>'NONE'
,p_query_row_template=>wwv_flow_api.id(10826985361342911)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>' - '
,p_query_break_cols=>'0'
,p_query_no_data_found=>'No Processes Found.'
,p_query_num_rows_item=>'P8_NUM_ROWS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_break_type_flag=>'DEFAULT_BREAK_FORMATTING'
,p_csv_output=>'N'
,p_query_asc_image=>'apex/builder/dup.gif'
,p_query_asc_image_attr=>'width="16" height="16" alt="" '
,p_query_desc_image=>'apex/builder/ddown.gif'
,p_query_desc_image_attr=>'width="16" height="16" alt="" '
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28506774910649321)
,p_query_column_id=>1
,p_column_alias=>'PROCESS_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Process Id'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RIR:P8_PROCESS_ID,P8_TRAVERSAL_ID:#PROCESS_ID#,#TOP_TRAVERSAL_ID#'
,p_column_linktext=>'#PROCESS_ID#'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_default_sort_dir=>'desc'
,p_disable_sort_column=>'N'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28506875220649321)
,p_query_column_id=>2
,p_column_alias=>'EXT_REF'
,p_column_display_sequence=>3
,p_column_heading=>'External Ref'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28506974704649321)
,p_query_column_id=>3
,p_column_alias=>'ORIGIN'
,p_column_display_sequence=>2
,p_column_heading=>'Origin'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28507093492649321)
,p_query_column_id=>4
,p_column_alias=>'USERNAME'
,p_column_display_sequence=>4
,p_column_heading=>'Username'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28507279219649321)
,p_query_column_id=>5
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>5
,p_column_heading=>'Comments'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28507388577649321)
,p_query_column_id=>6
,p_column_alias=>'INTERNAL_ERROR'
,p_column_display_sequence=>9
,p_column_heading=>'Internal Error Flag'
,p_disable_sort_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28507477025649321)
,p_query_column_id=>7
,p_column_alias=>'NOTIFIED_FLAG'
,p_column_display_sequence=>10
,p_column_heading=>'Notified Flag'
,p_disable_sort_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(14405864722652598)
,p_query_column_id=>8
,p_column_alias=>'ERROR_MESSAGE'
,p_column_display_sequence=>11
,p_column_heading=>'Internal Error Message'
,p_use_as_row_header=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_column_comment=>'DO NOT ALLOW SORTABLE - CAUSES CLOB ERRORS'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(28507187705649321)
,p_query_column_id=>9
,p_column_alias=>'CREATED_DATE'
,p_column_display_sequence=>12
,p_column_heading=>'Created DateTime'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_lov_show_nulls=>'NO'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(14405958464652602)
,p_query_column_id=>10
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>13
,p_column_heading=>'Updated Date'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2949851095927701)
,p_query_column_id=>11
,p_column_alias=>'KEEP_YN'
,p_column_display_sequence=>14
,p_column_heading=>'Keep yn'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(14131147995996832)
,p_query_column_id=>12
,p_column_alias=>'TOP_TRAVERSAL_ID'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(14371965368452051)
,p_query_column_id=>13
,p_column_alias=>'EXCEPTION_COUNT'
,p_column_display_sequence=>8
,p_column_heading=>'Exception Count'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.:IR_REPORT_EXCEPTIONS:&DEBUG.::P8_PROCESS_ID,P8_TRAVERSAL_ID:#PROCESS_ID#,#TOP_TRAVERSAL_ID#'
,p_column_linktext=>'#EXCEPTION_COUNT#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(15464860856633598)
,p_query_column_id=>14
,p_column_alias=>'MESSAGE_COUNT'
,p_column_display_sequence=>7
,p_column_heading=>'Message Count'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40154371987778552)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10815618593342902)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'BELOW'
,p_menu_id=>wwv_flow_api.id(28477486146604596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10852781594342929)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28507600034649321)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(28506580903649320)
,p_button_name=>'PURGE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Purge Old Processes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28507787332649321)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(28506580903649320)
,p_button_name=>'PURGE_ALL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Purge All Processes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14855742544381693)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(28506580903649320)
,p_button_name=>'REFRESH'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10852003520342929)
,p_button_image_alt=>'Refresh'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28505977796649320)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28505592500649319)
,p_button_name=>'CONTRACT_ALL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Collapse All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_redirect_url=>'javascript:apex.widget.tree.collapse_all(''tree25697475225348441'');'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28506197277649320)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28505592500649319)
,p_button_name=>'EXPAND_ALL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_image_alt=>'Expand All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_redirect_url=>'javascript:apex.widget.tree.expand_all(''tree25697475225348441'');'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2949913821927702)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(28505592500649319)
,p_button_name=>'KEEP'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10851931649342929)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Keep'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14284655150300387)
,p_name=>'P8_SHOW_MODULE_YN'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(28505592500649319)
,p_item_default=>'N'
,p_prompt=>'Show Module'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10851401898342926)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14310649388554454)
,p_name=>'P8_NUM_ROWS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(28506580903649320)
,p_prompt=>'Rows'
,p_source=>'5'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,5;5,10;10,15;15,20;20,25;25,30;30,50;50,100;100,200;200,500;500,1000;1000,5000;5000'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10851401898342926)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28505392618649318)
,p_name=>'P8_TRAVERSAL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(28499388879649313)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28506391507649320)
,p_name=>'P8_PROCESS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(28505592500649319)
,p_source=>'select max(process_id) from ms_process'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14051171350618429)
,p_name=>'HideControlPanel'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(28499388879649313)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14051473336618435)
,p_event_id=>wwv_flow_api.id(14051171350618429)
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
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28508003792649321)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeOldProcesses'
,p_process_sql_clob=>'ms_api.purge_old_processes(i_keep_day_count => 1);'
,p_process_when_button_id=>wwv_flow_api.id(28507600034649321)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28508176087649322)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PurgeAllProcesses'
,p_process_sql_clob=>'ms_api.purge_old_processes(i_keep_day_count => 0);'
,p_process_when_button_id=>wwv_flow_api.id(28507787332649321)
,p_process_success_message=>'Purged old messages'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2950296542927705)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ToggleKeep'
,p_process_sql_clob=>'ms_api.toggle_process_keep_flag(i_process_id => :P8_PROCESS_ID);'
,p_process_when_button_id=>wwv_flow_api.id(2949913821927702)
,p_process_success_message=>'Toggled Keep Flag on Process &P8_PROCESS_ID.'
);
end;
/
