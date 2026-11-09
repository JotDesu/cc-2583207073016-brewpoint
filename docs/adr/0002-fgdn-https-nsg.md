# ADR-0002: FQDN, HTTPS, dan NSG

- Status: Diterima (diterapkan 08-11-2026)
- Tanggal: 09-11-2026
- Terkait: ADR-0001 (arsitektur awal), `docs/evidence/ev01-vps-spec.md`, `docs/evidence/ev02-https.md`

## Konteks

BrewPoint berjalan pada satu VM Azure (Standard B2ats v2, 2 vCPU, 1 GiB, Ubuntu 24.04, East Asia). Sampai 07-11-2026 aplikasi hanya dilayani lewat HTTP pada alamat IP publik 65.52.163.162. Pengguna (kasir dan pemilik) akan memasukkan kredensial login, sehingga lalu lintas harus dienkripsi. Sertifikat TLS yang tepercaya mensyaratkan nama host, bukan alamat IP.

Batasan: kredit Azure for Students terbatas (lihat `ev07-tco-12bulan.md`), tidak ada anggaran untuk membeli domain, dan RAM hanya 1 GiB sehingga komponen tambahan harus ringan.

## Keputusan

1. **Nama host:** memakai label DNS bawaan Azure pada IP publik VM: `brewpoint-andiana.eastasia.cloudapp.azure.com`. Biayanya nol dan langsung dapat di-resolve.
2. **TLS:** Caddy sebagai reverse proxy di depan aplikasi. Caddy memperoleh dan memperbarui sertifikat Let's Encrypt secara otomatis. Sertifikat awal berlaku 08-11-2026 s.d. 06-02-2027.
3. **Redirect:** HTTP port 80 dialihkan ke HTTPS dengan status 308. Pada 09-11-2026 hasil uji: `HTTP/1.1 308 Permanent Redirect` ke `https://brewpoint-andiana.eastasia.cloudapp.azure.com/`.
4. **Backend:** Gunicorn tetap hanya mendengarkan `127.0.0.1:8000`. Hanya Caddy yang terbuka ke publik.
5. **NSG `andiana-nsg`:** inbound TCP 22 (prioritas 300), 80 (320), dan 443 (340), sumber "Apa saja". Lapisan kedua di VM: UFW default deny incoming, mengizinkan 22/tcp, 80/tcp, dan 443/tcp.
6. **SSH:** hanya kunci publik. `PermitRootLogin no`, `PasswordAuthentication no`, `AllowUsers andiana`.

Konfigurasi Caddy:

```
brewpoint-andiana.eastasia.cloudapp.azure.com {
    encode zstd gzip
    reverse_proxy 127.0.0.1:8000
}
```

Rollback: `sudo cp /etc/caddy/Caddyfile.bak /etc/caddy/Caddyfile && sudo systemctl reload caddy`.

## Alternatif yang dipertimbangkan

[ISI: alternatif yang kamu pertimbangkan saat memutuskan, misalnya domain sendiri atau Nginx + certbot. Tidak ada di berkas bukti, jadi tidak saya karang.]

## Konsekuensi

Positif:
- HTTPS valid tanpa biaya tambahan; hasil uji nslookup, redirect, dan sertifikat LULUS (`ev02-https.md`).
- Perpanjangan sertifikat otomatis oleh Caddy.
- Backend tidak terpapar langsung ke internet.

Negatif dan risiko:
- Nama host berakhiran `cloudapp.azure.com` terikat pada IP publik Azure; bila IP dihapus atau dibuat ulang, nama dan sertifikat ikut berubah.
- Penerbitan dan perpanjangan sertifikat mensyaratkan port 80 dan 443 tetap terbuka dari internet.
- Port 22 terbuka untuk semua alamat. Mitigasi saat ini: login kunci saja. Rencana: batasi sumber IP di NSG, dengan hati-hati agar tidak mengunci akses sendiri.
- NSG hanya mengizinkan TCP 443. Caddy mengiklankan HTTP/3 lewat `Alt-Svc`, tetapi HTTP/3 memakai UDP 443, sehingga klien akan kembali ke HTTP/1.1 atau HTTP/2. Tidak menyebabkan kegagalan, hanya HTTP/3 tidak termanfaatkan.
- IP publik Standar statis menimbulkan biaya sekitar US$3,65 per bulan (lihat `ev07-tco-12bulan.md`).

Tindak lanjut:
- Pantau masa berlaku sertifikat tiap bulan (`journalctl -u caddy` atau tanggal NotAfter).
- Batasi sumber SSH di NSG sebelum pilot.
- Ubah `APP_ENV` dari `development` ke `production` sebelum pilot.
