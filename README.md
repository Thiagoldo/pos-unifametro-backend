# FalaBLAU - Sistema FullStack para Conversas em Tempo Real

![FalaBLAU Logo](public/fala-blau.jpeg)

Um sistema de chat em tempo real construído com arquitetura de microsserviços avançada, utilizando Flask (backend), React (frontend), com API Gateway, sistema de mensageria e autenticação centralizada, totalmente containerizado com Docker.

![Arquitetura do Sistema](public/arquitetura-sistema.jpeg)

## � Configuração Rápida em Novo PC

### 📋 Pré-requisitos

**1. Docker e Docker Compose**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose

# macOS (Homebrew)
brew install docker docker-compose

# Verificar instalação
docker --version
docker-compose --version
```

### 🔧 Configuração Inicial

**1. Após git pull/clone:**
```bash
# Dar permissões aos scripts
chmod +x scripts/*.sh

# Verificar estrutura
ls -la scripts/
```

**2. Inicializar Sistema:**
```bash
# Opção 1: Modo simplificado (recomendado)
./scripts/start-simple.sh

# Opção 2: Com retry para internet lenta
./scripts/start.sh
```

**3. Verificar Status:**
```bash
./scripts/status.sh
```

### 🌐 URLs Disponíveis

Após inicialização bem-sucedida:
- **Sistema Principal**: http://localhost
- **Kong Admin**: http://localhost:8001
- **Keycloak**: http://localhost:8080
- **Users Service**: http://localhost:3001
- **Chat Service**: http://localhost:3002
- **WebSocket Service**: http://localhost:3003
- **RabbitMQ Management**: http://localhost:15672 (guest/guest)

### 🔧 Scripts de Gerenciamento

| Script | Função |
|--------|--------|
| `./scripts/start-simple.sh` | Inicia sistema (modo rápido) |
| `./scripts/start.sh` | Inicia com retry (internet lenta) |
| `./scripts/stop.sh` | Para todos os serviços |
| `./scripts/rebuild.sh` | Reconstrói e reinicia |
| `./scripts/logs.sh` | Visualizador de logs interativo |
| `./scripts/status.sh` | Status completo do sistema |

## 🐛 Solução de Problemas Comuns

### Kong não inicia
```bash
docker compose run --rm kong-migrations kong migrations bootstrap
docker compose restart kong
```

### User Service não conecta
```bash
docker compose restart user-service
```

### Nginx retorna 502
```bash
docker compose restart nginx
```

### Reset completo
```bash
docker compose down -v
./scripts/start-simple.sh
```

## 🏗️ Arquitetura

### Camada de Autenticação

- **Keycloak**: Servidor de autenticação e autorização centralizado (SSO)
- **JWT Tokens**: Validação distribuída entre microsserviços

### API Gateway e Load Balancing

- **Kong API Gateway**: Gateway centralizado para roteamento, rate limiting e políticas
- **NGINX Load Balancer**: Distribuição de carga e proxy reverso

### Microsserviços Backend

- **Serviço de Autenticação (Python/Flask)**: Integração com Keycloak, gerenciamento de usuários
- **Serviço de Chat (Python/Flask)**: Chat em tempo real com WebSockets, gerenciamento de salas e mensagens

### Sistema de Mensageria

- **Kafka/RabbitMQ**: Message broker para comunicação assíncrona entre microsserviços
- **Event-driven Architecture**: Processamento de eventos em tempo real

### Frontend

- **React App (NodeJS)**: Interface client-side com Material-UI para chat em tempo real

### Camada de Dados

- **PostgreSQL**: Banco de dados principal para usuários e configurações
- **NoSQL (MongoDB/CouchDB)**: Armazenamento otimizado para mensagens de chat
- **Redis**: Cache, sessões WebSocket e broker de mensagens em tempo real

## 📁 Estrutura do Projeto

```
backend/
├── services/
│   ├── auth-service/          # Microsserviço de Autenticação
│   │   ├── app.py            # Aplicação Flask principal
│   │   ├── keycloak_integration.py # Integração com Keycloak
│   │   ├── requirements.txt  # Dependências Python
│   │   ├── Dockerfile       # Container do serviço
│   │   └── .env.example     # Variáveis de ambiente
│   └── chat-service/         # Microsserviço de Chat
│       ├── app.py           # Aplicação Flask com Socket.IO
│       ├── message_broker.py # Integração com Kafka/RabbitMQ
│       ├── requirements.txt # Dependências Python
│       ├── Dockerfile      # Container do serviço
│       └── .env.example    # Variáveis de ambiente
├── frontend/                # Aplicação React (NodeJS)
│   ├── src/
│   │   ├── components/      # Componentes React
│   │   ├── services/       # Serviços API
│   │   └── App.js          # Aplicação principal
│   ├── package.json
│   ├── Dockerfile
│   └── nginx.conf          # Configuração Nginx
├── infrastructure/          # Configurações de Infraestrutura
│   ├── kong/               # API Gateway Kong
│   │   ├── kong.yml        # Configuração do Kong
│   │   └── plugins/        # Plugins personalizados
│   ├── keycloak/           # Servidor de Autenticação
│   │   ├── keycloak.yml    # Configuração do Keycloak
│   │   └── themes/         # Temas personalizados
│   ├── kafka/              # Sistema de Mensageria
│   │   └── kafka.yml       # Configuração do Kafka/RabbitMQ
│   └── nginx/              # Load Balancer
│       └── nginx.conf      # Configuração NGINX
├── databases/              # Configurações de Banco de Dados
│   ├── postgresql/         # SQL Database (Usuários)
│   ├── mongodb/           # NoSQL Database (Chat)
│   └── redis/             # Cache e Sessões
├── docs/                  # Documentação
│   ├── arquitetura-sistema.png # Diagrama de arquitetura
│   ├── api-documentation.md    # Documentação da API
│   └── deployment-guide.md     # Guia de deployment
├── docker-compose.yml      # Orquestração completa
├── docker-compose.dev.yml  # Ambiente de desenvolvimento
├── docker-compose.prod.yml # Ambiente de produção
└── README.md
```

## 🚀 Como Executar

### Pré-requisitos

- Docker
- Docker Compose
- Git

### Configuração Rápida

1. **Clone o repositório:**

   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Configure as variáveis de ambiente:**

   ```bash
   # Serviço de Autenticação
   cp services/auth-service/.env.example services/auth-service/.env

   # Serviço de Chat
   cp services/chat-service/.env.example services/chat-service/.env

   # Frontend
   cp frontend/.env.example frontend/.env
   ```

3. **Execute o ambiente completo:**

   ```bash
   docker-compose up -d --build
   ```

4. **Acesse a aplicação:**
   - Frontend: http://localhost:3000
   - Auth Service: http://localhost:5000
   - Chat Service: http://localhost:5001
   - Aplicação completa (via Nginx): http://localhost

### Ambiente de Desenvolvimento (Apenas Backend)

Para desenvolvimento focado no backend:

```bash
docker-compose -f docker-compose.dev.yml up -d --build
```

Para o frontend em modo de desenvolvimento:

```bash
cd frontend
npm install
npm start
```

## 📊 Serviços e Portas

| Serviço                     | Porta      | Descrição                         |
| --------------------------- | ---------- | --------------------------------- |
| **Frontend (React/NodeJS)** | 3000       | Interface do usuário              |
| **NGINX Load Balancer**     | 80/443     | Load balancer e proxy reverso     |
| **Kong API Gateway**        | 8000/8443  | API Gateway e rate limiting       |
| **Keycloak**                | 8080       | Servidor de autenticação SSO      |
| **Auth Service (Flask)**    | 5000       | API de autenticação               |
| **Chat Service (Flask)**    | 5001       | API de chat e WebSocket           |
| **Kafka/RabbitMQ**          | 9092/5672  | Sistema de mensageria             |
| **PostgreSQL**              | 5432       | Banco SQL (usuários)              |
| **MongoDB/NoSQL**           | 27017      | Banco NoSQL (chat)                |
| **Redis**                   | 6379       | Cache e sessões                   |
| **Kong Admin API**          | 8001       | Interface administrativa Kong     |
| **Keycloak Admin**          | 8080/admin | Interface administrativa Keycloak |

## 🔧 Funcionalidades

### Autenticação

- ✅ Registro de usuários
- ✅ Login/Logout
- ✅ Validação JWT
- ✅ Middleware de autenticação

### Chat em Tempo Real

- ✅ Salas de chat públicas
- ✅ Mensagens em tempo real (WebSocket)
- ✅ Indicadores de digitação
- ✅ Histórico de mensagens
- ✅ Notificações de entrada/saída de usuários

### Interface

- ✅ Design responsivo com Material-UI
- ✅ Lista de salas
- ✅ Área de chat
- ✅ Indicadores de status (online/offline)
- ✅ Formulários de login/registro

## 🛠️ Tecnologias Utilizadas

### Backend (Python/Flask)

- **Flask**: Framework web minimalista
- **Flask-SocketIO**: WebSocket para comunicação em tempo real
- **Flask-SQLAlchemy**: ORM para banco de dados
- **Flask-JWT-Extended**: Autenticação JWT
- **Gunicorn**: Servidor WSGI para produção
- **Celery**: Processamento assíncrono de tarefas

### Frontend (NodeJS/React)

- **React**: Biblioteca para interfaces
- **Material-UI**: Componentes de interface
- **Socket.IO Client**: Cliente WebSocket
- **Axios**: Cliente HTTP
- **React Router**: Roteamento
- **Redux/Context API**: Gerenciamento de estado

### Autenticação e Autorização

- **Keycloak**: Servidor de identidade e acesso
- **OAuth 2.0/OpenID Connect**: Protocolos de autenticação
- **JWT**: Tokens de autenticação distribuída

### API Gateway e Load Balancing

- **Kong**: API Gateway com plugins
- **NGINX**: Load balancer e proxy reverso
- **Rate Limiting**: Controle de taxa de requisições
- **Circuit Breaker**: Padrão de resilência

### Sistema de Mensageria

- **Apache Kafka**: Streaming de eventos em tempo real
- **RabbitMQ**: Message broker AMQP
- **Event Sourcing**: Arquitetura orientada a eventos

### Banco de Dados

- **PostgreSQL**: Banco relacional (usuários, configurações)
- **MongoDB**: Banco NoSQL (mensagens de chat)
- **Redis**: Cache, sessões e pub/sub

### DevOps e Monitoramento

- **Docker**: Containerização
- **Docker Compose**: Orquestração de containers
- **Kubernetes**: Orquestração em produção (opcional)
- **Prometheus**: Métricas e monitoramento
- **Grafana**: Dashboards e visualização
- **ELK Stack**: Logs centralizados (Elasticsearch, Logstash, Kibana)

## 🔐 Segurança

### Autenticação e Autorização

- **SSO (Single Sign-On)** via Keycloak
- **OAuth 2.0 / OpenID Connect** para autenticação distribuída
- **JWT Tokens** com expiração e refresh tokens
- **Role-based Access Control (RBAC)** para permissões granulares
- **Multi-factor Authentication (MFA)** opcional

### API Security

- **API Gateway (Kong)** com rate limiting e throttling
- **CORS** configurado adequadamente
- **HTTPS/TLS** obrigatório em produção
- **API Keys** e authentication headers
- **Request/Response validation** em todos os endpoints

### Infraestrutura

- **Variáveis de ambiente** para dados sensíveis
- **Secrets management** com Docker secrets ou Vault
- **Network segmentation** entre containers
- **Firewall rules** e security groups
- **Container security scanning** com Trivy ou similar

### Monitoramento e Auditoria

- **Logging centralizado** de eventos de segurança
- **Alertas** para tentativas de acesso não autorizado
- **Audit trails** para rastreabilidade
- **Health checks** e monitoring contínuo

## 📡 API Endpoints

### Kong API Gateway (porta 8000)

Todos os requests passam pelo API Gateway com autenticação e rate limiting:

```
/api/v1/auth/*     # Rotas do serviço de autenticação
/api/v1/chat/*     # Rotas do serviço de chat
/api/v1/users/*    # Rotas de usuários
```

### Keycloak Authentication (porta 8080)

```
/auth/realms/{realm}/protocol/openid-connect/auth    # Authorization endpoint
/auth/realms/{realm}/protocol/openid-connect/token   # Token endpoint
/auth/realms/{realm}/protocol/openid-connect/userinfo # User info
/auth/admin/realms/{realm}/users                     # User management
```

### Serviço de Autenticação - via Kong (porta 5000)

```
POST /api/v1/auth/register     # Registro de usuário
POST /api/v1/auth/login        # Login via Keycloak
POST /api/v1/auth/logout       # Logout
POST /api/v1/auth/refresh      # Refresh token
GET  /api/v1/auth/profile      # Perfil do usuário
GET  /api/v1/auth/health       # Health check
```

### Serviço de Chat - via Kong (porta 5001)

```
GET  /api/v1/chat/rooms                    # Listar salas
POST /api/v1/chat/rooms                    # Criar sala
GET  /api/v1/chat/rooms/{id}               # Detalhes da sala
GET  /api/v1/chat/rooms/{id}/messages      # Histórico de mensagens
POST /api/v1/chat/rooms/{id}/messages      # Enviar mensagem (REST)
DELETE /api/v1/chat/rooms/{id}             # Deletar sala
PUT  /api/v1/chat/rooms/{id}               # Atualizar sala
GET  /api/v1/chat/health                   # Health check
```

### WebSocket Events (via Chat Service)

```
connect              # Conexão autenticada
disconnect           # Desconexão
join_room            # Entrar em sala
leave_room           # Sair da sala
send_message         # Enviar mensagem em tempo real
typing               # Indicador de digitação
user_joined          # Usuário entrou na sala
user_left            # Usuário saiu da sala
message_received     # Nova mensagem recebida
room_updated         # Sala foi atualizada
```

### Message Broker Events (Kafka/RabbitMQ)

```
user.registered      # Usuário se registrou
user.login           # Usuário fez login
room.created         # Sala foi criada
room.deleted         # Sala foi deletada
message.sent         # Mensagem foi enviada
user.joined.room     # Usuário entrou em sala
user.left.room       # Usuário saiu da sala
```

## 🧪 Desenvolvimento

### Executar Testes

```bash
# Backend
docker exec -it auth-service python -m pytest
docker exec -it chat-service python -m pytest

# Frontend
cd frontend
npm test
```

### Logs

```bash
# Ver logs de todos os serviços
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f auth-service
docker-compose logs -f chat-service
```

### Debugging

```bash
# Acessar container
docker exec -it auth-service bash
docker exec -it chat-service bash

# Verificar status dos serviços
docker-compose ps
```

## 🚀 Deploy para Produção

### Pré-requisitos de Produção

1. **Configure variáveis de ambiente de produção**
2. **Setup Kubernetes cluster ou Docker Swarm**
3. **Configure HTTPS com certificados SSL/TLS**
4. **Setup backup automatizado dos bancos de dados**
5. **Configure monitoramento e alertas**
6. **Setup CI/CD pipeline**

### Ambientes de Deploy

```bash
# Desenvolvimento
docker-compose -f docker-compose.dev.yml up -d

# Produção
docker-compose -f docker-compose.prod.yml up -d

# Kubernetes
kubectl apply -f k8s/
```

### Variáveis de Ambiente Importantes

```bash
# Keycloak
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=secure-admin-password
KEYCLOAK_DATABASE_URL=postgresql://keycloak_user:pass@keycloak-db:5432/keycloak

# Kong API Gateway
KONG_DATABASE=postgres
KONG_PG_HOST=kong-database
KONG_PG_USER=kong
KONG_PG_PASSWORD=kong-password
KONG_PROXY_ACCESS_LOG=/dev/stdout
KONG_ADMIN_ACCESS_LOG=/dev/stdout

# Segurança
JWT_SECRET_KEY=your-production-jwt-secret
SECRET_KEY=your-production-secret-key
KEYCLOAK_CLIENT_SECRET=your-keycloak-client-secret

# Bancos de dados
DATABASE_URL=postgresql://user:pass@postgres-host:5432/chatdb
MONGODB_URI=mongodb://user:pass@mongo-host:27017/chatdb
REDIS_URL=redis://redis-host:6379/0

# Message Broker
KAFKA_BROKERS=kafka1:9092,kafka2:9092,kafka3:9092
RABBITMQ_URL=amqp://user:pass@rabbitmq-host:5672/

# URLs dos serviços
KONG_GATEWAY_URL=https://api.yourdomain.com
KEYCLOAK_URL=https://auth.yourdomain.com
FRONTEND_URL=https://chat.yourdomain.com

# Monitoramento
PROMETHEUS_URL=https://metrics.yourdomain.com
GRAFANA_URL=https://dashboard.yourdomain.com
ELASTICSEARCH_URL=https://logs.yourdomain.com
```

### Setup de Monitoramento

```yaml
# docker-compose.monitoring.yml
version: "3.8"
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3001:3000"

  elasticsearch:
    image: elasticsearch:7.17.0
    ports:
      - "9200:9200"

  kibana:
    image: kibana:7.17.0
    ports:
      - "5601:5601"
```

## 🐛 Troubleshooting

### Problemas Comuns

1. **Erro de conexão do banco:**

   ```bash
   docker-compose down -v
   docker-compose up -d --build
   ```

2. **WebSocket não conecta:**

   - Verifique CORS no chat-service
   - Confirme se o Redis está funcionando
   - Valide o token JWT

3. **Frontend não carrega:**
   - Verifique se as variáveis de ambiente estão corretas
   - Confirme se os serviços backend estão rodando

### Health Checks

```bash
# Verificar serviços
curl http://localhost:5000/health
curl http://localhost:5001/health
```

## 📈 Roadmap e Próximas Funcionalidades

### Fase 1 - Funcionalidades Básicas ✅

- [x] Autenticação via Keycloak
- [x] API Gateway com Kong
- [x] Chat em tempo real
- [x] Microsserviços containerizados

### Fase 2 - Funcionalidades Avançadas 🚧

- [ ] **Salas privadas e grupos**
- [ ] **Mensagens diretas entre usuários**
- [ ] **Upload de arquivos e imagens**
- [ ] **Notificações push em tempo real**
- [ ] **Histórico de mensagens paginado**
- [ ] **Busca avançada de mensagens**

### Fase 3 - Moderação e Administração 📋

- [ ] **Sistema de moderação de salas**
- [ ] **Painel administrativo**
- [ ] **Relatórios de uso e analytics**
- [ ] **Sistema de permissões granulares**
- [ ] **Auditoria completa de ações**

### Fase 4 - Experiência do Usuário 🎨

- [ ] **Temas customizáveis (dark/light)**
- [ ] **Emojis e reações nas mensagens**
- [ ] **Status de usuário (online/ocupado/ausente)**
- [ ] **Configurações de notificação**
- [ ] **Interface mobile responsiva**

### Fase 5 - Integrações e API 🔗

- [ ] **API REST completa para mobile**
- [ ] **SDK para desenvolvedores**
- [ ] **Webhooks para integrações**
- [ ] **Integração com Slack/Discord**
- [ ] **Bot framework para automação**

### Fase 6 - Performance e Escalabilidade ⚡

- [ ] **Auto-scaling horizontal**
- [ ] **CDN para arquivos estáticos**
- [ ] **Database sharding**
- [ ] **Caching avançado com Redis Cluster**
- [ ] **WebRTC para chamadas de vídeo/áudio**

### Fase 7 - Segurança Avançada 🔒

- [ ] **End-to-end encryption**
- [ ] **Audit logs compliance**
- [ ] **GDPR compliance tools**
- [ ] **Advanced threat protection**
- [ ] **Backup e disaster recovery**

## 👥 Equipe FalaBLAU

- **Jefferson Sant'ana Galvão** - Tech Lead & Backend Developer
- **Victor Cavalcante** - Frontend Developer & UI/UX
- **Thiago Lima** - DevOps & Infrastructure Engineer

---

## 🏆 Sobre o FalaBLAU

O **FalaBLAU** é mais que um sistema de chat - é uma plataforma completa de comunicação em tempo real, desenvolvida com as melhores práticas de arquitetura de software e tecnologias modernas.

### Missão

Conectar pessoas através de uma comunicação instantânea, segura e escalável.

### Visão

Ser referência em sistemas de chat corporativo com arquitetura de microsserviços.

### Valores

- **Inovação**: Sempre utilizando as tecnologias mais avançadas
- **Qualidade**: Código limpo e bem documentado
- **Escalabilidade**: Preparado para crescer
- **Segurança**: Proteção de dados em primeiro lugar

---

## 📝 Licença

Este projeto é desenvolvido para fins educacionais como parte da especialização em desenvolvimento fullstack.

**FalaBLAU** © 2025 - Equipe 5 | Pós-Graduação Unifametro
