# 📱 Flutter POS & Praktikum Hub — Pemrograman Mobile 2

Repository tunggal terpadu (**All-in-One Super-App**) yang dirancang untuk menampung dan mengelola seluruh penugasan modul praktikum mata kuliah **Pemrograman Mobile 2** selama satu semester penuh (Modul 2, Modul 3, Modul 4, dan seterusnya). 

Aplikasi ini menggunakan arsitektur **Modular Portal Hub**, sehingga setiap modul praktikum dapat diakses dan diuji secara independen melalui satu aplikasi tanpa perlu membuat project baru di tiap minggunya.

---

## 🧭 Roadmap Modul Praktikum

| Modul | Topik Praktikum | Status |
| :--- | :--- | :--- |
| **Modul 02** | **State & Data Management Review** (`setState`, Model, JSON, Local Storage) | ✅ **Selesai** |
| **Modul 03** | **REST API & Integration Review** (Dio HTTP, Directus BaaS, CRUD Products) | ✅ **Selesai** |
| **Modul 04** | *Akan datang sesuai silabus perkuliahan mingguan* | ⏳ *Upcoming* |
| **Modul 05+** | *Modul lanjutan semester Pemrograman Mobile 2* | ⏳ *Upcoming* |

---

## 🚀 Rincian Modul yang Telah & Sedang Dikembangkan

### 📌 Modul 02 — State & Data Management (Review PM1)
Fokus pada pengelolaan state lokal, pemodelan data, serialisasi JSON, dan penyimpanan persisten offline.
- **State Management**: Penggunaan `setState()` untuk pembaruan UI reaktif.
- **4 Status State UI**:
  - ⏳ **Loading State**: Animasi indikator proses saat memuat data.
  - ❌ **Error State**: Pesan galat interaktif dengan tombol *Coba Lagi* (Retry).
  - 📭 **Empty State**: Tampilan informatif saat data kosong atau pencarian nihil.
  - ✅ **Success State**: Menampilkan data menggunakan `ListView.builder` dan kartu interaktif.
- **Fitur Simple Inventory**:
  - ➕ **Create**: Tambah produk baru melalui form tervalidasi.
  - 👁️ **Read & Detail**: Menampilkan katalog produk dan rincian spesifikasi lengkap.
  - ✏️ **Update**: Edit informasi dan stok produk.
  - 🗑️ **Delete**: Hapus produk dengan dialog konfirmasi.
  - 🔍 **Search**: Pencarian instan (*real-time*) berdasarkan nama dan kategori produk.
- **Data Persistence (Challenge)**: Menyimpan seluruh katalog secara offline menggunakan `shared_preferences` sehingga data tidak hilang saat aplikasi ditutup.

---

### 📌 Modul 03 — REST API & Integration (Review PM1)
Integrasi komunikasi data daring dengan backend BaaS (Directus):
- **HTTP Client**: Menggunakan library `dio`.
- **Backend as a Service (BaaS)**: [pos.cicd.web.id](https://pos.cicd.web.id).
- **CRUD REST API**:
  - `GET /items/products`
  - `POST /items/products`
  - `PATCH /items/products/:id`
  - `DELETE /items/products/:id`
- **Fitur**: Autentikasi / Login token, manajemen asset gambar (`/assets/:id`), Pull-to-refresh, dan Pagination.

---

### 📌 Modul 04 & Seterusnya
Modul praktikum berikutnya akan langsung ditambahkan ke dalam folder modular dan didaftarkan pada menu `PortalMenuScreen` utama aplikasi.

---

## 📂 Struktur Project

```text
lib/
├── main.dart                          # Entry point aplikasi & tema Material 3
├── screens/
│   └── portal_menu_screen.dart        # Portal Menu Utama (pemilihan modul)
├── praktikum2/                        # Modul State & Local Data Management
│   ├── models/
│   │   └── product_model.dart         # Model Product, fromJson, toJson, copyWith
│   ├── data/
│   │   └── dummy_product.dart         # Data awal dummy produk
│   ├── services/
│   │   └── local_storage_service.dart # Layanan SharedPreferences (Offline Storage)
│   ├── widgets/
│   │   └── card_product.dart          # Komponen UI kartu produk
│   └── screens/
│       ├── list_product_screen.dart   # Halaman utama inventaris (4 State & Search)
│       ├── form_product_screen.dart   # Form Tambah & Edit Produk
│       └── detail_product_screen.dart # Halaman rincian produk
└── praktikum3/                        # Modul REST API & Integration (Directus BaaS)
```

---

## 🛠️ Teknologi & Dependencies

- **Framework**: [Flutter](https://flutter.dev/) (Channel stable, Material 3)
- **Language**: [Dart](https://dart.dev/)
- **Dependencies Utama**:
  - [`shared_preferences`](https://pub.dev/packages/shared_preferences): Penyimpanan key-value lokal offline.
  - [`dio`](https://pub.dev/packages/dio): HTTP networking client untuk REST API.
  - [`cupertino_icons`](https://pub.dev/packages/cupertino_icons): Ikon pendukung styling.

---

## 💻 Cara Menjalankan Project

1. **Clone repository ini:**
   ```bash
   git clone https://github.com/omisetiawan/PemrogramanMobile2.git
   cd flutter_application_pos_praktikum
   ```

2. **Pasang dependensi:**
   ```bash
   flutter pub get
   ```

3. **Jalankan pengujian unit (opsional):**
   ```bash
   flutter test
   ```

4. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Kontributor
- **Mahasiswa:** Romi Setiawan
- **NIM:** 2305083
- **Mata Kuliah:** Pemrograman Mobile 2
- **Program Studi:** Rekayasa Perangkat Lunak
- **Tahun Akademik:** 2026

