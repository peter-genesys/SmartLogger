--application/shared_components/user_interface/shortcuts/aop_adhoc_html
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'declare'||unistr('\000a')||
'  l_woven boolean;'||unistr('\000a')||
'  l_body clob := :P6_ORIG_TEXT;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_woven := aop_processor.weave(l_body, ''Adhoc'', true);'||unistr('\000a')||
''||unistr('\000a')||
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');'||unistr('\000a')||
'  l_body := REGEXP_REPLACE(l_body,''(ms_logger)(.+)(;)'',''<B>\1\2\3</B>'');'||unistr('\000a')||
''||unistr('\000a')||
'  return ''<PRE>''||l_body||''</PRE>'';'||unistr('\000a')||
'end;';

wwv_flow_api.create_shortcut (
 p_id=> 2761912338943635 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'AOP_ADHOC_HTML',
 p_shortcut_type=> 'FUNCTION_BODY',
 p_shortcut=> c1);
end;
null;
 
end;
/

prompt  ...web services (9iR2 or better)
--
prompt  ...shared queries
--
prompt  ...report layouts
--
prompt  ...authentication schemes
--
