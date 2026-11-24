#!/bin/sh
# Generates /etc/xray/config.json from env vars, then runs xray.
# XRAY_UUID is required (set as a Secret variable in Excalibase Studio).
# PORT defaults to 8080 (matches the container Port in Studio).
set -e
UUID="${XRAY_UUID:?XRAY_UUID env var is required}"
PORT="${PORT:-8080}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "port": ${PORT},
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "${UUID}", "flow": ""}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {"path": "/vless"}
    }
  }],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF
exec /usr/local/bin/xray run -c /etc/xray/config.json
