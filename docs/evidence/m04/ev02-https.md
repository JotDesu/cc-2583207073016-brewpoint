# Evidence EV-02: Validasi Domain DNS, TLS/HTTPS, dan Reverse Proxy

- **Tanggal Pengujian:** 08 November 2026
- **FQDN / Domain:** brewpoint-andiana.eastasia.cloudapp.azure.com
- **IP Publik Azure:** 65.52.163.162
- **Target Endpoint:** https://brewpoint-andiana.eastasia.cloudapp.azure.com/health
- **Status Audit:** LULUS (P1-03 Terpenuhi)

## 1. Resolusi DNS A Record (`dig +short`)

```text
$ dig +short brewpoint-andiana.eastasia.cloudapp.azure.com
65.52.163.162
```

Hasil: Domain FQDN Azure berhasil di-resolve tepat ke IP Publik 65.52.163.162.

## 2. Log Hasil Uji cURL TLS & Reverse Proxy (`curl -Iv`)

```text
* Host brewpoint-andiana.eastasia.cloudapp.azure.com:443 was resolved.
* IPv4: 65.52.163.162
* Connected to brewpoint-andiana.eastasia.cloudapp.azure.com (65.52.163.162) port 443
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* SSL connection using TLSv1.3 / TLS_AES_128_GCM_SHA256
* Server certificate:
*  subject: CN=brewpoint-andiana.eastasia.cloudapp.azure.com
*  start date: Nov  8 15:15:45 2026 GMT
*  expire date: Feb  6 15:15:44 2027 GMT
*  issuer: C=US; O=Let's Encrypt; CN=YE1
*  SSL certificate verify ok.
> HEAD /health HTTP/2
> Host: brewpoint-andiana.eastasia.cloudapp.azure.com
> User-Agent: curl/8.5.0
> Accept: */*
< HTTP/2 200
< alt-svc: h3=":443"; ma=2592000
< content-type: application/json
< date: Sun, 08 Nov 2026 16:16:15 GMT
< server: gunicorn
< via: 1.1 Caddy
< content-length: 91
```

## 3. Pengalihan Otomatis HTTP -> HTTPS

Caddy secara otomatis mengkonfigurasi pengalihan lalu lintas dari port 80 (HTTP) ke port 443 (HTTPS TLS) melalui mekanisme Caddy Auto-HTTPS.

## 4. Kesimpulan Evaluasi

1. Resolusi DNS A record `brewpoint-andiana.eastasia.cloudapp.azure.com` mengarah tepat ke IP 65.52.163.162.
2. Sertifikat TLS/SSL aktif secara otomatis via Let's Encrypt melalui Caddy Auto-HTTPS.
3. Permintaan HTTPS di-forward dengan benar oleh Caddy reverse proxy ke Gunicorn backend dan mengembalikan HTTP/2 200 OK.
