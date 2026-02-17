# Comandos úteis – n8n local com Docker e PostgreSQL

Este arquivo reúne os principais comandos para gerenciar o ambiente local do n8n.

---

## 🐳 Docker / Docker Compose

### Subir o ambiente
docker compose up -d

### Parar o ambiente
docker compose down

### Parar e remover volumes (⚠️ apaga banco)
docker compose down -v

### Reiniciar serviços
docker compose restart

### Atualizar imagens
docker compose pull
docker compose up -d

### Ver containers rodando
docker ps

### Ver logs gerais
docker compose logs -f

### Ver logs apenas do n8n
docker logs -f n8n

### Ver logs apenas do PostgreSQL
docker logs -f n8n-postgres

### Ver logs do backup
docker logs -f n8n-postgres-backup

---

## 🗄️ PostgreSQL

### Entrar no container do Postgres
docker exec -it n8n-postgres bash

### Acessar o banco via psql
docker exec -it n8n-postgres psql -U n8n -d n8n

### Listar bancos
\l

### Listar tabelas
\dt

### Sair do psql
\q

---

## 💾 Backup e Restore

### Listar backups disponíveis
ls backups/postgres

### Descompactar backup
gunzip nome_do_backup.sql.gz

### Restaurar backup no banco
docker exec -i n8n-postgres psql \
  -U n8n \
  -d n8n < nome_do_backup.sql

---

## 🔄 n8n

### Acessar n8n
http://localhost:5678

### Resetar execuções travadas (em caso extremo)
docker compose restart n8n

---

## 🌱 Git

### Inicializar repositório
git init

### Ver status
git status

### Adicionar arquivos
git add .

### Commit
git commit -m "mensagem do commit"

### Ver histórico
git log --oneline

---

## 🔐 Ambiente

### Criar arquivo de ambiente
cp .env.example .env

⚠️ Nunca versionar o arquivo .env

---

## 🧪 Debug rápido

### Ver uso de recursos dos containers
docker stats

### Inspecionar container
docker inspect n8n
