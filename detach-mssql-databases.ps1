Set-ExecutionPolicy Unrestricted
# 
# Get SQL Server databases. 
# 

# Initiate $databases variable as an array list
$databases = [System.Collections.ArrayList]@()

# The Microsoft.SqlServer.Smo object is required for this script to work.
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null 
$svr = new-object Microsoft.SqlServer.Management.Smo.Server

# Iterate through databases to generate a list matching only with DatabaseNames_ string. 
foreach ($y in $svr.Databases ) {
    if ($y.Name.Contains("DatabaseNames_")) {
        $databases.Add($y.Name)
    } 
}           

# Iterate through the list to detach only the items in the list. 
foreach ($database in $databases) { 
    #$db = $database[$i].toString()
    
    $attachSQLCMD = "USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'$database'
GO"    
     
    #write-host $attachSQLCMD
    
    $temp = Invoke-Sqlcmd -query $attachSQLCMD -ServerInstance "localhost" 
          
    If($?){  
      Write-Host 'Deattaching database' $database 'sucessfully!'  
    } else {  
      Write-Host 'Deattaching Failed!'  
      Add-PSSnapin SqlServerCmdletSnapin* -ErrorAction SilentlyContinue
    }
}
