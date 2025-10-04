-- Travel Routes Table Schema for Supabase
-- This table stores comprehensive travel itinerary information

-- Create the travel_routes table
CREATE TABLE IF NOT EXISTS travel_routes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    total_days INTEGER,
    total_cost DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'EUR',
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('Easy', 'Medium', 'Hard', 'Expert')),
    budget_range VARCHAR(10) CHECK (budget_range IN ('€', '€€', '€€€', '€€€€')),
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'planned', 'active', 'completed', 'cancelled')),
    is_public BOOLEAN DEFAULT false,
    tags TEXT[], -- Array of tags like ['adventure', 'beach', 'city']
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_travel_routes_user_id ON travel_routes(user_id);
CREATE INDEX IF NOT EXISTS idx_travel_routes_start_date ON travel_routes(start_date);
CREATE INDEX IF NOT EXISTS idx_travel_routes_status ON travel_routes(status);
CREATE INDEX IF NOT EXISTS idx_travel_routes_is_public ON travel_routes(is_public);
CREATE INDEX IF NOT EXISTS idx_travel_routes_tags ON travel_routes USING GIN(tags);

-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_travel_routes_updated_at 
    BEFORE UPDATE ON travel_routes 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE travel_routes ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can only see their own routes or public routes
CREATE POLICY "Users can view own routes and public routes" ON travel_routes
    FOR SELECT USING (
        auth.uid() = user_id OR is_public = true
    );

-- Users can only insert their own routes
CREATE POLICY "Users can insert own routes" ON travel_routes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can only update their own routes
CREATE POLICY "Users can update own routes" ON travel_routes
    FOR UPDATE USING (auth.uid() = user_id);

-- Users can only delete their own routes
CREATE POLICY "Users can delete own routes" ON travel_routes
    FOR DELETE USING (auth.uid() = user_id);

-- Insert sample data
INSERT INTO travel_routes (
    user_id,
    name,
    description,
    start_date,
    end_date,
    total_days,
    total_cost,
    currency,
    difficulty_level,
    budget_range,
    status,
    is_public,
    tags
) VALUES 
(
    '00000000-0000-0000-0000-000000000000', -- Placeholder UUID - replace with actual user ID
    'Asia Adventure March 2026',
    'Epic journey through Taiwan, Bali, Malaysia & Thailand. From Taipei''s night markets to Bali''s beaches, Kuala Lumpur''s skyline to Bangkok''s temples.',
    '2026-03-07',
    '2026-03-28',
    22,
    2664.00,
    'EUR',
    'Medium',
    '€€€',
    'planned',
    true,
    ARRAY['adventure', 'asia', 'beach', 'city', 'culture', 'food']
),
(
    '00000000-0000-0000-0000-000000000000', -- Placeholder UUID - replace with actual user ID
    'European City Hopper',
    'A whirlwind tour of Europe''s most iconic cities. Experience the romance of Paris, the history of Rome, and the charm of Amsterdam.',
    '2024-06-15',
    '2024-06-25',
    11,
    1850.00,
    'EUR',
    'Easy',
    '€€€',
    'completed',
    true,
    ARRAY['europe', 'city', 'culture', 'history', 'romance']
),
(
    '00000000-0000-0000-0000-000000000000', -- Placeholder UUID - replace with actual user ID
    'Backpacking Southeast Asia',
    'Budget-friendly adventure through Vietnam, Cambodia, and Laos. Discover ancient temples, bustling markets, and pristine beaches.',
    '2024-08-01',
    '2024-08-21',
    21,
    1200.00,
    'EUR',
    'Medium',
    '€€',
    'draft',
    false,
    ARRAY['backpacking', 'budget', 'southeast-asia', 'temples', 'beaches']
),
(
    '00000000-0000-0000-0000-000000000000', -- Placeholder UUID - replace with actual user ID
    'Luxury Safari Experience',
    'Premium safari adventure in Kenya and Tanzania. Witness the Great Migration and stay in luxury tented camps.',
    '2024-12-10',
    '2024-12-20',
    11,
    8500.00,
    'EUR',
    'Easy',
    '€€€€',
    'planned',
    true,
    ARRAY['luxury', 'safari', 'africa', 'wildlife', 'photography']
),
(
    '00000000-0000-0000-0000-000000000000', -- Placeholder UUID - replace with actual user ID
    'Nordic Winter Wonderland',
    'Experience the magic of winter in Scandinavia. Northern lights, ice hotels, and cozy hygge moments.',
    '2024-12-20',
    '2024-12-30',
    11,
    3200.00,
    'EUR',
    'Medium',
    '€€€',
    'planned',
    true,
    ARRAY['winter', 'nordic', 'northern-lights', 'hygge', 'adventure']
);

-- Create a view for public routes (for easier querying)
CREATE OR REPLACE VIEW public_travel_routes AS
SELECT 
    id,
    name,
    description,
    start_date,
    end_date,
    total_days,
    total_cost,
    currency,
    difficulty_level,
    budget_range,
    tags,
    created_at
FROM travel_routes
WHERE is_public = true AND status IN ('planned', 'completed');

-- Grant permissions
GRANT SELECT ON public_travel_routes TO anon, authenticated;

-- Add comments for documentation
COMMENT ON TABLE travel_routes IS 'Stores comprehensive travel itinerary information for users';
COMMENT ON COLUMN travel_routes.id IS 'Unique identifier for each travel route';
COMMENT ON COLUMN travel_routes.user_id IS 'Reference to the user who created this route';
COMMENT ON COLUMN travel_routes.name IS 'Display name of the travel route';
COMMENT ON COLUMN travel_routes.description IS 'Detailed description of the travel route';
COMMENT ON COLUMN travel_routes.start_date IS 'Start date of the travel route';
COMMENT ON COLUMN travel_routes.end_date IS 'End date of the travel route';
COMMENT ON COLUMN travel_routes.total_days IS 'Total number of days for the trip';
COMMENT ON COLUMN travel_routes.total_cost IS 'Total estimated cost of the trip';
COMMENT ON COLUMN travel_routes.currency IS 'Currency code for the cost (ISO 4217)';
COMMENT ON COLUMN travel_routes.difficulty_level IS 'Difficulty level of the travel route';
COMMENT ON COLUMN travel_routes.budget_range IS 'Budget range indicator';
COMMENT ON COLUMN travel_routes.status IS 'Current status of the travel route';
COMMENT ON COLUMN travel_routes.is_public IS 'Whether this route is visible to other users';
COMMENT ON COLUMN travel_routes.tags IS 'Array of tags for categorization and filtering';

