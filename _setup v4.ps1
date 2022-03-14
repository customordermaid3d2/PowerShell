#Requires -Version 3.0

clear
$GameName=$(Get-Item "..\").Name
$date=Get-Date -UFormat "%y%m%d_%H%M%S"
$MakePath="$($GameName)_$date"
$GamePath=$(Get-Item "..\").FullName

if( Test-Path "..\..\$MakePath" ){
    remove-item "..\..\$MakePath" -Recurse -Force | Out-Null
}
New-Item -Path "..\..\$MakePath" -ItemType Directory | Out-Null

#Get-Item "..\" | Select-Object -Property *

$Paths = @{}
$Paths.add("COM3D2x64_Data",@('desktop.ini','output_log.txt'))
$Paths.add("GameData",@('desktop.ini','paths.dat'))
$Paths.add("GameData_20",@('desktop.ini','paths.dat'))
$Paths.add("manual",@('desktop.ini'))
$Paths.add("_cmd",@('desktop.ini'))

foreach ($Path in $Paths.GetEnumerator()) { 
    try {            
        
        Get-ChildItem -Path "..\$($Path.Name)" -exclude $($Path.Value) -Recurse -File |
            ForEach-Object { 'begin' } { 
                $p="..\..\$MakePath$($_.DirectoryName.replace($GamePath,''))"
                if( -not( Test-Path $p ) ){
                    New-Item -Path $p -ItemType Directory | Out-Null
                }
                #$_ | Select-Object -Property *
                New-Item -ItemType HardLink -Path $p -Name $_.Name -Target $_.FullName | Out-Null
            } { 'end' }
    }
    catch { 
        "Err : $($Path.Name)" 
        $_
    }
}

$News = @(
'_setup',
'mod',
'MyRoom',
'PhotoModeData',
'Preset',
'SaveData')

foreach ($Path in $News) { 
    New-Item -Path "..\..\$MakePath\$Path" -ItemType Directory | Out-Null
}

$Paths = @{}
$Paths.add("GameData",@('paths.dat'))
$Paths.add("GameData_20",@('paths.dat'))
$Paths.add("",@(
'setup.ini',
#'update.cfg',
'update.lst',
'uninst.dat',
'uninst.exe',
'COM3D2.exe',
'COM3D2x64.exe'))

foreach ($Path in $Paths.GetEnumerator()) { 
    $p="..\..\$MakePath\_setup\$($Path.Key)"
    if( -not( Test-Path $p ) ){
        New-Item -Path $p -ItemType Directory | Out-Null
    }
    $Path.Value
    Get-ChildItem -Path "..\$($Path.Key)\*" -Include $($Path.Value) -File | Copy-Item -Destination "$p\" -Recurse -Container
}

$Paths = @{}
#$Paths.add("_cmd",@('7z*.*'))
$Paths.add("",@('*.bat','*.cmd'))

foreach ($Path in $Paths.GetEnumerator()) { 
    $p="..\..\$MakePath\$($Path.Key)"
    if( -not( Test-Path $p ) ){
        New-Item -Path $p -ItemType Directory
    }
    Get-ChildItem -Path "..\$($Path.Key)\*" -Include $Path.Value -File | Copy-Item -Destination "$p\" -Recurse -Container
}

Compress-Archive -Path "..\..\$MakePath\_setup\*" -DestinationPath "..\..\$MakePath\_setup.zip" -Force
remove-item "..\..\$MakePath\_setup" -Recurse -Force | Out-Null


New-Item -Force -Path ..\..\$MakePath\COM3D2x64_Data\Pack.dat -ItemType file -Value "$date $GameName"| Out-Null # succ
