#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERROR=0

echo "=== PENGUJIAN SINTAKS BASH ==="

for FILE in "$ROOT"/scripts/*.sh "$ROOT"/tests/*.sh; do
    [ -f "$FILE" ] || continue

    if bash -n "$FILE"; then
        echo "[OK] $(basename "$FILE")"
    else
        echo "[GAGAL] $(basename "$FILE")"
        ERROR=1
    fi
done

if [ "$ERROR" -eq 0 ]; then
    echo "HASIL: SEMUA SINTAKS VALID"
else
    echo "HASIL: TERDAPAT KESALAHAN SINTAKS"
fi

exit "$ERROR"
