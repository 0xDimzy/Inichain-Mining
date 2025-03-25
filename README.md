# Iniminer Auto Install

## ⚙️ Persyaratan Sistem
Sistem operasi: Ubuntu/Debian

Minimal 2 GB RAM

Minimal 2 core CPU

## Cara Menggunakan

1. **Unduh Skrip**: Salin skrip 
   ```bash
   wget -O install-iniminer.sh https://raw.githubusercontent.com/0xDimzy/Inichain-Mining/main/install_iniminer.sh
   ```
2. **Beri Izin Eksekusi**: Jalankan perintah berikut untuk memberikan izin eksekusi pada skrip:
   ```bash
   chmod +x install-iniminer.sh
   ```
3. **Jalankan Skrip**: Eksekusi skrip dengan perintah:
   ```bash
   sudo ./install-iniminer.sh
   ```
4. **Ikuti Petunjuk**: Ikuti petunjuk yang muncul di terminal untuk memasukkan alamat wallet dan memilih pool mining.

## Mengelola Layanan Miner

Setelah instalasi selesai, Anda dapat mengelola layanan miner menggunakan perintah berikut:

- **Cek status miner**:
  ```bash
  sudo systemctl status iniminer.service
  ```
- **Restart miner**:
  ```bash
  sudo systemctl restart iniminer.service
  ```
- **Cek log miner**:
  ```bash
  sudo journalctl -u iniminer.service --no-pager --lines=50
  ```
## 🔍 Cek Hasil Mining

Anda dapat melihat hasil mining melalui:

[Pool A](https://a.yatespool.com/)

[Pool B](https://b.yatespool.com/)

[Pool C](https://c.yatespool.com/)

## Catatan

- Pastikan untuk mengganti `WALLET_ADDRESS` dengan alamat wallet Anda yang valid.
- Skrip ini dirancang untuk digunakan dengan minimal 2 CPU core.

## Bergabung dengan Komunitas

Jangan lupa untuk bergabung dengan channel Telegram kami untuk mendapatkan informasi terbaru:
[Telegram Channel](https://t.me/balstotairdrop)

## Source Code [Inichain](https://inichain.gitbook.io/initverseinichain/inichain/mining-mainnet)
