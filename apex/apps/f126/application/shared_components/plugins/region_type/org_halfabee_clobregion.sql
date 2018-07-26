prompt --application/shared_components/plugins/region_type/org_halfabee_clobregion
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(34636878508938007391)
,p_plugin_type=>'REGION TYPE'
,p_name=>'ORG.HALFABEE.CLOBREGION'
,p_display_name=>'CLOB Region'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('REGION TYPE','ORG.HALFABEE.CLOBREGION'),'')
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render_clob_region (',
'    p_region              in apex_plugin.t_region,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_region_render_result',
'IS',
'    i                     PLS_INTEGER := 1;',
'    l_chunk_sz            PLS_INTEGER := 8000;',
'    l_clob                CLOB;',
'    l_return apex_plugin.t_region_render_result;',
'BEGIN',
'    apex_plugin_util.debug_region( p_plugin, p_region );',
'    ',
'    EXECUTE IMMEDIATE p_region.source INTO l_clob;',
'    ',
'    WHILE i <= dbms_lob.getlength( l_clob ) LOOP',
'        IF p_region.escape_output THEN',
'            apex_plugin_util.print_escaped_value( dbms_lob.substr( l_clob, l_chunk_sz, i ));',
'        ELSE',
'            htp.prn( dbms_lob.substr( l_clob, l_chunk_sz, i ));',
'        END IF;',
'        i := i + l_chunk_sz;',
'    END LOOP;',
'    sys.htp.prn( CHR(13) || CHR(10) );',
'   ',
'    return l_return;',
'END;',
''))
,p_api_version=>1
,p_render_function=>'render_clob_region'
,p_standard_attributes=>'SOURCE_SQL:ESCAPE_OUTPUT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(10922459817459506)
,p_plugin_id=>wwv_flow_api.id(34636878508938007391)
,p_name=>'SOURCE_SQL'
,p_sql_min_column_count=>1
,p_sql_max_column_count=>1
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT clob001',
'  FROM apex_collections',
' WHERE collection_name = ''MY_COLLECTION'''))
);
end;
/
