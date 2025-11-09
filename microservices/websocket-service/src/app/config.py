import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Define as configurações do Flask a partir de variáveis de ambiente."""
    SECRET_KEY = os.getenv("SECRET_KEY", "my-precious-secret-key")
    RABBITMQ_URL = os.getenv("RABBITMQ_URL")
