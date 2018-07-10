create or replace package ms_test5 as
--------------------------------------------------------------------------------
--This package is to be woven, but it is really a test of logger performance.
--
--------------------------------------------------------------------------------
  function test_clob_debugging     return varchar2;
  function test_varchar2_debugging return varchar2;
  function test_for_quiet_mode return varchar2;
  procedure test_sleeping1;
  procedure test_sleeping2;
  procedure test_sleeping;
end ms_test5;
/
