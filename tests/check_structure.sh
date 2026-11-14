#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERROR=0

echo "=== PENGUJIAN STRUKTUR PROYEK ==="

for DIR in scripts config evidence output docs tests; do
    if [ -d "$ROOT/$DIR" ]; then
        echo "[OK] Folder $DIR tersedia"
    else
        echo "[GAGAL] Folder $DIR tidak ditemukan"
        ERROR=1
    fi
done

for FILE in backup.sh check_service.sh cleanup.sh log_test.sh report.sh restore.sh setup_env.sh setup_services.sh; do
    if [ -f "$ROOT/scripts/$FILE" ]; then
        echo "[OK] $FILE tersedia"
    else
        echo "[GAGAL] $FILE tidak ditemukan"
        ERROR=1
    fi
done

if [ "$ERROR" -eq 0 ]; then
    echo "HASIL: STRUKTUR PROYEK LENGKAP"
else
    echo "HASIL: STRUKTUR PROYEK BELUM LENGKAP"
fi

exit "$ERROR"
