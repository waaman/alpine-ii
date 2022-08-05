#!/usr/bin/with-contenv ash

echo "--- On rejoint le chan ${SERVER_CHAN}"
echo "/j ${SERVER_CHAN}" > /app/servers/${SERVER_IP}/in