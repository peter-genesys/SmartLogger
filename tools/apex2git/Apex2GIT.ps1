function Debug($message) {
  if ($debugging) {
  write-host $message -foregroundcolor "DarkGray" -backgroundcolor "Black"
  }
}

function Note($var, $value) {
  Debug($var + "=" + $value)
}

function Info($message) {
  write-host
  write-host $message -foregroundcolor "Gray" -backgroundcolor "Black"
}

function Warn($message) {
  write-host
  write-warning $message
}

function Progress($message) {
  write-host 
  write-host $message
}

#------------------------
#-- ApexExportCommit
#------------------------

function ApexExportCommit ( $CONNECTION ,$USER ,$pword ,$APP_ID ,$SCRIPT_DIR, $DBNAME, $SID, $APPS_DIR) {
           $Host.UI.RawUI.BackgroundColor = "Black"
           $Host.UI.RawUI.ForegroundColor = "DarkGray"

  Debug $SCRIPT_DIR  
  Debug $CONNECTION
  Debug $USER      
  Debug $pword  
  Debug $APP_ID    
  Debug $APPS_DIR  
  Debug $DBNAME    
  Debug $SID
 
  Debug "APEX file export and commit - uses ApexSplitExport.sql"

  $ORIG_APP_ID = Read-Host "To export with Original Ids, enter the original app_id? (null for current)"
 
  if ($ORIG_APP_ID) {
    $APP = "f$ORIG_APP_ID"
    $APP_SQL = "f$APP_ID.sql"
    $UNCLEAN_SQL = "f$ORIG_APP_ID.unclean.sql"
  } else {
    $APP = "f$APP_ID"
    $APP_SQL = "f$APP_ID.sql"
    $UNCLEAN_SQL = "f$APP_ID.unclean.sql"
  }
 
  Debug "Remove the application directory $APPS_DIR\$APP" 
  Remove-Item -Recurse -Force -ErrorAction 0 @("$APPS_DIR\$APP")          #Remove application dir - apps dir
  Debug "Remove old unclean export files"
  Remove-Item -Recurse -Force -ErrorAction 0 @("$APPS_DIR\$APP_SQL")      #Remove app export file - apps dir
  Remove-Item -Recurse -Force -ErrorAction 0 @("$APPS_DIR\$UNCLEAN_SQL")  #Remove app export file - apps dir - unclean name    
 
  if ($ORIG_APP_ID) {
 
    Warn "YOU ARE EXPORTING f$APP_ID AND COMMITTING APP AS $APP IN GIT"

    #Pipe APP_ID to ApexSplitExport as param 
    echo "$APP_ID" | & $Config.sqlcl_path "$user/$pword@$connection" "@$SCRIPT_DIR\ApexSplitExportOrigIds.sql" 
 
  } else {
    Debug "Exporting and splitting the Apex App $APP_ID FROM $DBNAME"

    #Pipe APP_ID to ApexSplitExport as param 
    echo "$APP_ID" | & $Config.sqlcl_path "$user/$pword@$connection" "@$SCRIPT_DIR\ApexSplitExport.sql" 

  }

 
  #Move full export to apps dir
  Move-Item "$APPS_DIR\$APP_SQL" "$APPS_DIR\$UNCLEAN_SQL"  

  Debug "Extracting App Name from init.sql"
  #Look for this line in the f101/application/init.sql
  #"prompt APPLICATION 9221 - Marketing Reports"
  #Use details in the commit message.
  $env_filename = "$APPS_DIR/$APP/application/init.sql"
  $search = "prompt APPLICATION"
  $pos = $search.length
  $matched_lines = Get-Content "$env_filename" | Select-String "$search" -SimpleMatch
  $matched_line = $matched_lines[0].line
  Debug $matched_line 

  $app_id_name = $matched_line.Substring($pos+1)
  Debug $app_id_name 

  Info "Adding new files to GIT" 
  TortoiseGitProc.exe /command:"add" /path:"$APPS_DIR/$APP"  | Out-Null
   
  Info "Committing changed files to GIT" 
  TortoiseGitProc.exe /command:"commit" /path:"$APPS_DIR/$APP" /logmsg:"""Apex2GIT App $app_id_name - Incremental export from $DBNAME""" /closeonend:1  | Out-Null
  
  Info "Reverting remaining changes from the GIT checkout" 
  TortoiseGitProc.exe /command:"revert" /path:"$APPS_DIR/$APP"

}

#------------------------
#-- InstallApexApp
#------------------------
function InstallApexApp ( $CONNECTION ,$USER ,$pword ,$APP_ID, $DBNAME, $SID, $APPS_DIR, $SQLCL_PATH, $WORKSPACE) {

 
  Debug $CONNECTION
  Debug $USER
  Debug $pword
  Debug $APP_ID
  Debug $APPS_DIR
  Debug $ORACLE_DIR
  Debug $DBNAME
  Debug $SID
  Debug $SQLCL_PATH
  Debug $WORKSPACE
 
  $APP = "f$APP_ID"
  $APP_SQL = "f$APP_ID.sql"
  $SPLIT_SQL = "f$APP_ID.sql"

  if ($WORKSPACE) {
    Info "Importing $APP into Database $dbname and Workspace $WORKSPACE"
    $NEW_APP_ID = Read-Host "Please enter New Apex App No, if required? (null for original)"

    $APP_PAGE_ID = Read-Host "For single page import - enter Page No, if required? (null for full app)"
    
  } else {  
    Info "Importing $APP into Database $dbname"
  }
 
  If (Test-Path "$APPS_DIR\$APP"){
    If (Test-Path "$APPS_DIR\$APP\install.sql"){
        Info "Ready to import $APP into $DBNAME"
        #TODO ifelse below does not yet match that above...
        if ($NEW_APP_ID) {
          Warn "YOU ARE ABOUT TO IMPORT $APP AND OVERWRITE APP $NEW_APP_ID IN $DBNAME"
        } else {
          
          if ($APP_PAGE_ID) {
            $APP_PAGE_ID_FORMATTED=([string]$APP_PAGE_ID).PadLeft(5,'0')
            Warn "YOU ARE ABOUT TO IMPORT PAGE $APP_PAGE_ID_FORMATTED for APP $APP TO OVERWRITE THE PAGE IN $DBNAME"
          } else {
            Warn "YOU ARE ABOUT TO IMPORT $APP AND OVERWRITE APP $APP IN $DBNAME"
          }
        }
        write-host
        $confirmation = Read-Host "Are you Sure You Want To Proceed"
        if ($confirmation -eq 'y') {
 
           Progress "Ok - Importing ..."
           write-host
           Set-Location "$APPS_DIR\$APP"

           $Host.UI.RawUI.BackgroundColor = "Black"
           $Host.UI.RawUI.ForegroundColor = "DarkGray"

           if ($WORKSPACE) {
            
             Info "Writing to workspace $WORKSPACE"

             if ($NEW_APP_ID) {

               #Set the Workspace, schema, app_id and app_alias
#TODO - rationalise the code below using new technique
$install_mod = @"
declare 
 v_workspace_id NUMBER; 
begin 
 select workspace_id into v_workspace_id 
 from apex_workspaces where workspace = '$WORKSPACE'; 
 apex_application_install.set_workspace_id (v_workspace_id); 
 apex_util.set_security_group_id 
 (p_security_group_id => apex_application_install.get_workspace_id); 
 apex_application_install.set_schema('$USER'); 
 apex_application_install.set_application_id($NEW_APP_ID); 
 apex_application_install.generate_offset; 
 apex_application_install.set_application_alias('F$NEW_APP_ID'); 
end; 
/
"@

             } else {

               #Set the Workspace and schema only.

$install_mod = @"
declare 
 v_workspace_id NUMBER; 
begin 
 select workspace_id into v_workspace_id 
 from apex_workspaces where workspace = '$WORKSPACE'; 
 apex_application_install.set_workspace_id (v_workspace_id); 
 apex_util.set_security_group_id 
 (p_security_group_id => apex_application_install.get_workspace_id); 
 apex_application_install.set_schema('$USER'); 
 --apex_application_install.set_application_id($NEW_APP_ID); 
 --apex_application_install.generate_offset; 
 --apex_application_install.set_application_alias('F$NEW_APP_ID'); 
end; 
/
"@
             }


          if ($APP_PAGE_ID) {
 
$install_mod = @"
$install_mod
@application\init.sql;
prompt --application/pages/delete_$APP_PAGE_ID_FORMATTED
begin
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>$APP_PAGE_ID);
end;
/
@application\pages\page_$APP_PAGE_ID_FORMATTED;
@application\end_environment.sql;
"@

          } else {
 $install_mod = @"
$install_mod
@install.sql
"@
          }
 

$install_mod | Set-Content 'install_mod.sql' 
 
           #Using the call operator: &
           #Pipe exit to sqlplus to make the script finish.
           Debug "echo exit; | & $SQLCL_PATH $user/$pword@$connection @install_mod.sql"
           echo "exit;" | & "$SQLCL_PATH" "$user/$pword@$connection" "@install_mod.sql"
 

           } else {
             #Using the call operator: &
             #Pipe exit to sqlplus to make the script finish.
             echo "exit;" | & "$SQLCL_PATH" "$user/$pword@$connection" "@install.sql"

           }

 
        } else {
          Info "User cancelled import."
        }
      } else { 
        Warn "Could not find $APPS_DIR\$APP\install.sql"
      }
  } else { 
    Warn "Could not find App dir $APPS_DIR\$APP"
  }
 
}

 
# --------------------------------------------------------------------------------------
Debug "Apex2GIT.ps1"
# --------------------------------------------------------------------------------------

$Host.UI.RawUI.WindowTitle     = "APEX-2-GIT"
$Host.UI.RawUI.BackgroundColor = "darkgreen"
$Host.UI.RawUI.ForegroundColor = "Gray"


$backgroundColor1 = "Yellow"
$foregroundColor1 = "Black"
$backgroundColor2 = "Black"
$foregroundColor2 = "DarkGreen"


# JSON configuration path and filename
$global:BaseDirectory = ".\"
$global:BaseConfig = "env.json"

Debug $BaseDirectory$BaseConfig
Debug "Load and parse the JSON configuration file"

$Config = (Get-Content -Raw -Path "$BaseDirectory$BaseConfig")| ConvertFrom-Json -Verbose
 
$debugging  = $Config.debugging
$sqlcl_path = $Config.sqlcl_path;

# Check the configuration
if (!($Config)) {
  Warn "The Base configuration file is missing!"  
}

#Get the current dir
$scriptpath = $MyInvocation.MyCommand.Path
$util_dir = Split-Path $scriptpath 
Debug $util_dir 

#create empty choice array
[System.Management.Automation.Host.ChoiceDescription[]]$operationLevel = @()
#read each choice from the config file
$operationLevel += new-Object System.Management.Automation.Host.ChoiceDescription "&Exporting","Export Apex Apps from the Database";    
$operationLevel += new-Object System.Management.Automation.Host.ChoiceDescription "&Importing","Import Apex Apps into the Database";   

write-host
$level = $host.ui.PromptForChoice("Apex-2-Git","Exporting or Importing?",$operationLevel,0)

if ($level -eq 0) {
  $op = "Export"

  $Host.UI.RawUI.WindowTitle     = "$op Apex Apps"
  $Host.UI.RawUI.BackgroundColor = "darkgreen"
  $Host.UI.RawUI.ForegroundColor = "Gray"

  Progress "Export Apex App from DB and Commit changes to Split Apex App in local GIT repo"

} else {
  $op = "Import"

  $Host.UI.RawUI.WindowTitle     = "$op Apex Apps"
  $Host.UI.RawUI.BackgroundColor = "darkMagenta"
  $Host.UI.RawUI.ForegroundColor = "Gray"
 
  Progress "Import Split Apex App into DB from local GIT repo"
}
 

 
While ($true) {

  $caption = "Choose Connection for $op";
  
  $message = "Which promotion level?";
  
  #create empty choice array
  [System.Management.Automation.Host.ChoiceDescription[]]$promosLevel = @()
  #read each choice from the config file
  foreach ($promo in $Config.promos) {
      $promosLevel += new-Object System.Management.Automation.Host.ChoiceDescription $promo.choice_label,$promo.choice_help;    
  }
  
  write-host
  $level = $host.ui.PromptForChoice($caption,$message,$promosLevel,$Config.default_promo)
  
  $promo = $Config.promos[$level]
  
  $promo_name = $promo.promo_name
  
  #Choose env based on promo level
  if ($promo_name -eq "VM") {
    $envs = $Config.envs_vm;
  } elseif ($promo_name -eq "DEV") {
    $envs = $Config.envs_dev;
  } elseif ($promo_name -eq "TEST") {
    $envs = $Config.envs_test;
  } elseif ($promo_name -eq "UAT") {
    $envs = $Config.envs_uat;
  } elseif ($promo_name -eq "PAT") {
    $envs = $Config.envs_pat;
  } elseif ($promo_name -eq "PROD") {
    $envs = $Config.envs_prod;
  }  
  
  Debug $envs
   
  Info "Known apps"
  foreach ($app in $Config.apps) {
    $line = $app.app_id + " " + $app.app_name
    Info $line
  }
 
  write-host
  $appno = Read-Host "$op which Apex App - Apex App No? (null to quit) "
  if (!($appno)) {
      Break
  }

  $level = $null;
 
  foreach ($app in $Config.apps) {
    if ($app.app_id -eq $appno){
      Debug "Found known app $appno";
      $count = -1; 
      foreach ($env in $envs) {
        #First index will be 0
        $count = $count + 1;  
        if ($env.env_name -eq $app.env_name) {
          Debug "Found env";
          $level = $count;
          Debug $level  
        }
      }
    }
  }

  if ($level -eq $null) {

    Info "Please choose a connection for this unknown App"

    #create empty choice array
    [System.Management.Automation.Host.ChoiceDescription[]]$choicesLevel = @()
    #read each choice from the config file
    foreach ($env in $envs) {
        $choicesLevel += new-Object System.Management.Automation.Host.ChoiceDescription $env.choice_label,$env.choice_help;    
    }
     
    $caption = "Choose Connection for $promo_name";
    $message = "Which schema?";
    
    write-host
    $level = $host.ui.PromptForChoice($caption,$message,$choicesLevel,$Config.default_env)
 
  }

  #Get the chosen environment config 
  $env = $envs[$level]
 
  #Copy to simple vars
  $env_name   = $env.env_name;
  $connection = $env.connection;
  $sid        = $env.sid;
  $dbname     = $env.dbname;
  $user       = $env.user;
  $pword      = $env.pword;
  $owner_dir  = $env.owner_dir;
  $db_dir_rel = $env.db_dir_rel;
  $apps_dir_rel = $env.apps_dir_rel;
  $workspace  = $env.workspace;
 
  Debug $connection
 
  #Use relative DB path, if absolute DB path is null 
  $db_dir   = $env.db_dir;
  if (!$db_dir) {
    $db_dir = "$util_dir/$db_dir_rel";  
  }  
  Debug $db_dir 
  
  $apps_dir   = $env.apps_dir;
  $apps_dir_rel = $env.apps_dir_rel;
  
  #Use relative Apps path, if absolute Apps path is null 
  if (!$apps_dir) {
    $apps_dir = "$util_dir/$apps_dir_rel";  
  }  
 
  $apps_dir = "$apps_dir/$owner_dir";
  Debug $apps_dir
  
  
  $script_dir = "$util_dir/script"; 
  
  #Set dir for exported apps, NOT for the scripts themselves.
  #Change current directory to apps_dir
  Set-Location -Path $apps_dir -PassThru
  
  #Set display
  $Host.UI.RawUI.WindowTitle               = "$op Apex Apps - $env_name";
  $Host.PrivateData.WarningBackgroundColor = $backgroundColor1;
  $Host.PrivateData.WarningForegroundColor = $foregroundColor1;

  Info "Now using the $promo_name $env_name connection."
  
  write-host 
  $Host.UI.RawUI.BackgroundColor = $backgroundColor2
  $Host.UI.RawUI.ForegroundColor = $foregroundColor2
  
  While (!$pword) { 
    $response = Read-host "Password for $user in $dbname ?" -AsSecureString
    $pword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))
  }
  
  Debug "App dir=$apps_dir"
  Debug $appno

  if ($op -eq "Export") {
    ApexExportCommit "$connection" "$user" "$pword" "$appno" "$script_dir" "$dbname" "$sid" "$apps_dir"
  } else {
    InstallApexApp "$connection" "$user" "$pword" "$appno" "$dbname" "$sid" "$apps_dir" "$sqlcl_path" "$workspace"
  }



  write-host
  $Host.UI.RawUI.BackgroundColor = $backgroundColor2
  $Host.UI.RawUI.ForegroundColor = $foregroundColor2

}  
 
#read-host "Hit return to close."