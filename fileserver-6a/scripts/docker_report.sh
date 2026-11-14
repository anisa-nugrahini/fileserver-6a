#!/usr/bin/env bash
# Aktivitas Docker: container membaca laporan via bind mount read-only. Usage: docker_report.sh [positive|negative]
source "$(dirname "$0")/lib/common.sh"
command -v docker >/dev/null || die 3 "Docker tidak terpasang"
[ -f "$OUT_DIR/laporan.txt" ] || die 3 "output/laporan.txt belum ada (jalankan scripts/gen_report.sh)"
docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1 || die 3 "Image $DOCKER_IMAGE belum diunduh (docker pull $DOCKER_IMAGE)"
mnt=(--mount "type=bind,src=$OUT_DIR,dst=/data,readonly")
case "${1:-positive}" in
  positive)
    docker run --rm "${mnt[@]}" "$DOCKER_IMAGE" cat /data/laporan.txt; rc=$?
    echo "exit status: $rc"; exit $rc ;;
  negative)
    before=$(sha256sum "$OUT_DIR/laporan.txt" | cut -d' ' -f1)
    docker run --rm "${mnt[@]}" "$DOCKER_IMAGE" sh -c 'echo "uji perubahan" >> /data/laporan.txt'; rc=$?
    after=$(sha256sum "$OUT_DIR/laporan.txt" | cut -d' ' -f1)
    echo "exit status: $rc | sha256 sebelum=$before | sesudah=$after"
    [ "$rc" -ne 0 ] && [ "$before" = "$after" ] && { log INFO "Uji negatif Docker OK: penulisan ditolak, berkas host tidak berubah"; exit 0; }
    die 5 "Uji negatif Docker GAGAL (rc=$rc, checksum berubah=$([ "$before" != "$after" ] && echo ya || echo tidak))" ;;
  *) die 2 "Usage: $0 [positive|negative]" ;;
esac
