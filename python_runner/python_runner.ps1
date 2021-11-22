$PATH = "C:\tmp"
$files = Get-ChildItem $PATH

Write-Output $files

foreach($file in $files){

    $match = Select-String -InputObject $file -Pattern "from"  
    $match | % { $match_string += "$_ "} #Var Type System Array
    
    $pip_imports = ($match -replace "C:|tmp|$files|\\|\d|:|#|from|import", "")
    Write-Output($pip_imports)
}

