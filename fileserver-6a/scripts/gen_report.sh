#!/usr/bin/env bash
# Menghasilkan $OUT_DIR/laporan.txt (laporan layanan dan backup) -> dibaca container Docker.
source "$(dirname "$0")/lib/common.sh"
mkdir -p "$OUT_DIR"; rep="$OUT_DIR/laporan.txt"
{
  echo "LAPORAN SERVER BERKAS BERSAMA - $(date '+%F %T')"
  echo "Host: $(hostname) | OS: $(. /etc/os-release; echo "$PRETTY_NAME") | Kernel: $(uname -r)"
  echo; echo "## Status layanan"
  "$(dirname "$0")/check_services.sh" 2>/dev/null || echo "(ada layanan tidak aktif; lihat di atas)"
  echo; echo "## Share"
  if [ -d "$SHARE_DIR" ]; then
    stat -c '%n %U:%G %a' "$SHARE_DIR"; echo "Jumlah berkas: $(find "$SHARE_DIR" -type f | wc -l)"
  else echo "Share belum dibuat: $SHARE_DIR"; fi
  echo; echo "## Backup"
  if [ -s "$BACKUP_DIR/index.csv" ]; then
    while IFS=, read -r name when size hash; do
      if [ -f "$BACKUP_DIR/$name" ] && ( cd "$BACKUP_DIR" && sha256sum -c --status "$name.sha256" 2>/dev/null ); then v="VERIFIKASI OK"; else v="VERIFIKASI GAGAL/ARSIP HILANG"; fi
      echo "$name | $when | $size byte | $v"
    done < <(tail -n 5 "$BACKUP_DIR/index.csv")
  else echo "Belum ada backup tercatat."; fi
  echo; echo "## Hasil uji akses terakhir"
  [ -f "$OUT_DIR/hasil_uji_akses.log" ] && tail -n 15 "$OUT_DIR/hasil_uji_akses.log" || echo "Belum ada hasil uji."
  echo; echo "## Log operasional (10 baris terakhir)"
  [ -f "$LOG_DIR/fileserver.log" ] && tail -n 10 "$LOG_DIR/fileserver.log" || echo "Belum ada log."
} > "$rep"
log INFO "Laporan dibuat: $rep"; echo "$rep"
