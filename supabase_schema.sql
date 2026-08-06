-- ====================================================================
-- E-ACCESS (Electronic Assessment & Classroom System)
-- SUPABASE POSTGRESQL DATABASE SCHEMA & RLS POLICIES
-- Theme: Dark Mode Electric Blue SaaS Architecture
-- ====================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. ENUMS
CREATE TYPE user_role AS ENUM ('Super Admin', 'Admin', 'Guru', 'Siswa');
CREATE TYPE material_type AS ENUM ('pdf', 'video');
CREATE TYPE exam_type AS ENUM ('manual', 'pdf_upload');
CREATE TYPE question_type AS ENUM ('multiple_choice', 'essay');
CREATE TYPE attendance_status AS ENUM ('hadir', 'izin', 'sakit', 'alpa');

-- 3. USERS TABLE (Linked to Auth.Users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    role user_role NOT NULL DEFAULT 'Siswa',
    identifier TEXT UNIQUE, -- NIP for Guru/Admin, NISN for Siswa
    phone TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. CLASSES TABLE (Rombel)
CREATE TABLE public.classes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL, -- e.g., 'X DPIB 1', 'XI TKP 2'
    grade INTEGER NOT NULL, -- 10, 11, 12
    major TEXT NOT NULL, -- DPIB, TKP, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. SUBJECTS TABLE (Mata Pelajaran)
CREATE TABLE public.subjects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. CLASS SCHEDULES TABLE (Jadwal Kelas & Pembagian Guru)
CREATE TABLE public.class_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_id UUID NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    teacher_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL, -- 1 (Senin) - 7 (Minggu)
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. CLASS STUDENTS (Relasi Siswa ke Kelas)
CREATE TABLE public.class_students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_id UUID NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    UNIQUE(class_id, student_id)
);

-- 8. MATERIALS TABLE (Materi Pembelajaran PDF/Video)
CREATE TABLE public.materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    class_id UUID NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    type material_type NOT NULL,
    file_url TEXT NOT NULL,
    video_url TEXT,
    estimated_read_minutes INTEGER DEFAULT 10,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 9. EXAMS TABLE (Computer Based Test - CBT)
CREATE TABLE public.exams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    class_id UUID NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    type exam_type NOT NULL DEFAULT 'manual',
    duration_minutes INTEGER NOT NULL DEFAULT 60,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    pdf_url TEXT, -- If type is 'pdf_upload'
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 10. EXAM QUESTIONS TABLE
CREATE TABLE public.exam_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exam_id UUID NOT NULL REFERENCES public.exams(id) ON DELETE CASCADE,
    question_number INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    type question_type NOT NULL DEFAULT 'multiple_choice',
    option_a TEXT,
    option_b TEXT,
    option_c TEXT,
    option_d TEXT,
    option_e TEXT,
    correct_answer TEXT, -- 'A', 'B', 'C', 'D', 'E' for PG, or sample answer for essay
    points INTEGER DEFAULT 10,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 11. EXAM RESULTS TABLE
CREATE TABLE public.exam_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exam_id UUID NOT NULL REFERENCES public.exams(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    score NUMERIC(5, 2) DEFAULT 0.00,
    status TEXT NOT NULL DEFAULT 'completed', -- 'in_progress', 'completed'
    answers_json JSONB DEFAULT '{}'::jsonb,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    submitted_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(exam_id, student_id)
);

-- 12. ATTENDANCE TABLE (Presensi)
CREATE TABLE public.attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    schedule_id UUID NOT NULL REFERENCES public.class_schedules(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    status attendance_status NOT NULL DEFAULT 'hadir',
    notes TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(schedule_id, student_id, timestamp::date)
);

-- 13. ACTIVITY LOGS TABLE (Learning Analytics)
CREATE TABLE public.activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    material_id UUID REFERENCES public.materials(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL, -- 'read_pdf', 'watch_video', 'login', 'logout', 'cbt_submit'
    duration_seconds INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Hierarchical RBAC: Super Admin > Admin > Guru > Siswa
-- ====================================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exam_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exam_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- Helper Function: Check User Role
CREATE OR REPLACE FUNCTION public.get_current_user_role()
RETURNS user_role AS $$
    SELECT role FROM public.users WHERE id = auth.uid();
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Users Table Policies
CREATE POLICY "Users are viewable by all authenticated users" ON public.users FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can insert/update users" ON public.users FOR ALL USING (get_current_user_role() IN ('Super Admin', 'Admin'));

-- Classes & Subjects Policies
CREATE POLICY "Classes viewable by all users" ON public.classes FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Classes editable by Admin/Super Admin" ON public.classes FOR ALL USING (get_current_user_role() IN ('Super Admin', 'Admin'));

CREATE POLICY "Subjects viewable by all users" ON public.subjects FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Subjects editable by Admin/Super Admin" ON public.subjects FOR ALL USING (get_current_user_role() IN ('Super Admin', 'Admin'));

-- Schedules Policies
CREATE POLICY "Schedules viewable by all users" ON public.class_schedules FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Schedules managed by Admin/Super Admin" ON public.class_schedules FOR ALL USING (get_current_user_role() IN ('Super Admin', 'Admin'));

-- Materials Policies
CREATE POLICY "Materials readable by enrolled students & teachers" ON public.materials FOR SELECT USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    (get_current_user_role() = 'Guru' AND teacher_id = auth.uid()) OR
    (get_current_user_role() = 'Siswa' AND class_id IN (
        SELECT class_id FROM public.class_students WHERE student_id = auth.uid()
    ))
);
CREATE POLICY "Teachers can create and update their materials" ON public.materials FOR ALL USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    (get_current_user_role() = 'Guru' AND teacher_id = auth.uid())
);

-- Exams & Questions Policies
CREATE POLICY "Exams viewable by class students and teachers" ON public.exams FOR SELECT USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    (get_current_user_role() = 'Guru' AND teacher_id = auth.uid()) OR
    (get_current_user_role() = 'Siswa' AND class_id IN (
        SELECT class_id FROM public.class_students WHERE student_id = auth.uid()
    ))
);
CREATE POLICY "Exams manageable by teachers" ON public.exams FOR ALL USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    (get_current_user_role() = 'Guru' AND teacher_id = auth.uid())
);

CREATE POLICY "Questions viewable by class students & teachers" ON public.exam_questions FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Questions manageable by teachers" ON public.exam_questions FOR ALL USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    EXISTS (SELECT 1 FROM public.exams WHERE id = exam_questions.exam_id AND teacher_id = auth.uid())
);

-- Exam Results Policies
CREATE POLICY "Exam results viewable by student and teacher" ON public.exam_results FOR SELECT USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    student_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.exams WHERE id = exam_results.exam_id AND teacher_id = auth.uid())
);
CREATE POLICY "Students can insert their exam results" ON public.exam_results FOR INSERT WITH CHECK (
    student_id = auth.uid()
);
CREATE POLICY "Teachers can update exam results (grading)" ON public.exam_results FOR UPDATE USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    EXISTS (SELECT 1 FROM public.exams WHERE id = exam_results.exam_id AND teacher_id = auth.uid())
);

-- Attendance Policies
CREATE POLICY "Attendance viewable by teacher, admin, and student" ON public.attendance FOR SELECT USING (
    get_current_user_role() IN ('Super Admin', 'Admin') OR
    student_id = auth.uid() OR
    EXISTS (
        SELECT 1 FROM public.class_schedules cs 
        WHERE cs.id = attendance.schedule_id AND cs.teacher_id = auth.uid()
    )
);
CREATE POLICY "Students can insert attendance" ON public.attendance FOR INSERT WITH CHECK (
    student_id = auth.uid() OR get_current_user_role() IN ('Super Admin', 'Admin', 'Guru')
);

-- Activity Logs Policies
CREATE POLICY "Users can create their activity logs" ON public.activity_logs FOR INSERT WITH CHECK (
    user_id = auth.uid()
);
CREATE POLICY "Teachers and admins can view activity logs" ON public.activity_logs FOR SELECT USING (
    get_current_user_role() IN ('Super Admin', 'Admin', 'Guru') OR user_id = auth.uid()
);
