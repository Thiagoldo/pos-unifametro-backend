import eventlet
eventlet.monkey_patch()

from flask import Flask
from flask_socketio import SocketIO
import os
from .config import Config
from .queue_consumer import start_consumer
import threading
import logging
import sys

# Configura o logging
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Instancia sem parâmetros dependentes de configuração
socketio = SocketIO(cors_allowed_origins="*", async_mode='eventlet')

def create_app():
    """Cria e configura a aplicação Flask."""
    app = Flask(__name__)
    app.config.from_object(Config)
    app.logger = logger

    # Inicializa com a configuração do app agora que está carregada
    socketio.init_app(app, message_queue=app.config['RABBITMQ_URL'])

    from . import events

    # Inicia o consumidor do RabbitMQ em uma thread de fundo
    consumer_thread = threading.Thread(target=start_consumer, args=(socketio, app.config['RABBITMQ_URL']))
    consumer_thread.daemon = True
    consumer_thread.start()

    return app, socketio
