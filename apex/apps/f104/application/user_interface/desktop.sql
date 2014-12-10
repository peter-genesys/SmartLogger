--application/user interface/desktop
wwv_flow_api.create_user_interface (
  p_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_ui_type_name => 'DESKTOP'
 ,p_display_name => 'DESKTOP'
 ,p_display_seq => 10
 ,p_use_auto_detect => false
 ,p_is_default => true
 ,p_theme_id => 1
 ,p_home_url => 'f?p=&APP_ID.:1:&SESSION.'
  );
null;
 
end;
/

prompt  ...plug-in settings
--
 
begin
 
