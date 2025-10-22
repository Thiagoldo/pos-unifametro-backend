#!/bin/bash

# Script para iniciar todos os serviços do sistema
# Autor: Sistema de Chat FalaBlau

echo "🚀 Iniciando o sistema FalaBlau..."

# Navegar para o diretório do docker
cd "$(dirname "$0")/../docker" || exit 1

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Função para fazer pull com retry
pull_image_with_retry() {
    local image=$1
    local max_attempts=3
    local attempt=1
    
    echo "📦 Baixando $image..."
    
    while [ $attempt -le $max_attempts ]; do
        if timeout 60 docker pull "$image"; then
            echo "✅ $image baixada com sucesso!"
            return 0
        else
            echo "⚠️  Tentativa $attempt/$max_attempts falhou para $image"
            if [ $attempt -lt $max_attempts ]; then
                echo "🔄 Tentando novamente em 5 segundos..."
                sleep 5
            fi
            attempt=$((attempt + 1))
        fi
    done
    
    echo "❌ Falha ao baixar $image após $max_attempts tentativas"
    return 1
}

# Tentar baixar imagens com retry (opcional - continua mesmo se falhar)
echo "📦 Tentando baixar imagens Docker (pode pular se houver problemas de rede)..."
pull_image_with_retry "nginx:latest" || echo "⚠️  Nginx será baixado durante o build"
pull_image_with_retry "kong:latest" || echo "⚠️  Kong será baixado durante o build"
pull_image_with_retry "jboss/keycloak:latest" || echo "⚠️  Keycloak será baixado durante o build"
pull_image_with_retry "postgres:13" || echo "⚠️  PostgreSQL será baixado durante o build"
pull_image_with_retry "mongo:5" || echo "⚠️  MongoDB será baixado durante o build"
pull_image_with_retry "rabbitmq:3-management" || echo "⚠️  RabbitMQ será baixado durante o build"

# Iniciar os serviços
echo "🏗️  Construindo e iniciando os serviços..."
docker compose up --build -d

# Verificar se os serviços subiram corretamente
echo "🔍 Verificando status dos serviços..."
sleep 5
docker compose ps

echo ""
echo "✅ Sistema iniciado com sucesso!"
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
echo ""
echo "🔧 Para parar os serviços, execute: ./scripts/stop.sh"
echo "📊 Para ver logs, execute: ./scripts/logs.sh"
