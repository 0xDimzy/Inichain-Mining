#!/bin/bash

clear
echo "##################################################"
echo "#                                                #"
echo "#   ██████   █████   ██      ████████  ██████   #"
echo "#   ██   ██ ██   ██  ██         ██    ██    ██  #"
echo "#   ██████  ███████  ██         ██    ██    ██  #"
echo "#   ██   ██ ██   ██  ██         ██    ██    ██  #"
echo "#   ██   ██ ██   ██  ███████    ██     ██████   #"
echo "#                                                #"
echo "#           🚀 BALSTOT AIRDROP 🚀              #"
echo "##################################################"
echo ""

# Update dan install dependensi
echo "Memperbarui sistem dan menginstal dependensi..."
sudo apt update && sudo apt upgrade -y
sudo apt install wget nano systemd -y

# Minta input alamat wallet
read -p "Masukkan alamat wallet Anda ( Format 0x12345 ): " WALLET_ADDRESS

# Pilih pool
echo "Pilih pool:"
echo "1. pool-a.yatespool.com:31588"
echo "2. pool-b.yatespool.com:32488"
echo "3. pool-c.yatespool.com:31189"
read -p "Masukkan pilihan (1/2/3): " POOL_CHOICE

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
    echo "Pilihan tidak valid, menggunakan default pool-a.yatespool.com:31588"
    POOL="pool-a.yatespool.com:31588"
    POOL_URL="https://a.yatespool.com/"
fi

# Minta input jumlah CPU core dengan minimal 2
while true; do
    read -p "Masukkan jumlah CPU core (minimal 2): " CPU_CORES
    if [[ "$CPU_CORES" =~ ^[0-9]+$ ]] && [ "$CPU_CORES" -ge 2 ]; then
        break
    else
        echo "Input tidak valid atau kurang dari 2. Silakan coba lagi."
    fi
done

# Generate daftar CPU devices
CPU_DEVICES=""
for ((i=1; i<=CPU_CORES; i++)); do
    CPU_DEVICES+="--cpu-devices $i "
done
CPU_DEVICES=$(echo $CPU_DEVICES | sed 's/ $//')

# Download IniMiner
wget -O /root/iniminer-linux-x64 https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64

# Buat file service systemd
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

# Berikan izin eksekusi
sudo chmod +x /root/iniminer-linux-x64

# Reload systemd dan aktifkan service
sudo systemctl daemon-reload
sudo systemctl enable iniminer.service
sudo systemctl start iniminer.service

# Tampilkan pesan bahwa instalasi selesai
echo "\n✅ Instalasi selesai!"
echo "Gunakan perintah berikut untuk mengelola miner:"
echo "1. Cek status miner: sudo systemctl status iniminer.service"
echo "2. Restart miner: sudo systemctl restart iniminer.service"
echo "3. Cek log miner: sudo journalctl -u iniminer.service --no-pager --lines=50"
echo "4. Cek hasil mining Anda di: ${POOL_URL}#/account/$WALLET_ADDRESS"
echo "\n📢 Jangan lupa join ke channel Telegram: https://t.me/balstotairdrop"
