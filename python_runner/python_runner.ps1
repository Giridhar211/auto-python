$PATH = "C:\tmp"
$files = Get-ChildItem $PATH

function Get-Packages{

    foreach($file in $files){
    
        #create Folder for Processing, delete it after usage in script
        New-Item -Path C:\lightrunner -ItemType directory
   
        $match = Select-String -InputObject $file -Pattern "from"  
        $match | % { $match_string += "$_ "} #Var Type System Array

    
        #Remove Illegal Chars and Numbers
        $path_length = $PATH.Length
        $regex_var = $match -replace ("^.{0,$path_length}|$file|:|\d","") | Out-File -Encoding ascii -Append C:\lightrunner\regex_py.json

        #Get Packages
        $lines_txt = Get-Content C:\lightrunner\regex_py.json
        foreach($_ in $lines_txt){
            $package = $_.split()
            Write-Output $package[1]
            #Safe Package Names in pip_packages_py.json file
            $package[1] | Out-File -Encoding ascii -Append C:\lightrunner\pip_packages_py.json
        }
    }
    #Remove-Item -Recurse -Force -Path C:\lightrunner
}
