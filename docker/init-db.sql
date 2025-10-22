-- Script de inicialização do banco de dados
-- Este script será executado automaticamente quando o container PostgreSQL iniciar

-- Criar o banco de dados principal (se não existir)
SELECT 'CREATE DATABASE chat_app' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'chat_app')\gexec

-- Criar usuário Kong
CREATE USER kong WITH PASSWORD 'kong';
CREATE DATABASE kong OWNER kong;
GRANT ALL PRIVILEGES ON DATABASE kong TO kong;

-- Garantir que o usuário principal tenha acesso ao banco chat_app
GRANT ALL PRIVILEGES ON DATABASE chat_app TO "user";

-- Conectar ao banco chat_app para criar as extensões necessárias
\c chat_app;

-- Extensões que podem ser úteis
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Conectar ao banco kong para configurar as extensões necessárias
\c kong;

-- Kong precisa dessas extensões
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Voltar ao banco chat_app
\c chat_app;

-- Mensagem de sucesso
SELECT 'Banco de dados inicializado com sucesso!' as status;
