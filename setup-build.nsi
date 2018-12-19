#-----------------------------------------------------------#
#------------------   Created By Mukesh  -------------------#
#    Contact: 9709557348 [https://facebook.com/patelnwd]    #
#-----------------------------------------------------------#

#----------------------------------------------------------
# set compressor
SetCompressor /SOLID lzma ;Use solid LZMA compression

#---------------------------------------
# Define Global Variables
# --------------------------------------
Var /GLOBAL INST_FOLDER_NAME

#--------------------------------
# Header Files Library
#--------------------------------
!include "MUI2.nsh"
!include "StrRep.nsh"
!include "ReplaceInFile.nsh"

#-----------------------------------------------------------------------------
# Define constant strings which is require in builing Installer
#-----------------------------------------------------------------------------
!define MEDIA_PATH				"media"
!define EXE_PATH 				"$INSTDIR\sublime_text.exe"

#----------------------- EXE Attributes --------------------------
!define PRODUCT_NAME      	"Sublime Text"
!define /date BUILD_NO		"%m-%Y"
!define COMPANY 			"PatelWorld (http://patelworld.in)"
!define PRODUCT_VERSION   	"1.0.0.0"
!define PUBLISHER         	"${COMPANY}"
!define HOMEPAGE 		"http://patelworld.in"
!define INSTALL_DIR 	    "C:\SublimeText_configured\"
!define PRODUCT_UNINSTALL 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define EXE_FILE_NAME      	"${PRODUCT_NAME} [build-${BUILD_NO}] Setup.exe"

#----------------------------------------------------------------
# Installer's VersionInfo
#----------------------------------------------------------------
VIProductVersion                   "${PRODUCT_VERSION}"
VIAddVersionKey "CompanyName"      "${COMPANY}"
VIAddVersionKey "ProductName"      "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion"   "${PRODUCT_VERSION}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"      "${PRODUCT_VERSION}"
VIAddVersionKey "LegalCopyright"   "Sublime Text | ${PUBLISHER}"
VIAddVersionKey "Publisher"		   "${PUBLISHER}"
VIAddVersionKey "InternalName"     "${PRODUCT_NAME}"
VIAddVersionKey "LegalTrademarks"  "${COMPANY}"
VIAddVersionKey "OriginalFilename" "${EXE_FILE_NAME}"

#---------------------------------------------------
# Local Product Information
#---------------------------------------------------
Name 						"${PRODUCT_NAME}" # Name of the installer (usually the name of the application to install).
BrandingText 				"${COMPANY}"

#---------------------------------------------------------------
# Installer info
#---------------------------------------------------------------
!define EXTRACTING  "Installing:"
!define DESCRIPTION 	"A Sublime Text with minmal configuration to keep all system on same configuration."

#------------------------------------------------------------------
# Installer [EXE] General Congiguration
#------------------------------------------------------------------
OutFile 								"dest\${EXE_FILE_NAME}"
Caption 								"${PRODUCT_NAME} With Configuration" # show on setup title
!define MUI_ICON 						"${MEDIA_PATH}\icon.ico" ;Change the default setup icon.
!define MUI_UNICON 						"${MEDIA_PATH}\icon-uninstall.ico" ;Change the default Unintall Icon to remove program.
!define MUI_WELCOMEFINISHPAGE_BITMAP 	"${MEDIA_PATH}\leftBanner.bmp" ; Change the default Left installation banner
!define MUI_UNWELCOMEFINISHPAGE_BITMAP 	"${MEDIA_PATH}\leftBanner-uninstall.bmp" ; Change the default Left UNinstallation banner

#modern UI configuration
!define MUI_ABORTWARNING
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP 			"${MEDIA_PATH}\headBanner.bmp"
!define MUI_HEADERIMAGE_UNBITMAP 		"${MEDIA_PATH}\headBanner-uninstall.bmp"
!define MUI_FINISHPAGE_RUN 				"${EXE_PATH}"
!define MUI_FINISHPAGE_LINK 			"${HOMEPAGE}"
!define MUI_FINISHPAGE_LINK_LOCATION 	"${HOMEPAGE}"
!define MUI_FINISHPAGE_TEXT 			"${PRODUCT_NAME} successfully Installed with Minimal configuration and plugins."
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateDesktopShortCut

#--------------------------------------------------------------------------
# Define Pages
#--------------------------------------------------------------------------
; installation pages
!insertmacro MUI_PAGE_WELCOME # Welcome to the installer page.
!insertmacro MUI_PAGE_DIRECTORY # In which folder install page.
!insertmacro MUI_PAGE_INSTFILES # Installing page.
!insertmacro MUI_PAGE_FINISH # Finished installation page.
;Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

#--------------------------------------------------------------------------
# Language
#--------------------------------------------------------------------------
!insertmacro MUI_LANGUAGE "English" ;Language Include

#--------------------------------------------------------------------------
# Installation Settings
#--------------------------------------------------------------------------
InstallDir 				"${INSTALL_DIR}" ;Default installation folder
InstallDirRegKey HKLM 	"${PRODUCT_UNINSTALL}" "UninstallString"
ShowInstDetails 		nevershow ;Details while install
ShowUninstDetails 		nevershow ;Details while Unistallation
RequestExecutionLevel 	admin ;request application privileges for Windows

#---------------------------------------------------------------
# Reserve Files
!insertmacro MUI_RESERVEFILE_LANGDLL ;If you are using solid compression this will make installer start faster

#----------------------------------------------------------------
# Installation section started
#----------------------------------------------------------------
Section "Installtion"
	SetOutPath "$INSTDIR" ;Set output path ($OUTDIR) and create it recursively if necessary
    Call setInstFolderName
	# Add/Install Files
	DetailPrint "${EXTRACTING} ${PRODUCT_NAME}"
	SetDetailsPrint listonly

	# Moving ProcessPad to www directory
	; File /r "files\sublime_text_configured\"
	File /r "files\batch_files\"
	File /r "media\icon.ico"
	File /r "media\icon-uninstall.ico"

	# changing token with exe file path
	!insertmacro _ReplaceInFile "$INSTDIR\addInContextMenu.bat"				"<EXE_PATH>"		"${EXE_PATH}"
	!insertmacro _ReplaceInFile "$INSTDIR\removeFromContextMenu.bat"		"<EXE_PATH>"		"${EXE_PATH}"

	# Deleting all unwanted files
	Delete "$INSTDIR\*.old"

	# change Bat file exe path
	; nsExec::Exec "$INSTDIR\addInContextMenu.bat"
	; nsExec::Exec "$INSTDIR\removeFromContextMenu.bat"

	# creating uninstaller
	WriteUninstaller "$INSTDIR\uninstall ${PRODUCT_NAME}.exe"
SectionEnd

#--------------------------------
# Installer Functions
#--------------------------------
Function .onInit
	!insertmacro MUI_LANGDLL_DISPLAY ;Display language selection dialog
FunctionEnd

Function .onGUIEnd
	WriteRegStr HKCU "Software\$(^Name)" "" $INSTDIR ;Store installation folder in registry
	SetOutPath "$INSTDIR"
FunctionEnd

#----------------------------------------------------------------
# Post-Installation section started
#----------------------------------------------------------------
Section "-PostInstalltion"
	;write the installation path into the registry
	WriteRegStr HKCU "SOFTWARE\${PRODUCT_NAME}" "Install_Dir" "$INSTDIR"
	WriteRegStr HKLM "SOFTWARE\${PRODUCT_NAME}" "Install_Dir" "$INSTDIR"
SectionEnd

Function setInstFolderName
    Push "$INSTDIR"
	Push "\"
	Call GetAfterChar
	Pop $R0
	StrCpy $INST_FOLDER_NAME $R0
FunctionEnd


#-----------------------------------------------------
# Creating Desktop and program file shortcuts
#-----------------------------------------------------
Function CreateDesktopShortCut
	CreateDirectory "$SMPROGRAMS\$INST_FOLDER_NAME"
	CreateShortCut "$SMPROGRAMS\$INST_FOLDER_NAME\${PRODUCT_NAME}.lnk" 					"$INSTDIR\sublime_text.exe" 				"" 	"$INSTDIR\icon.ico"
	CreateShortCut "$SMPROGRAMS\$INST_FOLDER_NAME\Uninstall ${PRODUCT_NAME}.lnk" 		"$INSTDIR\uninstall ${PRODUCT_NAME}.exe" 	"" 	"$INSTDIR\icon-uninstall.ico"
	CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" 										"$INSTDIR\sublime_text.exe" 				"" 	"$INSTDIR\icon.ico"
FunctionEnd

#-------------------------------------------------------
# Uninstaller Section started
#-------------------------------------------------------
Section "Uninstall"
	RMDir /r "$SMPROGRAMS\$INST_FOLDER_NAME"
	RMDir /r "$INSTDIR"
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
SectionEnd

Function un.onInit
	!insertmacro MUI_UNGETLANGUAGE ;Get stored language preference
FunctionEnd

Function GetAfterChar
  Exch $0 ; chop char
  Exch
  Exch $1 ; input string
  Push $2
  Push $3
  StrCpy $2 0
  loop:
    IntOp $2 $2 - 1
    StrCpy $3 $1 1 $2
    StrCmp $3 "" 0 +3
      StrCpy $0 ""
      Goto exit2
    StrCmp $3 $0 exit1
    Goto loop
  exit1:
    IntOp $2 $2 + 1
    StrCpy $0 $1 "" $2
  exit2:
    Pop $3
    Pop $2
    Pop $1
    Exch $0 ; output
FunctionEnd