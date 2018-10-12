prompt --application/shared_components/user_interface/shortcuts/aop_adhoc_html
begin
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(38231015362589780)
,p_shortcut_name=>'AOP_ADHOC_HTML'
,p_shortcut_type=>'FUNCTION_BODY'
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_woven boolean;',
'  l_body clob := :P6_ORIG_TEXT;',
'begin',
'  l_woven := sm_weaver.weave(l_body, ''Adhoc'', true);',
'',
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');',
'  l_body := REGEXP_REPLACE(l_body,''(sm_logger)(.+)(;)'',''<B>\1\2\3</B>'');',
'',
'  return ''<PRE>''||l_body||''</PRE>'';',
'end;'))
);
end;
/
