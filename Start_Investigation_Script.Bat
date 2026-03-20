@echo off
SETLOCAL EnableDelayedExpansion
title THE BEAST - ULTIMATE JUMP KIT (PRO EDITION)
color 0A

:: [1] ADMINISTRATIVE PRIVILEGE CHECK
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [!] ERROR: PLEASE RUN AS ADMINISTRATOR.
    pause
    exit
)

:: [2] PATHS AND TIMESTAMP SETUP
pushd "%~dp0.."
set "ROOT=%cd%"
popd

for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd_HH-mm'"') do set "TS=%%i"
set "OUT=%ROOT%\04_Evidence\%COMPUTERNAME%_%TS%"

if not exist "%OUT%" mkdir "%OUT%"
if not exist "%OUT%\System" mkdir "%OUT%\System"
if not exist "%OUT%\Malware" mkdir "%OUT%\Malware"
if not exist "%OUT%\Logs" mkdir "%OUT%\Logs"
if not exist "%OUT%\Storage" mkdir "%OUT%\Storage"

:MENU
cls
echo ======================================================
echo             THE BEAST - FINAL INVESTIGATION MENU          
echo ======================================================
echo  TARGET: %COMPUTERNAME%
echo  OUTPUT: %OUT%
echo ======================================================
echo  [1] CAPTURE RAM (DumpIt - 100%% Silent)
echo  [2] RUN TRIAGE (KAPE - Automated Collection)
echo  [3] SYSTEM ^& PREFETCH (Autoruns + PECmd + RECmd)
echo  [4] EVENT LOGS (Hayabusa + Sigma Rules)
echo  [5] MALWARE SCAN (Thor Lite + Custom YARA)
echo  [6] USB HISTORY (USBDeview - Automated Export)
echo  [7] OPEN ANALYSIS TOOLS (GUI Mode - Lab Only)
echo  [8] EXIT
echo ======================================================
echo  * Recommended Order: 1 -> 2 -> 3 -> 4 -> 5
echo ======================================================
set /p choice="> Select Action: "

if "%choice%"=="1" goto ACTION_RAM
if "%choice%"=="2" goto ACTION_KAPE
if "%choice%"=="3" goto ACTION_PERSISTENCE
if "%choice%"=="4" goto ACTION_HAYABUSA
if "%choice%"=="5" goto ACTION_MALWARE
if "%choice%"=="6" goto ACTION_USB
if "%choice%"=="7" goto TOOLS
if "%choice%"=="8" exit
goto MENU

:ACTION_RAM
echo [*] Capturing Physical RAM (Silent Mode)...
pushd "%ROOT%\Step One\Comae-Toolkit-v20230117"
if exist "DumpIt.exe" (
    DumpIt.exe /QUIET /OUTPUT "%OUT%\RAM_Dump.raw"
) else (
    echo [!] Error: DumpIt.exe not found in Comae folder.
)
popd
echo [V] RAM Process Finished.
pause
goto MENU

:ACTION_KAPE
echo [*] Running KAPE Triage (Automated)...
"%ROOT%\Step One\kape\kape.exe" --tsource C: --tdest "%OUT%\KAPE_Out" --tflush --target KapeTriage --quiet
echo [V] KAPE Collection Complete.
pause
goto MENU

:ACTION_PERSISTENCE
echo ======================================================
echo           SYSTEM ANALYSIS (AUTORUNS + PREFETCH)        
echo ======================================================
echo [*] Running Autoruns...
"%ROOT%\Step Two\Autoruns\autorunsc64.exe" -accepteula -a * -c -h > "%OUT%\System\persistence.csv"

echo [*] Parsing Prefetch files (PECmd)...
"%ROOT%\Step Two\PECmd\PECmd.exe" -d "C:\Windows\Prefetch" --csv "%OUT%\System"

echo [*] Processing Registry (RECmd)...
"%ROOT%\Step Two\RECmd\RECmd.exe" -d "C:\Windows\System32\config" --sk "Run" --csv "%OUT%\System"
echo [V] System data collected (Autoruns, Prefetch, Registry).
pause
goto MENU

:ACTION_HAYABUSA
echo ======================================================
echo            EVENT LOG ANALYSIS (HAYABUSA + SIGMA)        
echo ======================================================
echo [*] Analyzing Event Logs...

pushd "%ROOT%\Step Two\hayabusa-3.8.0-win-x64-live-response"
hayabusa.exe csv-timeline --no-wizard --live-analysis --output "%OUT%\Logs\event_timeline.csv"
popd

echo [V] Event logs processed. Check event_timeline.csv.
pause
goto MENU

:ACTION_MALWARE
echo ======================================================
echo            SCANNING FOR MALWARE (THOR + CUSTOM YARA)    
echo ======================================================
echo [*] Starting Thor Lite...

pushd "%ROOT%\Step One\thor-lite-windows_10.7.29"
if exist "thor64-lite.exe" (
    :: Removed --no-update, --silent and --eula as they are not in your help menu.
    :: Using -l for the output log file path.
    thor64-lite.exe -a FileScan -p C:\ -l "%OUT%\Malware\thor_report.txt"
) else (
    echo [!] Error: thor64-lite.exe not found.
)
popd

echo [V] Malware scan finished. Results in Malware folder.
pause
goto MENU

:ACTION_USB
echo ======================================================
echo           USB DEVICE HISTORY COLLECTION                
echo ======================================================
echo [*] Extracting USB connection history...
"%ROOT%\Storage\usbdeview-x64\USBDeview.exe" /scomma "%OUT%\Storage\usb_history.csv"
echo [V] USB History exported to Storage folder.
pause
goto MENU

:TOOLS
cls
echo ======================================================
echo                  EXTERNAL ANALYSIS TOOLS               
echo ======================================================
echo  [1] Timeline Explorer (View CSVs)
echo  [2] FTK Imager Lite (Disk Imaging)
echo  [3] Registry Explorer (Manual Analysis)
echo  [4] Browsing History View
echo  [5] CyberChef (Decode)
echo  [6] Back to Menu
echo ======================================================
set /p t="Select Tool: "
if "%t%"=="1" start "" "%ROOT%\Storage\TimelineExplorer\TimelineExplorer.exe"
if "%t%"=="2" start "" "%ROOT%\Step One\Imager_Lite_3.1.1\FTK Imager.exe"
if "%t%"=="3" start "" "%ROOT%\Storage\RegistryExplorer\RegistryExplorer.exe"
if "%t%"=="4" start "" "%ROOT%\Storage\browsinghistoryview-x64\BrowsingHistoryView.exe"
if "%t%"=="5" start "" "%ROOT%\Storage\CyberChef_v10.22.1\CyberChef_v10.22.1.html"
goto MENU
