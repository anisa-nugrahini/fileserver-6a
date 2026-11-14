# Draf Laporan Akhir – Proyek 6A (isi bagian bertanda ▢ dengan data/hasil nyata dari VM)

## 1. Identitas
Judul: Server Berkas Bersama dengan Backup dan Audit Akses · Pilihan 6A · Anggota & NIM: ▢ · Versi: ▢ · Repository: ▢

## 2. Pendahuluan
**Masalah:** unit kerja butuh berkas bersama dengan hak berbeda (operator baca-tulis, pembaca hanya-baca) dan jaminan data dapat dipulihkan.
**Tujuan & indikator yang dapat diuji:** (1) operator menulis, pembaca tidak dapat mengubah/menghapus, non-anggota ditolak; (2) akses Samba selaras dengan permission Linux; (3) admin SSH dibatasi; (4) backup bercheck-sum dapat dipulihkan dan arsip rusak ditolak; (5) layanan berhenti terdeteksi; (6) laporan terbaca dari container read-only.
**Ruang lingkup:** satu server Linux (VM), data dummy; audit = bukti uji akses + log operasional, bukan sistem audit kompleks.

## 3. Kebutuhan dan rancangan
Spesifikasi aktual: ▢. Diagram komponen: klien → Samba (smbd, port 445) → direktori `/srv/fileserver/share` (permission+ACL) ← backup/restore; admin → SSH (22) → sudo terbatas; laporan → `output/laporan.txt` → container (read-only).

**Matriks akses**
| Subjek | Baca | Tulis | Hapus | Tindakan admin |
|---|---|---|---|---|
| sf_operator | ya | ya | ya | tidak |
| sf_reader | ya | tidak | tidak | tidak |
| di luar grup | tidak | tidak | tidak | tidak |
| sf_admin | via sudo terbatas | – | – | hanya perintah di sudoers |

Alasan rancangan: direktori `root:sf_operator` mode `2770` (setgid agar berkas baru mewarisi grup), ACL `g:sf_reader:r-x` untuk pembaca, `o::---` untuk lainnya; Samba memakai `valid users` + `write list` sehingga dua lapis (Samba dan Linux) harus sama-sama mengizinkan.

## 4. Analisis konsep sistem operasi (tiap anggota menulis bagiannya; bukti = perintah, keluaran, exit status)
- **Autentikasi vs otorisasi (A2, A4):** autentikasi = Samba/SSH memverifikasi identitas (password/kunci); otorisasi = `valid users`/`write list`, permission, ACL, sudoers. Bukti: T2-N1 (bukan valid user) berbeda dari T2-N2 (password salah). ▢
- **Proteksi berkas (A1, A3):** model owner/group/other + ACL, setgid, mask efektif ACL membuat pembaca efektif `r--` pada berkas `660`. Bukti: `getfacl`, T1-*, T3-*. ▢
- **Proses layanan (A4, A6):** `smbd`/`sshd` adalah daemon (PID, status systemd, siklus hidup start/stop). Bukti: `systemctl status`, `ps`, T6-N1. ▢
- **Sinkronisasi / critical section (A5):** backup memakai `flock -n` pada satu lock file; tanpa lock dua `tar` dapat menulis/menghitung checksum berbarengan (race). Bukti: T5-N3 (exit 6). ▢
- **Deadlock (A5):** hanya satu lock dan non-blocking (tidak menunggu) sehingga tidak ada *hold-and-wait*/menunggu melingkar; ini analisis desain, **bukan** fitur deteksi deadlock. ▢
- **Sistem berkas & I/O (A5):** alur baca (tar membaca share) → kompresi → tulis arsip → hitung checksum; integritas via SHA-256 diverifikasi sebelum ekstraksi. Bukti: T5-P1, T5-N1. ▢
- **CPU & memori (A6):** dua ukuran beban aman (5 MB vs 50 MB) pada `monitor.log` (waktu, puncak memori, CPU). Jelaskan perbedaan tanpa klaim berlebihan; sertakan kondisi VM. ▢
- **Penjadwalan:** tidak ada antrean aplikasi di 6A; penjadwalan CPU sepenuhnya oleh kernel — nyatakan sebagai konsep yang hanya dianalisis. ▢
- **Docker (A7):** image = templat read-only, container = instance berjalan; bind mount memetakan `output/` host → `/data`; `readonly` membuat tulis ditolak; `--rm` menghapus container setelah selesai. Bukti membatasi mount tersebut, bukan seluruh keamanan container.

## 5. Implementasi
Komponen dan cara menjalankan: lihat README. Konfigurasi penting: `config/smb_share.conf`, `config/sshd_fileserver.conf`, `config/sudoers_sfadmin.example`. Subbagian Docker: perintah positif/negatif, exit status, checksum sebelum/sesudah. ▢

## 6. Pengujian dan pembahasan
Gunakan format tiap kasus: ID · PIC · tujuan · prasyarat · langkah · hasil diharapkan · hasil aktual · lulus/gagal · bukti (exit status/log/checksum) · pemulihan · pembahasan SO. Sumber: `output/hasil_uji_akses.log`. Wajib tampil: deteksi layanan berhenti (T6-N1) & verifikasi setelah pemulihan (T6-V2), dua backup bersamaan (T5-N3), backup rusak (T5-N1). Hasil SKIP **tidak** boleh dilaporkan sebagai lulus. ▢

## 7. Evaluasi dan keterbatasan
Contoh yang perlu diperiksa jujur: sinkronisasi ACL/mask Samba pada berkas yang dibuat klien Windows; password uji; backup berada pada host yang sama (bukan off-site); tidak ada enkripsi arsip; `AllowGroups` berisiko mengunci akses. ▢

## 8. Kesimpulan · 9. Referensi dan lampiran
Jawab tiap tujuan berdasarkan bukti. Referensi: dokumentasi Samba (smb.conf), `man 5 acl`, `man 1 flock`, dokumentasi Docker bind mount, RPS ▢. Lampiran: matriks kontribusi (nama/NIM, komponen, analisis, ID skenario, tautan commit/PR).
