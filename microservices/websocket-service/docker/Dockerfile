FROM python:3.9-slim

WORKDIR /usr/src/app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .
COPY doc/asyncapi.yaml .

COPY docker/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

EXPOSE 3003

CMD ["gunicorn", "-k", "eventlet", "-w", "1", "-b", "0.0.0.0:3003", "run:app"]
