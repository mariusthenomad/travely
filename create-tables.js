#!/usr/bin/env node

const { createClient } = require('@supabase/supabase-js');

// Supabase Konfiguration
const supabaseUrl = process.env.SUPABASE_URL || 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'YOUR_ANON_KEY_HERE';

// Erstelle Supabase Client
const supabase = createClient(supabaseUrl, supabaseKey);

async function createPathFinderTables() {
    console.log('🚀 Creating PathFinder Database Tables...\n');
    
    if (supabaseKey === 'YOUR_ANON_KEY_HERE') {
        console.log('❌ Please set your SUPABASE_ANON_KEY environment variable');
        console.log('💡 Run: export SUPABASE_ANON_KEY="your_actual_key_here"');
        return;
    }
    
    try {
        // 1. Users Table
        console.log('👤 Creating users table...');
        const { data: usersTable, error: usersError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS users (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    email VARCHAR(255) UNIQUE NOT NULL,
                    full_name VARCHAR(255),
                    avatar_url TEXT,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    last_login TIMESTAMP WITH TIME ZONE,
                    subscription_type VARCHAR(50) DEFAULT 'free',
                    subscription_expires_at TIMESTAMP WITH TIME ZONE
                );
            `
        });
        
        if (usersError) {
            console.log('❌ Users table creation failed:', usersError.message);
        } else {
            console.log('✅ Users table created/verified');
        }
        
        // 2. Destinations Table
        console.log('\n🌍 Creating destinations table...');
        const { data: destinationsTable, error: destinationsError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS destinations (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    name VARCHAR(255) NOT NULL,
                    country VARCHAR(255) NOT NULL,
                    city VARCHAR(255),
                    latitude DECIMAL(10, 8),
                    longitude DECIMAL(11, 8),
                    description TEXT,
                    image_url TEXT,
                    osm_id BIGINT,
                    osm_type VARCHAR(50),
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (destinationsError) {
            console.log('❌ Destinations table creation failed:', destinationsError.message);
        } else {
            console.log('✅ Destinations table created/verified');
        }
        
        // 3. Travel Routes Table
        console.log('\n🗺️ Creating travel_routes table...');
        const { data: routesTable, error: routesError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS travel_routes (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
                    name VARCHAR(255) NOT NULL,
                    description TEXT,
                    start_date DATE,
                    end_date DATE,
                    total_nights INTEGER DEFAULT 0,
                    is_public BOOLEAN DEFAULT false,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (routesError) {
            console.log('❌ Travel routes table creation failed:', routesError.message);
        } else {
            console.log('✅ Travel routes table created/verified');
        }
        
        // 4. Route Stops Table
        console.log('\n📍 Creating route_stops table...');
        const { data: stopsTable, error: stopsError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS route_stops (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    route_id UUID REFERENCES travel_routes(id) ON DELETE CASCADE,
                    destination_id UUID REFERENCES destinations(id),
                    stop_order INTEGER NOT NULL,
                    nights INTEGER DEFAULT 1,
                    arrival_date DATE,
                    departure_date DATE,
                    notes TEXT,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (stopsError) {
            console.log('❌ Route stops table creation failed:', stopsError.message);
        } else {
            console.log('✅ Route stops table created/verified');
        }
        
        // 5. Hotels Table
        console.log('\n🏨 Creating hotels table...');
        const { data: hotelsTable, error: hotelsError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS hotels (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    name VARCHAR(255) NOT NULL,
                    destination_id UUID REFERENCES destinations(id),
                    address TEXT,
                    latitude DECIMAL(10, 8),
                    longitude DECIMAL(11, 8),
                    price_per_night DECIMAL(10, 2),
                    currency VARCHAR(3) DEFAULT 'EUR',
                    rating DECIMAL(2, 1),
                    amenities TEXT[],
                    image_url TEXT,
                    booking_url TEXT,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (hotelsError) {
            console.log('❌ Hotels table creation failed:', hotelsError.message);
        } else {
            console.log('✅ Hotels table created/verified');
        }
        
        // 6. Flights Table
        console.log('\n✈️ Creating flights table...');
        const { data: flightsTable, error: flightsError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS flights (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
                    route_id UUID REFERENCES travel_routes(id) ON DELETE CASCADE,
                    flight_number VARCHAR(50),
                    airline VARCHAR(255),
                    departure_airport VARCHAR(10),
                    arrival_airport VARCHAR(10),
                    departure_time TIMESTAMP WITH TIME ZONE,
                    arrival_time TIMESTAMP WITH TIME ZONE,
                    price DECIMAL(10, 2),
                    currency VARCHAR(3) DEFAULT 'EUR',
                    booking_reference VARCHAR(100),
                    booking_url TEXT,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (flightsError) {
            console.log('❌ Flights table creation failed:', flightsError.message);
        } else {
            console.log('✅ Flights table created/verified');
        }
        
        // 7. Waitlist Table (für Landing Page)
        console.log('\n📧 Creating waitlist table...');
        const { data: waitlistTable, error: waitlistError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS waitlist (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    email VARCHAR(255) UNIQUE NOT NULL,
                    name VARCHAR(255),
                    signup_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                    source VARCHAR(100) DEFAULT 'landing_page',
                    is_notified BOOLEAN DEFAULT false,
                    notified_at TIMESTAMP WITH TIME ZONE
                );
            `
        });
        
        if (waitlistError) {
            console.log('❌ Waitlist table creation failed:', waitlistError.message);
        } else {
            console.log('✅ Waitlist table created/verified');
        }
        
        // 8. Indexes erstellen
        console.log('\n🔍 Creating indexes...');
        const indexes = [
            'CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);',
            'CREATE INDEX IF NOT EXISTS idx_destinations_name ON destinations(name);',
            'CREATE INDEX IF NOT EXISTS idx_destinations_country ON destinations(country);',
            'CREATE INDEX IF NOT EXISTS idx_travel_routes_user_id ON travel_routes(user_id);',
            'CREATE INDEX IF NOT EXISTS idx_route_stops_route_id ON route_stops(route_id);',
            'CREATE INDEX IF NOT EXISTS idx_route_stops_order ON route_stops(route_id, stop_order);',
            'CREATE INDEX IF NOT EXISTS idx_hotels_destination_id ON hotels(destination_id);',
            'CREATE INDEX IF NOT EXISTS idx_flights_user_id ON flights(user_id);',
            'CREATE INDEX IF NOT EXISTS idx_flights_route_id ON flights(route_id);',
            'CREATE INDEX IF NOT EXISTS idx_waitlist_email ON waitlist(email);'
        ];
        
        for (const indexSQL of indexes) {
            const { error: indexError } = await supabase.rpc('exec_sql', { sql: indexSQL });
            if (indexError) {
                console.log('❌ Index creation failed:', indexError.message);
            }
        }
        console.log('✅ Indexes created/verified');
        
        // 9. Row Level Security (RLS) aktivieren
        console.log('\n🔒 Enabling Row Level Security...');
        const rlsTables = ['users', 'travel_routes', 'route_stops', 'flights'];
        
        for (const table of rlsTables) {
            const { error: rlsError } = await supabase.rpc('exec_sql', {
                sql: `ALTER TABLE ${table} ENABLE ROW LEVEL SECURITY;`
            });
            if (rlsError) {
                console.log(`❌ RLS failed for ${table}:`, rlsError.message);
            }
        }
        console.log('✅ Row Level Security enabled');
        
        console.log('\n🎉 All PathFinder database tables created successfully!');
        console.log('📊 Tables created:');
        console.log('   👤 users - User accounts and profiles');
        console.log('   🌍 destinations - Cities, countries, and places');
        console.log('   🗺️ travel_routes - User travel itineraries');
        console.log('   📍 route_stops - Individual stops in routes');
        console.log('   🏨 hotels - Hotel information and bookings');
        console.log('   ✈️ flights - Flight information and bookings');
        console.log('   📧 waitlist - Landing page email signups');
        console.log('\n🚀 Your PathFinder database is ready for development!');
        
    } catch (error) {
        console.error('❌ Unexpected error:', error.message);
        console.error('Full error:', error);
    }
}

// Tabellen erstellen
createPathFinderTables();

