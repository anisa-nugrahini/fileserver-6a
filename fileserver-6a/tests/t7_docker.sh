#!/usr/bin/env bash
# Anggota 7 - Aktivitas Docker (baca laporan, mount read-only)
source "$(dirname "$0")/lib_test.sh"; S="$PROJECT_ROOT/scripts"
if ! command -v docker >/dev/null || ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
  skip T7-ALL "docker/image $DOCKER_IMAGE tidak tersedia (docker pull $DOCKER_IMAGE di VM)"; summary; exit 0
fi
[ -f "$OUT_DIR/laporan.txt" ] || "$S/gen_report.sh" >/dev/null
expect_rc T7-P1 "container membaca laporan.txt (exit 0)" 0 "$S/docker_report.sh" positive
expect_rc T7-N1 "penulisan via mount read-only ditolak & checksum host tidak berubah" 0 "$S/docker_report.sh" negative
summary
