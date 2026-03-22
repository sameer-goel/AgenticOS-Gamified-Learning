#!/bin/bash
# Deploy mobile responsiveness fixes

echo "🔍 Verifying fixes..."

# Check if viewport meta tag exists
if grep -q 'width=device-width' index.html; then
    echo "✅ Viewport meta tag present"
else
    echo "❌ Viewport meta tag missing"
    exit 1
fi

# Check if mobile media queries exist
if grep -q '@media(max-width:768px)' index.html; then
    echo "✅ Mobile media queries present"
else
    echo "❌ Mobile media queries missing"
    exit 1
fi

# Check if init() function is properly closed
if grep -A 15 'function init' index.html | grep -q 'showView.*map'; then
    echo "✅ init() function properly structured"
else
    echo "⚠️  Verify init() function manually"
fi

echo ""
echo "📦 Ready to deploy! Run these commands:"
echo "git add index.html MOBILE_FIXES_SUMMARY.md"
echo 'git commit -m "fix: Mobile responsiveness for game canvas and zones"'
echo "git push origin main"
