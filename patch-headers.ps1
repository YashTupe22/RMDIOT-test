##############################################################################
# patch-headers.ps1
# Patches every RMDIOT HTML page:
#   1. Injects  <link rel="stylesheet" href="{rel}Assets/header.css">
#               <script src="{rel}Assets/header.js" defer></script>
#      right before </head>  (idempotent - skips if already present)
#   2. Replaces the old header block (from <header … to </header>)
#      with the new responsive curved-logo-block header.
#   3. Inserts the mobile-menu panel + defers to header.js
##############################################################################

$root = "D:\RMDIOT"

# All pages except the ones already manually updated (index, Faculty, Programmes)
# — we still process them so the shared-CSS link gets added consistently.
$files = Get-ChildItem -Path $root -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

function Get-RelPath($filePath) {
    # Pure PowerShell relative path (works on PS 5.1)
    $fileDir = [System.IO.Path]::GetDirectoryName($filePath).TrimEnd('\')
    $rootDir = $root.TrimEnd('\')
    if ($fileDir -ieq $rootDir) { return "" }
    # Count how many directory levels deep we are
    $remaining = $fileDir.Substring($rootDir.Length).TrimStart('\')
    $depth = ($remaining -split '\\').Count
    return ("../" * $depth)
}

# The new header HTML template.
# Placeholders: {REL} = relative path prefix, {LOGO} = rel path to logo
function New-Header($rel) {
    $logo = "${rel}Assets/Logo/logo.jpg"
    return @"
<header class="sticky top-0 w-full z-50 border-b-[3px] border-[#6B0F1A] bg-white/95 dark:bg-stone-950/95 backdrop-blur-md shadow-sm overflow-hidden">
<div class="header-row">
<a class="logo-block" href="${rel}index.html">
    <img src="$logo" alt="RMDIOT Logo" />
    <span class="college-name">RMDIOT<br/>Polytechnic</span>
</a>
<div class="header-inner">
<nav class="hidden lg:flex items-center space-x-6 font-['Playfair_Display'] text-sm tracking-wide uppercase font-semibold">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors" href="${rel}index.html">Home</a>
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors" href="${rel}admissions/Admission.html">Admissions</a>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="${rel}Programmee/Programmes.html">Programmes<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Programmes.html">Overview</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Department/Computer Department/index.html">Computer Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Department/Artificial Intelligence and Machine learning Department/index.html">AI &amp; ML Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Department/Automobile Deprtment/index.html">Automobile Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Department/Mechanical Department/index.html">Mechanical Department</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Facilities/index.html">Facilities</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}Programmee/Blog/index.html">Blog</a>
</div></div>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="${rel}faculty/Faculty.html">Faculty<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}faculty/Faculty.html">Overview</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}faculty/Faculty details/index.html">Faculty Details</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}faculty/photos/index.html">Faculty Photos</a>
</div></div>
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors" href="${rel}placements/Placement.html">Placements</a>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="${rel}events/index.html">Events<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}events/index.html">Events Overview</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}events/curricular/index.html">Curricular</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}events/Co - Curricular/index.html">Co-Curricular</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}events/Extra Curricular/index.html">Extra Curricular</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}events/Social Activities/index.html">Social Activities</a>
</div></div>
<div class="relative group py-7">
<a class="text-stone-600 dark:text-stone-400 hover:text-[#6B0F1A] transition-colors inline-flex items-center gap-1" href="${rel}About Us/index.html">About Us<span class="material-symbols-outlined text-[16px]">expand_more</span></a>
<div class="invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute left-0 top-full min-w-[220px] bg-white border border-stone-200 shadow-xl transition-all duration-200 py-2 normal-case tracking-normal font-body z-50">
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}About Us/index.html">About Us</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}About Us/About Trust/index.html">About Trust</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}About Us/Adminstration/index.html">Administration</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}About Us/Board of Governments/index.html">Board of Governors</a>
<a class="block px-4 py-2.5 text-[12px] text-stone-600 hover:bg-[#6B0F1A]/5 hover:text-[#6B0F1A] transition-colors whitespace-nowrap" href="${rel}About Us/Authority/index.html">Authority</a>
</div></div>
</nav>
<div class="flex items-center space-x-3">
    <button class="material-symbols-outlined text-maroon-mid hidden lg:block text-[20px]" aria-label="Search">search</button>
    <a class="hidden lg:inline-block bg-[#6B0F1A] text-white px-5 py-2 text-xs font-bold uppercase tracking-widest hover:bg-[#3D0408] transition-all duration-300 active:scale-95 whitespace-nowrap" href="${rel}admissions/Admission.html">Apply Now</a>
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
        <img src="${rel}Assets/Logo/logo.jpg" alt="RMDIOT Logo" />
        <span>RMDIOT<br/>Polytechnic</span>
    </div>
    <a href="${rel}index.html">Home</a>
    <a href="${rel}admissions/Admission.html">Admissions</a>
    <a href="${rel}Programmee/Programmes.html">Programmes</a>
    <a href="${rel}faculty/Faculty.html">Faculty</a>
    <a href="${rel}placements/Placement.html">Placements</a>
    <a href="${rel}events/index.html">Events</a>
    <a href="${rel}About Us/index.html">About Us</a>
    <a class="apply-btn" href="${rel}admissions/Admission.html">Apply Now</a>
</div>
<script src="${rel}Assets/header.js" defer></script>
"@
}

foreach ($file in $files) {
    $rel = Get-RelPath $file
    $content = Get-Content $file -Raw -Encoding UTF8

    # 1. Inject header.css link before </head> (idempotent)
    $cssLink = "<link rel=`"stylesheet`" href=`"${rel}Assets/header.css`"/>"
    if ($content -notmatch [regex]::Escape("Assets/header.css")) {
        $content = $content -replace '(?i)</head>', "$cssLink`n</head>"
        Write-Host "  [CSS] Injected header.css link -> $file"
    }

    # 2. Replace old header block with new responsive one
    # Pattern: <header ... (everything until) </header>
    # We also strip any inline mobile-menu/script blocks added in previous passes
    $headerPattern = '(?si)<header\b[^>]*>.*?</header>\s*(?:<!--\s*Mobile nav panel\s*-->.*?<\/script>\s*)?'
    $newHeader = New-Header $rel

    if ($content -match $headerPattern) {
        $content = [regex]::Replace($content, $headerPattern, $newHeader, [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        Write-Host "  [HDR] Replaced header -> $file"
    } else {
        Write-Host "  [SKP] No header matched -> $file"
    }

    # 3. Remove any old inline mobile-menu divs / scripts that remain (cleanup)
    $content = [regex]::Replace($content, '(?si)<!--\s*Mobile nav panel\s*-->.*?</script>\s*', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # 4. Remove old per-file hamburger scripts (bar1/bar2/bar3 pattern)
    $content = [regex]::Replace($content, '(?si)<script>\s*const menuToggle.*?</script>\s*', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # 5. Write back
    [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
}

Write-Host "`n✅ All $($files.Count) pages patched."
