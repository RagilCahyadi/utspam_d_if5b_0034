# UTS Pengembangan Aplikasi Mobile

**Rahmansyah Ragil Cahyadi (3012310034) IF-5B**

Lecturer: Moch. Nurul Indra Al Fauzan

---

## 📱 Kita Sehat - Aplikasi Pembelian Obat

Aplikasi mobile berbasis Flutter untuk pemesanan obat dengan sistem autentikasi, manajemen transaksi, dan fitur e-receipt. Dikembangkan menggunakan flutter dan menggunakan database lokal SQLite

---

## 🎥 Demo Video

https://github.com/user-attachments/assets/85fd9574-064c-4d0f-a16a-f14f787e89f0

---

## ✨ Fitur Utama

### 1. **Autentikasi Pengguna**
- **Login**: Login menggunakan username dan password
- **Register**: Registrasi akun baru dengan validasi lengkap
- **Logout**: Keluar dari aplikasi dengan konfirmasi

### 2. **Manajemen Profil**
- **Lihat Profil**: Menampilkan informasi lengkap pengguna (username, email, nama, no. telepon, alamat)
- **Edit Profil**: Edit nama lengkap, no. telepon, dan alamat (username dan email tidak dapat diubah)
- **Ubah Password**: Ganti password dengan verifikasi password lama

### 3. **Katalog Obat**
- Menampilkan daftar obat dengan gambar, nama, kategori, dan harga
- Kategori obat: Antibiotik, Analgesik, Vitamin, Antihistamin, Antiseptik
- Desain card yang menarik dengan informasi lengkap

### 4. **Pemesanan Obat**
- **Auto-fill Buyer Name**: Nama pembeli otomatis terisi dari akun yang login
- **Dua Metode Pembelian**:
  - **Beli Langsung**: Pembelian tanpa resep dokter
  - **Pakai Resep**: Pembelian dengan resep dokter (wajib input nomor resep dan foto resep)
- **Upload Foto Resep**: Ambil foto dari kamera atau galeri
- **Input Quantity & Notes**: Jumlah obat dan catatan tambahan
- **Kalkulasi Otomatis**: Total harga dihitung otomatis

### 5. **Riwayat Transaksi**
- **Filter Per User**: Setiap user hanya melihat transaksi miliknya sendiri
- **Status Transaksi**: Success (hijau) atau Cancelled (merah)
- **E-Receipt**: Menampilkan struk digital dengan detail lengkap via bottom sheet
- **Detail Transaksi**: Halaman detail dengan informasi lengkap
- **Edit Transaksi**: Edit quantity, notes, metode pembelian, nomor/foto resep
- **Delete Transaksi**: Hapus transaksi dengan konfirmasi

### 6. **Database Lokal**
- Menggunakan SQLite (SQFlite) untuk penyimpanan data offline
- Tabel: `users` dan `transactions`
- Database migration support (saat ini versi 3)

---

## ✅ Validasi Form

### **Form Register**
- **Username**: Minimal 3 karakter, wajib diisi
- **Password**: Minimal 6 karakter, wajib diisi
- **Confirm Password**: Harus sama dengan password
- **Full Name**: Minimal 3 karakter, wajib diisi
- **Email**: Format email valid, wajib diisi
- **Phone**: Minimal 10 digit, hanya angka, wajib diisi
- **Address**: Minimal 10 karakter, wajib diisi
- **Username Unique**: Tidak boleh sama dengan user yang sudah ada

### **Form Login**
- **Username**: Wajib diisi
- **Password**: Wajib diisi
- **Verifikasi**: Username dan password harus cocok dengan database

### **Form Pembelian**
- **Buyer Name**: Auto-fill dari user login (read-only)
- **Medicine**: Obat harus dipilih
- **Quantity**: Minimal 1, hanya angka, wajib diisi
- **Purchase Method**: Harus memilih salah satu (Beli Langsung/Pakai Resep)
- **Recipe Number**: Wajib diisi jika pakai resep, minimal 5 karakter
- **Recipe Photo**: Wajib diupload jika pakai resep

### **Form Edit Profile**
- **Full Name**: Minimal 3 karakter, wajib diisi
- **Phone**: Minimal 10 digit, hanya angka, wajib diisi
- **Address**: Minimal 10 karakter, wajib diisi
- **Username & Email**: Ditampilkan tapi tidak bisa diedit (disabled)

### **Form Edit Transaction**
- **Quantity**: Minimal 1, wajib diisi
- **Purchase Method**: Harus memilih salah satu
- **Recipe Number**: Wajib jika pakai resep
- **Recipe Photo**: Wajib jika pakai resep (bisa edit/ganti foto)
- **Validasi Status**: Transaksi yang dibatalkan tidak bisa diedit

### **Form Change Password**
- **Current Password**: Wajib diisi, harus sesuai dengan password lama
- **New Password**: Minimal 6 karakter, wajib diisi, tidak boleh sama dengan password lama
- **Confirm Password**: Harus sama dengan password baru

---

## 🎨 Desain & UI

### **Color Scheme**
- **Primary**: Green (`Colors.green`) - untuk tombol utama, AppBar
- **Secondary**: Blue, Orange - untuk tombol edit, change password
- **Danger**: Red - untuk logout, delete, cancel
- **Background**: White dengan gradient pada header

### **Komponen UI**
- **Material Design**: Mengikuti guidelines Material Design 3
- **Rounded Corners**: Border radius 12px pada semua card dan button
- **Icons**: Material Icons untuk visual yang konsisten
- **Cards**: Elevation 2-4 untuk depth
- **Animations**: Smooth transitions antar halaman
- **Responsive**: Layout menyesuaikan ukuran layar

### **Halaman**
1. **Login Page**: Form login dengan ilustrasi
2. **Register Page**: Form registrasi lengkap dengan scrollable view
3. **Home Page**: Dashboard dengan menu grid dan gradient header
4. **Profile Page**: Informasi user dengan card terstruktur
5. **Form Purchase Page**: Form pembelian dengan conditional fields
6. **History Page**: List transaksi dengan status badge
7. **Transaction Detail Page**: Detail lengkap dengan action buttons
8. **Edit Transaction Page**: Form edit dengan pre-filled data
9. **Edit Profile Page**: Form edit profil dengan disabled fields
10. **Change Password Page**: Form ganti password dengan visibility toggle
11. **E-Receipt Bottom Sheet**: Struk digital dengan format invoice

---

## 🛠 Tech Stack

### **Framework & Language**
- **Flutter**: 3.x (Cross-platform mobile framework)
- **Dart**: 3.x (Programming language)

### **Database**
- **SQFlite**: ^2.4.1 (SQLite untuk Flutter)
- **Path**: ^1.9.0 (Path manipulation)

### **Media & Storage**
- **Image Picker**: ^1.1.2 (Camera & gallery access)
- **Path Provider**: ^2.1.5 (Application directory paths)

### **Architecture**
- **DAO Pattern**: Data Access Object untuk abstraksi database
- **Model Classes**: User, Medicine, Transaction dengan enums
- **State Management**: StatefulWidget dengan setState

### **Platform Support**
- Android (Minimum SDK 21 / Android 5.0)
- iOS (Minimum iOS 12.0)

---

## 📁 Struktur Folder

```
lib/
├── main.dart                          # Entry point aplikasi
├── data/
│   ├── models/
│   │   ├── user_model.dart           # Model User
│   │   ├── medicine_model.dart       # Model Medicine & data dummy
│   │   └── transaction_model.dart    # Model Transaction dengan enums
│   └── db/
│       ├── db_helper.dart            # Database helper & migrations
│       ├── user_dao.dart             # User Data Access Object
│       └── transaction_dao.dart      # Transaction Data Access Object
└── presentation/
    ├── login_page.dart               # Halaman login
    ├── register_page.dart            # Halaman registrasi
    ├── home_page.dart                # Halaman dashboard
    ├── profile_page.dart             # Halaman profil user
    ├── edit_profile_page.dart        # Halaman edit profil
    ├── change_password_page.dart     # Halaman ubah password
    ├── form_purchase_page.dart       # Halaman form pembelian
    ├── history_purchase_page.dart    # Halaman riwayat transaksi
    ├── transaction_detail_page.dart  # Halaman detail transaksi
    └── edit_transaction_page.dart    # Halaman edit transaksi

assets/
└── images/                           # Folder untuk gambar obat
    ├── paracetamol.jpg
    ├── amoxicillin.jpg
    ├── vitamin_c.jpg
    └── ... (total 15 gambar obat)

android/                              # Konfigurasi Android
ios/                                  # Konfigurasi iOS
```

---

## 🚀 Cara Menjalankan

### **Prasyarat**
- Flutter SDK (versi 3.0 atau lebih baru)
- Android Studio / VS Code dengan Flutter plugin
- Android Emulator / iOS Simulator / Physical Device
- Dart SDK (included with Flutter)

### **Instalasi**

1. **Clone Repository**
   ```bash
   git clone https://github.com/RagilCahyadi/utspam_d_if5b_0034.git
   cd utspam_d_if5b_0034
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Flutter Setup**
   ```bash
   flutter doctor
   ```

4. **Run Aplikasi**
   
   **Debug Mode** (untuk development):
   ```bash
   flutter run
   ```
   
   **Release Mode** (untuk testing performa):
   ```bash
   flutter run --release
   ```

5. **Build APK** (Android)
   
   **Debug APK**:
   ```bash
   flutter build apk --debug
   ```
   
   **Release APK**:
   ```bash
   flutter build apk --release
   ```
   
   APK akan tersimpan di: `build/app/outputs/flutter-apk/app-release.apk`

6. **Build iOS** (macOS only)
   ```bash
   flutter build ios
   ```

### **Testing**

**Akun Testing** (sudah ada di database):
- Username: `test`
- Password: `123456`

Atau buat akun baru melalui halaman Register.

### **Struktur Database**

**Tabel Users:**
```sql
CREATE TABLE users (
  username TEXT PRIMARY KEY,
  password TEXT NOT NULL,
  fullName TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL
)
```

**Tabel Transactions:**
```sql
CREATE TABLE transactions (
  transactionId TEXT PRIMARY KEY,
  medicineId TEXT NOT NULL,
  medicineName TEXT NOT NULL,
  medicineCategory TEXT NOT NULL,
  medicinePrice REAL NOT NULL,
  medicineImage TEXT NOT NULL,
  buyerName TEXT NOT NULL,
  username TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  totalPrice REAL NOT NULL,
  date TEXT NOT NULL,
  notes TEXT,
  purchaseMethod TEXT NOT NULL,
  recipeNumber TEXT,
  recipeImagePath TEXT,
  status TEXT NOT NULL
)
```
**© 2025 - UTS Pengembangan Aplikasi Mobile**
