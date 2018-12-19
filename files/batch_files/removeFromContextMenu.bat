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
echo Removing all....
rem delete it for admin
@reg delete "HKEY_CLASSES_ROOT\*\shell\Open with Sublime\command" /f >nul 2>&1
@reg delete "HKEY_CLASSES_ROOT\*\shell\Open with Sublime" /f >nul 2>&1

rem delete it for folders
@reg delete "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime\command" /f >nul 2>&1
@reg delete "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime" /f >nul 2>&1

rem delete it for non admin
@reg delete  "HKEY_CURRENT_USER\Software\Classes\*\shell\Open with Sublime\command" /f >nul 2>&1
@reg delete  "HKEY_CURRENT_USER\Software\Classes\*\shell\Open with Sublime" /f >nul 2>&1

echo Done!
exit /b