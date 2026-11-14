#!/usr/bin/env bash
# Backup share/ -> backup/: validasi, lock, arsip atomik, checksum SHA-256.
# Exit: 0 ok | 2 sumber tidak valid | 3 tujuan/lock tidak dapat ditulis | 4 tar gagal | 75 lock dipegang proses lain
set -u
ROOT="${FS_ROOT:-/srv/fileserver}"
SRC="$ROOT/share"; DST="$ROOT/backup"; LOG="$ROOT/logs/ops.log"
LOCK="${FS_LOCK:-/run/lock/fs-backup.lock}"
log() { { printf '%s %s %s\n' "$(date '+%F %T')" "${SUDO_USER:-$(id -un)}" "$*" >> "$LOG"; } 2>/dev/null; }
die() { echo "$2" >&2; log "ERROR $2"; exit "$1"; }

[ -d "$SRC" ] || die 2 "Sumber tidak ada: $SRC"
{ [ -d "$DST" ] && [ -w "$DST" ]; } || die 3 "Tujuan tidak dapat ditulis: $DST"
exec 9>"$LOCK" || die 3 "Tidak dapat membuat lock: $LOCK"
flock -n -E 75 9 || { echo "Backup/restore lain sedang berjalan" >&2; log "WARN lock dipegang proses lain"; exit 75; }
[ -n "${FS_TEST_DELAY:-}" ] && sleep "$FS_TEST_DELAY"   # hanya untuk pengujian lock

NAME="backup_$(date '+%Y%m%d_%H%M%S').tar.gz"
ARC="$DST/$NAME"
tar -czf "$ARC.tmp" -C "$SRC" . ; rc=$?
if [ "$rc" -ge 2 ]; then rm -f "$ARC.tmp"; die 4 "tar gagal (rc=$rc)"; fi
[ "$rc" -eq 1 ] && log "WARN berkas berubah saat dibaca (tar rc=1)"
mv "$ARC.tmp" "$ARC"
( cd "$DST" && sha256sum "$NAME" > "$NAME.sha256" )
chmod 0640 "$ARC" "$ARC.sha256"
log "OK backup $NAME ukuran=$(stat -c %s "$ARC")"
echo "Backup selesai: $NAME"
