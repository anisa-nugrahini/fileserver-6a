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

Saya bertanggung jawab pada bagian **User, Group, dan Permission (Analisis Proteksi Sistem Berkas dan Hak Akses Pengguna)** dalam proyek Server Berkas Bersama. Fokus pekerjaan saya adalah membuat akun pengguna dan grup sistem, mengatur kepemilikan dan izin direktori (`chmod 2770` dengan bit *setgid* serta *Access Control List* / ACL), serta memverifikasi proteksi berkas agar hanya pengguna berwenang yang dapat mengakses direktori bersama.

## 3. Rincian Pekerjaan

### A. Inisialisasi Lingkungan & Struktur Direktori

Menjalankan skrip penyiapan lingkungan sistem berkas dan memeriksa struktur direktori kerja.

- Perintah yang digunakan:
  `chmod +x scripts/*.sh` dan `sudo scripts/setup_env.sh`
- Tanggal pengerjaan: `6 November 2026`
- Hasil: Direktori `/srv/fileserver/backup`, `/srv/fileserver/logs`, `/srv/fileserver/restore-test`, dan `/srv/fileserver/share` berhasil dibuat dengan kepemilikan dan struktur awal yang sesuai.

### B. Pembuatan User & Group Sistem

Membuat akun pengguna dan grup sesuai peran masing-masing serta menetapkan kata sandi sistem.

- User & grup yang dikonfigurasi:
  - Grup `sf_admin` (GID 1001) beranggotakan `adm1` (UID 1001).
  - Grup `sf_operator` (GID 1002) beranggotakan `op1` (UID 1002) dan `op2` (UID 1003).
  - Grup `sf_reader` (GID 1003) beranggotakan `rd1` (UID 1004) dan `rd2` (UID 1005).
  - Akun `tamu1` (UID 1006, GID 1009) di luar grup proyek untuk pengujian negatif.
- Perintah verifikasi: `getent group sf_operator`, `getent group sf_reader`, dan `id adm1 / op1 / op2 / rd1 / rd2 / tamu1`.

### C. Pengaturan Hak Akses Direktori (`chmod 2770` & ACL)

Mengatur izin akses direktori bersama `/srv/fileserver/share` menggunakan bit *setgid* dan POSIX ACL agar pewarisan grup berjalan otomatis.

- Lokasi folder: `/srv/fileserver/share`
- Konfigurasi izin:
  - Direktori `/srv/fileserver/share` diset ke mode `drwxrws---+` (`2770`) dengan pemilik `root:sf_operator`.
  - Grup `sf_operator` memiliki hak baca-tulis-eksekusi (`rwx`), grup `sf_reader` diberikan hak baca-saja (`r-x`) melalui aturan ACL (`group:sf_reader:r-x` dan `default:group:sf_reader:r-x`), sedangkan `other` tidak diberi akses (`---`).
- Perintah verifikasi: `ls -ld /srv/fileserver/*` dan `getfacl /srv/fileserver/share`.

### D. Pengujian Proteksi Hak Akses (Positif & Negatif)

Menguji kemampuan penulisan berkas pada direktori `/srv/fileserver/share` menggunakan akun operator dan akun tamu.

- Perintah pengujian:
  - Uji Positif (+): `sudo -u op1 touch /srv/fileserver/share/t1.txt`
  - Uji Negatif (-): `sudo -u tamu1 touch /srv/fileserver/share/t2.txt`
- Hasil pengujian: Akun `op1` berhasil membuat berkas `t1.txt` di dalam `/srv/fileserver/share`, sedangkan akun `tamu1` ditolak oleh sistem dengan pesan `Permission denied`.

## 4. Skenario Pengujian

| Jenis Pengujian | Skenario | Hasil Aktual |
| :--- | :--- | :--- |
| Positif (+) | Pengguna dengan peran operator (`op1`) membuat berkas baru di dalam direktori bersama `/srv/fileserver/share`. | `Berhasil — Perintah sudo -u op1 touch /srv/fileserver/share/t1.txt berjalan sukses tanpa error karena op1 tergabung dalam grup sf_operator yang memiliki izin rwx (mode 2770).` |
| Negatif (-) | Pengguna tamu (`tamu1`) yang tidak tergabung dalam grup berwenang mencoba membuat berkas di `/srv/fileserver/share`. | `Ditolak — Perintah sudo -u tamu1 touch /srv/fileserver/share/t2.txt gagal dengan pesan "touch: setting times of '/srv/fileserver/share/t2.txt': Permission denied".` |

## 5. Bukti Pekerjaan

Seluruh tangkapan layar bukti pengerjaan tersimpan pada folder Google Drive berikut:
https://drive.google.com/drive/folders/1YZUQLrVlPEdqvKpY_KEdr96lF0bqPfuT?usp=sharing

1. **Screenshot Inisialisasi `setup_env.sh`, Hak Akses Awal & Pembuatan Password User (`SO 1.jpeg`):**
   Menampilkan eksekusi `sudo scripts/setup_env.sh`, pemeriksaan ACL awal, struktur direktori `/srv/fileserver/*`, serta penetapan kata sandi untuk akun `adm1`, `op1`, `op2`, dan `tamu1`.
2. **Screenshot Verifikasi Group, UID/GID, Permission `2770`, `getfacl` & Uji Akses `op1` vs `tamu1` (`SO 2.jpg`):**
   Menampilkan output `getent group`, `id` seluruh akun uji, `ls -ld /srv/fileserver/*` (`drwxrws---+`), `getfacl /srv/fileserver/share`, serta bukti `op1` berhasil membuat `t1.txt` dan `tamu1` ditolak (`Permission denied`) saat membuat `t2.txt`.

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
`1) Skrip setup_env.sh sempat menolak dijalankan tanpa hak akses administrator dengan pesan "Jalankan dengan sudo". 2) Saat penetapan kata sandi akun uji dengan sudo passwd, sistem menolak kata sandi sederhana dengan peringatan "BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word". 3) Sempat terjadi kesalahan ketik perintah ([200-getent group sf_admin) akibat karakter paste pada terminal.`

**Langkah penyelesaian:**\
`1) Menjalankan skrip menggunakan hak akses superuser melalui perintah sudo scripts/setup_env.sh hingga seluruh direktori dan ACL terbentuk. 2) Menetapkan ulang kombinasi kata sandi yang lebih kuat sehingga seluruh akun uji (adm1, op1, op2, tamu1) berhasil diperbarui (passwd: password updated successfully). 3) Mengetik ulang perintah verifikasi getent group secara bersih tanpa karakter tambahan.`

## 8. Kesimpulan

Melalui bagian pekerjaan User, Group, dan Permission, saya memahami cara mengelola akun pengguna dan grup di Linux, menerapkan bit *setgid* (`2770`) serta POSIX ACL (`getfacl`) untuk pewarisan hak akses otomatis pada direktori bersama, serta membuktikan bahwa sistem mampu mengizinkan akses tulis bagi anggota grup berwenang (`op1`) dan memblokir pengguna di luar grup (`tamu1`).

---

**Nama:** Mario Dionisius Pake\
**NIM:** 2510512201\
**Tanggal pembaruan:** `15 November 2026`
