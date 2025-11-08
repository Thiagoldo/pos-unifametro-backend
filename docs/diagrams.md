# Diagramas

## 1. Registro e Autenticação de Usuário

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant user-service
    participant Keycloak
    participant PostgreSQL

    Cliente->>Kong: POST /api/users/register
    Kong->>user-service: /register
    user-service->>Keycloak: Registrar usuário
    Keycloak-->>user-service: Usuário registrado
    user-service->>PostgreSQL: Salvar informações do usuário
    PostgreSQL-->>user-service: Usuário salvo
    user-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta
```

### História de Usuário

```mermaid
graph TD
    A[Usuário quer se registrar] --> B{Preenche formulário de registro};
    B --> C[Envia formulário];
    C --> D{Sistema cria usuário no Keycloak};
    D --> E[Sistema salva usuário no banco de dados];
    E --> F[Usuário é registrado com sucesso];
```

## 2. Envio de Mensagem de Chat

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant chat-service
    participant MongoDB
    participant RabbitMQ
    participant websocket-service

    Cliente->>Kong: POST /api/chats/{chat_id}/messages
    Kong->>chat-service: /{chat_id}/messages
    chat-service->>MongoDB: Salvar mensagem
    MongoDB-->>chat-service: Mensagem salva
    chat-service->>RabbitMQ: Publicar mensagem na fila '''chat_messages'''
    RabbitMQ-->>websocket-service: Consumir mensagem da fila
    websocket-service->>Cliente: Emitir evento '''new_message''' via WebSocket
```

### História de Usuário

```mermaid
graph TD
    A[Usuário quer enviar uma mensagem] --> B{Digita a mensagem no chat};
    B --> C[Clica em enviar];
    C --> D{Sistema salva mensagem no banco de dados};
    D --> E[Sistema envia mensagem para a fila];
    E --> F{Serviço WebSocket obtém a mensagem};
    F --> G[Serviço WebSocket envia mensagem para os participantes do chat];
    G --> H[Usuários no chat recebem a mensagem em tempo real];
```

## 3. Notificações em Tempo Real

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant user-service
    participant RabbitMQ
    participant websocket-service
    participant Cliente

    user-service->>RabbitMQ: Publicar notificação na fila '''notifications'''
    RabbitMQ-->>websocket-service: Consumir notificação da fila
    websocket-service->>Cliente: Emitir evento '''new_notification''' via WebSocket
```

### História de Usuário

```mermaid
graph TD
    A[Um novo contato é adicionado] --> B{user-service envia um evento de notificação};
    B --> C[Evento é publicado em uma fila];
    C --> D{Serviço WebSocket obtém o evento};
    D --> E[Serviço WebSocket envia notificação para o usuário];
    E --> F[Usuário recebe uma notificação em tempo real];
```

## 4. Login de Usuário

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant user-service
    participant Keycloak

    Cliente->>Kong: POST /api/users/login
    Kong->>user-service: /login
    user-service->>Keycloak: Validar credenciais
    Keycloak-->>user-service: Token de acesso
    user-service-->>Kong: Resposta com token
    Kong-->>Cliente: Resposta com token
```

## 5. Pesquisar e Conectar com Usuário

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant user-service
    participant PostgreSQL
    participant RabbitMQ

    Cliente->>Kong: GET /api/users/search?query={query}
    Kong->>user-service: /search?query={query}
    user-service->>PostgreSQL: Pesquisar usuário
    PostgreSQL-->>user-service: Lista de usuários
    user-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta

    Cliente->>Kong: POST /api/users/connect
    Kong->>user-service: /connect
    user-service->>PostgreSQL: Criar solicitação de conexão
    PostgreSQL-->>user-service: Solicitação criada
    user-service->>RabbitMQ: Publicar na fila '''notifications'''
```

## 6. Notificação de Solicitação de Conexão

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant websocket-service
    participant Cliente
    participant Kong
    participant user-service
    participant PostgreSQL

    websocket-service->>Cliente: Emitir '''new_connection_request'''
    Cliente->>Kong: POST /api/users/connections/{id}/respond
    Kong->>user-service: /connections/{id}/respond
    user-service->>PostgreSQL: Atualizar status da conexão
    PostgreSQL-->>user-service: Status atualizado
```

## 7. Iniciar um Chat

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant chat-service
    participant MongoDB
    participant websocket-service

    Cliente->>Kong: POST /api/chats
    Kong->>chat-service: /chats
    chat-service->>MongoDB: Criar sala de chat
    MongoDB-->>chat-service: Sala de chat criada
    chat-service-->>Kong: Resposta com ID do chat
    Kong-->>Cliente: Resposta com ID do chat
    Cliente->>websocket-service: Conectar à sala de chat
```

## 8. Gerenciamento de Perfil de Usuário

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant user-service
    participant PostgreSQL

    Cliente->>Kong: GET /api/users/profile
    Kong->>user-service: /profile
    user-service->>PostgreSQL: Obter perfil do usuário
    PostgreSQL-->>user-service: Perfil do usuário
    user-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta

    Cliente->>Kong: PUT /api/users/profile
    Kong->>user-service: /profile
    user-service->>PostgreSQL: Atualizar perfil do usuário
    PostgreSQL-->>user-service: Perfil atualizado
    user-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta
```

### História de Usuário

```mermaid
graph TD
    A[Usuário quer ver seu perfil] --> B{Clica na página de perfil};
    B --> C[Sistema busca e exibe o perfil do usuário];
    C --> D{Usuário quer atualizar seu perfil};
    D --> E[Usuário edita as informações do perfil];
    E --> F[Envia as alterações];
    F --> G[Sistema atualiza o perfil no banco de dados];
```

## 9. Gerenciamento de Notificações

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant user-service
    participant PostgreSQL
    participant RabbitMQ

    Cliente->>Kong: GET /api/users/notifications
    Kong->>user-service: /notifications
    user-service->>PostgreSQL: Obter notificações
    PostgreSQL-->>user-service: Lista de notificações
    user-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta

    Cliente->>Kong: POST /api/users/notifications
    Kong->>user-service: /notifications
    user-service->>PostgreSQL: Criar notificação
    PostgreSQL-->>user-service: Notificação criada
    user-service->>RabbitMQ: Publicar na fila '''notifications'''
    user-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta
```

### História de Usuário

```mermaid
graph TD
    A[Usuário quer ver suas notificações] --> B{Clica no ícone de notificações};
    B --> C[Sistema busca e exibe as notificações];
    C --> D{Uma nova notificação é criada pelo sistema};
    D --> E[Sistema salva notificação no banco de dados];
    E --> F[Sistema envia notificação para uma fila para atualização em tempo real];
```

## 10. Gerenciamento de Chat

### Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant Cliente
    participant Kong
    participant chat-service
    participant MongoDB

    Cliente->>Kong: GET /api/chats
    Kong->>chat-service: /
    chat-service->>MongoDB: Obter todos os chats
    MongoDB-->>chat-service: Lista de chats
    chat-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta

    Cliente->>Kong: GET /api/chats/{chat_id}/messages
    Kong->>chat-service: /{chat_id}/messages
    chat-service->>MongoDB: Obter mensagens
    MongoDB-->>chat-service: Lista de mensagens
    chat-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta

    Cliente->>Kong: GET /api/chats/{chat_id}/participants
    Kong->>chat-service: /{chat_id}/participants
    chat-service->>MongoDB: Obter participantes
    MongoDB-->>chat-service: Lista de participantes
    chat-service-->>Kong: Resposta
    Kong-->>Cliente: Resposta
```

### História de Usuário

```mermaid
graph TD
    A[Usuário quer ver seus chats] --> B{Clica na lista de chats};
    B --> C[Sistema busca e exibe a lista de chats];
    C --> D{Usuário abre um chat};
    D --> E[Sistema busca e exibe as mensagens do chat];
    E --> F{Usuário quer ver quem está no chat};
    F --> G[Sistema busca e exibe os participantes do chat];
```
