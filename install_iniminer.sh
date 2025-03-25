#!/bin/bash

# Warna
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
RESET='\e[0m'

# Tampilan ASCII Art
clear
echo -e "${CYAN}##################################################${RESET}"
echo -e "${CYAN}#                                                #${RESET}"
echo -e "${CYAN}#   ██████   █████   ██      ████████  ██████   #${RESET}"
echo -e "${CYAN}#   ██   ██ ██   ██  ██         ██    ██    ██  #${RESET}"
echo -e "${CYAN}#   ██████  ███████  ██         ██    ██    ██  #${RESET}"
echo -e "${CYAN}#   ██   ██ ██   ██  ██         ██    ██    ██  #${RESET}"
echo -e "${CYAN}#   ██   ██ ██   ██  ███████    ██     ██████   #${RESET}"
echo -e "${CYAN}#                                                #${RESET}"
echo -e "${CYAN}#           🚀 BALSTOT AIRDROP 🚀              #${RESET}"
echo -e "${CYAN}##################################################${RESET}"
echo ""

# Update dan install dependensi
echo -e "${YELLOW}Memperbarui sistem dan menginstal dependensi...${RESET}"
sudo apt update && sudo apt upgrade -y
sleep 2
sudo apt install wget nano systemd -y
sleep 2

# Minta input alamat wallet
echo -e "${GREEN}Masukkan alamat wallet Anda (Format 0x12345):${RESET}"
read -p "👉 " WALLET_ADDRESS
sleep 2

# Pilih pool
echo -e "${MAGENTA}Pilih pool:${RESET}"
echo -e "${BLUE}1. pool-a.yatespool.com:31588${RESET}"
echo -e "${BLUE}2. pool-b.yatespool.com:32488${RESET}"
echo -e "${BLUE}3. pool-c.yatespool.com:31189${RESET}"
read -p "Masukkan pilihan (1/2/3): " POOL_CHOICE
sleep 2

# Tentukan pool berdasarkan pilihan
if [ "$POOL_CHOICE" == "1" ]; then
    POOL="pool-a.yatespool.com:31588"
    POOL_URL="https://a.yatespool.com/"
elif [ "$POOL_CHOICE" == "2" ]; then
    POOL="pool-b.yatespool.com:32488"
    POOL_URL="https://b.yatespool.com/"
elif [ "$POOL_CHOICE" == "3" ]; then
    POOL="pool-c.yatespool.com:31189"
    POOL_URL="https://c.yatespool.com/"
else
    echo -e "${RED}Pilihan tidak valid, menggunakan default pool-a.yatespool.com:31588${RESET}"
    POOL="pool-a.yatespool.com:31588"
    POOL_URL="https://a.yatespool.com/"
fi
sleep 2

# Minta input jumlah CPU core dengan minimal 2
while true; do
    echo -e "${GREEN}Masukkan jumlah CPU core (minimal 2):${RESET}"
    read -p "👉 " CPU_CORES
    if [[ "$CPU_CORES" =~ ^[0-9]+$ ]] && [ "$CPU_CORES" -ge 2 ]; then
        break
    else
        echo -e "${RED}Input tidak valid atau kurang dari 2. Silakan coba lagi.${RESET}"
    fi
done
sleep 2

# Generate daftar CPU devices
CPU_DEVICES=""
for ((i=1; i<=CPU_CORES; i++)); do
    CPU_DEVICES+="--cpu-devices $i "
done
CPU_DEVICES=$(echo $CPU_DEVICES | sed 's/ $//')
sleep 2

# Download IniMiner
echo -e "${YELLOW}Mengunduh IniMiner...${RESET}"
wget -O /root/iniminer-linux-x64 https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
sleep 2

# Buat file service systemd dengan sudo tee
echo -e "${YELLOW}Mengatur service miner...${RESET}"
cat <<EOF | sudo tee /etc/systemd/system/iniminer.service
[Unit]
Description=IniMiner Service (Root)
After=network.target

[Service]
ExecStart=/root/iniminer-linux-x64 --pool stratum+tcp://$WALLET_ADDRESS.Worker001@$POOL $CPU_DEVICES
WorkingDirectory=/root/
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sleep 2

# Berikan izin eksekusi
sudo chmod +x /root/iniminer-linux-x64
sleep 2

# Reload systemd dan aktifkan service
echo -e "${YELLOW}Menjalankan miner...${RESET}"
sudo systemctl daemon-reload
sleep 2
sudo systemctl enable iniminer.service
sleep 2
sudo systemctl start iniminer.service
sleep 2

# Tampilkan pesan bahwa instalasi selesai
echo -e "\n${GREEN}✅ Instalasi selesai!${RESET}"
echo -e "${CYAN}Gunakan perintah berikut untuk mengelola miner:${RESET}"
echo -e "${MAGENTA}1. Cek status miner: sudo systemctl status iniminer.service${RESET}"
echo -e "${MAGENTA}2. Restart miner: sudo systemctl restart iniminer.service${RESET}"
echo -e "${MAGENTA}3. Cek log miner: sudo journalctl -u iniminer.service --no-pager --lines=50${RESET}"
echo -e "${MAGENTA}4. Cek hasil mining Anda di: ${POOL_URL}#/account/$WALLET_ADDRESS${RESET}"
echo -e "\n${YELLOW}📢 Jangan lupa join ke channel Telegram: https://t.me/balstotairdrop${RESET}"
