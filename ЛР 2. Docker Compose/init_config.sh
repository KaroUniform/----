#!/bin/sh

mkdir -p /jupyterhub/config

cat > /jupyterhub/config/jupyterhub_config.py <<EOL
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = ${JUPYTERHUB_PORT}
c.JupyterHub.hub_connect_ip = '127.0.0.1'
c.JupyterHub.db_url = 'postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}'
EOL
