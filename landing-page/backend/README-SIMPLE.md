# Travely Waitlist - Einfache Version

Eine super einfache Version, die alle Email-Adressen direkt in einer `E-Mails.txt` Datei speichert.

## 🚀 Schnellstart

```bash
cd backend
./start.sh
```

Oder manuell:
```bash
cd backend
npm install
npm start
```

## 📧 Email-Speicherung

Alle Emails werden in der Datei `E-Mails.txt` gespeichert im Format:
```
user@example.com - 01.01.2024, 12:00:00
another@example.com - 01.01.2024, 12:05:00
```

## 🔧 API Endpoints

### Email hinzufügen
```
POST http://localhost:3000/api/waitlist
Content-Type: application/json

{
  "email": "user@example.com"
}
```

### Alle Emails anzeigen
```
GET http://localhost:3000/api/emails
```

### Health Check
```
GET http://localhost:3000/api/health
```

## 📁 Dateien

- `E-Mails.txt` - Alle Email-Adressen mit Zeitstempel
- `simple-server.js` - Einfacher Server
- `start.sh` - Start-Script

## ✨ Features

- ✅ Einfache Text-Datei Speicherung
- ✅ Email-Validation
- ✅ Duplicate-Check
- ✅ Zeitstempel
- ✅ CORS für Frontend
- ✅ Deutsche Zeitstempel

## 🔒 Datenschutz

- Keine Datenbank
- Nur lokale Text-Datei
- Keine externen Services
- Vollständige Kontrolle über die Daten
