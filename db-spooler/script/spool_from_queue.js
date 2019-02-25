function debug(message) {
  ctx.write(message+ "\n");
}

 
debug('Spool From Queue\n\n');
 
for(var arg in args) {
       debug(arg + ":" + args[arg]);
}

// Look up a single value to use in a bind later  
var l_schema = util.executeReturnOneCol('select user from dual');
debug('Schema: '+ l_schema + '\n')

/* simple string or number binds can be a js object */
var binds = {};
binds.db_path       = args[1];
binds.queued_by     = args[2];
binds.owner_dir     = args[3];
binds.object_owner  = l_schema;
 
ret = util.executeReturnList(
   "select rowid"
      +" , object_name"
      +" , replace(object_type,' ','_') object_type "
 +" from  sg_spool_queue_av"
 +" where queued_by = :queued_by"
 +" and object_owner = :object_owner"
 +" and spooled_date is null"
 +" order by object_type, object_name"
   ,binds);


ctx.write('\n\n');
ctx.write('\n***************************************************************');
ctx.write('\n** Matching Objects of Owner '+binds.object_owner+' requestor '+binds.queued_by);
ctx.write('\n***************************************************************');
 
if (ret.length == 0) {

  ctx.write('\n\nNo objects ready to spool. \n');
  ctx.write('\n***************************************************************');
 
} else {
 
 
  for (i = 0; i < ret.length; i++) {
    ctx.write( "\n" + ret[i].OBJECT_TYPE  + "\t" + ret[i].OBJECT_NAME);
  }
  ctx.write('\n***************************************************************');
  ctx.write('\n\n');
  
  
  //Export each object
  for (i = 0; i < ret.length; i++) {
      binds.object_type = ret[i].OBJECT_TYPE
      binds.object_name = ret[i].OBJECT_NAME
   
      var spool_command = "script spool_objects.js "+binds.db_path+" "+binds.owner_dir+" "+binds.object_owner+" "+ret[i].OBJECT_TYPE+" "+ret[i].OBJECT_NAME+";"
                       +"\nUPDATE sg_spool_queue SET spooled_date = sysdate WHERE rowid = '"+ret[i].ROWID+"';"
                       +"\nCOMMIT;";
  
      debug( spool_command);
  
      sqlcl.setStmt(spool_command);
      sqlcl.run();
    
  }
}