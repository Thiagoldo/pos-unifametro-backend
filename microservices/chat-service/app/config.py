import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Set Flask configuration from environment variables."""

    # Database
    # The MONGODB_URL from docker-compose is automatically used by Flask-PyMongo as MONGO_URI
    MONGO_URI = os.getenv("MONGODB_URL")
