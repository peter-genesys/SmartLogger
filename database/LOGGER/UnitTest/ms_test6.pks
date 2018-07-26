create or replace package ms_test6 as
--------------------------------------------------------------------------------
--This package is to be woven, but it is really a test of logger performance.
--
--------------------------------------------------------------------------------
function message_caching(i_max in integer) return varchar2;
end ms_test6;
/
