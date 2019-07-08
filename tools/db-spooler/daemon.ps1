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

#-----------------------------------------------------------
#-- SPOOL DAEMON
#-----------------------------------------------------------

$backgroundColor1 = "Yellow"
$foregroundColor1 = "Black"
$backgroundColor2 = "Black"
$foregroundColor2 = "DarkGreen"


$Host.UI.RawUI.WindowTitle     = "Spool Daemon"
$Host.UI.RawUI.BackgroundColor = "darkgreen"
$Host.UI.RawUI.ForegroundColor = "Gray"

Progress "Spool database objects from pending export requests"
 
# JSON configuration path and filename
$global:BaseDirectory = ".\"
$global:BaseConfig = "env.json"

Debug $BaseDirectory$BaseConfig
Debug "Load and parse the JSON configuration file"

$Config = (Get-Content -Raw -Path "$BaseDirectory$BaseConfig")| ConvertFrom-Json -Verbose
 
$debugging = $Config.debugging

# Check the configuration
if (!($Config)) {
  Warn "The Base configuration file is missing!  Please copy eg-env.json to $BaseConfig, then customise the file."  
}


#Get the current dir
$scriptpath = $MyInvocation.MyCommand.Path
$util_dir = Split-Path $scriptpath 
Debug $util_dir 

 
$caption = "Choose DB Connection";
$message = "Spool Objects from which Schema ?";
 
 
write-host 
#Get queued by user from config file.
$queued_by =  $Config.queued_by
if (!$queued_by) {
  $queued_by = Read-Host "Queued by username? "
}

$queued_by = $queued_by.ToUpper();
$op = "Spooling";

While ($true) {
 
    $caption = "Choose Connection for $op queued by $queued_by";
    
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
  
  #Change current directory to script_dir
  Set-Location -Path $script_dir -PassThru
 
  if (!($owner_dir)) {
    $owner_dir = "$user"
  }
 
  #Set display
  $Host.UI.RawUI.WindowTitle               = "Spooling Database Objects - $env_name";
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
  
    $db_path = "$db_dir"

    #$db_path = Read-Host "Full path to database dir (Default $db_dir)? "
    #if (!($db_path)) {
    #  $db_path = "$db_dir"
    #}
    
    Do {

      $Host.UI.RawUI.BackgroundColor = "Black"
      $Host.UI.RawUI.ForegroundColor = "DarkGray"
      #Using the call operator: &
      #Pipe exit to sqlplus to make the script finish.
      echo "exit;" | & $Config.sqlcl_path "$user/$pword@$connection" "@daemon_to_queue_interface.sql" "$db_path" "$queued_by" "$owner_dir"
    
      write-host
      $Host.UI.RawUI.BackgroundColor = $backgroundColor2
      $Host.UI.RawUI.ForegroundColor = $foregroundColor2

      $cont = Read-Host "Check $user queue for $queued_by again (null to go back)? "

    }
    Until (!($cont))
 
} #outer most

 
 