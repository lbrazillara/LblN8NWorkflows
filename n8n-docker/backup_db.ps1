$BackupDir = "backups/postgres"
$ContainerName = "n8n-postgres"
$DbName = "n8n"
$DbUser = "n8n"

if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$BackupFile = "$BackupDir\n8n_backup_$Timestamp.sql"

Write-Host "Iniciando backup manual do PostgreSQL..." -ForegroundColor Green

docker exec $ContainerName pg_dump `
    -U $DbUser `
    -d $DbName `
    -F p `
    -f /tmp/backup.sql

docker cp "${ContainerName}:/tmp/backup.sql" $BackupFile

docker exec $ContainerName rm /tmp/backup.sql

Write-Host "Backup concluido com sucesso." -ForegroundColor Green
Write-Host "Arquivo gerado: $BackupFile" -ForegroundColor Green
