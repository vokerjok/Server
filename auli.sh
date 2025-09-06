#!/bin/bash

WALLET="Mr8oEPuPZ3XMZY63bLzrZGJXgZ7wBpV3Ck"
WORKER_NAME="do1"
POOL="47.84.66.172:118"
ALGO="power2b"
THREADS=8
CPUMINER_VERSION="5.0.41"
CPUMINER_FILE="cpuminer-opt-linux-${CPUMINER_VERSION}a.tar.gz"
CPUMINER_URL="https://github.com/rplant8/cpuminer-opt-rplant/releases/download/${CPUMINER_VERSION}/${CPUMINER_FILE}"
EXECUTABLE="sse2"

cd ~
if [ ! -f "$EXECUTABLE" ]; then
    echo "[🔻] Mengunduh cpuminer-opt..."
    curl -LO "$CPUMINER_URL"
    tar -xf "$CPUMINER_FILE"
    mv cpuminer-sse2 $EXECUTABLE
    chmod +x $EXECUTABLE
    rm -f "$CPUMINER_FILE"
    echo "[✅] cpuminer-opt siap dijalankan."
else
    echo "[ℹ] cpuminer-opt sudah tersedia."
fi

echo "[🚀] Menjalankan cpuminer-opt..."
./$EXECUTABLE -a $ALGO -o stratum+tcp://$POOL -u $WALLET.$WORKER_NAME -p x -t $THREADS
