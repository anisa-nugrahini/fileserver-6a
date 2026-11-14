#!/usr/bin/env bash
# Usage: backup.sh [direktori_sumber]   (default: $SHARE_DIR)
# Membuat arsip tar.gz bertanda waktu + checksum SHA-256, akses 600, dengan lock (flock).
source "$(dirname "$0")/lib/common.sh"

src="${1:-$SHARE_DIR}"
[ $# -le 1 ] || die 2 "Usage: $0 [direktori_sumber]"
[ -d "$src" ] || die 3 "Sumber tidak tersedia: $src"
[ -r "$src" ] || die 3 "Sumber tidak dapat dibaca: $src"
mkdir -p "$BACKUP_DIR" 2>/dev/null
[ -d "$BACKUP_DIR" ] && [ -w "$BACKUP_DIR" ] || die 4 "Tujuan tidak dapat ditulis: $BACKUP_DIR"

# Critical section: hanya satu backup pada satu waktu (non-blocking lock).
exec 9>"$LOCK_FILE" || die 4 "Tidak dapat membuka lock file $LOCK_FILE"
flock -n 9 || die 6 "Backup lain sedang berjalan (lock: $LOCK_FILE). Ditolak."
log INFO "Lock diperoleh (PID $$)"
[ -n "${BACKUP_HOLD:-}" ] && sleep "$BACKUP_HOLD"   # hook uji: menahan lock agar konkurensi dapat diamati

umask 077
name="backup-$(date +%Y%m%d-%H%M%S).tar.gz"
if ! tar -czf "$BACKUP_DIR/$name" -C "$(dirname "$src")" "$(basename "$src")"; then
  rm -f "$BACKUP_DIR/$name"
  die 4 "Pembuatan arsip gagal: $name"
fi
( cd "$BACKUP_DIR" && sha256sum "$name" > "$name.sha256" ) || die 4 "Gagal menulis checksum"
chmod 600 "$BACKUP_DIR/$name" "$BACKUP_DIR/$name.sha256"

size=$(stat -c %s "$BACKUP_DIR/$name")
hash=$(cut -d' ' -f1 "$BACKUP_DIR/$name.sha256")
echo "$name,$(date '+%F %T'),$size,$hash" >> "$BACKUP_DIR/index.csv"
log INFO "Backup OK: $name ($size byte) sha256=$hash"
echo "$BACKUP_DIR/$name"
exit 0
