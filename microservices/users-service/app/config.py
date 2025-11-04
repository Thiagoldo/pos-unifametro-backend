import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Define as configurações do Flask a partir de variáveis de ambiente."""

    # Banco de Dados
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
