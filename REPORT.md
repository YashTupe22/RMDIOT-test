# RMDIOT Website — Complete Development Report

**Project:** SJVPM's Rasiklal M. Dhariwal Institute of Technology (Polytechnic)
**Repository:** `YashTupe22/RMDIOT-test` (GitHub → Vercel)
**Report Period:** Session 1 (2026-05-09) → Session 2 (2026-05-13)
**Total Pages Modified:** 25 HTML files

---

## Table of Contents

1. [Session 1 — 2026-05-09](#session-1--2026-05-09)
2. [Session 2 — 2026-05-13](#session-2--2026-05-13)
3. [Files Modified — Complete Reference](#files-modified--complete-reference)
4. [Git Commit History](#git-commit-history)
5. [Current Status](#current-status)

---

## Session 1 — 2026-05-09

### 1.1 Department Cleanup

**File:** `index.html`

The homepage course cards listed departments the college does not offer.
Card links pointed to the generic `Programmes.html` instead of specific department pages.

**Removed cards:** Civil Engineering, Electrical Engineering, Electronics & Telecomm, Information Technology

**Added cards:** AI & Machine Learning (card 03), Automobile Engineering (card 04)

Cards renumbered: 6 departments → 5 departments (01–05)

"View Department" links updated to point to each department's individual page:

| Card | Department | Link |
|------|-----------|------|
| 01 | Mechanical Engineering | `Programmee/Department/Mechanical Department/index.html` |
| 02 | Computer Technology | `Programmee/Department/Computer Department/index.html` |
| 03 | AI & Machine Learning | `Programmee/Department/Artificial Intelligence and Machine learning Department/index.html` |
| 04 | Automobile Engineering | `Programmee/Department/Automobile Deprtment/index.html` |
| 05 | Science & Humanities | `Programmee/Programmes.html` |

Admissions form dropdown: removed Civil Engineering and Electrical Engineering; added AIML and Automobile Engineering.

---

### 1.2 Programmes Page Cleanup

**File:** `Programmee/Programmes.html`

Removed: Civil Engineering, Electrical Engineering, Electronics & Telecomm, Information Technology

Added: AI & Machine Learning (card 03), Automobile Engineering (card 04)

Cards renumbered 01–04 with proper department links.

---

### 1.3 Curved Logo Block — Header Redesign

**Files:** `index.html`, `Programmee/Programmes.html`, `faculty/Faculty.html`

Added a curved accent block to the left of the header:
- `.logo-block` CSS with `border-bottom-right-radius: 50px` (pill-cut shape)
- Background color: `#6B0F1A` (maroon)
- Block height matches full header height (5rem)
- Contains: logo image (44x44px) + college name in white Playfair Display
- Outer container: `px-8` changed to `pl-0 pr-8` for flush-left positioning

---

### 1.4 Responsive Header — Site-Wide Rollout

**Files:** All 24 HTML pages (automated via PowerShell)

New shared files created:

| File | Purpose |
|------|---------|
| `Assets/header.css` | Logo block, hamburger, mobile menu, all breakpoints |
| `Assets/header.js` | Mobile menu toggle with outside-click-close |
| `patch-headers.ps1` | PowerShell automation script |

Per-page changes across all 24 pages:
- Injected `<link href="Assets/header.css">` with correct relative depth
- Replaced every `<header>` block with new curved logo block + `header-inner` wrapper
- Added mobile menu panel with hamburger toggle
- Added `<script src="Assets/header.js">` after each header

Responsive behaviour:

| Screen | Logo | Nav | Actions |
|--------|------|-----|---------|
| >= 1024px | Logo + text | Full nav | Search + Apply Now |
| 768–1024px | Logo + text | Hidden | Hamburger |
| < 768px | Logo + text (shrunk) | Hidden | Hamburger |

---

### 1.5 Nav Centering Fix

**File:** `Assets/header.css`

Problem: Nav links were pulled to the right side of the header, not centered.

Root cause: `.header-inner` had `position: relative`, so the nav anchored to `.header-inner`
(which starts after the logo block), not the full page width.

Fix:
- Removed `position: relative` from `.header-inner`
- Kept `position: relative` only on `.header-row` (spans full 100vw)
- Nav with `left: 0; right: 0` now anchors to true screen edges
- `justify-content: center` centers links at any zoom/screen size
- Added z-index layering so "Apply Now" button stays clickable

---

### 1.6 Mobile Menu — Logo Brand Block

**Files:** `Assets/header.css`, all 24 pages (via patch script)

Request: College logo and name must appear at the top of the mobile dropdown menu.

Added `.mobile-menu-brand` CSS block. Mobile menu now shows logo + college name at top,
separated from links by a 2px maroon divider line.

---

### 1.7 Vercel Deployment Setup

**Files:** `vercel.json`, `.vercelignore`, `404.html`

`vercel.json`:
- Asset caching: 1 year (Cache-Control: immutable) for `/Assets/` folder
- HTML pages: no cache (updates go live immediately on redeploy)
- Security headers on all routes

`.vercelignore`: Excludes `*.ps1` dev scripts, `.git`, `README.md` from deployment

`404.html`: Branded custom error page (maroon + gold) with nav back to key pages

---

### 1.8 Absolute Path Fix — 404 Resolution

**Files:** All 25 HTML pages (via `patch-headers.ps1` v3)

Problem: After deployment, clicking header links showed 404 errors on Vercel.

Root cause: Relative paths like `../../admissions/Admission.html` break when pages have
`<base href>` tags or are at different directory depths.

Fix: Rewrote patch script to use absolute paths (e.g. `/admissions/Admission.html`).
Stripped all `<base href>` tags from every page. Re-ran on all 25 pages and pushed.

---

### 1.9 Git Folder Case-Sensitivity Fix

Problem: Some pages returned 404 on Vercel (Linux is case-sensitive; Windows is not).

Mismatched folder casing in git:

| Git Tracked | Actual Disk | Nav Links |
|-------------|-------------|-----------|
| `Faculty/` | `faculty/` | `/faculty/` |
| `Events/` | `events/` | `/events/` |
| `Admissions/` | `admissions/` | `/admissions/` |
| `Placements/` | `placements/` | `/placements/` |
| `events/Curricular/` | `events/curricular/` | `/events/curricular/` |
| `faculty/Photos/` | `faculty/photos/` | `/faculty/photos/` |

Fix: Used `git mv` with temp rename to force case change in git index for all 6 folders.

---

### 1.10 Transparent Logo + One-Line Name

**Files:** `Assets/Logo/logo.png`, `Assets/header.css`, all 25 pages

Generated `logo.png` with transparent background (AI background removal from `logo.jpg`).
Updated all 25 pages to use `/Assets/Logo/logo.png`.

`header.css` changes:
- `white-space: nowrap` — prevents college name from wrapping
- `font-size: clamp(0.6rem, 2vw, 1rem)` — scales with viewport
- Removed `display: none` at 768px — name now always visible on all screens
- Logo shrinks progressively: 44px → 34px → 30px → 26px across breakpoints

| Screen | Before | After |
|--------|--------|-------|
| Desktop | 2 lines | 1 line |
| Tablet | 2 lines | 1 line |
| Mobile | Hidden | Visible, 1 line |

---

### 1.11 Duplicate Header Cleanup

**Files:** All 25 HTML pages

Each page had 2–3 duplicate `header.css`/`header.js` references from multiple patch runs.

Fix: Automated script removed every variant of the header references, then inserted
exactly one `<link>` + one `<script>` cleanly before `</head>`:

```html
<link rel="stylesheet" href="/Assets/header.css"/>
<script src="/Assets/header.js" defer></script>
</head>
```

---

### 1.12 Orphaned Nav Block Removal

**Files:** All 25 HTML pages

Problem: Pages showed an "old header" — a raw list of links visible in the page body.

Root cause: Each page had an orphaned nav block outside any container, left over from
earlier patch script iterations. It sat directly after the mobile menu closing tag:

```html
</div>  <- mobileMenu closing tag
<a href="/index.html">Home</a>     <- THIS was the "old header"
<a href="/admissions/...">Admissions</a>
...
```

Fix: Regex-targeted removal from all 25 pages via PowerShell.
`index.html` dropped from 636 to 617 lines (19 orphaned lines removed).

---

## Session 2 — 2026-05-13

---

### 2.1 Page Transition Animation

**Files:** `Assets/header.css`, `Assets/header.js`

CSS keyframes added to `header.css`:
- `pageEnter`: fade-in with upward slide (0.5s, applied to `body` on every page load)
- `pageFadeOut`: fade-out with upward slide (0.28s, applied via `body.page-exit` class)
- Header excluded from animation (`body > header { animation: none }`)
- Respects `prefers-reduced-motion` accessibility setting

`initPageTransitions()` function added to `header.js`:
- Intercepts all internal same-origin `<a>` link clicks
- Applies `page-exit` class for 280ms fade-out, then navigates
- Excluded: hash links, javascript:, mailto:, tel:, target="_blank", external domains, modifier keys
- Handles browser bfcache (back/forward navigation) via `pageshow` event

---

### 2.2 Header Alignment Fix

**File:** `Assets/header.css`

Problem: Nav content overlapped into the logo/nameplate section.

Root cause: Nav used `position: relative; width: 100%` inside `.header-inner`,
causing it to reference `.header-inner` width (after the logo) not the full header width.

Fix — changed to flex-based centering in the `>= 1024px` media query:
- Nav gets `flex: 1` and `justify-content: center`
- Dropdown triggers (`.relative.group`) constrained to `height: 100%` of header
- Actions div gets `flex-shrink: 0` so it stays at natural size
- Added `position: relative; z-index: 1` to `.header-row` as base styles
- Merged duplicate `body { overflow-x: hidden }` rule into main body block

---

### 2.3 Department Card Reorder

**File:** `index.html`

Requested new order for the 5 homepage department cards:

| Card | Before | After |
|------|--------|-------|
| 01 | Mechanical Engineering | Automobile Engineering |
| 02 | Computer Technology | AI & Machine Learning |
| 03 | AI & Machine Learning | Computer Engineering |
| 04 | Automobile Engineering | Mechanical Engineering |
| 05 | Science & Humanities | Electronics & Computer Engineering |

Card 05 replaced entirely with "Electronics & Computer Engineering" (new description,
same link pointing to `Programmee/Programmes.html` as placeholder).

---

### 2.4 Faculty Name Update

**File:** `index.html` (user edit)

Mechanical HOD faculty card updated on the homepage:

| Field | Before | After |
|-------|--------|-------|
| Name | Prof. Sandeep Surwase | Prof. S.B. Surwase |
| Role | HOD, Mechanical Dept. | HOD, Mechanical Dept. |

---

## Files Modified — Complete Reference

| File | Session(s) | Nature of Change |
|------|-----------|-----------------|
| `Assets/header.css` | 1, 2 | Created; iterated many times; final: page transitions + nav alignment |
| `Assets/header.js` | 1, 2 | Created; page transition logic added in session 2 |
| `Assets/Logo/logo.png` | 1 | New transparent-background PNG |
| `index.html` | 1, 2 | Dept. cards, admissions form, logo, header, faculty name, dept. reorder |
| `Programmee/Programmes.html` | 1 | Dept. cards, header |
| `faculty/Faculty.html` | 1 | Header redesign |
| `admissions/Admission.html` | 1 | Header |
| `404.html` | 1 | Created from scratch |
| `vercel.json` | 1 | Created — caching + security headers |
| `.vercelignore` | 1 | Created — exclude dev files from deploy |
| All other 20 HTML pages | 1 | Shared header injection via PowerShell |

---

## Git Commit History

| Commit | Date | Key Change |
|--------|------|-----------|
| *(Initial state)* | Before 2026-05-09 | — |
| Department cards + curved logo header | 2026-05-09 | Session 1 begins |
| Site-wide responsive header (24 pages) | 2026-05-09 | patch-headers.ps1 v1 |
| Nav centering + mobile brand block | 2026-05-09 | header.css centering fix |
| fix: use absolute paths in all headers | 2026-05-09 | Vercel 404 fix |
| fix: rename folder casing to lowercase | 2026-05-09 | Linux case-sensitivity |
| fix: lowercase Curricular and Photos | 2026-05-09 | Remaining case fixes |
| feat: new transparent logo, one-line name | 2026-05-09 | logo.png + mobile name |
| fix: remove duplicate header.css/js links | 2026-05-09 | Deduplication pass |
| fix: remove orphaned duplicate mobile nav | 2026-05-09 | Final cleanup, session 1 ends |
| *(Local — not yet pushed)* | 2026-05-13 | Page transitions + dept. reorder + header fix |

---

## Current Status

| Feature | Status |
|---------|--------|
| Department listings (correct 5 depts.) | Done |
| Curved logo block header | Done — all 25 pages |
| Responsive mobile menu with brand block | Done — all 25 pages |
| Nav centered in header | Done |
| Absolute paths (Vercel-safe) | Done |
| Git folder casing (Linux case-sensitive) | Done |
| Transparent logo (logo.png) | Done |
| College name always visible on mobile | Done |
| Custom 404 page | Done |
| vercel.json caching and security | Done |
| Page transition animations | Done |
| Header alignment / nameplate overlap fix | Done |
| Department card reorder (homepage) | Done |
| Faculty name update (Prof. S.B. Surwase) | Done |

**Pending Push:** The 2026-05-13 session changes have not yet been committed and pushed to GitHub.

Run:
```
git add -A
git commit -m "feat: page transitions, dept reorder, header alignment fix"
git push origin main
```
