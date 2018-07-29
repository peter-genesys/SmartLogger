prompt --application/shared_components/security/authentications
begin
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(53230059095577613)
,p_name=>'Application Express'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_attribute_15=>'17760956071931468'
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:1'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_comments=>'Use internal Application Express account credentials and login page in this application.'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(53230139872577613)
,p_name=>'DATABASE'
,p_scheme_type=>'NATIVE_DAD'
,p_attribute_15=>'17761036848931468'
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_comments=>'Use database authentication (user identified by DAD).'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(53230244667577613)
,p_name=>'DATABASE ACCOUNT'
,p_scheme_type=>'NATIVE_DB_ACCOUNTS'
,p_attribute_15=>'17761141643931468'
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:1'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_comments=>'Use database account credentials.'
);
end;
/
