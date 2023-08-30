#!/bin/bash

# ===========================
# Author: Andrew J. McDonald
# Date: 2023-03-15
# ==========================================================================
# Description: 
#    Copies SSL certs from letsencrypt Folder to RabbitMQ folder.
#    Then Restarts RabbitMQ.
# =========================================================================

SCRIPT_NAME="rabbitmq-cert-copy"

# Set source file/folder paths
ORIG_FOLDER="/etc/letsencrypt/live/rabbitmq-telehealth.freeddns.org"

ORIG_FULLCHAIN="$ORIG_FOLDER/fullchain.pem"
ORIG_CERT="$ORIG_FOLDER/cert.pem"
ORIG_PRIVKEY="$ORIG_FOLDER/privkey.pem"
ORIG_CHAIN="$ORIG_FOLDER/chain.pem"

# Set destination file/folder paths
DEST_FOLDER="/home/rabbitmq-certs"

NEW_FULLCHAIN="$DEST_FOLDER/fullchain.pem"
NEW_CERT="$DEST_FOLDER/cert.pem"
NEW_PRIVKEY="$DEST_FOLDER/privkey.pem"
NEW_CHAIN="$DEST_FOLDER/chain.pem"

# Copy new certificates to rabbitmq folder
echo $(date +"%y-%m-%d %T")" ["$SCRIPT_NAME"]: Copying updated SSL certificates..."
cp -fv "$ORIG_FULLCHAIN" "$NEW_FULLCHAIN"
cp -fv "$ORIG_CERT" "$NEW_CERT"
cp -fv "$ORIG_PRIVKEY" "$NEW_PRIVKEY"
cp -fv "$ORIG_CHAIN" "$NEW_CHAIN"

# Set permissions and ownership for the copied files
echo $(date +"%y-%m-%d %T")" ["$SCRIPT_NAME"]: Updating ownership and permissions of SSL certificates..."
chmod 644 "$NEW_FULLCHAIN" "$NEW_CERT" "$NEW_CHAIN"
chmod 600 "$NEW_PRIVKEY"
chown rabbitmq:rabbitmq "$NEW_FULLCHAIN" "$NEW_CERT" "$NEW_CHAIN" "$NEW_PRIVKEY"

# Restart RabbitMQ to ensure the new certificates are used
echo $(date +"%y-%m-%d %T")" ["$SCRIPT_NAME"]: Restarting Rabbitmq to ensure updated SSL certifcates are utilised..."
for i in {1..5}; do
  if systemctl restart rabbitmq-server; then
    echo $(date +"%y-%m-%d %T")" ["$SCRIPT_NAME"]: RabbitMQ has been successfully restarted!"
    exit 0
  else
    echo $(date +"%y-%m-%d %T")" ["$SCRIPT_NAME"]: RabbitMQ failed to restart. Retrying in 5 seconds..."
    sleep 5
  fi
done

# Check if RabbitMQ has been restarted
if ! systemctl is-active --quiet rabbitmq-server; then
  echo $(date +"%y-%m-%d %T")" ["$SCRIPT_NAME"]: Error: RabbitMQ failed to start after 5 attempts."
  exit 1
fi
