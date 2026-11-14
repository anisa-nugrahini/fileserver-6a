#!/usr/bin/env bash
# Usage: monitor.sh [label]  -> menambah snapshot CPU/memori ke $OUT_DIR/monitor.log
source "$(dirname "$0")/lib/common.sh"
mkdir -p "$OUT_DIR"
{
  echo "=== snapshot '${1:-tanpa-label}' $(date '+%F %T') ==="
  echo "loadavg: $(cut -d' ' -f1-3 /proc/loadavg)"
  free -m | awk 'NR<=2'
  echo "-- 5 proses teratas (CPU) --"; ps -eo pid,user,pcpu,pmem,rss,comm --sort=-pcpu | head -6
  echo "-- proses layanan --"; ps -eo pid,user,pcpu,pmem,rss,comm | grep -E 'smbd|sshd' | grep -v grep || echo "(smbd/sshd tidak berjalan)"
} | tee -a "$OUT_DIR/monitor.log"
