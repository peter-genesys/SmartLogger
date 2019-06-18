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

function ApexExportCommit ( $CONNECTION ,$USER ,$pword ,$ORIG_APP_ID ,$SCRIPT_DIR, $DBNAME, $SID, $APPS_DIR ) {
           $Host.UI.RawUI.BackgroundColor = "Black"
           $Host.UI.RawUI.ForegroundColor = "DarkGray"

  Debug "ApexExportCommit"

  Debug $chosenApp.new_app_id 
  Debug $chosenApp.orig_app_id 
  Debug $chosenApp.app_name 
  Debug $chosenApp.new_app_alias 
  Debug $chosenApp.orig_app_alias 
  Debug $chosenApp.env_name 
  Debug $chosenApp.promo 
 
  Debug $SCRIPT_DIR  
  Debug $CONNECTION
  Debug $USER      
  Debug $pword  
  Debug $ORIG_APP_ID    
  Debug $APPS_DIR  
  Debug $DBNAME    
  Debug $SID
 
  Debug "APEX file export and commit - uses ApexSplitExport.sql"

  ## SET EXPORT APP_ID
  ## ------------- 
  $NEW_APP_ID = $chosenApp.new_app_id
  if (!($NEW_APP_ID)) { #new_app_id is not mandatory
    #new app_id is not given, so prompt the user.
    $NEW_APP_ID = Read-Host "To export with Original Ids to ORIGINAL APP $ORIG_APP_ID, enter the CURRENT APP to export from? (null for normal export)"
  }
  if ($NEW_APP_ID -eq $ORIG_APP_ID) {
    #new and orig are the same, so nothing to do.
    Debug "No change of app id"
    $NEW_APP_ID = ""
    $EXPORT_APP_ID = $ORIG_APP_ID
  } 


  if ($NEW_APP_ID ) {
    Info "Setting Export App Id to $NEW_APP_ID"
    $EXPORT_APP_ID = $NEW_APP_ID

    Debug "Exporting from current App $EXPORT_APP_ID to orginal App $ORIG_APP_ID"
    $APP_TEMP = "f$EXPORT_APP_ID"
    $APP = "f$ORIG_APP_ID"
    $APP_SQL = "f$EXPORT_APP_ID.sql"
    $UNCLEAN_SQL = "f$ORIG_APP_ID.unclean.sql"

  } else {
    Debug "Exporting from orginal App $ORIG_APP_ID"
    $APP = "f$ORIG_APP_ID"
    $APP_SQL = "f$ORIG_APP_ID.sql"
    $UNCLEAN_SQL = "f$ORIG_APP_ID.unclean.sql"
  }
 
 
  Debug "Remove the application directory $APPS_DIR\$APP" 
  Remove-Item -Recurse -Force -ErrorAction 0 @("$APPS_DIR\$APP")          #Remove application dir - apps dir
  Debug "Remove old unclean export files"
  Remove-Item -Recurse -Force -ErrorAction 0 @("$APPS_DIR\$APP_SQL")      #Remove app export file - apps dir
  Remove-Item -Recurse -Force -ErrorAction 0 @("$APPS_DIR\$UNCLEAN_SQL")  #Remove app export file - apps dir - unclean name    
 
  if ($NEW_APP_ID) {
 
    Warn "YOU ARE EXPORTING f$EXPORT_APP_ID AND COMMITTING APP AS ORIGINAL $APP IN GIT"

    #Pipe EXPORT_APP_ID to ApexSplitExport as param 
    echo "$EXPORT_APP_ID" | & $Config.sqlcl_path "$user/$pword@$connection" "@$SCRIPT_DIR\ApexSplitExportOrigIds.sql" 
    #Move from current app folder to original app folder.
    Debug "Rename $APPS_DIR\$APP_TEMP to $APP"
    Rename-Item -path $APPS_DIR\$APP_TEMP -newName $APP
 
  } else {
    Debug "Exporting and splitting the Apex App $EXPORT_APP_ID FROM $DBNAME"

    #Pipe EXPORT_APP_ID to ApexSplitExport as param 
    echo "$EXPORT_APP_ID" | & $Config.sqlcl_path "$user/$pword@$connection" "@$SCRIPT_DIR\ApexSplitExport.sql" 

  }

 
  #Move full export to apps dir
  Debug "Move full export to apps dir"
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

  Debug "InstallApexApp"

  Debug $chosenApp.new_app_id 
  Debug $chosenApp.orig_app_id 
  Debug $chosenApp.app_name 
  Debug $chosenApp.new_app_alias 
  Debug $chosenApp.orig_app_alias 
  Debug $chosenApp.env_name 
  Debug $chosenApp.promo 


  $APP_ID = $chosenApp.orig_app_id
 
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

 
  ## SET WORKSPACE
  ## ------------- 
  if ($WORKSPACE) {
    Info "Importing $APP into Database $dbname and Workspace $WORKSPACE"
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
end; 
/
"@
  } else {  
    Info "Importing $APP into Database $dbname"
  }


  ## SET APP_ID
  ## ------------- 
  $NEW_APP_ID = $chosenApp.new_app_id
  if (!($NEW_APP_ID)) {
    #new app_id is not given, so prompt the user.
    $NEW_APP_ID = Read-Host "To import with a new app_id, enter a New Apex App No. (null for original)"
  }
  if ($NEW_APP_ID -eq $chosenApp.orig_app_id) {
    #new and orig are the same, so nothing to do.
    Debug "No change of app id"
    $NEW_APP_ID = ""
  } 
  if ($NEW_APP_ID ) {
    Info "Setting App Id to $NEW_APP_ID"
$install_mod = @"
$install_mod
begin 
 apex_application_install.set_application_id($NEW_APP_ID); 
 apex_application_install.generate_offset; 
end;  
/
"@
  }

  ## SET APP_ALIAS
  ## ------------- 
  $NEW_APP_ALIAS = $chosenApp.new_app_alias
  if (!($NEW_APP_ALIAS)) {
    #new app_alias is not given, so prompt the user.
    $NEW_APP_ALIAS = Read-Host "To import with a new app_alias, enter a New Apex Alias. (null for original)"
  }
  if ($NEW_APP_ALIAS -eq $chosenApp.orig_app_alias) {
    #new and orig are the same, so nothing to do.
    Debug "No change of app alias"
    $NEW_APP_ALIAS = ""
  } 
  if ($NEW_APP_ALIAS ) {
    Info "Setting App ALIAS to $NEW_APP_ALIAS"
$install_mod = @"
$install_mod
begin 
  apex_application_install.set_application_alias('$NEW_APP_ALIAS'); 
end; 
/
"@
  }

  ## SET SINGLE PAGE OR FULL APP
  ## ---------------------------
  $APP_PAGE_ID = Read-Host "For a single page import - enter Page No. (null for Full import)"

  if ($APP_PAGE_ID) {
   Info "Installing just page $APP_PAGE_ID"
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
   Info "Installing full app "
 $install_mod = @"
$install_mod
@install.sql
"@
   }
 
 
  ## CONFIRM START
  ## -------------
  If (Test-Path "$APPS_DIR\$APP"){
    If (Test-Path "$APPS_DIR\$APP\install.sql"){
        Info "Ready to import $APP into $DBNAME"
   
        if ($NEW_APP_ID) {
          Warn "YOU ARE ABOUT TO IMPORT $APP AND TO OVERWRITE NEW APP $NEW_APP_ID IN $DBNAME"
        } else {
          
          if ($APP_PAGE_ID) {
            $APP_PAGE_ID_FORMATTED=([string]$APP_PAGE_ID).PadLeft(5,'0')
            Warn "YOU ARE ABOUT TO IMPORT PAGE $APP_PAGE_ID_FORMATTED for APP $APP TO OVERWRITE THE PAGE IN $DBNAME"
          } else {
            Warn "YOU ARE ABOUT TO IMPORT $APP AND OVERWRITE SAME APP $APP IN $DBNAME"
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
 
           $install_mod | Set-Content 'install_mod.sql' 
 
           #Using the call operator: &
           #Pipe exit to sqlplus to make the script finish.
           Debug "echo exit; | & $SQLCL_PATH $user/$pword@$connection @install_mod.sql"
           echo "exit;" | & "$SQLCL_PATH" "$user/$pword@$connection" "@install_mod.sql"
 

          ##} else {
          ##  #Using the call operator: &
          ##  #Pipe exit to sqlplus to make the script finish.
          ##  echo "exit;" | & "$SQLCL_PATH" "$user/$pword@$connection" "@install.sql"

          ##}

 
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
 
    if (($app.promo -eq $promo_name) -or !($app.promo)  ) {
 
      if (($app.new_app_id) -and ($app.orig_app_id -ne $app.new_app_id)) {
        $line = $app.orig_app_id + " " + $app.app_name + " - In $promo_name uses APP_ID => " + $app.new_app_id
      } else {
        $line = $app.orig_app_id + " " + $app.app_name
      }

      Info $line
    }
  }
 
  write-host
  $appno = Read-Host "$op which Apex App - Apex App No? (null to quit) "
  if (!($appno)) {
      Break
  }

  $level = $null;
 
  foreach ($app in $Config.apps) {
    if ($app.orig_app_id -eq $appno) { 
      Debug "app.orig_app_id=" + $app.orig_app_id
      if (($app.promo -eq $promo_name) -or !($app.promo)  ) {
        Debug "Found known app $appno";
        Debug "app.env_name $app.env_name"
        $chosenApp = $app
        $count = -1; 
        foreach ($env in $envs) {
          Debug "env.env_name $env.env_name"
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
  }

  Debug $chosenApp.new_app_id 
  Debug $chosenApp.orig_app_id 
  Debug $chosenApp.app_name 
  Debug $chosenApp.new_app_alias 
  Debug $chosenApp.orig_app_alias 
  Debug $chosenApp.env_name 
  Debug $chosenApp.promo 

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
  Debug "App No=$appno"

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