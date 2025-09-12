#!/usr/bin/with-contenv bashio

set -e
set -x  # log dettagliato per debug

# Legge configurazione
DOMAIN=$(bashio::config 'domain')
HTTP_PORT=$(bashio::config 'http_port')
SSH_PORT=$(bashio::config 'ssh_port')

echo "Starting Forgejo with domain: $DOMAIN, HTTP: $HTTP_PORT, SSH: $SSH_PORT"

# Crea directory se non esistono
mkdir -p /data/custom/conf /data/repositories /data/log

# Genera app.ini se non esiste
if [ ! -f /data/custom/conf/app.ini ]; then
    echo "Generating /data/custom/conf/app.ini"
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

# Avvio Forgejo (l’immagine ufficiale gestisce già utente e permessi)
echo "Launching Forgejo..."
/usr/local/bin/forgejo web --config /data/custom/conf/app.ini
