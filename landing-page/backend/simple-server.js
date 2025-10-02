const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const nodemailer = require('nodemailer');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// File path for storing emails
const EMAILS_FILE = path.join(__dirname, 'E-Mails.txt');

// Initialize emails file if it doesn't exist
if (!fs.existsSync(EMAILS_FILE)) {
    fs.writeFileSync(EMAILS_FILE, '');
}

// Email configuration
const EMAIL_CONFIG = {
    // Gmail configuration (you'll need to set up an App Password)
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'mariusthenomad@gmail.com', // Your email
        pass: process.env.EMAIL_PASS || 'your-app-password'     // You need to set up App Password
    }
};

// Create email transporter
const transporter = nodemailer.createTransport(EMAIL_CONFIG);

// Email template
const getWelcomeEmailTemplate = (email) => {
    return {
        from: EMAIL_CONFIG.auth.user,
        to: email,
        subject: '🎉 Welcome to PathFinder Waitlist!',
        html: `
            <div style="font-family: 'Inter', Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background: #ffffff;">
                <div style="text-align: center; margin-bottom: 30px;">
                    <h1 style="color: #FF6633; font-size: 28px; margin: 0;">PathFinder</h1>
                    <p style="color: #666; font-size: 16px; margin: 10px 0 0 0;">One travel app to replace them all</p>
                </div>
                
                <div style="background: linear-gradient(135deg, #FF6633, #FF9500); padding: 30px; border-radius: 16px; text-align: center; margin-bottom: 30px;">
                    <h2 style="color: white; font-size: 24px; margin: 0 0 15px 0;">🎉 You're on the waitlist!</h2>
                    <p style="color: white; font-size: 16px; margin: 0; opacity: 0.9;">Thank you for joining us on this journey</p>
                </div>
                
                <div style="margin-bottom: 30px;">
                    <h3 style="color: #333; font-size: 20px; margin: 0 0 15px 0;">What's next?</h3>
                    <p style="color: #666; font-size: 16px; line-height: 1.6; margin: 0 0 15px 0;">
                        We're working hard to bring you the ultimate travel experience. You'll be among the first to know when PathFinder launches!
                    </p>
                    <ul style="color: #666; font-size: 16px; line-height: 1.6; margin: 0; padding-left: 20px;">
                        <li>Plan your perfect trip with AI assistance</li>
                        <li>Book flights, hotels, and activities in one place</li>
                        <li>Share your adventures with friends</li>
                        <li>Discover hidden gems around the world</li>
                    </ul>
                </div>
                
                <div style="text-align: center; margin-bottom: 30px;">
                    <p style="color: #666; font-size: 14px; margin: 0;">
                        Follow us for updates and travel inspiration
                    </p>
                </div>
                
                <div style="border-top: 1px solid #eee; padding-top: 20px; text-align: center;">
                    <p style="color: #999; font-size: 12px; margin: 0;">
                        © 2025 PathFinder. All rights reserved.<br>
                        You received this email because you joined our waitlist.
                    </p>
                </div>
            </div>
        `
    };
};

// Helper function to read emails
function readEmails() {
    try {
        const data = fs.readFileSync(EMAILS_FILE, 'utf8');
        return data.split('\n').filter(email => email.trim() !== '');
    } catch (error) {
        console.error('Error reading emails file:', error);
        return [];
    }
}

// Helper function to send welcome email
async function sendWelcomeEmail(email) {
    try {
        // Check if we have valid email credentials
        if (EMAIL_CONFIG.auth.pass === 'your-app-password') {
            console.log(`📧 [TEST MODE] Would send welcome email to: ${email}`);
            console.log(`📧 [TEST MODE] Email template preview:`);
            console.log(`📧 Subject: 🎉 Welcome to PathFinder Waitlist!`);
            console.log(`📧 To: ${email}`);
            console.log(`📧 From: ${EMAIL_CONFIG.auth.user}`);
            console.log(`📧 [TEST MODE] To enable real emails, set up Gmail App Password`);
            return { success: true, testMode: true };
        }
        
        // Test email configuration first
        await transporter.verify();
        console.log('✅ Email server connection verified');
        
        const mailOptions = getWelcomeEmailTemplate(email);
        const info = await transporter.sendMail(mailOptions);
        console.log(`✅ Welcome email sent to: ${email}`);
        console.log(`📧 Message ID: ${info.messageId}`);
        return { success: true };
    } catch (error) {
        console.error('❌ Error sending welcome email:', error.message);
        console.error('🔧 Full error:', error);
        return { success: false, error: error.message };
    }
}

// Helper function to add email
async function addEmail(email) {
    try {
        const emails = readEmails();
        
        // Check if email already exists (check only the email part before the timestamp)
        const emailExists = emails.some(existingEmail => {
            const emailPart = existingEmail.split(' - ')[0];
            return emailPart === email.toLowerCase();
        });
        
        if (emailExists) {
            return { success: false, message: 'Email already exists' };
        }
        
        // Add new email with timestamp
        const timestamp = new Date().toLocaleString('de-DE');
        const emailEntry = `${email.toLowerCase()} - ${timestamp}\n`;
        
        fs.appendFileSync(EMAILS_FILE, emailEntry);
        console.log(`New email added: ${email}`);
        
        // Send welcome email
        const emailResult = await sendWelcomeEmail(email);
        if (!emailResult.success) {
            console.warn(`Failed to send welcome email to ${email}:`, emailResult.error);
            // Don't fail the whole operation if email sending fails
        }
        
        return { success: true, message: 'Email added successfully' };
    } catch (error) {
        console.error('Error adding email:', error);
        return { success: false, message: 'Error saving email' };
    }
}

// Routes

// Add email to waitlist
app.post('/api/waitlist', async (req, res) => {
    const { email } = req.body;
    
    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !emailRegex.test(email)) {
        return res.status(400).json({
            success: false,
            message: 'Please provide a valid email address'
        });
    }
    
    const result = await addEmail(email);
    
    if (result.success) {
        res.json({
            success: true,
            message: 'Successfully added to waitlist!'
        });
    } else {
        res.status(409).json({
            success: false,
            message: result.message
        });
    }
});

// Get all emails (for admin purposes)
app.get('/api/emails', (req, res) => {
    const emails = readEmails();
    res.json({
        emails: emails,
        totalCount: emails.length
    });
});

// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 PathFinder Waitlist Server running on port ${PORT}`);
    console.log(`📧 Emails will be saved to: ${EMAILS_FILE}`);
    console.log(`🌐 Health check: http://localhost:${PORT}/api/health`);
});

module.exports = app;
