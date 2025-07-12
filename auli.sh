#!/bin/bash

WALLET="88zn5uk9A4DJ8ndSxZvQr8Xq8wZNAPaCoHTraTswpFzU8Phmg6QLotzBQHN5TP9q1s6X2DDq92PNy4sGNStYiBLHNzjeMBE"
WORKER_NAME="gshe"
POOL="157.230.254.83:69"
XMRIG_VERSION="6.21.1"
XMRIG_DIR="$HOME/xmrig-$XMRIG_VERSION"
XMRIG_TAR="xmrig-$XMRIG_VERSION-linux-x64.tar.gz"
XMRIG_URL="https://github.com/xmrig/xmrig/releases/download/v$XMRIG_VERSION/$XMRIG_TAR"
LOG_FILE="$HOME/xmrig.log"

cd ~
if [ ! -d "$XMRIG_DIR" ]; then
    echo " Mengunduh XMRig versi $XMRIG_VERSION..."
    curl -LO "$XMRIG_URL"
    tar -xf "$XMRIG_TAR"
    rm -f "$XMRIG_TAR"
    echo " XMRig berhasil diunduh dan diekstrak ke $XMRIG_DIR"
else
    echo " XMRig sudah tersedia di $XMRIG_DIR"
fi

cd "$XMRIG_DIR"
echo " Menjalankan XMRig di background dengan nohup..."
nohup ./xmrig -o $POOL -u $WALLET -p $WORKER_NAME -a rx/0 --tls --threads= 4 > "$LOG_FILE" 2>&1 &


echo " XMRig berjalan di background"
echo " Log bisa dilihat di: $LOG_FILE"
