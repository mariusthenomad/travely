-- =====================================================
-- Supabase Backend Setup: Auto Profile Creation
-- =====================================================
-- This file contains SQL code to automatically create profile rows
-- when new users sign up via Supabase Auth

-- =====================================================
-- 1. Create the profiles table
-- =====================================================

-- Drop the table if it exists (for development)
DROP TABLE IF EXISTS public.profiles CASCADE;

-- Create the profiles table
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    phone TEXT,
    date_of_birth DATE,
    country TEXT,
    timezone TEXT DEFAULT 'UTC',
    preferences JSONB DEFAULT '{}'::jsonb,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE
);

-- =====================================================
-- 2. Enable Row Level Security (RLS)
-- =====================================================

-- Enable RLS on the profiles table
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 3. Create RLS Policies
-- =====================================================

-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Policy: Users can insert their own profile (for manual creation if needed)
CREATE POLICY "Users can insert own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Policy: Users can delete their own profile
CREATE POLICY "Users can delete own profile" ON public.profiles
    FOR DELETE USING (auth.uid() = id);

-- =====================================================
-- 4. Create the trigger function
-- =====================================================

-- Function to automatically create a profile when a user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert a new row into the profiles table
    INSERT INTO public.profiles (id, email, created_at, updated_at)
    VALUES (
        NEW.id,
        NEW.email,
        NOW(),
        NOW()
    );
    
    -- Return the new user record
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 5. Create the trigger
-- =====================================================

-- Create trigger that fires after a new user is inserted into auth.users
CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- 6. Create helper functions for profile management
-- =====================================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update the updated_at field
CREATE OR REPLACE TRIGGER handle_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- =====================================================
-- 7. Create indexes for better performance
-- =====================================================

-- Index on email for faster lookups
CREATE INDEX IF NOT EXISTS profiles_email_idx ON public.profiles(email);

-- Index on created_at for sorting
CREATE INDEX IF NOT EXISTS profiles_created_at_idx ON public.profiles(created_at);

-- Index on is_active for filtering active users
CREATE INDEX IF NOT EXISTS profiles_is_active_idx ON public.profiles(is_active);

-- =====================================================
-- 8. Grant necessary permissions
-- =====================================================

-- Grant usage on the schema
GRANT USAGE ON SCHEMA public TO authenticated;

-- Grant all privileges on the profiles table to authenticated users
GRANT ALL ON public.profiles TO authenticated;

-- Grant usage on the sequence (if any)
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- =====================================================
-- 9. Create a view for easy profile access
-- =====================================================

-- Create a view that combines auth.users and profiles data
CREATE OR REPLACE VIEW public.user_profiles AS
SELECT 
    u.id,
    u.email,
    u.email_confirmed_at,
    u.created_at as auth_created_at,
    u.last_sign_in_at,
    p.first_name,
    p.last_name,
    p.avatar_url,
    p.bio,
    p.phone,
    p.date_of_birth,
    p.country,
    p.timezone,
    p.preferences,
    p.is_active,
    p.last_login,
    p.created_at as profile_created_at,
    p.updated_at as profile_updated_at
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id;

-- Grant access to the view
GRANT SELECT ON public.user_profiles TO authenticated;

-- =====================================================
-- 10. Test the setup (optional - for development)
-- =====================================================

-- Uncomment the following lines to test the trigger
-- Note: This will create a test user in auth.users
-- 
-- INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
-- VALUES (
--     gen_random_uuid(),
--     'test@example.com',
--     crypt('password123', gen_salt('bf')),
--     NOW(),
--     NOW(),
--     NOW()
-- );
-- 
-- -- Check if the profile was created
-- SELECT * FROM public.profiles WHERE email = 'test@example.com';

-- =====================================================
-- Setup Complete!
-- =====================================================
-- 
-- Your Supabase backend is now configured with:
-- 1. ✅ A profiles table with proper structure
-- 2. ✅ Row Level Security (RLS) enabled
-- 3. ✅ RLS policies for secure access
-- 4. ✅ Automatic profile creation via trigger
-- 5. ✅ Helper functions and indexes
-- 6. ✅ A convenient user_profiles view
-- 
-- Next steps:
-- 1. Run this SQL in your Supabase SQL editor
-- 2. Update your iOS app with the Supabase client configuration
-- 3. Test the signup flow to verify profiles are created automatically

