# https://superuser.com/a/1648105/1675831

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
    exit
}

Set-Location "$workingDirOverride"
##### END ELEVATE TO ADMIN #####

# Add actual commands to be executed in elevated mode here:
Write-Output "I get executed in an admin PowerShell"


$GameName=$(Get-Item "..\").Name

if( -not( Test-Path '..\SaveData' )){
	New-Item -ItemType SymbolicLink -Path "..\" -Name 'SaveData' -Target "..\..\COM3D2_plugin\$GameName-SaveData"
}

if( -not( Test-Path '..\mod\`[YotogiAnywhere`]' )){
	New-Item -ItemType SymbolicLink -Path "..\mod\" -Name '[YotogiAnywhere]' -Target '..\..\COM3D2_plugin\`[YotogiAnywhere`]'
}

if( -not( Test-Path "..\mod\Plugin_mod" )){
	New-Item -ItemType SymbolicLink -Path "..\mod\" -Name "Plugin_mod" -Target "..\..\COM3D2_plugin\Plugin_mod"
}

if( -not( Test-Path "..\Sybaris\UnityInjector\Config\DanceCameraMotion" )){
	New-Item -ItemType SymbolicLink -Path "..\Sybaris\UnityInjector\Config\" -Name "DanceCameraMotion" -Target "..\..\COM3D2_plugin\DanceCameraMotion"
}

if( -not( Test-Path "..\i18nEx" )){
	New-Item -ItemType SymbolicLink -Path "..\" -Name "i18nEx" -Target "..\..\COM3D2_plugin\i18nEx"
}

if( -not( Test-Path "..\IMGUITranslationLoader" )){
	New-Item -ItemType SymbolicLink -Path "..\" -Name "IMGUITranslationLoader" -Target "..\..\COM3D2_plugin\IMGUITranslationLoader"
}

if( -not( Test-Path "..\PhotoModeData" )){
	New-Item -ItemType SymbolicLink -Path "..\" -Name "PhotoModeData" -Target "..\..\COM3D2_plugin\PhotoModeData"
}

if( -not( Test-Path "..\Preset" )){
	New-Item -ItemType SymbolicLink -Path "..\" -Name "Preset" -Target "..\..\COM3D2_plugin\Preset"
}

#Read-Host "End"
