# SiPatuh — Smart Vehicle Incident Reporting Platform

> Bersama Warga, Membangun Kota Tertib.

SiPatuh merupakan aplikasi monitoring kendaraan dan pelaporan masyarakat berbasis AI yang dirancang untuk membantu pengguna dalam mengelola administrasi kendaraan sekaligus mendukung penataan lalu lintas dan lingkungan kota yang lebih tertib.

Aplikasi ini memanfaatkan teknologi **Computer Vision**, **YOLO Object Detection**, dan **OCR (Optical Character Recognition)** untuk mendeteksi serta membaca plat nomor kendaraan secara otomatis dari gambar.

---

# Latar Belakang

Masih banyak masyarakat yang:

- lupa masa berlaku STNK atau plat kendaraan,
- kesulitan melakukan pelaporan kendaraan bermasalah,
- serta kurang memiliki media pelaporan yang cepat dan terstruktur.

Di sisi lain, petugas juga membutuhkan sistem monitoring yang lebih efektif untuk membantu dokumentasi laporan masyarakat terkait kendaraan dan ketertiban lalu lintas.

SiPatuh hadir sebagai solusi berbasis AI yang menggabungkan:

- pengingat administrasi kendaraan,
- pelaporan masyarakat,
- serta dashboard monitoring petugas.

---

# Tujuan Aplikasi

- Membantu masyarakat memantau masa berlaku kendaraan
- Mengurangi keterlambatan administrasi kendaraan
- Mempermudah pelaporan kendaraan bermasalah
- Mendukung konsep smart city berbasis partisipasi masyarakat
- Mengimplementasikan teknologi AI untuk monitoring kendaraan

---

# Fokus SDGs

- **SDG 11** — Kota dan Komunitas Berkelanjutan
- **SDG 16** — Perdamaian, Keadilan, dan Kelembagaan yang Tangguh

---

# Fitur Utama

## Smart Plate Scanner

Pengguna dapat memindai plat nomor kendaraan menggunakan kamera smartphone.

Sistem AI akan:

- mendeteksi area plat menggunakan YOLO,
- membaca teks plat menggunakan OCR,
- mem-parsing informasi kendaraan secara otomatis.

Informasi yang diproses:

- kode wilayah,
- nomor kendaraan,
- kode seri,
- masa berlaku plat kendaraan.

---

## Smart Vehicle Reminder

Pengguna dapat menyimpan kendaraan pribadi secara privat untuk mendapatkan pengingat administrasi kendaraan.

Fitur reminder meliputi:

- pengingat masa berlaku STNK,
- pengingat masa berlaku plat kendaraan,
- countdown jatuh tempo kendaraan,
- notifikasi otomatis.

---

## Push Notification System

SiPatuh menggunakan **Awesome Notifications** untuk memberikan notifikasi lokal secara real-time kepada pengguna.

Notifikasi digunakan untuk:

- reminder masa berlaku kendaraan,
- pengingat administrasi,
- update status laporan,
- pemberitahuan laporan diterima atau ditolak.

---

## Vehicle Incident Reporting

Pengguna dapat melaporkan:

- parkir liar,
- kendaraan terbengkalai,
- plat nomor rusak/tidak terbaca,
- kendaraan mencurigakan,
- dugaan pelanggaran ganjil-genap.

Setiap laporan akan dilengkapi:

- foto kendaraan,
- lokasi GPS,
- timestamp,
- hasil OCR plat kendaraan.

---

## AI-Assisted OCR & Detection

Sistem AI membantu proses identifikasi kendaraan menggunakan:

- YOLOv8 untuk deteksi plat,
- OCR untuk membaca teks plat,
- parsing otomatis informasi kendaraan.

AI hanya membantu proses identifikasi dan dokumentasi, sedangkan validasi akhir tetap dilakukan oleh petugas/admin.

---

## Dashboard Monitoring Admin

Dashboard admin digunakan oleh petugas untuk:

- melihat laporan masyarakat,
- memvalidasi laporan,
- mengubah status laporan,
- melihat statistik pelaporan,
- memonitor lokasi laporan kendaraan.

Status laporan:

- Pending
- In Progress
- Resolved
- Rejected

---

# Alur AI System

## 1. Plate Detection

YOLOv8 mendeteksi area plat nomor kendaraan dari gambar.

## 2. OCR Recognition

OCR membaca teks plat kendaraan.

## 3. Plate Parsing

Sistem memisahkan:

- kode wilayah,
- nomor kendaraan,
- kode seri,
- masa berlaku kendaraan (plat/STNK).

---

# Arsitektur Sistem

## Mobile Application

- Flutter

## Admin Dashboard

- Flutter Web / React

## Backend API

- FastAPI / Flask

## Database & Cloud Service

- Firebase Firestore
- Firebase Storage
- Firebase Authentication
- Supabase Storage

## AI & Computer Vision

- YOLOv8
- EasyOCR
- OpenCV

## Notification Service

- Awesome Notifications

---

# API Service

## Custom REST API

API dibuat menggunakan FastAPI untuk:

- deteksi plat kendaraan,
- OCR processing,
- parsing plat kendaraan,
- manajemen laporan,
- validasi laporan admin.

Endpoint utama:

- `/detect-plate`
- `/parse-plate`
- `/submit-report`
- `/update-report-status`

---

# Struktur Database

## Users

Menyimpan data pengguna aplikasi.

## Vehicles

Menyimpan data kendaraan pribadi pengguna.

## Reports

Menyimpan laporan kendaraan dari masyarakat.

## OCRResults

Menyimpan hasil OCR dan parsing kendaraan.

## Notifications

Menyimpan data notifikasi reminder dan laporan.

---

# Privasi dan Etika

SiPatuh bukan sistem tilang otomatis.

Aplikasi ini merupakan:

> **AI-assisted civic reporting platform**

di mana:

- AI membantu proses identifikasi kendaraan,
- masyarakat membantu dokumentasi laporan,
- validasi dan tindak lanjut tetap dilakukan oleh petugas berwenang.

Pendekatan ini bertujuan menjaga:

- privasi pengguna,
- etika penggunaan AI,
- serta mencegah penyalahgunaan sistem.

---

# Pengembangan Selanjutnya

- Heatmap laporan kendaraan
- Statistik kendaraan pelanggar
- Integrasi smart city dashboard
- Monitoring kendaraan real-time
- Multi-region odd-even validation

---

# Teknologi yang Digunakan

- Flutter
- Firebase
- FastAPI
- YOLOv8
- EasyOCR
- OpenCV
- Awesome Notifications

---
