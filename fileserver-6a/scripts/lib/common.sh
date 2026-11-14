#!/usr/bin/env bash
# Fungsi bersama: konfigurasi, log, exit status.
# Exit status: 0 ok | 2 parameter salah | 3 sumber/berkas tidak ada | 4 tidak dapat ditulis
#              5 integritas gagal | 6 lock sibuk | 7 layanan tidak aktif | 8 butuh root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck disable=SC1091
source "$PROJECT_ROOT/config/project.env"

log() {  # log LEVEL pesan...
  local level="$1"; shift
  mkdir -p "$LOG_DIR" 2>/dev/null
  printf '%s [%s] [%s] %s\n' "$(date '+%F %T')" "$level" "$(basename "${0:-sh}")" "$*" \
    | tee -a "$LOG_DIR/fileserver.log" >&2
}
die() { local code="$1"; shift; log ERROR "$*"; exit "$code"; }
need_root() { [ "$(id -u)" -eq 0 ] || die 8 "Script ini harus dijalankan sebagai root (sudo)."; }
