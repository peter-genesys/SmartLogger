CREATE OR REPLACE PACKAGE BODY LOGGER."AOP_TEST" is
  --@AOP_LOG

  g number;

  function test4(i_module ms_module%ROWTYPE
                ,o_unit      out ms_unit%ROWTYPE) return varchar2 is
    l_var number;
  begin
    null;

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
  end;


  function test3(i_param31 in varchar2 ) return varchar2 is
  begin
    null;
    --ms_feedback.comment('Eg of debugging message added by a developer');


    <<anon1>>
    declare
      l_temp varchar2(1) := trim(' X ');
      x number;
      f integer;
      l_unit ms_unit%ROWTYPE;
      l_unit_name ms_unit.unit_name%TYPE;

    begin
      l_unit_name := 'X';
      l_unit.unit_name := 'X';
      l_unit := l_unit;
      null;
      --ms_feedback.comment('anon block1');
      --:x:= 1;
      --:x := 1;
      --:x  := 1;
      x:= 2;
      x := 2;
      x  := 2;
      --hello:= 23;
      f:=3;
      g:= 4 ;

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
        --ms_feedback.comment('testz is nested in anon block2');
      end testz;

    begin
      null;
      --ms_feedback.comment('anon block2');

      testz(i_paramz => 'Z');

      declare
        l_temp varchar2(1);
      begin
        null;
        --ms_feedback.comment('nested anon block3');
      end;

    end;

    return i_param31;
  end test3;


  procedure test1(i_param11 in varchar2
                 ,i_param12 in varchar2
                 ,i_param13 in varchar2) is

    l_test varchar2(100) := test3(i_param31 => 'X');

    procedure test1a(i_param1a1 in varchar2) is
      procedure test1aa(i_param1aa1 in varchar2
                       ,i_param1aa2 in varchar2) is
      begin

        null;
        --ms_feedback.comment('Should see this comment a 3 times');
      end test1aa;

    begin

      null;

      --This is a single comment with an ignored multi-line comment open /*
      declare
        l_temp varchar2(1);
      begin
        null;
        --ms_feedback.comment('anon block');
      end;
      --This is a single comment with an active multi-line comment close */

      test1aa(i_param1aa1 => i_param1a1
             ,i_param1aa2 => 'DUMMY');

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

  begin
    null;
    --ms_feedback.comment('About to raise an error');
    raise no_data_found;
    --ms_feedback.warning('Should not have reached here.');


    --""This is a special comment
    --??This is a special info
    --!!This is a special warning
    --##This is a special fatal

    o_param23:= 1;
    io_param24:= 2;
    --i_param25:= 4;



  exception
    when x_test then
      null;
    when others then
      null;
      --ms_feedback.oracle_error;
  end test2;

  /*
  This is
  a multi-line comment
  --This is a single comment with an active multi-line comment close */

end;
/
show errors;
execute logger.aop_processor.reapply_aspect(i_object_name=> 'AOP_TEST');