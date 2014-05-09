--application/shared_components/navigation/breadcrumbs
prompt  ...breadcrumbs
--
 
begin
 
wwv_flow_api.create_menu (
  p_id=> 17762344465931475 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> ' Breadcrumb');
 
wwv_flow_api.create_menu_option (
  p_id=>2634224359024772 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>null,
  p_option_sequence=>10,
  p_short_name=>'Source Code',
  p_long_name=>'',
  p_link=>'f?p=&FLOW_ID.:2:&SESSION.',
  p_page_id=>2,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2634616333027161 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2634224359024772 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'View Source',
  p_long_name=>'',
  p_link=>'f?p=&FLOW_ID.:4:&SESSION.',
  p_page_id=>4,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2725416979064911 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2727227583087388 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Step 3',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::',
  p_page_id=>3,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2726812733084856 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>null,
  p_option_sequence=>10,
  p_short_name=>'Step 1',
  p_long_name=>'',
  p_link=>'f?p=&FLOW_ID.:6:&SESSION.',
  p_page_id=>6,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2727227583087388 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2726812733084856 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Step 2',
  p_long_name=>'',
  p_link=>'f?p=&FLOW_ID.:7:&SESSION.',
  p_page_id=>7,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2727712137909173 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2726812733084856 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Step 1.5',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:13:&SESSION.',
  p_page_id=>13,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2730328507093461 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2725416979064911 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Step 4',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:5:&SESSION.',
  p_page_id=>5,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2765212044066214 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>null,
  p_option_sequence=>10,
  p_short_name=>'AOP Step 2',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:20:&SESSION.',
  p_page_id=>20,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2775004066441191 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>null,
  p_option_sequence=>10,
  p_short_name=>'Plugin Step 1',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:21:&SESSION.',
  p_page_id=>21,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2787518675796004 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2775004066441191 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Plugin Step 2',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:22:&SESSION.',
  p_page_id=>22,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>17762851233931479 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>0,
  p_option_sequence=>10,
  p_short_name=>'Page 1',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:1:&SESSION.',
  p_page_id=>1,
  p_also_current_for_pages=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_menu_option (
  p_id=>17829156375390268 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>null,
  p_option_sequence=>10,
  p_short_name=>'Modules Registry',
  p_long_name=>'',
  p_link=>'f?p=&FLOW_ID.:9:&SESSION.',
  p_page_id=>9,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>17829547748394199 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>17829156375390268 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Unit Registry',
  p_long_name=>'',
  p_link=>'f?p=&FLOW_ID.:10:&SESSION.',
  p_page_id=>10,
  p_also_current_for_pages=> '');
 
null;
 
end;
/

prompt  ...page templates for application: 104
--
