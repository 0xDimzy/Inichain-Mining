# Iniminer Auto Install

## ⚙️ System Requirements
Operating System: Ubuntu/Debian

Minimum 2 GB RAM

Minimum 2 CPU cores

## How to Use

1. **Download the Script**: Copy Script
   ```bash
   wget -O install-iniminer.sh https://raw.githubusercontent.com/0xDimzy/Inichain-Mining/main/install_iniminer.sh
   ```
2. **Grant Execution Permission**: Run the following command to make the script executable
   ```bash
   chmod +x install-iniminer.sh
   ```
3. **Run the Script**: Execute the script using
   ```bash
   sudo ./install-iniminer.sh
   ```
4. **Follow the Instructions**: Follow the on-screen instructions to enter your wallet address and choose a mining pool.

## Managing the Miner Service

After installation, you can manage the miner service using the following commands:

- **Check status miner**:
  ```bash
  sudo systemctl status iniminer.service
  ```
- **Restart miner**:
  ```bash
  sudo systemctl restart iniminer.service
  ```
- **Check log miner**:
  ```bash
  sudo journalctl -fu iniminer -o cat
  ```
## 🔍 CCheck Mining Results

You can check your mining results at:

[Pool A](https://a.yatespool.com/)

[Pool B](https://b.yatespool.com/)

[Pool C](https://c.yatespool.com/)

## Notes

- Make sure to replace `WALLET_ADDRESS` with your valid wallet address.
- This script is designed for systems with at least 2 CPU cores.

## Join the Community

Don't forget to join our Telegram channel for the latest updates:
[Telegram Channel](https://t.me/balstotairdrop)

## Source Code [Inichain](https://inichain.gitbook.io/initverseinichain/inichain/mining-mainnet)
