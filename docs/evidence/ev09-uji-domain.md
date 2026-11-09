# EV-09 — Uji Domain Kasir dan Akses Peran

Status: BELUM DIUJI (RENCANA). Fitur kasir belum diimplementasi (M05).
Semua uji memakai data sintetis. Catat log dan status apa adanya.

## Matriks uji
| ID | Skenario | Expected | Aktual | Status |
|---|---|---|---|---|
| T01 | Dua permintaan serentak, idempotency key sama | tepat 1 transaksi; stok tidak negatif | | |
| T02 | Dua kasir memproses pesanan yang sama | tidak ada duplikasi; satu berhasil, satu ditolak | | |
| T03 | Proses dimatikan sebelum commit | tidak ada transaksi setengah tercatat | | |
| T04 | Proses dimatikan sesudah commit | transaksi tercatat tepat satu kali | | |
| T05 | Total laporan omzet harian | = Σ transaksi sah | | |
| T06 | Kasir mengubah harga | ditolak (403) | | |
| T07 | Kasir membuka laporan/dashboard pemilik | ditolak (403) | | |
| T08 | Pemilik mengubah harga | berhasil; tercatat di audit (aktor, waktu) | | |
| T09 | Void/refund oleh pemilik | tercatat di audit trail | | |
| T10 | Akses objek akun lain (IDOR) | ditolak | | |
| T11 | Akses tanpa login | 401/redirect login | | |
| T12 | Input tidak valid | 4xx tanpa data tersimpan | | |

## Rancangan teknis yang akan diuji
Transaksi SQLite atomik (BEGIN IMMEDIATE), kolom `idempotency_key` UNIQUE, peran kasir/pemilik, tabel `audit_log`.
