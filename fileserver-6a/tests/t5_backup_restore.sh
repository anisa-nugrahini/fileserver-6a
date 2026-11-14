#!/usr/bin/env bash
# Anggota 5 - Backup dan restore (+ konkurensi)
source "$(dirname "$0")/lib_test.sh"
S="$PROJECT_ROOT/scripts"; T="$OUT_DIR/tmp_t5"; rm -rf "$T"; mkdir -p "$T"
arc=$("$S/backup.sh" 2>/dev/null | tail -1); [ -f "$arc" ] && { PASS=$((PASS+1)); _rec T5-P0 PASS "backup menghasilkan arsip $(basename "$arc")"; } || { FAIL=$((FAIL+1)); _rec T5-P0 FAIL "backup gagal"; summary; exit 1; }
expect_rc T5-P1 "restore ke direktori uji & isi sama dengan sumber" 0 "$S/restore.sh" "$arc" "$T/restore_ok" "$SHARE_DIR"
# arsip rusak: salin lalu ubah 1 byte
cp "$arc" "$T/rusak.tar.gz"; cp "$arc.sha256" "$T/rusak.tar.gz.sha256"
printf '\xff' | dd of="$T/rusak.tar.gz" bs=1 seek=20 count=1 conv=notrunc 2>/dev/null
expect_rc T5-N1 "arsip rusak ditolak (exit 5), tidak dinyatakan berhasil" 5 "$S/restore.sh" "$T/rusak.tar.gz" "$T/restore_bad"
check     T5-V1 "tidak ada data terekstrak dari arsip rusak" bash -c "[ ! -d '$T/restore_bad' ] || [ -z \"\$(ls -A '$T/restore_bad')\" ]"
expect_rc T5-N2 "sumber tidak ada ditolak (exit 3)" 3 "$S/backup.sh" /tidak/ada
# konkurensi: backup pertama menahan lock 4 detik; kedua harus ditolak (exit 6)
BACKUP_HOLD=4 "$S/backup.sh" >/dev/null 2>&1 & bg=$!; sleep 1
expect_rc T5-N3 "backup kedua bersamaan ditolak oleh lock (exit 6)" 6 "$S/backup.sh"
wait $bg; rm -rf "$T"; summary
