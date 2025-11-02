from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from .config import Config
from werkzeug.middleware.proxy_fix import ProxyFix

db = SQLAlchemy()

def create_app():
    """Construct the core application."""
    app = Flask(__name__)
    app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)
    app.config.from_object(Config)
    
    db.init_app(app)

    with app.app_context():
        from . import routes
        
        # Register Blueprints
        from flask_restx import Api
        api = Api(app, title='Users API', version='1.0', description='API for user management', doc='/doc')
        api.add_namespace(routes.users_bp)

        # Create database tables for our models
        db.create_all()

        return app
