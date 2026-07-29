Wa'alaikumussalam warahmatullahi wabarakatuh.

Tentu, saya sangat bersedia membantu Bapak menyusun konsep dan struktur sistem aplikasi pembelajaran ini. Konsep yang Bapak jabarkan sudah sangat komprehensif, matang, dan berstandar industri (SaaS - *Software as a Service*). Sistem *Role-Based Access Control* (RBAC) dengan 4 level yang Bapak buat sangat tepat untuk skalabilitas sistem sekolah.

Penggunaan **Flutter** (untuk Android & Web) dan **Supabase** (sebagai Backend, Database, Auth, dan Storage) adalah pilihan *tech-stack* yang sangat modern, cepat, dan efisien. Supabase memiliki fitur **Row Level Security (RLS)** di database PostgreSQL-nya yang akan sangat mempermudah pembuatan aturan "Guru hanya bisa melihat data kelasnya sendiri".

Berikut adalah draf **Product Requirements Document (PRD)** dalam format Markdown (`.md`) yang bisa Bapak gunakan sebagai panduan utama (blueprint) bagi *developer* atau tim pengembang.

Saya akan membuatkan filenya sekarang.

```markdown:PRD.md
# PRODUCT REQUIREMENTS DOCUMENT (PRD)
**Project Name:** E-ACCESS (Electronic Assessment & Classroom System)
**Platform:** Web Dashboard (Admin/Guru/Siswa) & Android App (Siswa)
**Tech Stack:** Flutter (Frontend), Supabase (Backend - PostgreSQL, Auth, Storage)
**Theme/UI:** Dark Mode (Electric Blue)

---

## 1. PENDAHULUAN
### 1.1 Tujuan Produk
Membangun platform pembelajaran digital terpadu (LMS & CBT) yang memfasilitasi proses belajar mengajar, pelaksanaan ujian, presensi, dan pemantauan aktivitas siswa secara *real-time*. Sistem ini dirancang dengan hierarki hak akses (RBAC) yang ketat dan analitik pembelajaran yang mendalam.

### 1.2 Target Pengguna
1. **Super Admin** (Manajemen IT/Kepala Sekolah)
2. **Admin** (Tata Usaha/Kurikulum)
3. **Guru** (Pengajar Mata Pelajaran)
4. **Siswa** (Peserta Didik)

---

## 2. ARSITEKTUR HAK AKSES (RBAC)
Sistem menggunakan konsep hierarki (Top-Down Access). Level yang lebih tinggi mewarisi hak akses level di bawahnya. Supabase **Row Level Security (RLS)** akan digunakan untuk membatasi akses data pada level Guru dan Siswa.

### Level 1: Super Admin (Akses 100%)
* Mengelola konfigurasi sistem inti (Logo, Nama Sekolah, dll).
* Mengelola seluruh data pengguna (Super Admin, Admin, Guru, Siswa).
* Monitoring aktivitas log (*Audit Trail*).
* Backup dan Restore Database.
* Memiliki seluruh hak akses Level 2 dan 3 tanpa batasan data.

### Level 2: Admin (Akses ±90%)
* Import/Export seluruh data Guru, Siswa, Kelas, dan Jadwal (Excel/CSV).
* Mengatur pembagian kelas dan jadwal mengajar Guru.
* Monitoring CBT dan Presensi seluruh sekolah secara global.
* Reset password pengguna.
* Memiliki seluruh hak akses Level 3 tanpa batasan rombel.

### Level 3: Guru (Akses ±70% - Terbatas pada Rombel & Mapel yang diampu)
* Membuat kelas virtual dan menambah/menghapus siswa di kelasnya.
* Upload materi (PDF/Modul) dan Video Pembelajaran.
* Membuat dan mengelola CBT (Input manual atau Upload PDF Soal).
* Membuka sesi Presensi online.
* Melihat, merekap, dan mengunduh (export) nilai CBT dan aktivitas siswa.
* Melihat *Learning Analytics* (Durasi belajar, persentase kehadiran) khusus kelasnya.

### Level 4: Siswa
* Mengakses sistem melalui Aplikasi Android atau Browser Web (Lab Komputer).
* Melakukan Presensi sesuai jadwal pelajaran yang aktif.
* Mengakses/mengunduh materi literasi dan menonton video pembelajaran.
* Mengerjakan ujian CBT (Pilihan Ganda & Essay) dengan batasan waktu.
* Melihat rekap nilai dan riwayat kehadiran pribadi.

---

## 3. FITUR UTAMA (CORE FEATURES)

### 3.1 Computer Based Test (CBT)
* **Mode Pembuatan Soal:**
  1. *Manual Entry:* Guru mengetik soal, opsi jawaban (A, B, C, D, E), dan menentukan kunci jawaban di dalam sistem.
  2. *Upload PDF:* Guru mengunggah file soal PDF, lalu hanya memasukkan kunci jawaban di sistem (mempermudah guru yang tidak mau input satu per satu).
* **Tipe Ujian:** Pilihan Ganda & Uraian Singkat (Essay).
* **Pengaturan Ujian:** 
  * Durasi/waktu pengerjaan (*Countdown timer*).
  * Jadwal rilis dan penutupan ujian.
  * Acak soal dan acak opsi jawaban (khusus manual entry).
* **Sistem Penilaian:** Otomatis (untuk PG) dan Manual Grading (untuk Essay oleh Guru).

### 3.2 Manajemen Materi & Video
* **Materi Literasi:** Upload dokumen PDF/Word yang dapat dibaca langsung (in-app PDF viewer).
* **Video Pembelajaran:** Pemutar video terintegrasi (MP4 upload via Supabase Storage atau embed link YouTube).

### 3.3 Presensi (Kehadiran) Online
* Presensi hanya dapat diakses oleh siswa **pada jam pelajaran berlangsung** (terkunci oleh jadwal sistem).
* Opsi validasi: Klik tombol hadir, atau Geo-tagging (opsional ke depan).
* Rekap kehadiran otomatis ke dashboard Guru dan Admin.

### 3.4 Learning Analytics (Pemantauan Aktivitas)
Sistem melacak dan menampilkan data berikut di Dashboard Guru/Admin:
* Total waktu (menit) siswa membuka materi PDF.
* Total waktu (menit) siswa menonton video.
* Waktu Login dan Logout.
* Persentase penyelesaian materi dan kehadiran kelas.

### 3.5 Import & Export Data
* **Import:** Fitur mass-upload via Excel (.xlsx) / CSV untuk data Siswa, Guru, Jadwal, Pembagian Kelas, dan Bank Soal.
* **Export:** Unduh rekap presensi, nilai CBT, dan aktivitas belajar dalam format Excel/PDF.

---

## 4. UI/UX & TEMA APLIKASI
Mengacu pada referensi desain yang disepakati:
* **Tema Warna:** *Electric Blue Dark Mode* (Latar belakang biru gelap/navy dengan aksen biru neon dan putih).
* **Dashboard Web:** Layout admin klasik dengan *sidebar* navigasi di kiri, *topbar* untuk profil/notifikasi, dan *card-based content* di area utama yang menampilkan grafik/chart analitik.
* **Aplikasi Android (Siswa):** 
  * *Bottom Navigation Bar* (Beranda, CBT, Materi, Presensi, Profil).
  * Tampilan *mobile-friendly*, navigasi ikonik, dan indikator progres belajar yang jelas.

---

## 5. SPESIFIKASI TEKNIS & DATABASE (SUPABASE)

### 5.1 Supabase Auth
* Autentikasi menggunakan Email/Password atau *Custom ID* (NISN untuk Siswa, NIP untuk Guru).

### 5.2 Skema Database Relasional (High-Level)
* `users` (id, role, name, nip/nisn, email)
* `classes` (id, name, grade, major)
* `subjects` (id, name, code)
* `class_schedules` (id, class_id, subject_id, teacher_id, day, start_time, end_time)
* `materials` (id, teacher_id, class_id, title, type [pdf/video], file_url)
* `exams` (id, teacher_id, class_id, title, duration, start_time, end_time, pdf_url)
* `exam_questions` (id, exam_id, question_text, options, correct_answer)
* `exam_results` (id, exam_id, student_id, score, answers_json)
* `attendance` (id, schedule_id, student_id, status, timestamp)
* `activity_logs` (id, user_id, action_type, duration_seconds, timestamp)

### 5.3 Supabase Storage (File Management)
* `materi-dokumen`: Bucket untuk menyimpan file PDF.
* `materi-video`: Bucket untuk menyimpan MP4.
* `soal-cbt`: Bucket untuk soal berbasis PDF.

### 5.4 Supabase Row Level Security (RLS) Policies
* **Contoh Policy Guru:** `SELECT, INSERT, UPDATE, DELETE ON exams WHERE teacher_id = auth.uid()`
* **Contoh Policy Siswa:** `SELECT ON materials WHERE class_id = (SELECT class_id FROM users WHERE id = auth.uid())`

---

## 6. FASE PENGEMBANGAN (MILESTONES)

* **Fase 1: UI/UX & Database Design** (Setup Supabase, Skema DB, Slicing UI Web & Mobile).
* **Fase 2: RBAC & Auth** (Login, Role Management, Dashboard berdasarkan Role).
* **Fase 3: Core Academic** (Manajemen Kelas, Jadwal, Materi Literasi, dan Video).
* **Fase 4: CBT Engine & Presensi** (Upload Soal, Timer, Engine Ujian, Logika Presensi).
* **Fase 5: Learning Analytics & Reporting** (Tracking aktivitas, Rekap Excel/PDF).
* **Fase 6: Testing, Bug Fixing, & Deployment** (Rilis ke Web Hosting & Google Play Store).
```eof

```