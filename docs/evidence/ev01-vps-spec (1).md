# EV-01 — Spesifikasi dan Inventaris VPS

Status: DRAF (data terukur; commit setelah screenshot portal diburamkan)
Tanggal pengamatan: 07-11-2026 20:27–20:32 WIB (inventaris awal); pembaruan DNS/HTTPS/NSG: 08–09-11-2026 (bagian 7)
Commit dasar: 03634c5680ff73faed86987706af7e82241a4183 (tag m04; 08-11-2026 23:49 WIB; repo /srv/cc-m03; `git rev-parse HEAD` dijalankan 09-11-2026)

## 1. Metadata VM (portal Azure)
| Item | Nilai |
|---|---|
| Nama VM / resource group | andiana / andiana |
| Hostname OS | cc-m03-2583207073016 |
| Status / region | Beroperasi / East Asia |
| Ukuran | Standard B2ats v2 (2 vCPU, 1 GiB) |
| OS | Linux (Ubuntu 24.04) |
| IPv4 publik | 65.52.163.162 |
| IPv6 publik | Tidak ada (portal: Alamat IP publik IPv6 = "-") |
| Nama DNS | brewpoint-andiana.eastasia.cloudapp.azure.com (portal; label aktif paling lambat 08-11-2026 23:14 WIB, saat sertifikat terbit; sebelumnya "Tidak dikonfigurasi" per 07-11-2026) |
| NSG | andiana-nsg (dilampirkan ke antarmuka jaringan andiana980); inbound: 300 SSH TCP 22, 320 HTTP TCP 80, 340 HTTPS TCP 443; sumber "Apa saja"; semua Allow |
| VNet/subnet | andiana-vnet/default |
| Dibuat | 18-09-2026 09:24 UTC |
| Disk OS | 64 GiB, SSD Premium |
| Langganan | Azure for Students |

Screenshot: simpan sebagai `img/ev01-portal-vm.png`, `img/ev01-portal-disk.png`, dan `img/ev02-nsg.png`. BURAMKAN email akun, ID langganan, dan URL portal sebelum commit.

## 2. Output di VM (FAKTA, 07-11-2026)
```
date            : Sat Nov 7 20:27:42 WIB 2026
os-release      : Ubuntu 24.04.5 LTS (Noble Numbat)
uname -r        : 7.0.0-1017-azure
nproc           : 2
free -h         : Mem total 887Mi, used 258Mi, free 36Mi, buff/cache 618Mi, available 629Mi; Swap 1.0Gi (used 65Mi)
lsblk           : sda 64G; sda1 63G (/); sda15 106M (/boot/efi); sda16 913M (/boot)
df -h /         : /dev/root 61G, used 4.6G, avail 57G, 8%
```

## 3. Port, firewall, SSH, service (07-11-2026; pembaruan 443 dan Caddyfile ada di bagian 7)
```
ss -lnt  : LISTEN 0.0.0.0:22, *:80, 127.0.0.1:8000, 127.0.0.1:2019, 127.0.0.53:53, 127.0.0.54:53, [::]:22
ufw      : active; default deny incoming; ALLOW 22/tcp (OpenSSH), 80/tcp, 443/tcp (v4 dan v6)
sshd -T  : permitrootlogin no; passwordauthentication no; kbdinteractiveauthentication no; pubkeyauthentication yes; allowusers andiana
swapon   : /swapfile 1024M
cc-m03.service : enabled; active (running) sejak Fri 2026-10-23 06:11:12 WIB; 1 worker + 2 thread; RAM 22,4 MB (puncak 37,2 MB)
Caddyfile (07-11): :80 { encode zstd gzip; reverse_proxy 127.0.0.1:8000 }
/health  : {"environment":"development","status":"ok","timestamp":"2026-11-07T13:32:39+00:00"}
```

## 4. Cara mengulang pemeriksaan
```bash
cd /srv/cc-m03
date; head -4 /etc/os-release; uname -r; nproc; free -h; lsblk; df -h /
ss -lnt; sudo ufw status verbose
sudo sshd -T | grep -Ei '^(permitrootlogin|passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|allowusers)'
systemctl status cc-m03 --no-pager | head -12; cat /etc/caddy/Caddyfile
curl -s http://127.0.0.1:8000/health
git log -1 --format="%H | %ci | %s"; git tag
```

## 5. Sanitasi
Tidak ada password, key, token, atau cookie pada berkas ini. Email akun dan ID langganan hanya ada pada screenshot dan harus diburamkan.

## 6. Isu tersisa
- Hostname OS (cc-m03-...) berbeda dari nama VM di portal (andiana); sengaja, tidak memengaruhi fungsi.
- APP_ENV masih `development` pada pengamatan 07-11-2026; ubah ke `production` sebelum pilot.
- Port 22 terbuka untuk semua alamat (NSG menandai aturan SSH dengan peringatan; mitigasi: key-only; rencana batasi sumber IP di NSG, hati-hati agar tidak mengunci akses sendiri).

## 7. Pembaruan 08–09-11-2026 (DNS, HTTPS, NSG)
Detail uji dan hasil lengkap: `ev02-https.md`; output mentah: `m04/ev02-raw-output.txt`.
```
ss -lnt | grep -E ':(80|443)' (VM, setelah reload Caddy 08-11-2026 23:14 WIB)
  LISTEN 0 2048 127.0.0.1:8000
  LISTEN 0 4096 *:443
  LISTEN 0 4096 *:80
Caddyfile (sesuai ev02): brewpoint-andiana.eastasia.cloudapp.azure.com { encode zstd gzip; reverse_proxy 127.0.0.1:8000 }
Sertifikat: CN=brewpoint-andiana.eastasia.cloudapp.azure.com; penerbit Let's Encrypt (CN=YE1); berlaku 08-11-2026 s.d. 06-02-2027 (waktu lokal laptop)
```
Catatan: port 443 listen sejak 08-11-2026 23:14 WIB; backend tetap hanya di 127.0.0.1:8000.
