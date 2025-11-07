# Diagrams

## 1. User Registration and Authentication

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant user-service
    participant Keycloak
    participant PostgreSQL

    Client->>Kong: POST /api/users/register
    Kong->>user-service: /register
    user-service->>Keycloak: Register user
    Keycloak-->>user-service: User registered
    user-service->>PostgreSQL: Save user info
    PostgreSQL-->>user-service: User saved
    user-service-->>Kong: Response
    Kong-->>Client: Response
```

### User Story

```mermaid
graph TD
    A[User wants to register] --> B{Fills registration form};
    B --> C[Submits form];
    C --> D{System creates user in Keycloak};
    D --> E[System saves user in database];
    E --> F[User is successfully registered];
```

## 2. Sending a Chat Message

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant chat-service
    participant MongoDB
    participant RabbitMQ
    participant websocket-service

    Client->>Kong: POST /api/chats/{chat_id}/messages
    Kong->>chat-service: /{chat_id}/messages
    chat-service->>MongoDB: Save message
    MongoDB-->>chat-service: Message saved
    chat-service->>RabbitMQ: Publish message to '''chat_messages''' queue
    RabbitMQ-->>websocket-service: Consume message from queue
    websocket-service->>Client: Emit '''new_message''' event via WebSocket
```

### User Story

```mermaid
graph TD
    A[User wants to send a message] --> B{Types message in chat};
    B --> C[Clicks send];
    C --> D{System saves message in database};
    D --> E[System sends message to queue];
    E --> F{WebSocket service gets message};
    F --> G[WebSocket service sends message to chat participants];
    G --> H[Users in chat receive the message in real-time];
```

## 3. Real-time Notifications

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant user-service
    participant RabbitMQ
    participant websocket-service
    participant Client

    user-service->>RabbitMQ: Publish notification to '''notifications''' queue
    RabbitMQ-->>websocket-service: Consume notification from queue
    websocket-service->>Client: Emit '''new_notification''' event via WebSocket
```

### User Story

```mermaid
graph TD
    A[A new contact is added] --> B{user-service sends a notification event};
    B --> C[Event is published to a queue];
    C --> D{WebSocket service gets the event};
    D --> E[WebSocket service sends notification to the user];
    E --> F[User receives a real-time notification];
```

## 4. User Login

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant user-service
    participant Keycloak

    Client->>Kong: POST /api/users/login
    Kong->>user-service: /login
    user-service->>Keycloak: Validate credentials
    Keycloak-->>user-service: Access token
    user-service-->>Kong: Response with token
    Kong-->>Client: Response with token
```

## 5. Search and Connect with User

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant user-service
    participant PostgreSQL
    participant RabbitMQ

    Client->>Kong: GET /api/users/search?query={query}
    Kong->>user-service: /search?query={query}
    user-service->>PostgreSQL: Search user
    PostgreSQL-->>user-service: User list
    user-service-->>Kong: Response
    Kong-->>Client: Response

    Client->>Kong: POST /api/users/connect
    Kong->>user-service: /connect
    user-service->>PostgreSQL: Create connection request
    PostgreSQL-->>user-service: Request created
    user-service->>RabbitMQ: Publish to '''notifications''' queue
```

## 6. Connection Request Notification

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant websocket-service
    participant Client
    participant Kong
    participant user-service
    participant PostgreSQL

    websocket-service->>Client: Emit '''new_connection_request'''
    Client->>Kong: POST /api/users/connections/{id}/respond
    Kong->>user-service: /connections/{id}/respond
    user-service->>PostgreSQL: Update connection status
    PostgreSQL-->>user-service: Status updated
```

## 7. Start a Chat

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant chat-service
    participant MongoDB
    participant websocket-service

    Client->>Kong: POST /api/chats
    Kong->>chat-service: /chats
    chat-service->>MongoDB: Create chat room
    MongoDB-->>chat-service: Chat room created
    chat-service-->>Kong: Response with chat ID
    Kong-->>Client: Response with chat ID
    Client->>websocket-service: Connect to chat room
```

## 8. User Profile Management

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant user-service
    participant PostgreSQL

    Client->>Kong: GET /api/users/profile
    Kong->>user-service: /profile
    user-service->>PostgreSQL: Get user profile
    PostgreSQL-->>user-service: User profile
    user-service-->>Kong: Response
    Kong-->>Client: Response

    Client->>Kong: PUT /api/users/profile
    Kong->>user-service: /profile
    user-service->>PostgreSQL: Update user profile
    PostgreSQL-->>user-service: Profile updated
    user-service-->>Kong: Response
    Kong-->>Client: Response
```

### User Story

```mermaid
graph TD
    A[User wants to view their profile] --> B{Clicks on profile page};
    B --> C[System fetches and displays user profile];
    C --> D{User wants to update their profile};
    D --> E[User edits profile information];
    E --> F[Submits changes];
    F --> G[System updates profile in database];
```

## 9. Notification Management

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant user-service
    participant PostgreSQL
    participant RabbitMQ

    Client->>Kong: GET /api/users/notifications
    Kong->>user-service: /notifications
    user-service->>PostgreSQL: Get notifications
    PostgreSQL-->>user-service: Notification list
    user-service-->>Kong: Response
    Kong-->>Client: Response

    Client->>Kong: POST /api/users/notifications
    Kong->>user-service: /notifications
    user-service->>PostgreSQL: Create notification
    PostgreSQL-->>user-service: Notification created
    user-service->>RabbitMQ: Publish to '''notifications''' queue
    user-service-->>Kong: Response
    Kong-->>Client: Response
```

### User Story

```mermaid
graph TD
    A[User wants to see their notifications] --> B{Clicks on notifications icon};
    B --> C[System fetches and displays notifications];
    C --> D{A new notification is created by the system};
    D --> E[System saves notification in database];
    E --> F[System sends notification to a queue for real-time update];
```

## 10. Chat Management

### Data Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Kong
    participant chat-service
    participant MongoDB

    Client->>Kong: GET /api/chats
    Kong->>chat-service: /
    chat-service->>MongoDB: Get all chats
    MongoDB-->>chat-service: Chat list
    chat-service-->>Kong: Response
    Kong-->>Client: Response

    Client->>Kong: GET /api/chats/{chat_id}/messages
    Kong->>chat-service: /{chat_id}/messages
    chat-service->>MongoDB: Get messages
    MongoDB-->>chat-service: Message list
    chat-service-->>Kong: Response
    Kong-->>Client: Response

    Client->>Kong: GET /api/chats/{chat_id}/participants
    Kong->>chat-service: /{chat_id}/participants
    chat-service->>MongoDB: Get participants
    MongoDB-->>chat-service: Participant list
    chat-service-->>Kong: Response
    Kong-->>Client: Response
```

### User Story

```mermaid
graph TD
    A[User wants to see their chats] --> B{Clicks on chat list};
    B --> C[System fetches and displays the list of chats];
    C --> D{User opens a chat};
    D --> E[System fetches and displays chat messages];
    E --> F{User wants to see who is in the chat};
    F --> G[System fetches and displays chat participants];
```