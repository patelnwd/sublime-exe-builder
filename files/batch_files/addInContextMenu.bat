@echo off

rem @author Juan Calvopina
rem This script allow you add/remove SublimeText to the contextual menu
rem This batch file was tested on Windows 7

cls

echo +------------------------------------------------------+
echo            SublimeText to the Contextual Menu
echo +------------------------------------------------------+
echo.

set exe_path="<EXE_PATH>"

echo.
echo Adding as Admin
rem add it for all file types
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime"         /t REG_SZ /v "" /d "Open with Sublime"   /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime"         /t REG_EXPAND_SZ /v "Icon" /d "%exe_path%,0" /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime\command" /t REG_SZ /v "" /d "%exe_path% \"%%1\"" /f

rem add it for folders
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime"         /t REG_SZ /v "" /d "Open with Sublime"   /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime"         /t REG_EXPAND_SZ /v "Icon" /d "%exe_path%,0" /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime\command" /t REG_SZ /v "" /d "%exe_path% \"%%1\"" /f
echo Done!
pause
exit /b