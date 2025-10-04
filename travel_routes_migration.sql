-- Travel Routes Database Migration
-- Run this script in Supabase SQL Editor

-- ==============================================
-- 1. CREATE TABLES
-- ==============================================

-- Create travel_routes table
CREATE TABLE IF NOT EXISTS travel_routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    region TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    duration_days INTEGER,
    planned_nights INTEGER,
    flight_cost NUMERIC,
    hotel_cost NUMERIC,
    total_cost NUMERIC,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create travel_stops table
CREATE TABLE IF NOT EXISTS travel_stops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID REFERENCES travel_routes(id) ON DELETE CASCADE,
    location TEXT NOT NULL,
    country TEXT,
    nights INTEGER,
    hotel_cost NUMERIC,
    notes TEXT
);

-- Create travel_bookings table
CREATE TABLE IF NOT EXISTS travel_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stop_id UUID REFERENCES travel_stops(id) ON DELETE CASCADE,
    type TEXT CHECK (type IN ('flight', 'hotel', 'train', 'other')),
    provider TEXT,
    cost NUMERIC,
    booking_ref TEXT
);

-- ==============================================
-- 2. CREATE INDEXES FOR PERFORMANCE
-- ==============================================

CREATE INDEX IF NOT EXISTS idx_travel_routes_start_date ON travel_routes(start_date);
CREATE INDEX IF NOT EXISTS idx_travel_routes_region ON travel_routes(region);
CREATE INDEX IF NOT EXISTS idx_travel_stops_route_id ON travel_stops(route_id);
CREATE INDEX IF NOT EXISTS idx_travel_stops_country ON travel_stops(country);
CREATE INDEX IF NOT EXISTS idx_travel_bookings_stop_id ON travel_bookings(stop_id);
CREATE INDEX IF NOT EXISTS idx_travel_bookings_type ON travel_bookings(type);

-- ==============================================
-- 3. ENABLE ROW LEVEL SECURITY (RLS)
-- ==============================================

-- Enable RLS on all tables
ALTER TABLE travel_routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_bookings ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for travel_routes
CREATE POLICY "Users can view all travel routes" ON travel_routes
    FOR SELECT USING (true);

CREATE POLICY "Users can insert travel routes" ON travel_routes
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update travel routes" ON travel_routes
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete travel routes" ON travel_routes
    FOR DELETE USING (true);

-- Create RLS policies for travel_stops
CREATE POLICY "Users can view all travel stops" ON travel_stops
    FOR SELECT USING (true);

CREATE POLICY "Users can insert travel stops" ON travel_stops
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update travel stops" ON travel_stops
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete travel stops" ON travel_stops
    FOR DELETE USING (true);

-- Create RLS policies for travel_bookings
CREATE POLICY "Users can view all travel bookings" ON travel_bookings
    FOR SELECT USING (true);

CREATE POLICY "Users can insert travel bookings" ON travel_bookings
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update travel bookings" ON travel_bookings
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete travel bookings" ON travel_bookings
    FOR DELETE USING (true);

-- ==============================================
-- 4. INSERT SAMPLE DATA
-- ==============================================

-- Insert the main route
INSERT INTO travel_routes (
    title, region, start_date, end_date, duration_days, 
    planned_nights, flight_cost, hotel_cost, total_cost
) VALUES (
    'Asia Route 2026', 'Asia', '2026-03-01', '2026-03-21', 
    21, 20, 1200, 1800, 3000
) RETURNING id;

-- Get the route ID for inserting stops
-- Note: In a real scenario, you'd capture this ID from the RETURNING clause
-- For this example, we'll use a subquery to get the latest route ID

-- Insert travel stops for the Asia Route 2026
INSERT INTO travel_stops (route_id, location, country, nights, hotel_cost, notes)
SELECT 
    r.id,
    stop_data.location,
    stop_data.country,
    stop_data.nights,
    stop_data.hotel_cost,
    stop_data.notes
FROM travel_routes r
CROSS JOIN (
    VALUES 
        ('Bangkok', 'Thailand', 3, 250, 'Capital city with amazing street food'),
        ('Singapore', 'Singapore', 2, 300, 'Modern city-state with diverse culture'),
        ('Bali', 'Indonesia', 7, 600, 'Tropical paradise with beautiful beaches'),
        ('Tokyo', 'Japan', 4, 400, 'Bustling metropolis with rich history'),
        ('Seoul', 'South Korea', 4, 250, 'Dynamic city blending tradition and modernity')
) AS stop_data(location, country, nights, hotel_cost, notes)
WHERE r.title = 'Asia Route 2026'
ORDER BY stop_data.nights;

-- ==============================================
-- 5. VERIFICATION QUERIES
-- ==============================================

-- Verify the migration was successful
SELECT 'Migration Verification' as status;

-- Check travel_routes table
SELECT 
    'travel_routes' as table_name,
    COUNT(*) as record_count,
    'Asia Route 2026' as sample_title
FROM travel_routes;

-- Check travel_stops table
SELECT 
    'travel_stops' as table_name,
    COUNT(*) as record_count,
    STRING_AGG(location, ', ') as locations
FROM travel_stops;

-- Show the complete route with stops
SELECT 
    r.title,
    r.region,
    r.start_date,
    r.end_date,
    r.total_cost,
    s.location,
    s.country,
    s.nights,
    s.hotel_cost
FROM travel_routes r
LEFT JOIN travel_stops s ON r.id = s.route_id
WHERE r.title = 'Asia Route 2026'
ORDER BY s.nights;

-- ==============================================
-- 6. USEFUL QUERIES FOR TESTING
-- ==============================================

-- Query to get all routes with their total stops
SELECT 
    r.id,
    r.title,
    r.region,
    r.start_date,
    r.end_date,
    r.total_cost,
    COUNT(s.id) as total_stops,
    SUM(s.nights) as total_nights
FROM travel_routes r
LEFT JOIN travel_stops s ON r.id = s.route_id
GROUP BY r.id, r.title, r.region, r.start_date, r.end_date, r.total_cost
ORDER BY r.created_at DESC;

-- Query to get route details with all stops
SELECT 
    r.title as route_title,
    r.region,
    r.start_date,
    r.end_date,
    r.total_cost,
    s.location,
    s.country,
    s.nights,
    s.hotel_cost,
    s.notes
FROM travel_routes r
JOIN travel_stops s ON r.id = s.route_id
ORDER BY r.title, s.nights;

-- ==============================================
-- MIGRATION COMPLETE
-- ==============================================

SELECT 'Migration completed successfully! ✅' as result;

