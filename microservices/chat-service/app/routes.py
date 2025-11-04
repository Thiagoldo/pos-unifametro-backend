from flask_restx import Namespace, Resource
from . import mongo
from bson.objectid import ObjectId

chat_bp = Namespace('chats', path='/', description='Operações relacionadas a chats')

@chat_bp.route('/')
class ChatList(Resource):
    def get(self):
        """Lista todos os chats."""
        # Lógica para buscar todos os chats do usuário atual
        # Exemplo: chats = mongo.db.chats.find({"participants": current_user_id})
        return {"message": "Lista todos os chats"}, 200

    def post(self):
        """Cria um novo chat."""
        # Lógica para criar uma nova sala de chat
        # Exemplo: mongo.db.chats.insert_one({'name': 'New Chat', 'participants': []})
        return {"message": "Cria um novo chat"}, 201

@chat_bp.route('/<string:chat_id>/messages')
class Messages(Resource):
    def get(self, chat_id):
        """Busca mensagens de um chat específico."""
        # Lógica para buscar mensagens de um chat específico
        # Exemplo: messages = mongo.db.messages.find({'chat_id': chat_id})
        return {"message": f"Busca mensagens do chat {chat_id}"}, 200

    def post(self, chat_id):
        """Envia uma nova mensagem para um chat."""
        # Lógica para enviar uma nova mensagem para um chat
        # Isso também provavelmente publicaria no RabbitMQ para o websocket-service
        # Exemplo: mongo.db.messages.insert_one({'chat_id': chat_id, 'text': 'Hello'})
        return {"message": f"Envia mensagem para o chat {chat_id}"}, 201

@chat_bp.route('/<string:chat_id>/participants')
class Participants(Resource):
    def get(self, chat_id):
        """Busca participantes de um chat específico."""
        # Lógica para buscar participantes de um chat específico
        # Exemplo: chat = mongo.db.chats.find_one({'_id': ObjectId(chat_id)})
        return {"message": f"Busca participantes do chat {chat_id}"}, 200
