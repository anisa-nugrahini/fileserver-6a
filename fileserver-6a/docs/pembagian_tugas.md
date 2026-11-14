# Pembagian tugas (7 anggota) dan skenario demonstrasi

> **Catatan:** panduan resmi hanya mengatur kelompok 5 atau 6 anggota. Untuk 7 anggota, konfirmasi ke dosen sebelum H-21
> (jumlah anggota, pembagian peran, dan alokasi waktu demonstrasi ≈ 4 menit × 7 = 28 menit — ini perkiraan, bukan ketentuan resmi).
> Anggota 1–6 mengikuti tabel panduan 6A; anggota 7 adalah tambahan usulan.

| # | Nama/NIM | Tanggung jawab | Positif | Negatif | Kode / uji |
|---|---|---|---|---|---|
| 1 | | User, group, permission | Operator dapat menulis | Di luar grup ditolak | `setup.sh`, `t1_permission.sh` |
| 2 | | Samba dan klien | Akun berwenang akses share | Akun tidak berwenang ditolak | `config/smb_share.conf`, `t2_samba.sh` |
| 3 | | Hak pembaca | Pembaca dapat membaca | Ubah/hapus ditolak | ACL di `setup.sh`, `t3_reader.sh` |
| 4 | | Administrasi SSH | Admin periksa via SSH | Akun biasa ditolak tindakan admin | `sshd_fileserver.conf`, `sudoers_sfadmin.example`, `t4_ssh_admin.sh` |
| 5 | | Backup dan restore | Dipulihkan, isi sesuai | Backup rusak tidak dinyatakan berhasil | `backup.sh`, `restore.sh`, `t5_backup_restore.sh` |
| 6 | | Monitoring layanan, log, laporan | Laporan layanan+backup terbentuk; CPU/memori terukur | Layanan berhenti terdeteksi; verifikasi setelah pemulihan | `check_services.sh`, `monitor.sh`, `gen_report.sh`, `t6_monitor_report.sh` |
| 7 | | Docker + kompilasi bukti uji akses + reproduksi (README, cleanup, run_all) | Container membaca laporan | Tulis via mount read-only ditolak, checksum host sama | `docker_report.sh`, `t7_docker.sh`, `run_all.sh`, `cleanup.sh` |

Setiap anggota juga menulis bagian analisis konsep SO miliknya di laporan dan memiliki commit atas namanya sendiri (lihat matriks kontribusi di laporan).
Analisis akses (audit) dibatasi pada bukti uji akses dan log operasional, sesuai panduan.
