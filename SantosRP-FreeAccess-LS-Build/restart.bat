@echo off
RMDIR /s /q "C:\FXServer\cache\files"
echo ----------------------------------
echo -
echo Pour relancer votre serveur, faites CTRL + C puis "runserver"
echo -
echo ----------------------------------
echo -
echo Appuyez sur une TOUCHE pour lancer votre serveur
echo -
pause > nul
CLS

:: CONFIGURATION

TITLE GTA 5 FIVEM SERVER
set reboot=6
set reboot2=12
set reboot3=18
set reboot4=0
set reboot_done=0
set reboot_done2=0
set reboot_done3=0
set reboot_done4=0
set location=C:\Fivem\ServerFiles\

:: CONFIGURATION

:start

set dat=%date:~6,4%-%date:~3,2%-%date:~0,2%
set backup=%location%logs\%dat%.txt

:: Partie sauvegarde

echo [%time%] - Serveur ouvert
echo [%time%] - Serveur ouvert >> %backup%
echo [%time%] - Lancement de la sauvegarde 
echo [%time%] - Lancement de la sauvegarde >> %backup%
xcopy %location%\"resources" %location%\backups\"%dat%" /E /H /R /Y /I /D  >> %backup%
echo [%time%] - Sauvegarde termine
echo [%time%] - Sauvegarde termine >> %backup%

:: Partie sauvegarde

:: Partie lancement

start %location%run.cmd +exec server.cfg %*

:: Partie lancement

goto loop

:loop
timeout /t 30>null
set tps=%TIME:~-0,2%
    if %tps% == %reboot% (
        if %reboot_done% == 0 (
            echo [%time%] - On ferme le serveur pour reboot && echo [%time%] - On ferme le serveur pour reboot >> %backup%
            taskkill /IM cmd.exe /FI "WINDOWTITLE ne GTA 5 FIVEM SERVER*" >> %backup%
			echo ----------------------------------------------------------------------
            set reboot_done=1
            goto start
        ) else (
            goto loop
        )
    ) else (
        set reboot_done=0
        goto loop
    )
	
	
:: Partie lancement 2

goto loop

:loop

timeout /t 30>null
set tps2=%TIME:~-0,2%
    if %tps2% == %reboot2% (
        if %reboot_done2% == 0 (
            echo [%time%] - On ferme le serveur pour reboot && echo [%time%] - On ferme le serveur pour reboot >> %backup%
            taskkill /IM cmd.exe /FI "WINDOWTITLE ne GTA 5 FIVEM SERVER*" >> %backup%
			echo ----------------------------------------------------------------------
            set reboot_done2=1
            goto start
        ) else (
            goto loop
        )
    ) else (
        set reboot_done2=0
        goto loop
    )
	

:: Partie lancement 3

goto loop

:loop

timeout /t 30>null
set tps3=%TIME:~-0,2%
    if %tps3% == %reboot3% (
        if %reboot_done3% == 0 (
            echo [%time%] - On ferme le serveur pour reboot && echo [%time%] - On ferme le serveur pour reboot >> %backup%
            taskkill /IM cmd.exe /FI "WINDOWTITLE ne GTA 5 FIVEM SERVER*" >> %backup%
			echo ----------------------------------------------------------------------
            set reboot_done3=1
            goto start
        ) else (
            goto loop
        )
    ) else (
        set reboot_done3=0
        goto loop
    )

:: Partie lancement 4

goto loop

:loop

timeout /t 30>null
set tps4=%TIME:~-0,2%
    if %tps4% == %reboot4% (
        if %reboot_done4% == 0 (
            echo [%time%] - On ferme le serveur pour reboot && echo [%time%] - On ferme le serveur pour reboot >> %backup%
            taskkill /IM cmd.exe /FI "WINDOWTITLE ne GTA 5 FIVEM SERVER*" >> %backup%
			echo ----------------------------------------------------------------------
            set reboot_done4=1
            goto start
        ) else (
            goto loop
        )
    ) else (
        set reboot_done4=0
        goto loop
    )	