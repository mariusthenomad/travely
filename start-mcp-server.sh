#!/bin/bash

# Supabase MCP Server Start Script
echo "🚀 Starting Supabase MCP Server for Travely..."

# Set environment variables
export SUPABASE_URL="https://mlnrhqbnphspbqcpzwez.supabase.co"
export SUPABASE_ANON_KEY="YOUR_ANON_KEY_HERE"
export SUPABASE_SERVICE_ROLE_KEY="YOUR_SERVICE_ROLE_KEY_HERE"
export DATABASE_URL="postgresql://postgres.mlnrhqbnphspbqcpzwez:Data%28mar19%2598ius%29data@aws-1-eu-central-1.pooler.supabase.com:6543/postgres"

# Start the MCP server
npx @supabase/mcp-server-supabase

echo "✅ Supabase MCP Server started!"
echo "📡 Server should be running and ready for connections"

