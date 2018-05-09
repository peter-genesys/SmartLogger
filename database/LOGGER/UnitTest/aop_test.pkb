CREATE OR REPLACE PACKAGE BODY "AOP_TEST" is
  --@AOP_LOG

  g$ number;

  type date_typ_rec is record (adate date);
  l_date_rec1 date_typ_rec;
  l_date_rec2 date_typ_rec;
 
  function test4$(i_module ms_module%ROWTYPE
                ,i_name_array  in OWA.vc_arr
                ,o_unit      out ms_unit%ROWTYPE) return varchar2 is
    l_var number;

    cursor cu_user_tables is
    select table_name, tablespace_name
    from user_tables 
    where table_name = 'X';

    l_table_name VARCHAR2(30);
    l_tablespace_name VARCHAR2(30);

    l_value_array  OWA.vc_arr;

    l_var2 number;
    l_var3 number;


  begin

    l_date_rec1.adate := SYSDATE;
    l_date_rec2 := l_date_rec1;

    null;

    open cu_user_tables;
    fetch cu_user_tables into l_table_name, l_tablespace_name;
    close cu_user_tables;
 
  
    select count(*), count(*) 
    into l_var2, l_var3 
    from dual;
 
    --i_module.module_name := 'X';

    FOR l_record IN (select 1 from dual) LOOP
      l_var := 1;
    END LOOP;

    IF l_var = 0 then
      l_var := 1;

    else
      IF l_var = 0 then  
        l_var := 1;
      elsif l_var = 0 then 
        l_var := 1;
      end if;
      l_var := 1;
    end if;
 
    o_unit.unit_name := 'X';
  end test4$;


  function test3(i_param31 in varchar2 ) return varchar2  RESULT_CACHE RELIES_ON (dual)  is
  begin
    null;
    --""Eg of debugging message added by a developer


    <<anon1>>
    declare
      l_temp varchar2(1) := trim(' X ');
      x number;
      f# integer;
      l_unit ms_unit%ROWTYPE;
      l_unit_name ms_unit.unit_name%TYPE;

    begin
      l_unit_name := 'X';
      l_unit.unit_name := 'X';
      l_unit := l_unit;
      null;
      --""anon block1
      --:x:= 1;
      --:x := 1;
      --:x  := 1;
      x:= 2;
      x := 2;
      x  := 2;
      --hello:= 23;
      f#:=3;
      g$:= 4 ;

    end anon1;

    <<anon2>>
    declare
      l_temp varchar2(1);

      procedure testz(i_paramz in varchar2 ) is
        l_var varchar2(32000);
      begin

        --x:= 4 ;
        l_var := q'[
with event_details as (
select q.*
      ,decode(:i_dataset_grp,NULL,'Dataset '||to_char(dataset_grp),'Assigned Group '||assigned_grp) context
from (
     select v.*
           ,max(event_date) over (partition by new_linkage_key ) max_event_date
     from  ppms_event_v v
     where dataset_grp = NVL(:i_dataset_grp,dataset_grp)
     and   publish_type in ('GRY','STR')
     ) q
where max_event_date >= :i_min_qa_date
)
, personal_details_filter as (
    select    new_linkage_key
    from      event_details e
    group by new_linkage_key
    having count(distinct trim_first_given) > 1
    and    count(distinct trim_first_given) = count(distinct trim_surname)
    and    count(distinct trim_first_given) = count(distinct trim_first_given||trim_surname)
    union all
    select    new_linkage_key
    from      event_details e
    group by new_linkage_key
    having count(distinct trim_first_given) > 1
    and    count(distinct trim_first_given) = count(distinct birth_date_char)
    and    count(distinct trim_first_given) = count(distinct trim_first_given||birth_date_char)
    union all
    select    new_linkage_key
    from      event_details e
    group by new_linkage_key
    having count(distinct trim_surname) > 1
    and    count(distinct trim_surname) = count(distinct birth_date_char)
    and    count(distinct trim_surname) = count(distinct trim_surname||birth_date_char)
    union all
    select    new_linkage_key
    from      event_details e
    group by new_linkage_key
    having count(distinct trim_postcode) > 1
    and    count(distinct trim_postcode) = count(distinct birth_date_char)
    and    count(distinct trim_postcode) = count(distinct trim_postcode||birth_date_char)
    union all
    select    new_linkage_key
    from      event_details e
    group by new_linkage_key
    having count(distinct trim_surname) > 1
    and    count(distinct trim_surname) = count(distinct trim_postcode)
    and    count(distinct trim_surname) = count(distinct trim_surname||trim_postcode)
)
]';

        null;
        --""testz is nested in anon block2
      end testz;

    begin
      null;
      --""anon block2

      testz(i_paramz => 'Z');

      declare
        l_temp varchar2(1);
      begin
        null;
        --""nested anon block3
      end;

    end;

    return i_param31;
  end test3;


  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
                 ,i_param13 in varchar2) is

    l_test varchar2(100) := test3(i_param31 => 'X');

    procedure test1a(i_param1a1 in varchar2);

    procedure test1b(i_param1b1 in varchar2) is
    begin
      test1a(i_param1a1 => i_param1b1);
    END;


    procedure test1a(i_param1a1 in varchar2) is
      procedure test1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2
                       ,i_clob      in CLOB) is
      begin

        null;
        --""Should see this comment a 3 times
      end test1aa;

    begin

      null;

      --This is a single comment with an ignored multi-line comment open /*
      declare
        l_temp varchar2(1);
      begin
        null;
        --""anon block
      end;
      --This is a single comment with an active multi-line comment close */

      test1aa(i_param1aa1 => i_param1a1
             ,i_param1aa2 => 'DUMMY'
             ,i_clob      => 'ZZZZZ');

    end test1a;

  begin

    test1a(i_param1a1 => i_param11);

    test1a(i_param1a1 => i_param12);

    test1a(i_param1a1 => i_param13);
    --ms_feedback.info('Routine finished successfully');

    null;
  exception
    when others then
      null;
      --ms_feedback.oracle_error;
  end test1;


  procedure test2(i_param21 in varchar2
                 ,i_param22 in varchar2
				 ,o_param23 out varchar2
				 ,io_param24 in out varchar2
				 ,i_param25 varchar2) is
   x_test exception;
   l_clob_a CLOB;

   l_dummy number;

  begin

    case 
      when l_dummy = 1 then
        null;
      when l_dummy = 2 then
        null;
      else
        null;
    end case;    




    l_clob_a := 'TEST';
    null;
    --""About to raise an error
    raise no_data_found;
    --##Should not have reached here.


    --""This is a special comment
    --??This is a special info
    --!!This is a special warning
    --##This is a special fatal
    --""Next comment produces a Note.
    --^^l_clob_a
    if true then

      o_param23:= NVL(NULL,CASE
                             WHEN TRUE THEN 1
                             WHEN FALSE THEN 2
                           END);
    end if;            
    io_param24:= 2;
    --i_param25:= 4;
 


  exception
    when x_test then
      o_param23:= CASE
                    WHEN TRUE THEN 1
                    WHEN FALSE THEN 2
                  END;
                  
    when others then
      null;
      --ms_feedback.oracle_error;
  end test2;



  FUNCTION test5 RETURN VARCHAR2 is
    l_insert_count number;
    l_delete_count number;
    l_update_count number;
    l_result VARCHAR2(2000);

    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
  
    insert into MS_PROCESS (process_id) values (-1);
    l_insert_count := SQL%ROWCOUNT;
 
    update MS_PROCESS
    SET UPDATED_DATE = SYSDATE
    WHERE process_id = -1 ;
    l_update_count := SQL%ROWCOUNT;
 
    delete from MS_PROCESS where process_id = -1;
    l_delete_count := SQL%ROWCOUNT;
 
    l_result := 'INSERTED '||l_insert_count||' UPDATED '||l_update_count||' DELETED '||l_delete_count;

    ROLLBACK;

    RETURN l_result;

  END;

  procedure test_spec_var(i_test in out test_typ) is

  BEGIN
    i_test.num := 2;

  END;




  procedure test99 is

    TYPE rule_set_typ IS RECORD (
       selector      VARCHAR2(50)
      ,selector_type VARCHAR2(30)
      ,decl_block    CLOB);
    
    TYPE rule_set_tab_typ IS TABLE OF rule_set_typ INDEX BY BINARY_INTEGER;

    l_rule_set_tab  rule_set_tab_typ;
    l_selector      VARCHAR2(50);  
    l_test          test_typ;
    l_rule_set      rule_set_typ;

  BEGIN
    l_test.num := 1;

    l_rule_set_tab(1).selector   := ltrim(l_selector,'.#'); --Does this create a valid statement?
     
    l_rule_set.selector := 'TEST';

  END;


  /*
  This is
  a multi-line comment
  --This is a single comment with an active multi-line comment close */

end;
/
show errors;
execute aop_processor.reapply_aspect(i_object_name=> 'AOP_TEST');
execute ms_api.set_module_debug(i_module_name => 'AOP_TEST');
select aop_test.test5 from dual;
