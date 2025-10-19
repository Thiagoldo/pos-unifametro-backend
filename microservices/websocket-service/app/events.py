from . import socketio
from flask_socketio import emit, join_room, leave_room
from flask import request

@socketio.on('connect')
def handle_connect():
    print(f'Client connected: {request.sid}')
    emit('status', {'msg': 'Connected'})

@socketio.on('disconnect')
def handle_disconnect():
    print(f'Client disconnected: {request.sid}')

@socketio.on('join_chat')
def handle_join_chat(data):
    chat_id = data.get('chat_id')
    join_room(chat_id)
    print(f'Client {request.sid} joined chat {chat_id}')
    emit('status', {'msg': f'Joined chat {chat_id}'}, room=chat_id)

@socketio.on('leave_chat')
def handle_leave_chat(data):
    chat_id = data.get('chat_id')
    leave_room(chat_id)
    print(f'Client {request.sid} left chat {chat_id}')
    emit('status', {'msg': f'Left chat {chat_id}'}, room=chat_id)

@socketio.on('send_message')
def handle_send_message(data):
    chat_id = data.get('chat_id')
    # In a real app, you'd likely send this to a message queue (e.g., RabbitMQ)
    # which would then be consumed and broadcasted back.
    # For simplicity here, we broadcast directly.
    emit('new_message', data, room=chat_id)

@socketio.on('typing_start')
def handle_typing_start(data):
    chat_id = data.get('chat_id')
    emit('typing_start', data, room=chat_id, include_self=False)

@socketio.on('typing_stop')
def handle_typing_stop(data):
    chat_id = data.get('chat_id')
    emit('typing_stop', data, room=chat_id, include_self=False)
