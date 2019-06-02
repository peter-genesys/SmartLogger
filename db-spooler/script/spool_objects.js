
function debug(message) {
  ctx.write(message+ "\n");
}


function config_by_object_name(binds) {
//object_types are the actual ORACLE object types, 
//except that ' ' has been replaced with '_' to simplify passing as a param.  

  switch (binds.object_type) {
    case "DATABASE LINK":
        binds.default_folder   = "dblinks";
        binds.file_ext = "dbl";
        binds.ddl_type = "DB_LINK";
        break;
    case "DATA":
        binds.object_type = "TABLE";
        binds.default_folder   = "data";
        binds.file_ext = "pop";
        binds.ddl_type = "DATA";
        debug("DATA");
        try {
          binds.file_suffix = "_" + args[6];
        } catch (err) {
          debug("No 6th param for DATA");
          binds.file_suffix = ""

        }
        break;
    case "ROLE":
        binds.object_type = "ROLE";
        binds.default_folder   = "roles";
        binds.file_ext = "rol";
        binds.ddl_type = "ROLE";
        break;
    case "TABLE":
        binds.default_folder   = "tables";
        binds.file_ext = "tab";
        break;
    case "VIEW":
        binds.default_folder   = "views";
        binds.file_ext = "vw";
        break;
    case "MATERIALIZED VIEW":
        binds.default_folder   = "mviews";
        binds.file_ext = "mv";
        binds.ddl_type = "MATERIALIZED_VIEW";
        break;
    case "PACKAGE":
        binds.default_folder   = "packages";
        binds.file_ext = "pks";
        binds.ddl_type = "PACKAGE_SPEC";
        break;
    case "PACKAGE BODY":
        binds.default_folder   = "packages";
        binds.file_ext = "pkb";
        binds.ddl_type = "PACKAGE_BODY";
        break;
    case "PROCEDURE":
        binds.default_folder   = "procedures";
        binds.file_ext = "prc";
        break;
    case "FUNCTION":
        binds.default_folder   = "functions";
        binds.file_ext = "fnc";
        break;
    case "TYPE":
        binds.default_folder   = "types";
        binds.file_ext = "tps";
        binds.ddl_type = "TYPE_SPEC";
        break;
    case "TYPE BODY":
        binds.default_folder   = "types";
        binds.file_ext = "tpb";
        binds.ddl_type = "TYPE_BODY";
        break;
    case "SYNONYM":
        binds.default_folder   = "synonyms";
        binds.file_ext = "syn";
        break;
    case "SEQUENCE":
        binds.default_folder   = "sequences";
        binds.file_ext = "seq";
        break;
    case "JOB":
        binds.default_folder   = "scheduler";
        binds.file_ext = "job";
        binds.ddl_type = "PROCOBJ";
        break;
    case "SCHEDULE":
        binds.default_folder   = "scheduler";
        binds.file_ext = "sched";
        binds.ddl_type = "PROCOBJ";
        break;
    case "RULE":
        binds.default_folder   = "scheduler";
        binds.file_ext = "rule";
        binds.ddl_type = "PROCOBJ";
        break;
    case "RULE SET":
        binds.default_folder   = "scheduler";
        binds.file_ext = "rlset";
        binds.ddl_type = "PROCOBJ";
        break;
    case "EVALUATION CONTEXT":
        binds.default_folder   = "scheduler";
        binds.file_ext = "evcon";
        binds.ddl_type = "PROCOBJ";
        break;
    case "CREDENTIAL":
        binds.default_folder   = "scheduler";
        binds.file_ext = "cred";
        binds.ddl_type = "PROCOBJ";
        break;
    case "CHAIN":
        binds.default_folder   = "scheduler";
        binds.file_ext = "chain";
        binds.ddl_type = "PROCOBJ";
        break;
    case "PROGRAM":
        binds.default_folder   = "scheduler";
        binds.file_ext = "prog";
        binds.ddl_type = "PROCOBJ";
        break;
    //case "FILE WATCHER":  NO SUPPORT YET
    //    binds.default_folder   = "scheduler";
    //    binds.file_ext = "fw";
    //    binds.ddl_type = "PROCOBJ"
    //    break;
    case "QUEUE":
        binds.default_folder   = "scheduler";
        binds.file_ext = "queue";
        binds.ddl_type = "AQ_QUEUE";
        break;
    case "JAVA CLASS":
        binds.default_folder   = "java";
        binds.file_ext = "class";
        binds.ddl_type = "JAVA_CLASS";
        break;
    case "JAVA TYPE":
        binds.default_folder   = "java";
        binds.file_ext = "jtyp";
        binds.ddl_type = "JAVA_TYPE";
        break;
    case "JAVA SOURCE":
        binds.default_folder   = "java";
        binds.file_ext = "jsrc";
        binds.ddl_type = "JAVA_SOURCE";
        break;
    case "JAVA RESOURCE":
        binds.default_folder   = "java";
        binds.file_ext = "jresrc";
        binds.ddl_type = "JAVA_RESOURCE";
        break;
    case "XML SCHEMA":
        binds.default_folder   = "xml";
        binds.file_ext = "xsch";
        binds.ddl_type = "XMLSCHEMA";
        break;
    case "DIRECTORY":
        binds.default_folder   = "directory";
        binds.file_ext = "dir";
        binds.ddl_type = "DIRECTORY";
        break;
 
    default: 
        binds.default_folder   = "adhoc";
        binds.file_ext = "sql";
}


}

 
function spool_with_SQLcl(binds) {
 
  debug("spool_with_SQLcl SPOOLING DDL FOR " + binds.ddl_type  + "\t" + binds.object_name);
 
  var ddl_settings =  "\nSET DDL PRETTY ON;"
                     +"\nSET DDL SQLTERMINATOR ON;"
                     +"\nSET DDL SEGMENT_ATTRIBUTES OFF;"
                     +"\nSET DDL CONSTRAINTS_AS_ALTER ON;"
                     +"\nSET DDL FORCE OFF;";
  if (binds.ddl_type != "SYNONYM") {
    ddl_settings = ddl_settings + "\nSET DDL EMIT_SCHEMA OFF;";
  }

  debug(ddl_settings);

  var ddl_command  =  "\nDDL " + binds.object_name + " " + binds.ddl_type;
  debug(ddl_command);

  var formatting = "";
  //Format only tables and views
  if (binds.ddl_type == "TABLE" || binds.ddl_type == "VIEW") {
    formatting = "\nformat rules PLSQLstyle.xml"
               + "\nformat buffer";
  }
  debug(formatting);
 
  var save_file =    "\nSAVE FILE " + binds.DDLfolder + "/" + binds.object_name.toLowerCase() + "." + binds.file_ext + " REPLACE";
  debug(save_file);

 
  sqlcl.setStmt(ddl_settings+ddl_command+formatting+save_file);
  sqlcl.run();

  //Now add the extra DDL to tables and views, without reformatting them.

  //save_file =    "\nSAVE FILE " + binds.DDLfolder + "/" + binds.object_name.toLowerCase() + "." + binds.file_ext + " APPEND";
 
}

function format1(fname) {
    var format_file = "\nformat rules PLSQLstyle.xml"
                    + "\nformat file "+fname+" "+fname;
    sqlcl.setStmt(format_file);
    sqlcl.run();
}

function format2(fname) {
    //var format_file = "\nformat rules D:\\GitRepos\\SmartCodeGen\\tools\\ddl_extract\\myStyle.xml"
    var format_file = "\nformat rules PLSQLstyle2.xml"
                    + "\nformat file "+fname+" "+fname;

 
    sqlcl.setStmt(format_file);
    sqlcl.run();
}


function format3(fname) {
    //var format_file = "\nformat rules D:\\GitRepos\\SmartCodeGen\\tools\\ddl_extract\\myStyle.xml"
 
    var format_file = "\nformat file "+fname+" "+fname;

    sqlcl.setStmt(format_file);
    sqlcl.run();
}


function spool_data_file(binds){



  //debug("spool_data_file"); 
  // get the path/file handle to write to
  
  var fs      = java.nio.file.FileSystems.getDefault();
  var f       = java.nio.file.Files;
  var fname = binds.DDLfolder + "/" + binds.object_name.toLowerCase() + binds.file_suffix + "." + binds.file_ext;
  var path = fs.getPath(fname);

  var sql_settings      = "\nset echo off heading off feedback off verify off pagesize 0 linesize 300 serveroutput on TRIMSPOOL ON;"
  var spool_on_command  = "\nspool " + path + " replace ";
  var export_command    = "\nexecute "+binds.object_name.toLowerCase() +"_tapi.unload_data;";
  var spool_off_command = "\nspool off ";
 
  sqlcl.setStmt(sql_settings
               +spool_on_command
               +export_command
               +spool_off_command);
  sqlcl.run();

}


function spool_append_section(secton_name, sql_script, ddl_path){

  var sql_settings      = "\nSET HEADING OFF PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON;"
  var spool_on_command  = "\nspool " + ddl_path + " append ";
  var section_label     = "\nprompt"
                        + "\nprompt"
                        + "\nprompt --" + secton_name;
  if (!secton_name) {
    section_label = "";
  }


  var spool_off_command = "\nspool off ";
 
  sqlcl.setStmt(sql_settings
               +spool_on_command
               +section_label
               +"\n"+sql_script
               +spool_off_command);
  sqlcl.run();
 
}

function append_ddl(binds, ddl_path, ddl_fname, section_name) {
  //size limit 4000 chars
  var sql_script   = "select to_char(dbms_metadata.get_ddl ('" + binds.ddl_type + "','" + binds.object_name + "','" + binds.owner + "')) ddl from dual;";
  //debug(sql_script);
 
  spool_append_section(section_name, sql_script, ddl_path);
 
}
 
function append_mview_logs(binds, ddl_path, ddl_fname, section_name) {
  //size limit 4000 chars
  var sql_script   = 
     " select to_char(dbms_metadata.get_dependent_ddl ('MATERIALIZED_VIEW_LOG',referenced_name,owner)) ddl "
  +  " from dba_dependencies"
  +  " where referenced_type = 'TABLE'"
  +  " and   referenced_name != '" + binds.object_name + "'"
  +  " and   owner = '" + binds.owner + "'"
  +  " and   name = '" + binds.object_name + "';";
  debug(sql_script);
 
  spool_append_section(section_name, sql_script, ddl_path);
 
}


function append_indexes(binds, ddl_path, ddl_fname, section_name) {
  //size limit 4000 chars
  var sql_script   = 
     " select to_char(dbms_metadata.get_ddl ('INDEX',index_name,owner)) ddl " 
  +  " from all_indexes"
  +  " where table_owner = '" + binds.owner + "'"
  +  " and   table_name = '" + binds.object_name + "'"
//  +  " and   index_type = 'NORMAL'"
  +  ";";
  debug(sql_script);

  spool_append_section(section_name, sql_script, ddl_path);
 
}

function append_big_dep_ddl(binds, ddl_path, ddl_fname, dep_ddl_type,section_name) {
  //especialy for size > 4000 chars.  Eg triggers.
    var fs      = java.nio.file.FileSystems.getDefault();
    var f       = java.nio.file.Files;

    binds.dep_ddl_type = dep_ddl_type;

    //Now output the dependant DDL to a temporary file
    var result = util.executeReturnList("select REPLACE(dbms_metadata.get_dependent_ddl(:dep_ddl_type,:object_name,:owner),' EDITIONABLE','') ddl from dual",binds);
    try {
 
      var blobStream =  result[0].DDL.getAsciiStream();
 
      // dump the file stream to temp grant file
      var CopyOption = Java.type("java.nio.file.StandardCopyOption");
      var dep_ddl_path = fs.getPath(ddl_fname+".dep_ddl");
      f.copy(blobStream,dep_ddl_path,CopyOption.REPLACE_EXISTING);

      //format1(dep_ddl_path);

      spool_append_section(section_name, "", ddl_path)

      //Append dep_ddl file to object file.    
      var OpenOption = Java.type("java.nio.file.StandardOpenOption");
      f.write(ddl_path, f.readAllLines(dep_ddl_path), OpenOption.CREATE, OpenOption.APPEND);
 
      //Delete the temp dep_ddl file.
      f.delete(dep_ddl_path);

      }
      catch(err) {
        debug("No dependent objects of type " + dep_ddl_type + " found.")
        //debug(err.message);
    }

}

function append_dependent_ddl(binds, ddl_path, ddl_fname, dep_ddl_type, section_name) {
  //size limit 4000 chars
  var sql_script   = "select to_char(dbms_metadata.get_dependent_ddl('" + dep_ddl_type + "','" + binds.object_name + "','" + binds.owner + "')) ddl from dual;";
  //debug(section_name + sql_script);

  spool_append_section(section_name, sql_script, ddl_path);
 
}
 

function append_granted_ddl(binds, ddl_path, ddl_fname, grant_ddl_type, section_name) {
  //size limit 4000 chars
  var sql_script   = "select to_char(dbms_metadata.get_granted_ddl('" + grant_ddl_type + "','" + binds.object_name + "')) ddl from dual;";
  //debug(section_name + sql_script);

  spool_append_section(section_name, sql_script, ddl_path);
 
} 

 

function append_synonyms(binds, ddl_path, ddl_fname, section_name) {
//spool append synonyms from dba_synonyms

  var sql_script   =  
    "select 'create or replace '"
+ "||case owner"
+ "    when 'PUBLIC' then 'public synonym '"
+ "    else               'synonym '||lower(owner) || '.'"
+ "  end" 
+ "||lower(synonym_name)||' for ' || lower(table_owner) || '.' || lower(table_name)|| decode(db_link,null,null,'@'||db_link)||';' ddl " 
+ "from sys.dba_synonyms where table_name = '" + binds.object_name + "' and table_owner = '" + binds.owner + "';";
  //debug(sql_script);

  spool_append_section(section_name, sql_script, ddl_path);
 
}

function append_sequences(binds, path, fname)  {
  //spool append sequences from user_objects
  //loops through sequences and outputs each sequence with its grants and synonyms, if any.
  
  var section_name = "SEQUENCE";

  //https://stackoverflow.com/questions/18359093/how-to-copy-javascript-object-to-new-variable-not-by-reference
  var seq_binds = JSON.parse(JSON.stringify(binds));

  seq_binds.ddl_type   = 'SEQUENCE';
  seq_binds.table_name = binds.object_name;
 
  seq_ret = util.executeReturnList(
     "select object_name"
  + " from all_objects"
  + " where object_type = :ddl_type" 
  + " and   owner       = :owner"  
     ,seq_binds);
 
 
  //Export each sequence, with its grants and synonyms
  for (j = 0; j < seq_ret.length; j++) {
 
      seq_binds.object_name = seq_ret[j].OBJECT_NAME;

      // Refactored to save TEMP space
      // Is this sequence used on this table? 
      var l_seq_in_col = util.executeReturnOneCol(
                " select 'Y'"
  +             " from  all_col_comments"
  +             " where table_name = :table_name"
  +             " and   owner      = :owner"
  +             " and   regexp_like(comments,:object_name,'i')"
          ,seq_binds);
      //debug('l_seq_in_col: '+ l_seq_in_col + '\n')

      if (l_seq_in_col == "Y") {

        //debug("SEQUENCE FOUND!!");

        //Add DDL for Sequence
        append_ddl(seq_binds, path, fname, section_name);
        //Add grant for sequence
        append_dependent_ddl(seq_binds, path, fname, 'OBJECT_GRANT', '');
        //Add synonym for sequence
        append_synonyms(seq_binds, path, fname, '');
      }
 

   
  }
 
}

 
function spool_with_dbms_metadata(binds) {

 
  sqlcl.setStmt(
 "\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'EMIT_SCHEMA'         , false);"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'PRETTY'              , true );"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'SQLTERMINATOR'       , true );"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'CONSTRAINTS'         , false);"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'REF_CONSTRAINTS'     , false);"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'CONSTRAINTS_AS_ALTER', false);"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES'  , true);"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'STORAGE'             , false);"
+"\nexecute DBMS_METADATA.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM, 'TABLESPACE'          , true);"
);

  sqlcl.run();

  //debug("spool_with_dbms_metadata");
  debug("Spooling DDL for " + binds.ddl_type  + "\t" + binds.object_name);
 
  var fs      = java.nio.file.FileSystems.getDefault();
  var f       = java.nio.file.Files;
 
  if (binds.ddl_type.match(/^(DIRECTORY|ROLE)$/)) {
    //Directories and Roles can only be found by searching without owner, but their dependant_ddl is still owned by SYS.
    var  result = util.executeReturnList(
       "select dbms_metadata.get_ddl(:ddl_type,:object_name) ddl from dual",binds);
  } else {

  //Export DDL removing COLLATION clauses, and EDITIONABLE 
  var  result = util.executeReturnList(
     "select REPLACE(REPLACE(REPLACE("
     + "dbms_metadata.get_ddl(:ddl_type,:object_name,:owner)"
     +   ",' COLLATE \"USING_NLS_COMP\"','')" 
     +   ",' DEFAULT COLLATION \"USING_NLS_COMP\"','')"
     +   ",' EDITIONABLE','') ddl from dual",binds);
  }

  var blobStream =  result[0].DDL.getAsciiStream();
 
  // get the path/file handle to write to
  var fname = binds.DDLfolder + "/" + binds.object_name.toLowerCase() + "." + binds.file_ext;
  var path = fs.getPath(fname);
 
  // dump the file stream to the object file
  var CopyOption = Java.type("java.nio.file.StandardCopyOption");
  f.copy(blobStream,path,CopyOption.REPLACE_EXISTING);
 
  
  if (binds.ddl_type.match(/^(TABLE|VIEW)$/)) {
    //Format the file with only the intial DDL.
    //Format only tables, views. 
    format1(fname);
  }


  if (binds.ddl_type == "TABLE" || binds.ddl_type == "VIEW") {
 
    //INDEX, and CONSTRAINT seem to be included in the table export script already
    if (binds.ddl_type == "TABLE") {
 
      append_indexes(binds, path, fname, 'INDEXES');
      append_dependent_ddl(binds, path, fname, 'CONSTRAINT'    ,'CONSTRAINTS');
      append_dependent_ddl(binds, path, fname, 'REF_CONSTRAINT','REFERENTIAL CONSTRAINTS');
      append_dependent_ddl(binds, path, fname, 'COMMENT'       ,'COMMENTS');

      append_sequences(binds, path, fname);

      append_dependent_ddl(binds, path, fname, 'MATERIALIZED_VIEW_LOG','MVIEW LOGS');

    }
 
    append_big_dep_ddl(binds, path, fname, 'TRIGGER', 'TRIGGERS');

  }


  if (binds.ddl_type == "MATERIALIZED_VIEW") {
    append_mview_logs(binds, path, fname, 'MVIEW LOGS');

  }


  if (binds.ddl_type == "ROLE" ) {

    append_granted_ddl(binds, path, fname, 'ROLE_GRANT', 'GRANTED ROLES');
    append_granted_ddl(binds, path, fname, 'SYSTEM_GRANT', 'GRANTED SYS PRIVS');
    append_granted_ddl(binds, path, fname, 'OBJECT_GRANT', 'GRANTED OBJECTS');
 
  }
 
  if (! binds.ddl_type.match(/^(PACKAGE_BODY|TYPE_BODY|SYNONYM)$/)) {
    //excludes PACKAGE_BODY, TYPE_BODY, SYNONYM
    append_dependent_ddl(binds, path, fname, 'OBJECT_GRANT','GRANTS');
    append_synonyms(binds, path, fname, 'SYNONYMS');
  }

  if (binds.ddl_type.match(/^(MATERIALIZED_VIEW|DIRECTORY|PROCOBJ|SEQUENCE|TYPE|SYNONYM|DB_LINK|ROLE|FUNCTION)$/)) {
    //Format the entire file.
    format1(fname);
  }


}

 

function db_object_query(table_name) {
 
  var l_query =  
   "select object_name"
      + " , object_type "
 + " from  " + table_name + " ao"
 + " where object_type = :object_type"
 + " and object_name like :object_name"
 + " and owner = :owner"
 //These objects are included with other object types.
 + " and object_type not in ('INDEX PARTITION','INDEX SUBPARTITION','LOB','LOB PARTITION','TABLE PARTITION','TABLE SUBPARTITION')" 
 //Ignore system-generated types that support collection processing.
 + " and not (object_type = 'TYPE' and object_name like 'SYS_PLSQL_%')" 
 //Exclude nested tables, their DDL is part of their parent table.
 + " and (owner, object_name) not in (select owner, table_name from all_nested_tables)" 
 //Exclude overflow segments, their DDL is part of their parent table.
 + " and (owner, object_name) not in (select owner, table_name from all_tables where iot_type = 'IOT_OVERFLOW')" 
 //Exclude SEQUENCEs that are included in table exports.
 + " and not exists (select 1 from all_col_comments a"
 +                 " where :object_type = 'SEQUENCE'"
 +                 " and   a.owner = :owner" 
 +                 " and   regexp_like(a.comments,ao.object_name,'i'))"
 //Exclude TABLEs that created by materialized views (but include prebuilt tables).
 + " and not exists (select 1 from ALL_MVIEWS a"
 +                 " where :object_type = 'TABLE'"
 +                 " and   a.mview_name = ao.object_name"
 +                 " and   a.unknown_prebuilt = 'N'"
 +                 " and   a.owner = :owner )"
 + " order by object_name";

  //debug(l_query); 
  
  return l_query;

}



function role_query() {
 
  var l_query =  
   "select role   object_name"
 + "    , 'ROLE' object_type "
 + " from  dba_roles "
 + " where role like :object_name"
 + " order by role";

  //debug(l_query); 
  
  return l_query;

}




debug('Spool Objects\n\n');
 
for(var arg in args) {
       debug(arg + ":" + args[arg]);
}

// Look up a single value to use in a bind later  
var l_user = util.executeReturnOneCol('select user from dual');
debug('User: '+ l_user + '\n')
 
/* simple string or number binds can be a js object */
var binds = {};

binds.db_path       = args[1];
binds.owner_dir     = args[2];
binds.owner         = args[3];
binds.object_type   = args[4].replace('_', ' '); //restore to normal form
binds.object_name   = args[5];
//if (binds.owner_dir == "SYS") {
//  binds.owner = "SYS";
//}
 
//binds.owner         = args[5]; 
//if (typeof(binds.owner) == 'undefined') {
//  binds.owner         = l_user;
//}

debug("binds.owner "+binds.owner);

binds.ddl_type      = binds.object_type; //default
 
binds.DDLfolder = binds.db_path
          + "/" + binds.owner_dir.toUpperCase();

//debug(binds.DDLfolder); 

var ddlPath = java.nio.file.FileSystems.getDefault().getPath(binds.DDLfolder);                  
var files   = java.nio.file.Files;
if ( ! files.exists(ddlPath)) {
    ctx.write("Schema Owner Path not found - creating directory "+binds.DDLfolder); 
    files.createDirectory(ddlPath)
}
 
config_by_object_name(binds); 

binds.DDLfolder = binds.db_path
          + "/" + binds.owner_dir.toUpperCase() 
          + "/generated"; 
 
//debug(binds.DDLfolder);            

ddlPath = java.nio.file.FileSystems.getDefault().getPath(binds.DDLfolder);                  
files   = java.nio.file.Files;
if ( ! files.exists(ddlPath)) {
    ctx.write("'generated' folder not found - creating directory "+binds.DDLfolder); 
    files.createDirectory(ddlPath)
}


if (binds.object_type == "ROLE") {
  //debug("role_query "+role_query);
  ret = util.executeReturnList( role_query() ,binds);
  
} else {

    ret = util.executeReturnList(
       db_object_query("dba_objects")
       ,binds);

    if (ret.length == 0) {
      debug("No results from dba_objects - trying all_objects instead.")
      ret = util.executeReturnList(
         db_object_query("all_objects")
        ,binds);
    }
 
}
 

ctx.write('\n\n');
ctx.write('\n***************************************************************');
ctx.write('\n** Matching User Objects of type '+binds.object_type);
ctx.write('\n***************************************************************');

for (i = 0; i < ret.length; i++) {
  ctx.write( "\n" + ret[i].OBJECT_TYPE  + "\t" + ret[i].OBJECT_NAME );
}
ctx.write('\n***************************************************************');
ctx.write('\n\n');


//Export each object
for (i = 0; i < ret.length; i++) {
    binds.object_type = ret[i].OBJECT_TYPE
    binds.object_name = ret[i].OBJECT_NAME

    //config_by_object_name(binds); 

    //modify the path based on object name and object_type
    if (binds.object_name.endsWith("_TAPI") && binds.object_type.startsWith("PACKAGE")) {
      binds.folder   = "generated/tapis";
    } else if (binds.object_name.endsWith("_AV") && binds.object_type == "VIEW") {
      binds.folder   = "generated/apex_views";
    } else if (binds.object_name.endsWith("_DO_AUDIT") && binds.object_type == "PROCEDURE") {
      binds.folder   = "generated/procedures";
    }  else {
      binds.folder   = binds.default_folder;
    }

    //create the full path, and check it exists.
    binds.DDLfolder = binds.db_path
              + "/" + binds.owner_dir.toUpperCase() 
              + "/" + binds.folder; 
     
    //debug(binds.DDLfolder);            
    
    ddlPath = java.nio.file.FileSystems.getDefault().getPath(binds.DDLfolder);                  
    files   = java.nio.file.Files;
    if ( ! files.exists(ddlPath)) {
        ctx.write("Object Group Path not found - creating directory "+binds.DDLfolder); 
        files.createDirectory(ddlPath)
    }

    //debug(binds.ddl_type); 

    if (binds.ddl_type.match(/^(PROCOBJ|MATERIALIZED_VIEW|TYPE_SPEC|TYPE_BODY|TABLE|VIEW|PACKAGE_SPEC|PACKAGE_BODY|PROCEDURE|FUNCTION|SEQUENCE|JAVA_CLASS|JAVA_SOURCE|DB_LINK|DIRECTORY|SYNONYM|ROLE)$/)) {
      //Many object types do not export correctly via SQLcl DDL command, or it is not possible to control the dependent ddl output.
      //Eg PROCOBJ objects do not seem to be FOUND using the SQLcl DDL command
      spool_with_dbms_metadata(binds);

    } else if (binds.ddl_type == "DATA") {
      //spool a datafile.

      spool_data_file(binds)

    } else {
      //Alternative method, now barely used.
      spool_with_SQLcl( binds );
    }
 
}