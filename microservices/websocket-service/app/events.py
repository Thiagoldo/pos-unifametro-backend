from functools import wraps
from . import socketio
from flask_socketio import emit, join_room, leave_room
from flask import request, current_app
import json

def with_chat_id(f):
    @wraps(f)
    def decorated(data, *args, **kwargs):
        if isinstance(data, str):
            chat_id = data
        elif isinstance(data, dict):
            chat_id = data.get('chat_id')
        else:
            chat_id = None

        if chat_id:
            return f(chat_id, data, *args, **kwargs)
        else:
            current_app.logger.warning(f"Cliente {request.sid} tentou realizar uma ação sem um chat_id")
            return None
    return decorated

@socketio.on('connect')
def handle_connect():
    current_app.logger.info(f'Cliente conectado: {request.sid}')
    emit('status', {'msg': 'Conectado'})

@socketio.on('disconnect')
def handle_disconnect():
    current_app.logger.info(f'Cliente desconectado: {request.sid}')

@socketio.on('join_chat')
@with_chat_id
def handle_join_chat(chat_id, data):
    join_room(chat_id)
    current_app.logger.info(f'Cliente {request.sid} entrou no chat {chat_id}')
    emit('status', {'msg': f'Entrou no chat {chat_id}'}, room=chat_id)

@socketio.on('leave_chat')
@with_chat_id
def handle_leave_chat(chat_id, data):
    leave_room(chat_id)
    current_app.logger.info(f'Cliente {request.sid} saiu do chat {chat_id}')
    emit('status', {'msg': f'Saiu do chat {chat_id}'}, room=chat_id)

@socketio.on('send_message')
@with_chat_id
def handle_send_message(chat_id, data):
    current_app.logger.info(f"Transmitindo para a sala {chat_id}: {data}")
    emit('new_message', data, room=chat_id)

@socketio.on('typing_start')
@with_chat_id
def handle_typing_start(chat_id, data):
    emit('typing_start', data, room=chat_id, include_self=False)

@socketio.on('typing_stop')
@with_chat_id
def handle_typing_stop(chat_id, data):
    emit('typing_stop', data, room=chat_id, include_self=False)
