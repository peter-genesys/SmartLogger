write-host "ExtractSUNTST01_f104.ps1"
write-host "Commit changes from the Apex 101 application on the VM to local GIT repo"

#Get the current dir
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath 
#write-host $dir
 
#include the ApexExportCommitGIT function  
. ".\ApexExportCommitGIT.ps1" 
 
ApexExportCommit "soraempl002.au.fcl.internal:1521:suntst01"  "LOGGER"  "logger" "104" "$dir" "$dir"
 
read-host "Finished."