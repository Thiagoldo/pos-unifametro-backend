# Use an official Python runtime as a parent image
FROM python:3.9-slim

WORKDIR /usr/src/app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

EXPOSE 3002

# Command to run the application using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:3002", "run:app"]
