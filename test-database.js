#!/usr/bin/env node

const { createClient } = require('@supabase/supabase-js');

// Supabase Konfiguration
const supabaseUrl = 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = 'YOUR_ANON_KEY_HERE'; // Du musst deinen echten Key hier einfügen

// Erstelle Supabase Client
const supabase = createClient(supabaseUrl, supabaseKey);

async function testDatabaseConnection() {
    console.log('🚀 Testing Supabase Database Connection...\n');
    
    try {
        // Test 1: Einfache Abfrage - Tabellen auflisten
        console.log('📋 Test 1: Listing all tables...');
        const { data: tables, error: tablesError } = await supabase
            .from('information_schema.tables')
            .select('table_name')
            .eq('table_schema', 'public');
        
        if (tablesError) {
            console.log('❌ Tables query failed:', tablesError.message);
        } else {
            console.log('✅ Tables found:', tables?.length || 0);
            if (tables && tables.length > 0) {
                console.log('   Tables:', tables.map(t => t.table_name).join(', '));
            }
        }
        
        // Test 2: Test-Tabelle erstellen (falls sie nicht existiert)
        console.log('\n📝 Test 2: Creating test table...');
        const { data: createTable, error: createError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS test_connection (
                    id SERIAL PRIMARY KEY,
                    message TEXT NOT NULL,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (createError) {
            console.log('❌ Table creation failed:', createError.message);
        } else {
            console.log('✅ Test table created/verified');
        }
        
        // Test 3: Daten einfügen
        console.log('\n💾 Test 3: Inserting test data...');
        const { data: insertData, error: insertError } = await supabase
            .from('test_connection')
            .insert([
                { message: 'Hello from PathFinder MCP Test!' },
                { message: 'Database connection successful!' }
            ])
            .select();
        
        if (insertError) {
            console.log('❌ Data insertion failed:', insertError.message);
        } else {
            console.log('✅ Data inserted successfully');
            console.log('   Inserted records:', insertData?.length || 0);
        }
        
        // Test 4: Daten abrufen
        console.log('\n📖 Test 4: Reading test data...');
        const { data: readData, error: readError } = await supabase
            .from('test_connection')
            .select('*')
            .order('created_at', { ascending: false })
            .limit(5);
        
        if (readError) {
            console.log('❌ Data reading failed:', readError.message);
        } else {
            console.log('✅ Data read successfully');
            console.log('   Records found:', readData?.length || 0);
            if (readData && readData.length > 0) {
                console.log('   Latest messages:');
                readData.forEach((record, index) => {
                    console.log(`   ${index + 1}. ${record.message} (${record.created_at})`);
                });
            }
        }
        
        // Test 5: Test-Daten löschen
        console.log('\n🗑️  Test 5: Cleaning up test data...');
        const { error: deleteError } = await supabase
            .from('test_connection')
            .delete()
            .neq('id', 0); // Lösche alle Test-Daten
        
        if (deleteError) {
            console.log('❌ Data cleanup failed:', deleteError.message);
        } else {
            console.log('✅ Test data cleaned up');
        }
        
        console.log('\n🎉 Database connection test completed!');
        console.log('✅ Supabase is working correctly for PathFinder!');
        
    } catch (error) {
        console.error('❌ Unexpected error:', error.message);
        console.error('Full error:', error);
    }
}

// Test ausführen
testDatabaseConnection();

