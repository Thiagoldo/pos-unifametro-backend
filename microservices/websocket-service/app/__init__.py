import eventlet
eventlet.monkey_patch()

from flask import Flask
from flask_socketio import SocketIO
import os
from .config import Config
from .queue_consumer import start_consumer
import threading

# Instantiate without config-dependent parameters
socketio = SocketIO(cors_allowed_origins="*", async_mode='eventlet')

def create_app():
    """Construct the core application."""
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize with app config now that it's loaded
    socketio.init_app(app, message_queue=app.config['RABBITMQ_URL'])

    from . import events

    # Start RabbitMQ consumer in a background thread
    consumer_thread = threading.Thread(target=start_consumer, args=(socketio, app.config['RABBITMQ_URL']))
    consumer_thread.daemon = True
    consumer_thread.start()

    return app, socketio
