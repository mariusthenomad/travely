# PathFinder Waitlist Backend

A simple Node.js backend to collect email addresses for the PathFinder app waitlist.

## Features

- ✅ Collect email addresses via API
- ✅ Store emails in JSON file
- ✅ Email validation
- ✅ Duplicate email prevention
- ✅ CORS enabled for frontend integration
- ✅ Health check endpoint
- ✅ Admin endpoints for viewing stats

## Setup

1. **Install dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **Start the server:**
   ```bash
   npm start
   ```
   
   Or for development with auto-restart:
   ```bash
   npm run dev
   ```

3. **Server will run on:** `http://localhost:3000`

## API Endpoints

### Add Email to Waitlist
```
POST /api/waitlist
Content-Type: application/json

{
  "email": "user@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Successfully added to waitlist!",
  "totalCount": 42
}
```

### Get Waitlist Stats
```
GET /api/waitlist/stats
```

**Response:**
```json
{
  "totalCount": 42,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "lastUpdated": "2024-01-01T12:00:00.000Z"
}
```

### Get All Emails (Admin)
```
GET /api/waitlist/emails
```

### Health Check
```
GET /api/health
```

## Data Storage

Emails are stored in `waitlist-emails.json` with the following structure:

```json
{
  "emails": [
    {
      "email": "user@example.com",
      "timestamp": "2024-01-01T12:00:00.000Z",
      "id": "1704110400000"
    }
  ],
  "totalCount": 1,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "lastUpdated": "2024-01-01T12:00:00.000Z"
}
```

## Environment Variables

- `PORT`: Server port (default: 3000)

## Deployment

For production deployment, consider:

1. **Environment variables** for configuration
2. **Database** instead of JSON file for better scalability
3. **Rate limiting** to prevent spam
4. **Email verification** before adding to waitlist
5. **HTTPS** for security

## Security Notes

- Basic email validation is implemented
- Duplicate emails are prevented
- CORS is enabled for frontend integration
- No authentication required (suitable for public waitlist)

## File Structure

```
backend/
├── package.json          # Dependencies and scripts
├── server.js            # Main server file
├── waitlist-emails.json # Email storage (auto-created)
└── README.md           # This file
```
