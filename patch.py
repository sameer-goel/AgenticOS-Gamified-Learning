#!/usr/bin/env python3
import sys

# Read the file
with open('index.html', 'r') as f:
    lines = f.readlines()

# HTML modal to insert after line 521 (after </div> for badge-celebration)
html_modal = """
<!-- Share Card Modal -->
<div id="share-card-modal" role="dialog" aria-label="Share achievement card">
  <div class="share-card-container">
    <h2>📤 Share Your Achievement</h2>
    <div class="share-card-preview" id="share-card-preview">
      <canvas id="share-canvas" width="800" height="1000"></canvas>
    </div>
    <div class="share-card-options" id="share-card-options">
      <div class="share-card-option selected" data-type="badge" onclick="selectShareType(this,'badge')">
        <div class="radio"></div>
        <div><strong>🏆 Badge Card</strong><br><span style="color:var(--text2);font-size:0.8rem">Share your latest badge</span></div>
      </div>
      <div class="share-card-option" data-type="stats" onclick="selectShareType(this,'stats')">
        <div class="radio"></div>
        <div><strong>📊 Stats Card</strong><br><span style="color:var(--text2);font-size:0.8rem">Show your progress</span></div>
      </div>
      <div class="share-card-option" data-type="zone" onclick="selectShareType(this,'zone')">
        <div class="radio"></div>
        <div><strong>🗺️ Zone Complete</strong><br><span style="color:var(--text2);font-size:0.8rem">Celebrate zone completion</span></div>
      </div>
    </div>
    <div class="share-card-actions">
      <button class="btn-download" onclick="downloadShareCard()">⬇️ Download PNG</button>
      <button class="btn-close-share" onclick="closeShareModal()">Close</button>
    </div>
  </div>
</div>

"""

# Insert HTML modal after line 521 (0-indexed: 520)
lines.insert(522, html_modal)

print("✅ HTML modal inserted")

# JavaScript functions to insert before init() function
# Find the line with "function init()"
init_line = None
for i, line in enumerate(lines):
    if 'function init(){' in line:
        init_line = i
        break

if init_line:
    js_code = """
// ===== SHARE CARDS =====
let currentShareType='badge';
let currentShareData=null;

function openShareModal(type='badge',data=null){
  currentShareType=type;
  currentShareData=data||{};
  
  // Auto-fill data if not provided
  if(!currentShareData.badge && type==='badge' && state.badges.length>0){
    const lastBadgeId=state.badges[state.badges.length-1];
    // Find badge info
    const zoneBadge=ZONES.find(z=>z.badge.id===lastBadgeId)?.badge;
    const specialBadge=SPECIAL_BADGES.find(b=>b.id===lastBadgeId);
    currentShareData.badge=zoneBadge||specialBadge;
  }
  if(!currentShareData.zone && type==='zone'){
    const completedZones=ZONES.filter(z=>isZoneCompleted(z.id));
    if(completedZones.length>0){
      currentShareData.zone=completedZones[completedZones.length-1];
    }
  }
  
  document.getElementById('share-card-modal').classList.add('show');
  renderShareCard(currentShareType);
  playSound('click');
}

function closeShareModal(){
  document.getElementById('share-card-modal').classList.remove('show');
  playSound('click');
}

function selectShareType(el,type){
  document.querySelectorAll('.share-card-option').forEach(o=>o.classList.remove('selected'));
  el.classList.add('selected');
  currentShareType=type;
  renderShareCard(type);
  playSound('click');
}

function renderShareCard(type){
  const canvas=document.getElementById('share-canvas');
  const ctx=canvas.getContext('2d');
  
  // Clear canvas
  ctx.clearRect(0,0,canvas.width,canvas.height);
  
  // Background gradient
  const gradient=ctx.createLinearGradient(0,0,0,canvas.height);
  gradient.addColorStop(0,'#0A0A0F');
  gradient.addColorStop(1,'#1A1A2E');
  ctx.fillStyle=gradient;
  ctx.fillRect(0,0,canvas.width,canvas.height);
  
  // Border glow
  ctx.strokeStyle='rgba(0,240,255,0.3)';
  ctx.lineWidth=4;
  ctx.strokeRect(10,10,canvas.width-20,canvas.height-20);
  
  if(type==='badge'){
    renderBadgeCard(ctx);
  } else if(type==='stats'){
    renderStatsCard(ctx);
  } else if(type==='zone'){
    renderZoneCard(ctx);
  }
  
  // Footer branding
  ctx.fillStyle='rgba(255,255,255,0.4)';
  ctx.font='24px "Inter", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('OpenClaw Academy',canvas.width/2,canvas.height-40);
}

function renderBadgeCard(ctx){
  const badge=currentShareData.badge||{icon:'🏆',name:'Achievement',desc:'Badge earned!'};
  
  // Title
  ctx.fillStyle='#FFFFFF';
  ctx.font='bold 48px "Orbitron", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('Achievement Unlocked',canvas.width/2,120);
  
  // Badge icon (emoji)
  ctx.font='200px "Inter", sans-serif';
  ctx.fillText(badge.icon,canvas.width/2,380);
  
  // Badge name
  ctx.font='bold 56px "Orbitron", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(badge.name,canvas.width/2,520);
  
  // Description
  ctx.font='32px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.7)';
  wrapText(ctx,badge.desc,canvas.width/2,600,700,48);
  
  // XP badge
  ctx.font='bold 40px "Inter", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(\`⭐ \${state.xp.toLocaleString()} XP\`,canvas.width/2,740);
  
  // Date
  ctx.font='28px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.5)';
  ctx.fillText(new Date().toLocaleDateString('en-US',{month:'long',day:'numeric',year:'numeric'}),canvas.width/2,820);
}

function renderStatsCard(ctx){
  // Title
  ctx.fillStyle='#FFFFFF';
  ctx.font='bold 48px "Orbitron", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('My OpenClaw Journey',canvas.width/2,100);
  
  // Stats grid
  const stats=[
    {icon:'⭐',label:'Total XP',value:state.xp.toLocaleString()},
    {icon:'📚',label:'Levels',value:\`\${state.completedLevels.length}/51\`},
    {icon:'🗺️',label:'Zones',value:\`\${ZONES.filter(z=>isZoneCompleted(z.id)).length}/11\`},
    {icon:'🏆',label:'Badges',value:\`\${state.badges.length}/\${11+SPECIAL_BADGES.length}\`},
    {icon:'🔥',label:'Best Streak',value:state.maxStreak.toString()},
    {icon:'💯',label:'Perfect Quizzes',value:Object.values(state.quizResults||{}).filter(q=>q.perfect).length.toString()}
  ];
  
  let y=200;
  stats.forEach((stat,i)=>{
    const x=i%2===0?200:600;
    if(i%2===0&&i>0)y+=180;
    
    // Icon
    ctx.font='64px "Inter", sans-serif';
    ctx.fillStyle='rgba(255,255,255,0.9)';
    ctx.textAlign='center';
    ctx.fillText(stat.icon,x,y);
    
    // Value
    ctx.font='bold 48px "Orbitron", sans-serif';
    ctx.fillStyle='#FFD700';
    ctx.fillText(stat.value,x,y+70);
    
    // Label
    ctx.font='24px "Inter", sans-serif';
    ctx.fillStyle='rgba(255,255,255,0.6)';
    ctx.fillText(stat.label,x,y+110);
  });
  
  // Rank
  const rank=getRank();
  ctx.font='bold 40px "Orbitron", sans-serif';
  ctx.fillStyle='#BF00FF';
  ctx.textAlign='center';
  ctx.fillText(\`\${rank.icon} \${rank.title}\`,canvas.width/2,y+220);
}

function renderZoneCard(ctx){
  const zone=currentShareData.zone||ZONES[0];
  
  // Title
  ctx.fillStyle='#FFFFFF';
  ctx.font='bold 48px "Orbitron", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('Zone Complete!',canvas.width/2,100);
  
  // Zone emoji
  ctx.font='180px "Inter", sans-serif';
  ctx.fillText(zone.emoji,canvas.width/2,320);
  
  // Zone name
  ctx.font='bold 56px "Orbitron", sans-serif';
  ctx.fillStyle=zone.color;
  ctx.fillText(zone.name,canvas.width/2,440);
  
  // Theme
  ctx.font='32px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.7)';
  ctx.fillText(zone.theme,canvas.width/2,500);
  
  // Level count
  ctx.font='bold 40px "Inter", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(\`\${zone.levels.length} Levels Mastered\`,canvas.width/2,600);
  
  // Badge icon
  ctx.font='100px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.9)';
  ctx.fillText(zone.badge.icon,canvas.width/2,740);
  
  // Badge name
  ctx.font='36px "Orbitron", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(zone.badge.name,canvas.width/2,820);
  
  // Progress
  const completedZones=ZONES.filter(z=>isZoneCompleted(z.id)).length;
  ctx.font='28px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.5)';
  ctx.fillText(\`\${completedZones}/11 zones complete\`,canvas.width/2,880);
}

function wrapText(ctx,text,x,y,maxWidth,lineHeight){
  const words=text.split(' ');
  let line='';
  let currentY=y;
  
  for(let n=0;n<words.length;n++){
    const testLine=line+words[n]+' ';
    const metrics=ctx.measureText(testLine);
    const testWidth=metrics.width;
    if(testWidth>maxWidth&&n>0){
      ctx.fillText(line,x,currentY);
      line=words[n]+' ';
      currentY+=lineHeight;
    } else {
      line=testLine;
    }
  }
  ctx.fillText(line,x,currentY);
}

function downloadShareCard(){
  const canvas=document.getElementById('share-canvas');
  const link=document.createElement('a');
  const filename=\`openclaw-academy-\${currentShareType}-\${Date.now()}.png\`;
  link.download=filename;
  link.href=canvas.toDataURL('image/png');
  link.click();
  playSound('success');
  
  // Show success message
  const result=document.createElement('div');
  result.style.cssText='position:fixed;top:80px;left:50%;transform:translateX(-50%);background:#39FF14;color:#000;padding:12px 24px;border-radius:10px;font-weight:600;z-index:400;animation:fade-out 2s forwards';
  result.textContent='✅ Downloaded! Share it on social media';
  document.body.appendChild(result);
  setTimeout(()=>result.remove(),2000);
}

"""
    lines.insert(init_line, js_code)
    print(f"✅ JavaScript functions inserted before init() at line {init_line}")

# Write back
with open('index.html', 'w') as f:
    f.writelines(lines)

print("✅ Share cards feature fully integrated!")
print("")
print("Now updating development-queue.md...")

# Update development-queue.md
with open('development-queue.md', 'r') as f:
    queue_lines = f.readlines()

new_queue = []
for line in queue_lines:
    if '- [NEXT] `share-cards`' in line:
        new_queue.append('- [x] `share-cards` — Generate shareable achievement cards (canvas → PNG) for social media.\n')
        new_queue.append('- [NEXT] `mobile-gestures` — Swipe navigation between levels, touch-friendly drag & drop improvements.\n')
    elif '- [ ] `mobile-gestures`' in line:
        pass  # Skip, we added it above with [NEXT]
    else:
        new_queue.append(line)

with open('development-queue.md', 'w') as f:
    f.writelines(new_queue)

print("✅ development-queue.md updated - share-cards marked complete, mobile-gestures is now [NEXT]")

