create or replace package body aop_test3 as
  --@AOP_LOG


--------------------------------------------------------------------------------
--to_LCD_from_MINS 
--transform MINS to LCD
--------------------------------------------------------------------------------
FUNCTION to_LCD_from_MINS(i_MINS    IN NUMBER
                         ,i_zeroval IN VARCHAR2 DEFAULT '00:00'
                         ,i_nullval IN VARCHAR2 DEFAULT  NULL) RETURN VARCHAR2 IS
  HHH    NUMBER;
  MI     NUMBER;
  l_MINS NUMBER;
  g_minus  CONSTANT VARCHAR2(1) := '-';
  l_sign            VARCHAR2(1);
 
BEGIN

  IF i_MINS IS NULL THEN
    RETURN i_nullval;
  ELSIF i_MINS = 0 THEN
    RETURN i_zeroval;
  END IF;
 
  IF i_MINS < 0 THEN
    l_sign := g_minus;
  END IF;

  l_MINS := ROUND(ABS(i_MINS));

  HHH := TRUNC(l_MINS/60);  
  MI  :=   MOD(l_MINS,60); 
 
  RETURN   l_sign
         ||CASE
             WHEN HHH < 100 THEN LPAD(NVL(HHH  ,0),2,'0')
             ELSE                TO_CHAR(HHH)
           END
         ||':'
         ||LPAD(NVL(MI,0),2,'0');

END;


  function test_clob_debugging return varchar2 is

 
    l_start_time date := sysdate;
    l_stop_time  date;
    l_clob clob;

  BEGIN
  	--""Start
  	--??Hi
    
    for j in 1 .. 4 LOOP
      l_clob := null;
      for i in 1 .. 1000 LOOP
        l_clob := l_clob || 'X';
      END LOOP;
    END LOOP;

    l_stop_time := sysdate;

    --""Stop

    l_clob := 'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);

    --raise no_data_found;

    return l_clob;
 
  end test_clob_debugging;


  function test_varchar2_debugging return varchar2 is

 
    l_start_time date := sysdate;
    l_stop_time  date;
    l_string varchar2(2000);

  BEGIN
  	--""Start
  	--??Hi
    
    for j in 1 .. 4 LOOP
      l_string := null;
      for i in 1 .. 1000 LOOP
        l_string := l_string || 'X';
      END LOOP;
    END LOOP;

    l_stop_time := sysdate;

    --""Stop

    l_string := 'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);

    --raise no_data_found;

    return l_string;
 
  end test_varchar2_debugging;


  function test_for_quiet_mode return varchar2 is

 
    l_start_time date;
    l_stop_time  date;
    l_string varchar2(2000);

  BEGIN

    l_start_time := sysdate;

  	--""Start
  	--??Hi
    
    for j in 1 .. 4 LOOP
      l_string := null;
      for i in 1 .. 1000 LOOP
        l_string := l_string || 'X';
      END LOOP;
    END LOOP;

    l_stop_time := sysdate;

    --""Stop

    l_string := 'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);

    raise no_data_found;

    return l_string;
 
  end test_for_quiet_mode;


end aop_test3;
/
execute aop_processor.reapply_aspect(i_object_name=> 'AOP_TEST3', i_versions => 'HTML,AOP');
--execute ms_api.set_module_debug(i_module_name => 'AOP_TEST3');