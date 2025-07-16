#!/bin/bash
# ======================================================
# INSTALASI SOCKS5 PROXY SERVER (DANTE) TEROPTIMASI
# Untuk Ubuntu 20.04/22.04 dan Debian 10/11/12
# ======================================================

# 1. Persiapan Sistem
sudo apt update && sudo apt upgrade -y
sudo apt install -y dante-server net-tools ufw

# 2. Konfigurasi Dante (Edit dengan nano/vim)
sudo bash -c 'cat > /etc/danted.conf << EOF
# Konfigurasi SOCKS5 Premium oleh Dante
logoutput: syslog
user.privileged: root
user.unprivileged: nobody

# Port utama SOCKS5
internal: 0.0.0.0 port = 1080
external: $(ip -o -4 addr show | awk '"'"'/scope global/ {split($4,a,"/"); print a[1]}'"'"')

# Metode otentikasi (pilih salah satu)
method: username none  # Tanpa autentikasi
# method: username pam # Dengan autentikasi sistem
# method: username # Username/password

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    log: connect disconnect error
}
EOF'

# 3. Konfigurasi Firewall (UFW)
sudo ufw allow 22/tcp
sudo ufw allow 1080/tcp
sudo ufw --force enable

# 4. Hidupkan Systemd dan Dante
sudo systemctl restart danted
sudo systemctl enable danted

# 5. Konfigurasi Kernel untuk Performa Optimal
sudo bash -c 'cat >> /etc/sysctl.conf << EOF
# Optimalisasi Kernel untuk SOCKS5
net.ipv4.ip_forward=1
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_tw_reuse=1
net.core.somaxconn=65535
net.ipv4.tcp_max_syn_backlog=8192
net.ipv4.tcp_max_tw_buckets=2000000
EOF'
sudo sysctl -p

# 6. Buat User Khusus untuk Autentikasi (Opsional)
sudo useradd -r -s /bin/false socksuser
echo "socksuser:passwordkuat" | sudo chpasswd

# 7. Verifikasi Instalasi
echo ""
echo "===================== INSTALASI SELESAI ====================="
echo "Alamat IP Server: $(curl -s ifconfig.me)"
echo "Port SOCKS5: 1080"
echo "Autentikasi: none"
echo "Test Koneksi: curl --socks5 IP_SERVER:1080 ifconfig.me"
echo "============================================================"
