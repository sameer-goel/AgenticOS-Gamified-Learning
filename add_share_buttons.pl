#!/usr/bin/perl
use strict;
use warnings;

open(my $in, '<', 'index.html') or die "Can't open: $!";
my @lines = <$in>;
close($in);

# Add share button in renderTrophyCase after the title
for my $i (0 .. $#lines) {
    if ($lines[$i] =~ /document\.getElementById\('trophy-view'\)\.innerHTML=html;/ && $lines[$i-1] =~ /renderTrophyCase/) {
        # Insert share button before setting innerHTML
        my $insert = q{  html+='<div style="text-align:center;margin:16px 0"><button class="btn-primary" style="padding:12px 24px;border-radius:10px;font-size:0.95rem;background:linear-gradient(135deg,var(--gold),#B8860B);color:#000;font-weight:600;cursor:pointer;border:none;transition:all .3s ease" onclick="openShareModal(\'badge\')">📤 Share Achievement Card</button></div>';
};
        splice(@lines, $i, 0, $insert);
        print "✅ Share button added to Trophy view\n";
        last;
    }
}

# Add share button in renderLeaderboard after personal bests
for my $i (0 .. $#lines) {
    if ($lines[$i] =~ /html\+='<div class="lb-tabs">/ && $lines[$i-1] =~ /renderLeaderboard/) {
        my $insert = q{  html+='<div style="text-align:center;margin:16px 0"><button class="btn-primary" style="padding:10px 20px;border-radius:10px;font-size:0.9rem;background:linear-gradient(135deg,var(--gold),#B8860B);color:#000;font-weight:600;cursor:pointer;border:none;transition:all .3s ease" onclick="openShareModal(\'stats\')">📤 Share My Stats</button></div>';
};
        splice(@lines, $i, 0, $insert);
        print "✅ Share button added to Leaderboard view\n";
        last;
    }
}

# Modify showBadgeCelebration to add a share button option
for my $i (0 .. $#lines) {
    if ($lines[$i] =~ /function closeCelebration/ && $lines[$i+1] =~ /getElementById\('badge-celebration'\)/) {
        # Add new function after closeCelebration
        my $insert = q{function shareFromCelebration(){
  const badgeIcon=document.getElementById('celeb-badge-icon').textContent;
  const badgeName=document.getElementById('celeb-badge-name').textContent;
  const badgeDesc=document.getElementById('celeb-badge-desc').textContent.split('—')[0].trim();
  openShareModal('badge',{badge:{icon:badgeIcon,name:badgeName,desc:badgeDesc}});
  closeCelebration();
}

};
        splice(@lines, $i, 0, $insert);
        print "✅ shareFromCelebration function added\n";
        last;
    }
}

open(my $out, '>', 'index.html') or die "Can't write: $!";
print $out @lines;
close($out);

print "✅ Share buttons integrated into Trophy and Leaderboard views!\n";
