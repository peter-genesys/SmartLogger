prompt --application/shared_components/logic/application_items
begin
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(28482797566617832)
,p_name=>'FSP_AFTER_LOGIN_URL'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(157908296763216239)
,p_name=>'PROMO_LEVEL'
,p_protection_level=>'N'
);
end;
/
