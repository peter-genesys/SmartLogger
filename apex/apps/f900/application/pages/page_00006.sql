prompt --application/pages/page_00006
begin
wwv_flow_api.create_page(
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'Apex Errors'
,p_page_mode=>'NORMAL'
,p_step_title=>'Apex Errors'
,p_step_sub_title=>'Apex Errors'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20170510214522'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36058895929607353)
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
 p_id=>wwv_flow_api.id(36059471976607355)
,p_plug_name=>'Apex Errors'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(35559327458315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT *',
'FROM APEX_WORKSPACE_ACTIVITY_LOG',
'WHERE ERROR_MESSAGE IS NOT NULL'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_row_template=>1
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(36059563889607355)
,p_name=>'Apex Errors'
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'PETER'
,p_internal_uid=>11305602546634331
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36060060476607358)
,p_db_column_name=>'WORKSPACE'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Workspace'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36060384343607360)
,p_db_column_name=>'WORKSPACE_DISPLAY_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Workspace Display Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36060786379607360)
,p_db_column_name=>'APEX_USER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Apex User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36061179848607361)
,p_db_column_name=>'APPLICATION_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Application Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36061580136607361)
,p_db_column_name=>'APPLICATION_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Application Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36061970220607361)
,p_db_column_name=>'APPLICATION_SCHEMA_OWNER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Application Schema Owner'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36062369234607362)
,p_db_column_name=>'PAGE_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Page Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36062797542607363)
,p_db_column_name=>'PAGE_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Page Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36063209551607363)
,p_db_column_name=>'VIEW_DATE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'View Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36063572906607363)
,p_db_column_name=>'THINK_TIME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Think Time'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36063965414607363)
,p_db_column_name=>'SECONDS_AGO'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Seconds Ago'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36064363237607364)
,p_db_column_name=>'LOG_CONTEXT'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Log Context'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36064725636607364)
,p_db_column_name=>'ELAPSED_TIME'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Elapsed Time'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36065142180607364)
,p_db_column_name=>'ROWS_QUERIED'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Rows Queried'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36065511059607365)
,p_db_column_name=>'IP_ADDRESS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Ip Address'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36065940240607365)
,p_db_column_name=>'AGENT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Agent'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36066271634607365)
,p_db_column_name=>'APEX_SESSION_ID'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Apex Session Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36066751109607366)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Error Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36067082881607366)
,p_db_column_name=>'ERROR_ON_COMPONENT_TYPE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Error On Component Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36067559898607366)
,p_db_column_name=>'ERROR_ON_COMPONENT_NAME'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Error On Component Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36067923338607366)
,p_db_column_name=>'PAGE_VIEW_MODE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Page View Mode'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36068322794607367)
,p_db_column_name=>'APPLICATION_INFO'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Application Info'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36068717151607367)
,p_db_column_name=>'INTERACTIVE_REPORT_ID'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Interactive Report Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36069155114607368)
,p_db_column_name=>'IR_SAVED_REPORT_ID'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Ir Saved Report Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36069558802607368)
,p_db_column_name=>'IR_SEARCH'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Ir Search'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36069879506607368)
,p_db_column_name=>'WS_APPLICATION_ID'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Ws Application Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36070346255607369)
,p_db_column_name=>'WS_PAGE_ID'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Ws Page Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36070711089607369)
,p_db_column_name=>'WS_DATAGRID_ID'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Ws Datagrid Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36071156467607369)
,p_db_column_name=>'CONTENT_LENGTH'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Content Length'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36071528025607369)
,p_db_column_name=>'REGIONS_FROM_CACHE'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Regions From Cache'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36071914352607370)
,p_db_column_name=>'WORKSPACE_ID'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Workspace Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36072308988607370)
,p_db_column_name=>'PAGE_VIEW_TYPE'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Page View Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36072716212607370)
,p_db_column_name=>'REQUEST_VALUE'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Request Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36073144057607371)
,p_db_column_name=>'DEBUG_PAGE_VIEW_ID'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Debug Page View Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(36073549515607915)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'113196'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'VIEW_DATE:APEX_USER:APPLICATION_NAME:PAGE_ID:PAGE_NAME:ERROR_MESSAGE:ERROR_ON_COMPONENT_TYPE:ERROR_ON_COMPONENT_NAME:PAGE_VIEW_TYPE:REQUEST_VALUE:'
,p_sort_column_1=>'VIEW_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'SECONDS_AGO'
,p_sort_direction_2=>'ASC'
,p_flashback_enabled=>'N'
);
end;
/
