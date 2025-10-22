#!/bin/bash

# Script para preparar commit do projeto FalaBlau
# Autor: Sistema de Chat FalaBlau

echo "🔍 Verificando arquivos para commit..."

# Verificar se estamos em um repositório git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Este não é um repositório git!"
    exit 1
fi

# Mostrar status atual
echo ""
echo "📋 Status atual do repositório:"
git status --short

echo ""
echo "📦 Arquivos que serão incluídos no commit:"
echo "=========================================="

# Adicionar apenas os arquivos necessários
echo "✅ Adicionando arquivos de configuração Docker..."
git add docker/docker-compose.yaml
git add docker/init-db.sql

echo "✅ Adicionando configuração Nginx..."
git add nginx/nginx.conf

echo "✅ Adicionando scripts de gerenciamento..."
git add scripts/

echo "✅ Adicionando arquivos .gitignore e .dockerignore..."
git add .gitignore
git add .dockerignore
git add microservices/*/.dockerignore

echo "✅ Adicionando código dos microserviços..."
git add microservices/

echo ""
echo "📋 Verificação final dos arquivos preparados para commit:"
git status --short --cached

echo ""
echo "💡 Comandos úteis:"
echo "   • Para fazer commit: git commit -m 'feat: configuração completa do ambiente Docker'"
echo "   • Para ver diferenças: git diff --cached"
echo "   • Para desfazer: git reset"
echo ""
echo "⚠️  Lembre-se de verificar se não há dados sensíveis nos arquivos!"

# Verificar se há arquivos grandes
echo ""
echo "🔍 Verificando tamanho dos arquivos..."
git diff --cached --name-only | xargs -I {} sh -c 'echo "$(wc -c < "{}") {}"' | sort -n | tail -5

echo ""
echo "✅ Preparação concluída! Revise os arquivos e faça o commit."
