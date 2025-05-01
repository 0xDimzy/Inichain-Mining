#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[97m'
RESET='\e[0m'

clear
echo -e "${CYAN}┌────────────────────────────────────────────────────┐${RESET}"
echo -e "${CYAN}│${RESET}        🚀 ${MAGENTA}INITVERSE MINER - MAINNET INSTALLER${RESET}        ${CYAN}│${RESET}"
echo -e "${CYAN}└────────────────────────────────────────────────────┘${RESET}"

if [[ "$(uname)" != "Linux" ]]; then
    echo -e "${RED}❌ This script only works on Linux systems!${RESET}"
    exit 1
fi

echo -e "${YELLOW}🌐 Checking internet connection...${RESET}"
if ! ping -c 1 google.com &> /dev/null; then
    echo -e "${RED}❌ No internet connection! Please check your connection and try again.${RESET}"
    exit 1
fi

echo -e "${YELLOW}📦 Updating system and installing dependencies...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt install wget nano systemd -y

while true; do
    echo -e "${GREEN}💳 Enter your EVM wallet address (Format 0x...):${RESET}"
    read -p "👉 " WALLET_ADDRESS

    if [ -z "$WALLET_ADDRESS" ]; then
        echo -e "${RED}⚠️  Wallet address cannot be empty!${RESET}"
        continue
    fi

    if [[ "$WALLET_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        echo -e "${GREEN}✅ Valid wallet address!${RESET}"
        break
    else
        echo -e "${RED}❌ Invalid address format!${RESET}"
        echo -e "${YELLOW}Example: 0xabc123... (40 hex chars)${RESET}"
    fi
done

echo -e "${GREEN}🧑‍💻 Enter your worker name (e.g. Worker001):${RESET}"
read -p "👉 " WORKER_NAME

while [ -z "$WORKER_NAME" ]; do
    echo -e "${RED}⚠️  Worker name cannot be empty!${RESET}"
    echo -e "${GREEN}Please enter again:${RESET}"
    read -p "👉 " WORKER_NAME
done

while true; do
    echo -e "${MAGENTA}🌐 Select a mining pool:${RESET}"
    echo -e "${BLUE} 1. pool-a.yatespool.com:31588${RESET}"
    echo -e "${BLUE} 2. pool-b.yatespool.com:32488${RESET}"
    echo -e "${BLUE} 3. pool-c.yatespool.com:31189${RESET}"
    read -p "👉 Your choice (1/2/3): " POOL_CHOICE

    case $POOL_CHOICE in
        1) POOL="pool-a.yatespool.com:31588"; POOL_URL="https://a.yatespool.com/"; break ;;
        2) POOL="pool-b.yatespool.com:32488"; POOL_URL="https://b.yatespool.com/"; break ;;
        3) POOL="pool-c.yatespool.com:31189"; POOL_URL="https://c.yatespool.com/"; break ;;
        *) echo -e "${RED}❌ Invalid choice! Please select 1, 2, or 3.${RESET}" ;;
    esac
done

while true; do
    echo -e "${GREEN}🧠 Enter number of CPU cores to use (Min 2):${RESET}"
    read -p "👉 " CPU_CORES
    TOTAL_CORES=$(nproc)

    if [[ ! "$CPU_CORES" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ Please enter a valid number.${RESET}"
    elif [ "$CPU_CORES" -lt 2 ]; then
        echo -e "${RED}⚠️  Minimum 2 cores required.${RESET}"
    elif [ "$CPU_CORES" -gt "$TOTAL_CORES" ]; then
        echo -e "${RED}⚠️  You only have $TOTAL_CORES cores available.${RESET}"
    else
        echo -e "${GREEN}✅ Using $CPU_CORES CPU cores${RESET}"
        break
    fi
done

CPU_DEVICES=""
for ((i=1; i<=CPU_CORES; i++)); do
    CPU_DEVICES+="--cpu-devices $i "
done

echo -e "${YELLOW}⬇️  Downloading IniMiner binary...${RESET}"
wget -O /root/iniminer-linux-x64 https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64

echo -e "${YELLOW}⚙️  Configuring systemd service...${RESET}"
cat <<EOF | sudo tee /etc/systemd/system/iniminer.service > /dev/null
[Unit]
Description=IniMiner Service (Root)
After=network.target

[Service]
ExecStart=/root/iniminer-linux-x64 --pool stratum+tcp://$WALLET_ADDRESS.$WORKER_NAME@$POOL $CPU_DEVICES
WorkingDirectory=/root/
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# ========== Start Miner ==========
sudo chmod +x /root/iniminer-linux-x64
sudo systemctl daemon-reload
sudo systemctl enable iniminer.service
sudo systemctl start iniminer.service

# ========== Success Screen ==========
echo -e "\n${CYAN}┌────────────────────────────────────────────┐${RESET}"
echo -e "${CYAN}│${RESET}         ✅ ${GREEN}INSTALLATION COMPLETE!${RESET}          ${CYAN}│${RESET}"
echo -e "${CYAN}└────────────────────────────────────────────┘${RESET}"

echo -e "${GREEN}🚀 Miner is now running in background${RESET}"
echo -e "${WHITE}🔍 Check your miner status:${RESET} ${MAGENTA}sudo systemctl status iniminer.service${RESET}"
echo -e "${WHITE}🔁 Restart miner:${RESET} ${MAGENTA}sudo systemctl restart iniminer.service${RESET}"
echo -e "${WHITE}📜 View logs:${RESET} ${MAGENTA}sudo journalctl -fu iniminer -o cat${RESET}"
echo -e "${WHITE}📈 Monitor mining progress:${RESET} ${BLUE}${POOL_URL}mining/$WALLET_ADDRESS/data${RESET}"
echo -e "${YELLOW}📢 Join the community: https://t.me/balstotairdrop${RESET}\n"
