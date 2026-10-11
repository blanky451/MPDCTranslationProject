@echo off
rem  Applies Mercurius_Pretty_EN.xdelta to an ORIGINAL Mercurius Pretty v1.003 (JP) disc.
rem  Put this file, xdelta3.exe and Mercurius_Pretty_EN.xdelta in the folder with game.gdi and the track files.
rem  The original data track is kept as <name>.orig and the patched one takes its place.
set "TRACK="
for %%F in (*03.bin) do set "TRACK=%%F"
if not defined TRACK goto notrack
if not exist xdelta3.exe goto noxd
if not exist Mercurius_Pretty_EN.xdelta goto nopatch
xdelta3.exe -d -f -s "%TRACK%" Mercurius_Pretty_EN.xdelta "%TRACK%.new"
if errorlevel 1 goto fail
ren "%TRACK%" "%TRACK%.orig"
ren "%TRACK%.new" "%TRACK%"
echo.
echo Patched. Load game.gdi in your emulator.
goto end
:notrack
echo Could not find the data track (a file ending in 03.bin) in this folder.
goto end
:noxd
echo xdelta3.exe was not found in this folder.
goto end
:nopatch
echo Mercurius_Pretty_EN.xdelta was not found in this folder.
goto end
:fail
echo xdelta3 reported an error - is this the original v1.003 disc?
del "%TRACK%.new" 2>nul
:end
