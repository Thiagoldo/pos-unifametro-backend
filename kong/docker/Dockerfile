FROM kong:3.9.1

ENV KONG_DATABASE='off'
ENV KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yaml

COPY ../config/kong.yaml /etc/kong/kong.yaml

EXPOSE 8000
EXPOSE 8443