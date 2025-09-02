#!/bin/bash
# Script para configurar Git Party (Copyparty + Git)
# Estructura alineada a /srv/git-party

# --- Variables ---
BASE="/srv/git-party"
CONFIG="$BASE/config"
REPOS="$BASE/repos"
SHARED="$BASE/shared"
LOGS="$BASE/logs"
CONF="$CONFIG/the.conf"
COPYPARTY="$CONFIG/copyparty-sfx.py"
USER="juan"
PASS="1234"
PORT=3923

# --- Crear estructura de carpetas ---
mkdir -p "$CONFIG" "$REPOS" "$SHARED" "$LOGS"

# --- Inicializar Git en el proyecto principal (configuración) ---
if [ ! -d "$BASE/.git" ]; then
  cd "$BASE"
  git init
  echo "# Git Party" > README.md
  echo "Repositorio principal con configuración y scripts" >> README.md
  git add .
  git commit -m "Primer commit: estructura inicial"
fi

# --- Crear archivo de configuración the.conf ---
cat > "$CONF" <<EOL
[global]
  p: $PORT
  e2dsa
  e2ts
  z, qr
  dedup
  df: 1
  no-robots
  theme: 2
  lang: spa

[accounts]
  $USER: $PASS

[/shared]
  $SHARED
  accs:
    rwmda: $USER

[/repos]
  $REPOS
  accs:
    rwmda: $USER
EOL

# --- Arrancar Copyparty en segundo plano con log ---
cd "$CONFIG"
python3 "$COPYPARTY" -c "$CONF" > "$LOGS/copyparty.log" 2>&1 &

echo "Copyparty corriendo!"
echo "Logs en $LOGS/copyparty.log"
echo "Usuario: $USER | Contraseña: $PASS"
echo "Repositorios: $REPOS"
echo "Archivos compartidos: $SHARED"
