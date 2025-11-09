# Este arquivo é para a lógica de negócios, como a interação com o Keycloak.
# Por exemplo, você poderia ter funções aqui para:
# - Criar um usuário no Keycloak
# - Obter um token de autenticação do Keycloak
# - Validar um token

import requests

class KeycloakService:
    def __init__(self, server_url, realm, client_id, client_secret):
        self.server_url = server_url
        self.realm = realm
        self.client_id = client_id
        self.client_secret = client_secret

    def get_admin_token(self):
        """Obtém o token de administrador para gerenciar o Keycloak."""
        token_url = f"{self.server_url}/realms/master/protocol/openid-connect/token"
        payload = {
            'client_id': 'admin-cli',
            'username': 'admin_user', # Isso deve ser configurado de forma segura
            'password': 'admin_password', # Isso deve ser configurado de forma segura
            'grant_type': 'password'
        }
        response = requests.post(token_url, data=payload)
        response.raise_for_status()
        return response.json()['access_token']

    # Adicione mais métodos para registro de usuário, login, etc.
