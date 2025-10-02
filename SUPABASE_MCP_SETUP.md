# 🚀 Supabase MCP Server Setup für PathFinder

## 📋 Übersicht
Dieses Setup verbindet deinen Supabase MCP Server mit der PathFinder App für direkten Datenbankzugriff und API-Integration.

## 🔧 Installation

### 1. MCP Server installiert ✅
```bash
npm install @supabase/mcp-server-supabase
```

### 2. Konfigurationsdateien erstellt ✅
- `mcp-config.json` - Hauptkonfiguration
- `start-mcp-server.sh` - Start-Script

## 🔑 Benötigte Supabase Keys

Du musst noch deine Supabase API Keys hinzufügen:

1. **Gehe zu deinem Supabase Dashboard**: https://supabase.com/dashboard
2. **Wähle dein Projekt**: `mlnrhqbnphspbqcpzwez`
3. **Gehe zu Settings → API**
4. **Kopiere die Keys**:
   - `anon` key (public)
   - `service_role` key (secret)

## 📝 Konfiguration aktualisieren

### In `mcp-config.json`:
```json
{
  "supabase": {
    "url": "https://mlnrhqbnphspbqcpzwez.supabase.co",
    "anonKey": "DEIN_ANON_KEY_HIER",
    "serviceRoleKey": "DEIN_SERVICE_ROLE_KEY_HIER"
  },
  "database": {
    "connectionString": "postgresql://postgres.mlnrhqbnphspbqcpzwez:Data%28mar19%2598ius%29data@aws-1-eu-central-1.pooler.supabase.com:6543/postgres"
  }
}
```

### In `start-mcp-server.sh`:
```bash
export SUPABASE_ANON_KEY="DEIN_ANON_KEY_HIER"
export SUPABASE_SERVICE_ROLE_KEY="DEIN_SERVICE_ROLE_KEY_HIER"
```

## 🚀 MCP Server starten

```bash
./start-mcp-server.sh
```

## 🔗 Cursor Integration

### 1. Cursor Settings öffnen
- `Cmd + ,` (macOS) oder `Ctrl + ,` (Windows/Linux)
- Gehe zu "Features" → "Model Context Protocol"

### 2. MCP Server hinzufügen
```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["@supabase/mcp-server-supabase"],
      "env": {
        "SUPABASE_URL": "https://mlnrhqbnphspbqcpzwez.supabase.co",
        "SUPABASE_ANON_KEY": "DEIN_ANON_KEY",
        "SUPABASE_SERVICE_ROLE_KEY": "DEIN_SERVICE_ROLE_KEY",
        "DATABASE_URL": "postgresql://postgres.mlnrhqbnphspbqcpzwez:Data%28mar19%2598ius%29data@aws-1-eu-central-1.pooler.supabase.com:6543/postgres"
      }
    }
  }
}
```

## 🎯 Verfügbare Funktionen

Mit dem MCP Server kannst du:

- **Datenbankabfragen** direkt ausführen
- **Tabellen erstellen/bearbeiten**
- **API-Endpoints verwalten**
- **Authentication konfigurieren**
- **Storage verwalten**
- **Real-time Subscriptions**

## 🔒 Sicherheit

⚠️ **Wichtig**: 
- Speichere deine Keys niemals in Git
- Verwende `.env` Dateien für lokale Entwicklung
- Der `service_role` Key hat Admin-Rechte - behandle ihn sicher

## 📚 Nützliche Commands

```bash
# MCP Server starten
./start-mcp-server.sh

# Server Status prüfen
npx @supabase/mcp-server-supabase --help

# Logs anzeigen
tail -f mcp-server.log
```

## 🆘 Troubleshooting

### Server startet nicht:
1. Prüfe deine Internetverbindung
2. Verifiziere deine Supabase Keys
3. Prüfe die Connection String Formatierung

### Cursor erkennt Server nicht:
1. Restart Cursor nach Konfigurationsänderungen
2. Prüfe die JSON-Syntax in den Settings
3. Verifiziere die Environment Variables

---

**🎉 Nach der Einrichtung hast du direkten Zugriff auf deine Supabase-Datenbank über Cursor!**

