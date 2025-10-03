const { createClient } = require('@supabase/supabase-js');

// Supabase-Konfiguration
const supabaseUrl = 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw';

const supabase = createClient(supabaseUrl, supabaseKey);

// Verschiedene Test-Benutzer
const testUsers = [
    {
        email: 'admin@pathfinder.app',
        password: 'AdminPass123!',
        user_metadata: {
            name: 'Admin User',
            role: 'admin',
            app_name: 'PathFinder'
        }
    },
    {
        email: 'user@pathfinder.app',
        password: 'UserPass123!',
        user_metadata: {
            name: 'Regular User',
            role: 'user',
            app_name: 'PathFinder'
        }
    },
    {
        email: 'demo@pathfinder.app',
        password: 'DemoPass123!',
        user_metadata: {
            name: 'Demo User',
            role: 'demo',
            app_name: 'PathFinder'
        }
    }
];

async function createMultipleUsers() {
    console.log('🚀 Erstelle mehrere Test-Benutzer...\n');
    
    for (const user of testUsers) {
        try {
            console.log(`📧 Erstelle Benutzer: ${user.email}`);
            
            const { data, error } = await supabase.auth.signUp({
                email: user.email,
                password: user.password,
                options: {
                    data: user.user_metadata
                }
            });
            
            if (error) {
                if (error.message.includes('already registered')) {
                    console.log(`   ⚠️  Benutzer ${user.email} existiert bereits`);
                } else {
                    console.log(`   ❌ Fehler: ${error.message}`);
                }
            } else {
                console.log(`   ✅ Erfolgreich erstellt!`);
                console.log(`   👤 ID: ${data.user.id}`);
            }
            
        } catch (err) {
            console.log(`   ❌ Unerwarteter Fehler: ${err.message}`);
        }
        
        console.log(''); // Leerzeile
    }
}

async function showAllTestUsers() {
    console.log('📋 Alle Test-Benutzer:\n');
    console.log('=' .repeat(60));
    
    const allUsers = [
        { email: 'test@pathfinder.app', password: 'TestPassword123!', name: 'Test User' },
        { email: 'admin@pathfinder.app', password: 'AdminPass123!', name: 'Admin User' },
        { email: 'user@pathfinder.app', password: 'UserPass123!', name: 'Regular User' },
        { email: 'demo@pathfinder.app', password: 'DemoPass123!', name: 'Demo User' }
    ];
    
    allUsers.forEach((user, index) => {
        console.log(`${index + 1}. ${user.name}`);
        console.log(`   📧 E-Mail: ${user.email}`);
        console.log(`   🔑 Passwort: ${user.password}`);
        console.log('');
    });
    
    console.log('=' .repeat(60));
    console.log('💡 Du kannst diese Benutzer in deiner PathFinder App verwenden!');
}

// Hauptfunktion
async function main() {
    console.log('🎯 PathFinder - Mehrere Test-Benutzer erstellen\n');
    
    await createMultipleUsers();
    await showAllTestUsers();
}

main().catch(console.error);
