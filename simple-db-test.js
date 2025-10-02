#!/usr/bin/env node

const { createClient } = require('@supabase/supabase-js');

// Supabase Konfiguration
const supabaseUrl = 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = 'YOUR_ANON_KEY_HERE'; // Du musst deinen echten Key hier einfügen

// Erstelle Supabase Client
const supabase = createClient(supabaseUrl, supabaseKey);

async function simpleConnectionTest() {
    console.log('🔍 Simple Supabase Connection Test\n');
    
    try {
        // Einfachste Abfrage - prüfe ob wir eine Verbindung haben
        console.log('📡 Testing connection...');
        
        const { data, error } = await supabase
            .from('_supabase_migrations')
            .select('version')
            .limit(1);
        
        if (error) {
            console.log('❌ Connection failed:', error.message);
            console.log('💡 Make sure to:');
            console.log('   1. Add your real ANON_KEY to this script');
            console.log('   2. Check your internet connection');
            console.log('   3. Verify your Supabase project is active');
            return false;
        }
        
        console.log('✅ Connection successful!');
        console.log('🎉 Supabase is ready for PathFinder!');
        return true;
        
    } catch (error) {
        console.error('❌ Unexpected error:', error.message);
        return false;
    }
}

// Test ausführen
simpleConnectionTest();

