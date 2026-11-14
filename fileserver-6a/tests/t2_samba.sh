#!/usr/bin/env bash
# Anggota 2 - Samba & klien. Password lewat env: SF_PASS_OP, SF_PASS_OUT (tidak disimpan di repo)
source "$(dirname "$0")/lib_test.sh"
if ! command -v smbclient >/dev/null || ! systemctl is-active --quiet smbd 2>/dev/null; then
  skip T2-ALL "smbclient/smbd tidak tersedia di lingkungan ini (jalankan di VM Ubuntu dengan Samba aktif)"; summary; exit 0
fi
[ -n "${SF_PASS_OP:-}" ] && [ -n "${SF_PASS_OUT:-}" ] || { skip T2-ALL "set SF_PASS_OP & SF_PASS_OUT"; summary; exit 0; }
cred() { f=$(mktemp); chmod 600 "$f"; printf 'username=%s\npassword=%s\n' "$1" "$2" > "$f"; echo "$f"; }
c_ok=$(cred "$USER_OPERATOR" "$SF_PASS_OP"); c_out=$(cred "$USER_OUTSIDER" "$SF_PASS_OUT"); c_bad=$(cred "$USER_OPERATOR" "salah-sengaja")
echo "isi dari klien samba" > "$OUT_DIR/tmp_up.txt"
expect_rc T2-P1 "akun berwenang ($USER_OPERATOR) melihat daftar share" 0 smbclient //localhost/shared -A "$c_ok" -c 'ls'
expect_rc T2-P2 "operator dapat mengunggah berkas via Samba" 0 smbclient //localhost/shared -A "$c_ok" -c "put $OUT_DIR/tmp_up.txt test_smb.txt"
expect_rc T2-N1 "akun tidak berwenang ($USER_OUTSIDER) ditolak (bukan valid user)" nonzero smbclient //localhost/shared -A "$c_out" -c 'ls'
expect_rc T2-N2 "password salah ditolak" nonzero smbclient //localhost/shared -A "$c_bad" -c 'ls'
smbclient //localhost/shared -A "$c_ok" -c 'del test_smb.txt' >/dev/null 2>&1
rm -f "$c_ok" "$c_out" "$c_bad" "$OUT_DIR/tmp_up.txt"; summary
