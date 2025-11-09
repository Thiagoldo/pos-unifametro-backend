#!/bin/sh

# Wait for RabbitMQ to be ready
python /usr/src/app/wait_for_rabbitmq.py

# Now execute the main command (CMD from Dockerfile)
exec "$@"
