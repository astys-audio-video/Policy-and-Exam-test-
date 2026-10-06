-- Supabase Schema for Astys Audio Video Pvt. Ltd. Policy Manual Portal

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Table: policy_acknowledgements
CREATE TABLE IF NOT EXISTS public.policy_acknowledgements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    record_id TEXT UNIQUE NOT NULL,
    employee_name TEXT NOT NULL,
    employee_id TEXT NOT NULL,
    designation TEXT NOT NULL,
    department TEXT NOT NULL,
    place TEXT NOT NULL,
    policy_version TEXT DEFAULT '1.0' NOT NULL,
    signature_type TEXT CHECK (signature_type IN ('draw', 'type')) NOT NULL,
    signature_data TEXT NOT NULL, -- Stores base64 canvas PNG data URL or typed signature string
    read_sections_count INTEGER DEFAULT 21 NOT NULL,
    user_agent TEXT
);

-- 3. Table: employee_progress (Stores section reading progress)
CREATE TABLE IF NOT EXISTS public.employee_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id TEXT UNIQUE NOT NULL,
    read_sections INTEGER[] DEFAULT '{}',
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 4. Performance Indexes
CREATE INDEX IF NOT EXISTS idx_ack_employee_id ON public.policy_acknowledgements(employee_id);
CREATE INDEX IF NOT EXISTS idx_ack_created_at ON public.policy_acknowledgements(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ack_department ON public.policy_acknowledgements(department);

-- 5. Row Level Security (RLS) Configuration
ALTER TABLE public.policy_acknowledgements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employee_progress ENABLE ROW LEVEL SECURITY;

-- Allow anyone to submit an acknowledgement
CREATE POLICY "Allow public insert to policy_acknowledgements"
    ON public.policy_acknowledgements
    FOR INSERT
    WITH CHECK (true);

-- Allow reading policy acknowledgements (Can be restricted to HR roles if Supabase Auth is enabled)
CREATE POLICY "Allow public select of policy_acknowledgements"
    ON public.policy_acknowledgements
    FOR SELECT
    USING (true);

-- Allow reading and writing progress
CREATE POLICY "Allow public upsert to employee_progress"
    ON public.employee_progress
    FOR ALL
    USING (true)
    WITH CHECK (true);
