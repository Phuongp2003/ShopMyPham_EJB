@echo off
setlocal

set "AS_JAVA=C:\Program Files\Java\jdk1.8.0_202"

if "%1"=="" (
    echo Invalid action. Use 'stop', 'redeploy', or 'start'.
    exit /b 1
)

if "%1"=="stop" (
    call :StopGlassFish
) else if "%1"=="redeploy" (
    call :RedeployApplication "%2"
) else if "%1"=="start" (
    call :StartGlassFish "%2"
) else (
    echo Invalid action. Use 'stop', 'redeploy', or 'start'.
    exit /b 1
)
exit /b 0

:StopGlassFish
echo Stopping GlassFish Server...
call "glassfish-4.1.1\glassfish4\bin\asadmin.bat" stop-domain
echo GlassFish Server stopped.
exit /b 0

:RedeployApplication
echo Undeploying application...
call "glassfish-4.1.1\glassfish4\bin\asadmin.bat" undeploy cart-web-1.0
echo Deploying application...
call "glassfish-4.1.1\glassfish4\bin\asadmin.bat" deploy %1
exit /b 0

:StartGlassFish
echo Starting GlassFish Server...
call "glassfish-4.1.1\glassfish4\bin\asadmin.bat" start-domain
if errorlevel 1 (
    echo Failed to start GlassFish Server
    exit /b 1
)

echo Deploying application...
call "glassfish-4.1.1\glassfish4\bin\asadmin.bat" deploy %1
if errorlevel 1 (
    echo Deployment failed
    call :RedeployApplication %1
    exit /b 1
)
echo Successfully started server and deployed application.
exit /b 0
