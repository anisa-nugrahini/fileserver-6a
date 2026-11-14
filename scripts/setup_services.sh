#!/usr/bin/env bash
# Memasang blok share Samba, aturan sudo terbatas, dan pembatasan SSH. Jalankan: sudo scripts/setup_services.sh
# PENTING: akun yang Anda pakai untuk login SSH harus anggota sf_admin atau sf_operator,
# jika tidak, Anda akan terkunci dari SSH. Simpan satu sesi terminal lain tetap terbuka.
set -eu
[ "$(id -u)" -eq 0 ] || { echo "Jalankan dengan sudo" >&2; exit 1; }
HERE="$(cd "$(dirname "$0")/.." && pwd)"

echo "== Samba =="
[ -f /etc/samba/smb.conf ] || { echo "Samba belum terpasang: sudo apt install samba" >&2; exit 1; }
cp -n /etc/samba/smb.conf /etc/samba/smb.conf.bak-proyek
grep -q '^\[berkas\]' /etc/samba/smb.conf || cat "$HERE/config/smb.conf.example" >> /etc/samba/smb.conf
testparm -s >/dev/null && echo "testparm OK"
systemctl enable --now smbd
smbcontrol smbd reload-config || systemctl restart smbd

echo "== sudoers =="
TMP="$(mktemp)"; cp "$HERE/config/sudoers.example" "$TMP"
visudo -cf "$TMP" && install -o root -g root -m 0440 "$TMP" /etc/sudoers.d/sf_admin; rm -f "$TMP"

echo "== SSH =="
WHO="${SUDO_USER:-}"
if [ -z "$WHO" ] || ! id -nG "$WHO" | tr ' ' '\n' | grep -qxE 'sf_admin|sf_operator'; then
  echo "Dilewati: '$WHO' belum anggota sf_admin/sf_operator. Tambahkan dulu (sudo usermod -aG sf_admin $WHO), lalu jalankan ulang." >&2
  exit 0
fi
install -o root -g root -m 0644 "$HERE/config/sshd_config.example" /etc/ssh/sshd_config.d/10-fileserver.conf
sshd -t && { systemctl reload ssh 2>/dev/null || systemctl reload sshd; echo "SSH dimuat ulang"; }
