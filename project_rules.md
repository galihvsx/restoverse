# Trae rules

- Selalu gunakan mcp tools
- Selalu gunakan built in todo / task manager tools

- Proyek ini akan meminta Anda membuat aplikasi bernama Restoverse, bertemakan Restaurant App. Pastikan membuat aplikasi terbaik Anda dengan kreatif dan inovatif.
- Proyek aplikasi ini harus memenuhi standard karakteristik yang ditentukan.

## Status Implementasi

### ✅ SUDAH DIIMPLEMENTASI
### ❌ BELUM DIIMPLEMENTASI
### 🔄 SEBAGIAN DIIMPLEMENTASI

---

## Fitur Inti (Persyaratan Utama)

### ✅ Halaman Daftar Restoran
- ✅ Membuat satu halaman berisi daftar restoran
- ✅ Informasi daftar restoran didapat dari API
- ✅ Menampilkan item yang mencakup informasi minimal, seperti nama, gambar, kota, dan rating restoran
- **Status**: Sudah diimplementasi (folder `lib/features/restaurant_list/`)

### ✅ Halaman Detail Restoran
- ✅ Membuat satu halaman berisi detail restoran
- ✅ Informasi detail restoran didapat dari API
- ✅ Menampilkan informasi restoran, seperti nama, gambar, deskripsi, kota, alamat, rating, menu makanan, dan minuman
- **Status**: Sudah diimplementasi (folder `lib/features/restaurant_detail/`)

### 🔄 Mengganti Tema Default
- ✅ Menambahkan tema terang dan gelap (ada folder `lib/features/theme/`)
- ✅ Mengubah default font type (menggunakan Google Fonts)
- ✅ Mengubah warna pada tema selain warna default aplikasi
- **Status**: Sebagian diimplementasi (tema dasar ada, tapi belum ada pengaturan untuk switch tema)

### ✅ Indikator Loading
- ✅ Terdapat indikator loading untuk setiap proses pemanggilan API
- ✅ Indikator loading dapat berupa widget CircularProgressIndicator, gambar, ataupun animasi tertentu, seperti Lottie dan Rive
- **Status**: Sudah diimplementasi (ada Lottie animation dan loading widgets)

### ✅ Menggunakan State Management
- ✅ Menggunakan library state management Provider
- ✅ Cukup menggunakan satu state management untuk mengelola state, tidak boleh menggunakan selain provider package
- ✅ Manfaatkan sealed class, khususnya pada saat memanggil Web API
- **Status**: Sudah diimplementasi (Provider sudah ada di dependencies)

### ✅ Menggunakan full animation di setiap transisi atau interaksi user
- ✅ Animasi transisi dan interaksi
- **Status**: Sudah diimplementasi (ada folder `lib/core/animations/`)

### ✅ Menambahkan splash screen aplikasi
- ✅ Splash screen
- **Status**: Sudah diimplementasi (folder `lib/features/splash/`)

### ✅ Menggunakan clean architechture
- ✅ Clean architecture dengan layer data, domain, dan presentation
- **Status**: Sudah diimplementasi (struktur folder mengikuti clean architecture)

---

## Persyaratan Tambahan (Fitur Lanjutan)

### ❌ 1. Halaman Favorit Restoran
- ❌ Membuat halaman khusus untuk menampilkan daftar restoran favorit pengguna
- ❌ Setiap item kartu di halaman daftar favorit harus menampilkan informasi minimal seperti nama, gambar, kota, dan rating restoran
- ❌ Ketika item favorit ditekan, aplikasi harus dapat menavigasi ke halaman detail restoran yang bersangkutan
- ❌ Pengguna harus dapat menambah dan menghapus restoran dari daftar favorit, baik dari halaman daftar favorit maupun dari halaman detail restoran
- ❌ Informasi daftar favorit restoran harus disimpan dan diambil dari database SQLite
- ❌ Menggunakan package `sqflite` untuk operasi database SQLite
- ❌ Implementasi CRUD operations untuk data favorit restoran
- **Status**: Belum diimplementasi (folder `lib/features/favorites/` tidak ada)
- **Dependencies yang dibutuhkan**: `sqflite: ^2.3.0`, `path: ^1.8.3` (belum ada di pubspec.yaml)

### 🔄 2. Pengaturan Tema (Theme Settings)
- 🔄 Sediakan menu pengaturan untuk memungkinkan pengguna beralih antara tema terang (light theme) dan tema gelap (dark theme)
- ❌ Perubahan tema harus disimpan menggunakan `shared_preferences` agar tetap persisten meskipun aplikasi ditutup dan dibuka kembali
- ✅ Pastikan semua komponen antarmuka pengguna tetap terlihat jelas dan dapat digunakan dengan baik di kedua tema
- ❌ Menggunakan package `shared_preferences` untuk penyimpanan preferensi tema
- 🔄 Implementasi ThemeProvider untuk mengelola state tema aplikasi
- **Status**: Sebagian diimplementasi (ThemeProvider ada, tapi belum ada halaman settings dan shared_preferences)
- **Dependencies yang dibutuhkan**: `shared_preferences: ^2.2.2` (belum ada di pubspec.yaml)

### ❌ 3. Pengingat Harian (Daily Reminder)
- ❌ Tambahkan opsi pengaturan di halaman pengaturan untuk mengaktifkan atau menonaktifkan pengingat harian
- ❌ Pengaturan pengingat harian harus disimpan menggunakan `shared_preferences`
- ❌ Tampilkan notifikasi pada pukul 11.00 AM setiap hari menggunakan `Schedule Notification` untuk mengingatkan pengguna tentang makan siang
- ❌ Menggunakan package `flutter_local_notifications` untuk implementasi notifikasi terjadwal
- ❌ Implementasi `zonedSchedule` untuk notifikasi harian yang akurat
- ❌ Konfigurasi AndroidManifest.xml untuk izin notifikasi
- **Status**: Belum diimplementasi
- **Dependencies yang dibutuhkan**: `flutter_local_notifications: ^16.3.2`, `timezone: ^0.9.2` (belum ada di pubspec.yaml)

### 🔄 4. Pengujian (Testing)
- ❌ Terapkan tiga skenario pengujian pada fungsi di dalam `Provider` yang bertanggung jawab untuk mengambil daftar data restoran
- ❌ Skenario pengujian yang harus diimplementasikan:
  1. ❌ Memastikan bahwa `state` awal `Provider` telah didefinisikan dengan benar
  2. ❌ Memastikan bahwa `Provider` mengembalikan daftar restoran yang benar ketika pengambilan data dari API berhasil
  3. ❌ Memastikan bahwa `Provider` mengembalikan kesalahan yang sesuai ketika pengambilan data dari API gagal
- ✅ Menggunakan package `mockito` dan `build_runner` untuk mocking dan code generation
- ❌ Implementasi unit testing untuk Provider dengan mock HTTP client
- **Status**: Sebagian diimplementasi (dependencies ada, tapi test files belum dibuat)
- **Dependencies yang tersedia**: `mockito: ^5.4.6`, `build_runner: ^2.5.4` ✅

### ❌ 5. Formulir Penilaian (Rating Form)
- ❌ Buat formulir di halaman detail restoran yang memungkinkan pengguna untuk mengirimkan penilaian (rating) untuk restoran tersebut
- ❌ Formulir harus terintegrasi dengan API review yang sudah tersedia
- ❌ Implementasi validasi input untuk nama pengguna dan review
- ❌ Tampilkan feedback yang sesuai setelah berhasil mengirim review
- ❌ Update daftar customer reviews secara real-time setelah review berhasil dikirim
- **Status**: Belum diimplementasi (folder `lib/features/review/` tidak ada)

### ✅ 6. Mempertahankan Fungsionalitas Inti
- ✅ Pastikan semua kriteria utama dari proyek sebelumnya tetap berfungsi dan terintegrasi dengan baik
- ✅ Tidak ada breaking changes pada fitur-fitur yang sudah ada
- ✅ Semua fitur baru harus mengikuti arsitektur clean architecture yang sudah diterapkan
- ✅ Konsistensi dalam penggunaan Provider sebagai state management
- ✅ Mempertahankan animasi dan transisi yang sudah ada
- **Status**: Sudah diimplementasi

---

## Dependencies Status

### ✅ Dependencies yang Sudah Ada:
```yaml
# State Management
provider: ^6.1.5 ✅

# HTTP Client
dio: ^5.8.0+1 ✅

# UI Components
cached_network_image: ^3.4.1 ✅
lottie: ^3.3.1 ✅
google_fonts: ^6.2.1 ✅
flutter_rating_bar: ^4.0.1 ✅
skeletonizer: ^2.1.0 ✅

# Utilities
equatable: ^2.0.7 ✅
dartz: ^0.10.1 ✅

# Testing & Code Generation
mockito: ^5.4.6 ✅
build_runner: ^2.5.4 ✅
```

### ❌ Dependencies yang Belum Ada (Perlu Ditambahkan):
```yaml
# Untuk database SQLite
sqflite: ^2.3.0 ❌
path: ^1.8.3 ❌

# Untuk shared preferences
shared_preferences: ^2.2.2 ❌

# Untuk notifikasi lokal
flutter_local_notifications: ^16.3.2 ❌
timezone: ^0.9.2 ❌
```

---

## Struktur Folder Status

### ✅ Struktur yang Sudah Ada:
```
lib/
├── features/
│   ├── restaurant_detail/ ✅
│   ├── restaurant_list/ ✅
│   ├── splash/ ✅
│   └── theme/ ✅
├── core/
│   ├── animations/ ✅
│   ├── constants/ ✅
│   ├── errors/ ✅
│   ├── network/ ✅
│   ├── routes/ ✅
│   ├── services/ ✅
│   ├── themes/ ✅
│   ├── utils/ ✅
│   └── widgets/ ✅
```

### ❌ Struktur yang Belum Ada (Perlu Dibuat):
```
lib/
├── features/
│   ├── favorites/ ❌
│   ├── settings/ ❌
│   └── review/ ❌
├── core/
│   ├── database/ ❌
│   ├── notifications/ ❌
│   └── preferences/ ❌
test/
├── features/
│   ├── restaurant_list/
│   │   └── presentation/
│   │       └── providers/
│   │           └── restaurant_list_provider_test.dart ❌
│   ├── favorites/ ❌
│   └── settings/ ❌
└── helpers/
    └── test_helper.dart ❌
```

---

## Ringkasan Status Implementasi

### ✅ Fitur yang Sudah Lengkap (6/6):
1. ✅ Halaman Daftar Restoran
2. ✅ Halaman Detail Restoran
3. ✅ Indikator Loading
4. ✅ State Management (Provider)
5. ✅ Animasi dan Transisi
6. ✅ Splash Screen
7. ✅ Clean Architecture

### 🔄 Fitur yang Sebagian Diimplementasi (2/5):
1. 🔄 Pengaturan Tema (ThemeProvider ada, tapi belum ada settings page dan shared_preferences)
2. 🔄 Pengujian (Dependencies ada, tapi test files belum dibuat)

### ❌ Fitur yang Belum Diimplementasi (3/5):
1. ❌ Halaman Favorit Restoran
2. ❌ Pengingat Harian
3. ❌ Formulir Penilaian

### Dependencies yang Perlu Ditambahkan: 4 packages
- `sqflite` dan `path` untuk database SQLite
- `shared_preferences` untuk penyimpanan preferensi
- `flutter_local_notifications` dan `timezone` untuk notifikasi

---

Dicoding Restaurant API
Base URL
<https://restaurant-api.dicoding.dev>

Endpoints
Get List of Restaurant
Mendapatkan daftar restoran

URL: /list
Method: GET
Response:
{
  "error": false,
  "message": "success",
  "count": 20,
  "restaurants": [
      {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
      },
      {
          "id": "s1knt6za9kkfw1e867",
          "name": "Kafe Kita",
          "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
          "pictureId": "25",
          "city": "Gorontalo",
          "rating": 4
      }
  ]
}
Get Detail of Restaurant
Mendapatkan detail restoran

URL: /detail/:id
Method: GET
Response:
{
  "error": false,
  "message": "success",
  "restaurant": {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
      "city": "Medan",
      "address": "Jln. Pandeglang no 19",
      "pictureId": "14",
      "categories": [
          {
              "name": "Italia"
          },
          {
              "name": "Modern"
          }
      ],
      "menus": {
          "foods": [
              {
                  "name": "Paket rosemary"
              },
              {
                  "name": "Toastie salmon"
              }
          ],
          "drinks": [
              {
                  "name": "Es krim"
              },
              {
                  "name": "Sirup"
              }
          ]
      },
      "rating": 4.2,
      "customerReviews": [
          {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
          }
      ]
  }
}
Search Restaurant
Mencari restoran berdasarkan nama, kategori, dan menu.

URL: /search?q=<query>
Method: GET
Response:
{
  "error": false,
  "founded": 1,
  "restaurants": [
      {
          "id": "fnfn8mytkpmkfw1e867",
          "name": "Makan mudah",
          "description": "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
          "pictureId": "22",
          "city": "Medan",
          "rating": 3.7
      }
  ]
}
Add Review
Menambahkan review pada restoran

URL: /review
Method: POST
Headers:
Content-Type: application/json
Body:
JSON: {"id": string, "name": string, "review": string}
Response:
{
"error": false,
"message": "success",
"customerReviews": [
  {
    "name": "Ahmad",
    "review": "Tidak rekomendasi untuk pelajar!",
    "date": "13 November 2019"
  },
  {
    "name": "test",
    "review": "makanannya lezat",
    "date": "29 Oktober 2020"
  }
]
}
Restaurant Image
Mendapatkan gambar restoran

Small resolution: <https://restaurant-api.dicoding.dev/images/small/><pictureId>
Medium resolution: <https://restaurant-api.dicoding.dev/images/medium/><pictureId>
Large resolution: <https://restaurant-api.dicoding.dev/images/large/><pictureId>