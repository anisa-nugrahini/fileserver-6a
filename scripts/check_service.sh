#!/usr/bin/env bash
# Memeriksa status layanan, mencatat ke ops.log. Pemakaian: check_service.sh [--loop DETIK]
# Exit: 0 layanan aktif | 1 layanan tidak aktif | 3 systemctl tidak tersedia
ROOT="${FS_ROOT:-/srv/fileserver}"; LOG="$ROOT/logs/ops.log"; SVC="${FS_SERVICE:-smbd}"
log() { { printf '%s %s %s\n' "$(date '+%F %T')" "${SUDO_USER:-$(id -un)}" "$*" >> "$LOG"; } 2>/dev/null; }
command -v systemctl >/dev/null || { echo "systemctl tidak tersedia" >&2; exit 3; }

check() {
  if systemctl is-active --quiet "$SVC"; then
    pid="$(systemctl show -p MainPID --value "$SVC")"
    log "OK $SVC aktif PID=$pid"; echo "OK $SVC aktif (PID $pid)"; return 0
  fi
  log "ERROR $SVC tidak aktif"; echo "ERROR $SVC tidak aktif" >&2; return 1
}

if [ "${1:-}" = "--loop" ]; then
  iv="${2:-10}"
  while true; do check; sleep "$iv"; done
else
  check
fi
