#!/usr/bin/env bash
# Anggota 3 - Hak pembaca
source "$(dirname "$0")/lib_test.sh"; need_root
f="$SHARE_DIR/test_t3_$$.txt"; as "$USER_OPERATOR" bash -c "echo isi-asli > '$f'"
before=$(sha256sum "$f" | cut -d' ' -f1)
expect_rc T3-P1 "pembaca ($USER_READER) dapat membaca berkas" 0 as "$USER_READER" cat "$f"
expect_rc T3-N1 "pembaca ditolak mengubah berkas" nonzero as "$USER_READER" bash -c "echo x >> '$f'"
expect_rc T3-N2 "pembaca ditolak menghapus berkas" nonzero as "$USER_READER" rm -f "$f"
expect_rc T3-N3 "pembaca ditolak membuat berkas baru" nonzero as "$USER_READER" touch "$SHARE_DIR/test_t3_new"
check     T3-V1 "berkas masih ada & checksum tidak berubah" bash -c "[ \"\$(sha256sum '$f' | cut -d' ' -f1)\" = '$before' ]"
rm -f "$f"; summary
