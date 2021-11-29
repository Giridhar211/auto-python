
#Download URL's
$DOWNLOAD_PYTHON = "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe" 
$DOWNLOAD_PYTHON_PIP = "https://github.com/pypa/pip/archive/refs/heads/main.zip" 

#Path with your Python files
$my_path = "C:\tmp"

#create Folder and env for Processing, delete it after usage in script
$LIGHTRUNNER = "$my_path\lightrunner"
if (Get-Item -Path $LIGHTRUNNER){
     Write-Output "Path $LIGHTRUNNER already exists"
}
else{
   New-Item -Path $LIGHTRUNNER -ItemType directory
}


function Install-Python {

    #Download Python
    $webobject = New-Object System.Net.WebClient
    $webobject.DownloadFile($DOWNLOAD_LATEST_PYTHON,"$LIGHTRUNNER\acutualpythonversion.exe")

    #Download Pip Package Installer
    $webobject.DownloadFile($DOWNLOAD_LATEST_PIP,"$LIGHTRUNNER\pip.zip")

    Start-Process -FilePath $LIGHTRUNNER\* -ArgumentList /quiet

}
function Get-Package{

    foreach($file in Get-ChildItem $my_path){

   
        $match = Select-String -InputObject $file -Pattern "from"  
        $match | % { $match_string += "$_ "} #Var Type System Array

    
        #Remove Illegal Chars and Numbers
        $path_length = $PATH.Length
        $regex_var = $match -replace ("^.{0,$path_length}|$file|:|\d","") | Out-File -Encoding ascii -Append "$LIGHTRUNNER\regex_py.json"

        #Get Packages
        $lines_txt = Get-Content "$LIGHTRUNNER\regex_py.json"
        foreach($_ in $lines_txt){
            $package = $_.split()
            Write-Output $package[1]
            #Safe Package Names in pip_packages_py.json file
            $package[1] | Out-File -Encoding ascii -Append "$LIGHTRUNNER\packages_py.txt"
        }
    }
    
}
function Install-Packages{




    
}
#Remove-Item -Recurse -Force -Path C:\lightrunner
Get-Package