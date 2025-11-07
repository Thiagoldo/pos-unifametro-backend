# Histórico de Alterações

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/spec/v2.0.0.html).

## [0.1.0] - 2025-11-07

### Adicionado
- **Componentes de Arquitetura:**
  - Configuração inicial de uma arquitetura baseada em microsserviços.
  - Pré-configuração do API Gateway (Kong) para futuro roteamento de APIs.
  - Pré-configuração do Proxy Reverso (Nginx) para servir o frontend.
  - Pré-configuração do Keycloak para autenticação e autorização de usuários.
  - Pré-configuração do Message Broker (RabbitMQ) para comunicação assíncrona.
  - Estrutura básica para `user-service`, `chat-service` e `websocket-service` com endpoints de exemplo.
- **Gerenciamento de Dados:**
  - Configuração do PostgreSQL para dados relacionais.
  - Configuração do MongoDB para dados não relacionais.
- **Desenvolvimento e Implantação:**
  - Configurações do Docker e Docker Compose para containerizar todos os serviços.
  - Estrutura inicial do projeto para a aplicação frontend (React, TypeScript, Tailwind CSS).
  - Estrutura inicial do projeto para os microsserviços de backend (Python, Flask).
- **Interface de Usuário:**
  - Layout básico da interface de usuário para o chat.

### Modificado
- O projeto está em sua fase inicial de configuração. As funcionalidades principais estão planejadas, mas ainda não foram implementadas. Os endpoints são exemplos e não estão totalmente funcionais.

### Removido
- N/A