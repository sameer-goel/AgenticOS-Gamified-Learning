#!/bin/bash
set -e

echo "🚀 Deploying mobile responsiveness fixes..."
echo ""

# Stage changes
echo "📝 Staging files..."
git add index.html MOBILE_FIXES_SUMMARY.md DEPLOY_INSTRUCTIONS.md mobile-fix.css init-fix.txt deploy.sh git-commit.sh

# Show status
echo ""
echo "📊 Git status:"
git status --short

# Commit
echo ""
echo "💾 Committing..."
git commit -m "fix: Mobile responsiveness for game canvas and zones

- Fixed critical init() function bug preventing mobile display
- Enhanced CSS media queries for mobile (<768px) and small (<375px) screens
- Added 44px minimum tap targets for all interactive elements
- Fixed overflow and viewport height issues
- Ensured game zones display properly on all mobile screen sizes

Fixes #mobile-responsiveness
"

# Push
echo ""
echo "🌐 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🔗 Verify at: https://sameer-goel.github.io/AgenticOS-Gamified-Learning/"
