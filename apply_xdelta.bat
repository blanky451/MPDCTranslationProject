@echo off
rem  Applies the Mercurius Pretty English patch to an ORIGINAL Mercurius Pretty v1.003 (JP) disc.
rem  Put this file, xdelta3.exe and the .xdelta file(s) in the folder with the .gdi and the track files (any file names).
rem  If several patches are there you are asked which name entry you want. The original data track is kept as <name>.orig.
set "PATCH="
set "HAVE1="
set "HAVE2="
set "HAVE3="
set "COUNT=0"
if exist Mercurius_Pretty_EN.xdelta set "HAVE1=1"
if exist Mercurius_Pretty_EN_romaji.xdelta set "HAVE2=1"
if exist Mercurius_Pretty_EN_kana.xdelta set "HAVE3=1"
if defined HAVE1 set /a COUNT+=1
if defined HAVE2 set /a COUNT+=1
if defined HAVE3 set /a COUNT+=1
if %COUNT% GEQ 2 goto ask
if defined HAVE1 set "PATCH=Mercurius_Pretty_EN.xdelta"
if defined HAVE2 set "PATCH=Mercurius_Pretty_EN_romaji.xdelta"
if defined HAVE3 set "PATCH=Mercurius_Pretty_EN_kana.xdelta"
if not defined PATCH goto nopatch
goto go
:ask
echo Which name entry do you want?
echo   1 = English letters (abc / ABC)  - recommended
echo   2 = Romaji syllables (ka, shi, chi ...)
echo   3 = Original Japanese kana names
choice /c 123 /n /m "Press 1, 2 or 3: "
if errorlevel 3 (set "PATCH=Mercurius_Pretty_EN_kana.xdelta" & goto go)
if errorlevel 2 (set "PATCH=Mercurius_Pretty_EN_romaji.xdelta" & goto go)
set "PATCH=Mercurius_Pretty_EN.xdelta"
:go
if not exist "%PATCH%" goto nopick
set "TRACK="
for /f "delims=" %%F in ('dir /b /o-s *.bin *.raw 2^>nul') do if not defined TRACK set "TRACK=%%F"
if not defined TRACK goto notrack
for %%F in ("%TRACK%") do set "SZ=%%~zF"
if "%SZ:~8,1%"=="" goto nodisc
if not exist xdelta3.exe goto noxd
xdelta3.exe -d -f -s "%TRACK%" "%PATCH%" "%TRACK%.new"
if errorlevel 1 goto fail
if exist "%TRACK%.orig" del /q /f "%TRACK%.orig"
move /y "%TRACK%" "%TRACK%.orig" >nul
if errorlevel 1 goto renfail
move /y "%TRACK%.new" "%TRACK%" >nul
if errorlevel 1 goto renfail
echo.
echo Patched with %PATCH%. Load the .gdi in your emulator.
echo (the original track was kept as %TRACK%.orig)
goto end
:renfail
echo.
echo The patch was built but the files could not be swapped (is the disc open in an emulator or another program?).
echo Close it and run this again - nothing has been lost.
goto end
:nodisc
echo The biggest .bin in this folder is only %SZ% bytes (%TRACK%) - that is not the game disc.
echo Put this file, xdelta3.exe, the .xdelta patch(es) and the ORIGINAL disc (.gdi + its track files) in one folder, then run it there.
goto end
:notrack
echo Could not find the data track (the largest .bin file) in this folder.
goto end
:noxd
echo xdelta3.exe was not found in this folder.
goto end
:nopick
echo %PATCH% is not in this folder - run again and pick one you have.
goto end
:nopatch
echo No patch found. Put Mercurius_Pretty_EN.xdelta (and/or the _romaji / _kana ones) in this folder.
goto end
:fail
echo xdelta3 reported an error - is this the original v1.003 disc?
del "%TRACK%.new" 2>nul
:end
