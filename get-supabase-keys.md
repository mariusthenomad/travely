# Supabase Keys bekommen

## 1. Gehe zu deinem Supabase Dashboard
- URL: https://supabase.com/dashboard
- Logge dich ein

## 2. Wähle dein Projekt
- Klicke auf "PathFinder" oder dein Projekt

## 3. Gehe zu Settings → API
- Linke Seitenleiste: **Settings**
- Klicke auf **API**

## 4. Kopiere die Keys
Du findest dort:

### Project URL
```
https://mlnrhqbnphspbqcpzwez.supabase.co
```

### API Keys
- **anon public** (für Client-seitige Apps)
- **service_role** (für Server-seitige Apps - NIEMALS in Client-Code verwenden!)

### Beispiel:
```
anon public: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw

service_role: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODgzMjEyNywiZXhwIjoyMDc0NDA4MTI3fQ.nnf5LWeI6yDkofBvswfsZr4ff59s8VxmOdzQmj2W8D0
```

## 5. Verwendung in deiner App
```swift
let supabaseURL = URL(string: "https://mlnrhqbnphspbqcpzwez.supabase.co")!
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw"
```

## ⚠️ Wichtige Hinweise:
- Verwende IMMER den **anon public** Key in deiner iOS App
- NIEMALS den **service_role** Key in Client-Code verwenden
- Der **anon** Key ist sicher für Client-seitige Apps
