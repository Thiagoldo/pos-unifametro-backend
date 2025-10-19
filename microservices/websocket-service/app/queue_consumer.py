import pika
import json
import time

def start_consumer(socketio, rabbitmq_url):
    """Connects to RabbitMQ and starts consuming messages."""
    
    # It's better to handle connection recovery more robustly in production
    while True:
        try:
            connection = pika.BlockingConnection(pika.URLParameters(rabbitmq_url))
            channel = connection.channel()
            print("RabbitMQ consumer connected.")

            # Declare queues
            channel.queue_declare(queue='chat_messages', durable=True)
            channel.queue_declare(queue='user_presence', durable=True)
            channel.queue_declare(queue='notifications', durable=True)

            def callback(ch, method, properties, body):
                print(f" [x] Received from {method.routing_key}: {body}")
                try:
                    message = json.loads(body)
                    # Broadcast message to the appropriate room/client
                    socketio.emit(method.routing_key, message, room=message.get('room'))
                except json.JSONDecodeError:
                    print("Could not decode message from queue.")
                ch.basic_ack(delivery_tag=method.delivery_tag)

            channel.basic_qos(prefetch_count=1)
            channel.basic_consume(queue='chat_messages', on_message_callback=callback)
            channel.basic_consume(queue='user_presence', on_message_callback=callback)
            channel.basic_consume(queue='notifications', on_message_callback=callback)

            print(' [*] Waiting for messages. To exit press CTRL+C')
            channel.start_consuming()

        except pika.exceptions.AMQPConnectionError as e:
            print(f"Could not connect to RabbitMQ: {e}. Retrying in 5 seconds...")
            time.sleep(5)
        except Exception as e:
            print(f"An unexpected error occurred: {e}. Restarting consumer...")
            time.sleep(5)
