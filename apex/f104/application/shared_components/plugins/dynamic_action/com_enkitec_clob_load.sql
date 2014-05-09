--application/shared_components/plugins/dynamic_action/com_enkitec_clob_load
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'COM_ENKITEC_CLOB_LOAD'
 ,p_display_name => 'Enkitec CLOB Load'
 ,p_category => 'MISC'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'FUNCTION enkitec_clob_load_render ('||unistr('\000a')||
'   p_dynamic_action IN APEX_PLUGIN.T_DYNAMIC_ACTION,'||unistr('\000a')||
'   p_plugin         IN APEX_PLUGIN.T_PLUGIN'||unistr('\000a')||
')'||unistr('\000a')||
''||unistr('\000a')||
'   RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT'||unistr('\000a')||
''||unistr('\000a')||
'IS'||unistr('\000a')||
''||unistr('\000a')||
'   l_retval           APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;'||unistr('\000a')||
'   l_show_modal       VARCHAR2(1) := p_plugin.attribute_01;'||unistr('\000a')||
'   l_dialog_title     VARCHAR2(4000) := NVL(p_plugin.attribute_02, ''Please wait.'||
'..'');'||unistr('\000a')||
'   l_loading_img_type VARCHAR2(30) := p_plugin.attribute_03;'||unistr('\000a')||
'   l_loading_img_c    VARCHAR2(4000) := p_plugin.attribute_04;'||unistr('\000a')||
'   l_action           VARCHAR2(10) := NVL(p_dynamic_action.attribute_01, ''RENDER'');'||unistr('\000a')||
'   l_change_only      VARCHAR2(1) := NVL(p_dynamic_action.attribute_06, ''Y'');'||unistr('\000a')||
'   l_make_blocking    VARCHAR2(1) := NVL(p_dynamic_action.attribute_07, ''Y'');'||unistr('\000a')||
'   l_loading_img_src  VARCHAR2'||
'(32767);'||unistr('\000a')||
'   l_crlf             VARCHAR2(2) := CHR(13)||CHR(10);'||unistr('\000a')||
'   l_js_function      VARCHAR2(32767);'||unistr('\000a')||
'   l_onload_code      VARCHAR2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'BEGIN'||unistr('\000a')||
''||unistr('\000a')||
'   IF apex_application.g_debug'||unistr('\000a')||
'   THEN'||unistr('\000a')||
'      apex_plugin_util.debug_dynamic_action('||unistr('\000a')||
'         p_plugin         => p_plugin,'||unistr('\000a')||
'         p_dynamic_action => p_dynamic_action'||unistr('\000a')||
'      );'||unistr('\000a')||
'   END IF;'||unistr('\000a')||
''||unistr('\000a')||
'   IF l_loading_img_type = ''DEFAULT'''||unistr('\000a')||
'   THEN'||unistr('\000a')||
'      l_loading'||
'_img_src := p_plugin.file_prefix || ''enkitec-loading.gif'';'||unistr('\000a')||
'   ELSE'||unistr('\000a')||
'      l_loading_img_src := REPLACE(l_loading_img_c, ''#IMAGE_PREFIX#'', apex_application.g_image_prefix);'||unistr('\000a')||
'      l_loading_img_src := REPLACE(l_loading_img_src, ''#PLUGIN_PREFIX#'', p_plugin.file_prefix);'||unistr('\000a')||
'   END IF;'||unistr('\000a')||
''||unistr('\000a')||
'   apex_css.add('||unistr('\000a')||
'      p_css => ''.clob-load-dialog .ui-dialog-titlebar-close {display: none;}'','||unistr('\000a')||
'      p_key => ''clob-load'||
'-hide-modal-close'''||unistr('\000a')||
'   );'||unistr('\000a')||
''||unistr('\000a')||
'   apex_javascript.add_library('||unistr('\000a')||
'      p_name      => ''enkitec-clob-load.min'','||unistr('\000a')||
'      p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'      p_version   => NULL'||unistr('\000a')||
'   );'||unistr('\000a')||
''||unistr('\000a')||
'   l_onload_code :='||unistr('\000a')||
'      ''apex.jQuery(document).clob_load({''|| l_crlf ||'||unistr('\000a')||
'      ''   showModal: "'' || l_show_modal ||''",''|| l_crlf ||'||unistr('\000a')||
'      ''   dialogTitle: "'' || l_dialog_title ||''",''|| l_crlf ||'||unistr('\000a')||
'      ''   loadingImageSr'||
'c: "'' || l_loading_img_src ||''",''|| l_crlf ||'||unistr('\000a')||
'      ''   pluginFilePrefix: "'' || p_plugin.file_prefix || ''",'' || l_crlf ||'||unistr('\000a')||
'      ''   apexImagePrefix: "'' || apex_application.g_image_prefix || '',"'' || l_crlf ||'||unistr('\000a')||
'      ''});'';'||unistr('\000a')||
''||unistr('\000a')||
'   apex_javascript.add_onload_code('||unistr('\000a')||
'      p_code => l_onload_code'||unistr('\000a')||
'   );'||unistr('\000a')||
''||unistr('\000a')||
'   IF l_action = ''RENDER'''||unistr('\000a')||
'   THEN'||unistr('\000a')||
'      l_js_function :='||unistr('\000a')||
'         ''function(){''|| l_crlf ||'||unistr('\000a')||
'         ''   '||
'apex.jQuery(document).clob_load("renderClob", {'' || l_crlf ||'||unistr('\000a')||
'         ''      $elmt: this.affectedElements.eq(0),'' || l_crlf ||'||unistr('\000a')||
'         ''      ajaxIdentifier: "'' || apex_plugin.get_ajax_identifier() || ''"'' || l_crlf ||'||unistr('\000a')||
'         ''   });''|| l_crlf ||'||unistr('\000a')||
'         ''}'';'||unistr('\000a')||
'   ELSE'||unistr('\000a')||
'      l_js_function :='||unistr('\000a')||
'         ''function(){''|| l_crlf ||'||unistr('\000a')||
'         ''   apex.jQuery(document).clob_load("submitClob", {'' || l_crl'||
'f ||'||unistr('\000a')||
'         ''      $elmt: this.affectedElements.eq(0),'' || l_crlf ||'||unistr('\000a')||
'         ''      ajaxIdentifier: "'' || apex_plugin.get_ajax_identifier() || ''",'' || l_crlf ||'||unistr('\000a')||
'         ''      changeOnly: "'' || l_change_only || ''",'' || l_crlf ||'||unistr('\000a')||
'         ''      makeBlocking: "'' || l_make_blocking || ''"'' || l_crlf ||'||unistr('\000a')||
'         ''   });''|| l_crlf ||'||unistr('\000a')||
'         ''}'';'||unistr('\000a')||
'   END IF;'||unistr('\000a')||
''||unistr('\000a')||
'   l_retval.javascript_function := l_js'||
'_function;'||unistr('\000a')||
''||unistr('\000a')||
'   RETURN l_retval;'||unistr('\000a')||
''||unistr('\000a')||
'END enkitec_clob_load_render;'||unistr('\000a')||
''||unistr('\000a')||
'FUNCTION enkitec_clob_load_ajax ('||unistr('\000a')||
'   p_dynamic_action IN APEX_PLUGIN.T_DYNAMIC_ACTION,'||unistr('\000a')||
'   p_plugin         IN APEX_PLUGIN.T_PLUGIN'||unistr('\000a')||
')'||unistr('\000a')||
''||unistr('\000a')||
'    RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT'||unistr('\000a')||
''||unistr('\000a')||
'IS'||unistr('\000a')||
''||unistr('\000a')||
'   l_retval                   APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;'||unistr('\000a')||
'   l_ajax_function            VARCHAR2(32767) := apex_application.g_x01;'||unistr('\000a')||
''||
'   l_source                   VARCHAR2(20) := NVL(p_dynamic_action.attribute_02, ''COLLECTION'');'||unistr('\000a')||
'   l_render_collection_name   VARCHAR2(255) := p_dynamic_action.attribute_03;'||unistr('\000a')||
'   l_query                    VARCHAR2(32767) := p_dynamic_action.attribute_04;'||unistr('\000a')||
'   l_submit_collection_name   VARCHAR2(255) := p_dynamic_action.attribute_05;'||unistr('\000a')||
'   l_column_value_list        APEX_PLUGIN_UTIL.T_COLUMN_VALUE_LIST2;'||
''||unistr('\000a')||
'   l_clob_text                CLOB := EMPTY_CLOB();'||unistr('\000a')||
'   l_token                    VARCHAR2(32000);'||unistr('\000a')||
'   l_chunk_size               NUMBER := 4000;'||unistr('\000a')||
''||unistr('\000a')||
'BEGIN'||unistr('\000a')||
''||unistr('\000a')||
'   IF l_ajax_function = ''RENDER_CLOB'''||unistr('\000a')||
'   THEN'||unistr('\000a')||
'      IF l_source = ''COLLECTION'''||unistr('\000a')||
'      THEN'||unistr('\000a')||
'         IF apex_collection.collection_exists(l_render_collection_name)'||unistr('\000a')||
'         THEN'||unistr('\000a')||
'            SELECT clob001'||unistr('\000a')||
'            INTO l_clob_text'||unistr('\000a')||
'            FR'||
'OM apex_collections'||unistr('\000a')||
'            WHERE collection_name = l_render_collection_name'||unistr('\000a')||
'               AND seq_id = 1;'||unistr('\000a')||
'         END IF;'||unistr('\000a')||
'      ELSE --must be SQL_QUERY'||unistr('\000a')||
'         BEGIN'||unistr('\000a')||
''||unistr('\000a')||
'            l_column_value_list := apex_plugin_util.get_data2('||unistr('\000a')||
'               p_sql_statement  => l_query,'||unistr('\000a')||
'               p_min_columns    => 1,'||unistr('\000a')||
'               p_max_columns    => 1,'||unistr('\000a')||
'               p_component_name => p_dyna'||
'mic_action.action,'||unistr('\000a')||
'               p_first_row      => 1,'||unistr('\000a')||
'               p_max_rows       => 1'||unistr('\000a')||
'            );'||unistr('\000a')||
''||unistr('\000a')||
'         EXCEPTION'||unistr('\000a')||
''||unistr('\000a')||
'            WHEN NO_DATA_FOUND'||unistr('\000a')||
'            THEN'||unistr('\000a')||
'               NULL;'||unistr('\000a')||
''||unistr('\000a')||
'         END;'||unistr('\000a')||
''||unistr('\000a')||
'         IF l_column_value_list.exists(1)'||unistr('\000a')||
'            AND l_column_value_list(1).value_list.exists(1)'||unistr('\000a')||
'         THEN'||unistr('\000a')||
'            l_clob_text := l_column_value_list(1).value_list(1).clob_'||
'value;'||unistr('\000a')||
'         END IF;'||unistr('\000a')||
'      END IF;'||unistr('\000a')||
''||unistr('\000a')||
'      FOR i IN 0 .. FLOOR(LENGTH(l_clob_text)/l_chunk_size)'||unistr('\000a')||
'      LOOP'||unistr('\000a')||
'         sys.htp.prn(substr(l_clob_text, i * l_chunk_size + 1, l_chunk_size));'||unistr('\000a')||
'      END LOOP;'||unistr('\000a')||
'   ELSE --must be SUBMIT_CLOB'||unistr('\000a')||
'      dbms_lob.createtemporary(l_clob_text, false, dbms_lob.session);'||unistr('\000a')||
''||unistr('\000a')||
'      FOR i IN 1..apex_application.g_f01.count'||unistr('\000a')||
'      LOOP'||unistr('\000a')||
'         l_token := wwv_flow.g_f01(i'||
');'||unistr('\000a')||
''||unistr('\000a')||
'         IF length(l_token) > 0'||unistr('\000a')||
'         THEN'||unistr('\000a')||
'            dbms_lob.writeappend(l_clob_text, length(l_token), l_token);'||unistr('\000a')||
'         END IF;'||unistr('\000a')||
'      END LOOP;'||unistr('\000a')||
''||unistr('\000a')||
'      apex_collection.create_or_truncate_collection('||unistr('\000a')||
'         p_collection_name => l_submit_collection_name'||unistr('\000a')||
'      );'||unistr('\000a')||
''||unistr('\000a')||
'      apex_collection.add_member('||unistr('\000a')||
'         p_collection_name => l_submit_collection_name,'||unistr('\000a')||
'         p_clob001         => l_clo'||
'b_text'||unistr('\000a')||
'      );'||unistr('\000a')||
'   END IF;'||unistr('\000a')||
''||unistr('\000a')||
'   RETURN l_retval;'||unistr('\000a')||
''||unistr('\000a')||
'END enkitec_clob_load_ajax;'
 ,p_render_function => 'enkitec_clob_load_render'
 ,p_ajax_function => 'enkitec_clob_load_ajax'
 ,p_standard_attributes => 'ITEM:JQUERY_SELECTOR:REQUIRED'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64726880902654597 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Show Modal Dialog While Loading'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'Y'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64727777008672426 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Dialog Title'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'Please wait...'
 ,p_display_length => 50
 ,p_max_length => 500
 ,p_is_translatable => true
 ,p_depending_on_attribute_id => 64726880902654597 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64728279910682712 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Loading Image Type'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'DEFAULT'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64726880902654597 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 64728784065683916 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 64728279910682712 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Default'
 ,p_return_value => 'DEFAULT'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 64729179695692086 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 64728279910682712 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Custom'
 ,p_return_value => 'CUSTOM'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64731395933744135 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Loading Image'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_display_length => 50
 ,p_max_length => 500
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64728279910682712 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'CUSTOM'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'CLOB Action'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => false
 ,p_default_value => 'RENDER'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 64737302944077269 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Render'
 ,p_return_value => 'RENDER'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 64737705368077944 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Submit'
 ,p_return_value => 'SUBMIT'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64753601045565471 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Source'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'SQL_QUERY'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'RENDER'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 64754103816566302 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 64753601045565471 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Collection'
 ,p_return_value => 'COLLECTION'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 64754508664567617 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 64753601045565471 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'SQL Query'
 ,p_return_value => 'SQL_QUERY'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64724205659923743 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Collection Name'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_display_length => 50
 ,p_max_length => 255
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64753601045565471 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'COLLECTION'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64756080753644788 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'SQL Query'
 ,p_attribute_type => 'SQL'
 ,p_is_required => true
 ,p_sql_min_column_count => 1
 ,p_sql_max_column_count => 1
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64753601045565471 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'SQL_QUERY'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64756597375649523 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Collection Name'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_display_length => 50
 ,p_max_length => 255
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'SUBMIT'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64726382718636188 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Submit Only When Value Changed'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'Y'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'SUBMIT'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 64783183343058476 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Make Synchronous (Blocking) '
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'Y'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 64736800520076562 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'SUBMIT'
  );
wwv_flow_api.create_plugin_event (
  p_id => 64784486038153907 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_name => 'enkitecclobloadrendercomplete'
 ,p_display_name => 'CLOB(s) Render Complete'
  );
wwv_flow_api.create_plugin_event (
  p_id => 64784179112151921 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_name => 'enkitecclobloadsubmitcomplete'
 ,p_display_name => 'CLOB(s) Submit Complete'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '766172207175657279537472696E673D22223B66756E6374696F6E20616464506172616D28612C62297B6966287175657279537472696E673D3D3D2222297B7175657279537472696E673D612B223D222B282862213D6E756C6C293F656E636F64655552';
wwv_flow_api.g_varchar2_table(2) := '49436F6D706F6E656E742862293A2222297D656C73657B7175657279537472696E673D7175657279537472696E672B2226222B612B223D222B282862213D6E756C6C293F656E636F6465555249436F6D706F6E656E742862293A2222297D7D66756E6374';
wwv_flow_api.g_varchar2_table(3) := '696F6E206368756E6B436C6F6228642C63297B76617220613D4D6174682E666C6F6F7228642E6C656E6774682F63292B313B666F722876617220623D303B623C613B622B2B297B616464506172616D2822663031222C642E736C69636528632A622C632A';
wwv_flow_api.g_varchar2_table(4) := '28622B312929297D7D66756E6374696F6E20242861297B696628747970656F6620613D3D22737472696E6722297B613D646F63756D656E742E676574456C656D656E74427949642861297D72657475726E20617D66756E6374696F6E20636F6C6C656374';
wwv_flow_api.g_varchar2_table(5) := '28622C65297B76617220673D5B5D3B666F722876617220643D303B643C622E6C656E6774683B642B2B297B76617220633D6528625B645D293B69662863213D6E756C6C297B672E707573682863297D7D72657475726E20677D616A61783D7B7D3B616A61';
wwv_flow_api.g_varchar2_table(6) := '782E783D66756E6374696F6E28297B7472797B72657475726E206E657720416374697665584F626A65637428224D73786D6C322E584D4C4854545022297D63617463682861297B7472797B72657475726E206E657720416374697665584F626A65637428';
wwv_flow_api.g_varchar2_table(7) := '224D6963726F736F66742E584D4C4854545022297D63617463682861297B72657475726E206E657720584D4C487474705265717565737428297D7D7D3B616A61782E73657269616C697A653D66756E6374696F6E2868297B76617220653D66756E637469';
wwv_flow_api.g_varchar2_table(8) := '6F6E2866297B72657475726E20682E676574456C656D656E747342795461674E616D652866297D3B76617220613D66756E6374696F6E2866297B696628662E6E616D65297B72657475726E20656E636F6465555249436F6D706F6E656E7428662E6E616D';
wwv_flow_api.g_varchar2_table(9) := '65292B223D222B656E636F6465555249436F6D706F6E656E7428662E76616C7565297D656C73657B72657475726E22227D7D3B76617220633D636F6C6C65637428652822696E70757422292C66756E6374696F6E2866297B69662828662E74797065213D';
wwv_flow_api.g_varchar2_table(10) := '22726164696F222626662E74797065213D22636865636B626F7822297C7C662E636865636B6564297B72657475726E20612866297D7D293B76617220643D636F6C6C6563742865282273656C65637422292C61293B76617220623D636F6C6C6563742865';
wwv_flow_api.g_varchar2_table(11) := '2822746578746172656122292C61293B72657475726E20632E636F6E6361742864292E636F6E6361742862292E6A6F696E28222622297D3B616A61782E73656E643D66756E6374696F6E28652C672C632C64297B76617220623D616A61782E7828293B62';
wwv_flow_api.g_varchar2_table(12) := '2E6F70656E28632C652C74727565293B622E6F6E726561647973746174656368616E67653D66756E6374696F6E28297B696628622E726561647953746174653D3D34297B6728622E726573706F6E736554657874297D7D3B696628633D3D22504F535422';
wwv_flow_api.g_varchar2_table(13) := '297B622E736574526571756573744865616465722822436F6E74656E742D74797065222C226170706C69636174696F6E2F782D7777772D666F726D2D75726C656E636F64656422297D622E73656E642864297D3B616A61782E6765743D66756E6374696F';
wwv_flow_api.g_varchar2_table(14) := '6E28612C62297B616A61782E73656E6428612C622C2247455422297D3B616A61782E676574733D66756E6374696F6E2862297B76617220613D616A61782E7828293B612E6F70656E2822474554222C622C66616C7365293B612E73656E64286E756C6C29';
wwv_flow_api.g_varchar2_table(15) := '3B72657475726E20612E726573706F6E7365546578747D3B616A61782E706F73743D66756E6374696F6E28622C632C61297B616A61782E73656E6428622C632C22504F5354222C61297D3B616A61782E7570646174653D66756E6374696F6E28612C6429';
wwv_flow_api.g_varchar2_table(16) := '7B76617220633D242864293B76617220623D66756E6374696F6E2865297B632E696E6E657248544D4C3D657D3B616A61782E67657428612C62297D3B616A61782E7375626D69743D66756E6374696F6E28612C672C63297B76617220643D242867293B76';
wwv_flow_api.g_varchar2_table(17) := '617220623D66756E6374696F6E2865297B642E696E6E657248544D4C3D657D3B616A61782E706F737428612C622C616A61782E73657269616C697A65286329297D3B6164644576656E744C697374656E657228226D657373616765222C66756E6374696F';
wwv_flow_api.g_varchar2_table(18) := '6E2862297B76617220633D746869732C613D622E646174613B696628612E7830313D3D3D225355424D49545F434C4F4222297B616464506172616D2822705F666C6F775F6964222C612E705F666C6F775F6964293B616464506172616D2822705F666C6F';
wwv_flow_api.g_varchar2_table(19) := '775F737465705F6964222C612E705F666C6F775F737465705F6964293B616464506172616D2822705F696E7374616E6365222C612E705F696E7374616E6365293B616464506172616D2822705F72657175657374222C612E705F72657175657374293B61';
wwv_flow_api.g_varchar2_table(20) := '6464506172616D2822783031222C612E783031293B6368756E6B436C6F6228612E636C6F62446174612C3330303030293B616A61782E706F737428227777765F666C6F772E73686F77222C66756E6374696F6E2864297B632E706F73744D657373616765';
wwv_flow_api.g_varchar2_table(21) := '28227375636365737322297D2C7175657279537472696E67297D656C73657B616464506172616D2822705F666C6F775F6964222C612E705F666C6F775F6964293B616464506172616D2822705F666C6F775F737465705F6964222C612E705F666C6F775F';
wwv_flow_api.g_varchar2_table(22) := '737465705F6964293B616464506172616D2822705F696E7374616E6365222C612E705F696E7374616E6365293B616464506172616D2822705F72657175657374222C612E705F72657175657374293B616464506172616D2822783031222C612E78303129';
wwv_flow_api.g_varchar2_table(23) := '3B616A61782E706F737428227777765F666C6F772E73686F77222C66756E6374696F6E2865297B76617220643D7B7D3B642E636C6F623D653B632E706F73744D6573736167652864297D2C7175657279537472696E67297D7D2C66616C7365293B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 41646778405429289 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_file_name => 'enkitec-clob-load-worker.min.js'
 ,p_mime_type => 'text/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2866756E6374696F6E2861297B612E7769646765742822656E6B697465632E636C6F625F6C6F6164222C7B6F7074696F6E733A7B73686F774D6F64616C3A6E756C6C2C6469616C6F675469746C653A6E756C6C2C6C6F6164696E67496D6167655372633A';
wwv_flow_api.g_varchar2_table(2) := '6E756C6C2C616A61784964656E7469666965723A6E756C6C2C61706578546869733A6E756C6C2C706C7567696E46696C655072656669783A6E756C6C2C61706578496D6167655072656669783A6E756C6C7D2C5F6372656174653A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(3) := '297B76617220623D746869733B622E5F6372656174655072697661746553746F7261676528293B622E5F696E6974456C656D656E747328297D2C5F6372656174655072697661746553746F726167653A66756E6374696F6E28297B76617220623D746869';
wwv_flow_api.g_varchar2_table(4) := '733B622E5F76616C7565733D7B6469616C6F67436F756E74446174613A22636C6F625F6C6F61645F6469616C6F675F636F756E74227D3B622E5F656C656D656E74733D7B246469616C6F673A7B7D7D7D2C5F696E6974456C656D656E74733A66756E6374';
wwv_flow_api.g_varchar2_table(5) := '696F6E28297B76617220623D746869733B622E5F656C656D656E74732E246469616C6F673D6128226469762E636C6F622D6C6F61642D636F6E7461696E657222297D2C5F73686F774469616C6F673A66756E6374696F6E28297B76617220623D74686973';
wwv_flow_api.g_varchar2_table(6) := '2C633B633D273C64697620636C6173733D22636C6F622D6C6F61642D636F6E7461696E65722075692D776964676574223E2020203C696D67207372633D22272B622E6F7074696F6E732E6C6F6164696E67496D6167655372632B27222F3E3C2F6469763E';
wwv_flow_api.g_varchar2_table(7) := '273B612822626F647922292E617070656E642863293B622E5F696E6974456C656D656E747328293B622E5F656C656D656E74732E246469616C6F672E6469616C6F67287B64697361626C65643A66616C73652C6175746F4F70656E3A747275652C636C6F';
wwv_flow_api.g_varchar2_table(8) := '73654F6E4573636170653A66616C73652C6469616C6F67436C6173733A22636C6F622D6C6F61642D6469616C6F67222C647261676761626C653A747275652C6865696768743A226175746F222C686964653A6E756C6C2C6D6178684865696768743A6661';
wwv_flow_api.g_varchar2_table(9) := '6C73652C6D617857696474683A66616C73652C6D696E4865696768743A3130302C6D696E57696474683A66616C73652C6D6F64616C3A747275652C726573697A61626C653A66616C73652C73686F773A6E756C6C2C737461636B3A747275652C7469746C';
wwv_flow_api.g_varchar2_table(10) := '653A622E6F7074696F6E732E6469616C6F675469746C652C636C6F73653A66756E6374696F6E28297B612874686973292E6469616C6F67282264657374726F7922293B622E5F656C656D656E74732E246469616C6F672E72656D6F766528297D7D293B62';
wwv_flow_api.g_varchar2_table(11) := '2E5F696E6974456C656D656E747328297D2C72656E646572436C6F623A66756E6374696F6E2862297B76617220633D746869732C652C643B696628632E6F7074696F6E732E73686F774D6F64616C3D3D3D225922297B632E5F696E634469616C6F67436F';
wwv_flow_api.g_varchar2_table(12) := '756E7428293B696628632E5F6765744469616C6F67436F756E7428293D3D3D31297B632E5F73686F774469616C6F6728297D7D69662877696E646F772E576F726B6572297B643D6E657720576F726B657228632E6F7074696F6E732E706C7567696E4669';
wwv_flow_api.g_varchar2_table(13) := '6C655072656669782B22656E6B697465632D636C6F622D6C6F61642D776F726B65722E6D696E2E6A7322293B642E6164644576656E744C697374656E657228226D657373616765222C66756E6374696F6E2866297B632E5F68616E646C65436C6F625265';
wwv_flow_api.g_varchar2_table(14) := '6E6465725375636365737328662E646174612E636C6F622C622E24656C6D745B305D297D2C66616C7365293B642E706F73744D657373616765287B705F666C6F775F69643A6128222370466C6F77496422292E76616C28292C705F666C6F775F73746570';
wwv_flow_api.g_varchar2_table(15) := '5F69643A6128222370466C6F7753746570496422292E76616C28292C705F696E7374616E63653A6128222370496E7374616E636522292E76616C28292C705F726571756573743A22504C5547494E3D222B622E616A61784964656E7469666965722C7830';
wwv_flow_api.g_varchar2_table(16) := '313A2252454E4445525F434C4F42227D297D656C73657B653D7B705F666C6F775F69643A6128222370466C6F77496422292E76616C28292C705F666C6F775F737465705F69643A6128222370466C6F7753746570496422292E76616C28292C705F696E73';
wwv_flow_api.g_varchar2_table(17) := '74616E63653A6128222370496E7374616E636522292E76616C28292C705F726571756573743A22504C5547494E3D222B622E616A61784964656E7469666965722C7830313A2252454E4445525F434C4F42227D3B612E616A6178287B747970653A22504F';
wwv_flow_api.g_varchar2_table(18) := '5354222C75726C3A227777765F666C6F772E73686F77222C646174613A652C64617465547970653A2274657874222C6173796E633A747275652C636F6E746578743A746869732C737563636573733A66756E6374696F6E2866297B632E5F68616E646C65';
wwv_flow_api.g_varchar2_table(19) := '436C6F6252656E6465725375636365737328662C622E24656C6D745B305D297D7D297D7D2C5F68616E646C65436C6F6252656E646572537563636573733A66756E6374696F6E28642C62297B76617220633D746869733B247328622C64293B612E646174';
wwv_flow_api.g_varchar2_table(20) := '6128622C2264656661756C7456616C7565222C64293B696628632E6F7074696F6E732E73686F774D6F64616C3D3D3D225922297B632E5F6465634469616C6F67436F756E7428297D696628632E5F6765744469616C6F67436F756E7428293D3D3D30297B';
wwv_flow_api.g_varchar2_table(21) := '69662821612E6973456D7074794F626A65637428632E5F656C656D656E74732E246469616C6F6729297B632E5F656C656D656E74732E246469616C6F672E6469616C6F672822636C6F736522297D6128646F63756D656E74292E74726967676572282265';
wwv_flow_api.g_varchar2_table(22) := '6E6B69746563636C6F626C6F616472656E646572636F6D706C65746522297D7D2C7375626D6974436C6F623A66756E6374696F6E2865297B76617220663D746869732C642C632C622C682C673B643D652E24656C6D745B305D3B633D24762864293B623D';
wwv_flow_api.g_varchar2_table(23) := '612E6461746128642C2264656661756C7456616C756522293B247328642C2222293B696628652E6368616E67654F6E6C793D3D3D224E227C7C63213D3D62297B696628662E6F7074696F6E732E73686F774D6F64616C3D3D3D225922297B662E5F696E63';
wwv_flow_api.g_varchar2_table(24) := '4469616C6F67436F756E7428293B696628662E5F6765744469616C6F67436F756E7428293D3D3D31297B662E5F73686F774469616C6F6728297D7D696628652E6D616B65426C6F636B696E673D3D3D225922297B683D7B705F666C6F775F69643A612822';
wwv_flow_api.g_varchar2_table(25) := '2370466C6F77496422292E76616C28292C705F666C6F775F737465705F69643A6128222370466C6F7753746570496422292E76616C28292C705F696E7374616E63653A6128222370496E7374616E636522292E76616C28292C705F726571756573743A22';
wwv_flow_api.g_varchar2_table(26) := '504C5547494E3D222B652E616A61784964656E7469666965722C7830313A225355424D49545F434C4F42222C6630313A5B5D7D3B683D662E5F6368756E6B436C6F6228632C33303030302C68293B612E616A6178287B747970653A22504F5354222C7572';
wwv_flow_api.g_varchar2_table(27) := '6C3A227777765F666C6F772E73686F77222C646174613A682C64617465547970653A2274657874222C6173796E633A66616C73652C636F6E746578743A746869732C737563636573733A66756E6374696F6E2869297B662E5F68616E646C655375626D69';
wwv_flow_api.g_varchar2_table(28) := '74436C6F625375636365737328297D7D297D656C73657B69662877696E646F772E576F726B6572297B673D6E657720576F726B657228662E6F7074696F6E732E706C7567696E46696C655072656669782B22656E6B697465632D636C6F622D6C6F61642D';
wwv_flow_api.g_varchar2_table(29) := '776F726B65722E6D696E2E6A7322293B672E6164644576656E744C697374656E657228226D657373616765222C66756E6374696F6E2869297B662E5F68616E646C655375626D6974436C6F625375636365737328297D2C66616C7365293B672E706F7374';
wwv_flow_api.g_varchar2_table(30) := '4D657373616765287B705F666C6F775F69643A6128222370466C6F77496422292E76616C28292C705F666C6F775F737465705F69643A6128222370466C6F7753746570496422292E76616C28292C705F696E7374616E63653A6128222370496E7374616E';
wwv_flow_api.g_varchar2_table(31) := '636522292E76616C28292C705F726571756573743A22504C5547494E3D222B652E616A61784964656E7469666965722C7830313A225355424D49545F434C4F42222C636C6F62446174613A637D297D656C73657B683D7B705F666C6F775F69643A612822';
wwv_flow_api.g_varchar2_table(32) := '2370466C6F77496422292E76616C28292C705F666C6F775F737465705F69643A6128222370466C6F7753746570496422292E76616C28292C705F696E7374616E63653A6128222370496E7374616E636522292E76616C28292C705F726571756573743A22';
wwv_flow_api.g_varchar2_table(33) := '504C5547494E3D222B652E616A61784964656E7469666965722C7830313A225355424D49545F434C4F42222C6630313A5B5D7D3B683D662E5F6368756E6B436C6F6228632C33303030302C68293B612E616A6178287B747970653A22504F5354222C7572';
wwv_flow_api.g_varchar2_table(34) := '6C3A227777765F666C6F772E73686F77222C646174613A682C64617465547970653A2274657874222C6173796E633A747275652C636F6E746578743A746869732C737563636573733A66756E6374696F6E2869297B662E5F68616E646C655375626D6974';
wwv_flow_api.g_varchar2_table(35) := '436C6F625375636365737328297D7D297D7D7D7D2C5F68616E646C655375626D6974436C6F62537563636573733A66756E6374696F6E28297B76617220623D746869733B696628622E6F7074696F6E732E73686F774D6F64616C3D3D3D225922297B622E';
wwv_flow_api.g_varchar2_table(36) := '5F6465634469616C6F67436F756E7428297D696628622E5F6765744469616C6F67436F756E7428293D3D3D30297B69662821612E6973456D7074794F626A65637428622E5F656C656D656E74732E246469616C6F6729297B622E5F656C656D656E74732E';
wwv_flow_api.g_varchar2_table(37) := '246469616C6F672E6469616C6F672822636C6F736522297D6128646F63756D656E74292E747269676765722822656E6B69746563636C6F626C6F61647375626D6974636F6D706C65746522297D7D2C5F696E634469616C6F67436F756E743A66756E6374';
wwv_flow_api.g_varchar2_table(38) := '696F6E28297B76617220633D746869732C623D632E5F6765744469616C6F67436F756E7428293B696628623D3D3D756E646566696E65647C7C623C30297B623D313B632E5F7365744469616C6F67436F756E742862297D656C73657B622B2B3B632E5F73';
wwv_flow_api.g_varchar2_table(39) := '65744469616C6F67436F756E742862297D7D2C5F6465634469616C6F67436F756E743A66756E6374696F6E28297B76617220633D746869732C623D632E5F6765744469616C6F67436F756E7428293B696628623E3D30297B622D2D3B632E5F7365744469';
wwv_flow_api.g_varchar2_table(40) := '616C6F67436F756E742862297D7D2C5F6765744469616C6F67436F756E743A66756E6374696F6E28297B76617220633D746869732C623D612E6461746128646F63756D656E742C632E5F76616C7565732E6469616C6F67436F756E7444617461293B7265';
wwv_flow_api.g_varchar2_table(41) := '7475726E28623D3D3D756E646566696E65647C7C623C30293F303A627D2C5F7365744469616C6F67436F756E743A66756E6374696F6E2863297B76617220623D746869733B612E6461746128646F63756D656E742C622E5F76616C7565732E6469616C6F';
wwv_flow_api.g_varchar2_table(42) := '67436F756E74446174612C63297D2C5F6368756E6B436C6F623A66756E6374696F6E28672C642C66297B76617220653D746869732C623D4D6174682E666C6F6F7228672E6C656E6774682F64292B313B666F722876617220633D303B633C623B632B2B29';
wwv_flow_api.g_varchar2_table(43) := '7B662E6630312E7075736828672E736C69636528642A632C642A28632B312929297D72657475726E20667D7D297D2928617065782E6A5175657279293B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 41647475602430550 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_file_name => 'enkitec-clob-load.min.js'
 ,p_mime_type => 'text/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '47494638396180000F00F20000FFFFFF000000C6C6C6B2B2B242424200000000000000000021FF0B4E45545343415045322E30030100000021FE1A43726561746564207769746820616A61786C6F61642E696E666F0021F904090A0000002C0000000080';
wwv_flow_api.g_varchar2_table(2) := '000F000003E708B20BFEAC3D17C5A4F1AA7CABF61D3781A3089918B391AB5949A9FB96EC6B9DF58CCBB9DDF340D54E1823B68C365A107664FA744527B4798B56A94AE4343994FE9E57AE35EB5D86B7E86F590B5EBBCF6AB8992C67CFBB3EBA1EBF1FF3FF';
wwv_flow_api.g_varchar2_table(3) := '7E81587862838285886977878A760C039091031392919495930F98990E9B97959F92A1969A98A390A79C009B9EA5A0AEA2B0A49DA6B2A8B6AAADB4AFBBB1BDB3ABACBCC1C3BAC4BEC7C0C6CBB5BFB7CEB9CDC9C2A9D5B8D6D0D8D3D1C5D2CCC2CADEE2DD';
wwv_flow_api.g_varchar2_table(4) := 'E4C8DFE6E3E8E5E0DAE7E1EBCFDBEDE9EFEAA2C3BF1AF8C9FAC8F917FB02FAE3077020A8040021F904090A0000002C0000000080000F000003FF08B40BFE22C607A5A0CE5EAC31E89CE581145949A318A24C5B6A5B06BF261C7FF3A9CA75CEEFB89EA6C5';
wwv_flow_api.g_varchar2_table(5) := 'A0016D46944EF963068FBEA713B99C5405C4C635696D76A55FAAF7260693A3655B96C03D0BA1EF297A1E0FD32DEBB67ECB1FEFFD7D667F667981697772756E708C898D11858092828688768A83871A059C9D051403A1A203A0A3A1A5A6A8A3AAA2ACA70F';
wwv_flow_api.g_varchar2_table(6) := 'A6AF0EB1A4B0B1AEB5B3B19E9DB8BEB6A9C0ABC2ADC4B200B4BFBAC1CBC3CDA2BC9CCAC8B7C6B9D4CCD8CEDAC5CFC7C9D6D3B4D19FE1E6DED7E0E8E2D5EBE7DCDFBBD1ECD9EAF0E9EDF7F4DBF6FDF2BCFBBAE97BE7AF5EBE82FC0EDE028821DB330F0EB9';
wwv_flow_api.g_varchar2_table(7) := '41DCF6B021458916055664052001010021F904090A0000002C0000000080000F000003FF08B40BFEAC3D276A9DD40A0CF4C61E17829A58929699A257C44CAE948DF359AFF7F5787AFEF913DEAFC30BF2620458CC482336854C9B530ADD15ADCFAB0FA974';
wwv_flow_api.g_varchar2_table(8) := '457153701588A56AC33DF470ACE6429665F1994D9FDBB378B3C7EDE0ABBF697579728381777A1A7E7E8288848D86856B878E168A7064987F71908F9291809E1A05A3A40513A5A41303ABAC03AAADABAFB0B2ADB4ACB6B10FB0B90EBBAEBABBB803A8A3A7';
wwv_flow_api.g_varchar2_table(9) := 'C4C2C8C0B3CAB5CCB7CEBC00BEC9BDC1D0C3C70FC4A6D7D4D2D6D5CBE1CDE3CFE5D1D3DDD7DBC6A8DEE9E7BFF1EFE0DFE2F6E4F8E6FAABECDAD9F3D4051CC84F5E417AF7E015F4E780E141810F092A9C588F62C260EE3064B4C5E10F5EB98EF93E62F0A8';
wwv_flow_api.g_varchar2_table(10) := '0FE43E911C13000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C97422E70BF4BE9EC085A3576AE73791A05949D43BBDD613AADDBDEA368FF939D64F1834F542B4990CB21C1A9DA8E3B31885E26E2269957ABD2599156558DB2562';
wwv_flow_api.g_varchar2_table(11) := '7766E0999CB5B6B9826F6C3C8FA0A76BF77D9B87EFCB785E4D0A83727E6C7F6F7D8B6A8D6948859174877A88969598949A58869D838C8F81A17C8EA2A61A05A9AA0513ABAAADAEAC0F03B4B50313B6B5B8B9B7B3BCBBB9C0B6C2BABEC1C6B6B1B20ECAB0';
wwv_flow_api.g_varchar2_table(12) := 'AEC4B4D0BD0EBCD300D5D2D9C8C5D4BFDBB4CD0FE1CCB1DADDC7E7C3DFD6D8EBE6D7DEE9B5E300F4F4EDF2D1EEFBF9ECF1F0E800AAEB67AF9C3883FDDEE113C88DA1BE84FC1CFACB55F0D9418B10334A54F86F1AA1C78EBF305E4CC541A43C0E014F5E48';
wwv_flow_api.g_varchar2_table(13) := 'C910E5C06D2E1B9E4C000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F102C1B9EEDE050A1F587667388D2959495835BD16F4AE23F9E4BAC3E3AC5D0E6812067D39DAEC66933533C622F2B8194651575595FACB0A944FC6D2';
wwv_flow_api.g_varchar2_table(14) := '19834EA55B74F78C656BD7E9769C032E8BC33005D3DD9BF7E180567C44723C757A6488668A77835E846F827E907F92867B8C798787815C969F9EA16A49989BA5989DA3A285A0AAAE1D05B1B20513B3B2B5B6B40FB9BA0E03BFC00313C1C0C3C4C20FC7C8';
wwv_flow_api.g_varchar2_table(15) := 'BEC7C6C4CEC1D0C0BCB8B6D5B3D7B7C9CDDBCFDDD1DFC5E1BFD2E4E3CB00CAD4BBB9D9B1EEBDE9DCCCDEF4E0F6E2F8E6FAE8CAE503EB1C04043070A0BF73FF12225CC8EF5FC176ECAC45C4C6505E3D8BF730E6D3B88F2B63BF791E1F4A140891E4488F0A';
wwv_flow_api.g_varchar2_table(16) := '1B563CA8B225CA9326DF5D804990A2340D17F1E1CCA8F3424E8D3B8B25000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7C85F7DA07766258929F99A2602561D5E45A902BDB8FB83AFAC8F7939E2008CC157FBAD92D56';
wwv_flow_api.g_varchar2_table(17) := '63C2384F0651373D21AD006175973D7693B8E86BE32443CD5223558DD5B2B9EE2BBCA76C9EEB625A7EEBFBB6BD717E736B721E786863878A61827D818F8091848D028B6596778C90939B7F9C922298697B76A3887A947C436F8EA0839E2205B2B30513B4';
wwv_flow_api.g_varchar2_table(18) := 'B3B6B7B50FBABB0EBD1303C2C303C1C4C2C6C7C9C4CBC3CDC80FC7C2C0BCBAB9B7D7B4D9B8D1D2CFC5DDCAE1CCE3CEE5D00ED203D4BFD6D5D8EFDAF1DCE9DEE7E0F5E2F9E4FBE6FDE800D4B10330B0A0BB76F0FEE10B684FE1B787F7BE194C48F060458A';
wwv_flow_api.g_varchar2_table(19) := '03D5417418B12D23478513E52114799164C6860CF5A5E4B7D25F4B801A23521CE96B9E8699256BF6D3A072E7859E2D79B2DC99000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CAB1620F885C2189AE245962AB97950';
wwv_flow_api.g_varchar2_table(20) := '65C53056BF9C9D036BEAF4AC5F6F02240E1F40D94CC798289D32E8ED893C0A57466C557B756D4954A644BCC43569BB30CFBAE6B6BDDDD3571E07A9EF51F4992CDD15E73E6F7482817F75027853797C7A63668E8684419259709480888B8F6589699A6A91';
wwv_flow_api.g_varchar2_table(21) := 'A16CA26E499FA78AA99E37A496AD83AF2005B3B40513B5B4B7B8B60FBBBC0EBEBAB81303C5C603C4C7C5C9CACCC7CEC6D0C5C1BDBBC2B5D7B9D5C3DBD80FCACBDFE0D2C8E2CDE6CFE8C6D4C0D6DDDAEDDCF1DEF3F000E0E50EF8E4FCEAE1FAE0D8011048';
wwv_flow_api.g_varchar2_table(22) := 'D05DBD59D910FACB776FDCC27E00CF453C5650DE4083172D56A4D7503362C77413A33D1C19721AC68DF6502A3CF8EBA3C8920CF79174F98F26328BF534E0CCB8F29D4E8E2135780C7A61A84BA1CF12000021F904090A0000002C0000000080000F000003';
wwv_flow_api.g_varchar2_table(23) := 'FF08B40BFEAC3D17C9A4F1AA7CABF697208ADA48866699A2E30662AFCBC1B3CC4C9544DF8FD9F63EC1242804FA86C19C0592C3359931A533FA74109147E3CA1AC49AA4D01A78A7B395C7E62537BBDE02AEDA5F7B84AE57D353F11D0D9F9FFC45805E747B';
wwv_flow_api.g_varchar2_table(24) := '8554877A883C82717F6F5D8D818F3E768A678689998B936E7D9C729F8E44959A97966A78619B9EAC908C8005B1B20513B3B2B5B6B40FB9BA0EBCB8B6C0B31303C5C603C4C7C5C9CACCC7CEC6BFBBB9C2B7D3C1D7C3D9D6BED40FCACBDFE0D0E10EE0C8E2';
wwv_flow_api.g_varchar2_table(25) := 'CAD2DDD8ECDAEEDC00EBF2DEF0B1E4E8E6E3E9CFFCC6F8F302D6A3D78EE03B83F1E69DC3C7D05F3900E7041694789062C2810B1DE683B84F2E5F338D16EF6D1369AF174292274D2AECC8F1A3C77E2FFF6944A8A120BC9A076F5EB049F3824B7F1A7EC60C';
wwv_flow_api.g_varchar2_table(26) := 'FA2C010021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D370924A995E6850A27BA8118FC8A333355524CE316848F2BD623287410812BDEEDE793299B3BA6CE06A51A8348D710BB4D4A6B39706F1A7E92C7E2A5EC';
wwv_flow_api.g_varchar2_table(27) := 'D8D55E57D992395D2D7FE7F8FB97FD7603F87F41794E7A848651875681706D2571297D728588948A8395766B5C91908B7E44979693A28999986880A99B9E2505AEAF0513B0AFB2B3B10FB6B70EB9B5B3BDB0BFB40F03C4C50313C6C5C8C9C7C3CCBCB8B6';
wwv_flow_api.g_varchar2_table(28) := 'C1AED3BA00D0BBD2D1BEDBC0CEC9CBE0DFC6E1C6D8D7DAD9DCEADEECC2EED4DDEFE8EB00CCCD0EF7E5CAE3C5E7FFE9E8B513380F60BD73FAFA11DBB750E100830321160C28311E3C6B09F3316388CF27DE338A200F868C387262BD8C1EC5695499925C3D';
wwv_flow_api.g_varchar2_table(29) := '771A5E128C3910E605993259AE6CB84F03B8040021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D378193609ADA895EAAB091AF1833636541760DDB37B6E78FD6CA217405853C9D2C89FB3997401F14562C09AD2D';
wwv_flow_api.g_varchar2_table(30) := 'A694D69C7AB95B49B8371397C9D5630BABD29E95E07737EEAE47E5C4AB5AC53ED99F74777F5F66837169796B7B7E828D80858E8464866688009645949391818F9B9E70957A897C8B2605A8A90513AAA9ACADAB0FB0B10EB3AFADB7AAB9AEB2B01303C0C1';
wwv_flow_api.g_varchar2_table(31) := '03BFC2C0C4C5B6BDB8CABACCBCB5BECEA8BBD3D2B400C90EC5C60FDBC3DDDBD9D8D1D0CBE5CDE7CFE3E6EBE8EDEAE2DEC7C2F3C1E2F7E4EFD5E9FBFAD7F8ECE26DABC74D5BB87C00DD258487B061C07CF2C015233860613F8BFF1C2AD4C8901B5D448313';
wwv_flow_api.g_varchar2_table(32) := '25D263974E03C97726DD95BC70B2A54A0021EB699898000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D3781A3F80828AAA56A2561E416BB16E496F36DE7BCC9A6931F8A86331177461D2CD963149D48A84328';
wwv_flow_api.g_varchar2_table(33) := '080A8F4BA98CC9D562B75E25F835AE4D85D6DF772D6637C9EE2E5C4C4DB3E2E1B7B9FC9CEBFB7B5F7527576D867F517E7281878B7640846A8D798E898C88598A945A83673F05A0A10513A2A1A4A5A30FA8A90EABA7A5AFA2B1A6AAA8B3A01303BABB03B9';
wwv_flow_api.g_varchar2_table(34) := 'BCBAAEB5B0C2B2C4B4ADB6C6B8CAAC00C1C8C3D0C50EBFBABEBFCFCEC9D2C7DAD1DED3E0DDD9E4DBE2CBD4D5D7BCE5DFEDE1EFE3E6F1E8E7CDD5BD0FF8F4CDFCB7FDF302BA13180EDFBA5DFE98FD5BA8B021B77A09D3FD3A68ED1B370D16C5610C77F10C';
wwv_flow_api.g_varchar2_table(35) := '42C68F1C355E9838921780040021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D3781A308998EA0AA1BD99A9584B9B175D27189EF70FEACC09AAEC7630C8D37A212395BCA5E4C0070254C46ABCDAB2FFBC442BBDB';
wwv_flow_api.g_varchar2_table(36) := 'AF8D3B964E05DE74585D04B7CB6C67F98C5EDBDF47B73C0FBFEF7F67715A78567A837F647C8A805382868F7D8489859188621374059A9B05139C9B9E9F9D0FA2A30EA5A19FA99CABA0A4A2AD9AB1A60003B6B703A8AFAABBACBDAEA7B0BFB2C3B4BAC1BC';
wwv_flow_api.g_varchar2_table(37) := 'C8BECAC0B5B8B6C700D1D3C2CCC4D6C6D5D2DAD4C9DBDECFD0DCE3DEDDCBDFE7E6CDEAD7E8CDE1B9E4E9F2EBF4EDECD9E5F6B4F0F8B3FFC5006213E8EEDEBE09F0DC69F0C66CE1B98617182A8CF870622B87CD1C3C0390000021F904090A0000002C0000';
wwv_flow_api.g_varchar2_table(38) := '000080000F000003E708B40BFEAC3D17C9A4F1AA7CABF61D3781A3089918B391AB5949A9FB96EC6B9DF58CCBB9DDF340D54E1823B68C365A107664FA744527B4798B56A94AE4343994FE9E57AE35EB5D86B7E86F590B5EBBCF6AB8992C67CFBB3EBA1EBF';
wwv_flow_api.g_varchar2_table(39) := '1FF3FF7E81587862838285886977878A760C059091051392919495930F98990E9B97959F92A1969A98A390A79C009B9EA5A0AEA2B0A49DA6B2A8B6AAADB4AFBBB1BDB3ABACBCC1C3BAC4BEC7C0C6CBB5BFB7CEB9CDC9C2A9D5B8D6D0D8D3D1C5D2CCC2CA';
wwv_flow_api.g_varchar2_table(40) := 'DEE2DDE4C8DFE6E3E8E5E0DAE7E1EBCFDBEDE9EFEAA2C3BF1AF8C9FAC8F917FB02FAE3077020A804003B000000000000000000';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 64732403822772849 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 64721183440813267 + wwv_flow_api.g_id_offset
 ,p_file_name => 'enkitec-loading.gif'
 ,p_mime_type => 'image/gif'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

prompt  ...data loading
--
