#!/usr/bin/env bash
# Memeriksa status layanan ($SERVICES) dan port ($SERVICE_PORTS). Exit 7 bila ada yang tidak aktif.
source "$(dirname "$0")/lib/common.sh"
mkdir -p "$OUT_DIR"
bad=0; out="$OUT_DIR/status_layanan.txt"
{
  echo "Pemeriksaan layanan: $(date '+%F %T')"
  for s in $SERVICES; do
    st=$(systemctl is-active "$s" 2>/dev/null); [ -n "$st" ] || st="unknown"
    printf '%-10s %s\n' "$s" "$st"
    [ "$st" = "active" ] || bad=1
  done
  for p in $SERVICE_PORTS; do
    if ss -ltn 2>/dev/null | awk '{print $4}' | grep -Eq "[:.]$p$"; then
      printf 'port %-6s LISTEN\n' "$p"
    else
      printf 'port %-6s TIDAK LISTEN\n' "$p"; bad=1
    fi
  done
} | tee "$out"
if [ "$bad" -ne 0 ]; then log ERROR "Ada layanan/port tidak aktif (lihat $out)"; exit 7; fi
log INFO "Semua layanan aktif"; exit 0
