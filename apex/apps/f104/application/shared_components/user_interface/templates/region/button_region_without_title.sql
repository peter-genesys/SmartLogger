--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 17755250926931434
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 17755250926931434 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_layout => 'TABLE'
 ,p_template => 
'<div class="borderless-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||unistr('\000a')||
'  <div class="bl-top">'||unistr('\000a')||
'    <div class="bl-title">&nbsp;</div>'||unistr('\000a')||
'    <div class="bl-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||unistr('\000a')||
'  </div>'||unistr('\000a')||
'  <div class="bl-body">#BODY#</div>'||unistr('\000a')||
'</div>'
 ,p_page_plug_template_name => 'Button Region without Title'
 ,p_theme_id => 1
 ,p_theme_class_id => 17
 ,p_default_label_alignment => 'RIGHT'
 ,p_default_field_alignment => 'LEFT'
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

