#!/usr/bin/env bash
# Anggota 1 - User, group, permission
source "$(dirname "$0")/lib_test.sh"; need_root
f="$SHARE_DIR/test_t1_$$.txt"
expect_rc T1-P1 "operator ($USER_OPERATOR) dapat menulis ke share" 0 as "$USER_OPERATOR" bash -c "echo data > '$f'"
check     T1-P2 "berkas hasil tulis berkelompok $GRP_OPERATOR (setgid)" bash -c "[ \"\$(stat -c %G '$f')\" = '$GRP_OPERATOR' ]"
expect_rc T1-N1 "pengguna di luar grup ($USER_OUTSIDER) ditolak membaca share" nonzero as "$USER_OUTSIDER" ls "$SHARE_DIR"
expect_rc T1-N2 "pengguna di luar grup ($USER_OUTSIDER) ditolak menulis" nonzero as "$USER_OUTSIDER" touch "$SHARE_DIR/test_t1_out"
rm -f "$f"; getfacl -p "$SHARE_DIR" 2>/dev/null | tee -a "$OUT_DIR/hasil_uji_akses.log" >/dev/null
summary
