#To get the content of a directory you can use
$files = Get-ChildItem "C:\Users\Batmam\Documents\My Files\"

for ($i=0; $i -lt $files.Count; $i++) {
  $outfile = $files[$i].FullName 
}
