@echo off
rem  Applies the Mercurius Pretty English patch to an ORIGINAL Mercurius Pretty v1.003 (JP) disc.
rem  Put this file, xdelta3.exe and the .xdelta file(s) in the folder with the .gdi and the track files (any file names).
rem  If both patches are there you are asked which name entry you want. The original data track is kept as <name>.orig.
set "PATCH="
set "HAVE1="
set "HAVE2="
if exist Mercurius_Pretty_EN.xdelta set "HAVE1=1"
if exist Mercurius_Pretty_EN_romaji.xdelta set "HAVE2=1"
if defined HAVE1 if defined HAVE2 goto ask
if defined HAVE1 set "PATCH=Mercurius_Pretty_EN.xdelta"
if defined HAVE2 set "PATCH=Mercurius_Pretty_EN_romaji.xdelta"
if not defined PATCH goto nopatch
goto go
:ask
echo Which name entry do you want?
echo   1 = English letters (abc / ABC)  - recommended
echo   2 = Romaji syllables (ka, shi, chi ...)
choice /c 12 /n /m "Press 1 or 2: "
if errorlevel 2 (set "PATCH=Mercurius_Pretty_EN_romaji.xdelta") else (set "PATCH=Mercurius_Pretty_EN.xdelta")
:go
set "TRACK="
for /f "delims=" %%F in ('dir /b /o-s *.bin *.raw 2^>nul') do if not defined TRACK set "TRACK=%%F"
if not defined TRACK goto notrack
if not exist xdelta3.exe goto noxd
xdelta3.exe -d -f -s "%TRACK%" "%PATCH%" "%TRACK%.new"
if errorlevel 1 goto fail
ren "%TRACK%" "%TRACK%.orig"
ren "%TRACK%.new" "%TRACK%"
echo.
echo Patched with %PATCH%. Load the .gdi in your emulator.
goto end
:notrack
echo Could not find the data track (the largest .bin file) in this folder.
goto end
:noxd
echo xdelta3.exe was not found in this folder.
goto end
:nopatch
echo No patch found. Put Mercurius_Pretty_EN.xdelta (and/or Mercurius_Pretty_EN_romaji.xdelta) in this folder.
goto end
:fail
echo xdelta3 reported an error - is this the original v1.003 disc?
del "%TRACK%.new" 2>nul
:end
