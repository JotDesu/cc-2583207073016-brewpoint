# ADR-0001: Initial VPS Deployment Architecture

## Status
Accepted

## Context
Proyek "BrewPoint" dideploy pada Azure Virtual Machine dengan Ubuntu Server 24.04 LTS,
2 vCPU, RAM sekitar 1 GB (892 MiB), disk 61 GB, dan Public IPv4.
RAM menjadi batas utama sehingga stack harus ringan.
Domain dan HTTPS belum digunakan pada tahap ini (dijadwalkan M04).

## Decision
- Aplikasi: Flask (Python 3.12)
- Application server: Gunicorn, 1 worker + 2 thread, bind ke 127.0.0.1:8000
- Service manager: systemd (cc-m03.service)
- Reverse proxy: Caddy pada port 80
- Firewall: UFW + Azure Network Security Group
- Version control: Git + GitHub (deploy key untuk VM)

## Alternatives
1. Node.js + PM2: perlu runtime tambahan dan tidak lebih sederhana untuk kebutuhan ini.
2. NGINX + Gunicorn: valid, tetapi konfigurasi HTTPS otomatis lebih rumit dibanding Caddy.
3. Docker: containerization adalah capaian pertemuan berikutnya (M06).
4. PHP-FPM: tidak sesuai dengan keputusan memakai Python/Flask.

## Rationale
- Python 3.12 sudah menjadi default Ubuntu 24.04, sehingga tidak perlu instalasi runtime tambahan.
- Gunicorn 1 worker menjaga pemakaian RAM karena memori VM hanya sekitar 1 GB,
  walaupun jumlah vCPU ada 2.
- Gunicorn hanya listen di loopback agar backend tidak dapat diakses langsung dari internet;
  seluruh trafik publik melewati Caddy.
- systemd membuat aplikasi otomatis berjalan setelah reboot dan mudah dipantau lewat journalctl.
- Caddy sederhana dan siap dikembangkan menjadi HTTPS otomatis pada M04.

## Consequences
### Positive
- Footprint kecil (aplikasi memakai sekitar 25 MB RAM).
- Backend tidak terekspos langsung.
- Deployment dapat diulang lewat git pull dan restart service.

### Negative
- 1 worker membatasi konkurensi.
- Masih HTTP (belum terenkripsi) sampai M04.
- Belum ada swap, sehingga RAM yang habis berisiko memicu OOM killer.

## Review Trigger
Review pada M06/M07, atau bila terjadi masalah memori/performa.
