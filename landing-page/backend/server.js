const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// File path for storing emails
const EMAILS_FILE = path.join(__dirname, 'waitlist-emails.json');

// Initialize emails file if it doesn't exist
if (!fs.existsSync(EMAILS_FILE)) {
    fs.writeFileSync(EMAILS_FILE, JSON.stringify({
        emails: [],
        totalCount: 0,
        createdAt: new Date().toISOString(),
        lastUpdated: new Date().toISOString()
    }, null, 2));
}

// Helper function to read emails
function readEmails() {
    try {
        const data = fs.readFileSync(EMAILS_FILE, 'utf8');
        return JSON.parse(data);
    } catch (error) {
        console.error('Error reading emails file:', error);
        return { emails: [], totalCount: 0 };
    }
}

// Helper function to write emails
function writeEmails(data) {
    try {
        data.lastUpdated = new Date().toISOString();
        fs.writeFileSync(EMAILS_FILE, JSON.stringify(data, null, 2));
        return true;
    } catch (error) {
        console.error('Error writing emails file:', error);
        return false;
    }
}

// Routes

// Add email to waitlist
app.post('/api/waitlist', (req, res) => {
    const { email } = req.body;
    
    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !emailRegex.test(email)) {
        return res.status(400).json({
            success: false,
            message: 'Please provide a valid email address'
        });
    }
    
    const data = readEmails();
    
    // Check if email already exists
    const emailExists = data.emails.some(entry => 
        entry.email.toLowerCase() === email.toLowerCase()
    );
    
    if (emailExists) {
        return res.status(409).json({
            success: false,
            message: 'Email already exists in waitlist'
        });
    }
    
    // Add new email
    const newEntry = {
        email: email.toLowerCase(),
        timestamp: new Date().toISOString(),
        id: Date.now().toString()
    };
    
    data.emails.push(newEntry);
    data.totalCount = data.emails.length;
    
    if (writeEmails(data)) {
        console.log(`New email added to waitlist: ${email}`);
        res.json({
            success: true,
            message: 'Successfully added to waitlist!',
            totalCount: data.totalCount
        });
    } else {
        res.status(500).json({
            success: false,
            message: 'Failed to save email. Please try again.'
        });
    }
});

// Get waitlist stats (optional - for admin purposes)
app.get('/api/waitlist/stats', (req, res) => {
    const data = readEmails();
    res.json({
        totalCount: data.totalCount,
        createdAt: data.createdAt,
        lastUpdated: data.lastUpdated
    });
});

// Get all emails (optional - for admin purposes)
app.get('/api/waitlist/emails', (req, res) => {
    const data = readEmails();
    res.json({
        emails: data.emails,
        totalCount: data.totalCount
    });
});

// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Serve static files (if you want to serve the HTML from here)
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../index.html'));
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Travely Waitlist Backend running on port ${PORT}`);
    console.log(`📧 Emails will be saved to: ${EMAILS_FILE}`);
    console.log(`🌐 Health check: http://localhost:${PORT}/api/health`);
});

module.exports = app;
