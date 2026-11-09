# EV-08 — Uji Beban Terkontrol

Status: BELUM DIUJI (RENCANA). Jangan klaim lulus sebelum diukur.
Catatan: VM B-series bersifat burstable; catat metrik kredit CPU.

## Batas lulus (ditetapkan SEBELUM pengukuran, usulan)
p95 ≤ 800 ms pada 5 pengguna konkuren; error 5xx < 1%; RAM terpakai < 80%.

## Skenario
| Tahap | Pengguna konkuren | Durasi | Endpoint |
|---|---|---|---|
| 1 | 1 | 5 menit | GET /health, GET / |
| 2 | 5 | 5 menit | alur kasir: login, daftar menu, buat transaksi (M05) |
| 3 | 10 | 5 menit | sama |
Alat: k6 atau ApacheBench dari laptop (bukan dari VM). Data sintetis. Pantau di VM: `vmstat 5`, `free -h`, `top`.

## Hasil
| Tahap | Request total | RPS | p50 | p95 | Error rate | CPU maks | RAM maks | Status |
|---|---|---|---|---|---|---|---|---|

Kondisi server (baseline idle 07-11-2026): RAM terpakai 258 MiB, service cc-m03 22,4 MB, swap 65 MiB.
