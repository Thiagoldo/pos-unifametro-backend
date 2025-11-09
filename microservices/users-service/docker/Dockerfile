# Use an official Python runtime as a parent image
FROM python:3.9-slim

WORKDIR /usr/src/app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

EXPOSE 3001

CMD ["gunicorn", "-b", "0.0.0.0:3001", "run:app"]
