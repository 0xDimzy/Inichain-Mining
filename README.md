# Iniminer

Skrip ini digunakan untuk menginstal dan mengonfigurasi miner bernama IniMiner pada sistem berbasis Linux. Skrip ini secara otomatis memperbarui sistem, menginstal dependensi yang diperlukan, dan mengonfigurasi layanan systemd untuk menjalankan miner.

## Fitur

- Memperbarui sistem dan menginstal dependensi yang diperlukan.
- Meminta input dari pengguna untuk alamat wallet dan jumlah CPU core.
- Memilih pool mining berdasarkan input pengguna.
- Mengonfigurasi layanan systemd untuk menjalankan miner secara otomatis.

## Prasyarat

- Sistem operasi berbasis Linux (Ubuntu/Debian).
- Akses ke terminal dengan hak istimewa `sudo`.
- Koneksi internet yang stabil.

## Cara Menggunakan

1. **Unduh Skrip**: Salin skrip `Test-Iniminer.sh` ke direktori yang diinginkan.
2. **Beri Izin Eksekusi**: Jalankan perintah berikut untuk memberikan izin eksekusi pada skrip:
   ```bash
   chmod +x Test-Iniminer.sh
   ```
3. **Jalankan Skrip**: Eksekusi skrip dengan perintah:
   ```bash
   ./Test-Iniminer.sh
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

## Catatan

- Pastikan untuk mengganti `WALLET_ADDRESS` dengan alamat wallet Anda yang valid.
- Skrip ini dirancang untuk digunakan dengan minimal 2 CPU core.

## Bergabung dengan Komunitas

Jangan lupa untuk bergabung dengan channel Telegram kami untuk mendapatkan informasi terbaru:
[Telegram Channel](https://t.me/balstotairdrop)
