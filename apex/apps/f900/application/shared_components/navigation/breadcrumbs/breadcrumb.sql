prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(53231447489577620)
,p_name=>' Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36059355922607354)
,p_short_name=>'Apex Errors'
,p_link=>'f?p=&APP_ID.:6:&SESSION.'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36364793586695260)
,p_parent_id=>0
,p_short_name=>'Session Browser'
,p_long_name=>'Session Browser'
,p_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38103327382670917)
,p_parent_id=>0
,p_short_name=>'Source Library'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38244107090087336)
,p_parent_id=>0
,p_short_name=>'Step 1'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38256621699442149)
,p_parent_id=>wwv_flow_api.id(38244107090087336)
,p_short_name=>'Step 2'
,p_link=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(39002120156740958)
,p_parent_id=>wwv_flow_api.id(38256621699442149)
,p_short_name=>'Step 3'
,p_link=>'f?p=&APP_ID.:25:&SESSION.'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(39182413759674019)
,p_parent_id=>wwv_flow_api.id(38103327382670917)
,p_short_name=>'Compare Source'
,p_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53231954257577624)
,p_parent_id=>0
,p_short_name=>'Dashboard'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53298259399036413)
,p_short_name=>'Modules Registry'
,p_link=>'f?p=&FLOW_ID.:9:&SESSION.'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53298650772040344)
,p_parent_id=>wwv_flow_api.id(53298259399036413)
,p_short_name=>'Unit Registry'
,p_link=>'f?p=&FLOW_ID.:10:&SESSION.'
,p_page_id=>10
);
end;
/
