-- Travely Database Schema for Supabase
-- Run this in your Supabase SQL Editor

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Create travel_routes table
CREATE TABLE IF NOT EXISTS travel_routes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    duration TEXT,
    total_price INTEGER,
    image_url TEXT,
    stops TEXT, -- JSON string of RouteStop array
    price_breakdown TEXT, -- JSON string of PriceItem array
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Create user_profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    profile_image_url TEXT,
    preferences TEXT, -- JSON string
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_favorites table for saved routes
CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    route_id UUID REFERENCES travel_routes(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, route_id)
);

-- Create user_trips table for booked trips
CREATE TABLE IF NOT EXISTS user_trips (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    route_id UUID REFERENCES travel_routes(id) ON DELETE CASCADE,
    booking_status TEXT DEFAULT 'pending', -- pending, confirmed, cancelled
    booking_reference TEXT,
    total_price INTEGER,
    payment_status TEXT DEFAULT 'pending', -- pending, paid, refunded
    trip_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE travel_routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_trips ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies

-- Travel Routes: Users can read all routes, but only modify their own
CREATE POLICY "Anyone can view travel routes" ON travel_routes
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own routes" ON travel_routes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own routes" ON travel_routes
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own routes" ON travel_routes
    FOR DELETE USING (auth.uid() = user_id);

-- User Profiles: Users can only access their own profile
CREATE POLICY "Users can view own profile" ON user_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile" ON user_profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON user_profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own profile" ON user_profiles
    FOR DELETE USING (auth.uid() = user_id);

-- User Favorites: Users can only access their own favorites
CREATE POLICY "Users can view own favorites" ON user_favorites
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites" ON user_favorites
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites" ON user_favorites
    FOR DELETE USING (auth.uid() = user_id);

-- User Trips: Users can only access their own trips
CREATE POLICY "Users can view own trips" ON user_trips
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own trips" ON user_trips
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own trips" ON user_trips
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own trips" ON user_trips
    FOR DELETE USING (auth.uid() = user_id);

-- Create functions for automatic updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_travel_routes_updated_at 
    BEFORE UPDATE ON travel_routes 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at 
    BEFORE UPDATE ON user_profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_trips_updated_at 
    BEFORE UPDATE ON user_trips 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert some sample data (optional)
INSERT INTO travel_routes (title, description, duration, total_price, image_url, stops, price_breakdown, user_id) VALUES
(
    'European Adventure',
    'Explore the best of Europe in 14 days',
    '14 days',
    2500,
    'https://example.com/europe.jpg',
    '[{"id": 1, "destination": "Paris", "country": "France", "countryEmoji": "🇫🇷", "duration": "3 days", "dates": "2024-06-01 to 2024-06-04", "hasFlight": true, "hasTrain": false, "isStart": true, "flightInfo": "Flight to Paris", "flightDuration": "2h 30m", "flightPrice": "€150", "nights": 2}]',
    '[{"id": 1, "item": "Flight to Paris", "price": 150}, {"id": 2, "item": "Hotel Paris", "price": 300}]',
    null
),
(
    'Asian Discovery',
    'Discover the beauty of Asia',
    '21 days',
    3200,
    'https://example.com/asia.jpg',
    '[{"id": 1, "destination": "Tokyo", "country": "Japan", "countryEmoji": "🇯🇵", "duration": "5 days", "dates": "2024-07-01 to 2024-07-06", "hasFlight": true, "hasTrain": false, "isStart": true, "flightInfo": "Flight to Tokyo", "flightDuration": "11h 30m", "flightPrice": "€800", "nights": 4}]',
    '[{"id": 1, "item": "Flight to Tokyo", "price": 800}, {"id": 2, "item": "Hotel Tokyo", "price": 600}]',
    null
);
