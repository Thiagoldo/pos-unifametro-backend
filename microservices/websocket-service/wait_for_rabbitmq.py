import pika
import time
import os

def check_rabbitmq():
    rabbitmq_url = os.getenv('RABBITMQ_URL')
    if not rabbitmq_url:
        print("RABBITMQ_URL not set, skipping wait.")
        return

    print("Waiting for RabbitMQ...")
    while True:
        try:
            connection = pika.BlockingConnection(pika.URLParameters(rabbitmq_url))
            connection.close()
            print("RabbitMQ is ready.")
            break
        except pika.exceptions.AMQPConnectionError:
            print("RabbitMQ not ready, retrying in 5 seconds...")
            time.sleep(5)

if __name__ == "__main__":
    check_rabbitmq()
