#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
RESET='\e[0m'

clear
echo -e "${CYAN}=============================================${RESET}"
echo -e "${CYAN}          INITVERSE MINER MAINNET            ${RESET}"
echo -e "${CYAN}=============================================${RESET}"

# System checks
if [[ "$(uname)" != "Linux" ]]; then
    echo -e "${RED}This script only works on Linux systems!${RESET}"
    exit 1
fi

echo -e "${YELLOW}Checking internet connection...${RESET}"
if ! ping -c 1 google.com &> /dev/null; then
    echo -e "${RED}No internet connection! Please check your connection and try again.${RESET}"
    exit 1
fi

# System update and dependencies
echo -e "${YELLOW}Updating system and installing dependencies...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt install wget nano systemd -y

# Wallet validation
while true; do
    echo -e "${GREEN}Enter your wallet EVM address (Format 0x**):${RESET}"
    read -p "👉 " WALLET_ADDRESS
    
    # Check if input is empty
    if [ -z "$WALLET_ADDRESS" ]; then
        echo -e "${RED}Wallet address cannot be empty! Please try again.${RESET}"
        continue
    fi
    
    # Validate wallet format
    if [[ "$WALLET_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        echo -e "${GREEN}✓ Valid wallet address${RESET}"
        break
    else
        echo -e "${RED}Invalid wallet format! Address must:${RESET}"
        echo -e "${RED}- Start with '0x'${RESET}"
        echo -e "${RED}- Contain exactly 40 hexadecimal characters after '0x'${RESET}"
        echo -e "${RED}- Only use characters: 0-9 and a-f or A-F${RESET}"
    fi
done

echo -e "${GREEN}Enter your worker name (Example Worker001 ):${RESET}"
read -p "👉 " WORKER_NAME

while [ -z "$WORKER_NAME" ]; do
    echo -e "${RED}Worker name cannot be empty! Please try again.${RESET}"
    echo -e "${GREEN}Enter your worker name:${RESET}"
    read -p "👉 " WORKER_NAME
done

# Pool selection
while true; do
    echo -e "${MAGENTA}Select a mining pool:${RESET}"
    echo -e "${BLUE}1. pool-a.yatespool.com:31588${RESET}"
    echo -e "${BLUE}2. pool-b.yatespool.com:32488${RESET}"
    echo -e "${BLUE}3. pool-c.yatespool.com:31189${RESET}"
    read -p "Enter your choice (1/2/3): " POOL_CHOICE

    if [ "$POOL_CHOICE" == "1" ]; then
        POOL="pool-a.yatespool.com:31588"
        POOL_URL="https://a.yatespool.com/"
        break
    elif [ "$POOL_CHOICE" == "2" ]; then
        POOL="pool-b.yatespool.com:32488"
        POOL_URL="https://b.yatespool.com/"
        break
    elif [ "$POOL_CHOICE" == "3" ]; then
        POOL="pool-c.yatespool.com:31189"
        POOL_URL="https://c.yatespool.com/"
        break
    else
        echo -e "${RED}Invalid choice! Please enter 1, 2, or 3${RESET}"
    fi
done

# CPU configuration
while true; do
    echo -e "${GREEN}Enter the number of CPU cores to use (Minimum 2):${RESET}"
    read -p "👉 " CPU_CORES
    
    # Check if input is empty
    if [ -z "$CPU_CORES" ]; then
        echo -e "${RED}CPU cores cannot be empty! Please enter a number.${RESET}"
        continue
    fi
    
    # Check if input is a number and within valid range
    if [[ "$CPU_CORES" =~ ^[0-9]+$ ]]; then
        # Get total CPU cores available
        TOTAL_CORES=$(nproc)
        
        if [ "$CPU_CORES" -lt 2 ]; then
            echo -e "${RED}Error: Minimum 2 CPU cores required!${RESET}"
        elif [ "$CPU_CORES" -gt "$TOTAL_CORES" ]; then
            echo -e "${RED}Error: You only have $TOTAL_CORES CPU cores available!${RESET}"
            echo -e "${YELLOW}Please enter a number between 2 and $TOTAL_CORES${RESET}"
        else
            echo -e "${GREEN}✓ Using $CPU_CORES CPU cores${RESET}"
            break
        fi
    else
        echo -e "${RED}Invalid input! Please enter a valid number.${RESET}"
    fi
done


# Setup CPU devices
CPU_DEVICES=""
for ((i=1; i<=CPU_CORES; i++)); do
    CPU_DEVICES+="--cpu-devices $i "
done
CPU_DEVICES=$(echo $CPU_DEVICES | sed 's/ $//')

# Download and configure miner
echo -e "${YELLOW}Downloading IniMiner...${RESET}"
wget -O /root/iniminer-linux-x64 https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64

echo -e "${YELLOW}Configuring miner service...${RESET}"
cat <<EOF | sudo tee /etc/systemd/system/iniminer.service
[Unit]
Description=IniMiner Service (Root)
After=network.target

[Service]
ExecStart=/root/iniminer-linux-x64 --pool stratum+tcp://$WALLET_ADDRESS.$WORKER_NAME@$POOL $CPU_DEVICES
WorkingDirectory=/root/
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start miner
sudo chmod +x /root/iniminer-linux-x64
echo -e "${YELLOW}Starting miner...${RESET}"
sudo systemctl daemon-reload
sudo systemctl enable iniminer.service
sudo systemctl start iniminer.service

# Final instructions
echo -e "${CYAN}=============================================${RESET}"
echo -e "${CYAN}           INSTALLATION COMPLETE             ${RESET}"
echo -e "${CYAN}=============================================${RESET}"
echo -e "${CYAN}🚀 Miner is now running...${RESET}"
echo -e "${CYAN}Use the following commands to manage the miner:${RESET}"
echo -e "${MAGENTA}1. Check miner status: sudo systemctl status iniminer.service${RESET}"
echo -e "${MAGENTA}2. Restart miner: sudo systemctl restart iniminer.service${RESET}"
echo -e "${MAGENTA}3. View miner logs: sudo journalctl -fu iniminer -o cat${RESET}"
echo -e "${MAGENTA}4. Check your mining progress at: ${POOL_URL}mining/$WALLET_ADDRESS$/data${RESET}"
echo -e "\n${YELLOW}📢 Join Telegram: https://t.me/balstotairdrop${RESET}"
