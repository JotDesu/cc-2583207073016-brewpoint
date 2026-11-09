# EV-07 — TCO 12 Bulan, Kredit, dan Budget Alert

Status: DRAF TERISI (data portal, kalkulator resmi, dan anggaran ada; 5 hal masih terbuka, lihat bagian "Isu tersisa")
Kurs ASUMSI Rp16.000/USD (ganti dengan kurs BI bertanggal bila diminta).
Kalkulator: Azure Pricing Calculator, region East Asia, mata uang USD, diambil pada **09-11-2026, pukul 09:19 WIB** (jam sistem pada screenshot).

## 1. Fakta portal (screenshot: img/ev07-*.png; email dan ID langganan dikaburkan)
| Item | Nilai | Sumber |
|---|---|---|
| Kredit tersedia | US$93 dari US$100 (per 07-11-2026) | Halaman Pendidikan / portal |
| Kedaluwarsa kredit | 18-09-2027 (315 hari per 07-11-2026) | Portal |
| Biaya aktual kumulatif (Agu–sekarang) | US$6,73 | Cost Management, Analisis biaya |
| Biaya aktual November | US$0,89 (Virtual Network 0,89; Bandwidth < 0,01; Storage 0,00; Virtual Machines 0,00) | Cost Management |
| Prakiraan November | US$3,60 | Cost Management |
| Biaya per resource (November) | Hanya grup `andiana`; resource `andiana-ip` (IP publik), `andiana` (VM), `andiana_osdisk_1_...` (disk OS). Satu-satunya biaya nyata: kategori Virtual Network (IP publik). VM dan disk: US$0,00 | Analisis biaya, dikelompokkan menurut Sumber daya |
| Anggaran | `brewpoint-budget-5usd`: US$5/bulan, periode bulanan, 01-11-2026 s.d. 18-09-2027 | Cost Management, Anggaran |
| Resource group lain | `cc-p2-...`: US$0,62 pada bulan sebelumnya, US$0 bulan ini; isi belum diperiksa | Analisis biaya |

Screenshot: `img/ev07-cost-per-resource.png`, `img/ev07-budget.png`, `img/ev07-budget-alert.png`, `img/ev07-kalkulator.png`.

## 2. Tarif bruto (sebelum kredit dan kuota gratis)
Sumber utama: Azure Pricing Calculator (East Asia, USD, 730 jam/bulan), tanggal pengambilan di atas.

| Komponen | Satuan | US$/bulan | Rp/bulan | Status |
|---|---|---|---|---|
| VM Standard_B2ats_v2 (Linux) | US$0,0131/jam × 730 | 9,56 | ±152.960 | Terverifikasi kalkulator resmi; sama dengan azurespeed.com (Azure Retail Prices API) |
| Disk OS Premium SSD P6 64 GiB (LRS) | 1 disk | 11,23 (tarif 11,227) | ±179.680 | Terverifikasi kalkulator resmi |
| IPv4 publik Standar (statis) | 1 alamat × 730 jam (US$0,005/jam) | 3,65 | ±58.400 | Terverifikasi kalkulator; prakiraan portal US$3,60 (720 jam) |
| Backup Blob LRS | < 1 GB | ±0,50 | ±8.000 | ASUMSI; tampilan Pendidikan menyebut Blob gratis, batas belum dicek |
| Instance uji restore (sementara) | 2–4 jam × US$0,0131/jam | ±0,03–0,05 per uji | ±500–800 per uji | ASUMSI; belum termasuk IP dan disk VM uji; hapus VM dan disk setelah uji |
| FQDN Azure (label DNS pada IP publik) | gratis | 0 | 0 | Terealisasi (nama DNS terlihat di portal) |
| **Total bruto** | | **±24,94** | **±399.040** | |
| Kontingensi 10% | | ±2,49 | ±39.904 | Kebijakan kelas |
| **Total bruto + kontingensi** | | **±27,43** | **±438.944** | |

TCO 12 bulan: bruto ±Rp4,79 juta; dengan kontingensi ±Rp5,27 juta (399.040 × 12 = 4.788.480; × 1,1 = 5.267.328).
Catatan: angka lama pada versi sebelumnya (±Rp2,89 juta) belum memasukkan disk Premium, sehingga tidak berlaku lagi.

Catatan screenshot: `img/ev07-kalkulator.png` (jam sistem 09:19 WIB) menunjukkan kondisi SEBELUM pembersihan: total US$22,38 = VM 9,56 + disk P6 11,23 + disk Standard HDD S4 1,59, dengan IP Statis masih 0 alamat. Angka US$24,44 di bawah adalah hasil sesudah pembersihan dan penambahan IP; screenshot kondisi akhir menyusul (`img/ev07-kalkulator-final.png`).

Catatan kalkulator: item bawaan (VM D2 v3 dan disk Standard HDD S4) sudah dihapus dari estimasi. Total header kalkulator setelah pembersihan: US$24,44 (VM + disk + IP; tanpa backup). Catatan di kalkulator menyebut tarif pratinjau IP publik Standar; tarif IP dapat berubah.

## 3. Rumus umur kredit
Umur kredit (bulan) = sisa kredit ÷ biaya bulanan yang ditagih.
Batas peringatan: sisa kredit < US$20 tercapai setelah (93 − 20) ÷ biaya bulanan.

## 4. Skenario kredit (acuan 07-11-2026: sisa US$93)
| Skenario | Dasar | Hasil |
|---|---|---|
| A (laju aktual) | Hanya IP publik yang ditagih: US$3,65/bln. VM dan disk US$0 per portal (penyebab BELUM terverifikasi) | Kredit cukup sampai kedaluwarsa 18-09-2027. Perkiraan sisa saat kedaluwarsa ±US$55 (93 − ±10,3 bulan × 3,65). Berlaku hanya selama VM dan disk tetap US$0 |
| B (semua ditagih penuh) | VM + disk + IP = US$24,44/bln (tanpa backup); US$24,94 dengan backup | 93 ÷ 24,44 = ±3,8 bulan (dengan backup ±3,7 bulan): kredit habis ±awal Maret 2027. Sisa < US$20 tercapai ±3 bulan (±awal Februari 2027) |

Skenario B menggantikan estimasi lama (±7 bulan, ≈ Juni 2027), yang keliru karena belum memasukkan disk.
Periksa tanggal UAS/go-live terhadap awal Februari 2027. Pada skenario B kredit tidak mencukupi untuk 12 bulan penuh.

## 5. Keputusan stop/upgrade
- STOP (hapus VM, disk, IP, dan resource uji) bila: sisa kredit < US$20, ATAU alert 80% anggaran (US$4) tercapai bersamaan dengan VM/disk mulai ditagih, ATAU proyek selesai (evaluasi final M16).
- UPGRADE hanya bila ada sumber dana setelah kredit (belum ada).
- Pantau mingguan: Cost Management, Analisis biaya, kelompokkan menurut Sumber daya. Bila VM atau disk berubah dari US$0, Skenario B mulai berlaku.
- Alert 80% (US$4) berpotensi terpicu karena laju aktual ±US$3,65 mendekati US$4; itu sinyal untuk meninjau biaya, bukan kegagalan.

## 6. Budget alert (bukti)
| Item | Nilai |
|---|---|
| Nama | `brewpoint-budget-5usd` |
| Jumlah | US$5/bulan |
| Periode | Bulanan, 01-11-2026 s.d. 18-09-2027 |
| Peringatan | 50% (US$2,50) dan 80% (US$4,00), tipe Aktual, penerima: email pemilik akun |
| Dibuat | 09-11-2026 (halaman Buat anggaran 00:29 WIB; muncul di daftar anggaran 00:32 WIB) |
| Bukti | `img/ev07-budget.png` (daftar anggaran), `img/ev07-budget-alert.png` (detail dua peringatan) |

## 7. Isu tersisa (jujur, jangan dihapus sebelum selesai)
1. Penyebab biaya VM dan disk US$0 BELUM terverifikasi untuk langganan Azure for Students. Kotak "jumlah gratis" pada kalkulator adalah promosi akun gratis (kredit US$200), bukan bukti bagi langganan ini. Skenario B dipakai sebagai batas aman.
2. SKU IP publik `andiana-ip` pada portal (Basic atau Standard) belum dicatat; tarif kalkulator memakai Standar. Tambahkan screenshot properti IP.
3. Kondisi peringatan 50% dan 80% perlu dibuktikan lewat halaman detail anggaran (`img/ev07-budget-alert.png`).
4. Resource group `cc-p2-...` (US$0,62 bulan lalu): isi belum diperiksa. Jangan dihapus sebelum dipastikan tidak dipakai.
5. Backup Blob dan batas gratis penyimpanan masih ASUMSI; verifikasi setelah ev05 dijalankan.

## 8. Tindakan wajib (status)
1. Buat budget US$5/bulan, alert 50% dan 80%, lalu screenshot: SELESAI (daftar anggaran). Screenshot detail alert: BELUM.
2. Cost analysis dikelompokkan menurut Sumber daya + screenshot: SELESAI.
3. Cek harga VM dan disk di Azure Pricing Calculator + catat tanggal: SELESAI (isi tanggal di atas).
4. Verifikasi SKU IP dan penyebab VM/disk US$0: BELUM.
