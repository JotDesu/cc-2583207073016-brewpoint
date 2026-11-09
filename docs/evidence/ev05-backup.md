# EV-05 — Backup SQLite

Status: SEBAGIAN (backup konsisten lokal LULUS; penyimpanan off-site, jadwal, dan enkripsi BELUM)
Tanggal/waktu: 09-11-2026 20:09:52 WIB
Commit dasar: 7b881b5 (feat(db): add SQLite schema and init script for BrewPoint, M05); path DB: /srv/cc-m03/data/brewpoint.db (di luar repo; .gitignore memuat data/*.db*)
Data: SINTETIS (6 menu, 2 akun uji; 0 transaksi). Bukan data kasir produksi.

## Metode
SQLite Online Backup API lewat `sqlite3 .backup` [3], bukan `cp` pada file yang sedang ditulis. Mode jurnal DB: WAL.

## Prosedur dan hasil
| Langkah | Perintah | Expected | Aktual | Status |
|---|---|---|---|---|
| Backup konsisten | `time sqlite3 data/brewpoint.db ".backup '/tmp/brew-backup.db'"` | selesai tanpa galat | real 0m0,019s | LULUS |
| Integritas backup | `sqlite3 /tmp/brew-backup.db "PRAGMA integrity_check;"` | ok | ok | LULUS |
| Jumlah baris | `SELECT COUNT(*)` per tabel | sama dengan sumber | users 2, menu_items 6, orders 0, order_items 0, audit_log 0 | LULUS |
| Checksum backup | `sha256sum /tmp/brew-backup.db` | tercatat | a527538f2bd1053764102a034c11e005c6d33f5ae2b32727ad3cbe293420ee8b | LULUS |
| Izin berkas DB | `ls -l data/brewpoint.db` | 600, pemilik = user service | -rw------- andiana (cocok dengan User=andiana pada cc-m03.service) | LULUS |
| Storage terpisah (off-site) | Azure Blob LRS pada storage account terpisah | ada | belum dibuat | BELUM |
| Penjadwalan harian | systemd timer 02:00 | aktif | belum dibuat | BELUM |
| Enkripsi/akses terbatas | SAS/identitas hak minimal; enkripsi bila memuat data pribadi | ada | belum | BELUM |
| Retensi | 7 harian + 4 mingguan | berjalan | belum | BELUM |

## Isu tersisa
1. Backup masih di /tmp pada disk yang sama dengan sumber dan hilang saat reboot; syarat backup off-site belum terpenuhi.
2. Belum ada skrip dan timer terjadwal; RPO ≤ 24 jam (TARGET) baru dapat dibuktikan setelah jadwal berjalan beberapa hari.
3. Database masih berisi data sintetis tanpa transaksi; ulangi setelah aplikasi kasir menulis data (M05).
