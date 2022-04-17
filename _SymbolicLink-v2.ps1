# https://superuser.com/a/1648105/1675831

# 아래 명령어 관리자 권한으로 실행 필요
# Set-ExecutionPolicy RemoteSigned

#### START ELEVATE TO ADMIN #####
param(
    [Parameter(Mandatory=$false)]
    [switch]$shouldAssumeToBeElevated,

    [Parameter(Mandatory=$false)]
    [String]$workingDirOverride
)

# If parameter is not set, we are propably in non-admin execution. We set it to the current working directory so that
#  the working directory of the elevated execution of this script is the current working directory
if(-not($PSBoundParameters.ContainsKey('workingDirOverride')))
{
    $workingDirOverride = (Get-Location).Path
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# If we are in a non-admin execution. Execute this script as admin
if ((Test-Admin) -eq $false)  {
    if ($shouldAssumeToBeElevated) {
        Write-Output "Elevating did not work :("

    } else {
        #                                                         vvvvv add `-noexit` here for better debugging vvvvv 
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -shouldAssumeToBeElevated -workingDirOverride "{1}"' -f ($myinvocation.MyCommand.Definition, "$workingDirOverride"))
    }
    #Read-Host "End"
    exit
}

Set-Location "$workingDirOverride"
##### END ELEVATE TO ADMIN #####

# Add actual commands to be executed in elevated mode here:
Write-Output "I get executed in an admin PowerShell"

# ====== 작업 부분 ====== 

$GameName=$(Get-Item "..\").Name
$tg="..\..\COM3D2_plugin"

# 심볼릭링크 표준화
function SymbolicLinkMake {
    param (
        $kp
    )
    #"======SymbolicLinkMake st========"
    $nm=$kp.name
    $p0=$kp.Value[0]+"\"+$kp.name
    $p1=$kp.Value[0]
    if ( $kp.Value.count -ge 2 )
    {
        $p2=$tg+"\"+$kp.Value[1]
    }else{
        $p2=$tg+"\"+$nm
    }
    #Write-Output $kp
    #$kp.Value.count
    #$nm
    #$p0
    #$p1
    #$p2

    if( -not( Test-Path -LiteralPath "$p0" )){
       New-Item -ItemType SymbolicLink ([WildcardPattern]::Escape("$p1")) -Name "$nm" -Target ([WildcardPattern]::Escape("$p2"))
    }else{
        "already $nm"
    }
    #"======SymbolicLinkMake ed========"
}
#
## 헤쉬 테이블
$Paths = @{}
$Paths.add("SaveData",@('..\',"$GameName-SaveData"))
$Paths.add("[YotogiAnywhere]",@('..\mod\'))
$Paths.add("Plugin_mod",@('..\mod\'))
$Paths.add("MultipleMaidsPose",@('..\mod\'))
$Paths.add("DanceCameraMotion",@('..\Sybaris\UnityInjector\Config\'))
$Paths.add("PngPlacement",@('..\Sybaris\UnityInjector\Config\'))
$Paths.add("MeidoPhotoStudio",@('..\BepinEx\Config\'))
$Paths.add("i18nEx",@('..\'))
$Paths.add("IMGUITranslationLoader",@('..\'))
$Paths.add("PhotoModeData",@('..\'))
$Paths.add("Preset",@('..\'))
$Paths.add("_vmd",@('..\'))
#
foreach ($Path in $Paths.GetEnumerator()) { 
    try {
        SymbolicLinkMake $Path
    }
    catch { 
        "Err : $($Path.Name)" 
        $_
    }
}


# if( -not( Test-Path '..\SaveData' )){
#   New-Item -ItemType SymbolicLink -Path "..\" -Name 'SaveData' -Target "..\..\COM3D2_plugin\$GameName-SaveData"
# }
# 
# if( -not( Test-Path '..\mod\`[YotogiAnywhere`]' )){
#   New-Item -ItemType SymbolicLink -Path "..\mod\" -Name '[YotogiAnywhere]' -Target '..\..\COM3D2_plugin\`[YotogiAnywhere`]'
# }
# 
# if( -not( Test-Path "..\mod\Plugin_mod" )){
#   New-Item -ItemType SymbolicLink -Path "..\mod\" -Name "Plugin_mod" -Target "..\..\COM3D2_plugin\Plugin_mod"
# }
# 
# if( -not( Test-Path "..\mod\MultipleMaidsPose" )){
#   New-Item -ItemType SymbolicLink -Path "..\mod\" -Name "MultipleMaidsPose" -Target "..\..\COM3D2_plugin\MultipleMaidsPose"
# }
# 
# if( -not( Test-Path "..\Sybaris\UnityInjector\Config\DanceCameraMotion" )){
#   New-Item -ItemType SymbolicLink -Path "..\Sybaris\UnityInjector\Config\" -Name "DanceCameraMotion" -Target "..\..\COM3D2_plugin\DanceCameraMotion"
# }
# 
# if( -not( Test-Path "..\Sybaris\UnityInjector\Config\PngPlacement" )){
#   New-Item -ItemType SymbolicLink -Path "..\Sybaris\UnityInjector\Config\" -Name "PngPlacement" -Target "..\..\COM3D2_plugin\PngPlacement"
# }
# 
# if( -not( Test-Path "..\BepinEx\config\MeidoPhotoStudio" )){
#   New-Item -ItemType SymbolicLink -Path "..\BepinEx\Config\" -Name "MeidoPhotoStudio" -Target "..\..\COM3D2_plugin\MeidoPhotoStudio"
# }
# 
# if( -not( Test-Path "..\i18nEx" )){
#   New-Item -ItemType SymbolicLink -Path "..\" -Name "i18nEx" -Target "..\..\COM3D2_plugin\i18nEx"
# }
# 
# if( -not( Test-Path "..\IMGUITranslationLoader" )){
#   New-Item -ItemType SymbolicLink -Path "..\" -Name "IMGUITranslationLoader" -Target "..\..\COM3D2_plugin\IMGUITranslationLoader"
# }
# 
# if( -not( Test-Path "..\PhotoModeData" )){
#   New-Item -ItemType SymbolicLink -Path "..\" -Name "PhotoModeData" -Target "..\..\COM3D2_plugin\PhotoModeData"
# }
# 
# if( -not( Test-Path "..\Preset" )){
#   New-Item -ItemType SymbolicLink -Path "..\" -Name "Preset" -Target "..\..\COM3D2_plugin\Preset"
# }
# 
# if( -not( Test-Path "..\_vmd" )){
#   New-Item -ItemType SymbolicLink -Path "..\" -Name "_vmd" -Target "..\..\COM3D2_plugin\_vmd"
# }

Read-Host "End"