import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Set Flask configuration from environment variables."""

    # Database
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
