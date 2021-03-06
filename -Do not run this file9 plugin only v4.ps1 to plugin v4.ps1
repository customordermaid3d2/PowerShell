#Requires -Version 3.0
$GameName=$(Get-Item "..\").Name
$GamePath="$($GameName)_plugin_"
clear

$date=Get-Date -UFormat "%y%m%d_%H%M%S"
write-host $date

if( Test-Path "..\..\$GamePath$date" ){
	remove-item "..\..\$GamePath$date" -Recurse -Force
}

# 삭제
$Dels = @(
"BepinEx\plugins\UnityExplorer" # 불필??로그
)
#$Dels
foreach ($del in $Dels) { 
	if( (  Test-Path "..\$del") ){
		remove-item  -Path "..\$del"  -Recurse -Force | Out-Null # succ
	}
}

# 폴더 만들기
$folders = @(
'mod\MultipleMaidsPose')

foreach ($Path in $folders) { 

    if( -not(  Test-Path "..\..\$GamePath$date\$($Path)") ){
        New-Item -Path "..\..\$GamePath$date\$($Path)" -ItemType Directory
    }
}


# 하위가지 복사
#$Paths.Clear()
$Paths = @{}
$Paths.add("BepinEx\config\COM3D2.HighHeel\",@('desktop.ini'))
$Paths.add("BepinEx\config\MeidoPhotoStudio\",@('desktop.ini'))
#$Paths.add("BepinEx\config\MeidoPhotoStudio\Database\",@('desktop.ini'))
$Paths.add("BepinEx\core\",@('desktop.ini'))
$Paths.add("BepinEx\patchers\",@('desktop.ini'))
$Paths.add("BepinEx\plugins\",@('desktop.ini','COM3D2.Lilly.Plugin.dll','UnityExplorer.*'))
$Paths.add("BepinEx\Translation\",@('desktop.ini'))
$Paths.add("scripts\",@('desktop.ini','*.bak'))
#$Paths.add('mod\Plugin_mod',@('desktop.ini'))

foreach ($Path in $Paths.GetEnumerator()) { 
	$Path
	Copy-Item -Path "..\$($Path.Name)" -Destination "..\..\$GamePath$date\$($Path.Name)" -Recurse -PassThru -exclude $($Path.Value)| Out-Null
}

# UnityInjector 설정 복사
$Excludes = @{}
$Excludes.add("ACCPresets",@('desktop.ini','*.json'))
$Excludes.add("PngPlacement",@('desktop.ini','*.png','*.png.ppa'))
$Excludes.add("DanceCameraMotion",@('desktop.ini','*.xcf','*.csv','*.anm','*.ogg','*.wav','*.mp4','*.jpg','*.png','*.png.ppa'))

$PathMain="Sybaris\UnityInjector\Config"
$Paths=Get-ChildItem -Path "..\$PathMain" -Directory -Name 
foreach ($Path in $Paths.GetEnumerator()) { 
	$Path
    if( -not(  Test-Path "..\..\$GamePath$date\$($Path.Name)") ){
        New-Item -Path "..\..\$GamePath$date\$($Path.Name)" -ItemType Directory
    }
	if( $Excludes.ContainsKey($Path) ){
		#Write-output "$Path ContainsKey"
        #Get-ChildItem -Path "..\Sybaris\$Path" -Recurse -exclude $Excludes[$Path] -Name
        Copy-Item -Path "..\$PathMain\$Path\" -Destination "..\..\$GamePath$date\$PathMain\$Path" -Recurse -PassThru -exclude $Excludes[$Path] | Out-Null
	}else{
        #Write-output "$Path ContainsKey not"
		#Get-ChildItem -Path "..\Sybaris\$Path" -File -Recurse -exclude @('desktop.ini') 
        Copy-Item -Path "..\$PathMain\$Path\" -Destination "..\..\$GamePath$date\$PathMain\$Path" -Recurse -PassThru -exclude @('desktop.ini') | Out-Null
    }
}

# UnityInjector 제외 복사
Get-ChildItem "..\Sybaris\" -Directory | Where-Object{$_.Name -notin "UnityInjector"} | Copy-Item -Destination "..\..\$GamePath$date\Sybaris\" -Recurse -Force | Out-Null # succ

# 폴더 복사
#$Paths2.Clear()
$Paths2 = @{}
$Paths2.add('Sybaris\UnityInjector\Config',@('desktop.ini','PropMyItem.xml','PropMyItemUser.xml'))
$Paths2.add('Sybaris\UnityInjector',@('desktop.ini'))
$Paths2.add('Sybaris',@('desktop.ini'))
#$Paths2.add('mod\[CMI]Uncensors',@('desktop.ini'))
#$Paths2.add('mod\[CMI]XTFutaAccessories',@('desktop.ini'))
#$Paths2.add('mod\PhotMot_NEI',@('desktop.ini'))
#$Paths2.add('mod\PhotoBG_NEI',@('desktop.ini'))
#$Paths2.add('mod\PhotoBG_OBJ_NEI',@('desktop.ini'))


foreach ($Path in $Paths2.GetEnumerator()) { 
if( -not(  Test-Path "..\..\$GamePath$date\$($Path.Name)") ){
    New-Item -Path "..\..\$GamePath$date\$($Path.Name)" -ItemType Directory
}
    Get-ChildItem "..\$($Path.Name)" -File | Copy-Item -Destination "..\..\$GamePath$date\$($Path.Name)" -Force -exclude $($Path.Value)| Out-Null # succ
}

#New-Item -Path "..\..\$GamePath$date\BepinEx\config" -ItemType Directory

# 파일 복사
$files = @(
'BepinEx\config\AutoTranslatorConfig.ini', 
'BepinEx\config\com.bepis.bepinex.configurationmanager.cfg', 
'BepinEx\config\com.sinai.BepInExConfigManager.cfg', 
'BepinEx\config\org.bepinex.plugins.unityinjectorloader.cfg', 
'BepinEx\config\ShortMenuLoader.cfg', 
'BepinEx\config\SybarisLoader.cfg', 
'BepinEx\config\BepInEx.cfg', 
'BepinEx\config\COM3D2.MaidFlagCtr.Plugin-flags.json', 
'BepinEx\config\COM3D2.MaidFlagCtr.Plugin-flagsOld.json', 
'BepinEx\config\COM3D2.MaidFlagCtr.Plugin-flagsNot.json', 
'Sybaris\UnityInjector\Config\DanceCameraMotion\png\gearicon.png', 
'doorstop_config.ini', 
'winhttp.dll')

foreach ($Path in $files) { 

	Copy-Item -Path "..\$Path" -Destination "..\..\$GamePath$date\$Path" -PassThru -Recurse -Force -Container| Out-Null # succ
}



New-Item -Force -Path ..\..\$GamePath$date\BepInEx\LillyPack.dat -ItemType file -Value "$date $GameName"| Out-Null # succ

Read-Host -Prompt "Press Enter to continue"
