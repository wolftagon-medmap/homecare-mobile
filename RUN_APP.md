# Cara menjalankan app Flutter (agar edit kode terbaca)

**Penting:** Project Flutter ada di folder **ini** (`homecare-mobile` yang ada `pubspec.yaml`).

Jangan jalankan dari folder parent (`.../homecare-mobile/` yang isinya `homecare-backend` + `homecare-mobile`).  
Kalau jalan dari sana, app bisa pakai kode lama / folder lain dan **edit tidak akan kelihatan**.

## Langkah

1. Buka terminal.
2. Masuk ke folder project Flutter:
   ```
   cd "c:\Universitas Brawijaya\Linkedin\1_Medmap Intern\Project\homecare-mobile\homecare-mobile"
   ```
3. (Opsional) Bersihkan build dulu:
   ```
   fvm flutter clean
   ```
4. Jalankan app:
   ```
   fvm flutter run
   ```

Setelah itu, buka lagi halaman Profile Information. Title harus tampil **"PROFILE INFO TEST 999"** kalau kode di sini yang dipakai.
