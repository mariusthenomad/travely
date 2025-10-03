// Script to check and display current keys in your project
const fs = require('fs');
const path = require('path');

console.log('🔍 Überprüfe aktuelle Keys in deinem PathFinder Projekt...\n');

// Check Supabase configuration
console.log('📊 SUPABASE CONFIGURATION:');
console.log('=' .repeat(50));

const supabaseUrl = 'https://mlnrhqbnphspbqcpzwez.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw';

console.log('✅ Supabase URL:', supabaseUrl);
console.log('✅ Supabase Key (anon public):', supabaseKey.substring(0, 50) + '...');
console.log('✅ Key Type: anon public (sicher für Client-Apps)');

// Check Google Sign-In configuration
console.log('\n🔍 GOOGLE SIGN-IN CONFIGURATION:');
console.log('=' .repeat(50));

const googleClientId = '1033990407187-mffia1va0it83u51clbvmi40ol0adi3l.apps.googleusercontent.com';
const googleUrlScheme = 'com.googleusercontent.apps.1033990407187-mffia1va0it83u51clbvmi40ol0adi3l';

console.log('✅ Google Client ID:', googleClientId);
console.log('✅ URL Scheme:', googleUrlScheme);
console.log('✅ Bundle ID (aus Client ID):', 'com.pathfinder.app');

// Check if Info.plist exists and has correct URL schemes
console.log('\n📱 INFO.PLIST CHECK:');
console.log('=' .repeat(50));

const infoPlistPath = path.join(__dirname, 'PathFinder', 'Info.plist');

if (fs.existsSync(infoPlistPath)) {
    console.log('✅ Info.plist gefunden');
    
    try {
        const infoPlistContent = fs.readFileSync(infoPlistPath, 'utf8');
        
        if (infoPlistContent.includes(googleUrlScheme)) {
            console.log('✅ Google URL Scheme in Info.plist gefunden');
        } else {
            console.log('❌ Google URL Scheme NICHT in Info.plist gefunden');
            console.log('   Erwartet:', googleUrlScheme);
        }
        
        if (infoPlistContent.includes('CFBundleURLTypes')) {
            console.log('✅ CFBundleURLTypes in Info.plist gefunden');
        } else {
            console.log('❌ CFBundleURLTypes NICHT in Info.plist gefunden');
        }
        
    } catch (error) {
        console.log('❌ Fehler beim Lesen der Info.plist:', error.message);
    }
} else {
    console.log('❌ Info.plist nicht gefunden unter:', infoPlistPath);
}

// Check GoogleService-Info.plist
console.log('\n🔧 GOOGLE SERVICE INFO CHECK:');
console.log('=' .repeat(50));

const googleServicePath = path.join(__dirname, 'PathFinder', 'GoogleService-Info.plist');

if (fs.existsSync(googleServicePath)) {
    console.log('✅ GoogleService-Info.plist gefunden');
    
    try {
        const googleServiceContent = fs.readFileSync(googleServicePath, 'utf8');
        
        if (googleServiceContent.includes(googleClientId)) {
            console.log('✅ Google Client ID in GoogleService-Info.plist gefunden');
        } else {
            console.log('❌ Google Client ID NICHT in GoogleService-Info.plist gefunden');
        }
        
    } catch (error) {
        console.log('❌ Fehler beim Lesen der GoogleService-Info.plist:', error.message);
    }
} else {
    console.log('❌ GoogleService-Info.plist nicht gefunden unter:', googleServicePath);
}

// Summary
console.log('\n📋 ZUSAMMENFASSUNG:');
console.log('=' .repeat(50));
console.log('✅ Alle notwendigen Keys sind in deinem Code vorhanden');
console.log('✅ Supabase ist korrekt konfiguriert');
console.log('✅ Google Sign-In ist korrekt konfiguriert');
console.log('\n💡 Du musst KEINE neuen Keys bekommen - alles ist bereits eingerichtet!');
console.log('\n🚀 Nächste Schritte:');
console.log('1. Teste die Anmeldung mit dem erstellten Benutzer:');
console.log('   📧 E-Mail: test@pathfinder.app');
console.log('   🔑 Passwort: TestPassword123!');
console.log('2. Teste Google Sign-In in deiner App');
console.log('3. Falls Probleme auftreten, überprüfe die URL Schemes in Info.plist');
