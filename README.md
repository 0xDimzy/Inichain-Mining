#IniMiner Installer

📌 Deskripsi

Script ini digunakan untuk menginstal dan mengkonfigurasi IniMiner pada VPS Linux agar dapat melakukan mining di jaringan YatesPool. Pengguna dapat memilih pool dan menentukan jumlah core CPU yang digunakan untuk mining.

⚙️ Persyaratan Sistem

Sistem operasi: Ubuntu/Debian

Akses root

Minimal 2 core CPU

Koneksi internet

📥 Instalasi

Download script

wget -O install-iniminer.sh https://raw.githubusercontent.com/0xDimzy/Inichain-Mining/main/install-iniminer.sh
chmod +x install-iniminer.sh

Jalankan script

sudo ./install-iniminer.sh

Ikuti instruksi

Masukkan alamat wallet

Pilih pool yang tersedia

Masukkan jumlah core CPU yang akan digunakan

🔧 Manajemen Miner

Cek status miner:

sudo systemctl status iniminer.service

Restart miner:

sudo systemctl restart iniminer.service

Cek log miner:

sudo journalctl -u iniminer.service --no-pager --lines=50

🔍 Cek Hasil Mining

Anda dapat melihat hasil mining melalui:

Pool A

Pool B

Pool C

Gunakan format berikut untuk mengecek akun mining Anda:

https://[pool].yatespool.com/#/account/[WALLET_ADDRESS]

📢 Bergabung di Komunitas

Jangan lupa bergabung ke channel Telegram untuk mendapatkan informasi terbaru:
👉 Join Telegram

📂 Sumber Kode

Repository ini tersedia di GitHub:
🔗 Inichain Mining

