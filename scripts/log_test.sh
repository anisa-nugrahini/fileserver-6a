#!/usr/bin/env bash
# Mencatat hasil uji akses. Pemakaian: sudo log_test.sh <ID> "<deskripsi>" <exit-status> [LULUS|GAGAL]
ROOT="${FS_ROOT:-/srv/fileserver}"
[ $# -ge 3 ] || { echo "Pemakaian: $0 <ID> \"<deskripsi>\" <exit-status> [LULUS|GAGAL]" >&2; exit 2; }
printf '%s %s | %s | exit=%s | %s\n' "$(date '+%F %T')" "$1" "$2" "$3" "${4:--}" >> "$ROOT/logs/access-tests.log"
