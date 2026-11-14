#!/usr/bin/env bash
# Usage: sudo setup.sh [--install-configs]
# Membuat group, user uji, direktori share + permission/ACL, data dummy.
# --install-configs: pasang blok Samba, drop-in SSH, dan sudoers (dengan validasi & backup).
source "$(dirname "$0")/lib/common.sh"
need_root
command -v setfacl >/dev/null || die 3 "Paket 'acl' belum terpasang (apt install acl)"

for g in "$GRP_OPERATOR" "$GRP_READER" "$GRP_ADMIN"; do
  getent group "$g" >/dev/null || { groupadd "$g" && log INFO "Group dibuat: $g"; }
done
mkuser() { # user [group_proyek]
  id "$1" >/dev/null 2>&1 || { useradd -m -s /bin/bash "$1" && passwd -l "$1" >/dev/null \
    && log INFO "User dibuat (password terkunci): $1"; }
  [ -z "${2:-}" ] || usermod -aG "$2" "$1"
}
mkuser "$USER_OPERATOR" "$GRP_OPERATOR"
mkuser "$USER_READER"   "$GRP_READER"
mkuser "$USER_ADMIN"    "$GRP_ADMIN"
mkuser "$USER_OUTSIDER"            # sengaja tanpa grup proyek
mkuser "$USER_REGULAR"             # akun biasa non-admin

mkdir -p "$SHARE_DIR"
chown root:"$GRP_OPERATOR" "$SHARE_DIR"
chmod 2770 "$SHARE_DIR"                                  # setgid: berkas baru mewarisi group operator
setfacl -m  g:"$GRP_READER":rx "$SHARE_DIR"              # pembaca: baca saja
setfacl -d -m g:"$GRP_OPERATOR":rwx -m g:"$GRP_READER":rx -m o::--- "$SHARE_DIR"
# traversal parent
chmod o+x "$(dirname "$SHARE_DIR")" 2>/dev/null

[ -f "$SHARE_DIR/readme_dummy.txt" ] || {
  printf 'Dokumen dummy proyek 6A\nBaris 2\nBaris 3\n' > "$SHARE_DIR/readme_dummy.txt"
  chown "$USER_OPERATOR":"$GRP_OPERATOR" "$SHARE_DIR/readme_dummy.txt"; chmod 660 "$SHARE_DIR/readme_dummy.txt"
  setfacl -m g:"$GRP_READER":r "$SHARE_DIR/readme_dummy.txt"
}
log INFO "Share siap: $(stat -c '%n %U:%G %a' "$SHARE_DIR")"

if [ "${1:-}" = "--install-configs" ]; then
  ts=$(date +%s)
  if command -v testparm >/dev/null && [ -f /etc/samba/smb.conf ]; then
    cp /etc/samba/smb.conf "/etc/samba/smb.conf.bak.$ts"
    grep -q '^\[shared\]' /etc/samba/smb.conf || { echo >> /etc/samba/smb.conf; cat "$PROJECT_ROOT/config/smb_share.conf" >> /etc/samba/smb.conf; }
    testparm -s >/dev/null 2>&1 && systemctl restart smbd && log INFO "Samba dikonfigurasi" \
      || { cp "/etc/samba/smb.conf.bak.$ts" /etc/samba/smb.conf; log ERROR "testparm gagal; konfigurasi dikembalikan"; }
  else log WARN "Samba belum terpasang; lewati (apt install samba smbclient)"; fi
  if command -v sshd >/dev/null; then
    install -m 644 "$PROJECT_ROOT/config/sshd_fileserver.conf" /etc/ssh/sshd_config.d/50-fileserver.conf
    sshd -t && systemctl reload ssh && log INFO "SSH dikonfigurasi" \
      || { rm -f /etc/ssh/sshd_config.d/50-fileserver.conf; log ERROR "sshd -t gagal; drop-in dihapus"; }
  else log WARN "OpenSSH server belum terpasang; lewati"; fi
  tmp=$(mktemp); sed "s#__ROOT__#$PROJECT_ROOT#g" "$PROJECT_ROOT/config/sudoers_sfadmin.example" > "$tmp"
  if visudo -cf "$tmp" >/dev/null; then install -m 440 "$tmp" /etc/sudoers.d/fileserver-admin; log INFO "sudoers dipasang"
  else log ERROR "visudo menolak berkas sudoers; tidak dipasang"; fi; rm -f "$tmp"
fi
echo "Selanjutnya (Samba): sudo smbpasswd -a <user>  untuk $USER_OPERATOR, $USER_READER, $USER_OUTSIDER"
