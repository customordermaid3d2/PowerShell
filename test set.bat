cd /D %~dp0..\

rmdir Mod\COM3D2_mod

del COM3D2x64_Data\output_log.txt
del BepInEx\LogOutput.log*
del Sybaris\UnityInjector\Config\PropMyItem.xml

md GameData_bak

move /y GameData\*_av*.arc  GameData_bak
move /y GameData\*_denkigai*.arc  GameData_bak
move /y GameData\*_dlc*.arc       GameData_bak
move /y GameData\*_karaoke*.arc   GameData_bak
move /y GameData\*_ordermade*.arc GameData_bak
move /y GameData\*_magazine*.arc    GameData_bak
move /y GameData\*_crshop*.arc    GameData_bak
move /y GameData\*_shop*.arc    GameData_bak
move /y GameData\*_omytgc*.arc    GameData_bak
move /y GameData\*_dance*.arc    GameData_bak
move /y GameData\*_yomeidokanteidan*.arc    GameData_bak
move /y GameData\*_personal_om*.arc    GameData_bak
move /y GameData\*_charaevent*.arc    GameData_bak
move /y GameData\*_oldplus*.arc    GameData_bak
move /y GameData\*_xmas*.arc    GameData_bak
move /y GameData\*_valentine*.arc    GameData_bak
move /y GameData\*_halloween*.arc    GameData_bak
move GameData_20 GameData_20_bak

del update.cfg
del config.xml

rmdir /s /q BepInEx\cache
rmdir /s /q BepInEx\config

md BepInEx\cache
md BepInEx\config

copy /Y ..\COM3D2\BepInEx\config\BepInEx.cfg BepInEx\config
copy /Y ..\COM3D2\BepInEx\config\org.bepinex.plugins.unityinjectorloader.cfg BepInEx\config