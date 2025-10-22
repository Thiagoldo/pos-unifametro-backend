#!/bin/bash

# Script para configurar Docker com DNS alternativos
# Autor: Sistema de Chat FalaBlau

echo "🔧 Configurando Docker para melhor conectividade..."

# Verificar se está rodando como root ou com sudo
if [ "$EUID" -ne 0 ]; then
    echo "⚠️  Este script precisa ser executado com sudo para modificar configurações do Docker"
    echo "Execute: sudo ./scripts/fix-network.sh"
    exit 1
fi

# Backup da configuração atual
echo "💾 Fazendo backup da configuração atual..."
cp /etc/docker/daemon.json /etc/docker/daemon.json.backup 2>/dev/null || true

# Criar configuração do Docker com DNS alternativos
echo "📝 Configurando DNS alternativos..."
cat > /etc/docker/daemon.json << EOF
{
  "dns": ["8.8.8.8", "8.8.4.4", "1.1.1.1"],
  "registry-mirrors": [
    "https://mirror.gcr.io",
    "https://registry.docker-cn.com"
  ],
  "insecure-registries": [],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

echo "🔄 Reiniciando serviço Docker..."
systemctl restart docker

echo "⏳ Aguardando Docker inicializar..."
sleep 5

if docker info > /dev/null 2>&1; then
    echo "✅ Docker configurado e funcionando com DNS alternativos!"
    echo ""
    echo "🧪 Testando conectividade:"
    echo "------------------------"
    
    if docker run --rm alpine:latest sh -c "nslookup registry-1.docker.io"; then
        echo "✅ Conectividade com Docker Hub: OK"
    else
        echo "❌ Problemas de conectividade persistem"
    fi
    
    echo ""
    echo "💡 Configurações aplicadas:"
    echo "   • DNS: 8.8.8.8, 8.8.4.4, 1.1.1.1"
    echo "   • Registry mirrors configurados"
    echo "   • Logs otimizados"
    echo ""
    echo "🚀 Agora tente executar: ./scripts/start-simple.sh"
else
    echo "❌ Erro ao reiniciar Docker. Restaurando configuração anterior..."
    cp /etc/docker/daemon.json.backup /etc/docker/daemon.json 2>/dev/null || true
    systemctl restart docker
    echo "🔄 Configuração anterior restaurada"
    exit 1
fi
