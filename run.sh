#!/usr/bin/with-contenv bashio

# Get configuration
DOMAIN=$(bashio::config 'domain')
HTTP_PORT=$(bashio::config 'http_port')
SSH_PORT=$(bashio::config 'ssh_port')

echo "Starting Forgejo with domain: $DOMAIN"
echo "HTTP Port: $HTTP_PORT"
echo "SSH Port: $SSH_PORT"

# Create directories
mkdir -p /data/custom/conf

# Generate basic configuration if not exists
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

# Set permissions
chown -R git:git /data

# Start Forgejo
cd /data
exec su-exec git /usr/local/bin/forgejo web --config /data/custom/conf/app.ini
