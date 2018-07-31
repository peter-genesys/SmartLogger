create or replace package sm_weave_test2 is

  type spec_rec_typ is record (adate   date
  	                          ,anum    number
  	                          ,astring varchar2(20));

  spec_rec_var1 spec_rec_typ;
  spec_rec_var2 spec_rec_typ;

  spec_simple_var1 number;


end sm_weave_test2;
/
