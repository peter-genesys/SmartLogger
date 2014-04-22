--application/shared_components/user_interface/themes/simple_red
prompt  ......theme 17760840534931463
begin
wwv_flow_api.create_theme (
  p_id =>17760840534931463 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 1,
  p_theme_name=>'Simple Red',
  p_ui_type_name=>'DESKTOP',
  p_is_locked=>false,
  p_default_page_template=>17753761249931431 + wwv_flow_api.g_id_offset,
  p_error_template=>17753761249931431 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>17753949310931431 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'REGION_POSITION_02',
  p_login_template=>17752956143931429 + wwv_flow_api.g_id_offset,
  p_default_button_template=>17754457373931432 + wwv_flow_api.g_id_offset,
  p_default_region_template=>17756239625931434 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>17755364250931434 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>17755453133931434 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>17756239625931434 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>17756239625931434 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>17756839023931435 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>17755063450931434 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>17755643932931434 + wwv_flow_api.g_id_offset,
  p_default_irr_template=>17755951543931434 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>17758952883931438 + wwv_flow_api.g_id_offset,
  p_default_label_template=>17759655087931450 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>17759948703931450 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>17760158943931450 + wwv_flow_api.g_id_offset,
  p_default_list_template=>17758244714931436 + wwv_flow_api.g_id_offset,
  p_default_option_label=>17759655087931450 + wwv_flow_api.g_id_offset,
  p_default_header_template=>null + wwv_flow_api.g_id_offset,
  p_default_footer_template=>null + wwv_flow_api.g_id_offset,
  p_default_page_transition=>'NONE',
  p_default_popup_transition=>'NONE',
  p_default_required_label=>17759837603931450 + wwv_flow_api.g_id_offset);
end;
/
 
prompt  ...theme styles
--
 
begin
 
null;
 
end;
/

prompt  ...theme display points
--
 
begin
 
null;
 
end;
/

prompt  ...build options
--
 
begin
 
null;
 
end;
/

