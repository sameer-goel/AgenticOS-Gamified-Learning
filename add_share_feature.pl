#!/usr/bin/perl
use strict;
use warnings;

# Read entire file
open(my $in, '<', 'index.html') or die "Can't open index.html: $!";
my @lines = <$in>;
close($in);

# HTML modal to insert after </div> for badge-celebration (line ~522)
my $html_modal = q{
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

};

# Find line with badge-celebration closing </div> and insert after it
for my $i (0 .. $#lines) {
    if ($lines[$i] =~ /^<\/div>$/ && $lines[$i-2] =~ /closeCelebration/) {
        splice(@lines, $i+1, 0, $html_modal);
        print "✅ HTML modal inserted at line " . ($i+2) . "\n";
        last;
    }
}

# Find init() function and insert JS before it
my $init_line = 0;
for my $i (0 .. $#lines) {
    if ($lines[$i] =~ /^function init\(\)/) {
        $init_line = $i;
        last;
    }
}

if ($init_line > 0) {
    my $js_code = q{
// ===== SHARE CARDS =====
let currentShareType='badge';
let currentShareData=null;

function openShareModal(type='badge',data=null){
  currentShareType=type;
  currentShareData=data||{};
  if(!currentShareData.badge && type==='badge' && state.badges.length>0){
    const lastBadgeId=state.badges[state.badges.length-1];
    const zoneBadge=ZONES.find(z=>z.badge.id===lastBadgeId)?.badge;
    const specialBadge=SPECIAL_BADGES.find(b=>b.id===lastBadgeId);
    currentShareData.badge=zoneBadge||specialBadge;
  }
  if(!currentShareData.zone && type==='zone'){
    const completedZones=ZONES.filter(z=>isZoneCompleted(z.id));
    if(completedZones.length>0)currentShareData.zone=completedZones[completedZones.length-1];
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
  ctx.clearRect(0,0,canvas.width,canvas.height);
  const gradient=ctx.createLinearGradient(0,0,0,canvas.height);
  gradient.addColorStop(0,'#0A0A0F');
  gradient.addColorStop(1,'#1A1A2E');
  ctx.fillStyle=gradient;
  ctx.fillRect(0,0,canvas.width,canvas.height);
  ctx.strokeStyle='rgba(0,240,255,0.3)';
  ctx.lineWidth=4;
  ctx.strokeRect(10,10,canvas.width-20,canvas.height-20);
  if(type==='badge')renderBadgeCard(ctx);
  else if(type==='stats')renderStatsCard(ctx);
  else if(type==='zone')renderZoneCard(ctx);
  ctx.fillStyle='rgba(255,255,255,0.4)';
  ctx.font='24px "Inter", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('OpenClaw Academy',canvas.width/2,canvas.height-40);
}

function renderBadgeCard(ctx){
  const badge=currentShareData.badge||{icon:'🏆',name:'Achievement',desc:'Badge earned!'};
  ctx.fillStyle='#FFFFFF';
  ctx.font='bold 48px "Orbitron", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('Achievement Unlocked',canvas.width/2,120);
  ctx.font='200px "Inter", sans-serif';
  ctx.fillText(badge.icon,canvas.width/2,380);
  ctx.font='bold 56px "Orbitron", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(badge.name,canvas.width/2,520);
  ctx.font='32px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.7)';
  wrapText(ctx,badge.desc,canvas.width/2,600,700,48);
  ctx.font='bold 40px "Inter", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(`⭐ ${state.xp.toLocaleString()} XP`,canvas.width/2,740);
  ctx.font='28px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.5)';
  ctx.fillText(new Date().toLocaleDateString('en-US',{month:'long',day:'numeric',year:'numeric'}),canvas.width/2,820);
}

function renderStatsCard(ctx){
  ctx.fillStyle='#FFFFFF';
  ctx.font='bold 48px "Orbitron", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('My OpenClaw Journey',canvas.width/2,100);
  const stats=[
    {icon:'⭐',label:'Total XP',value:state.xp.toLocaleString()},
    {icon:'📚',label:'Levels',value:`${state.completedLevels.length}/51`},
    {icon:'🗺️',label:'Zones',value:`${ZONES.filter(z=>isZoneCompleted(z.id)).length}/11`},
    {icon:'🏆',label:'Badges',value:`${state.badges.length}/${11+SPECIAL_BADGES.length}`},
    {icon:'🔥',label:'Best Streak',value:state.maxStreak.toString()},
    {icon:'💯',label:'Perfect Quizzes',value:Object.values(state.quizResults||{}).filter(q=>q.perfect).length.toString()}
  ];
  let y=200;
  stats.forEach((stat,i)=>{
    const x=i%2===0?200:600;
    if(i%2===0&&i>0)y+=180;
    ctx.font='64px "Inter", sans-serif';
    ctx.fillStyle='rgba(255,255,255,0.9)';
    ctx.textAlign='center';
    ctx.fillText(stat.icon,x,y);
    ctx.font='bold 48px "Orbitron", sans-serif';
    ctx.fillStyle='#FFD700';
    ctx.fillText(stat.value,x,y+70);
    ctx.font='24px "Inter", sans-serif';
    ctx.fillStyle='rgba(255,255,255,0.6)';
    ctx.fillText(stat.label,x,y+110);
  });
  const rank=getRank();
  ctx.font='bold 40px "Orbitron", sans-serif';
  ctx.fillStyle='#BF00FF';
  ctx.textAlign='center';
  ctx.fillText(`${rank.icon} ${rank.title}`,canvas.width/2,y+220);
}

function renderZoneCard(ctx){
  const zone=currentShareData.zone||ZONES[0];
  ctx.fillStyle='#FFFFFF';
  ctx.font='bold 48px "Orbitron", sans-serif';
  ctx.textAlign='center';
  ctx.fillText('Zone Complete!',canvas.width/2,100);
  ctx.font='180px "Inter", sans-serif';
  ctx.fillText(zone.emoji,canvas.width/2,320);
  ctx.font='bold 56px "Orbitron", sans-serif';
  ctx.fillStyle=zone.color;
  ctx.fillText(zone.name,canvas.width/2,440);
  ctx.font='32px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.7)';
  ctx.fillText(zone.theme,canvas.width/2,500);
  ctx.font='bold 40px "Inter", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(`${zone.levels.length} Levels Mastered`,canvas.width/2,600);
  ctx.font='100px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.9)';
  ctx.fillText(zone.badge.icon,canvas.width/2,740);
  ctx.font='36px "Orbitron", sans-serif';
  ctx.fillStyle='#FFD700';
  ctx.fillText(zone.badge.name,canvas.width/2,820);
  const completedZones=ZONES.filter(z=>isZoneCompleted(z.id)).length;
  ctx.font='28px "Inter", sans-serif';
  ctx.fillStyle='rgba(255,255,255,0.5)';
  ctx.fillText(`${completedZones}/11 zones complete`,canvas.width/2,880);
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
    }else{
      line=testLine;
    }
  }
  ctx.fillText(line,x,currentY);
}

function downloadShareCard(){
  const canvas=document.getElementById('share-canvas');
  const link=document.createElement('a');
  const filename=`openclaw-academy-${currentShareType}-${Date.now()}.png`;
  link.download=filename;
  link.href=canvas.toDataURL('image/png');
  link.click();
  playSound('success');
  const result=document.createElement('div');
  result.style.cssText='position:fixed;top:80px;left:50%;transform:translateX(-50%);background:#39FF14;color:#000;padding:12px 24px;border-radius:10px;font-weight:600;z-index:400;animation:fade-out 2s forwards';
  result.textContent='✅ Downloaded! Share it on social media';
  document.body.appendChild(result);
  setTimeout(()=>result.remove(),2000);
}

};
    splice(@lines, $init_line, 0, $js_code);
    print "✅ JavaScript functions inserted before init() at line " . ($init_line+1) . "\n";
}

# Write modified file
open(my $out, '>', 'index.html') or die "Can't write index.html: $!";
print $out @lines;
close($out);

print "✅ Share cards feature fully integrated!\n\n";

# Update development-queue.md
open(my $qin, '<', 'development-queue.md') or die "Can't open development-queue.md: $!";
my @qlines = <$qin>;
close($qin);

open(my $qout, '>', 'development-queue.md') or die "Can't write development-queue.md: $!";
for my $line (@qlines) {
    if ($line =~ /\[NEXT\] `share-cards`/) {
        print $qout "- [x] `share-cards` — Generate shareable achievement cards (canvas → PNG) for social media.\n";
        print $qout "- [NEXT] `mobile-gestures` — Swipe navigation between levels, touch-friendly drag & drop improvements.\n";
    } elsif ($line =~ /\[ \] `mobile-gestures`/) {
        # Skip, already added above
    } else {
        print $qout $line;
    }
}
close($qout);

print "✅ development-queue.md updated - share-cards marked complete, mobile-gestures is now [NEXT]\n";
