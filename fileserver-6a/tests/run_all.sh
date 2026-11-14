#!/usr/bin/env bash
# Menjalankan semua uji. Usage: sudo tests/run_all.sh   (SKIP = lingkungan belum mendukung, bukan lulus)
cd "$(dirname "$0")" || exit 1
rf=0; for t in t1_permission t2_samba t3_reader t4_ssh_admin t5_backup_restore t6_monitor_report t7_docker; do
  echo "##### $t"; bash "./$t.sh" || rf=1
done
exit $rf
