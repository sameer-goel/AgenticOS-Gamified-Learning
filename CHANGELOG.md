# Changelog — AgenticOS Gamified Learning

## 2026-03-21 — Mobile Gestures v1.0

### Added
✅ **Swipe Navigation** — Navigate between levels with horizontal swipes
- Swipe left → next level (if current level is complete)
- Swipe right → previous level
- Angle detection prevents accidental triggers during vertical scrolling
- 80px swipe threshold for intentional gestures only

✅ **Touch-Friendly Drag & Drop** — Complete rewrite for mobile
- Visual feedback: 0.5 opacity + 1.05 scale during drag
- Drop zone highlighting with `.over` class
- Works for both drag-match challenges and ordering challenges
- Proper touch event handling with passive/active flags for performance

### Technical Details
- **Touch events**: `touchstart`, `touchmove`, `touchend`
- **Swipe detection**: Uses angle math to distinguish horizontal vs vertical gestures
- **Element detection**: `document.elementFromPoint()` for accurate drop targeting
- **Conflict prevention**: Separate listeners for swipe vs drag operations
- **138 lines** of new JavaScript code added at line 2727

### Files Modified
- `index.html` — Added mobile gesture handlers (2746 → 2864 lines)
- `development-queue.md` — Marked `mobile-gestures` as complete, moved `[NEXT]` to `daily-challenge`

### Testing Recommendations
1. Test on iOS Safari, Android Chrome
2. Verify swipe works in level view but not in zone map
3. Confirm drag & drop works for both match and ordering challenges
4. Check that vertical scrolling isn't blocked
5. Validate that locked levels don't respond to swipes

### Next Up
`daily-challenge` — Auto-generated daily challenge from random levels with bonus XP
