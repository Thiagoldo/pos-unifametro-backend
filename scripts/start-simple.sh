#!/bin/bash

# Script simplificado para iniciar os serviços (sem pre-download)
# Autor: Sistema de Chat FalaBlau

echo "🚀 Iniciando o sistema FalaBlau (modo simplificado)..."

# Navegar para o diretório do docker
cd "$(dirname "$0")/../docker" || exit 1

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Parar containers existentes primeiro
echo "🛑 Parando containers existentes..."
docker compose down 2>/dev/null || true

# Configurar timeout maior para builds
export DOCKER_BUILDKIT=1
export COMPOSE_HTTP_TIMEOUT=300
export DOCKER_CLIENT_TIMEOUT=300

# Iniciar os serviços diretamente (sem pull prévio)
echo "🏗️  Construindo e iniciando os serviços..."
echo "⏳ Isso pode demorar alguns minutos na primeira execução..."

if docker compose up --build -d --timeout 300; then
    echo ""
    echo "🔍 Verificando status dos serviços..."
    sleep 10
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
    echo "📈 Para ver status, execute: ./scripts/status.sh"
else
    echo ""
    echo "❌ Erro ao iniciar os serviços!"
    echo ""
    echo "💡 Dicas para solucionar problemas:"
    echo "   • Verifique sua conexão com a internet"
    echo "   • Tente executar: docker system prune -f"
    echo "   • Configure um proxy Docker se necessário"
    echo "   • Execute: ./scripts/logs.sh para ver detalhes"
    echo ""
    echo "🔍 Status atual dos containers:"
    docker compose ps
    exit 1
fi
