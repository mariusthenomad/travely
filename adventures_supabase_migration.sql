-- Adventures Supabase Migration
-- This migration creates tables specifically for your current PathFinder Adventures

-- ==============================================
-- 1. CREATE ADVENTURES TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS adventures (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    duration TEXT,
    difficulty TEXT CHECK (difficulty IN ('Easy', 'Medium', 'Hard', 'Expert')),
    budget TEXT CHECK (budget IN ('€', '€€', '€€€', '€€€€')),
    image TEXT,
    color_hex TEXT, -- Store color as hex string
    destinations TEXT[], -- Array of destination names
    highlights TEXT[], -- Array of highlights
    total_cost INTEGER,
    total_nights INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================
-- 2. CREATE ADVENTURE_FLIGHTS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS adventure_flights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    adventure_id TEXT REFERENCES adventures(id) ON DELETE CASCADE,
    route TEXT NOT NULL,
    date TEXT NOT NULL,
    duration TEXT NOT NULL,
    price TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================
-- 3. CREATE ADVENTURE_PLACES TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS adventure_places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    adventure_id TEXT REFERENCES adventures(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    nights INTEGER,
    is_start_point BOOLEAN DEFAULT false,
    hotel_name TEXT,
    price_per_night INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================
-- 4. CREATE ADVENTURE_BADGES TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS adventure_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    adventure_id TEXT REFERENCES adventures(id) ON DELETE CASCADE,
    badge_emoji TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================
-- 5. CREATE INDEXES FOR PERFORMANCE
-- ==============================================

CREATE INDEX IF NOT EXISTS idx_adventures_difficulty ON adventures(difficulty);
CREATE INDEX IF NOT EXISTS idx_adventures_budget ON adventures(budget);
CREATE INDEX IF NOT EXISTS idx_adventures_total_cost ON adventures(total_cost);
CREATE INDEX IF NOT EXISTS idx_adventure_flights_adventure_id ON adventure_flights(adventure_id);
CREATE INDEX IF NOT EXISTS idx_adventure_places_adventure_id ON adventure_places(adventure_id);
CREATE INDEX IF NOT EXISTS idx_adventure_badges_adventure_id ON adventure_badges(adventure_id);

-- ==============================================
-- 6. ENABLE ROW LEVEL SECURITY (RLS)
-- ==============================================

ALTER TABLE adventures ENABLE ROW LEVEL SECURITY;
ALTER TABLE adventure_flights ENABLE ROW LEVEL SECURITY;
ALTER TABLE adventure_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE adventure_badges ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for adventures
CREATE POLICY "Users can view all adventures" ON adventures
    FOR SELECT USING (true);

CREATE POLICY "Users can insert adventures" ON adventures
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update adventures" ON adventures
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete adventures" ON adventures
    FOR DELETE USING (true);

-- Create RLS policies for adventure_flights
CREATE POLICY "Users can view all adventure flights" ON adventure_flights
    FOR SELECT USING (true);

CREATE POLICY "Users can insert adventure flights" ON adventure_flights
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update adventure flights" ON adventure_flights
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete adventure flights" ON adventure_flights
    FOR DELETE USING (true);

-- Create RLS policies for adventure_places
CREATE POLICY "Users can view all adventure places" ON adventure_places
    FOR SELECT USING (true);

CREATE POLICY "Users can insert adventure places" ON adventure_places
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update adventure places" ON adventure_places
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete adventure places" ON adventure_places
    FOR DELETE USING (true);

-- Create RLS policies for adventure_badges
CREATE POLICY "Users can view all adventure badges" ON adventure_badges
    FOR SELECT USING (true);

CREATE POLICY "Users can insert adventure badges" ON adventure_badges
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update adventure badges" ON adventure_badges
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete adventure badges" ON adventure_badges
    FOR DELETE USING (true);

-- ==============================================
-- 7. INSERT YOUR CURRENT ADVENTURES
-- ==============================================

-- European Adventure
INSERT INTO adventures (
    id, name, description, duration, difficulty, budget, image, 
    color_hex, destinations, highlights, total_cost, total_nights
) VALUES (
    'european',
    'European Adventure',
    'Discover the best of Europe with this amazing journey through iconic cities, rich history, and stunning architecture.',
    '14 days',
    'Easy',
    '€€€',
    'europe.africa.fill',
    '#FF6B35', -- UltraLightDesignSystem.primaryOrange
    ARRAY['Paris', 'Rome', 'Barcelona', 'Amsterdam'],
    ARRAY['Eiffel Tower', 'Colosseum', 'Sagrada Familia', 'Van Gogh Museum'],
    1290,
    11
);

-- Asian Discovery
INSERT INTO adventures (
    id, name, description, duration, difficulty, budget, image, 
    color_hex, destinations, highlights, total_cost, total_nights
) VALUES (
    'asian',
    'Asian Discovery',
    'Experience the vibrant cultures, delicious cuisines, and modern marvels of Asia''s most exciting cities.',
    '21 days',
    'Medium',
    '€€',
    'globe.asia.australia.fill',
    '#FF6B35',
    ARRAY['Tokyo', 'Seoul', 'Bangkok', 'Singapore'],
    ARRAY['Tokyo Skytree', 'Gyeongbokgung Palace', 'Grand Palace', 'Marina Bay Sands'],
    1245,
    21
);

-- Asia Adventure March 2026
INSERT INTO adventures (
    id, name, description, duration, difficulty, budget, image, 
    color_hex, destinations, highlights, total_cost, total_nights
) VALUES (
    'asia_march_2026',
    'Asia Adventure March 2026',
    'Epic journey through Taiwan, Bali, Malaysia & Thailand. From Taipei''s night markets to Bali''s beaches, Kuala Lumpur''s skyline to Bangkok''s temples.',
    '22 days',
    'Medium',
    '€€€',
    'airplane.departure',
    '#FF6B35',
    ARRAY['Taipei', 'Taichung', 'Bali', 'Kuala Lumpur', 'Bangkok'],
    ARRAY['Taipei 101', 'Taichung Night Market', 'Bali Temples', 'Petronas Towers', 'Grand Palace Bangkok'],
    2664,
    20
);

-- ==============================================
-- 8. INSERT FLIGHTS FOR EUROPEAN ADVENTURE
-- ==============================================

INSERT INTO adventure_flights (adventure_id, route, date, duration, price) VALUES
('european', 'Munich → Paris', 'Dec 15, 2024', '1h 30m', '€89'),
('european', 'Paris → Rome', 'Dec 18, 2024', '2h 15m', '€95'),
('european', 'Rome → Barcelona', 'Dec 21, 2024', '1h 45m', '€67'),
('european', 'Barcelona → Amsterdam', 'Dec 24, 2024', '2h 30m', '€78');

-- ==============================================
-- 9. INSERT PLACES FOR EUROPEAN ADVENTURE
-- ==============================================

INSERT INTO adventure_places (adventure_id, name, latitude, longitude, nights, is_start_point, hotel_name, price_per_night) VALUES
('european', 'Paris', 48.8566, 2.3522, 3, true, 'Hotel Plaza', 120),
('european', 'Rome', 41.9028, 12.4964, 3, false, 'Hotel Colosseum', 95),
('european', 'Barcelona', 41.3851, 2.1734, 3, false, 'Hotel Sagrada', 110),
('european', 'Amsterdam', 52.3676, 4.9041, 2, false, 'Hotel Canal', 130);

-- ==============================================
-- 10. INSERT BADGES FOR EUROPEAN ADVENTURE
-- ==============================================

INSERT INTO adventure_badges (adventure_id, badge_emoji) VALUES
('european', '🏛️'),
('european', '🍝'),
('european', '🏰'),
('european', '🎨'),
('european', '🚂'),
('european', '✈️');

-- ==============================================
-- 11. INSERT FLIGHTS FOR ASIAN DISCOVERY
-- ==============================================

INSERT INTO adventure_flights (adventure_id, route, date, duration, price) VALUES
('asian', 'Munich → Tokyo', 'Jan 10, 2025', '11h 30m', '€650'),
('asian', 'Tokyo → Seoul', 'Jan 17, 2025', '2h 15m', '€180'),
('asian', 'Seoul → Bangkok', 'Jan 24, 2025', '5h 30m', '€320'),
('asian', 'Bangkok → Singapore', 'Jan 28, 2025', '2h 15m', '€95');

-- ==============================================
-- 12. INSERT PLACES FOR ASIAN DISCOVERY
-- ==============================================

INSERT INTO adventure_places (adventure_id, name, latitude, longitude, nights, is_start_point, hotel_name, price_per_night) VALUES
('asian', 'Tokyo', 35.6762, 139.6503, 7, true, 'Hotel Tokyo Central', 85),
('asian', 'Seoul', 37.5665, 126.9780, 7, false, 'Hotel Gangnam', 75),
('asian', 'Bangkok', 13.7563, 100.5018, 4, false, 'Hotel Bangkok Central', 45),
('asian', 'Singapore', 1.3521, 103.8198, 3, false, 'Hotel Marina Bay', 120);

-- ==============================================
-- 13. INSERT BADGES FOR ASIAN DISCOVERY
-- ==============================================

INSERT INTO adventure_badges (adventure_id, badge_emoji) VALUES
('asian', '🏯'),
('asian', '🍜'),
('asian', '🏙️'),
('asian', '🌸'),
('asian', '🚄'),
('asian', '✈️');

-- ==============================================
-- 14. INSERT FLIGHTS FOR ASIA ADVENTURE MARCH 2026
-- ==============================================

INSERT INTO adventure_flights (adventure_id, route, date, duration, price) VALUES
('asia_march_2026', 'Munich → Taipei', 'Mar 7, 2026', '12h 0m', '€545'),
('asia_march_2026', 'Taipei → Bali', 'Mar 13, 2026', '5h 30m', '€280'),
('asia_march_2026', 'Bali → Kuala Lumpur', 'Mar 18, 2026', '2h 55m', '€51'),
('asia_march_2026', 'Kuala Lumpur → Bangkok', 'Mar 23, 2026', '2h 10m', '€139'),
('asia_march_2026', 'Bangkok → Munich', 'Mar 28, 2026', '11h 50m', '€535');

-- ==============================================
-- 15. INSERT PLACES FOR ASIA ADVENTURE MARCH 2026
-- ==============================================

INSERT INTO adventure_places (adventure_id, name, latitude, longitude, nights, is_start_point, hotel_name, price_per_night) VALUES
('asia_march_2026', 'Taichung', 24.1477, 120.6736, 3, true, 'SOF Hotel', 57),
('asia_march_2026', 'Taipei', 25.0330, 121.5654, 2, false, 'Hotel Relax 5', 60),
('asia_march_2026', 'Bali', -8.3405, 115.0920, 5, false, 'Boutique Hotel Mengwi', 46),
('asia_march_2026', 'Kuala Lumpur', 3.1390, 101.6869, 5, false, 'Sleeping Lion Suites', 53),
('asia_march_2026', 'Bangkok', 13.7563, 100.5018, 5, false, 'Rama 9 Luxury Condo', 51);

-- ==============================================
-- 16. INSERT BADGES FOR ASIA ADVENTURE MARCH 2026
-- ==============================================

INSERT INTO adventure_badges (adventure_id, badge_emoji) VALUES
('asia_march_2026', '🏮'),
('asia_march_2026', '🏖️'),
('asia_march_2026', '🏢'),
('asia_march_2026', '🏛️'),
('asia_march_2026', '🍜'),
('asia_march_2026', '✈️');

-- ==============================================
-- 17. VERIFICATION QUERIES
-- ==============================================

-- Check adventures
SELECT 'Adventures Migration Verification' as status;

SELECT 
    'adventures' as table_name,
    COUNT(*) as record_count
FROM adventures;

-- Check flights
SELECT 
    'adventure_flights' as table_name,
    COUNT(*) as record_count
FROM adventure_flights;

-- Check places
SELECT 
    'adventure_places' as table_name,
    COUNT(*) as record_count
FROM adventure_places;

-- Check badges
SELECT 
    'adventure_badges' as table_name,
    COUNT(*) as record_count
FROM adventure_badges;

-- Show complete adventure data
SELECT 
    a.name,
    a.duration,
    a.difficulty,
    a.budget,
    a.total_cost,
    a.total_nights,
    COUNT(DISTINCT f.id) as flight_count,
    COUNT(DISTINCT p.id) as place_count,
    COUNT(DISTINCT b.id) as badge_count
FROM adventures a
LEFT JOIN adventure_flights f ON a.id = f.adventure_id
LEFT JOIN adventure_places p ON a.id = p.adventure_id
LEFT JOIN adventure_badges b ON a.id = b.adventure_id
GROUP BY a.id, a.name, a.duration, a.difficulty, a.budget, a.total_cost, a.total_nights
ORDER BY a.name;

-- ==============================================
-- MIGRATION COMPLETE
-- ==============================================

SELECT 'Adventures migration completed successfully! ✅' as result;

