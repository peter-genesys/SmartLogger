ALTER SESSION SET plscope_settings='IDENTIFIERS:NONE'
/
create or replace package body aop_test2 is
  --@AOP_LOG
  type body_rec_typ is record (adate   date
  	                          ,anum    number
  	                          ,astring varchar2(20)
  	                          ,abool   boolean);

  type body_nested_rec_typ is record (adate   date
  	                                 ,subrec  body_rec_typ);


  body_rec_var1 spec_rec_typ;
  body_rec_var2 body_rec_typ;

  body_simple_var1 number;

  type body_rec_tab_typ is table of body_rec_typ index by binary_integer;


  procedure scope_test is
    l_var number;
  BEGIN
  	l_var :=                  body_simple_var1;

    body_simple_var1                   := l_var;
    aop_test2.body_simple_var1         := l_var;
    --pacman.aop_test2.body_simple_var := l_var; --'PLS-00302: component 'BODY_SIMPLE_VAR1' must be declared

    spec_simple_var1                   := l_var;
    aop_test2.spec_simple_var1         := l_var;
    pacman.aop_test2.spec_simple_var1  := l_var;
 
  END;

  procedure test(io_var  IN OUT            spec_rec_typ
                ,io_var2 IN OUT aop_test2.spec_rec_typ) is

    l_nested_rec body_nested_rec_typ;

    l_tab   aop_test.test_tab_typ; --from spec of another package

  begin
    io_var.anum  := 1;
    io_var2.anum := 1;
    aop_test2.scope_test;
    --pacman.aop_test2.scope_test; --PLS-00302: component 'SCOPE_TEST' must be declared
    --No need to user the owner in the pu_stack of the package body.
    --Cannot refer to either variables or program units defined in the body by a user prefix, 
    --because this denotes that we are referring to the spec only.
  
    l_nested_rec.subrec.astring := 'HI';
    
    test.l_nested_rec.subrec.astring := 'HI';

    test.l_nested_rec := l_nested_rec;

    l_tab(1).num := 1;

  end;


  procedure nested_block_scope is
    l_var number;
  BEGIN
    
    l_var := 1;

    DECLARE  
      l_var number;
    BEGIN
      l_var := 1;
    END;

    --Will support a named block.
    <<test_block>>
    DECLARE  
      l_var number;
    BEGIN
      test_block.l_var := 1;
    END;

    
    <<test_block2>>
    --I will assume that the last label always has scope.
    if true then
      null;
    end if;
    if false then
      declare 
        x number;
      BEGIN
        test_block2.x := 2;
        dbms_output.put_line('test_block2.x='||test_block2.x);
      END;
    end if;  

    --It is compilable in PLSQL to have 2 labels apply to the same block.
    --But it screws with PLscope, and i have decided not to support this syntax.
    <<test_block2a>>
    null;
    <<test_block2b>>
    declare
      l_var1 number;
    BEGIN
      test_block2a.l_var1 := 1;
      test_block2b.l_var1 := test_block2a.l_var1;
      dbms_output.put_line('test_block2b.l_var1='||test_block2b.l_var1);
    END;

    --labels will be assumed to have scope over the next statement only.
    --If that is a block, then the label has scope over its descendents too.
    <<ifthen>>
    if false then
      <<blocka>>
      declare 
        x number;
      BEGIN
        blocka.x := 2;
        dbms_output.put_line('blocka.x='||blocka.x);
      END;
      declare 
        x number;
      BEGIN
        x := 2;
        dbms_output.put_line('x='||x);
      END;
    end if;  


    declare
      l_var3 number;
    BEGIN
      null;
    END;

 
  END;


  procedure test_nulls_in_block is
  BEGIN
    --Labelled vars and nulls statements 
    --Causes issues because PLScope seem to skip the rest of the block
    --So misses the ASSIGNMENT to label.var

    <<test_label>> 
    declare
      l_dog  varchar2(20);
      l_cat  varchar2(20);
      l_bird varchar2(20);
      l_fish varchar2(20);
    BEGIN
      test_label.l_dog := 'SPANIEL';
      if true then
        null;
 
        <<inner_label>>
        declare
          l_plant varchar2(20);
        BEGIN
          inner_label.l_plant := 'LILLY';
          l_plant := 'LILLY';
        END;

        test_label.l_fish := 'FLAKE';
        l_fish := 'FLAKE';

      end if;
      test_label.l_cat := 'PUSSY';
      null;
      test_label.l_bird := 'CANARY';
      l_bird := 'CANARY';

    END;

    declare
      l_fish varchar2(20);
    BEGIN
      l_fish := 'TROUT';
    END;
 
  END;


  procedure test_nulls_in_block2 is
    l_rock varchar2(20);
  BEGIN
    --Same effect with any sort of qualified variable name
    null;
    test_nulls_in_block2.l_rock := 'GRANITE';
    l_rock := 'GRANITE';
  END;



  procedure test_ref_to_unscoped_package is
  --Test compilation with PLScope when reference package is not yet compiled with PLScope.
  --Requires separate step to ensure the precondition...
    l_dummy number;
  BEGIN
    l_dummy := 1;
    aop_test.g_test3 := 1;
 
  END;

  procedure test_comment_within_formatting is
  BEGIN
    aop_test. --comment within term (not supported)
             g_test3 := 1;

    aop_test.  
             g_test3 := 1; --line break within term (not supported)

    aop_test.g_test3  := 1; --term on one line (supported)

    aop_test.g_test3  
                      := 1; --assignment on a different line (supported)

    aop_test.g_test3 --comment between term and assign (supported)
                     --comment between term and assign (supported)
                     := 1;

  END;



  procedure test_array is

   
    type name_tab_typ is table of varchar2(100) index by binary_integer;
    l_nam_tab    name_tab_typ;
    l_nam_tab2   name_tab_typ;
    l_tab_of_rec body_rec_tab_typ;
    l_rec        body_rec_typ;
    x number;

  BEGIN
    if x = 1 then 
      null;
    end if;
    l_nam_tab(2) := 'MARY';
    l_nam_tab := l_nam_tab2;
    
    test_array.l_nam_tab := l_nam_tab2;

    l_tab_of_rec(1).anum := 1;
    l_tab_of_rec(1) := l_rec;
    l_tab_of_rec := l_tab_of_rec;
 
  END;



 
BEGIN
  
  body_simple_var1 := 1;

  aop_test2.body_simple_var1 := 2;


end aop_test2;
/

execute aop_processor.reapply_aspect(i_object_name=> 'AOP_TEST2', i_versions => 'HTML,AOP');
execute ms_api.set_module_debug(i_module_name => 'AOP_TEST2');