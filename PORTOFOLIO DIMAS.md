# PORTOFOLIO KONTRIBUSI PROYEK SISTEM OPERASI

**Topik:** Server Berkas Bersama (Samba) & Audit Akses

## 1. Identitas Mahasiswa

  Keterangan            Isi
  --------------------- ------------------------------------------
  Nama                  Dimas Dwi Surya
  NIM                   2510512196
  Kelas / Kelompok      [Isi kelas] / Kelompok 02
  Mata Kuliah           Sistem Operasi
  Tanggung Jawab        Monitoring, Log, Laporan, dan Docker
  Repository Kelompok   https://github.com/kel2-so/fileserver-6a

## 2. Deskripsi Tanggung Jawab

Saya bertanggung jawab pada bagian **Monitoring, Log, Laporan, dan
Docker** dalam proyek Server Berkas Bersama. Fokus pekerjaan saya adalah
memantau status layanan, mencatat hasil uji akses ke dalam log,
membuat laporan hasil pengujian, serta membaca laporan melalui
container Docker dengan mode read-only.

## 3. Rincian Pekerjaan

### A. Monitoring Layanan

Memeriksa status layanan menggunakan skrip `fs-check.sh`.

-   Perintah yang digunakan: `[Isi perintah yang benar-benar dijalankan]`
-   Tanggal pengerjaan: `[Isi tanggal]`
-   Hasil: `[Isi hasil aktual]`

### B. Pencatatan Log

Mencatat hasil uji akses menggunakan skrip `fs-logtest.sh`.

-   Perintah yang digunakan: `[Isi perintah yang benar-benar dijalankan]`
-   Lokasi log: `[Isi lokasi file log]`

### C. Pembuatan Laporan

Membuat laporan hasil pengujian menggunakan `scripts/report.sh`.

-   Perintah yang digunakan: `[Isi perintah]`
-   Lokasi laporan: `output/laporan.txt`

### D. Docker Read-Only

Membaca laporan melalui container Docker (image alpine) dengan mount
read-only, lalu memverifikasi integritas laporan dengan `sha256sum`.

-   Perintah yang digunakan: `[Isi perintah Docker yang benar-benar dijalankan]`
-   Hasil baca laporan: `[Isi hasil aktual]`
-   Hasil percobaan tulis: `[Isi pesan error aktual, misalnya Read-only file system]`
-   Hasil verifikasi sha256sum: `[Isi hasil aktual, misalnya OK]`

## 4. Skenario Pengujian

  ---------------------------------------------------------------------------------------------------------
  Jenis Pengujian         Skenario                Hasil Aktual
  ----------------------- ----------------------- ---------------------------------------------------------
  Positif (+)             Layanan aktif           `[Berhasil/Gagal + keterangan atau bukti]`
                          terdeteksi, aktivitas   
                          pada log tercatat, dan  
                          Docker berhasil membaca 
                          laporan.                

  Negatif (-)             Layanan yang berhenti   `[Terdeteksi/Ditolak + keterangan atau bukti]`
                          terdeteksi dan          
                          penulisan laporan       
                          melalui Docker          
                          read-only ditolak.      
  ---------------------------------------------------------------------------------------------------------

## 5. Bukti Pekerjaan

Tambahkan screenshot atau tautan bukti yang benar-benar berasal dari
pengerjaan proyek.

1.  Screenshot hasil `fs-check.sh`: `[Tempel gambar atau tautan]`
2.  Screenshot hasil `fs-logtest.sh` / isi log: `[Tempel gambar atau tautan]`
3.  Screenshot hasil `report.sh` / isi `output/laporan.txt`: `[Tempel gambar atau tautan]`
4.  Screenshot Docker membaca laporan: `[Tempel gambar atau tautan]`
5.  Screenshot Docker menolak penulisan (read-only): `[Tempel gambar atau tautan]`
6.  Screenshot hasil `sha256sum -c`: `[Tempel gambar atau tautan]`

> Pastikan screenshot tidak menampilkan password atau informasi rahasia
> lainnya.

## 6. Informasi GitHub

  -------------------------------------------------------------------------------------------------------------
  Keterangan                          Isi
  ----------------------------------- -------------------------------------------------------------------------
  Repository kelompok                 https://github.com/kel2-so/fileserver-6a

  Repository fork pribadi             https://github.com/dimasdwsrya/fileserver-6a

  Commit hash pekerjaan               `[Masukkan hash commit aktual setelah di-commit dan di-push]`

  Pesan commit                        `Monitoring, Log, Laporan, dan Docker`

  Status PORTOFOLIO.md                `[Sudah dibuat/Belum dibuat]`
  -------------------------------------------------------------------------------------------------------------

## 7. Kendala dan Penyelesaian

**Kendala yang ditemukan:**\
`[Tuliskan kendala yang benar-benar dialami. Jika tidak ada, tulis "Tidak ada kendala berarti."]`

**Langkah penyelesaian:**\
`[Jelaskan tindakan yang dilakukan untuk mengatasi kendala tersebut.]`

## 8. Kesimpulan

Melalui bagian Monitoring, Log, Laporan, dan Docker, saya mempelajari
cara memantau layanan, mencatat hasil uji akses, membuat laporan, serta
membaca laporan melalui container Docker read-only. Hasil akhir dan
status pengujian perlu disesuaikan dengan bukti aktual dari pelaksanaan
proyek.

------------------------------------------------------------------------

**Nama:** Dimas Dwi Surya\
**NIM:** 2510512196\
**Tanggal pembaruan:** `[Isi tanggal]`
