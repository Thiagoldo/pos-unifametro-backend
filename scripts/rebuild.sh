#!/bin/bash

# Script para reconstruir todos os serviços do sistema
# Autor: Sistema de Chat FalaBlau

echo "🔄 Reconstruindo o sistema FalaBlau..."

# Navegar para o diretório do docker
cd "$(dirname "$0")/../docker" || exit 1

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Parar serviços existentes
echo "⏹️  Parando serviços existentes..."
docker compose down

# Remover imagens antigas dos microserviços
echo "🗑️  Removendo imagens antigas..."
docker rmi docker-user-service:latest 2>/dev/null || true
docker rmi docker-chat-service:latest 2>/dev/null || true
docker rmi docker-websocket-service:latest 2>/dev/null || true

# Limpar cache do Docker
echo "🧹 Limpando cache do Docker..."
docker builder prune -f

# Fazer pull das imagens externas
echo "📦 Atualizando imagens externas..."
docker pull nginx:latest
docker pull kong:latest
docker pull jboss/keycloak:latest
docker pull postgres:13
docker pull mongo:5
docker pull rabbitmq:3-management

# Reconstruir e iniciar
echo "🏗️  Reconstruindo e iniciando os serviços..."
docker compose up --build -d

# Verificar status
echo "🔍 Verificando status dos serviços..."
sleep 5
docker compose ps

echo ""
echo "✅ Sistema reconstruído e iniciado com sucesso!"
echo ""
echo "📋 Serviços disponíveis:"
echo "   • Nginx (Proxy):           http://localhost"
echo "   • Kong (API Gateway):      http://localhost:8000"
echo "   • Keycloak (Auth):         http://localhost:8080"
echo "   • Users Service:           http://localhost:3001"
echo "   • Chat Service:            http://localhost:3002"
echo "   • WebSocket Service:       http://localhost:3003"
echo "   • PostgreSQL:              localhost:5432"
echo "   • MongoDB:                 localhost:27017"
echo "   • RabbitMQ Management:     http://localhost:15672"
