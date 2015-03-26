Set-ExecutionPolicy Unrestricted
# 
# Get SQL Server databases. 
# 
$databases = [System.Collections.ArrayList]@()

[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null 

$svr = new-object Microsoft.SqlServer.Management.Smo.Server

foreach ($y in $svr.Databases ) {
    if ($y.Name.Contains("DatabaseNames_")) {
        $databases.Add($y.Name)
    } 
}           
      
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
