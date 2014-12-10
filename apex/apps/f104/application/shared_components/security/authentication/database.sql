--application/shared_components/security/authentication/database
prompt  ......authentication 17761036848931468
 
begin
 
wwv_flow_api.create_authentication (
  p_id => 17761036848931468 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_name => 'DATABASE'
 ,p_scheme_type => 'NATIVE_DAD'
 ,p_attribute_15 => '17761036848931468'
 ,p_invalid_session_type => 'LOGIN'
 ,p_use_secure_cookie_yn => 'N'
 ,p_comments => 'Use database authentication (user identified by DAD).'
  );
null;
 
end;
/

