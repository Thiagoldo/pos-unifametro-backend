#!/bin/bash

# Script de configuração inicial para novo PC
# Execute este script após fazer git pull em uma nova máquina

echo "🚀 Configuração Inicial - Sistema FalaBlau"
echo "=========================================="

# Verificar se estamos no diretório correto
if [ ! -f "docker/docker-compose.yaml" ]; then
    echo "❌ Erro: Execute este script na raiz do projeto!"
    echo "   Certifique-se de estar no diretório pos-unifametro-backend/"
    exit 1
fi

echo ""
echo "🔍 Verificando pré-requisitos..."

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado!"
    echo ""
    echo "📋 Para instalar o Docker:"
    echo "   Ubuntu/Debian: sudo apt update && sudo apt install docker.io docker-compose"
    echo "   macOS: brew install docker docker-compose"
    echo "   Windows: Baixe Docker Desktop do site oficial"
    exit 1
else
    echo "✅ Docker encontrado: $(docker --version)"
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado!"
    exit 1
else
    echo "✅ Docker Compose encontrado: $(docker-compose --version)"
fi

# Verificar se Docker está rodando
if ! docker info &> /dev/null; then
    echo "❌ Docker não está rodando!"
    echo "   Inicie o Docker e tente novamente."
    exit 1
else
    echo "✅ Docker está rodando"
fi

echo ""
echo "🔧 Configurando permissões dos scripts..."

# Dar permissões aos scripts
chmod +x scripts/*.sh
echo "✅ Permissões configuradas"

echo ""
echo "📁 Verificando estrutura do projeto..."

# Verificar estrutura essencial
required_dirs=("docker" "microservices" "nginx" "scripts")
missing_dirs=()

for dir in "${required_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        missing_dirs+=("$dir")
    else
        echo "✅ $dir/"
    fi
done

if [ ${#missing_dirs[@]} -ne 0 ]; then
    echo "❌ Diretórios ausentes: ${missing_dirs[*]}"
    echo "   Verifique se o git pull foi executado corretamente."
    exit 1
fi

echo ""
echo "🌐 Verificando conectividade..."

# Testar conectividade com Docker Hub
if timeout 10 docker pull hello-world &> /dev/null; then
    echo "✅ Conectividade com Docker Hub OK"
    docker rmi hello-world &> /dev/null
else
    echo "⚠️  Conectividade lenta - use ./scripts/start.sh (com retry)"
fi

echo ""
echo "🎯 Pronto para inicializar!"
echo ""
echo "📋 Próximos passos:"
echo "1️⃣  Para iniciar rapidamente:"
echo "   ./scripts/start-simple.sh"
echo ""
echo "2️⃣  Para internet lenta:"
echo "   ./scripts/start.sh"
echo ""
echo "3️⃣  Para ver status:"
echo "   ./scripts/status.sh"
echo ""
echo "4️⃣  Para ver logs:"
echo "   ./scripts/logs.sh"
echo ""

read -p "🚀 Deseja iniciar o sistema agora? (s/N): " choice
case "$choice" in 
    s|S|sim|SIM|Sim )
        echo ""
        echo "🏗️  Iniciando sistema..."
        ./scripts/start-simple.sh
        ;;
    * )
        echo ""
        echo "✅ Configuração concluída!"
        echo "   Execute ./scripts/start-simple.sh quando estiver pronto."
        ;;
esac
