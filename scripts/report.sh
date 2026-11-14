#!/usr/bin/env bash
# Menulis output/laporan.txt: status layanan, backup terakhir, hasil uji akses, log terakhir.
ROOT="${FS_ROOT:-/srv/fileserver}"; SVC="${FS_SERVICE:-smbd}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"; OUT="${FS_OUTPUT:-$HERE/output}"
mkdir -p "$OUT"
{
  echo "LAPORAN SERVER BERKAS 6A"
  echo "Dibuat : $(date '+%F %T')"
  echo
  echo "== Layanan $SVC =="
  if command -v systemctl >/dev/null && systemctl is-active --quiet "$SVC"; then
    echo "Status : aktif (PID $(systemctl show -p MainPID --value "$SVC"))"
  else
    echo "Status : TIDAK AKTIF atau tidak dapat diperiksa"
  fi
  echo
  echo "== Backup terakhir =="
  last="$(ls -1t "$ROOT"/backup/backup_*.tar.gz 2>/dev/null | head -n1)"
  if [ -n "$last" ]; then
    n="$(basename "$last")"
    echo "Arsip  : $n"
    echo "Waktu  : $(stat -c %y "$last" | cut -d. -f1)"
    echo "Ukuran : $(stat -c %s "$last") byte"
    if ( cd "$ROOT/backup" && sha256sum -c --quiet "$n.sha256" ) >/dev/null 2>&1; then
      echo "Verifikasi checksum : OK"
    else
      echo "Verifikasi checksum : GAGAL atau berkas checksum tidak ada"
    fi
  else
    echo "Belum ada arsip backup."
  fi
  echo
  echo "== Hasil uji akses =="
  if [ -r "$ROOT/logs/access-tests.log" ]; then tail -n 20 "$ROOT/logs/access-tests.log"; else echo "(belum ada atau tidak dapat dibaca)"; fi
  echo
  echo "== 5 baris terakhir ops.log =="
  tail -n 5 "$ROOT/logs/ops.log" 2>/dev/null || echo "(tidak dapat dibaca)"
} > "$OUT/laporan.txt"
echo "Laporan ditulis: $OUT/laporan.txt"
