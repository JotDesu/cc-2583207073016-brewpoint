# Evidence EV-01: Inventaris dan Spesifikasi VM Azure

- **Tanggal Pengamatan:** 08 November 2026
- **Nama Komputer/Host:** `cc-m03-2583207073016`
- **Penyedia Cloud:** Microsoft Azure (Azure for Students)
- **SKU VM:** Standard_B2ats_v2 (2 vCPU, 1 GiB RAM)
- **Region:** East Asia
- **Public IPv4:** 65.52.163.162
- **Nama DNS:** brewpoint-andiana.eastasia.cloudapp.azure.com
- **Status Audit:** LULUS (P1-07 Terpenuhi)

## Output Audit Sistem Operasi (Tersanitasi)

### 1. OS & Kernel (`cat /etc/os-release`, `uname -a`)

```text
PRETTY_NAME="Ubuntu 24.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.5 LTS (Noble Numbat)"
Linux cc-m03-2583207073016 7.0.0-1017-azure #17-Ubuntu SMP x86_64
```

### 2. CPU & Memori (`nproc`, `free -h`)

```text
vCPU Count: 2
Memory:
               total        used        free      shared  buff/cache   available
Mem:           887Mi       258Mi       229Mi       1.0Mi       400Mi       629Mi
Swap:          1.0Gi          0B       1.0Gi
```

### 3. Penyimpanan (`df -h /`)

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        61G  4.6G   57G   8% /
```

### 4. Status Port & Service (`ss -ltnp`, `sudo ufw status`)

```text
State      Recv-Q Send-Q Local Address:Port  Peer Address:Port Process
LISTEN     0      511        127.0.0.1:8000       0.0.0.0:*     users:(("gunicorn",pid=...))
LISTEN     0      4096         0.0.0.0:80         0.0.0.0:*     users:(("caddy",pid=...))
LISTEN     0      4096         0.0.0.0:443        0.0.0.0:*     users:(("caddy",pid=...))
LISTEN     0      128          0.0.0.0:22         0.0.0.0:*     users:(("sshd",pid=...))

Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
```
