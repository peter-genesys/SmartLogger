prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(53231447489577620)
,p_name=>' Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25046302152869475)
,p_parent_id=>0
,p_short_name=>'Settings'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25301237257164985)
,p_parent_id=>0
,p_short_name=>'Apex Sessions'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25539554331902916)
,p_parent_id=>wwv_flow_api.id(25301237257164985)
,p_short_name=>'Messages'
,p_link=>'f?p=&APP_ID.:40:&SESSION.'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25811729421917962)
,p_short_name=>'Logger Sessions'
,p_link=>'f?p=&APP_ID.:35:&SESSION.'
,p_page_id=>35
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26194982721586297)
,p_parent_id=>0
,p_short_name=>'Just Messages'
,p_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:::'
,p_page_id=>50
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
,p_short_name=>'Original PLSQL'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38256621699442149)
,p_parent_id=>wwv_flow_api.id(38244107090087336)
,p_short_name=>'Woven with Highlighting'
,p_link=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(39002120156740958)
,p_parent_id=>wwv_flow_api.id(38256621699442149)
,p_short_name=>'Woven Plain'
,p_link=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:::'
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
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(57836709018223193)
,p_parent_id=>wwv_flow_api.id(25811729421917962)
,p_short_name=>'Logger Session Messages'
,p_link=>'f?p=&APP_ID.:45:&SESSION.'
,p_page_id=>45
);
end;
/
