# Astys Audio Video Pvt. Ltd. — Policy Portal & Supabase Integration

## Overview
This portal provides an interactive Company Policy Manual, Employee Acknowledgement, and restricted **HR Admin Dashboard** for **Astys Audio Video Pvt. Ltd.**.

---

## 🔒 HR Admin Login & Panel Features

- **Navbar Login Button**: Clicking **🔒 HR Login** in the top navbar opens the HR authentication modal.
- **Protected HR Panel**: The HR Acknowledgement Register, employee analytics, and tools are hidden by default from regular employees and unlocked only upon HR login.
- **Default HR Credentials**:
  - **Username**: `admin`
  - **Password**: `admin123`
- **HR Dashboard KPI Cards**: Instant summary metrics showing total sign-offs, active departments, latest submission date, and Supabase cloud sync status.
- **Record Management & Revocation**: View full certificates, search, filter by department, export CSV, or delete individual records.

---

## 🚀 Key Platform Features

1. **Supabase Cloud Database Persistence**:
   - Stores all signed policy acknowledgements (Employee Name, ID, Designation, Department, Place, Signed Timestamp, Record ID, and Base64 Signature) in PostgreSQL on Supabase.
   - Fallback support for `localStorage` when offline or prior to configuring database keys.

2. **HR Management & Analytics**:
   - **Real-time Synchronization**: Pulls submitted records directly from Supabase.
   - **Live Search**: Instant filtering by Employee Name, ID, or Record ID.
   - **Department Filter**: Dropdown filtering across departments.
   - **CSV Export**: One-click export of all policy acknowledgements to CSV for HR compliance.
   - **Digital Certificate Viewer**: Instant modal view and print preview of verified signed policy certificates.

3. **Form & UX Improvements**:
   - Non-blocking toast notifications replacing disruptive `alert()` dialogs.
   - Red border visual validation for empty required inputs and missing checkmarks.
   - Touchscreen and HD screen (DPR) responsive signature drawing canvas.
   - Company branding with logo display in header.

---

## 🗄️ Supabase Database Setup Guide

### Step 1: Create Table & Security Rules
1. Log into your [Supabase Dashboard](https://supabase.com).
2. Go to your project's **SQL Editor**.
3. Open `schema.sql` from this repository or copy the code below into the editor and click **Run**:

```sql
-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: policy_acknowledgements
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
    signature_data TEXT NOT NULL,
    read_sections_count INTEGER DEFAULT 21 NOT NULL,
    user_agent TEXT
);

-- Enable RLS
ALTER TABLE public.policy_acknowledgements ENABLE ROW LEVEL SECURITY;

-- Allow submissions and viewing
CREATE POLICY "Allow public insert" ON public.policy_acknowledgements FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public select" ON public.policy_acknowledgements FOR SELECT USING (true);
```

### Step 2: Connect the Portal to Supabase

1. Open `index.html` in your browser.
2. Click the status badge in the top right header: **"Supabase: Disconnected"** / **"Configure Key"**.
3. Paste your **Supabase Project URL** (e.g. `https://xyz.supabase.co`) and **Anon Public Key**.
4. Click **Save & Connect**.
