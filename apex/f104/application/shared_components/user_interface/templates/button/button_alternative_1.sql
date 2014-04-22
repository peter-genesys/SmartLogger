--application/shared_components/user_interface/templates/button/button_alternative_1
prompt  ......Button Template 17754539557931433
 
begin
 
wwv_flow_api.create_button_templates (
  p_id => 17754539557931433 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template_name => 'Button, Alternative 1'
 ,p_template => 
'<button value="#LABEL#" onclick="#LINK#" class="button-alt1" type="button">'||unistr('\000a')||
'  <span>#LABEL#</span>'||unistr('\000a')||
'</button>'
 ,p_translate_this_template => 'N'
 ,p_theme_class_id => 4
 ,p_theme_id => 1
  );
null;
 
end;
/

