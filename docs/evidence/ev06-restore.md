# EV-06 — Simulasi Kehilangan Data dan Restore

Status: LULUS untuk restore ke staging pada DB uji sintetis; BELUM untuk off-site, simulasi kehilangan VM, DB kasir, dan RTO penuh
Tanggal/waktu: 09-11-2026 20:11:33–20:13:00 WIB (seluruh drill 87 detik, termasuk pengetikan perintah manual)
Commit dasar: 7b881b5; backup sumber: ev05 (sha256 a527538f…ee8b, dibuat 20:09:52 WIB)
Data: SINTETIS (6 menu, 2 akun uji, 0 transaksi). Staging: /tmp/restore-test/live.db pada VM yang sama (bukan VM terpisah).

## Prosedur
1. Hash isi logis sumber: `sqlite3 data/brewpoint.db .dump | sha256sum`
2. Salin backup ke staging; simulasi kehilangan data: `DELETE FROM menu_items;` pada salinan staging (bukan DB produksi).
3. Restore: `time cp /tmp/brew-backup.db /tmp/restore-test/live.db`
4. Verifikasi: `PRAGMA integrity_check; PRAGMA foreign_key_check;`, row count tiap tabel, hash `.dump` staging vs sumber, sha256 file backup.

## Hasil
| Item | Expected | Aktual | Status |
|---|---|---|---|
| menu_items setelah simulasi kehilangan | 0 | 0 | LULUS |
| menu_items setelah restore | 6 | 6 | LULUS |
| integrity_check | ok | ok | LULUS |
| foreign_key_check | tanpa keluaran | tanpa keluaran | LULUS |
| Row count (users, menu_items, orders, order_items, audit_log) | 2, 6, 0, 0, 0 | 2, 6, 0, 0, 0 | LULUS |
| Hash .dump sumber vs staging | identik | 08b2e31a02bf03e6334fc4b87fb0b85d75d0089a62ebc127f25e8ced6f091814 pada keduanya | LULUS |
| sha256 file backup | a527538f…ee8b | a527538f2bd1053764102a034c11e005c6d33f5ae2b32727ad3cbe293420ee8b | LULUS |
| Durasi restore (cp) | tercatat | real 0m0,002s | LULUS |
| Durasi seluruh drill | tercatat | 87 detik | LULUS |

## RPO dan RTO (jujur, belum mewakili skenario penuh)
- RTO target ≤ 2 jam (TARGET). Terukur: restore database uji 87 detik termasuk verifikasi manual. Ini BUKAN RTO penuh; RTO penuh mencakup membangun ulang VM, deploy dari runbook, dan restore, yang diuji pada M12.
- RPO target ≤ 24 jam (TARGET). Pada drill, umur backup saat simulasi ±2 menit (20:09:52 ke 20:11:33) dan tidak ada transaksi yang hilang karena DB belum menerima transaksi. Belum mewakili backup harian terjadwal.

## Catatan
- Kesamaan hash .dump sah karena tidak ada penulisan ke DB antara dua pengambilan hash; setelah aplikasi menulis data, bandingkan row count dan checksum pada saat backup dibuat.
- Simulasi kehilangan dilakukan dengan DELETE pada salinan staging, bukan kehilangan VM atau file.

## Isu tersisa
1. Staging berada di VM yang sama; ulangi ke instance uji terpisah (atau VM sementara) pada M12.
2. Backup belum off-site (lihat ev05).
3. Ulangi dengan data transaksi nyata/sintetis dari aplikasi kasir dan ukur RTO penuh.
