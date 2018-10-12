prompt --application/shared_components/user_interface/shortcuts/aop_text
begin
wwv_flow_api.create_shortcut(
 p_id=>wwv_flow_api.id(38097022930575691)
,p_shortcut_name=>'AOP_TEXT'
,p_shortcut_type=>'FUNCTION_BODY'
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  CURSOR cu_source IS',
'  select aop_text',
'  from sm_source_v',
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
'  l_body := REGEXP_REPLACE(l_body,''(sm_logger)(.+)(;)'',''<B>\1\2\3</B>'');',
'',
'  return ''<PRE>''||l_body||''</PRE>'';',
' ',
'end;'))
);
end;
/
