# EV-06 — Simulasi Kehilangan Data dan Restore

Status: BELUM DIUJI (RENCANA). Prasyarat: ev05 berhasil.
Target: RPO ≤ 24 jam, RTO ≤ 2 jam (TARGET, bukan hasil).

## Prosedur
1. Catat kondisi awal: `SELECT COUNT(*)` tiap tabel, total omzet, sha256 file DB. Mulai stopwatch (T0).
2. Simulasi kehilangan: hentikan service, pindahkan file DB (di staging/instance uji, bukan produksi saat pilot).
3. Unduh backup terbaru dari penyimpanan terpisah; verifikasi sha256.
4. Restore ke staging; jalankan `PRAGMA integrity_check;`; bandingkan row count dan omzet.
5. Jalankan service dan `curl /health`; hentikan stopwatch (T1). RTO = T1 − T0. RPO = waktu simulasi − waktu backup terakhir.

## Hasil
| Item | Nilai |
|---|---|
| Tanggal/waktu simulasi | |
| File backup dan sha256 | |
| integrity_check | |
| Row count sebelum / sesudah | |
| Total omzet sebelum / sesudah | |
| RTO terukur | |
| RPO terukur | |
| Status | |
