#!/bin/bash
# Script para iniciar todos os serviços da aplicação
cd /home/victor.cavalcante/Victor/BackendFametro/pos-unifametro-backend/docker
docker-compose up -d
echo "✅ Todos os serviços foram iniciados!"
echo "🌐 Acesse: http://localhost"
echo "🔧 RabbitMQ: http://localhost:15672"
echo "🔐 Keycloak: http://localhost:8081/auth"
