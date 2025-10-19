from flask import Flask
from flask_pymongo import PyMongo
from .config import Config

mongo = PyMongo()

def create_app():
    """Construct the core application."""
    app = Flask(__name__)
    app.config.from_object(Config)
    
    mongo.init_app(app)

    with app.app_context():
        from . import routes
        
        # Register Blueprints
        app.register_blueprint(routes.chat_bp)

        return app
