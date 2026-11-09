# EV-04 — Arsitektur dan ADR

Status: ADA. Koreksi 1, 2, dan ADR-0002 SELESAI (09-11-2026). ADR-0003 menunggu M05.
- Diagram: docs/architecture.md (v0.1)
- ADR: docs/adr/0001-initial-architecture.md (tag m03, commit 7d40415)

## Koreksi dan status
| No | Koreksi | Bukti | Tanggal | Status |
|---|---|---|---|---|
| 1 | ADR-0001 bagian Context: "Catatan Tugas" diganti BrewPoint (baris 7) | commit 9a019a3, `git diff --stat` (1 baris berubah) | 09-11-2026 | SELESAI |
| 2 | docs/requirements.md bagian Constraints: 1 vCPU / 1 GB / 20 GB diganti 2 vCPU / 1 GiB / 64 GiB (SSD Premium); ditambah budget desain 1 worker + 2 thread | commit 9a019a3 (7 baris berubah) | 09-11-2026 | SELESAI |
| 3a | ADR-0002 (FQDN, HTTPS, NSG) | docs/adr/0002-fqdn-https-nsg.md (di repo) | 09-11-2026 | SELESAI |
| 3b | ADR-0003 (SQLite dan backup) | | | MENUNGGU M05 |

Nilai di requirements.md bersumber dari ev01 (2 vCPU, 1 GiB, disk OS 64 GiB SSD Premium; cc-m03.service 1 worker + 2 thread).
