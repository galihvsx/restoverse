# TODO – Restoverse (Dcresto)

Catatan: Fokus hanya menuliskan apa saja yang harus dikerjakan. Tidak memakai built-in task manager. Checklist ditandai saat sudah selesai.

## 0) Persiapan Umum
- [ ] Buat branch baru untuk pengembangan fitur lanjutan: `feature/extended-features`
- [ ] Tambahkan dependencies berikut ke pubspec.yaml lalu jalankan `flutter pub get`:
  - [ ] `sqflite`, `path` (SQLite)
  - [ ] `shared_preferences` (preferensi tema & pengingat)
  - [ ] `flutter_local_notifications`, `timezone` (notifikasi terjadwal)
- [ ] Tambahkan entry navigasi ke halaman Favorites dan Settings (mis. melalui AppBar/menu atau bottom navigation) via `core/routes/app_router.dart`

## 1) Fitur Favorites (SQLite CRUD)
Struktur: `lib/features/favorites/` (data/domain/presentation) dan `lib/core/database/`.
- [ ] Buat `lib/core/database/database_helper.dart` untuk inisialisasi SQLite (tabel: `favorites` dengan kolom minimal: id, name, city, rating, pictureId)
- [ ] Implementasi Data Layer
  - [ ] models: `favorite_restaurant_model.dart`
  - [ ] datasources: `favorite_local_datasource.dart` (CRUD dengan sqflite)
  - [ ] repositories: `favorite_repository_impl.dart`
- [ ] Implementasi Domain Layer
  - [ ] entities: `favorite_restaurant.dart`
  - [ ] repositories: `favorite_repository.dart`
  - [ ] usecases: `add_favorite.dart`, `remove_favorite.dart`, `get_favorites.dart`, `is_favorite.dart`
- [ ] Implementasi Presentation Layer
  - [ ] providers: `favorite_provider.dart`
  - [ ] pages: `favorites_page.dart`
  - [ ] widgets: `favorite_card.dart`
- [ ] Integrasi UI
  - [ ] Tambahkan tombol/ikon favorit di List & Detail Restoran (toggle add/remove)
  - [ ] Navigasi ke `favorites_page`
- [ ] Validasi & Error Handling (duplikasi, kegagalan I/O)

## 2) Fitur Settings (Theme & Daily Reminder)
Struktur: `lib/features/settings/` dan `lib/core/preferences/`.
- [ ] Buat `lib/core/preferences/preferences_helper.dart` untuk wrapper `shared_preferences`
- [ ] Implementasi Data & Domain
  - [ ] datasources: `settings_local_datasource.dart`
  - [ ] repositories: `settings_repository.dart`, `settings_repository_impl.dart`
  - [ ] usecases: `get_theme_setting.dart`, `save_theme_setting.dart`, `get_reminder_setting.dart`, `save_reminder_setting.dart`
- [ ] Implementasi Providers
  - [ ] `theme_provider.dart` (manage ThemeMode + persist ke shared_prefs)
  - [ ] `reminder_provider.dart` (manage toggle pengingat harian)
- [ ] Implementasi UI Settings
  - [ ] `settings_page.dart` berisi dua switch: Dark Mode dan Daily Reminder (11:00 AM)
  - [ ] Pastikan `MaterialApp` membaca ThemeMode dari `ThemeProvider` (apply ke `theme`, `darkTheme`, `themeMode`)

## 3) Notifikasi Harian (flutter_local_notifications + timezone)
Struktur: `lib/core/notifications/`.
- [ ] Buat `notification_helper.dart` untuk inisialisasi plugin dan helper schedule/cancel
- [ ] Inisialisasi di `main.dart` (request permission iOS/Android 13+)
- [ ] Konfigurasi Android:
  - [ ] Tambahkan permission POST_NOTIFICATIONS untuk Android 13+
  - [ ] Pastikan konfigurasi channel/receiver sesuai dokumentasi plugin di AndroidManifest
- [ ] Implementasi jadwal notifikasi harian 11:00 menggunakan `zonedSchedule` (timezone lokal)
- [ ] Integrasi dengan `reminder_provider.dart` (ON = schedule, OFF = cancel)

## 4) Formulir Penilaian (Add Review)
Struktur: `lib/features/review/`.
- [ ] Data Layer: `review_remote_datasource.dart` (Dio POST /review), `review_model.dart`, `review_repository_impl.dart`
- [ ] Domain Layer: `review.dart`, `review_repository.dart`, `add_review.dart`
- [ ] Presentation: `review_provider.dart`, `review_form.dart`
- [ ] Integrasi di Halaman Detail Restoran: tampilkan `review_form.dart` + update daftar `customerReviews` saat sukses
- [ ] Validasi input (nama, review), tampilkan feedback sukses/gagal

## 5) Testing
- [ ] Siapkan helper test: `test/helpers/test_helper.dart` (Mockito, register fallback)
- [ ] Generate mocks: jalankan `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Tulis unit test untuk `RestaurantListProvider`:
  - [ ] State awal terdefinisi benar
  - [ ] Berhasil mengambil data (mengembalikan list)
  - [ ] Gagal mengambil data (mengembalikan error state)
- [ ] Tulis test minimal untuk provider baru:
  - [ ] `FavoriteProvider` (CRUD local success/error)
  - [ ] `ThemeProvider` (persist & restore ThemeMode)
  - [ ] `ReminderProvider` (schedule/cancel dipanggil sesuai toggle)
- [ ] Jalankan test: `flutter test`

## 6) Integrasi & QA
- [ ] Tambahkan route untuk `favorites_page` dan `settings_page` di `app_router.dart`
- [ ] Tambahkan akses UI ke Favorites & Settings (ikon/menu)
- [ ] Pastikan tidak ada breaking change pada fitur inti (list, detail, splash, animasi)
- [ ] Lint & format: `dart fix --apply` dan `dart format .`
- [ ] Uji manual alur utama:
  - [ ] Add/Remove favorite dari List & Detail
  - [ ] Buka Favorites Page (menampilkan data dari SQLite)
  - [ ] Ubah tema & persist setelah restart app
  - [ ] Aktifkan reminder, verifikasi notifikasi muncul pukul 11:00 (atau lakukan trigger uji dengan jadwal dekat)
  - [ ] Kirim review dan verifikasi daftar review terupdate

## 7) Rilis Internal
- [ ] Update changelog ringkas di PR description
- [ ] Minta review kode
- [ ] Setelah approve, merge `feature/extended-features` ke branch utama