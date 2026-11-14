#!/usr/bin/env bash
# Mengembalikan kondisi uji: hapus hasil restore, salinan arsip rusak, berkas uji pada share.
# Tidak menghapus arsip backup asli. Gunakan --all untuk menghapus semua arsip dan log.
ROOT="${FS_ROOT:-/srv/fileserver}"
[ "$(id -u)" -eq 0 ] || { echo "Jalankan dengan sudo" >&2; exit 1; }
rm -rf "${ROOT:?}/restore-test/"* 
rm -f "$ROOT"/backup/*_rusak.tar.gz "$ROOT"/backup/*_rusak.tar.gz.sha256
rm -f "$ROOT"/share/t1.txt "$ROOT"/share/t2.txt "$ROOT"/share/baru.txt "$ROOT"/share/x.txt
if [ "${1:-}" = "--all" ]; then rm -f "$ROOT"/backup/* "$ROOT"/logs/*; fi
echo "Pembersihan selesai."
