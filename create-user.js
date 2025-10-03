const { createClient } = require('@supabase/supabase-js');

// Supabase-Konfiguration aus deiner App
const supabaseUrl = 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw';

// Supabase-Client erstellen
const supabase = createClient(supabaseUrl, supabaseKey);

async function createTestUser() {
    console.log('🚀 Erstelle Test-Benutzer in Supabase...\n');
    
    // Test-Benutzer Daten
    const testUser = {
        email: 'test@pathfinder.app',
        password: 'TestPassword123!',
        user_metadata: {
            name: 'Test User',
            app_name: 'PathFinder',
            created_by: 'script'
        }
    };
    
    try {
        // Benutzer registrieren
        console.log(`📧 Registriere Benutzer: ${testUser.email}`);
        const { data, error } = await supabase.auth.signUp({
            email: testUser.email,
            password: testUser.password,
            options: {
                data: testUser.user_metadata
            }
        });
        
        if (error) {
            console.error('❌ Fehler beim Erstellen des Benutzers:', error.message);
            
            // Prüfe, ob der Benutzer bereits existiert
            if (error.message.includes('already registered')) {
                console.log('ℹ️  Benutzer existiert bereits. Versuche Anmeldung...');
                
                // Versuche Anmeldung
                const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
                    email: testUser.email,
                    password: testUser.password
                });
                
                if (signInError) {
                    console.error('❌ Fehler bei der Anmeldung:', signInError.message);
                } else {
                    console.log('✅ Benutzer erfolgreich angemeldet!');
                    console.log('👤 Benutzer-ID:', signInData.user.id);
                    console.log('📧 E-Mail:', signInData.user.email);
                    console.log('📅 Erstellt am:', signInData.user.created_at);
                }
            }
        } else {
            console.log('✅ Benutzer erfolgreich erstellt!');
            console.log('👤 Benutzer-ID:', data.user.id);
            console.log('📧 E-Mail:', data.user.email);
            console.log('📅 Erstellt am:', data.user.created_at);
            
            if (data.session) {
                console.log('🔑 Session erstellt:', data.session.access_token ? 'Ja' : 'Nein');
            }
        }
        
    } catch (err) {
        console.error('❌ Unerwarteter Fehler:', err.message);
    }
}

async function listUsers() {
    console.log('\n📋 Lade alle Benutzer...\n');
    
    try {
        // Hinweis: Um alle Benutzer zu sehen, brauchst du Admin-Rechte
        // Für normale Benutzer können wir nur den aktuellen Benutzer sehen
        const { data: { user }, error } = await supabase.auth.getUser();
        
        if (error) {
            console.log('ℹ️  Kein angemeldeter Benutzer gefunden');
        } else if (user) {
            console.log('👤 Aktueller Benutzer:');
            console.log('   ID:', user.id);
            console.log('   E-Mail:', user.email);
            console.log('   Erstellt:', user.created_at);
            console.log('   Bestätigt:', user.email_confirmed_at ? 'Ja' : 'Nein');
        }
        
    } catch (err) {
        console.error('❌ Fehler beim Laden der Benutzer:', err.message);
    }
}

async function testConnection() {
    console.log('🔗 Teste Supabase-Verbindung...\n');
    
    try {
        // Teste die Verbindung mit einer einfachen Abfrage
        const { data, error } = await supabase
            .from('countries')
            .select('count')
            .limit(1);
        
        if (error) {
            console.log('⚠️  Verbindung funktioniert, aber Tabelle "countries" existiert nicht oder ist nicht zugänglich');
            console.log('   Fehler:', error.message);
        } else {
            console.log('✅ Supabase-Verbindung erfolgreich!');
        }
        
    } catch (err) {
        console.error('❌ Verbindungsfehler:', err.message);
    }
}

// Hauptfunktion
async function main() {
    console.log('🎯 PathFinder Supabase Benutzer-Management\n');
    console.log('=' .repeat(50));
    
    // Teste zuerst die Verbindung
    await testConnection();
    
    // Erstelle Test-Benutzer
    await createTestUser();
    
    // Zeige Benutzer-Info
    await listUsers();
    
    console.log('\n' + '=' .repeat(50));
    console.log('✨ Fertig! Du kannst jetzt den Test-Benutzer in deiner App verwenden.');
    console.log('📧 E-Mail: test@pathfinder.app');
    console.log('🔑 Passwort: TestPassword123!');
}

// Skript ausführen
main().catch(console.error);
