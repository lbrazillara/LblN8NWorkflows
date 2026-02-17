Write-Host "Iniciando deploy local do n8n..." -ForegroundColor Green

Write-Host "Atualizando imagens..." -ForegroundColor Green
docker compose pull

Write-Host "Aplicando configuracao do docker-compose..." -ForegroundColor Green
docker compose up -d

Write-Host "Aguardando inicializacao do n8n..." -ForegroundColor Green
Start-Sleep -Seconds 10

Write-Host "Abrindo n8n no navegador..." -ForegroundColor Green
Start-Process "http://localhost:5678"

Write-Host "Deploy finalizado com sucesso." -ForegroundColor Green
