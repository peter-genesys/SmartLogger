prompt --application/shared_components/user_interface/shortcuts/comment_html
begin
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
'  --@@TODO IS THIS PROCEDURE STILL USED??',
'  --weaver.remove_comments(l_body);',
' ',
'',
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');',
'  l_body := REGEXP_REPLACE(l_body,''(sm_logger)(.+)(;)'',''<B>\1\2\3</B>'');',
'',
'  return ''<PRE>''||l_body||''</PRE>'';',
'end;'))
);
end;
/
