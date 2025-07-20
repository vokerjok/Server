
#!/bin/bash
# ======================================================
# Skrip untuk Instalasi SOCKS5 Proxy Server (Dante)
# Untuk Ubuntu/Debian
# ======================================================

# 1. Update dan Install Dante
sudo apt update && sudo apt install -y dante-server

# 2. Konfigurasi Dante
sudo bash -c 'cat > /etc/danted.conf << EOF
logoutput: /var/log/dante.log
internal: 0.0.0.0 port = 1080
external: eth0
method: none

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect
}
EOF'

# 3. Restart Dante
sudo systemctl restart danted
sudo systemctl enable danted

# 4. Buka Port di Firewall (Jika Diperlukan)
sudo ufw allow 1080/tcp
sudo ufw enable

# 5. Verifikasi Instalasi
echo "===================== INSTALASI SELESAI ====================="
echo "SOCKS5 Proxy berjalan di port 1080"
echo "Anda dapat menguji dengan: curl --socks5 localhost:1080 ifconfig.me"
echo "============================================================"
