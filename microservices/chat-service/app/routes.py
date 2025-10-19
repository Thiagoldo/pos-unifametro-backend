from flask import Blueprint, request, jsonify
from . import mongo
from bson.objectid import ObjectId

chat_bp = Blueprint('chat_bp', __name__, url_prefix='/chats')

@chat_bp.route('/', methods=['GET'])
def get_chats():
    # Logic to get all chats for the current user
    # Example: chats = mongo.db.chats.find({"participants": current_user_id})
    return jsonify({"message": "List all chats"}), 200

@chat_bp.route('/', methods=['POST'])
def create_chat():
    # Logic to create a new chat room
    # Example: mongo.db.chats.insert_one({'name': 'New Chat', 'participants': []})
    return jsonify({"message": "Create a new chat"}), 201

@chat_bp.route('/<chat_id>/messages', methods=['GET'])
def get_messages(chat_id):
    # Logic to get messages for a specific chat
    # Example: messages = mongo.db.messages.find({'chat_id': chat_id})
    return jsonify({"message": f"Get messages for chat {chat_id}"}), 200

@chat_bp.route('/<chat_id>/messages', methods=['POST'])
def post_message(chat_id):
    # Logic to post a new message to a chat
    # This would also likely publish to RabbitMQ for the websocket-service
    # Example: mongo.db.messages.insert_one({'chat_id': chat_id, 'text': 'Hello'})
    return jsonify({"message": f"Post message to chat {chat_id}"}), 201

@chat_bp.route('/<chat_id>/participants', methods=['GET'])
def get_participants(chat_id):
    # Logic to get participants of a specific chat
    # Example: chat = mongo.db.chats.find_one({'_id': ObjectId(chat_id)})
    return jsonify({"message": f"Get participants for chat {chat_id}"}), 200
