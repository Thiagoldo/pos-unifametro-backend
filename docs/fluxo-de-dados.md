# Documentação do Fluxo de Dados

Este documento descreve a arquitetura e o fluxo de dados entre os diferentes componentes do sistema de chat, com foco nas interações entre os microsserviços.

## Visão Geral da Arquitetura

O sistema é baseado em uma arquitetura de microsserviços orquestrada com Docker Compose. Os principais componentes são:

*   **Nginx:** Atua como reverse proxy, sendo a porta de entrada principal da aplicação (`:80`).
*   **Kong API Gateway:** Gerencia e roteia as requisições para os microsserviços apropriados.
*   **Keycloak:** Serviço de Identity and Access Management (IAM), responsável pela autenticação e autorização dos usuários.
*   **Microsserviços:**
    *   `user-service`: Gerencia dados de usuários, perfis, contatos e notificações.
    *   `chat-service`: Gerencia salas de chat e o histórico de mensagens.
    *   `websocket-service`: Gerencia a comunicação em tempo real com os clientes via WebSockets.
*   **Bancos de Dados e Mensageria:**
    *   **PostgreSQL:** Usado pelo `user-service`.
    *   **MongoDB:** Usado pelo `chat-service`.
    *   **RabbitMQ:** Usado como um message broker para a comunicação assíncrona entre o `chat-service` e o `websocket-service`.

![Arquitetura do Sistema](../public/arquitetura-sistema.jpeg)

---

## Fluxos de Dados Detalhados

### 1. Registro e Autenticação de Usuário

Este fluxo descreve como um novo usuário é criado e autenticado no sistema.

1.  **Requisição do Cliente:** O cliente (front-end) envia uma requisição `POST /api/users/register` para o **Kong API Gateway**.
2.  **Roteamento:** O **Kong** roteia a requisição para o `user-service`.
3.  **Interação com Keycloak:** O `user-service` se comunica com o **Keycloak** para registrar o novo usuário no provedor de identidade.
4.  **Persistência de Dados:** Após o sucesso no registro do Keycloak, o `user-service` salva as informações do usuário (incluindo o `keycloak_id` retornado) em seu banco de dados **PostgreSQL**.
5.  **Login:** O processo de login (`POST /api/users/login`) segue um fluxo semelhante, onde o `user-service` valida as credenciais contra o **Keycloak** para emitir tokens de acesso.

### 2. Envio de Mensagem no Chat

Este é o fluxo principal de comunicação e demonstra a interação síncrona e assíncrona entre os serviços.

1.  **Requisição do Cliente:** Um usuário autenticado envia uma nova mensagem através de uma requisição `POST /api/chats/{chat_id}/messages` para o **Kong API Gateway**.
2.  **Roteamento:** O **Kong** roteia a requisição para o `chat-service`.
3.  **Persistência da Mensagem (Fluxo Síncrono):** O `chat-service` recebe a requisição, valida os dados e salva a nova mensagem em sua coleção no banco de dados **MongoDB**.
4.  **Publicação no RabbitMQ (Fluxo Assíncrono):** Após salvar a mensagem, o `chat-service` publica um evento (contendo a mensagem, o autor, e o `chat_id`) na fila `chat_messages` do **RabbitMQ**. Este passo é crucial para desacoplar o serviço de chat da entrega em tempo real.
5.  **Consumo pelo WebSocket Service:** O `websocket-service` possui um consumidor (`queue_consumer`) que está constantemente escutando a fila `chat_messages`. Ao receber a nova mensagem, ele a processa.
6.  **Transmissão via WebSocket:** O `websocket-service` emite um evento `new_message` através da conexão WebSocket para todos os clientes que estão na "sala" correspondente àquele `chat_id`.
7.  **Recebimento pelo Cliente:** Os clientes (front-end) que estão escutando o evento `new_message` recebem os dados e atualizam a interface do chat em tempo real, exibindo a nova mensagem para todos os participantes da conversa.

### 3. Notificações em Tempo Real

O sistema também suporta outros eventos em tempo real, como notificações, usando uma arquitetura similar.

1.  **Criação da Notificação:** Um serviço (por exemplo, o `user-service` ao receber um novo contato) publica uma mensagem na fila `notifications` do **RabbitMQ**.
2.  **Consumo e Transmissão:** O `websocket-service` consome a mensagem da fila `notifications`.
3.  **Emissão do Evento:** Ele emite um evento (ex: `new_notification`) via WebSocket para o usuário específico (ou para uma sala de notificações do usuário).
4.  **Exibição no Cliente:** O front-end recebe o evento e exibe a notificação ao usuário.

### 4. Login do Usuário

1.  **Requisição do Cliente:** O cliente envia uma requisição `POST /api/users/login` para o **Kong API Gateway**.
2.  **Roteamento:** O **Kong** roteia a requisição para o `user-service`.
3.  **Validação no Keycloak:** O `user-service` valida as credenciais com o **Keycloak**.
4.  **Emissão de Token:** O **Keycloak** retorna um token de acesso.
5.  **Resposta ao Cliente:** O `user-service` retorna o token para o cliente.

### 5. Busca e Conexão com Usuário

1.  **Busca de Usuário:** O cliente envia `GET /api/users/search?query={query}` para o **Kong**, que roteia para o `user-service`. O serviço busca no **PostgreSQL** e retorna uma lista de usuários.
2.  **Pedido de Conexão:** O cliente envia `POST /api/users/connect` com o ID do usuário alvo.
3.  **Criação da Notificação:** O `user-service` cria uma notificação de pedido de conexão no **PostgreSQL**.
4.  **Publicação no RabbitMQ:** O `user-service` publica um evento na fila `notifications` do **RabbitMQ**.

### 6. Notificação de Pedido de Conexão

1.  **Consumo pelo WebSocket Service:** O `websocket-service` consome a mensagem da fila `notifications`.
2.  **Transmissão via WebSocket:** O `websocket-service` emite um evento `new_connection_request` para o usuário alvo.
3.  **Aceite/Recusa da Conexão:** O cliente do usuário alvo envia `POST /api/users/connections/{id}/respond` com a resposta.
4.  **Atualização de Status:** O `user-service` atualiza o status da conexão no **PostgreSQL**.

### 7. Início de um Chat

1.  **Requisição de Início de Chat:** O cliente envia `POST /api/chats` para o **Kong**, que roteia para o `chat-service`.
2.  **Criação da Sala de Chat:** O `chat-service` cria uma nova sala de chat no **MongoDB**.
3.  **Resposta ao Cliente:** O `chat-service` retorna o ID da nova sala de chat.
4.  **Conexão WebSocket:** O cliente se conecta ao `websocket-service` usando o ID da sala para receber mensagens em tempo real.

Este modelo de comunicação assíncrona via RabbitMQ garante que o sistema seja resiliente e escalável, permitindo que os serviços de escrita (como `chat-service`) não precisem se preocupar com a lógica de entrega em tempo real para os clientes.

### 8. Gerenciamento de Perfil de Usuário

1.  **Busca de Perfil:** O cliente envia `GET /api/users/profile` para o **Kong**, que roteia para o `user-service`. O serviço busca o perfil do usuário autenticado no **PostgreSQL** e o retorna.
2.  **Atualização de Perfil:** O cliente envia `PUT /api/users/profile` com os dados a serem atualizados. O `user-service` atualiza as informações do perfil no **PostgreSQL**.

### 9. Gerenciamento de Notificações

1.  **Busca de Notificações:** O cliente envia `GET /api/users/notifications` para o **Kong**, que roteia para o `user-service`. O serviço busca as notificações do usuário no **PostgreSQL** e as retorna.
2.  **Criação de Notificação:** O cliente envia `POST /api/users/notifications` com os dados da notificação. O `user-service` cria a notificação no **PostgreSQL** e, se necessário, publica um evento no **RabbitMQ** para notificação em tempo real.

### 10. Gerenciamento de Chats

1.  **Listar Chats:** O cliente envia `GET /api/chats` para o **Kong**, que roteia para o `chat-service`. O serviço busca e retorna a lista de chats do usuário.
2.  **Obter Mensagens:** O cliente envia `GET /api/chats/{chat_id}/messages` para o **Kong**, que roteia para o `chat-service`. O serviço busca e retorna as mensagens de um chat específico.
3.  **Obter Participantes:** O cliente envia `GET /api/chats/{chat_id}/participants` para o **Kong**, que roteia para o `chat-service`. O serviço busca e retorna os participantes de um chat específico.