# Status Temuan Revisi — BrewPoint (M03–M04)

Diperbarui: 09-11-2026
Kolom Status: LULUS = tindakan selesai dan bukti ada di repo; BELUM = tindakan belum selesai atau bukti belum ada; GAGAL = tindakan sudah dicoba dan tidak memenuhi syarat (belum ada saat ini).

| No | Temuan | Tindakan | Bukti | Tanggal | Lulus/Gagal |
|---|---|---|---|---|---|
| 1 | P1 Biaya (ev07) | Isi tanggal pengambilan Azure Pricing Calculator | ev07 header; `img/ev07-kalkulator.png` (jam 09:19 WIB). Screenshot ini menunjukkan kondisi sebelum pembersihan (US$22,38); screenshot kondisi akhir (±US$24,44) menyusul | 09-11-2026 | BELUM (menunggu screenshot kondisi akhir) |
| 2 | P1 Biaya (ev07) | Isi tanggal pembuatan budget alert | ev07 §6; `img/ev07-budget.png` | 09-11-2026 | LULUS |
| 3 | P1 Biaya (ev07) | Screenshot detail peringatan 50% dan 80% | `img/ev07-budget-alert.png` | | BELUM |
| 4 | P1 Biaya (ev07) | Verifikasi SKU IP publik dan penyebab VM/disk US$0; periksa isi grup `cc-p2-...` | `img/ev07-ip-sku.png` (belum ada) | | BELUM |
| 5 | P1 Spesifikasi VM (ev01) | Perbarui SHA commit dasar | ev01 header: 03634c5680ff73faed86987706af7e82241a4183 (`git rev-parse HEAD` di /srv/cc-m03) | 09-11-2026 | LULUS |
| 6 | P1 Spesifikasi VM (ev01) | Siapkan screenshot portal VM, disk, dan NSG; buramkan email, ID langganan, URL | `img/ev01-portal-vm.png`, `img/ev01-portal-disk.png`, `img/ev02-nsg.png` | | BELUM |
| 7 | P1 Domain dan HTTPS (ev02) | Isi jam pemeriksaan sertifikat TLS | ev02 tabel Hasil: 09-11-2026 17:12:25 WIB (`openssl s_client`, diperiksa ulang dari VM) | 09-11-2026 | LULUS |
| 8 | P1 Domain dan HTTPS (ev02) | Screenshot gembok browser pada domain | `img/ev02-gembok.png` | | BELUM |
| 9 | Arsitektur (ev04) | ADR-0001: ganti "Catatan Tugas" menjadi BrewPoint | commit 9a019a3, docs/adr/0001-initial-architecture.md | 09-11-2026 | LULUS |
| 10 | Arsitektur (ev04) | requirements.md: 2 vCPU / 1 GiB / 64 GiB, budget 1 worker + 2 thread | commit 9a019a3, docs/requirements.md | 09-11-2026 | LULUS |
| 11 | Arsitektur (ev04) | Buat ADR-0002 (FQDN, HTTPS, NSG) | docs/adr/0002-fqdn-https-nsg.md (belum di repo) | | BELUM |
| 12 | ev03, ev05, ev06, ev08, ev09 | Commit sebagai template rencana (status tetap BELUM DIUJI) | docs/evidence/ (belum di repo) | | BELUM |
| 13 | ev03, ev05, ev06, ev08, ev09 | Isi hasil uji nyata | menunggu M05 (database, backup, restore, kasir) dan M11 (load test) | | BELUM (di luar cakupan M03–M04) |
