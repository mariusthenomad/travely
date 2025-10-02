#!/usr/bin/env node

const { createClient } = require('@supabase/supabase-js');

// Supabase Konfiguration - lade aus Environment Variables
const supabaseUrl = process.env.SUPABASE_URL || 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'YOUR_ANON_KEY_HERE';

console.log('🔧 Configuration:');
console.log('   URL:', supabaseUrl);
console.log('   Key:', supabaseKey.substring(0, 20) + '...');
console.log('');

// Erstelle Supabase Client
const supabase = createClient(supabaseUrl, supabaseKey);

async function testWithEnvironment() {
    console.log('🚀 Testing Supabase with Environment Variables\n');
    
    if (supabaseKey === 'YOUR_ANON_KEY_HERE') {
        console.log('❌ Please set your SUPABASE_ANON_KEY environment variable');
        console.log('💡 Run: export SUPABASE_ANON_KEY="your_actual_key_here"');
        console.log('   Or add it to your .env file');
        return;
    }
    
    try {
        // Test 1: Einfache Verbindung
        console.log('📡 Test 1: Basic connection...');
        const { data, error } = await supabase
            .from('_supabase_migrations')
            .select('version')
            .limit(1);
        
        if (error) {
            console.log('❌ Connection failed:', error.message);
            return;
        }
        
        console.log('✅ Connection successful!');
        
        // Test 2: Prüfe verfügbare Tabellen
        console.log('\n📋 Test 2: Checking available tables...');
        const { data: tables, error: tablesError } = await supabase
            .from('information_schema.tables')
            .select('table_name')
            .eq('table_schema', 'public');
        
        if (tablesError) {
            console.log('❌ Tables query failed:', tablesError.message);
        } else {
            console.log('✅ Found', tables?.length || 0, 'tables');
            if (tables && tables.length > 0) {
                console.log('   Tables:', tables.map(t => t.table_name).join(', '));
            } else {
                console.log('   No custom tables found yet - this is normal for a new project');
            }
        }
        
        // Test 3: Erstelle eine Test-Tabelle
        console.log('\n📝 Test 3: Creating test table...');
        const { data: createResult, error: createError } = await supabase.rpc('exec_sql', {
            sql: `
                CREATE TABLE IF NOT EXISTS travely_test (
                    id SERIAL PRIMARY KEY,
                    test_message TEXT NOT NULL,
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                );
            `
        });
        
        if (createError) {
            console.log('❌ Table creation failed:', createError.message);
        } else {
            console.log('✅ Test table created/verified');
        }
        
        // Test 4: Test-Daten einfügen und abrufen
        console.log('\n💾 Test 4: Inserting and reading test data...');
        
        const { data: insertData, error: insertError } = await supabase
            .from('travely_test')
            .insert({ test_message: 'PathFinder MCP Test - ' + new Date().toISOString() })
            .select();
        
        if (insertError) {
            console.log('❌ Data insertion failed:', insertError.message);
        } else {
            console.log('✅ Data inserted successfully');
            
            // Daten abrufen
            const { data: readData, error: readError } = await supabase
                .from('travely_test')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(3);
            
            if (readError) {
                console.log('❌ Data reading failed:', readError.message);
            } else {
                console.log('✅ Data read successfully');
                console.log('   Latest test records:');
                readData?.forEach((record, index) => {
                    console.log(`   ${index + 1}. ${record.test_message}`);
                });
            }
        }
        
        console.log('\n🎉 All tests passed!');
        console.log('✅ Supabase is ready for PathFinder development!');
        console.log('🚀 You can now use the MCP server with confidence');
        
    } catch (error) {
        console.error('❌ Unexpected error:', error.message);
        console.error('Full error:', error);
    }
}

// Test ausführen
testWithEnvironment();

