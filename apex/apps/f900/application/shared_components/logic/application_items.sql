prompt --application/shared_components/logic/application_items
begin
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(25103888368087635)
,p_name=>'APP_LOGO'
,p_protection_level=>'N'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(53236758909590856)
,p_name=>'FSP_AFTER_LOGIN_URL'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(182662258106189263)
,p_name=>'PROMO_LEVEL'
,p_protection_level=>'N'
);
end;
/
