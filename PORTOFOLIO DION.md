# PORTOFOLIO KONTRIBUSI PROYEK SISTEM OPERASI

**Topik:** Server Berkas Bersama (Samba) & Audit Akses

## 1. Identitas Mahasiswa

| Keterangan | Isi |
| :--- | :--- |
| Nama | Mario Dionisius Pake |
| NIM | 2510512201 |
| Kelas / Kelompok | E / Kelompok 02 |
| Mata Kuliah | Sistem Operasi |
| Tanggung Jawab | User, Group, dan Permission (Analisis Proteksi Sistem Berkas dan Hak Akses Pengguna) |
| Repository Kelompok | https://github.com/kel2-so/fileserver-6a |

## 2. Deskripsi Tanggung Jawab

Saya bertanggung jawab pada bagian **User, Group, dan Permission (Analisis Proteksi Sistem Berkas dan Hak Akses Pengguna)** dalam proyek Server Berkas Bersama[cite: 18]. Fokus pekerjaan saya adalah melakukan penyiapan struktur direktori bersama, membuat akun pengguna dan grup sistem sesuai peran, mengatur izin kepemilikan serta hak akses direktori (`chmod 2770` dan POSIX ACL), serta menguji proteksi sistem berkas agar hanya pengguna berwenang yang dapat mengakses dan menulis berkas[cite: 16, 17, 18].

## 3. Rincian Pekerjaan

### A. Inisialisasi Lingkungan & Pembuatan Direktori Kerja

Menjalankan skrip inisialisasi lingkungan sistem berkas pada Ubuntu untuk menyiapkan direktori proyek[cite: 16].

- Perintah yang digunakan:
  `chmod +x scripts/*.sh` dan `sudo scripts/setup_env.sh`[cite: 16]
- Tanggal pengerjaan: `6 November 2026`[cite: 16]

### B. Pembuatan User dan Group Sistem

Mengatur pembuatan akun pengguna dan grup sistem sesuai peran masing-masing serta menetapkan kata sandi login untuk setiap akun uji[cite: 16, 17].

- Konfigurasi yang dibuat:
  `Membuat grup sf_admin (GID 1001) untuk adm1 (UID 1001), grup sf_operator (GID 1002) untuk op1 (UID 1002) dan op2 (UID 1003), grup sf_reader (GID 1003) untuk rd1 (UID 1004) dan rd2 (UID 1005), serta akun tamu1 (UID 1006, GID 1009) di luar grup proyek untuk pengujian negatif.`[cite: 17]
- Perintah penetapan sandi: `sudo passwd adm1`, `sudo passwd op1`, `sudo passwd op2`, dan `sudo passwd tamu1`[cite: 16]

### C. Pembuatan Shared Folder

Membuat dan memverifikasi direktori bersama beserta struktur subdirektori sistem berkas[cite: 16, 17].

- Nama shared folder: `share` (beserta subdirektori `backup`, `logs`, dan `restore-test`)[cite: 16, 17]
- Lokasi/path folder: `/srv/fileserver/share`[cite: 16, 17]

### D. Pengaturan Hak Akses (Permission 2770 & ACL)

Mengatur izin akses direktori agar pengguna yang berwenang dapat mengakses dan mewarisi kepemilikan grup secara otomatis sesuai perannya[cite: 16, 17].

- User/grup yang digunakan: `Grup sf_operator (op1, op2), Grup sf_reader (rd1, rd2), Grup sf_admin (adm1), serta akun tamu1 (di luar grup untuk uji negatif)`[cite: 17]
- Hak akses yang diberikan:
  `Direktori /srv/fileserver/share diatur dengan kepemilikan root:sf_operator dan mode izin drwxrws---+ (chmod 2770 dengan bit setgid). Grup sf_operator diberikan hak baca-tulis-eksekusi (rwx), grup sf_reader diberikan hak baca-saja (r-x) melalui POSIX ACL (group:sf_reader:r-x dan default:group:sf_reader:r-x), sedangkan pengguna lain (other) ditolak seluruh aksesnya (---).`[cite: 16, 17]

### E. Pengujian Proteksi Sistem Berkas & Hak Akses

Memeriksa konfigurasi grup, UID/GID, izin direktori, ACL, serta menguji akses penulisan berkas menggunakan akun operator dan akun tamu[cite: 17].

- Perintah pengujian: `getent group sf_operator`, `getent group sf_reader`, `id adm1 / op1 / op2 / rd1 / rd2 / tamu1`, `ls -ld /srv/fileserver/*`, `getfacl /srv/fileserver/share`, `sudo -u op1 touch /srv/fileserver/share/t1.txt`, dan `sudo -u tamu1 touch /srv/fileserver/share/t2.txt`[cite: 17]
- Hasil pengujian: `Struktur grup, UID/GID, mode drwxrws---+ (2770), dan aturan ACL terverifikasi sesuai rancangan. Pengujian positif (+) pada op1 berhasil membuat berkas baru /srv/fileserver/share/t1.txt tanpa error, sedangkan pengujian negatif (-) pada tamu1 ditolak sistem dengan pesan "touch: setting times of '/srv/fileserver/share/t2.txt': Permission denied".`[cite: 17]

## 4. Skenario Pengujian

| Jenis Pengujian | Skenario | Hasil Aktual |
| :--- | :--- | :--- |
| Positif (+) | Pengguna dengan peran operator (`op1`) membuat berkas baru pada direktori bersama `/srv/fileserver/share` yang memiliki izin `2770`.[cite: 17, 18] | `Berhasil — Perintah sudo -u op1 touch /srv/fileserver/share/t1.txt dieksekusi tanpa error karena op1 tergabung dalam grup sf_operator yang memiliki hak akses rwx pada direktori /srv/fileserver/share.`[cite: 17] |
| Negatif (-) | Pengguna tamu (`tamu1`) yang tidak tergabung dalam grup berwenang mencoba membuat berkas pada direktori bersama `/srv/fileserver/share`.[cite: 17, 18] | `Ditolak — Perintah sudo -u tamu1 touch /srv/fileserver/share/t2.txt gagal dan diblokir sistem dengan pesan "touch: setting times of '/srv/fileserver/share/t2.txt': Permission denied".`[cite: 17] |

## 5. Bukti Pekerjaan

Tambahkan screenshot atau tautan bukti yang benar-benar berasal dari pengerjaan proyek.

1. Screenshot inisialisasi lingkungan `setup_env.sh` pada Ubuntu (`SO 1.jpeg`)[cite: 16]:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
2. Screenshot pembuatan user dan pengaturan kata sandi sistem (`SO 1.jpeg`)[cite: 16]:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
3. Screenshot pembuatan shared folder dan lokasi direktori `/srv/fileserver/*` (`SO 1.jpeg` & `SO 2.jpg`)[cite: 16, 17]:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
4. Screenshot pengaturan hak akses `chmod 2770` (`drwxrws---+`) dan `getfacl` (`SO 2.jpg`)[cite: 17]:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
5. Screenshot hasil pemeriksaan grup (`getent group`) dan `id` pengguna (`SO 2.jpg`)[cite: 17]:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing
6. Screenshot pengujian akses shared folder oleh `op1` (+) dan penolakan `tamu1` (-) (`SO 2.jpg`)[cite: 17]:
   https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing

> Pastikan screenshot tidak menampilkan password atau informasi rahasia lainnya.

## 6. Informasi GitHub

| Keterangan | Isi |
| :--- | :--- |
| Repository kelompok | https://github.com/kel2-so/fileserver-6a |
| Repository fork pribadi | https://github.com/mariodyon/fileserver-6a |
| Commit hash pekerjaan | `f450d84` |
| Pesan commit | `Menambahkan dokumentasi User, Group, dan Permission pada PORTOFOLIO DION.md` |
| Status PORTOFOLIO.md | `Sudah dibuat` |

## 7. Kendala dan Penyelesaian

**Kendala yang ditemukan:**\
`1) Skrip setup_env.sh sempat menolak dijalankan secara langsung tanpa hak akses root dengan pesan "Jalankan dengan sudo". 2) Saat penetapan kata sandi akun uji menggunakan sudo passwd, sistem menolak kata sandi sederhana dengan peringatan "BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word" serta terjadi ketidakcocokan pengetikan ulang sandi (Sorry, passwords do not match). 3) Sempat terjadi kesalahan karakter paste pada terminal ([200-getent group sf_admin) sehingga perintah tidak dikenali.`[cite: 16, 17]

**Langkah penyelesaian:**\
`1) Menjalankan skrip menggunakan hak akses superuser melalui perintah sudo scripts/setup_env.sh hingga seluruh struktur direktori dan ACL terbentuk. 2) Menetapkan ulang kombinasi kata sandi yang memenuhi kebijakan kompleksitas sistem hingga seluruh akun uji (adm1, op1, op2, tamu1) berhasil diperbarui (passwd: password updated successfully). 3) Mengetik ulang perintah verifikasi getent group secara bersih tanpa karakter tambahan.`[cite: 16, 17]

## 8. Kesimpulan

Melalui bagian pekerjaan User, Group, dan Permission, saya mempelajari proses pengelolaan akun pengguna dan grup di sistem operasi Linux, pembuatan folder bersama beserta penerapan bit *setgid* (`2770`) dan POSIX ACL untuk pewarisan hak akses otomatis, serta verifikasi proteksi berkas agar folder hanya dapat ditulis oleh pengguna yang berwenang (`op1`) dan memblokir pengguna di luar grup (`tamu1`)[cite: 16, 17, 18].

---

**Nama:** Mario Dionisius Pake\
**NIM:** 2510512201\
**Tanggal pembaruan:** `15 November 2026`
