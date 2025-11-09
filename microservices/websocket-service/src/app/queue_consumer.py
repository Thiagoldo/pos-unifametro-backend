import pika
import json
import time

def start_consumer(socketio, rabbitmq_url):
    """Conecta-se ao RabbitMQ e começa a consumir mensagens."""
    
    # É melhor lidar com a recuperação da conexão de forma mais robusta em produção
    while True:
        try:
            connection = pika.BlockingConnection(pika.URLParameters(rabbitmq_url))
            channel = connection.channel()
            print("Consumidor do RabbitMQ conectado.")

            # Declara as filas
            channel.queue_declare(queue='chat_messages', durable=True)
            channel.queue_declare(queue='user_presence', durable=True)
            channel.queue_declare(queue='notifications', durable=True)

            def callback(ch, method, properties, body):
                print(f" [x] Recebido de {method.routing_key}: {body}")
                try:
                    message = json.loads(body)
                    # Transmite a mensagem para a sala/cliente apropriado
                    socketio.emit(method.routing_key, message, room=message.get('room'))
                except json.JSONDecodeError:
                    print("Não foi possível decodificar a mensagem da fila.")
                ch.basic_ack(delivery_tag=method.delivery_tag)

            channel.basic_qos(prefetch_count=1)
            channel.basic_consume(queue='chat_messages', on_message_callback=callback)
            channel.basic_consume(queue='user_presence', on_message_callback=callback)
            channel.basic_consume(queue='notifications', on_message_callback=callback)

            print(' [*] Aguardando por mensagens. Para sair, pressione CTRL+C')
            channel.start_consuming()

        except pika.exceptions.AMQPConnectionError as e:
            print(f"Não foi possível conectar ao RabbitMQ: {e}. Tentando novamente em 5 segundos...")
            time.sleep(5)
        except Exception as e:
            print(f"Ocorreu um erro inesperado: {e}. Reiniciando o consumidor...")
            time.sleep(5)
