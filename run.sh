#!/usr/bin/with-contenv bashio

set -e
set -x  # per log dettagliato

# Legge configurazione da config.yaml
DOMAIN=$(bashio::config 'domain')
HTTP_PORT=$(bashio::config 'http_port')
SSH_PORT=$(bashio::config 'ssh_port')

echo "Starting Forgejo with domain: $DOMAIN"
echo "HTTP Port: $HTTP_PORT"
echo "SSH Port: $SSH_PORT"

# Crea le directory necessarie
mkdir -p /data/custom/conf
mkdir -p /data/repositories
mkdir -p /data/log

# Genera app.ini se non esiste
if [ ! -f /data/custom/conf/app.ini ]; then
    cat > /data/custom/conf/app.ini << EOF
[DEFAULT]
APP_NAME = Forgejo
RUN_USER = git

[repository]
ROOT = /data/repositories

[server]
DOMAIN = $DOMAIN
HTTP_PORT = $HTTP_PORT
ROOT_URL = http://$DOMAIN:$HTTP_PORT/
DISABLE_SSH = false
SSH_PORT = $SSH_PORT

[database]
DB_TYPE = sqlite3
PATH = /data/forgejo.db

[security]
INSTALL_LOCK = false

[service]
DISABLE_REGISTRATION = false

[log]
MODE = file
LEVEL = Info
ROOT_PATH = /data/log
EOF
fi

# Imposta permessi corretti
chown -R git:git /data

# Avvia Forgejo come utente git (senza su-exec)
exec /usr/local/bin/forgejo web --config /data/custom/conf/app.ini
