#!/usr/bin/env bash
# Usage: cleanup.sh            -> bersihkan artefak uji (restore dir, berkas test_*, output/tmp)
#        sudo cleanup.sh --purge -> hapus juga user uji, group, share, backup (butuh konfirmasi 'yes')
source "$(dirname "$0")/lib/common.sh"
rm -rf "$RESTORE_DIR" "$OUT_DIR"/tmp_* 2>/dev/null
[ -d "$SHARE_DIR" ] && find "$SHARE_DIR" -maxdepth 1 -name 'test_*' -delete 2>/dev/null
log INFO "Artefak uji dibersihkan"
if [ "${1:-}" = "--purge" ]; then
  need_root
  read -r -p "Hapus user/group uji, share, dan backup? ketik 'yes': " a; [ "$a" = "yes" ] || die 2 "Dibatalkan"
  for u in "$USER_OPERATOR" "$USER_READER" "$USER_ADMIN" "$USER_OUTSIDER" "$USER_REGULAR"; do userdel -r "$u" 2>/dev/null; done
  for g in "$GRP_OPERATOR" "$GRP_READER" "$GRP_ADMIN"; do groupdel "$g" 2>/dev/null; done
  rm -rf "$SHARE_DIR" "$BACKUP_DIR" /etc/sudoers.d/fileserver-admin /etc/ssh/sshd_config.d/50-fileserver.conf
  log INFO "Purge selesai (blok [shared] di smb.conf perlu dihapus manual; ada backup smb.conf.bak.*)"
fi
