#!/bin/bash

# Script para verificar status dos serviços
# Autor: Sistema de Chat FalaBlau

echo "📊 Status do Sistema FalaBlau"
echo "============================="

# Navegar para o diretório do docker
cd "$(dirname "$0")/../docker" || exit 1

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando."
    exit 1
fi

# Mostrar status dos containers
echo ""
echo "🐳 Status dos Containers:"
echo "------------------------"
docker compose ps

echo ""
echo "📈 Uso de Recursos:"
echo "------------------"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

echo ""
echo "🔍 Verificação de Saúde dos Serviços:"
echo "------------------------------------"

# Função para verificar se um serviço está respondendo
check_service() {
    local name=$1
    local url=$2
    local expected_code=${3:-200}
    
    printf "%-20s: " "$name"
    
    if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$url" | grep -q "$expected_code"; then
        echo "✅ Online"
    else
        echo "❌ Offline"
    fi
}

# Verificar serviços HTTP
check_service "Nginx" "http://localhost" "200\|301\|302"
check_service "Kong" "http://localhost:8000" "404"  # Kong retorna 404 quando não há rotas
check_service "Keycloak" "http://localhost:8080" "200\|301\|302"
check_service "Users Service" "http://localhost:3001" "200\|404"
check_service "Chat Service" "http://localhost:3002" "200\|404"
check_service "WebSocket Service" "http://localhost:3003" "200\|404"

# Verificar bancos de dados
printf "%-20s: " "PostgreSQL"
if docker compose exec -T postgresql pg_isready -q; then
    echo "✅ Online"
else
    echo "❌ Offline"
fi

printf "%-20s: " "MongoDB"
if docker compose exec -T mongodb mongosh --eval "db.runCommand('ping').ok" --quiet 2>/dev/null | grep -q "1"; then
    echo "✅ Online"
else
    echo "❌ Offline"
fi

printf "%-20s: " "RabbitMQ"
if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "http://localhost:15672" | grep -q "200"; then
    echo "✅ Online"
else
    echo "❌ Offline"
fi

echo ""
echo "📋 Informações Úteis:"
echo "--------------------"
echo "• Para reiniciar um serviço: docker compose restart <service_name>"
echo "• Para ver logs: ./scripts/logs.sh"
echo "• Para reconstruir: ./scripts/rebuild.sh"
echo "• Para parar tudo: ./scripts/stop.sh"

echo ""
echo "🌐 URLs dos Serviços:"
echo "--------------------"
echo "• Sistema (Nginx):         http://localhost"
echo "• Kong Admin:              http://localhost:8001"
echo "• Keycloak:                http://localhost:8080"
echo "• RabbitMQ Management:     http://localhost:15672 (guest/guest)"
