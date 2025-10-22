#!/bin/bash

# Script para parar todos os serviços do sistema
# Autor: Sistema de Chat FalaBlau

echo "🛑 Parando o sistema FalaBlau..."

# Navegar para o diretório do docker
cd "$(dirname "$0")/../docker" || exit 1

# Parar todos os serviços
echo "⏹️  Parando os serviços..."
docker compose down

echo ""
echo "✅ Todos os serviços foram parados com sucesso!"
echo ""
echo "💡 Dicas:"
echo "   • Para remover também os volumes: docker compose down -v"
echo "   • Para remover imagens não utilizadas: docker system prune"
echo "   • Para iniciar novamente: ./scripts/start.sh"
