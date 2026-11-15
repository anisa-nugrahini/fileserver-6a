# PORTOFOLIO KONTRIBUSI PROYEK SISTEM OPERASI

**Topik:** Server Berkas Bersama (Samba) & Audit Akses

## 1. Identitas Mahasiswa

  Keterangan            Isi
  --------------------- ------------------------------------------
  Nama                  Zahara Marchela
  NIM                   2510512200
  Kelas / Kelompok      E / Kelompok 02
  Mata Kuliah           Sistem Operasi
  Tanggung Jawab        Samba Server
  Repository Kelompok   https://github.com/kel2-so/fileserver-6a

## 2. Deskripsi Tanggung Jawab

Saya bertanggung jawab pada bagian **Samba Server** dalam proyek Server
Berkas Bersama. Fokus pekerjaan saya adalah melakukan instalasi dan
konfigurasi layanan Samba pada Ubuntu, membuat shared folder agar dapat
diakses melalui jaringan, serta mengatur hak akses Samba sesuai
kebutuhan pengguna.

## 3. Rincian Pekerjaan

### A. Instalasi Samba

Melakukan instalasi paket Samba pada Ubuntu.

-   Perintah yang digunakan: `sudo apt install samba`
    (verifikasi versi dengan `smbd --version`, hasil:
    Samba 4.23.6-Ubuntu-4.23.6+dfsg-1ubuntu2.2)
-   Tanggal pengerjaan: 6 November 2026

### B. Konfigurasi Samba

Mengatur konfigurasi layanan melalui file `smb.conf`, termasuk nama
share, lokasi direktori, dan aturan akses.

-   Konfigurasi yang dibuat: konfigurasi diterapkan melalui skrip
    `scripts/setup_services.sh` (dijalankan dengan `sudo`). Bagian
    `[global]` menggunakan `server role = standalone server`,
    `map to guest = Bad User`, `log file = /var/log/samba/log.%m`,
    dan `max log size = 1000`. Share yang dibuat bernama `[berkas]`
    dengan `create mask = 0660`, `directory mask = 02770`,
    `path = /srv/fileserver/share`, `valid users = @sf_operator @sf_reader`,
    `read list = @sf_reader`, dan `write list = @sf_operator`.
-   Lokasi file konfigurasi: `/etc/samba/smb.conf`

### C. Pembuatan Shared Folder

Membuat direktori yang akan dibagikan melalui Samba.

-   Nama shared folder: `berkas`
-   Lokasi/path folder: `/srv/fileserver/share`

### D. Pengaturan Hak Akses Samba

Mengatur izin akses agar pengguna yang berwenang dapat mengakses folder
sesuai perannya.

-   User/grup yang digunakan: grup `@sf_operator` dan `@sf_reader`
    pada share; user Samba `op1`, `op2`, `rd1`, `rd2` didaftarkan dengan
    `sudo smbpasswd -a <user>`; grup `sf_admin` untuk administrator
    (user yang menjalankan skrip ditambahkan dengan
    `sudo usermod -aG sf_admin <user>`).
-   Hak akses yang diberikan: `@sf_operator` mendapat baca-tulis
    (`write list`), `@sf_reader` hanya baca (`read list`). Akses hanya
    untuk anggota kedua grup tersebut (`valid users`). File baru dibuat
    dengan mode 0660 dan direktori baru dengan 02770 (setgid).

### E. Pengujian Konfigurasi

Memeriksa konfigurasi Samba menggunakan `testparm` dan menguji akses
folder bersama dari klien.

-   Perintah pengujian: `sudo testparm -s`,
    `sudo systemctl status smbd`, `sudo ufw status`, `hostname -I`
-   Hasil pengujian: `testparm` menampilkan "Loaded services file OK"
    dan "testparm OK" dengan server role `ROLE_STANDALONE`. Layanan
    `smbd` berstatus **active (running)** dan *enabled*, dengan pesan
    "smbd: ready to serve connections...". Firewall UFW berstatus
    inactive. IP server: 192.168.1.48. Terdapat peringatan bahwa
    `netbios name` terlalu panjang (maks. 15 karakter).

## 4. Skenario Pengujian

  ---------------------------------------------------------------------------------------------------------
  Jenis Pengujian         Skenario                Hasil Aktual
  ----------------------- ----------------------- ---------------------------------------------------------
  Positif (+)             Layanan Samba berjalan  **Berhasil.** `systemctl status smbd` menunjukkan active
                          dan konfigurasi folder  (running) sejak 6 Nov 2026 13:40:43 WIB, dan `testparm`
                          sharing dinyatakan      menampilkan "Loaded services file OK" serta "testparm OK".
                          valid.                  

  Negatif (-)             Konfigurasi Samba yang  `[Belum ada bukti: isi setelah menguji, misalnya dengan
                          tidak valid dapat       sengaja membuat kesalahan di smb.conf lalu menjalankan
                          dideteksi melalui       testparm. Tulis Terdeteksi/Tidak terdeteksi + bukti]`
                          pemeriksaan `testparm`. 
  ---------------------------------------------------------------------------------------------------------

## 5. Bukti Pekerjaan

1.  Screenshot instalasi Samba pada Ubuntu (versi Samba via
    `smbd --version` dan pendaftaran user Samba):
    ![Instalasi dan user Samba] https://drive.google.com/drive/folders/1v09apRmm4hGrjSph5NsRLGTmDqA2mhIe?usp=drive_link 
2.  Screenshot konfigurasi `smb.conf` (hasil `testparm -s`, bagian
    `[global]`): ![testparm bagian global] https://drive.google.com/drive/folders/1v09apRmm4hGrjSph5NsRLGTmDqA2mhIe?usp=drive_link
3.  Screenshot pembuatan shared folder dan lokasi direktori (share
    `[berkas]`, path `/srv/fileserver/share`):
    ![Share berkas] https://drive.google.com/drive/folders/1v09apRmm4hGrjSph5NsRLGTmDqA2mhIe?usp=drive_link
4.  Screenshot pengaturan hak akses Samba (`valid users`, `read list`,
    `write list`, `smbpasswd -a` dan
    `usermod -aG sf_admin`).
5.  Screenshot hasil pemeriksaan `testparm` 

## 6. Informasi GitHub

  -------------------------------------------------------------------------------------------------------------
  Keterangan                          Isi
  ----------------------------------- -------------------------------------------------------------------------
  Repository kelompok                 https://github.com/kel2-so/fileserver-6a

  Repository fork pribadi             https://github.com/zhcheel/fileserver-6a 

  Commit hash pekerjaan               77718d250e9675121996d3f39b63499ad9449fab 

  Pesan commit                        `Instalasi dan konfigurasi Samba Server`

  Status PORTOFOLIO.md                Sudah dibuat
  -------------------------------------------------------------------------------------------------------------

## 7. Kendala dan Penyelesaian

**Kendala yang ditemukan:**\
1. Perintah `samba --version` tidak ditemukan (paket yang menyediakan
perintah tersebut adalah `samba-ad-dc`).\
2. `sudo usermod -aG sf_admin ubuntu` gagal karena user `ubuntu` tidak
ada.\
3. Skrip `setup_services.sh` menolak lanjut karena user belum menjadi
anggota `sf_admin`/`sf_operator`.\
4. `testparm` memberi peringatan bahwa `netbios name` terlalu panjang
(maks. 15 karakter).

**Langkah penyelesaian:**\
1. Versi Samba dicek dengan `smbd --version`, yang berhasil
menampilkan versi 4.23.6.\
2. Memakai user yang sedang login (dicek dengan `whoami`) sebagai
pengganti `ubuntu`.\
3. Menjalankan `sudo usermod -aG sf_admin <user>` lalu menjalankan ulang
`sudo scripts/setup_services.sh`, yang kemudian berhasil
(`testparm OK`, sudoers parsed OK, SSH dimuat ulang).\
4. Peringatan `netbios name` tidak menghentikan layanan (`testparm`
tetap OK dan `smbd` berjalan); `[Opsional: tulis jika nama sudah
dipersingkat]`.

## 8. Kesimpulan

Melalui bagian pekerjaan Samba Server, saya mempelajari proses instalasi
dan konfigurasi layanan Samba, pembuatan folder bersama, serta
pengaturan hak akses agar folder dapat digunakan oleh pengguna sesuai
izin yang ditetapkan. Share `berkas` pada `/srv/fileserver/share`
berhasil dikonfigurasi dengan pemisahan peran operator (baca-tulis) dan
reader (baca saja), dan layanan `smbd` berjalan serta lolos
pemeriksaan `testparm`. Pengujian negatif dan akses dari klien masih
perlu dilengkapi dengan bukti.

------------------------------------------------------------------------

**Nama:** Zahara Marchela\
**NIM:** 2510512200\
**Tanggal pembaruan:** 15 November 2026
