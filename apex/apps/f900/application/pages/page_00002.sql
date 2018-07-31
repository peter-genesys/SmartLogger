prompt --application/pages/page_00002
begin
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_tab_set=>'TS1'
,p_name=>'Source Library'
,p_page_mode=>'NORMAL'
,p_step_title=>'Source Library'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'ON'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_nav_list_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_cache_timeout_seconds=>21600
,p_help_text=>'No help is available for this page.'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180729004015'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38039013699640399)
,p_plug_name=>'Source Code'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY_3'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'name',
',type',
',ORIG_VALID_YN	 ',
'--,ORIG_TEXT ',
'--,ORIG_RESULT	 ',
',ORIG_LOAD_DATETIME',
',AOP_VALID_YN  ',
'--,AOP_TEXT	 ',
'--,AOP_RESULT ',
',AOP_LOAD_DATETIME',
',HTML_LOAD_DATETIME',
',using_aop',
',case when ORIG_LOAD_DATETIME > AOP_LOAD_DATETIME then',
'  ''Processing''',
'else',
'  ''Done''',
'end as Status',
',case when ORIG_LOAD_DATETIME > AOP_LOAD_DATETIME then',
'  null',
'else',
'  round((AOP_LOAD_DATETIME - ORIG_LOAD_DATETIME) * 24 * 60) ',
'end as elasped_mins',
'from sm_source_v ',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(38039211649640399)
,p_name=>'Source Code'
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_report_categories=>'N'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'NONE'
,p_show_detail_link=>'C'
,p_show_pivot=>'N'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML:EMAIL'
,p_detail_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.::P23_NAME,P23_TYPE:#NAME#,#TYPE#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">'
,p_allow_exclude_null_values=>'N'
,p_allow_hide_extra_columns=>'N'
,p_icon_view_columns_per_row=>1
,p_owner=>'PBURGESS'
,p_internal_uid=>2570108625994254
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38093714191494910)
,p_db_column_name=>'ORIG_VALID_YN'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Orig Valid'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'ORIG_VALID_YN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38094016979494910)
,p_db_column_name=>'ORIG_LOAD_DATETIME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Orig Load Datetime'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
,p_static_id=>'ORIG_LOAD_DATETIME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38094128658494910)
,p_db_column_name=>'AOP_VALID_YN'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'AOP Valid'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'AOP_VALID_YN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38094435740494911)
,p_db_column_name=>'AOP_LOAD_DATETIME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'AOP Load Datetime'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
,p_static_id=>'AOP_LOAD_DATETIME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38095727795531088)
,p_db_column_name=>'NAME'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Name'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38095835126531088)
,p_db_column_name=>'TYPE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Type'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'TYPE'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38562229344945197)
,p_db_column_name=>'HTML_LOAD_DATETIME'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'HTML Load Datetime'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
,p_static_id=>'HTML_LOAD_DATETIME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38648913299303198)
,p_db_column_name=>'USING_AOP'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Using AOP'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_tz_dependent=>'N'
,p_static_id=>'USING_AOP'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36020175961670568)
,p_db_column_name=>'STATUS'
,p_display_order=>24
,p_column_identifier=>'O'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36020265078670569)
,p_db_column_name=>'ELASPED_MINS'
,p_display_order=>34
,p_column_identifier=>'P'
,p_column_label=>'Elasped mins'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(38039916272640597)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'25709'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'NAME:TYPE:ORIG_VALID_YN:ORIG_LOAD_DATETIME:AOP_VALID_YN:AOP_LOAD_DATETIME:HTML_LOAD_DATETIME:USING_AOP::STATUS:ELASPED_MINS'
,p_break_on=>'USING_AOP:0:0:0:0:0'
,p_break_enabled_on=>'USING_AOP:0:0:0:0:0'
,p_flashback_enabled=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38103025278670916)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35569579936315926)
,p_plug_display_sequence=>1
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(53231447489577620)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(35606742937315953)
,p_plug_query_row_template=>1
);
end;
/
