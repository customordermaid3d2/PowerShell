[string[]]$Paths = @(
'BepInEx\plugins\', 
'scripts\', 
'Sybaris\', 
'Sybaris\UnityInjector\'
)
[string[]]$files = @(
'Assembly-CSharp-firstpass.dll'
,'Assembly-CSharp.dll'
,'Assembly-UnityScript-firstpass.dll'
,'Boo.Lang.dll'
,'ExIni.dll'
,'FoveUnityPlugin.dll'
,'Ionic.Zlib.dll'
,'JsonFx.Json.dll'
,'Microsoft.Bcl.AsyncInterfaces.dll'
,'System.Buffers.dll'
,'System.Memory.dll'
,'System.Numerics.Vectors.dll'
,'System.Runtime.CompilerServices.Unsafe.dll'
,'System.Text.Encodings.Web.dll'
,'System.Text.Json.dll'
,'System.Threading.Tasks.Extensions.dll'
,'System.ValueTuple.dll'
,'UnityEngine.UI.dll'
,'UnityScript.Lang.dll'
,'Win32.dll'
,'zxing.unity.dll'
)
foreach ($Path in $Paths) { 
	#Write-output "Path : $Path"
		
	foreach ($file in $files) { 
		#Write-output "file : $file"		
		
        if (Test-Path "..\$Path\$file" ){
            Write-output "remove ..\$Path\$file"
		    remove-item "..\$Path\$file"
        }else{
            Write-output "no  ..\$Path\$file"
        }
	}
}

Start-Sleep 5000
