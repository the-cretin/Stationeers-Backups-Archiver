@echo off
setlocal enableDelayedExpansion
title Stationeer's Backup Archiver 1.2 - By Spunky

@rem Made by: spunky
@rem Feedback: find me on stationeers discord!
@rem Date-and-time-stamp sourced from: https://stackoverflow.com/a/23476347

@rem =======
@rem README:  

@rem Description: This can be used to make compressed archives of your save files. Use In conjunction with 7-Zip Command Line Version (7za.exe) and Task Scheduler.

@rem Warning: 7 Zip is a  cpu hog and compressing files is slow.  To avoid disrupting game's server performance, it is recommended to assign an alternate cpu core for this process. An Affinity Mask of "1" is applied to assign a single cpu core for the task.
@rem Affinity Mask of 1 will use CPU Core 0 /or/ hyperthreaded cpus will be LOGICAL THREAD 0.  Please be aware and adjust the affinity mask if needed.
@rem Affinity Mask Calculator: http://www.gatwick-fsg.org.uk/affinitymask.aspx?SubMenuItem=utilties
@rem Once you have calculated your Affinity Mask, convert that integer to Hexadecimal by using google.
@rem To disable this feature set AffinityMask="0"  (Warning: disabling this will hog the cpu on all available cores it is recommended to choose an unused cpu thread.)

@rem Instructions: 

@rem This process requires 7-Zip Command Line Version (7za.exe): https://www.7-zip.org/download.html

@rem You need only to update the Input variables...

@rem Step 1: Adjust Affinity Mask if needed

@rem Step 2: The variable 7zDir needs to match your path to the executible 7za.exe

@rem Step 3: ServerDir variable needs to point to the root of your server

@rem Step 4: WorldName variable must match the name your world's name.

@rem Step 5: Schedule this .bat file to run via Task Scheduler.

@rem ENJOY!
@rem =======


@rem |Input|
set /a AffinityMask=1
set 7zDir="C:\7zConsole"
set ServerDir="C:\Stationeers Server Folder"
set WorldName="My World Name"
@rem |End of Input|


@rem Initialization & Execution

@rem DO NOT EDIT BEYOND HERE


cd /d %ServerDir%

if exist "%ServerDir:"=%\Archives" goto step2
mkdir "%ServerDir:"=%\Archives"
:step2

if exist "%ServerDir:"=%\Archives\%WorldName:"=%" goto step3
mkdir "%ServerDir:"=%\Archives\%WorldName:"=%"
:step3

set ArchiveDir="%ServerDir:"=%\Archives\%WorldName:"=%"
set BackupDir="%ServerDir:"=%\saves\%WorldName:"=%\Backup"

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%"

set FileName="%WorldName:"=%_%MM%-%DD%-%YY%_%HH%-%Min%.7z"
echo Archiving your save games!
echo #Debug
echo From: %BackupDir%
echo To: %ArchiveDir%
echo 7z directory: !7zDir!
echo Filename: %FileName%
echo #Debug
echo Please wait while the file is being compressed.  This might take a while...

@rem Compressing...

cd !7zDir!

if %AffinityMask%==0 (
	start /w "Zip Debug" "7za" a -mx7 %FileName% %BackupDir%
) else (
	start /w /affinity %AffinityMask% "Zip Debug" "7za" a -mx7 %FileName% %BackupDir%
)

echo Done compressing but wait. We still need to relocate the newly made archive. Please Wait...
timeout 14

echo Moving zip file to Archive folder...
move %FileName% %ArchiveDir%
timeout 3

cls
echo Exiting...
timeout 3
endlocal
@exit