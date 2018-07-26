--define ENDUSER_user=QHOWN 
grant execute on ms_logger          to &&ENDUSER_user;
grant execute on aop_processor      to &&ENDUSER_user;
grant execute on ins_upd_aop_source to &&ENDUSER_user;
grant execute on ms_api             to &&ENDUSER_user;
grant execute on sm_jotter          to &&ENDUSER_user;