prompt --application/shared_components/user_interface/shortcuts/orig_text
begin
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
end;
/
