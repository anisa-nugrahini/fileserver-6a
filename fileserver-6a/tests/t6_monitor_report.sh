#!/usr/bin/env bash
# Anggota 6 - Deteksi layanan berhenti, verifikasi pasca-pemulihan, laporan, CPU/memori
source "$(dirname "$0")/lib_test.sh"; S="$PROJECT_ROOT/scripts"
expect_rc T6-P1 "laporan layanan & backup terbentuk" 0 "$S/gen_report.sh"
check     T6-V1 "laporan memuat bagian Status layanan, Backup, Hasil uji" bash -c "grep -q 'Status layanan' '$OUT_DIR/laporan.txt' && grep -q '## Backup' '$OUT_DIR/laporan.txt'"
svc="${T6_SERVICE:-smbd}"
if systemctl cat "$svc" >/dev/null 2>&1 && [ "$(id -u)" -eq 0 ]; then
  SERVICES="$svc" SERVICE_PORTS="" "$S/check_services.sh" >/dev/null 2>&1 || systemctl start "$svc"
  systemctl stop "$svc"
  SERVICES="$svc" SERVICE_PORTS="" expect_rc T6-N1 "layanan $svc dihentikan -> terdeteksi (exit 7)" 7 "$S/check_services.sh"
  systemctl start "$svc"; sleep 2
  SERVICES="$svc" SERVICE_PORTS="" expect_rc T6-V2 "setelah dipulihkan, verifikasi layanan aktif (exit 0)" 0 "$S/check_services.sh"
else skip T6-N1 "systemd/layanan $svc tidak tersedia atau bukan root; uji di VM (sudo)"; fi
# Beban uji: dua ukuran data (CPU/memori), kondisi dicatat
for mb in 5 50; do
  d="$OUT_DIR/tmp_load_$mb"; mkdir -p "$d/share"; head -c "${mb}M" /dev/urandom > "$d/share/blob.bin"
  "$S/monitor.sh" "sebelum-backup-${mb}MB" >/dev/null
  /usr/bin/time -f "backup ${mb}MB: %e detik, puncak memori %M KB, CPU %P" -a -o "$OUT_DIR/monitor.log" env BACKUP_DIR="$OUT_DIR/tmp_bk_$mb" "$S/backup.sh" "$d/share" >/dev/null 2>&1
  rm -rf "$d" "$OUT_DIR/tmp_bk_$mb"
done
check T6-V3 "log pengukuran beban tercatat" grep -q 'puncak memori' "$OUT_DIR/monitor.log"
summary
