--application/shared_components/user_interface/shortcuts/source_text
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'DECLARE'||unistr('\000a')||
'CURSOR cu_source IS'||unistr('\000a')||
'--select Concat(Concat(''<div class="textRegion">'',text),''</div>'') '||unistr('\000a')||
'select Concat(Concat(''<PRE>'',text),''</PRE>'') '||unistr('\000a')||
'from aop_source'||unistr('\000a')||
'where rowid = :P3_ROWID;'||unistr('\000a')||
'l_text CLOB;'||unistr('\000a')||
'BEGIN'||unistr('\000a')||
'OPEN cu_source;'||unistr('\000a')||
'FETCH cu_source INTO l_text;'||unistr('\000a')||
'CLOSE cu_source;'||unistr('\000a')||
'return l_text;'||unistr('\000a')||
'END;';

wwv_flow_api.create_shortcut (
 p_id=> 2615805787916158 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'SOURCE_TEXT',
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
