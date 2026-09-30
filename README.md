# 📱 Flutter POS & Praktikum Hub — Pemrograman Mobile 2

Repository tunggal terpadu (**All-in-One Super-App**) yang dirancang untuk menampung dan mengelola seluruh penugasan modul praktikum mata kuliah **Pemrograman Mobile 2** selama satu semester penuh (Modul 2, Modul 3, Modul 4, dan seterusnya). 

Aplikasi ini menggunakan arsitektur **Modular Portal Hub**, sehingga setiap modul praktikum dapat diakses dan diuji secara independen melalui satu aplikasi tanpa perlu membuat project baru di tiap minggunya.

---

## 🧭 Roadmap Modul Praktikum

| Modul | Topik Praktikum | Status |
| :--- | :--- | :--- |
| **Modul 02** | **State & Data Management Review** (`setState`, Model, JSON, Local Storage) | ✅ **Selesai** |
| **Modul 03** | **REST API & Integration Review** (Dio HTTP, Directus BaaS, CRUD Products) | ✅ **Selesai** |
| **Modul 04** | **Advance State Management (Redux)** (Redux Store, Thunk, Pure Reducers, StoreConnector) | ✅ **Selesai** |
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

### 📌 Modul 04 — Advance State Management (Redux)
Refactoring menyeluruh dari Praktikum 3 dengan memisahkan Business Logic dan State UI secara ketat menggunakan **Redux**:
- **Single Source of Truth**: Seluruh state aplikasi (autentikasi dan katalog produk) tersimpan dalam satu `Store<AppState>`.
- **Unidirectional Data Flow**: Alur data satu arah `View -> Action -> Middleware (Thunk) -> Pure Reducer -> Store -> StoreConnector -> View`.
- **Async Side-Effects (Redux Thunk)**: Operasi asynchronous REST API (Login, Fetch, Create, Update, Delete) ditangani secara elegan via `ThunkAction<AppState>`.
- **Separation of Concerns**: UI screens sepenuhnya murni presentational (`StatelessWidget`), berlangganan data dan mengirim action menggunakan `StoreConnector<AppState, ViewModel>`.
- **Reactive Dashboard & Metric Counter**: Dashboard membaca state produk langsung dari Store secara instant tanpa perlu request HTTP tambahan.
- **Comprehensive Testing**: 22 unit & integration tests yang memvalidasi pure reducers, state immutability, dan async thunk dispatching.

---

## 📂 Struktur Project

```text
lib/
├── main.dart                          # Entry point aplikasi & tema Material 3
├── screens/
│   └── portal_menu_screen.dart        # Portal Menu Utama (pemilihan modul)
├── praktikum2/                        # Modul State & Local Data Management (setState)
├── praktikum3/                        # Modul REST API & Integration (Directus BaaS)
└── praktikum4/                        # Modul Advance State Management (Redux)
    ├── praktikum4_root.dart           # StoreProvider root wrapper
    ├── redux/                         # Arsitektur Redux State Management
    │   ├── app_state.dart             # Root AppState gabungan
    │   ├── app_reducer.dart           # Root reducer murni
    │   ├── store.dart                 # Factory Store & Thunk middleware
    │   ├── auth/                      # Domain Autentikasi Redux
    │   │   ├── auth_state.dart        # Imutable AuthState
    │   │   ├── auth_actions.dart      # Action definitions
    │   │   ├── auth_reducer.dart      # Pure AuthReducer
    │   │   └── auth_thunks.dart       # Async login, logout, persistance thunk
    │   └── product/                   # Domain Katalog Produk Redux
    │       ├── product_state.dart     # Imutable ProductState (4 status states)
    │       ├── product_actions.dart   # Action definitions
    │       ├── product_reducer.dart   # Pure ProductReducer
    │       └── product_thunks.dart    # Async CRUD Thunk actions
    ├── screens/                       # Presentation layer terhubung via StoreConnector
    │   ├── login_redux_screen.dart    # Auth screen dengan Thunk
    │   ├── dashboard_redux_screen.dart# Reactive Dashboard
    │   ├── product_list_redux_screen.dart # Catalog dengan 4 UI states & Search
    │   ├── form_product_redux_screen.dart # Form Add/Edit (POST/PATCH thunk)
    │   └── detail_product_redux_screen.dart # Detail & Delete thunk
    └── widgets/
        └── redux_badge.dart           # Visual indicator arsitektur Redux
```

---

## 🛠️ Teknologi & Dependencies

- **Framework**: [Flutter](https://flutter.dev/) (Channel stable, Material 3)
- **Language**: [Dart](https://dart.dev/)
- **Dependencies Utama**:
  - [`redux`](https://pub.dev/packages/redux): Predictable state container untuk Dart.
  - [`flutter_redux`](https://pub.dev/packages/flutter_redux): Widget bindings (`StoreProvider`, `StoreConnector`).
  - [`redux_thunk`](https://pub.dev/packages/redux_thunk): Middleware untuk async actions.
  - [`dio`](https://pub.dev/packages/dio): HTTP networking client untuk REST API Directus.
  - [`shared_preferences`](https://pub.dev/packages/shared_preferences): Penyimpanan token & session lokal.
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

