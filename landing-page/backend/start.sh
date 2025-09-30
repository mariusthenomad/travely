#!/bin/bash

echo "🚀 Starting Travely Waitlist Server..."
echo "📧 Emails will be saved to: E-Mails.txt"
echo ""

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the server
echo "🌟 Starting server on http://localhost:3000"
npm start
