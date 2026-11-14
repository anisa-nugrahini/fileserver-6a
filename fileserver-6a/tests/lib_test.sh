#!/usr/bin/env bash
# Harness uji: mencatat ID, status, exit status aktual ke output/hasil_uji_akses.log
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib/common.sh"
mkdir -p "$OUT_DIR"; RESULT_LOG="$OUT_DIR/hasil_uji_akses.log"
: "${PASS:=0}"; : "${FAIL:=0}"; : "${SKIP:=0}"
_rec() { printf '%s | %-6s | %-5s | %s\n' "$(date '+%F %T')" "$1" "$2" "$3" | tee -a "$RESULT_LOG"; }
# expect_rc ID "deskripsi" <rc_diharapkan|nonzero> perintah...
expect_rc() {
  local id="$1" desc="$2" exp="$3"; shift 3
  local out rc; out=$("$@" 2>&1); rc=$?
  local ok=0
  if [ "$exp" = "nonzero" ]; then [ $rc -ne 0 ] && ok=1; else [ $rc -eq "$exp" ] && ok=1; fi
  if [ $ok -eq 1 ]; then PASS=$((PASS+1)); _rec "$id" PASS "$desc (rc=$rc, diharapkan=$exp)"
  else FAIL=$((FAIL+1)); _rec "$id" FAIL "$desc (rc=$rc, diharapkan=$exp) :: $(echo "$out" | head -2 | tr '\n' ' ')"; fi
}
check() { # check ID "deskripsi" perintah...  (lulus bila perintah sukses; digunakan utk verifikasi tambahan)
  local id="$1" desc="$2"; shift 2
  if "$@" >/dev/null 2>&1; then PASS=$((PASS+1)); _rec "$id" PASS "$desc"; else FAIL=$((FAIL+1)); _rec "$id" FAIL "$desc"; fi
}
skip() { SKIP=$((SKIP+1)); _rec "$1" SKIP "$2"; }
as() { local u="$1"; shift; runuser -u "$u" -- "$@"; }   # jalankan sebagai akun tertentu (bukan admin)
summary() { echo "RINGKASAN: PASS=$PASS FAIL=$FAIL SKIP=$SKIP"; [ "$FAIL" -eq 0 ]; }
