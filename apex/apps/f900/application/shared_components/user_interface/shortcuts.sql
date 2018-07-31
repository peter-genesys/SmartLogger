prompt --application/shared_components/user_interface/shortcuts
begin
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(25036481921869375)
,p_shortcut_name=>'DELETE_CONFIRM_MSG'
,p_shortcut_type=>'TEXT_ESCAPE_JS'
,p_shortcut=>'Would you like to perform this delete action?'
);
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(38005312973037748)
,p_shortcut_name=>'COMMENT_HTML'
,p_shortcut_type=>'FUNCTION_BODY'
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_woven boolean;',
'  l_body clob := :P6_ORIG_TEXT;',
'begin',
'',
'  ',
'  aop_processor.remove_comments(l_body);',
' ',
'',
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');',
'  l_body := REGEXP_REPLACE(l_body,''(ms_logger)(.+)(;)'',''<B>\1\2\3</B>'');',
'',
'  return ''<PRE>''||l_body||''</PRE>'';',
'end;'))
);
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(38096732149568892)
,p_shortcut_name=>'ORIG_TEXT'
,p_shortcut_type=>'FUNCTION_BODY'
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'CURSOR cu_source IS',
'select Concat(Concat(''<PRE>'',REPLACE(REPLACE(orig_text,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'')),''</PRE>'') ',
'from aop_source_v',
'where name = :P4_name and type = :P4_type;',
'l_text CLOB;',
'BEGIN',
'OPEN cu_source;',
'FETCH cu_source INTO l_text;',
'CLOSE cu_source;',
'return l_text;',
'END;'))
);
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(38097022930575691)
,p_shortcut_name=>'AOP_TEXT'
,p_shortcut_type=>'FUNCTION_BODY'
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  CURSOR cu_source IS',
'  select aop_text',
'  from aop_source_v',
'  where name = :P4_name and type = :P4_type;',
' ',
'  l_body CLOB;',
'',
'BEGIN',
'  OPEN cu_source;',
'  FETCH cu_source INTO l_body;',
'  CLOSE cu_source;',
'',
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');',
'  l_body := REGEXP_REPLACE(l_body,''(ms_logger)(.+)(;)'',''<B>\1\2\3</B>'');',
'',
'  return ''<PRE>''||l_body||''</PRE>'';',
' ',
'end;'))
);
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(38231015362589780)
,p_shortcut_name=>'AOP_ADHOC_HTML'
,p_shortcut_type=>'FUNCTION_BODY'
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_woven boolean;',
'  l_body clob := :P6_ORIG_TEXT;',
'begin',
'  l_woven := aop_processor.weave(l_body, ''Adhoc'', true);',
'',
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');',
'  l_body := REGEXP_REPLACE(l_body,''(ms_logger)(.+)(;)'',''<B>\1\2\3</B>'');',
'',
'  return ''<PRE>''||l_body||''</PRE>'';',
'end;'))
);
end;
/
