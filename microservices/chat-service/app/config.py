import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Define as configurações do Flask a partir de variáveis de ambiente."""

    # Banco de Dados
    # A variável MONGODB_URL do docker-compose é usada automaticamente pelo Flask-PyMongo como MONGO_URI
    MONGO_URI = os.getenv("MONGODB_URL")
