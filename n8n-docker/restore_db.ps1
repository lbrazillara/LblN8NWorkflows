$BackupDir = "backups/postgres"
$ContainerName = "n8n-postgres"
$DbName = "n8n"
$DbUser = "n8n"

Write-Host "========================================" -ForegroundColor Green
Write-Host " RESTORE DO BANCO POSTGRES - N8N" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

if (-not (Test-Path $BackupDir)) {
    Write-Host "Diretorio de backup nao encontrado." -ForegroundColor Red
    exit 1
}

$Backups = Get-ChildItem "$BackupDir\*.sql" | Sort-Object LastWriteTime -Descending

if ($Backups.Count -eq 0) {
    Write-Host "Nenhum arquivo de backup encontrado." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Backups disponiveis:" -ForegroundColor Green

for ($i = 0; $i -lt $Backups.Count; $i++) {
    Write-Host "[$i] $($Backups[$i].Name)" -ForegroundColor Green
}

Write-Host ""
$Choice = Read-Host "Digite o numero do backup para restaurar"

if ($Choice -notmatch '^\d+$' -or $Choice -ge $Backups.Count) {
    Write-Host "Opcao invalida." -ForegroundColor Red
    exit 1
}

$SelectedBackup = $Backups[$Choice].FullName

Write-Host ""
Write-Host "Restaurando backup: $($Backups[$Choice].Name)" -ForegroundColor Green

docker cp $SelectedBackup "${ContainerName}:/tmp/restore.sql"

docker exec -i $ContainerName psql `
    -U $DbUser `
    -d $DbName `
    -f /tmp/restore.sql

docker exec $ContainerName rm /tmp/restore.sql

Write-Host ""
Write-Host "Restore concluido com sucesso." -ForegroundColor Green
