#!/bin/sh
# Skriver /srv/config.json ur miljövariabler vid start. Sätts en gång i
# ~/busstabell/.env på VPS:en → funkar på alla enheter utan att mata in något.
set -e

esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

cat > /srv/config.json <<EOF
{
  "key": "$(esc "${TRAFIKLAB_KEY:-}")",
  "interval": "$(esc "${TRAFIKLAB_INTERVAL:-30}")",
  "to":   { "stop": "$(esc "${TRAFIKLAB_STOP:-740069150}")" },
  "from": { "stop": "$(esc "${TRAFIKLAB_STOP_FROM:-}")" }
}
EOF

exec "$@"
