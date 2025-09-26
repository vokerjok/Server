#!/bin/bash
set -e

WORKDIR="$(cd "$(dirname "$0")" && pwd)"
ROOTFS_DIR="$WORKDIR/rootfs"

# ===== Extract rootfs jika belum ada =====
if [ ! -d "$ROOTFS_DIR" ]; then
    echo "[*] Extract rootfs..."
    mkdir -p "$ROOTFS_DIR"
    tar -xzf "$WORKDIR/alpine-minirootfs.tar.gz" -C "$ROOTFS_DIR"
fi

# ===== Buat script startup di dalam Alpine =====
STARTUP_SH="$ROOTFS_DIR/startup.sh"
if [ ! -f "$STARTUP_SH" ]; then
cat <<'EOF' > "$STARTUP_SH"
#!/bin/sh
set -e

echo "[*] Update Alpine packages..."
apk update
apk add --no-cache bash sudo python3 py3-pip curl wget unzip

echo "[*] Upgrade pip..."
pip3 install --upgrade pip

echo "[*] Install Playwright..."
pip3 install playwright

echo "[*] Install Chromium + dependencies..."
python3 -m playwright install chromium
sudo python3 -m playwright install-deps

echo "[*] Tambahkan user non-root..."
adduser -D user
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "[*] Alpine siap digunakan! Masuk dengan 'su user'"
/bin/sh
EOF
    chmod +x "$STARTUP_SH"
fi

# ===== Cek QEMU =====
if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
    echo "[!] QEMU tidak ditemukan, install dulu: sudo apt install qemu-system-x86"
    exit 1
fi

# ===== Jalankan Alpine di QEMU =====
echo "[*] Menjalankan Alpine Linux di QEMU..."
qemu-system-x86_64 \
    -m 2048 \
    -kernel /usr/lib/linux-virt/vmlinuz-virt || true \
    -initrd "$STARTUP_SH" \
    -append "console=ttyS0 root=/dev/ram0 rw" \
    -nographic
