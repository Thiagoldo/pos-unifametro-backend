# FalaBLAU - Sistema de Chat em Tempo Real

![FalaBLAU Logo](public/fala-blau.jpeg)

Um sistema de chat em tempo real construído com arquitetura de microsserviços, utilizando Flask para o backend, e totalmente containerizado com Docker.

![Arquitetura do Sistema](public/arquitetura-sistema.jpeg)

## 🏗️ Arquitetura

O projeto é composto pelos seguintes serviços:

- **nginx**: Atua como um proxy reverso para os outros serviços.
- **kong**: API Gateway para gerenciar as rotas e o acesso aos microsserviços.
- **keycloak**: Lida com a autenticação e autorização de usuários.
- **user-service**: Microsserviço para gerenciar usuários, perfis e contatos. Utiliza **PostgreSQL** como banco de dados.
- **chat-service**: Microsserviço para gerenciar as salas de chat e mensagens. Utiliza **MongoDB** como banco de dados.
- **websocket-service**: Lida com a comunicação em tempo real usando WebSockets e se comunica com outros serviços através do **RabbitMQ**.
- **postgresql**: Banco de dados relacional para o `user-service`.
- **mongodb**: Banco de dados NoSQL para o `chat-service`.
- **rabbitmq**: Message broker para a comunicação assíncrona entre os serviços.

## 📁 Estrutura do Projeto

```
.
├── docker
│   └── docker-compose.yaml
├── kong
│   └── kong.yaml
├── microservices
│   ├── chat-service
│   ├── users-service
│   └── websocket-service
├── nginx
│   └── nginx.conf
├── public
│   ├── arquitetura-sistema.jpeg
│   └── fala-blau.jpeg
├── index.html
└── README.md
```

## 🚀 Como Executar

### Pré-requisitos

- Docker
- Docker Compose

### Configuração

1. **Clone o repositório:**

   ```bash
   git clone <repository-url>
   cd pos-unifametro-backend/docker
   ```

2. **Inicie os serviços:**

   ```bash
   docker-compose up -d --build
   ```

A aplicação estará disponível em `http://localhost`.

## 📄 Documentação

Para mais detalhes sobre a arquitetura e o fluxo de dados do sistema, consulte os seguintes documentos:

- **[Fluxo de Dados](docs/fluxo-de-dados.md)**: Descreve como os dados fluem entre os diferentes microsserviços.
- **[Diagramas de Arquitetura](docs/diagrams.md)**: Contém diagramas que ilustram a arquitetura do sistema.


## 📊 Serviços e Portas

| Serviço             | Porta      | Descrição                                      |
| ------------------- | ---------- | ---------------------------------------------- |
| **nginx**           | 80         | Proxy reverso para todos os serviços           |
| **kong**            | 8000       | API Gateway                                    |
| **keycloak**        | 8080       | Servidor de autenticação                       |
| **user-service**    | 3001       | Microsserviço de usuários                      |
| **chat-service**    | 3002       | Microsserviço de chat                          |
| **websocket-service** | 3003       | Serviço de WebSocket para comunicação real-time|

## 📡 API Endpoints

As rotas da API são gerenciadas pelo Kong API Gateway.

- **User Service**: `http://localhost/api/users`
- **Chat Service**: `http://localhost/api/chats`
- **WebSocket Service**: `ws://localhost/socket.io`

Para mais detalhes sobre os endpoints de cada serviço, consulte a documentação Swagger UI de cada um:

- **User Service Docs**: `http://localhost:3001/doc`
- **Chat Service Docs**: `http://localhost:3002/doc`
- **WebSocket Service AsyncAPI**: `http://localhost:3003/asyncapi` (Exposto pelo `asyncapi.yaml`)

## 🏛️ Áreas Administrativas

Para acessar as áreas administrativas dos serviços, utilize os seguintes endereços:

- **Keycloak**:
  - **URL**: `http://localhost/auth/`
  - **Usuário**: `admin`
  - **Senha**: `admin`

- **RabbitMQ**:
  - **URL**: `http://localhost/rabbitmq/`
  - **Usuário**: `guest`
  - **Senha**: `guest`