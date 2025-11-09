import pika
import time
import os

def check_rabbitmq():
    rabbitmq_url = os.getenv('RABBITMQ_URL')
    if not rabbitmq_url:
        print("RABBITMQ_URL não definida, pulando a espera.")
        return

    print("Aguardando pelo RabbitMQ...")
    while True:
        try:
            connection = pika.BlockingConnection(pika.URLParameters(rabbitmq_url))
            connection.close()
            print("RabbitMQ está pronto.")
            break
        except pika.exceptions.AMQPConnectionError:
            print("RabbitMQ não está pronto, tentando novamente em 5 segundos...")
            time.sleep(5)

if __name__ == "__main__":
    check_rabbitmq()
