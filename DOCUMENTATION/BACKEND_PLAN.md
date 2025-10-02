# Backend Development Plan - PathFinder

## Current Status
- ✅ **Search functionalities implemented**: Country and city search already working
- 🚧 **Backend architecture**: Still to be expanded and completed

---

## Backend Components

### Database Schema
```sql
-- Countries table (already available)
countries_schema.sql

-- Main database schema
database_schema.sql
```

### Search Functions (✅ Implemented)
- [x] Country search
- [x] City search
- [x] Destination search

### Still to be implemented

#### Authentication
- [ ] User Registration/Login API
- [ ] JWT Token Management
- [ ] Password Reset Functionality
- [ ] Email Verification

#### User Management
- [ ] User Profile Management
- [ ] User Preferences
- [ ] User Settings API

#### Travel Features
- [ ] Route Saving/Loading
- [ ] Favorites Management
- [ ] Travel History
- [ ] Itinerary Management

#### Subscription Management
- [ ] Subscription Status API
- [ ] Payment Verification
- [ ] Feature Access Control

#### Mobile Integration
- [ ] Push Notifications
- [ ] Offline Sync
- [ ] Data Caching

---

## Technology Stack

### Backend Framework
- **Node.js** + Express
- **TypeScript** for Type Safety
- **Prisma** as ORM
- **PostgreSQL** as database

### Authentication
- **JWT** for Token Management
- **bcrypt** for Password Hashing
- **Google/Apple OAuth** Integration

### APIs
- **REST API** for Standard Operations
- **GraphQL** for complex queries (optional)

---

## Implementation Order

### Phase 1: Core Backend
1. **User Authentication System**
   - Registration/Login
   - JWT Implementation
   - Password Management

2. **Basic User Management**
   - Profile CRUD
   - Settings Management

### Phase 2: Travel Features
1. **Route Management**
   - Save/Load Routes
   - Route Sharing
   - Route History

2. **Favorites System**
   - Save Destinations
   - Favorite Routes
   - Quick Access

### Phase 3: Advanced Features
1. **Subscription Integration**
   - Payment Processing
   - Feature Gating
   - Usage Analytics

2. **Performance & Scaling**
   - Caching Layer
   - API Optimization
   - Database Indexing

---

## Development Setup

### Local Development
```bash
# Backend Repository Setup
npm install
npm run dev

# Database Setup
npm run db:migrate
npm run db:seed
```

### Environment Variables
```env
DATABASE_URL="postgresql://..."
JWT_SECRET="your-secret-key"
GOOGLE_CLIENT_ID="..."
APPLE_CLIENT_ID="..."
```

---

## API Endpoints (Planned)

### Authentication
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/logout
POST /api/auth/refresh
POST /api/auth/forgot-password
POST /api/auth/reset-password
```

### User Management
```
GET /api/user/profile
PUT /api/user/profile
GET /api/user/settings
PUT /api/user/settings
```

### Travel Features
```
GET /api/search/countries
GET /api/search/cities
GET /api/search/destinations
POST /api/routes
GET /api/routes
PUT /api/routes/:id
DELETE /api/routes/:id
```

### Subscription
```
GET /api/subscription/status
POST /api/subscription/restore
GET /api/subscription/features
```

---

*Backend Entwicklungsplan - PathFinder iOS App*
