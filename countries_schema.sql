-- Countries Table for Travely App
-- Run this in your Supabase SQL Editor

-- Create countries table
CREATE TABLE IF NOT EXISTS countries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    code TEXT NOT NULL UNIQUE, -- ISO country code (e.g., 'DE', 'FR', 'US')
    emoji TEXT NOT NULL, -- Country flag emoji (e.g., '🇩🇪', '🇫🇷', '🇺🇸')
    continent TEXT, -- Continent name
    capital TEXT, -- Capital city
    population INTEGER, -- Population count
    area_km2 INTEGER, -- Area in square kilometers
    currency TEXT, -- Currency code (e.g., 'EUR', 'USD')
    language TEXT, -- Primary language
    timezone TEXT, -- Primary timezone
    description TEXT, -- Brief description of the country
    image_url TEXT, -- URL to country image
    is_popular BOOLEAN DEFAULT false, -- Popular travel destination
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies - Anyone can read countries, but only authenticated users can modify
CREATE POLICY "Anyone can view countries" ON countries
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert countries" ON countries
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update countries" ON countries
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete countries" ON countries
    FOR DELETE USING (auth.role() = 'authenticated');

-- Create trigger for updated_at
CREATE TRIGGER update_countries_updated_at 
    BEFORE UPDATE ON countries 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample countries data
INSERT INTO countries (name, code, emoji, continent, capital, population, area_km2, currency, language, timezone, description, is_popular) VALUES
('Germany', 'DE', '🇩🇪', 'Europe', 'Berlin', 83200000, 357022, 'EUR', 'German', 'Europe/Berlin', 'A country in Central Europe known for its rich history, culture, and engineering excellence.', true),
('France', 'FR', '🇫🇷', 'Europe', 'Paris', 68000000, 551695, 'EUR', 'French', 'Europe/Paris', 'A country in Western Europe famous for its art, cuisine, and romantic capital city.', true),
('Italy', 'IT', '🇮🇹', 'Europe', 'Rome', 60000000, 301340, 'EUR', 'Italian', 'Europe/Rome', 'A country in Southern Europe known for its ancient history, art, and delicious cuisine.', true),
('Spain', 'ES', '🇪🇸', 'Europe', 'Madrid', 47000000, 505992, 'EUR', 'Spanish', 'Europe/Madrid', 'A country in Southwestern Europe known for its vibrant culture, beaches, and architecture.', true),
('United Kingdom', 'GB', '🇬🇧', 'Europe', 'London', 67000000, 242495, 'GBP', 'English', 'Europe/London', 'An island nation in Northwestern Europe with a rich history and diverse culture.', true),
('Japan', 'JP', '🇯🇵', 'Asia', 'Tokyo', 125000000, 377975, 'JPY', 'Japanese', 'Asia/Tokyo', 'An island nation in East Asia known for its unique culture, technology, and natural beauty.', true),
('United States', 'US', '🇺🇸', 'North America', 'Washington D.C.', 331000000, 9833517, 'USD', 'English', 'America/New_York', 'A large country in North America known for its diverse landscapes and culture.', true),
('Canada', 'CA', '🇨🇦', 'North America', 'Ottawa', 38000000, 9984670, 'CAD', 'English/French', 'America/Toronto', 'A vast country in North America known for its natural beauty and multicultural society.', true),
('Australia', 'AU', '🇦🇺', 'Oceania', 'Canberra', 26000000, 7692024, 'AUD', 'English', 'Australia/Sydney', 'An island continent known for its unique wildlife, beaches, and outback.', true),
('Brazil', 'BR', '🇧🇷', 'South America', 'Brasília', 213000000, 8514877, 'BRL', 'Portuguese', 'America/Sao_Paulo', 'The largest country in South America known for its Amazon rainforest and vibrant culture.', true),
('India', 'IN', '🇮🇳', 'Asia', 'New Delhi', 1380000000, 3287263, 'INR', 'Hindi/English', 'Asia/Kolkata', 'A diverse country in South Asia known for its rich history, culture, and spirituality.', true),
('China', 'CN', '🇨🇳', 'Asia', 'Beijing', 1440000000, 9596961, 'CNY', 'Mandarin', 'Asia/Shanghai', 'The most populous country in the world with a rich history and rapid modernization.', true),
('South Korea', 'KR', '🇰🇷', 'Asia', 'Seoul', 52000000, 100210, 'KRW', 'Korean', 'Asia/Seoul', 'A country in East Asia known for its technology, pop culture, and economic growth.', true),
('Thailand', 'TH', '🇹🇭', 'Asia', 'Bangkok', 70000000, 513120, 'THB', 'Thai', 'Asia/Bangkok', 'A country in Southeast Asia known for its beautiful beaches, temples, and cuisine.', true),
('Mexico', 'MX', '🇲🇽', 'North America', 'Mexico City', 128000000, 1964375, 'MXN', 'Spanish', 'America/Mexico_City', 'A country in North America known for its rich culture, history, and cuisine.', true),
('Netherlands', 'NL', '🇳🇱', 'Europe', 'Amsterdam', 17500000, 41543, 'EUR', 'Dutch', 'Europe/Amsterdam', 'A country in Northwestern Europe known for its canals, tulips, and cycling culture.', true),
('Switzerland', 'CH', '🇨🇭', 'Europe', 'Bern', 8700000, 41284, 'CHF', 'German/French/Italian', 'Europe/Zurich', 'A mountainous country in Central Europe known for its neutrality, banking, and natural beauty.', true),
('Austria', 'AT', '🇦🇹', 'Europe', 'Vienna', 9000000, 83879, 'EUR', 'German', 'Europe/Vienna', 'A country in Central Europe known for its classical music, mountains, and imperial history.', true),
('Portugal', 'PT', '🇵🇹', 'Europe', 'Lisbon', 10000000, 92090, 'EUR', 'Portuguese', 'Europe/Lisbon', 'A country in Southern Europe known for its maritime history, cuisine, and beautiful coastline.', true),
('Greece', 'GR', '🇬🇷', 'Europe', 'Athens', 10700000, 131957, 'EUR', 'Greek', 'Europe/Athens', 'A country in Southeastern Europe known for its ancient history, islands, and Mediterranean culture.', true);

-- Create an index on the code column for faster lookups
CREATE INDEX IF NOT EXISTS idx_countries_code ON countries(code);

-- Create an index on the is_popular column for filtering popular destinations
CREATE INDEX IF NOT EXISTS idx_countries_popular ON countries(is_popular);
