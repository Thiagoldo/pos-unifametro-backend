# 🚀 Guia de Configuração - Novo PC

## Após Git Pull/Clone

### 1. Executar Setup Inicial
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 2. Ou Manualmente

**Verificar pré-requisitos:**
```bash
docker --version
docker-compose --version
```

**Dar permissões:**
```bash
chmod +x scripts/*.sh
```

**Iniciar sistema:**
```bash
./scripts/start-simple.sh
```

**Opcional - Personalizar configurações:**
```bash
# Apenas se quiser alterar portas/credenciais
cp .env.example .env
# Edite o arquivo .env conforme necessário
```

## 🌐 URLs do Sistema

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| Sistema Principal | http://localhost | - |
| Kong Admin | http://localhost:8001 | - |
| Keycloak | http://localhost:8080 | admin/admin |
| Users Service | http://localhost:3001 | - |
| Chat Service | http://localhost:3002 | - |
| WebSocket Service | http://localhost:3003 | - |
| RabbitMQ | http://localhost:15672 | guest/guest |

## 🔧 Comandos Essenciais

```bash
# Iniciar sistema
./scripts/start-simple.sh

# Ver status
./scripts/status.sh

# Ver logs
./scripts/logs.sh

# Parar sistema
./scripts/stop.sh

# Reconstruir
./scripts/rebuild.sh

# Em caso de problemas
docker compose down -v
./scripts/start-simple.sh
```

## 🐛 Solução Rápida de Problemas

| Problema | Solução |
|----------|---------|
| Kong não inicia | `docker compose run --rm kong-migrations kong migrations bootstrap && docker compose restart kong` |
| User Service falha | `docker compose restart user-service` |
| Nginx 502 | `docker compose restart nginx` |
| Portas ocupadas | `./scripts/stop.sh` em outro projeto |
| Reset completo | `docker compose down -v && ./scripts/start-simple.sh` |

## ⚡ Para Desenvolvedores

**Ver logs específicos:**
```bash
docker compose logs -f <service-name>
```

**Executar comandos no container:**
```bash
docker compose exec <service-name> bash
```

**Rebuild apenas um serviço:**
```bash
docker compose up --build <service-name>
```

## 📝 Arquivo .env (Opcional)

**Quando criar:**
- ✅ Se quiser alterar portas padrão (conflitos)
- ✅ Se quiser credenciais diferentes
- ✅ Para configurações específicas do PC

**Como usar:**
```bash
cp .env.example .env
# Edite apenas as variáveis que quer alterar
```

**⚠️ Importante:** 
- O sistema funciona **sem** arquivo .env (usa valores padrão)
- O `.env` não vai para o git (está no .gitignore)
- Cada PC pode ter seu próprio .env
