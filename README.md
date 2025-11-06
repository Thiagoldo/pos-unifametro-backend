# FalaBLAU - Sistema de Chat em Tempo Real

![FalaBLAU Logo](public/fala-blau.jpeg)

Um sistema de chat em tempo real construído com arquitetura de microsserviços, utilizando Flask para o backend, e totalmente containerizado com Docker.

![Arquitetura do Sistema](public/arquitetura-sistema.jpeg)

## 📜 Sumário

- [Funcionalidades](#-funcionalidades)
- [Arquitetura](#️-arquitetura)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Como Executar](#-como-executar)
- [Documentação](#-documentação)
- [Serviços e Portas](#-serviços-e-portas)
- [API Endpoints](#-api-endpoints)
- [Áreas Administrativas](#-áreas-administrativas)
- [Variáveis de Ambiente](#-variáveis-de-ambiente)

## ✨ Funcionalidades

- [ ] Autenticação e autorização de usuários com Keycloak.
- [ ] Gerenciamento de usuários, perfis e contatos.
- [ ] Criação e gerenciamento de salas de chat.
- [ ] Envio e recebimento de mensagens em tempo real.
- [ ] Notificações de mensagens e status de usuário.

## 🏗️ Arquitetura

O projeto é composto pelos seguintes serviços:

- **nginx**: Atua como um proxy reverso para os outros serviços e serve o frontend.
- **frontend**: Aplicação web construída com React, TypeScript e Tailwind CSS.
- **kong**: API Gateway para gerenciar as rotas e o acesso aos microsserviços.
- **keycloak**: Lida com a autenticação e autorização de usuários.
- **user-service**: Microsserviço para gerenciar usuários, perfis e contatos.
- **chat-service**: Microsserviço para gerenciar as salas de chat e mensagens.
- **websocket-service**: Lida com a comunicação em tempo real usando WebSockets.
- **postgresql**: Banco de dados relacional para o `user-service`.
- **mongodb**: Banco de dados NoSQL para o `chat-service`.
- **rabbitmq**: Message broker para a comunicação assíncrona entre os serviços.

## 🛠️ Tecnologias Utilizadas

- **Frontend**: React, TypeScript, Tailwind CSS
- **Backend**: Python, Flask, Flask-RESTX, Flask-SocketIO
- **Banco de Dados**: PostgreSQL, MongoDB
- **Mensageria**: RabbitMQ
- **Autenticação**: Keycloak
- **API Gateway**: Kong
- **Containerização**: Docker, Docker Compose
- **Comunicação em Tempo Real**: WebSockets
- **Servidor WSGI**: Gunicorn, Eventlet
- **Outros**: Pika (para RabbitMQ), Kombu, Psycopg2, PyMongo

## 📁 Estrutura do Projeto

```
.
├── docker
│   └── docker-compose.yaml
├── frontend
│   ├── public
│   │   └── index.html
│   ├── src
│   │   ├── components
│   │   │   ├── Chat.tsx
│   │   │   └── Login.tsx
│   │   ├── App.tsx
│   │   ├── index.css
│   │   ├── index.tsx
│   │   └── reportWebVitals.ts
│   ├── .env.example
│   ├── package.json
│   ├── tsconfig.json
│   └── Dockerfile
├── kong
│   ├── config
│   │   └── kong.yaml
│   └── docker
│       └── Dockerfile
├── microservices
│   ├── chat-service
│   │   ├── docker
│   │   │   └── Dockerfile
│   │   └── src
│   ├── users-service
│   │   ├── docker
│   │   │   └── Dockerfile
│   │   └── src
│   └── websocket-service
│       ├── docker
│       │   └── Dockerfile
│       └── src
├── nginx
│   ├── config
│   │   └── nginx.conf
│   └── docker
│       └── Dockerfile
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
   cd pos-unifametro-backend
   ```

2. **Inicie os serviços (incluindo o frontend):**

   ```bash
   docker-compose -f docker/docker-compose.yaml up -d --build
   ```

A aplicação estará disponível em `http://localhost`.

## 📄 Documentação

Para mais detalhes sobre a arquitetura e o fluxo de dados do sistema, consulte os seguintes documentos:

- **[Fluxo de Dados](docs/fluxo-de-dados.md)**: Descreve como os dados fluem entre os diferentes microsserviços.
- **[Diagramas de Arquitetura](docs/diagrams.md)**: Contém diagramas que ilustram a arquitetura do sistema.

## 📊 Serviços e Portas

| Serviço             | Porta      | Descrição                                      |
| ------------------- | ---------- | ---------------------------------------------- |
| **Frontend**        | 80         | Aplicação web (servida pelo Nginx)             |
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

- **User Service Docs**: `http://localhost/api/chats/doc`
- **Chat Service Docs**: `http://localhost/api/chats/doc`
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

## 📝 Variáveis de Ambiente

O projeto utiliza um arquivo `.env` para configurar as variáveis de ambiente. Para configurar o ambiente local, siga os seguintes passos:

1. **Crie uma cópia do arquivo de exemplo:**

   ```bash
   cp .env.example .env
   ```

2. **Altere as variáveis no arquivo `.env` conforme necessário.**

O arquivo `.env` é ignorado pelo Git, então suas chaves e senhas não serão enviadas para o repositório.