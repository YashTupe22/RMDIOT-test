##############################################################################
# patch-headers.ps1  (v3 — absolute paths, Vercel-safe)
# - Uses /absolute/paths for ALL links (immune to <base href> and page depth)
# - Strips any residual <base href> tags from every page
# - Injects <link> to shared Assets/header.css
# - Injects <script> to shared Assets/header.js
##############################################################################

$root  = "D:\RMDIOT"
$files = Get-ChildItem -Path $root -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

# ── New header HTML (ALL paths are absolute — start with /) ──────────────────
$newHeader = @'
<header class="sticky top-0 w-full z-50 border-b-[3px] border-[#6B0F1A] bg-white/95 dark:bg-stone-950/95 backdrop-blur-md shadow-sm overflow-hidden">
<div class="header-row">
<a class="logo-block" href="/index.html">
    <img src="/Assets/Logo/logo.jpg" alt="RMDIOT Logo" />
    <span class="college-name">RMDIOT<br/>Polytechnic</span>
</a>
<div class="header-inner">
<nav class="hidden lg:flex items-center space-x-6 font-['Playfair_Display'] text-sm tracking-wide uppercase font-semibold">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors" href="/index.html">Home</a>
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors" href="/admissions/Admission.html">Admissions</a>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="/Programmee/Programmes.html">Programmes<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Programmes.html">Overview</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Department/Computer Department/index.html">Computer Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Department/Artificial Intelligence and Machine learning Department/index.html">AI &amp; ML Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Department/Automobile Deprtment/index.html">Automobile Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Department/Mechanical Department/index.html">Mechanical Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Facilities/index.html">Facilities</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/Programmee/Blog/index.html">Blog</a>
</div></div>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="/faculty/Faculty.html">Faculty<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/faculty/Faculty.html">Overview</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/faculty/Faculty details/index.html">Faculty Details</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/faculty/photos/index.html">Faculty Photos</a>
</div></div>
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors" href="/placements/Placement.html">Placements</a>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="/events/index.html">Events<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/events/index.html">Events Overview</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/events/curricular/index.html">Curricular</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/events/Co - Curricular/index.html">Co-Curricular</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/events/Extra Curricular/index.html">Extra Curricular</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/events/Social Activities/index.html">Social Activities</a>
</div></div>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="/About Us/index.html">About Us<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/About Us/index.html">About Us</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/About Us/About Trust/index.html">About Trust</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/About Us/Adminstration/index.html">Administration</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/About Us/Board of Governments/index.html">Board of Governors</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="/About Us/Authority/index.html">Authority</a>
</div></div>
</nav>
<div class="flex items-center space-x-3">
    <button class="material-symbols-outlined text-[#8B1A2A] hidden lg:block text-[20px]" aria-label="Search">search</button>
    <a class="hidden lg:inline-block bg-[#6B0F1A] text-white px-5 py-2 text-xs font-bold uppercase tracking-widest hover:bg-[#3D0408] transition-all duration-300 active:scale-95 whitespace-nowrap" href="/admissions/Admission.html">Apply Now</a>
    <button id="hamburger" class="hamburger lg:hidden" aria-label="Toggle menu" aria-expanded="false">
        <span></span><span></span><span></span>
    </button>
</div>
</div>
</div>
</header>
<!-- Mobile nav panel -->
<div class="mobile-menu" id="mobileMenu">
    <div class="mobile-menu-brand">
        <img src="/Assets/Logo/logo.jpg" alt="RMDIOT Logo" />
        <span>RMDIOT<br/>Polytechnic</span>
    </div>
    <a href="/index.html">Home</a>
    <a href="/admissions/Admission.html">Admissions</a>
    <a href="/Programmee/Programmes.html">Programmes</a>
    <a href="/faculty/Faculty.html">Faculty</a>
    <a href="/placements/Placement.html">Placements</a>
    <a href="/events/index.html">Events</a>
    <a href="/About Us/index.html">About Us</a>
    <a class="apply-btn" href="/admissions/Admission.html">Apply Now</a>
</div>
<script src="/Assets/header.js" defer></script>
'@

foreach ($file in $files) {

    $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

    # 1. Strip any <base href="..."> tags (absolute paths make them unnecessary)
    $content = [regex]::Replace($content, '(?i)<base\s[^>]*href[^>]*/?>(\s*)', '', 'Singleline')

    # 2. Inject /Assets/header.css before </head> (idempotent)
    if ($content -notmatch [regex]::Escape("/Assets/header.css")) {
        $content = $content -replace '(?i)</head>', "<link rel=`"stylesheet`" href=`"/Assets/header.css`"/>`n</head>"
        Write-Host "  [CSS] $file"
    }

    # 3. Replace header block + any trailing mobile-menu/script blocks
    $headerPattern = '(?si)<header\b[^>]*>.*?</header>(\s*<!--.*?-->)?\s*(<div[^>]*class="[^"]*mobile-menu[^"]*"[^>]*>.*?</div>)?\s*(<script\b.*?</script>)?\s*'
    if ($content -match $headerPattern) {
        $content = [regex]::Replace($content, $headerPattern, $newHeader + "`n", 'Singleline,IgnoreCase')
        Write-Host "  [HDR] $file"
    } else {
        Write-Host "  [SKP] No header found: $file"
    }

    # 4. Write back
    [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
}

Write-Host "`n✅ Done. $($files.Count) pages patched with absolute paths."
