from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from .config import Config

db = SQLAlchemy()

def create_app():
    """Construct the core application."""
    app = Flask(__name__)
    app.config.from_object(Config)
    
    db.init_app(app)

    with app.app_context():
        from . import routes
        
        # Register Blueprints
        app.register_blueprint(routes.users_bp)

        # Create database tables for our models
        db.create_all()

        return app
