from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from .config import Config
from werkzeug.middleware.proxy_fix import ProxyFix

db = SQLAlchemy()

def create_app():
    """Cria e configura a aplicação Flask."""
    app = Flask(__name__)
    app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)
    app.config.from_object(Config)
    
    db.init_app(app)

    with app.app_context():
        from . import routes
        
        # Registra os Blueprints
        from flask_restx import Api
        api = Api(app, title='Users API', version='1.0', description='API para gerenciamento de usuários', doc='/doc')
        api.add_namespace(routes.users_bp)

        # Cria as tabelas do banco de dados para nossos modelos
        db.create_all()

        return app
