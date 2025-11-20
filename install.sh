#!/bin/bash
# =====================================
# FULL INSTALLER YHDS VPN (UDP + Xray + Nginx + Trojan + Menu Full Color + Payload)
# =====================================

# -----------------------------
# Update dan install tools
# -----------------------------
apt update -y
apt upgrade -y
apt install lolcat figlet neofetch screenfetch unzip curl wget ruby -y
gem install lolcat >/dev/null 2>&1 || true

# -----------------------------
# Disable IPv6 supaya UDP lebih stabil
# -----------------------------
echo "Menonaktifkan IPv6..."
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# -----------------------------
# Hapus folder lama dan buat folder baru
# -----------------------------
rm -rf /root/udp
mkdir -p /root/udp

# -----------------------------
# Banner Installer YHDS VPN
# -----------------------------
clear
figlet -f slant "YHDS VPN" | lolcat
echo -e "\e[36m   === Selamat datang di YHDS VPN Installer ===\e[0m"
sleep 3

# -----------------------------
# Set timezone Sri Lanka GMT+5:30
# -----------------------------
ln -fs /usr/share/zoneinfo/Asia/Colombo /etc/localtime
echo "Timezone diubah ke GMT+5:30 (Sri Lanka)"

# -----------------------------
# Install Xray
# -----------------------------
echo "Install Xray..."
bash -c "$(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)" >/dev/null 2>&1

# -----------------------------
# Install Nginx
# -----------------------------
echo "Install Nginx..."
apt install nginx -y
systemctl enable nginx
systemctl start nginx

# -----------------------------
# Install Trojan
# -----------------------------
echo "Install Trojan..."
bash -c "$(curl -sL https://raw.githubusercontent.com/p4gefau1t/trojan-install/master/trojan.sh)" >/dev/null 2>&1

# -----------------------------
# Download UDP Custom dari GitHub
# -----------------------------
GITHUB_RAW="https://raw.githubusercontent.com/Yahdiad1/Udp-custom/main"
wget "$GITHUB_RAW/udp-custom-linux-amd64" -O /root/udp/udp-custom
chmod +x /root/udp/udp-custom
wget "$GITHUB_RAW/config.json" -O /root/udp/config.json
chmod 644 /root/udp/config.json

# -----------------------------
# Buat systemd service UDP Custom
# -----------------------------
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=YHDS VPN UDP Custom

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF

# -----------------------------
# Download skrip tambahan menu
# -----------------------------
mkdir -p /etc/YHDS
cd /etc/YHDS
wget "$GITHUB_RAW/system.zip"
unzip system.zip
cd system
mv menu /usr/local/bin
chmod +x menu creatuser.sh Adduser.sh DelUser.sh Userlist.sh ToggleUser.sh DashboardStatus.sh InstallBot.sh RemoveScript.sh torrent.sh CreateTrial.sh CreateTrojan.sh
cd /etc/YHDS
rm system.zip

# -----------------------------
# Jalankan menu otomatis saat login
# -----------------------------
if ! grep -q "/usr/local/bin/menu" /root/.bashrc; then
    echo "/usr/local/bin/menu" >> /root/.bashrc
fi

# -----------------------------
# Start dan enable service UDP Custom
# -----------------------------
systemctl daemon-reload
systemctl start udp-custom
systemctl enable udp-custom

clear
figlet -f slant "YHDS VPN" | lolcat
echo "=========================================="
echo "YHDS VPN berhasil diinstall!"
echo "UDP, Xray, Nginx, Trojan siap digunakan"
echo "IPv6 dinonaktifkan, UDP lebih stabil"
echo "Menu utama full color siap pakai"
echo "Payload SSH/WS/Trojan/UDP otomatis muncul setelah create user"
echo "Menu akan otomatis muncul setelah close atau login kembali"
echo "Github: https://github.com/Yahdiad1/Udp-custom"
echo "=========================================="
