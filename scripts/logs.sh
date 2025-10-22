#!/bin/bash

# Script para visualizar logs do sistema
# Autor: Sistema de Chat FalaBlau

echo "📋 Visualizador de Logs - Sistema FalaBlau"
echo "=========================================="

# Navegar para o diretório do docker
cd "$(dirname "$0")/../docker" || exit 1

# Função para mostrar menu
show_menu() {
    echo ""
    echo "Escolha uma opção:"
    echo "1) Ver logs de todos os serviços"
    echo "2) Ver logs do Nginx"
    echo "3) Ver logs do Kong"
    echo "4) Ver logs do Keycloak"
    echo "5) Ver logs do Users Service"
    echo "6) Ver logs do Chat Service"
    echo "7) Ver logs do WebSocket Service"
    echo "8) Ver logs do PostgreSQL"
    echo "9) Ver logs do MongoDB"
    echo "10) Ver logs do RabbitMQ"
    echo "11) Seguir logs em tempo real (todos)"
    echo "0) Sair"
    echo ""
    read -p "Digite sua escolha (0-11): " choice
}

# Função para mostrar logs
show_logs() {
    local service=$1
    local lines=${2:-50}
    
    echo "📄 Últimas $lines linhas de log para $service:"
    echo "============================================"
    docker compose logs --tail=$lines $service
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Loop principal
while true; do
    show_menu
    
    case $choice in
        1)
            echo "📄 Logs de todos os serviços:"
            echo "============================"
            docker compose logs --tail=20
            echo ""
            read -p "Pressione Enter para continuar..."
            ;;
        2)
            show_logs "nginx"
            ;;
        3)
            show_logs "kong"
            ;;
        4)
            show_logs "keycloak"
            ;;
        5)
            show_logs "user-service"
            ;;
        6)
            show_logs "chat-service"
            ;;
        7)
            show_logs "websocket-service"
            ;;
        8)
            show_logs "postgresql"
            ;;
        9)
            show_logs "mongodb"
            ;;
        10)
            show_logs "rabbitmq"
            ;;
        11)
            echo "📡 Seguindo logs em tempo real (Ctrl+C para parar):"
            echo "=================================================="
            docker compose logs -f
            ;;
        0)
            echo "👋 Saindo..."
            exit 0
            ;;
        *)
            echo "❌ Opção inválida. Tente novamente."
            ;;
    esac
done
