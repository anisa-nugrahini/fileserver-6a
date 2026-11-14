#!/usr/bin/env bash
# Menyiapkan grup, akun uji, direktori, permission, ACL, data dummy, dan memasang script ke /usr/local/sbin.
# Idempoten. Jalankan: sudo scripts/setup_env.sh
set -eu
[ "$(id -u)" -eq 0 ] || { echo "Jalankan dengan sudo" >&2; exit 1; }
command -v setfacl >/dev/null || { echo "Paket acl belum ada: sudo apt install acl" >&2; exit 1; }
ROOT="${FS_ROOT:-/srv/fileserver}"
HERE="$(cd "$(dirname "$0")" && pwd)"

for g in sf_admin sf_operator sf_reader; do getent group "$g" >/dev/null || groupadd "$g"; done

mkuser() {  # nama grup shell
  id "$1" >/dev/null 2>&1 || useradd -m -s "$3" "$1"
  [ -z "$2" ] || id -nG "$1" | tr ' ' '\n' | grep -qx "$2" || usermod -aG "$2" "$1"
}
mkuser adm1 sf_admin /bin/bash
mkuser op1  sf_operator /bin/bash
mkuser op2  sf_operator /bin/bash
mkuser rd1  sf_reader /usr/sbin/nologin
mkuser rd2  sf_reader /usr/sbin/nologin
mkuser tamu1 "" /bin/bash

mkdir -p "$ROOT"/{share,backup,restore-test,logs}
chmod 0755 "$ROOT"
chown root:sf_operator "$ROOT/share";  chmod 2770 "$ROOT/share"
setfacl -m g:sf_reader:rx  "$ROOT/share"
setfacl -d -m g:sf_reader:rX "$ROOT/share"
chown root:sf_admin "$ROOT/backup" "$ROOT/logs" "$ROOT/restore-test"
chmod 0750 "$ROOT/backup" "$ROOT/logs" "$ROOT/restore-test"

if [ -z "$(ls -A "$ROOT/share")" ]; then
  for i in 1 2 3; do
    echo "Dokumen dummy $i" > "$ROOT/share/dokumen$i.txt"
    chown root:sf_operator "$ROOT/share/dokumen$i.txt"; chmod 0660 "$ROOT/share/dokumen$i.txt"
  done
fi

install -o root -g root -m 0755 "$HERE/backup.sh"        /usr/local/sbin/fs-backup.sh
install -o root -g root -m 0755 "$HERE/restore.sh"       /usr/local/sbin/fs-restore.sh
install -o root -g root -m 0755 "$HERE/check_service.sh" /usr/local/sbin/fs-check.sh
install -o root -g root -m 0755 "$HERE/log_test.sh"      /usr/local/sbin/fs-logtest.sh

echo "== Verifikasi =="; getfacl -p "$ROOT/share"; ls -ld "$ROOT"/*
cat <<MSG

Langkah berikut (interaktif, kata sandi tidak disimpan di script):
  sudo passwd adm1; sudo passwd op1; sudo passwd op2; sudo passwd tamu1
  sudo smbpasswd -a op1; sudo smbpasswd -a op2; sudo smbpasswd -a rd1; sudo smbpasswd -a rd2
  (jangan daftarkan tamu1 ke Samba)
Lalu: sudo scripts/setup_services.sh
MSG
