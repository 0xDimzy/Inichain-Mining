#!/bin/bash


RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
RESET='\e[0m'


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


echo -e "${YELLOW}Updating system and installing dependencies...${RESET}"
sudo apt update && sudo apt upgrade -y
sleep 2
sudo apt install wget nano systemd -y
sleep 2


echo -e "${GREEN}Enter your wallet EVM address (Format 0x12345):${RESET}"
read -p "👉 " WALLET_ADDRESS
sleep 2

# Select pool
echo -e "${MAGENTA}Select a mining pool:${RESET}"
echo -e "${BLUE}1. pool-a.yatespool.com:31588${RESET}"
echo -e "${BLUE}2. pool-b.yatespool.com:32488${RESET}"
echo -e "${BLUE}3. pool-c.yatespool.com:31189${RESET}"
read -p "Enter your choice (1/2/3): " POOL_CHOICE
sleep 2


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
    echo -e "${RED}Invalid choice, defaulting to pool-a.yatespool.com:31588${RESET}"
    POOL="pool-a.yatespool.com:31588"
    POOL_URL="https://a.yatespool.com/"
fi
sleep 2


while true; do
    echo -e "${GREEN}Enter the number of CPU cores (Minimum 2):${RESET}"
    read -p "👉 " CPU_CORES
    if [[ "$CPU_CORES" =~ ^[0-9]+$ ]] && [ "$CPU_CORES" -ge 2 ]; then
        break
    else
        echo -e "${RED}Invalid input or less than 2. Please try again.${RESET}"
    fi
done
sleep 2


CPU_DEVICES=""
for ((i=1; i<=CPU_CORES; i++)); do
    CPU_DEVICES+="--cpu-devices $i "
done
CPU_DEVICES=$(echo $CPU_DEVICES | sed 's/ $//')
sleep 2


echo -e "${YELLOW}Downloading IniMiner...${RESET}"
wget -O /root/iniminer-linux-x64 https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
sleep 2


echo -e "${YELLOW}Configuring miner service...${RESET}"
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


sudo chmod +x /root/iniminer-linux-x64
sleep 2


echo -e "${YELLOW}Starting miner...${RESET}"
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable iniminer.service
sleep 1
sudo systemctl start iniminer.service
sleep 1


echo -e "${GREEN}##################################################${RESET}"
echo -e "${GREEN}#                                              #${RESET}"
echo -e "${GREEN}#     ██████   █████   ██      ████████       #${RESET}"
echo -e "${GREEN}#     ██   ██ ██   ██  ██         ██         #${RESET}"
echo -e "${GREEN}#     ██████  ███████  ██         ██         #${RESET}"
echo -e "${GREEN}#     ██   ██ ██   ██  ██         ██         #${RESET}"
echo -e "${GREEN}#     ██   ██ ██   ██  ███████    ██         #${RESET}"
echo -e "${GREEN}#                                              #${RESET}"
echo -e "${GREEN}#              🚀 BALSTOT 🚀                 #${RESET}"
echo -e "${GREEN}##################################################${RESET}"
echo -e "${CYAN}🚀 Installation complete! Miner is now running...${RESET}"
echo -e "${CYAN}Use the following commands to manage the miner:${RESET}"
echo -e "${MAGENTA}1. Check miner status: sudo systemctl status iniminer.service${RESET}"
echo -e "${MAGENTA}2. Restart miner: sudo systemctl restart iniminer.service${RESET}"
echo -e "${MAGENTA}3. View miner logs: sudo journalctl -fu iniminer -o cat${RESET}"
echo -e "${MAGENTA}4. Check your mining progress at: ${POOL_URL}mining/$WALLET_ADDRESS$/data{RESET}"
echo -e "\n${YELLOW}📢 Don't forget to join the Telegram channel: https://t.me/balstotairdrop${RESET}"
