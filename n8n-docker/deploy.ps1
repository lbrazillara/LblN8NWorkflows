$UrlPrimary = "http://localhost:5678/healthz"
$UrlFallback = "http://localhost:5678"
$MaxAttempts = 30
$DelaySeconds = 2

Write-Host "Iniciando deploy local do n8n..." -ForegroundColor Green

Write-Host "Atualizando imagens..." -ForegroundColor Green
docker compose pull

Write-Host "Aplicando configuracao do docker-compose..." -ForegroundColor Green
docker compose up -d

Write-Host "Aguardando n8n ficar disponivel..." -ForegroundColor Green

$attempt = 0
$healthy = $false

while ($attempt -lt $MaxAttempts -and -not $healthy) {
    try {
        $response = Invoke-WebRequest -Uri $UrlPrimary -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            $healthy = $true
            break
        }
    } catch {
        try {
            $response = Invoke-WebRequest -Uri $UrlFallback -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -eq 200) {
                $healthy = $true
                break
            }
        } catch {
            Start-Sleep -Seconds $DelaySeconds
            $attempt++
        }
    }
}

if (-not $healthy) {
    Write-Host "Falha ao iniciar o n8n dentro do tempo esperado." -ForegroundColor Red
    exit 1
}

Write-Host "n8n esta disponivel. Abrindo no navegador..." -ForegroundColor Green
Start-Process $UrlFallback

Write-Host "Deploy finalizado com sucesso." -ForegroundColor Green
