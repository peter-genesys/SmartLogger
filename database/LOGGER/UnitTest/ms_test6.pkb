create or replace package body ms_test6 as

--------------------------------------------------------------------------------
--This package is a mockup to test the storing of messages 
--
--------------------------------------------------------------------------------

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


------------------------------------------------------------------------
-- push_message
------------------------------------------------------------------------
PROCEDURE push_message(io_messages  IN OUT NOCOPY ms_logger.message_list
                      ,i_message    IN            ms_message%ROWTYPE ) IS
  l_next_index               BINARY_INTEGER;    


BEGIN
 
  --Next index is last index + 1
  l_next_index := NVL(io_messages.LAST,0) + 1;
 
  --add to the stack             
  io_messages( l_next_index ) := i_message;
 
END;


  function message_caching(i_max in integer) return varchar2 is

    l_node         ms_logger.node_typ := ms_logger.new_func('ms_test6','message_caching');

    l_ms_message   ms_message%ROWTYPE;
 
    l_start_time date;
    l_stop_time  date;


  BEGIN

    l_start_time := sysdate;



    ms_logger.note(l_node,'l_node.traversal.traversal_id', l_node.traversal.traversal_id);

    for i in 1..i_max loop
    l_ms_message.message := to_char(SYS_GUID)
                          ||to_char(SYS_GUID)
                          ||to_char(SYS_GUID)
                          ||to_char(SYS_GUID);

      push_message(io_messages  => l_node.unlogged_messages
                  ,i_message    => l_ms_message);

      --Hmm but its not just pushing the messages on the stack its also push the nodes on a stack of unlogged nodes...
      l_node.unlogged_messages.DELETE(l_node.unlogged_messages.count);


    end loop;
  
    

   --traversal        ms_traversal%ROWTYPE
   --module           ms_module%ROWTYPE
   --unit             ms_unit%ROWTYPE
   --open_process     ms_unit.open_process%TYPE
   --node_level       BINARY_INTEGER
   --logged           BOOLEAN
   --unlogged_messages message_list
   --internal_error   BOOLEAN DEFAULT NULL --start undefined, set to false by an ENTER routine.
   --call_stack_level BINARY_INTEGER
   --call_stack_hist  VARCHAR2(2000));  --limit of 2000 chars returned by dbms_utility.format_call_stack in 11g

   l_stop_time := sysdate;

   return 'Done. '||l_node.unlogged_messages.count||' '||'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);


  
  end message_caching;

 
end ms_test6;
/
 
select ms_test6.message_caching(100000) from dual;