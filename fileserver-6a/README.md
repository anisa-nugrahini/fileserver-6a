# Proyek 6A – Server Berkas Bersama dengan Backup dan Audit Akses

Proyek Akhir Sistem Operasi & Praktikum SO – S1 Sistem Informasi UPN Veteran Jakarta, Semester Ganjil 2026/2027.
Dikerjakan **berkelompok** (7 anggota; lihat `docs/pembagian_tugas.md`). Semua data adalah data dummy.

## Lingkungan (isi sesuai VM aktual)
Ubuntu Server ___ (VM: ___ vCPU, ___ MB RAM) · Samba ___ · OpenSSH ___ · Docker ___ · image `alpine:3.20` (ubah `DOCKER_IMAGE` bila berbeda)

## Instalasi
```bash
sudo apt update && sudo apt install -y samba smbclient openssh-server acl time
git clone <URL repository utama> && cd fileserver-6a
sudo scripts/setup.sh --install-configs   # user, group, share+ACL, Samba, SSH drop-in, sudoers
sudo smbpasswd -a sfop1; sudo smbpasswd -a sfread1; sudo smbpasswd -a sfout1   # password diketik interaktif
```
> **SSH:** `AllowGroups` dapat mengunci Anda keluar. Pertahankan satu sesi SSH terbuka dan pastikan akun admin VM ada di grup `sudo`/`sf_admin`.

## Menjalankan
| Tujuan | Perintah |
|---|---|
| Backup | `sudo scripts/backup.sh` → arsip + `.sha256` di `/var/backups/fileserver` |
| Restore (ke direktori uji) | `sudo scripts/restore.sh <arsip> /tmp/fileserver-restore /srv/fileserver/share` |
| Cek layanan | `scripts/check_services.sh` (exit 7 bila ada yang mati) |
| Snapshot CPU/memori | `scripts/monitor.sh <label>` |
| Laporan | `scripts/gen_report.sh` → `output/laporan.txt` |
| Docker (positif / negatif) | `docker pull alpine:3.20` sebelum presentasi, lalu `scripts/docker_report.sh positive` / `negative` |

Exit status: 0 ok · 2 parameter · 3 tidak ditemukan · 4 tidak dapat ditulis · 5 integritas gagal · 6 lock sibuk · 7 layanan mati · 8 butuh root.

## Pengujian
```bash
export SF_PASS_OP='...' SF_PASS_OUT='...'   # hanya untuk uji Samba; jangan di-commit
sudo -E tests/run_all.sh
```
Hasil: `output/hasil_uji_akses.log` (bukti akses), `output/monitor.log` (CPU/memori), `logs/fileserver.log` (log operasional).
**SKIP bukan lulus**: berarti lingkungan belum mendukung uji itu; selesaikan sebelum pengumpulan.
Menguji `T6-N1` (layanan berhenti) akan menghentikan `smbd` sebentar lalu menyalakannya lagi.

## Pembersihan / pemulihan kondisi
`scripts/cleanup.sh` (artefak uji) · `sudo scripts/cleanup.sh --purge` (hapus user/group/share/backup; blok `[shared]` di smb.conf dihapus manual, cadangan `smb.conf.bak.*`).

## Struktur
`scripts/` shell script · `config/` konfigurasi contoh tanpa rahasia · `tests/` uji positif/negatif · `docs/` laporan · `evidence/` bukti terpilih (bersihkan data sensitif)
