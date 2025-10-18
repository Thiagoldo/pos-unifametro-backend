# Sistema FullStack para Conversas em Tempo Real
## FalaBLAU

Um sistema de chat em tempo real construído com arquitetura de microsserviços, utilizando Flask (backend) e React (frontend), totalmente containerizado com Docker. Usa Kafka como broker de mensageria para eventos em tempo real e gerenciamento de sessões WebSocket.

## 🏗️ Arquitetura

### Microsserviços
- **Serviço de Autenticação (auth-service)**: Gerenciamento de usuários, login, registro e validação JWT
- **Serviço de Chat (chat-service)**: Chat em tempo real com WebSockets, gerenciamento de salas e mensagens

### Frontend
- **React App**: Interface client-side com Material-UI para chat em tempo real

### Infraestrutura
- **PostgreSQL**: Banco de dados principal
- **Kafka**: Broker de mensageria e gerenciamento de sessões WebSocket
- **Nginx**: Load balancer e proxy reverso
- **Docker**: Containerização completa

## 📁 Estrutura do Projeto

```
backend/
├── services/
│   ├── auth-service/          # Microsserviço de Autenticação
│   │   ├── app.py            # Aplicação Flask principal
│   │   ├── requirements.txt  # Dependências Python
│   │   ├── Dockerfile       # Container do serviço
│   │   └── .env.example     # Variáveis de ambiente
│   └── chat-service/         # Microsserviço de Chat
│       ├── app.py           # Aplicação Flask com Socket.IO
│       ├── requirements.txt # Dependências Python
│       ├── Dockerfile      # Container do serviço
│       └── .env.example    # Variáveis de ambiente
├── frontend/                # Aplicação React
│   ├── src/
│   │   ├── components/      # Componentes React
│   │   ├── services/       # Serviços API
│   │   └── App.js          # Aplicação principal
│   ├── package.json
│   ├── Dockerfile
│   └── nginx.conf          # Configuração Nginx
├── docker-compose.yml      # Orquestração completa
├── docker-compose.dev.yml  # Ambiente de desenvolvimento
├── nginx.conf             # Load balancer
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

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| Frontend (React) | 3000 | Interface do usuário |
| Auth Service | 5000 | API de autenticação |
| Chat Service | 5001 | API de chat e WebSocket |
| PostgreSQL | 5432 | Banco de dados |
| Kafka | 9092 | Broker de mensageria |
| Nginx | 80 | Load balancer |

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

### Backend
- **Flask**: Framework web minimalista
- **Flask-SocketIO**: WebSocket para comunicação em tempo real
- **Flask-SQLAlchemy**: ORM para banco de dados
- **Flask-JWT-Extended**: Autenticação JWT
- **PostgreSQL**: Banco de dados relacional
- **Kafka**: Broker de mensageria e gerenciamento de sessões WebSocket
- **Gunicorn**: Servidor WSGI para produção

### Frontend
- **React**: Biblioteca para interfaces
- **Material-UI**: Componentes de interface
- **Socket.IO Client**: Cliente WebSocket
- **Axios**: Cliente HTTP
- **React Router**: Roteamento

### DevOps
- **Docker**: Containerização
- **Docker Compose**: Orquestração de containers
- **Nginx**: Proxy reverso e load balancer

## 🔐 Segurança

- Autenticação JWT com expiração
- Validação de entrada de dados
- CORS configurado adequadamente
- Variáveis de ambiente para dados sensíveis
- Validação de tokens em todas as rotas protegidas

## 📡 API Endpoints

### Serviço de Autenticação (porta 5000)
```
POST /register     # Registro de usuário
POST /login        # Login
POST /verify       # Validação de token
GET  /users/me     # Dados do usuário atual
GET  /health       # Health check
```

### Serviço de Chat (porta 5001)
```
GET  /rooms                    # Listar salas
POST /rooms                    # Criar sala
GET  /rooms/{id}/messages      # Histórico de mensagens
GET  /health                   # Health check
```

### WebSocket Events
```
connect          # Conexão
join_room        # Entrar em sala
leave_room       # Sair da sala
send_message     # Enviar mensagem
typing          # Indicador de digitação
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

1. **Configure variáveis de ambiente de produção**
2. **Use HTTPS com certificados SSL**
3. **Configure backup do PostgreSQL**
4. **Monitore logs e performance**
5. **Configure auto-scaling se necessário**

### Variáveis de Ambiente Importantes
```bash
# Segurança
JWT_SECRET_KEY=your-production-jwt-secret
SECRET_KEY=your-production-secret-key

# Banco de dados
DATABASE_URL=postgresql://user:pass@host:port/db

# Kafka
KAFKA_BOOTSTRAP_SERVERS=kafka1:9092,kafka2:9092

# URLs dos serviços
AUTH_SERVICE_URL=https://auth.yourdomain.com
CHAT_SERVICE_URL=https://chat.yourdomain.com
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
   - Confirme se o Kafka (broker) está funcionando e os tópicos necessários existem
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

## 📈 Próximas Funcionalidades

- [ ] Salas privadas
- [ ] Mensagens diretas entre usuários  
- [ ] Upload de arquivos e imagens
- [ ] Notificações push
- [ ] Histórico de mensagens paginado
- [ ] Moderação de salas
- [ ] Temas customizáveis
- [ ] API REST completa para mobile

## 👥 Equipe 5 
- Jefferson Sant'ana Galvão
- Victor Cavalcante  
- Thiago Lima

---

## 📝 Licença

Este projeto é desenvolvido para fins educacionais como parte da especialização em desenvolvimento fullstack.
