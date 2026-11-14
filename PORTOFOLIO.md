# PORTOFOLIO KONTRIBUSI PROYEK SISTEM OPERASI

**Topik:** Server Berkas Bersama (Samba) & Audit Akses

## 1. Identitas Mahasiswa

| Keterangan | Isi |
|---|---|
| Nama | Dimas Dwi Surya |
| NIM | 2510512196 |
| Kelas / Kelompok | E / Kelompok 02 |
| Mata Kuliah | Sistem Operasi |
| Tanggung Jawab | Monitoring, Log, Laporan, dan Docker |
| Repository Kelompok | https://github.com/kel2-so/fileserver-6a |

## 2. Deskripsi Tanggung Jawab

Saya bertanggung jawab pada bagian **Monitoring, Log, Laporan, dan
Docker** dalam proyek Server Berkas Bersama. Fokus pekerjaan saya adalah
memantau status layanan Samba, mencatat hasil uji akses ke dalam log,
membuat laporan hasil pengujian, serta membaca laporan melalui container
Docker dengan mode read-only dan memverifikasi integritasnya.

Seluruh pengujian dijalankan pada VM Ubuntu milik saya sendiri
(hostname `s026-2510512196-e`, akun `dimas`), yang disiapkan mengikuti
langkah instalasi pada README repository.

## 3. Rincian Pekerjaan

### A. Monitoring Layanan

Memeriksa status layanan Samba (`smbd`) menggunakan skrip `fs-check.sh`.

-   Perintah yang digunakan:
    `sudo /usr/local/sbin/fs-check.sh`,
    `sudo systemctl stop smbd`,
    `sudo systemctl start smbd`
-   Tanggal pengerjaan: 14 November 2026
-   Hasil: saat layanan hidup muncul `OK smbd aktif (PID 6788)`; setelah
    layanan dihentikan muncul `ERROR smbd tidak aktif`; setelah
    dihidupkan kembali muncul `OK smbd aktif (PID 9329)`.

### B. Pencatatan Log

Mencatat hasil uji akses menggunakan skrip `fs-logtest.sh`. Setiap uji
dijalankan terlebih dahulu, lalu kode keluar (exit code) yang benar-benar
muncul dicatat ke log.

-   Perintah yang digunakan:
    -   `sudo -u op1 touch /srv/fileserver/share/uji_op1.txt` lalu
        `sudo /usr/local/sbin/fs-logtest.sh T1-p "op1 berhasil membuat file" 0 LULUS`
    -   `sudo -u rd1 rm -f /srv/fileserver/share/uji_op1.txt` lalu
        `sudo /usr/local/sbin/fs-logtest.sh T4-N "rd1 gagal menghapus file" 1 LULUS`
    -   `sudo -u tamu1 ls /srv/fileserver/share` lalu
        `sudo /usr/local/sbin/fs-logtest.sh T3-N "tamu1 ditolak mengakses share" 2 LULUS`
-   Lokasi log: `/srv/fileserver/logs/access-tests.log`
-   Hasil: tiga baris tercatat (T1-p `exit=0`, T4-N `exit=1`,
    T3-N `exit=2`), seluruhnya berstatus LULUS.

### C. Pembuatan Laporan

Membuat laporan hasil pengujian menggunakan `scripts/report.sh`.

-   Perintah yang digunakan: `sudo bash scripts/report.sh`
-   Lokasi laporan: `output/laporan.txt`
-   Hasil: laporan dibuat pada 14 November 2026 pukul 20:56:58, berisi
    status layanan smbd (aktif), hasil uji akses (3 baris), dan baris
    terakhir `ops.log`. Bagian backup tertulis "Belum ada arsip backup"
    karena backup bukan bagian tugas saya.

### D. Docker Read-Only

Membaca laporan melalui container Docker (image `alpine:3.20`) dengan
mount read-only, lalu memverifikasi integritas laporan dengan
`sha256sum`. Versi Docker: 29.1.3.

-   Perintah yang digunakan:
    -   `sudo docker pull alpine:3.20`
    -   `sha256sum output/laporan.txt > evidence/laporan.sha256.before`
    -   `sudo docker run --rm --mount type=bind,src="$(pwd)/output",dst=/data,readonly alpine:3.20 cat /data/laporan.txt`
    -   `sudo docker run --rm --mount type=bind,src="$(pwd)/output",dst=/data,readonly alpine:3.20 sh -c 'echo "uji perubahan" >> /data/laporan.txt'`
    -   `sha256sum -c evidence/laporan.sha256.before`
-   Hasil baca laporan: isi `laporan.txt` berhasil ditampilkan dari
    dalam container.
-   Hasil percobaan tulis: ditolak dengan pesan
    `sh: can't create /data/laporan.txt: Read-only file system`.
-   Hasil verifikasi sha256sum: `output/laporan.txt: OK` (isi laporan
    tidak berubah).

## 4. Skenario Pengujian

| Jenis Pengujian | Skenario | Hasil Aktual |
|---|---|---|
| Positif (+) | Layanan aktif terdeteksi, aktivitas pada log tercatat, dan Docker berhasil membaca laporan. | Berhasil. `fs-check.sh` menampilkan `OK smbd aktif`, log uji akses tercatat 3 baris, dan Docker berhasil membaca `laporan.txt` dari mount read-only. |
| Negatif (-) | Layanan yang berhenti terdeteksi dan penulisan laporan melalui Docker read-only ditolak. | Terdeteksi dan ditolak. Setelah `smbd` dihentikan, `fs-check.sh` menampilkan `ERROR smbd tidak aktif`. Penulisan lewat Docker read-only ditolak dengan pesan `Read-only file system` dan `sha256sum -c` tetap `OK`. |

## 5. Bukti Pekerjaan

Seluruh screenshot berada di folder `evidence/` pada repository fork
pribadi saya.

1.  Screenshot `fs-check.sh` (hidup, mati, hidup lagi):
    `evidence/dimas_1_fs-check.png`
2.  Screenshot isi log `access-tests.log`:
    `evidence/dimas_2_log.png`
3.  Screenshot isi `output/laporan.txt`:
    `evidence/dimas_3_laporan.png`
4.  Screenshot Docker aktif dan `docker pull alpine:3.20`:
    `evidence/dimas_4_docker.png`
5.  Screenshot Docker membaca laporan dan penulisan ditolak (read-only):
    `evidence/dimas_5_docker-readonly.png`
6.  Screenshot hasil `sha256sum -c` (OK):
    `evidence/dimas_6_sha256.png`

## 6. Informasi GitHub

| Keterangan | Isi |
|---|---|
| Repository kelompok | https://github.com/kel2-so/fileserver-6a |
| Repository fork pribadi | https://github.com/dimasdwsrya/fileserver-6a |
| Commit hash pekerjaan | `[ISI HASH COMMIT TERBARU]` |
| Pesan commit | `Bukti Anggota 7: monitoring, log, laporan, Docker` |
| Status PORTOFOLIO.md | Sudah dibuat |

## 7. Kendala dan Penyelesaian

**Kendala yang ditemukan:**\
1. Perintah `sg` tidak tersedia di VM sehingga laporan pertama tidak
dapat membaca log (bagian hasil uji akses dan `ops.log` kosong).\
2. Pada uji penghapusan file oleh `rd1`, `rm` biasa menampilkan
pertanyaan konfirmasi sehingga hasilnya belum menunjukkan penolakan
yang jelas, dan kode keluar yang dicatat di log awalnya tidak sesuai
dengan hasil sebenarnya.\
3. Saat pembuatan kata sandi akun uji, muncul peringatan
`BAD PASSWORD` karena kata sandi dianggap terlalu sederhana.

**Langkah penyelesaian:**\
1. Laporan dibuat ulang menggunakan `sudo bash scripts/report.sh`
sehingga log dapat terbaca.\
2. Log awal dihapus, lalu uji diulang menggunakan `rm -f` dan kode
keluar dicatat sesuai hasil sebenarnya (`exit=1` untuk `rd1`, `exit=2`
untuk `tamu1`).\
3. Peringatan diabaikan karena akun hanya digunakan untuk pengujian;
kata sandi tetap berhasil diperbarui.

## 8. Kesimpulan

Melalui bagian Monitoring, Log, Laporan, dan Docker, saya mempelajari
cara memantau layanan Samba, mencatat hasil uji akses beserta kode
keluarnya, membuat laporan hasil pengujian, serta membaca laporan
melalui container Docker read-only. Pengujian menunjukkan bahwa
layanan yang berhenti dapat terdeteksi, dan bahwa container dengan
mount read-only dapat membaca laporan tetapi tidak dapat mengubahnya,
dibuktikan dengan pesan `Read-only file system` dan hasil `sha256sum`
yang tetap `OK`.

------------------------------------------------------------------------

**Nama:** Dimas Dwi Surya\
**NIM:** 2510512196\
**Tanggal pembaruan:** 14 November 2026
