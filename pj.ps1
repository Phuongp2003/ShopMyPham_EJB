param (
    [string]$action,
    [string]$warPath
)

function Stop-GlassFish {
    Write-Output "Stopping GlassFish Server..."
    $env:AS_JAVA = "C:\Program Files\Java\jdk1.8.0_202"
    & "glassfish-4.1.1\glassfish4\bin\asadmin.bat" stop-domain
    Write-Output "GlassFish Server stopped."
}

function Redeploy-Application {
    Write-Output "Undeploying application..."
    $env:AS_JAVA = "C:\Program Files\Java\jdk1.8.0_202"
    & "glassfish-4.1.1\glassfish4\bin\asadmin.bat" undeploy cart-web-1.0
    Write-Output "Deploying application..."
    $env:AS_JAVA = "C:\Program Files\Java\jdk1.8.0_202"
    & "glassfish-4.1.1\glassfish4\bin\asadmin.bat" deploy $warPath
}

function Start-GlassFish {
    Write-Output "Starting GlassFish Server..."
    $env:AS_JAVA = "C:\Program Files\Java\jdk1.8.0_202"
    & "glassfish-4.1.1\glassfish4\bin\asadmin.bat" start-domain
    if ($LASTEXITCODE -ne 0) {
        Write-Output "Failed to start GlassFish Server"
        exit $LASTEXITCODE
    }

    Write-Output "Deploying application..."
    $env:AS_JAVA = "C:\Program Files\Java\jdk1.8.0_202"
    & "glassfish-4.1.1\glassfish4\bin\asadmin.bat" deploy $warPath
    if ($LASTEXITCODE -ne 0) {
        Write-Output "Deployment failed"
        Redeploy-Application
        exit $LASTEXITCODE
    }

    Write-Output "Successfully started server and deployed application."
}

switch ($action) {
    "stop" { Stop-GlassFish }
    "redeploy" { Redeploy-Application }
    "start" { Start-GlassFish }
    default { Write-Output "Invalid action. Use 'stop', 'redeploy', or 'start'." }
}
