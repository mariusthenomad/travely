#!/usr/bin/env swift

import Foundation

// MARK: - Supabase Adventures Migration Runner
// This script will execute the adventures_supabase_migration.sql in your Supabase project

print("🚀 PathFinder Adventures Supabase Migration")
print("==========================================")

// Read the SQL migration file
let migrationFile = "adventures_supabase_migration.sql"
let currentDirectory = FileManager.default.currentDirectoryPath
let migrationPath = "\(currentDirectory)/\(migrationFile)"

print("📁 Looking for migration file at: \(migrationPath)")

guard FileManager.default.fileExists(atPath: migrationPath) else {
    print("❌ Migration file not found at: \(migrationPath)")
    print("Please make sure adventures_supabase_migration.sql exists in the current directory.")
    exit(1)
}

do {
    let migrationContent = try String(contentsOfFile: migrationPath, encoding: .utf8)
    print("✅ Migration file loaded successfully")
    print("📊 Migration contains \(migrationContent.components(separatedBy: .newlines).count) lines")
    
    // Display summary of what will be created
    let tables = [
        "adventures",
        "adventure_flights", 
        "adventure_places",
        "adventure_badges"
    ]
    
    print("\n📋 Tables that will be created:")
    for table in tables {
        print("  • \(table)")
    }
    
    print("\n🎯 Adventures that will be inserted:")
    print("  • European Adventure (€1,290, 11 nights)")
    print("  • Asian Discovery (€1,245, 21 nights)")
    print("  • Asia Adventure March 2026 (€2,664, 20 nights)")
    
    print("\n⚠️  IMPORTANT: This script only displays the migration content.")
    print("To actually execute it in Supabase:")
    print("1. Copy the content from adventures_supabase_migration.sql")
    print("2. Go to your Supabase Dashboard → SQL Editor")
    print("3. Paste and run the SQL")
    print("4. Or use Supabase CLI: supabase db push")
    
    print("\n📝 Migration SQL Preview (first 500 characters):")
    let preview = String(migrationContent.prefix(500))
    print(preview)
    if migrationContent.count > 500 {
        print("... (truncated)")
    }
    
    print("\n✅ Migration script ready!")
    print("📋 Next steps:")
    print("1. Open your Supabase Dashboard")
    print("2. Go to SQL Editor")
    print("3. Copy the entire content from adventures_supabase_migration.sql")
    print("4. Paste and execute")
    
} catch {
    print("❌ Error reading migration file: \(error)")
    exit(1)
}

