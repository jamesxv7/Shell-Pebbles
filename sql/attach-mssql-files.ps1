Set-ExecutionPolicy Unrestricted
# 
# Setup configuration 
#
$filesPath = "D:\database\files\path"
$databases = Get-ChildItem "D:\database\files\path\*" -Include *.MDF
$databasesLog = Get-ChildItem "D:\database\files\path\*" -Include *.LDF

[System.Collections.ArrayList]$logs = $databasesLog

# 
# Get SQL Server database (MDF/LDF). 
# 

ForEach ($database in $databases) 
{ 

	# 
	# Attach SQL Server database 
	# 
    
    $x = @{}
    [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null 
    
    $svr = new-object Microsoft.SqlServer.Management.Smo.Server

    $mdfFilename = $database.name
   
    $DBName = $mdfFilename.Replace("_Data.MDF","")
    
    ForEach ($logfile in $logs) { 
        if ($logfile.name.Contains($DBName)) {
            $ldfFilename = $logfile.name            
            break
        }
    }
    
    $logs.Remove($logfile)

    Add-PSSnapin SqlServerCmdletSnapin* -ErrorAction SilentlyContinue
    
    $attachSQLCMD = "USE [master] 
    CREATE DATABASE [$DBName] ON 
    (FILENAME = N'$filesPath$mdfFilename'), 
    (FILENAME = N'$filesPath$ldfFilename') 
    FOR ATTACH" 
    
    $ldfFilename = [string]::Empty
    
    #write-host $attachSQLCMD
    
    $temp = Invoke-Sqlcmd -query $attachSQLCMD -ServerInstance "localhost" 
          
    If($?)  {  
      Write-Host 'Attaching database' $DBName 'sucessfully!'  
    } else {  
      Write-Host 'Attaching Failed!'  
    }
} 
