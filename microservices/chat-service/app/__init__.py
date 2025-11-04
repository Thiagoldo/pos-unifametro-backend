from flask import Flask
from flask_pymongo import PyMongo
from flask_cors import CORS
from .config import Config
from werkzeug.middleware.proxy_fix import ProxyFix

mongo = PyMongo()

def create_app():
    """Cria e configura a aplicação Flask."""
    app = Flask(__name__)
    app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)
    app.config.from_object(Config)
    
    # Configurar CORS
    CORS(app, resources={
        r"/*": {
            "origins": ["*"],
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    
    mongo.init_app(app)

    with app.app_context():
        from . import routes
        
        # Registra os Blueprints
        from flask_restx import Api
        api = Api(app, title='Chat API', version='1.0', description='API para gerenciamento de chats', doc='/doc')
        api.add_namespace(routes.chat_bp)

        return app
