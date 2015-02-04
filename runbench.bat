@echo off
@setlocal 
::echo %time%

:: Cleanup temp files
if exist temp.txt del temp.txt
if exist windows.unf del windows.unf
if exist windows.pic del windows.pic
if exist windows.bmp del windows.bmp

echo Check if specular sampling is available in rpict
rpict -defaults >> temp.txt
:: determine whether this rpict uses -ss or -sj
findstr /c:"specular sampling" temp.txt
if %errorlevel% equ 1 goto notfound
:: post-4.0
set "spec=-ss 1.0"
goto done
:notfound
:: 4.0 and earlier
set "spec=-sj 1.0"
goto done
:done

echo Check if pixel depth-of-field is available in rpict
:: determine whether this rpict uses -pd
findstr /c:"pixel depth-of-field" temp.txt
if %errorlevel% equ 1 goto notfoundpdf
:: post-3R6P1
set "pdf=-lr -10 -u- -pd 0.0"
goto donepdf
:notfoundpdf
:: 3R6P1 and earlier
set "pdf=-lr 10"
goto donepdf
:donepdf

:: Create options file
type optionsbase > options
set "opt=%spec% %pdf%"
echo.%opt% >> options

obj2mesh -n 15 -r 16384 lens.obj > lens.msh
oconv -f -n 6 -r 16384 materials.rad cube2f.rad > cube2f_instance.oct
oconv -f -n 6 -r 16384 materials.rad cube4f.rad > cube4f_instance.oct
oconv -n 6 -r 16384 materials.rad scene.rad > scene.oct

set start=%time%

:: runs your command
rpict @viewpoint @options -x 2048 -y 2048 -t 60 -o windows.unf scene.oct

set end=%time%
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %hours% lss 0 set /a hours = 24%hours%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if 1%ms% lss 100 set ms=0%ms%

:: mission accomplished
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs% 
echo rpict command took %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)

pfilt -1 -e +0 -x /4 -y /4 -r .6 -m .15 windows.unf > windows.pic

ra_bmp windows.pic > windows.bmp

::echo %time%

::Display Radiance version
echo You are using Radiance version:
rpict -version

::Cleanup temp files left by rpict
if exist rta????? del rta?????

pause
