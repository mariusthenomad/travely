#!/usr/bin/env node

const { createClient } = require('@supabase/supabase-js');

// Supabase Konfiguration
const supabaseUrl = 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = 'YOUR_ANON_KEY_HERE'; // Du musst deinen echten Key hier einfügen

// Erstelle Supabase Client
const supabase = createClient(supabaseUrl, supabaseKey);

async function quickTest() {
    console.log('🔍 Quick Supabase Test für PathFinder\n');
    
    if (supabaseKey === 'YOUR_ANON_KEY_HERE') {
        console.log('❌ Bitte füge deinen echten SUPABASE_ANON_KEY ein!');
        console.log('💡 Gehe zu: https://supabase.com/dashboard');
        console.log('   → Wähle dein Projekt: mlnrhqbnphspbqcpzwez');
        console.log('   → Settings → API → Kopiere den "anon" key');
        console.log('   → Ersetze "YOUR_ANON_KEY_HERE" in dieser Datei');
        return;
    }
    
    try {
        console.log('📡 Teste Verbindung...');
        
        // Einfachste Abfrage
        const { data, error } = await supabase
            .from('_supabase_migrations')
            .select('version')
            .limit(1);
        
        if (error) {
            console.log('❌ Verbindung fehlgeschlagen:', error.message);
            return;
        }
        
        console.log('✅ Verbindung erfolgreich!');
        console.log('🎉 Supabase funktioniert für PathFinder!');
        
        // Prüfe ob Tabellen existieren
        console.log('\n📋 Prüfe vorhandene Tabellen...');
        const { data: tables, error: tablesError } = await supabase
            .from('information_schema.tables')
            .select('table_name')
            .eq('table_schema', 'public');
        
        if (tablesError) {
            console.log('❌ Tabellen-Abfrage fehlgeschlagen:', tablesError.message);
        } else {
            const tableNames = tables?.map(t => t.table_name) || [];
            console.log('✅ Gefundene Tabellen:', tableNames.length);
            
            if (tableNames.length > 0) {
                console.log('   Tabellen:', tableNames.join(', '));
            } else {
                console.log('   Noch keine Tabellen - das ist normal für ein neues Projekt');
                console.log('   💡 Führe "node create-tables.js" aus, um Tabellen zu erstellen');
            }
        }
        
    } catch (error) {
        console.error('❌ Unerwarteter Fehler:', error.message);
    }
}

// Test ausführen
quickTest();

