# 🎮 OpenClaw Academy — Gamified Interactive Tutorial

An interactive, gamified single-page tutorial that teaches the OpenClaw autonomous AI agent framework from zero to hero. Built as a self-contained HTML file with no external dependencies (beyond Google Fonts).

## How to Run

Just open `index.html` in any modern browser. No build step, no server, no dependencies.

```bash
open index.html
# or
python -m http.server 8000  # then visit http://localhost:8000
```

## Features

- **8 Themed Zones** — From "Getting Started" to "Deploy on AWS", each zone covers a core concept
- **31 Levels** — Progressive curriculum with explanations, key takeaways, and challenges
- **7 Challenge Types** — Multiple choice, drag & drop matching, ordering, fill-in-the-blank, true/false rapid fire, checklists, and creative writing
- **XP & Ranking System** — Earn XP through challenges, speed bonuses, and streaks. Progress through 10 ranks from 🐣 Curious Human to 👑 OpenClaw Master
- **20 Badges** — Zone completion badges + special achievement badges (First Blood, Speed Demon, Story Collector, etc.)
- **20 Real-World Stories** — Practitioner stories from Bhanu and Florian unlocked by completing levels
- **Sound Effects** — Web Audio API synthesized sounds (toggleable)
- **Confetti Celebrations** — Canvas-based confetti for badge unlocks and graduation
- **Persistent Progress** — All progress saved to localStorage
- **Responsive Design** — Desktop sidebar navigation, mobile bottom tabs
- **Accessibility** — ARIA live regions, keyboard navigation, reduced motion support
- **Graduation Ceremony** — Complete all zones to unlock the final ceremony with next-step recommendations

## Content Source

Educational content is based on:
- **Jay's OpenClaw Tutorial** — Comprehensive walkthrough of the OpenClaw framework
- **Bhanu & Florian's Podcast** — Real-world practitioner stories and insights about building with autonomous AI agents

## Tech Stack

- Single HTML file (~1700 lines)
- Vanilla CSS with CSS custom properties
- Vanilla JavaScript (no frameworks)
- Google Fonts (Inter, JetBrains Mono, Orbitron)
- Web Audio API for sound effects
- Canvas API for confetti
- localStorage for persistence
