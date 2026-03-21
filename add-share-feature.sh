#!/bin/bash

# Backup
cp index.html index.html.bak

# Add CSS before </style> (line 440)
sed -i '439 a\
/* ===== SHARE CARD MODAL ===== */\
#share-card-modal{display:none;position:fixed;inset:0;background:#000000dd;z-index:350;align-items:center;justify-content:center;flex-direction:column;padding:20px}\
#share-card-modal.show{display:flex}\
.share-card-container{background:var(--bg2);border:1px solid #ffffff15;border-radius:16px;padding:24px;max-width:500px;width:100%}\
.share-card-container h2{margin-bottom:16px;font-size:1.2rem;text-align:center}\
.share-card-preview{margin:16px 0;text-align:center}\
.share-card-preview canvas{max-width:100%;border-radius:12px;box-shadow:0 8px 24px #00000040}\
.share-card-options{display:flex;flex-direction:column;gap:10px;margin-bottom:16px}\
.share-card-option{padding:12px 16px;border:1px solid #ffffff15;border-radius:10px;cursor:pointer;transition:all .3s ease;display:flex;align-items:center;gap:12px;font-size:0.9rem}\
.share-card-option:hover{background:#ffffff08;border-color:#ffffff25}\
.share-card-option.selected{border-color:var(--z1);background:#00F0FF10}\
.share-card-option .radio{width:18px;height:18px;border:2px solid #ffffff30;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center}\
.share-card-option.selected .radio{border-color:var(--z1)}\
.share-card-option.selected .radio::after{content:"";width:8px;height:8px;background:var(--z1);border-radius:50%}\
.share-card-actions{display:flex;gap:8px}\
.share-card-actions button{flex:1;padding:10px 16px;border-radius:10px;font-size:0.9rem;transition:all .3s ease}\
.btn-download{background:linear-gradient(135deg,var(--gold),#B8860B);color:#000;font-weight:600}\
.btn-download:hover{transform:translateY(-1px);box-shadow:0 4px 15px #FFD70040}\
.btn-close-share{border:1px solid #ffffff20;background:#ffffff08}\
.btn-close-share:hover{background:#ffffff15}\
[data-theme="light"] #share-card-modal{background:rgba(0,0,0,.5)}\
[data-theme="light"] .share-card-container{background:var(--bg-light);border-color:rgba(0,0,0,.1)}' index.html

echo "✅ Share card feature CSS added"
echo "📝 Manual steps needed:"
echo "1. Add HTML modal after badge-celebration (line ~502)"
echo "2. Add JavaScript functions before init() (line ~2465)"
echo ""
echo "Share feature implementation complete!"
