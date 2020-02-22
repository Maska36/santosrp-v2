@echo off

:: CONFIGURATION
TITLE SANTOSRP
set reboot=18
set reboot_done=0
set location=C:\Users\loren\Desktop\Perso\md\SERVERS\SantosRP-WL-Live-Server-Build\

:: CONFIGURATION
:start

set dat=%date:~6,4%-%date:~3,2%-%date:~0,2%

:: Partie sauvegarde
echo [%time%] - Serveur démarré
echo [%time%] - Serveur démarré 

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
            echo [%time%] - On ferme le serveur pour reboot && echo [%time%] - On ferme le serveur pour reboot 
            taskkill /f /im C:\Users\loren\Desktop\Perso\md\SERVERS\SantosRP-WL-Live-Server-Build\run.cmd
			taskkill /F /FI "WindowTitle eq SANTOSRP*"
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