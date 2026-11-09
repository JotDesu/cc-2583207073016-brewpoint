# Requirements

## Problem Statement
Pencatatan penjualan kedai kopi kecil masih dilakukan manual sehingga
rekap harian lambat, rawan salah catat, dan pemilik tidak dapat memantau
penjualan dari jarak jauh.

Sistem menyediakan kasir dan laporan penjualan berbasis web di cloud
sehingga transaksi tercatat rapi dan dapat dipantau pemilik kapan saja.

## Target Users
- Barista atau kasir kedai kopi
- Pemilik kedai kopi

## Functional Requirements
- FR-01 Sistem menampilkan halaman utama.
- FR-02 Sistem menyediakan health endpoint.
- FR-03 Sistem menampilkan metadata aplikasi.
- FR-04 Kasir dapat mencatat transaksi dari daftar menu (M05).
- FR-05 Pemilik dapat mengelola menu dan harga (M05).
- FR-06 Pemilik dapat melihat laporan penjualan harian (M05).
- FR-07 Pemilik login sebelum mengakses dashboard (M10).

## Non-Functional Requirements
- NFR-01 backend loopback-only
- NFR-02 application managed by systemd
- NFR-03 public request through reverse proxy
- NFR-04 no secret in repository

## Constraints
- 2 vCPU
- 1 GiB RAM
- 64 GiB disk (SSD Premium)
- Budget desain aplikasi: 1 worker + 2 thread
- Ubuntu Server 24.04
- public IPv4

## Acceptance Criteria M03
- [x] first deployment accessible
- [x] health endpoint works
