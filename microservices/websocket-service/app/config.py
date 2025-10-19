import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Set Flask configuration from environment variables."""
    SECRET_KEY = os.getenv("SECRET_KEY", "my-precious-secret-key")
    RABBITMQ_URL = os.getenv("RABBITMQ_URL")
