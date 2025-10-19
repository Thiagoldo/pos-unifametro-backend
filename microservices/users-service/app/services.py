# This file is for business logic, such as interacting with Keycloak.
# For example, you could have functions here to:
# - Create a user in Keycloak
# - Get an authentication token from Keycloak
# - Validate a token

import requests

class KeycloakService:
    def __init__(self, server_url, realm, client_id, client_secret):
        self.server_url = server_url
        self.realm = realm
        self.client_id = client_id
        self.client_secret = client_secret

    def get_admin_token(self):
        """Get admin token to manage Keycloak."""
        token_url = f"{self.server_url}/realms/master/protocol/openid-connect/token"
        payload = {
            'client_id': 'admin-cli',
            'username': 'admin_user', # This should be configured securely
            'password': 'admin_password', # This should be configured securely
            'grant_type': 'password'
        }
        response = requests.post(token_url, data=payload)
        response.raise_for_status()
        return response.json()['access_token']

    # Add more methods for user registration, login, etc.
