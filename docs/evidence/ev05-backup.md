# EV-05 — Backup SQLite ke Penyimpanan Terpisah

Status: BELUM ADA (RENCANA). Database SQLite belum dibuat (M05).
Metode: SQLite Online Backup API (`.backup`), bukan `cp` pada file yang sedang ditulis. RPO target ≤ 24 jam.

## Rencana
1. Buat storage account Azure (LRS) terpisah dari VM; container privat `brewpoint-backup`. Akses lewat SAS/identitas dengan hak minimal. Kredensial TIDAK masuk repo.
2. Skrip `/srv/cc-m03/scripts/backup.sh` (dijalankan systemd timer 02:00):
```bash
set -euo pipefail
TS=$(date +%Y%m%d-%H%M%S); OUT=/var/backups/brewpoint/brewpoint-$TS.db
sqlite3 /srv/cc-m03/data/brewpoint.db ".backup '$OUT'"
sqlite3 "$OUT" "PRAGMA integrity_check;"     # harus ok
sha256sum "$OUT" > "$OUT.sha256"
# unggah ke Blob (azcopy/az cli); retensi 7 harian + 4 mingguan
```
3. Enkripsi bila data pribadi (hash password) ikut tersimpan; batasi izin folder (700).

## Hasil (isi setelah dijalankan)
| Tanggal/waktu | File | Ukuran | sha256 | integrity_check | Lokasi off-site | Status |
|---|---|---|---|---|---|---|
