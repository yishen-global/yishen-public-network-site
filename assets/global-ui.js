/**
 * YISHEN GLOBAL - SOVEREIGN UI ENGINE V8.1
 * VACUUM VERSION: ZERO NON-ASCII CHARACTERS TO PREVENT GARBLED TEXT
 */
(function() {
    const initSovereignUI = () => {
        if (document.getElementById('sov-nav-root')) return;

        // 1. Inject Styles
        const style = document.createElement('style');
        style.textContent = `
            #sov-nav-root { background:#000; border-bottom:1px solid #222; height:60px; width:100%; position:fixed; top:0; left:0; z-index:9999; font-family:sans-serif; display:flex; align-items:center; justify-content:space-between; padding:0 5%; box-sizing:border-box; }
            .sov-brand { color:#fff; font-weight:900; font-size:18px; letter-spacing:1px; text-decoration:none; }
            .sov-menu { display:flex; gap:20px; }
            .sov-link { color:#888; text-decoration:none; font-size:13px; text-transform:uppercase; }
            .sov-btn { background:#0070f3; color:#fff; padding:6px 15px; border-radius:4px; font-weight:bold; }
            .sov-footer { background:rgba(0,112,243,0.05); border-top:1px solid #0070f3; padding:25px 8%; font-size:11px; color:#0070f3; margin-top:60px; text-transform:uppercase; }
        `;
        document.head.appendChild(style);

        // 2. Inject Navigation Bar
        const nav = document.createElement('div');
        nav.id = 'sov-nav-root';
        nav.innerHTML = `
            <a href="/" class="sov-brand">YISHEN GLOBAL</a>
            <div class="sov-menu">
                <a href="/solutions" class="sov-link">Solutions</a>
                <a href="/rfq" class="sov-link">RFQ</a>
                <a href="/login" class="sov-link sov-btn">Login</a>
            </div>
        `;
        document.body.prepend(nav);

        // 3. Inject Clean Status Footer (Replacing the garbled text)
        const footer = document.createElement('footer');
        footer.className = 'sov-footer';
        footer.innerHTML = `
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap;">
                <div><strong>SYSTEM STATUS:</strong> V8.1 ACTIVE<br>CORE NODE: SOVEREIGN PROCUREMENT NETWORK</div>
                <div style="text-align:right; color:#555;">&copy; 2026 YISHEN GLOBAL &#124; POWERING GLOBAL TRADE<br>WIN / APL / AND / HMY OPTIMIZED</div>
            </div>
        `;
        document.body.appendChild(footer);
    };

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initSovereignUI);
    else initSovereignUI();
})();