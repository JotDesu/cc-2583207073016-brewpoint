# EV-02 — FQDN, DNS, TLS, dan Redirect HTTP→HTTPS

Status: SEBAGIAN DIUJI (DNS, redirect, dan sertifikat LULUS; screenshot gembok browser menunggu)
FQDN: brewpoint-andiana.eastasia.cloudapp.azure.com (label DNS pada IP publik Azure, 65.52.163.162)

## Bukti yang sudah ada
- HTTP publik berfungsi sebelum HTTPS (log Gunicorn 07-11-2026: GET / → 200 dari iPhone). Lihat m04/network-baseline.txt dan m03/.
- Label DNS terlihat di portal (Nama DNS = FQDN di atas). Screenshot: `img/ev01-portal-vm.png`.
- NSG `andiana-nsg` mengizinkan inbound TCP 22, 80, dan 443 (prioritas 300, 320, 340; sumber "Apa saja"). Screenshot: `img/ev02-nsg.png`.
- Caddy dimuat ulang 08-11-2026 23:14 WIB dan memperoleh sertifikat Let's Encrypt (log di m04/ev02-raw-output.txt).
- Port 443 listen (`ss -lnt`), backend tetap hanya di 127.0.0.1:8000.

## Langkah (sudah dijalankan)
1. Azure Portal → IP publik VM → Konfigurasi → Label nama DNS = `brewpoint-andiana` → Simpan.
2. Azure Portal → VM → Jaringan → pastikan aturan inbound NSG mengizinkan TCP 80 dan 443 (screenshot, buramkan ID).
3. Di VM, cadangkan dan ubah Caddyfile:
```bash
sudo cp /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak
sudo tee /etc/caddy/Caddyfile >/dev/null <<'EOF'
brewpoint-andiana.eastasia.cloudapp.azure.com {
    encode zstd gzip
    reverse_proxy 127.0.0.1:8000
}
EOF
sudo caddy validate --config /etc/caddy/Caddyfile && sudo systemctl reload caddy
sudo journalctl -u caddy -n 50 --no-pager
```
4. Verifikasi dari laptop (Windows PowerShell; `curl.exe` dipakai karena `curl` adalah alias):
```
nslookup brewpoint-andiana.eastasia.cloudapp.azure.com
curl.exe -Iv http://brewpoint-andiana.eastasia.cloudapp.azure.com
curl.exe -Iv https://brewpoint-andiana.eastasia.cloudapp.azure.com
```
5. Sertifikat diperiksa dengan .NET `SslStream` (PowerShell), perintah di m04/ev02-raw-output.txt.
Rollback: `sudo cp /etc/caddy/Caddyfile.bak /etc/caddy/Caddyfile && sudo systemctl reload caddy`

## Hasil
| Pemeriksaan | Expected | Aktual | Waktu | Status |
|---|---|---|---|---|
| nslookup (setara dig +short) | 65.52.163.162 | Addresses: 65.52.163.162 (juga muncul 64:ff9b::4134:a3a2, alamat NAT64 dari jaringan klien, bukan IPv6 milik VM) | 09-11-2026, sebelum 00:16 WIB (jam tepat tidak dicatat) | LULUS |
| curl -Iv http → https | 308 Location https | `HTTP/1.1 308 Permanent Redirect`; `Location: https://brewpoint-andiana.eastasia.cloudapp.azure.com/`; `Server: Caddy` | 09-11-2026 00:16:04 WIB (header Date 08-11-2026 17:16:04 GMT) | LULUS |
| curl -Iv https | koneksi TLS berhasil tanpa `-k`; 200 OK (HTTP/2 atau HTTP/1.1) | `HTTP/1.1 200 OK`; `Via: 1.1 Caddy`; `Server: gunicorn`; `Alt-Svc: h3=":443"` | 09-11-2026 00:16:15 WIB (header Date 17:16:15 GMT) | LULUS |
| Sertifikat TLS | valid, penerbit dan masa berlaku tercatat | Subject CN=brewpoint-andiana.eastasia.cloudapp.azure.com; Issuer CN=YE1, O=Let's Encrypt, C=US; NotBefore 08-11-2026 22:15:45; NotAfter 06-02-2027 22:15:44 (waktu lokal laptop); `AuthenticateAsClient` tidak mengeluarkan galat (validasi rantai dan nama host berhasil) | 09-11-2026 17:12:25 WIB (diperiksa ulang dari VM dengan `openssl s_client`; hasil identik: CN sama, penerbit CN=YE1, notBefore 08-11-2026 15:15:45 GMT, notAfter 06-02-2027 15:15:44 GMT) | LULUS |
| Screenshot gembok browser | ada | (menunggu) | | BELUM |

## Catatan teknis
- Curl Windows (schannel) hanya menawarkan HTTP/1.1, sehingga hasil berupa HTTP/1.1 200, bukan HTTP/2. Header `Alt-Svc: h3` menunjukkan Caddy melayani HTTP/3. Expected pada tabel diubah menjadi "HTTP/2 atau HTTP/1.1".
- IPv6 publik VM tidak ada (portal). Alamat 64:ff9b:: pada nslookup adalah sintesis NAT64 dari jaringan klien.
- Sertifikat Let's Encrypt berlaku sekitar 90 hari; Caddy memperbarui otomatis (log memuat jendela perpanjangan). Pantau tiap bulan lewat `journalctl -u caddy` atau pemeriksaan tanggal NotAfter.
- Aturan SSH (22) pada NSG masih "Apa saja"; lihat isu tersisa di ev01.

## Isu tersisa
1. Screenshot gembok dan detail sertifikat browser: `img/ev02-gembok.png`.
2. ADR-0002 (FQDN, HTTPS, NSG): `docs/adr/0002-fqdn-https-nsg.md`.
