write-host "ExtractVM_f101.ps1"
write-host "Commit changes from the Apex 101 application on the VM to local GIT repo"

#Get the current dir
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath 
#write-host $dir
 
#include the ApexExportCommitGIT function  
. ".\ApexExportCommitGIT.ps1" 
 
ApexExportCommit "10.10.10.12:1521:ORCL"  "LOGGER"  "logger" "104" "$dir" "$dir"
 
read-host "Finished."