#!/bin/bash

WALLET="wallet"
WORKER="FOMO1"
POOL="pool"
XMRIG_VERSION="6.21.1"
XMRIG_DIR="$HOME/xmrig-$XMRIG_VERSION"
XMRIG_URL="https://github.com/xmrig/xmrig/releases/download/v$XMRIG_VERSION/xmrig-$XMRIG_VERSION-linux-x64.tar.gz"
XMRIG_TAR="xmrig-$XMRIG_VERSION-linux-x64.tar.gz"
LOG="$HOME/xmrig.log"

install_xmrig() {
  if [ ! -d "$XMRIG_DIR" ]; then
    echo "Mengunduh XMRig..."
    curl -LO "$XMRIG_URL"
    tar -xf "$XMRIG_TAR"
    rm "$XMRIG_TAR"
  fi
}

start_mining() {
  echo "⛏ Menjalankan XMRig..."
  nohup "$XMRIG_DIR/xmrig" -o $POOL -u $WALLET -p $WORKER -a rx/0 --tls --threads=4 > "$LOG" 2>&1 &
  MINER_PID=$!
}

stop_mining() {
  echo "🛑 Menghentikan XMRig (PID: $MINER_PID)..."
  kill "$MINER_PID" 2>/dev/null
}

start_ram_dummy() {
  echo "📦 Mengisi RAM ~2GB langsung di memori..."
  perl -e '$x = "a" x (2 * 1024 * 1024 * 1024); sleep 300' &
  RAM_PID=$!
}

stop_ram_dummy() {
  echo "🧹 Menghapus dummy RAM dan kill proses (PID: $RAM_PID)..."
  kill "$RAM_PID" 2>/dev/null
}

main_loop() {
  install_xmrig

  while true; do
    echo "🔁 Memulai siklus baru (50 menit)..."
    START_TIME=$(date +%s)

    start_ram_dummy
    start_mining
    sleep $((RANDOM % 120 + 240)) # 4–6 menit

    stop_mining
    sleep $((RANDOM % 60 + 120))  # 2–3 menit

    start_mining
    sleep $((RANDOM % 60 + 120))  # 2–3 menit

    stop_mining
    sleep $((RANDOM % 60 + 300))  # 5–6 menit

    stop_ram_dummy

    ELAPSED=$(( $(date +%s) - START_TIME ))
    REMAINING=$((3000 - ELAPSED)) # 50 menit = 3000 detik
    if [ "$REMAINING" -gt 0 ]; then
      echo "⏳ Menunggu $REMAINING detik sebelum siklus selanjutnya..."
      sleep "$REMAINING"
    fi
  done
}

main_loop
