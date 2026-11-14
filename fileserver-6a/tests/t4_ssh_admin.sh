#!/usr/bin/env bash
# Anggota 4 - Administrasi SSH & pembatasan tindakan admin
source "$(dirname "$0")/lib_test.sh"; need_root
cs="$PROJECT_ROOT/scripts/check_services.sh"
if command -v sshd >/dev/null; then
  check T4-V1 "sshd -T: PermitRootLogin no" bash -c "sshd -T 2>/dev/null | grep -qi '^permitrootlogin no'"
else skip T4-V1 "sshd tidak terpasang di lingkungan ini"; fi
if [ -f /etc/sudoers.d/fileserver-admin ]; then
  # layanan boleh tidak aktif (rc 7); yang diuji adalah IZIN sudo, bukan hasil layanan
  as "$USER_ADMIN" sudo -n "$cs" >/dev/null 2>&1; rc=$?
  [ $rc -eq 0 ] || [ $rc -eq 7 ] && { PASS=$((PASS+1)); _rec T4-P1 PASS "admin ($USER_ADMIN) boleh menjalankan tindakan admin terbatas (rc=$rc)"; } \
                                 || { FAIL=$((FAIL+1)); _rec T4-P1 FAIL "admin ditolak (rc=$rc)"; }
  expect_rc T4-N1 "akun biasa ($USER_REGULAR) ditolak menjalankan tindakan admin via sudo" nonzero as "$USER_REGULAR" sudo -n "$cs"
  expect_rc T4-N2 "admin ditolak mendapat shell root bebas (sudo -n bash)" nonzero as "$USER_ADMIN" sudo -n /bin/bash -c id
else skip T4-ALL "sudoers belum dipasang (jalankan: sudo scripts/setup.sh --install-configs)"; fi
summary
