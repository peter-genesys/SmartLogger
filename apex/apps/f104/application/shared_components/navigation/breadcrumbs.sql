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
  p_parent_id=>0,
  p_option_sequence=>10,
  p_short_name=>'Source Library',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::',
  p_page_id=>2,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2775004066441191 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>0,
  p_option_sequence=>10,
  p_short_name=>'Step 1',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::',
  p_page_id=>21,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>2787518675796004 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2775004066441191 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Step 2',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:::',
  p_page_id=>22,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>3533017133094813 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2787518675796004 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Step 3',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:25:&SESSION.',
  p_page_id=>25,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>3713310736027874 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>2634224359024772 + wwv_flow_api.g_id_offset,
  p_option_sequence=>10,
  p_short_name=>'Compare Source',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::',
  p_page_id=>23,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>17762851233931479 + wwv_flow_api.g_id_offset,
  p_menu_id=>17762344465931475 + wwv_flow_api.g_id_offset,
  p_parent_id=>0,
  p_option_sequence=>10,
  p_short_name=>'Dashboard',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
  p_page_id=>1,
  p_also_current_for_pages=> '');
 
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
