#!/usr/bin/env bash
# Usage: restore.sh <arsip.tar.gz> [direktori_target_kosong] [direktori_acuan_untuk_dibandingkan]
# Integritas diverifikasi SEBELUM ekstraksi; arsip rusak tidak pernah dinyatakan berhasil.
source "$(dirname "$0")/lib/common.sh"

arc="${1:-}"; target="${2:-$RESTORE_DIR}"; ref="${3:-}"
[ -n "$arc" ] || die 2 "Usage: $0 <arsip.tar.gz> [target] [acuan]"
[ -f "$arc" ] || die 3 "Arsip tidak ditemukan: $arc"
[ -f "$arc.sha256" ] || die 3 "Berkas checksum tidak ditemukan: $arc.sha256"

if ! ( cd "$(dirname "$arc")" && sha256sum -c --status "$(basename "$arc").sha256" ); then
  die 5 "Checksum TIDAK cocok: $arc. Restore dibatalkan, tidak ada data diekstrak."
fi
tar -tzf "$arc" >/dev/null 2>&1 || die 5 "Arsip tidak dapat dibaca (rusak): $arc. Restore dibatalkan."

mkdir -p "$target" || die 4 "Tidak dapat membuat target: $target"
[ -z "$(ls -A "$target" 2>/dev/null)" ] || die 4 "Target tidak kosong (mencegah menimpa data): $target"
tar -xzf "$arc" -C "$target" || die 4 "Ekstraksi gagal"

if [ -n "$ref" ]; then
  if diff -r "$ref" "$target/$(basename "$ref")" >/dev/null 2>&1; then
    log INFO "Verifikasi isi: SAMA dengan acuan $ref"
  else
    die 5 "Verifikasi isi: BERBEDA dari acuan $ref"
  fi
fi
log INFO "Restore OK: $arc -> $target ($(find "$target" -type f | wc -l) berkas)"
exit 0
