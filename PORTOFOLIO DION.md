# PORTOFOLIO KONTRIBUSI PROYEK SISTEM OPERASI

**Topik:** Server Berkas Bersama (Samba) & Audit Akses

## 1. Identitas Mahasiswa

| Keterangan | Isi |
| :--- | :--- |
| Nama | Mario Dionisius Pake |
| NIM | 2510512201 |
| Kelas / Kelompok | E / Kelompok 02 |
| Mata Kuliah | Sistem Operasi |
| Tanggung Jawab | Samba Server |
| Repository Kelompok | https://github.com/kel2-so/fileserver-6a |

## 2. Deskripsi Tanggung Jawab

Saya bertanggung jawab pada bagian **Samba Server** dalam proyek Server Berkas Bersama. Fokus pekerjaan saya adalah melakukan instalasi dan konfigurasi layanan Samba pada Ubuntu, membuat shared folder agar dapat diakses melalui jaringan, serta mengatur hak akses Samba sesuai kebutuhan pengguna.

## 3. Rincian Pekerjaan

### A. Instalasi Samba

Melakukan instalasi paket Samba pada Ubuntu.

- Perintah yang digunakan:
  `sudo apt update && sudo apt install samba -y`
- Tanggal pengerjaan: `6 November 2026`

### B. Konfigurasi Samba

Mengatur konfigurasi layanan melalui file `smb.conf`, termasuk nama share, lokasi direktori, dan aturan akses.

- Konfigurasi yang dibuat:
  `Membuat blok share [berkas] dengan path /srv/fileserver/share, mengatur valid users untuk grup @sf_operator, @sf_reader, dan op1, read list untuk @sf_reader, write list untuk @sf_operator, serta menetapkan create mask = 0660 dan directory mask = 02770.`
- Lokasi file konfigurasi: `/etc/samba/smb.conf`

### C. Pembuatan Shared Folder

Membuat direktori yang akan dibagikan melalui Samba.

- Nama shared folder: `berkas` (direktori `share`)
- Lokasi/path folder: `/srv/fileserver/share`

### D. Pengaturan Hak Akses Samba

Mengatur izin akses agar pengguna yang berwenang dapat mengakses folder sesuai perannya.

- User/grup yang digunakan: `Grup @sf_operator (op1, op2), Grup @sf_reader (rd1, rd2), serta akun tamu1 (di luar grup untuk uji negatif)`
- Hak akses yang diberikan:
  `Grup @sf_operator diberikan hak baca-tulis (read-write / rwx pada direktori mode 2770 dengan setgid), grup @sf_reader diberikan hak baca-saja (read-only / r-x melalui ACL POSIX), sedangkan akun tamu1 di luar grup ditolak aksesnya.`

### E. Pengujian Konfigurasi

Memeriksa konfigurasi Samba menggunakan `testparm` dan menguji akses folder bersama dari klien.

- Perintah pengujian: `testparm -s`, `sudo -u op1 sh -c 'echo uji > /srv/fileserver/share/t1.txt'`, dan `sudo -u tamu1 ls /srv/fileserver/share`
- Hasil pengujian: `Konfigurasi Samba valid (Loaded services file OK). Pengujian positif (T1-P) pada op1 berhasil membuat berkas baru dengan pewarisan grup sf_operator (exit 0), sedangkan pengujian negatif (T1-N) pada tamu1 ditolak sistem dengan pesan Permission denied (exit 2).`

## 4. Skenario Pengujian

| Jenis Pengujian | Skenario | Hasil Aktual |
| :--- | :--- | :--- |
| Positif (+) | Layanan Samba berjalan dan konfigurasi folder sharing dinyatakan valid. | `Berhasil — Perintah testparm -s memuat smb.conf tanpa error (Loaded services file OK), dan op1 berhasil membuat file pada /srv/fileserver/share (exit 0).` |
| Negatif (-) | Konfigurasi Samba yang tidak valid dapat dideteksi melalui pemeriksaan `testparm`. | `Terdeteksi — Kesalahan sintaks/parameter pada smb.conf terdeteksi oleh testparm (exit 1), serta akses pengguna tamu (tamu1) ke direktori bersama ditolak sistem (Permission denied, exit 2).` |

## 5. Bukti Pekerjaan

Tambahkan screenshot atau tautan bukti yang benar-benar berasal dari pengerjaan proyek.

1. Screenshot instalasi Samba pada Ubuntu:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
2. Screenshot konfigurasi `smb.conf`:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
3. Screenshot pembuatan shared folder dan lokasi direktori:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
4. Screenshot pengaturan hak akses Samba:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
5. Screenshot hasil pemeriksaan `testparm`:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
6. Screenshot pengujian akses shared folder dari komputer klien:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing

> Pastikan screenshot tidak menampilkan password atau informasi rahasia lainnya.

## 6. Informasi GitHub

| Keterangan | Isi |
| :--- | :--- |
| Repository kelompok | https://github.com/kel2-so/fileserver-6a |
| Repository fork pribadi | https://github.com/mariodyon/fileserver-6a |
| Commit hash pekerjaan | `Isi dengan kode 7 karakter commit kamu setelah simpan` |
| Pesan commit | `Instalasi dan konfigurasi Samba Server` |
| Status PORTOFOLIO.md | `Sudah dibuat` |

## 7. Kendala dan Penyelesaian

**Kendala yang ditemukan:**\
`1) Muncul peringatan "WARNING: The 'netbios name' is too long (max. 15 chars)" saat pemeriksaan konfigurasi Samba menggunakan testparm -s karena nama hostname VM melebihi 15 karakter. 2) Skrip setup_env.sh sempat menolak dijalankan secara langsung karena membutuhkan hak akses root, serta muncul penolakan password lemah (dictionary check) saat pengaturan awal kata sandi akun uji.`

**Langkah penyelesaian:**\
`1) Memastikan parameter disable netbios = Yes aktif pada blok [global] di /etc/samba/smb.conf sehingga layanan berbagi berkas tetap berjalan normal tanpa terpengaruh batasan panjang nama NetBIOS. 2) Menjalankan skrip menggunakan hak akses superuser (sudo scripts/setup_env.sh) dan menetapkan kombinasi kata sandi yang memenuhi kebijakan kompleksitas sistem.`

## 8. Kesimpulan

Melalui bagian pekerjaan Samba Server, saya mempelajari proses instalasi dan konfigurasi layanan Samba, pembuatan folder bersama, serta pengaturan hak akses agar folder dapat digunakan oleh pengguna sesuai izin yang ditetapkan. Hasil akhir dan status pengujian perlu disesuaikan dengan bukti aktual dari pelaksanaan proyek.

---

**Nama:** Mario Dionisius Pake\
**NIM:** 2510512201\
**Tanggal pembaruan:** `15 November 2026`
