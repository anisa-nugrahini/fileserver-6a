# PORTOFOLIO KONTRIBUSI PROYEK SISTEM OPERASI

**Topik:** Server Berkas Bersama (Samba) & Audit Akses

## 1. Identitas Mahasiswa

| Keterangan | Isi |
|---|---|
| Nama | Anisa Nugrahini |
| NIM | 2510512182 |
| Kelas / Kelompok | E / Kelompok 2 |
| Mata Kuliah | Sistem Operasi |
| Tanggung Jawab | Backup dan Restore |
| Repository Kelompok | [fileserver-6a](https://github.com/kel2-so/fileserver-6a) |

## 2. Deskripsi Tanggung Jawab

Saya bertanggung jawab pada bagian **Backup dan Restore** dalam proyek Server Berkas Bersama. Fokus pekerjaan saya adalah membuat salinan cadangan data (backup) pada Ubuntu Server, melakukan pemeriksaan integritas file menggunakan checksum SHA-256, serta melakukan pemulihan data (restore) apabila terjadi kehilangan atau kerusakan data.

Selain itu, saya juga melakukan pengujian terhadap file backup yang rusak untuk memastikan sistem dapat mendeteksi ketidaksesuaian checksum dan mencegah pemulihan data dari arsip yang tidak valid.

## 3. Rincian Pekerjaan

### A. Persiapan Backup dan Restore

Memastikan script backup dan restore sudah tersedia pada Ubuntu Server sebelum proses pencadangan dan pemulihan dilakukan.

**Perintah yang digunakan:**

```bash
ls -l /usr/local/sbin/fs-backup.sh
ls -l /usr/local/sbin/fs-restore.sh
```

**Lokasi script:**
- `/usr/local/sbin/fs-backup.sh`
- `/usr/local/sbin/fs-restore.sh`

**Tanggal pengerjaan:** 15 November 2026

### B. Pembuatan Backup

Melakukan pencadangan data dari direktori shared folder agar file memiliki salinan cadangan yang dapat digunakan apabila terjadi kehilangan atau kerusakan data.

- Lokasi data asli: `/srv/fileserver/share/`
- Perintah yang digunakan:

```bash
sudo /usr/local/sbin/fs-backup.sh
```

- Lokasi penyimpanan backup: `/srv/fileserver/backup/`
- Hasil yang diharapkan: Terbentuk file arsip backup dengan format `.tar.gz` dan file checksum `.sha256`.

### C. Pemeriksaan Integritas Backup

Melakukan pemeriksaan terhadap file backup menggunakan SHA-256 untuk memastikan file cadangan tidak mengalami perubahan atau kerusakan.

**Perintah yang digunakan:**

```bash
cd /srv/fileserver/backup
sudo sha256sum -c NAMA_FILE.tar.gz.sha256
```

**Hasil yang diharapkan:**

```text
NAMA_FILE.tar.gz: OK
```

**Keterangan:** Status OK menunjukkan bahwa checksum file backup sesuai dengan nilai hash yang tersimpan.

### D. Proses Restore (Pemulihan Data)

Melakukan pemulihan data dari file backup yang telah dibuat sebelumnya.

**Perintah yang digunakan:**

```bash
sudo /usr/local/sbin/fs-restore.sh NAMA_FILE.tar.gz
```

- Lokasi penyimpanan hasil restore: `/srv/fileserver/restore-test/`
- Hasil yang diharapkan: File yang sebelumnya dicadangkan berhasil dikembalikan ke direktori pemulihan.

### E. Pengujian Hasil Restore

Melakukan perbandingan antara direktori data asli dengan direktori hasil pemulihan untuk memastikan bahwa isi file tetap sama.

**Perintah yang digunakan:**

```bash
sudo diff -r /srv/fileserver/share /srv/fileserver/restore-test/NAMA_FOLDER
```

**Hasil yang diharapkan:** Tidak terdapat output dari perintah diff, yang menunjukkan tidak ditemukan perbedaan isi antara kedua direktori.

### F. Pengujian Backup Rusak

Melakukan pengujian terhadap file backup yang telah dimodifikasi untuk membuktikan bahwa sistem dapat mendeteksi file cadangan yang rusak melalui pemeriksaan checksum.

**Langkah pengujian:**

1. Membuat salinan file backup:

```bash
sudo cp NAMA_FILE.tar.gz backup_rusak.tar.gz
```

2. Mengubah nama file pada checksum:

```bash
sudo sed 's/NAMA_FILE.tar.gz/backup_rusak.tar.gz/' NAMA_FILE.tar.gz.sha256 | sudo tee backup_rusak.tar.gz.sha256
```

3. Merusak file salinan:

```bash
sudo truncate -s 100 backup_rusak.tar.gz
```

4. Menguji restore:

```bash
sudo /usr/local/sbin/fs-restore.sh backup_rusak.tar.gz
```

**Hasil yang diharapkan:** Proses restore ditolak karena verifikasi checksum gagal.

### G. Pemeriksaan Log Backup dan Restore

Memeriksa catatan aktivitas backup dan restore untuk memastikan proses yang dilakukan tercatat pada sistem.

**Perintah yang digunakan:**

```bash
sudo cat /srv/fileserver/logs/ops.log
```

- Lokasi file log: `/srv/fileserver/logs/ops.log`
- Informasi yang diperiksa: Catatan proses backup, restore, dan kegagalan verifikasi checksum.

## 4. Skenario Pengujian

| Jenis Pengujian | Skenario | Hasil Aktual |
|---|---|---|
| Positif (+) | Melakukan backup data dari shared folder menggunakan script fs-backup.sh. | Backup berhasil dibuat dengan nama `backup_20261106_201541.tar.gz`. |
| Positif (+) | Memeriksa checksum file backup menggunakan SHA-256. | Pemeriksaan berhasil dengan hasil `backup_20261106_201541.tar.gz: OK`. |
| Positif (+) | Melakukan restore dari file backup yang valid. | Restore berhasil dilakukan ke direktori `/srv/fileserver/restore-test/backup_20261106_201541/`. |
| Positif (+) | Membandingkan data asli dan hasil restore menggunakan perintah diff. | Perintah diff tidak menghasilkan output pada percobaan dengan direktori yang benar, sehingga tidak ditemukan perbedaan isi file. |
| Negatif (-) | Melakukan restore terhadap file backup yang sudah dimodifikasi atau rusak. | Sistem mendeteksi kegagalan verifikasi checksum dan menolak proses restore dengan pesan `Verifikasi checksum GAGAL untuk backup_rusak.tar.gz; restore dibatalkan.` |
| Positif (+) | Memeriksa catatan aktivitas backup dan restore pada file log. | Aktivitas backup berhasil, restore berhasil, dan kegagalan verifikasi checksum tercatat pada file ops.log. |

## 5. Bukti Pekerjaan

Seluruh screenshot berikut merupakan bukti pelaksanaan pekerjaan Backup dan Restore pada Ubuntu Server.

**1. Screenshot pemeriksaan script backup dan restore**

![Pemeriksaan Script Backup dan Restore](evidence/01-pemeriksaan-script.png)

**2. Screenshot proses pembuatan backup**

![Proses Backup](evidence/02-proses-backup.png)

**3. Screenshot isi direktori backup yang menunjukkan file .tar.gz dan .sha256**

![File Backup](evidence/03-file-backup.png)

**4. Screenshot pemeriksaan checksum yang menunjukkan hasil verifikasi**

![Verifikasi Checksum](evidence/04-checksum.png)

**5. Screenshot proses restore**

![Proses Restore](evidence/05-proses-restore.png)

**6. Screenshot direktori hasil restore**

![Hasil Restore](evidence/06-hasil-restore.png)

**7. Screenshot perbandingan data menggunakan perintah diff**

![Perbandingan Data Diff](evidence/07-diff.png)

**8. Screenshot pengujian backup rusak yang menunjukkan kegagalan verifikasi checksum**

![Pengujian Backup Rusak](evidence/08-backup-rusak.png)

**9. Screenshot isi file log backup dan restore**

![Log Backup dan Restore](evidence/09-log-backup-restore.png)

## 6. Informasi GitHub

| Keterangan | Isi |
|---|---|
| Repository kelompok | [https://github.com/kel2-so/fileserver-6a](https://github.com/kel2-so/fileserver-6a) |
| Repository fork pribadi | [https://github.com/anisa-nugrahini/fileserver-6a](https://github.com/anisa-nugrahini/fileserver-6a) |
| Commit hash pekerjaan | Belum diisi |
| Pesan commit | Implementasi Backup dan Restore |
| Status PORTOFOLIO.md | Dalam proses penyusunan |

## 7. Kendala dan Penyelesaian

**Kendala yang ditemukan:**

Saat melakukan pemeriksaan integritas file backup, saya mengalami kendala `Permission denied` ketika mencoba mengakses direktori `/srv/fileserver/backup/` menggunakan user biasa. Hal ini terjadi karena direktori backup memiliki hak akses terbatas, dengan kepemilikan root dan grup sf_admin, sehingga user biasa tidak memiliki izin untuk mengakses direktori tersebut.

**Langkah penyelesaian:**

Untuk mengatasi kendala tersebut, saya melakukan beberapa langkah berikut:

1. Memeriksa kembali akses direktori backup dan mengetahui bahwa direktori tersebut memiliki hak akses terbatas.
2. Menggunakan perintah `sudo -i` untuk masuk ke shell administrator (root).
3. Setelah berhasil masuk sebagai root, mengakses direktori backup menggunakan perintah:

```bash
cd /srv/fileserver/backup
```

4. Menjalankan pemeriksaan integritas file backup menggunakan perintah:

```bash
sha256sum -c backup_20261106_201541.tar.gz.sha256
```

5. Memastikan hasil pemeriksaan checksum menunjukkan status OK.

**Hasil pemeriksaan:**

```text
backup_20261106_201541.tar.gz: OK
```

Dengan langkah tersebut, kendala akses berhasil diatasi menggunakan hak akses administrator tanpa perlu mengubah permission direktori. File backup juga berhasil melewati pemeriksaan integritas SHA-256.

## 8. Kesimpulan

Melalui bagian pekerjaan Backup dan Restore, saya mempelajari proses pencadangan data pada Ubuntu Server, pemeriksaan integritas file menggunakan checksum SHA-256, serta pemulihan data dari arsip backup yang telah dibuat.

Selain itu, saya juga melakukan pengujian terhadap file backup yang rusak untuk memastikan sistem mampu mendeteksi ketidaksesuaian checksum sebelum proses pemulihan dilakukan.

Dengan adanya mekanisme backup dan restore, data pada Server Berkas Bersama dapat memiliki salinan cadangan sehingga proses pemulihan dapat dilakukan apabila terjadi kehilangan atau kerusakan data.

---

**Nama:** Anisa Nugrahini  
**NIM:** 2510512182  
**Tanggal pembaruan:** 15 November 2026
