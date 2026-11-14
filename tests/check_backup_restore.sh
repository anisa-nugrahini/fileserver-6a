#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERROR=0

echo "=== PENGUJIAN BACKUP DAN RESTORE ==="

for FILE in backup.sh restore.sh; do
    if [ -f "$ROOT/scripts/$FILE" ]; then
        echo "[OK] $FILE tersedia"
    else
        echo "[GAGAL] $FILE tidak ditemukan"
        ERROR=1
    fi
done

if grep -q "sha256sum" "$ROOT/scripts/backup.sh"; then
    echo "[OK] Backup menggunakan SHA-256"
else
    echo "[GAGAL] SHA-256 tidak ditemukan pada backup"
    ERROR=1
fi

if grep -q "sha256sum -c" "$ROOT/scripts/restore.sh"; then
    echo "[OK] Restore melakukan verifikasi checksum"
else
    echo "[GAGAL] Verifikasi checksum tidak ditemukan"
    ERROR=1
fi

if grep -q "flock" "$ROOT/scripts/backup.sh" &&
   grep -q "flock" "$ROOT/scripts/restore.sh"; then
    echo "[OK] Backup dan restore menggunakan file lock"
else
    echo "[GAGAL] Mekanisme file lock tidak lengkap"
    ERROR=1
fi

if [ "$ERROR" -eq 0 ]; then
    echo "HASIL: PEMERIKSAAN KOMPONEN BERHASIL"
else
    echo "HASIL: PEMERIKSAAN KOMPONEN GAGAL"
fi

exit "$ERROR"
