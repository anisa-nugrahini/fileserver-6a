#!/usr/bin/env bash
# Restore arsip ke restore-test/ setelah verifikasi checksum. Pemakaian: restore.sh <nama-arsip>
# Exit: 0 ok | 2 argumen/arsip tidak valid | 3 tujuan tidak dapat ditulis | 4 ekstraksi gagal | 5 verifikasi gagal | 75 lock dipegang
set -u
ROOT="${FS_ROOT:-/srv/fileserver}"
SRC="$ROOT/share"; DST="$ROOT/backup"; OUT="$ROOT/restore-test"; LOG="$ROOT/logs/ops.log"
LOCK="${FS_LOCK:-/run/lock/fs-backup.lock}"
log() { { printf '%s %s %s\n' "$(date '+%F %T')" "${SUDO_USER:-$(id -un)}" "$*" >> "$LOG"; } 2>/dev/null; }
die() { echo "$2" >&2; log "ERROR $2"; exit "$1"; }

[ $# -eq 1 ] || die 2 "Pemakaian: $0 <nama-arsip>"
NAME="$(basename "$1")"            # hanya nama berkas, mencegah path traversal
ARC="$DST/$NAME"
[ -f "$ARC" ] || die 2 "Arsip tidak ditemukan: $NAME"
[ -f "$ARC.sha256" ] || die 5 "Berkas checksum tidak ada untuk $NAME; restore dibatalkan"
{ [ -d "$OUT" ] && [ -w "$OUT" ]; } || die 3 "Direktori restore tidak dapat ditulis: $OUT"
exec 9>"$LOCK" || die 3 "Tidak dapat membuat lock"
flock -n -E 75 9 || { echo "Backup/restore lain sedang berjalan" >&2; log "WARN lock dipegang proses lain"; exit 75; }

if ! ( cd "$DST" && sha256sum -c --quiet "$NAME.sha256" ) >/dev/null 2>&1; then
  die 5 "Verifikasi checksum GAGAL untuk $NAME; restore dibatalkan"
fi
TARGET="$OUT/${NAME%.tar.gz}"
rm -rf "$TARGET"; mkdir -p "$TARGET"
tar -xzf "$ARC" -C "$TARGET" || { rm -rf "$TARGET"; die 4 "Ekstraksi gagal untuk $NAME"; }
if diff -r "$SRC" "$TARGET" >/dev/null 2>&1; then HASIL="identik dengan share/ saat ini"; else HASIL="berbeda dari share/ saat ini (share berubah setelah backup)"; fi
log "OK restore $NAME ke $TARGET; $HASIL"
echo "Restore selesai ke $TARGET ($HASIL)"
