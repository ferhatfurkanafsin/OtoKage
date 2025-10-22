# GitHub Pages Setup Guide for OtoKage

**Last Updated:** January 22, 2025
**Version:** 1.3.0

This document explains how the GitHub Pages documentation is set up for OtoKage's privacy policy, terms of service, and account deletion instructions. This setup is required for Google Play Store compliance.

---

## Table of Contents
1. [Overview](#overview)
2. [File Structure](#file-structure)
3. [Jekyll Configuration](#jekyll-configuration)
4. [How to Update Content](#how-to-update-content)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)

---

## Overview

### What is GitHub Pages?
GitHub Pages is a free static site hosting service that allows you to host HTML files directly from your GitHub repository. It's perfect for hosting documentation like privacy policies and terms of service.

### Why We Use It
Google Play Store requires:
- Privacy Policy URL
- Data Deletion Instructions URL
- Terms of Service URL (optional but recommended)

These URLs must be:
- Publicly accessible
- Permanent (won't change)
- Not behind authentication

### Our GitHub Pages URLs
- **Base URL:** https://ferhatfurkanafsin.github.io/OtoKage/
- **Privacy Policy:** https://ferhatfurkanafsin.github.io/OtoKage/privacy.html
- **Delete Account:** https://ferhatfurkanafsin.github.io/OtoKage/delete-account.html
- **Terms of Service:** https://ferhatfurkanafsin.github.io/OtoKage/terms.html

---

## File Structure

All GitHub Pages files are in the `docs/` directory:

```
Otokage/
├── docs/
│   ├── _config.yml           # Jekyll configuration (REQUIRED)
│   ├── index.html            # Landing page with links to all documents
│   ├── privacy.html          # Privacy Policy
│   ├── delete-account.html   # Account Deletion Instructions
│   └── terms.html            # Terms of Service
```

### Why `docs/` Directory?
GitHub Pages can serve from:
1. Root directory (`/`)
2. `docs/` directory
3. `gh-pages` branch

We use `docs/` because:
- Keeps documentation separate from code
- Easier to manage
- Standard practice

---

## Jekyll Configuration

### What is Jekyll?
Jekyll is a static site generator that GitHub Pages uses by default. Even though we're serving plain HTML files, we need to configure Jekyll to serve them correctly.

### _config.yml File

**Location:** `docs/_config.yml`

```yaml
# OtoKage - GitHub Pages Configuration
title: "OtoKage - Privacy & Legal Documents"
description: "Privacy Policy, Terms of Service, and Account Deletion for OtoKage Music Recognition App"
baseurl: "/OtoKage"
url: "https://ferhatfurkanafsin.github.io"

# Theme
theme: jekyll-theme-minimal

# Exclude files from processing
exclude:
  - README.md
  - .gitignore
  - Gemfile
  - Gemfile.lock

# Include all HTML files
include:
  - privacy.html
  - delete-account.html
  - terms.html
  - index.html

# Disable Jekyll's default markdown processing for HTML files
# This ensures our HTML files are served as-is
defaults:
  - scope:
      path: "*.html"
    values:
      layout: none
```

### Key Configuration Points

1. **baseurl: "/OtoKage"**
   - This must match your repository name
   - If your repo is `username/MyApp`, use `baseurl: "/MyApp"`

2. **url: "https://ferhatfurkanafsin.github.io"**
   - This is your GitHub Pages domain
   - Format: `https://{username}.github.io`

3. **include: [list of HTML files]**
   - Explicitly tells Jekyll to include these HTML files
   - Without this, Jekyll might ignore files starting with `_` or in certain directories

4. **layout: none**
   - Tells Jekyll NOT to wrap our HTML in a template
   - We want our custom HTML served as-is

---

## How to Update Content

### Updating Privacy Policy

1. Open `docs/privacy.html` in your editor
2. Make your changes to the HTML content
3. Keep the styling and structure intact
4. Commit and push to GitHub:
   ```bash
   git add docs/privacy.html
   git commit -m "Update privacy policy"
   git push origin main
   ```
5. Wait 1-2 minutes for GitHub to rebuild the site
6. Verify at: https://ferhatfurkanafsin.github.io/OtoKage/privacy.html

### Updating Terms of Service

Same process as privacy policy, but edit `docs/terms.html`

### Updating Delete Account Instructions

Same process, but edit `docs/delete-account.html`

### Adding a New Page

1. Create new HTML file in `docs/` directory (e.g., `docs/faq.html`)
2. Update `docs/_config.yml` to include it:
   ```yaml
   include:
     - privacy.html
     - delete-account.html
     - terms.html
     - index.html
     - faq.html  # Add your new file
   ```
3. Add link to `docs/index.html` landing page
4. Commit and push

---

## Verification

### How to Verify URLs Work

**Method 1: Browser**
1. Open browser
2. Go to: https://ferhatfurkanafsin.github.io/OtoKage/
3. Click each link to verify pages load

**Method 2: Command Line (curl)**
```bash
# Check privacy policy
curl -I https://ferhatfurkanafsin.github.io/OtoKage/privacy.html

# Should return:
# HTTP/2 200

# Check delete account
curl -I https://ferhatfurkanafsin.github.io/OtoKage/delete-account.html

# Check terms
curl -I https://ferhatfurkanafsin.github.io/OtoKage/terms.html
```

**Method 3: Google Play Console**
1. Go to Play Console
2. Navigate to: Policy → App content → Privacy Policy
3. Enter URL: https://ferhatfurkanafsin.github.io/OtoKage/privacy.html
4. Click "Verify URL"
5. Should show green checkmark (no 404 error)

### What Success Looks Like
- HTTP status: **200 OK**
- Page content loads correctly
- No 404 errors
- No SSL/certificate warnings
- Links on landing page work

---

## Troubleshooting

### Problem: 404 Error on All Pages

**Symptoms:**
- All GitHub Pages URLs return 404
- Play Console shows "URL returned 404 response code"

**Possible Causes & Solutions:**

1. **GitHub Pages Not Enabled**
   - Go to GitHub repo → Settings → Pages
   - Source: Select "Deploy from a branch"
   - Branch: Select "main" and "/docs"
   - Click Save
   - Wait 2-3 minutes

2. **Wrong baseurl in _config.yml**
   - Check `baseurl: "/OtoKage"` matches your repo name exactly
   - Case-sensitive!
   - No trailing slash

3. **Missing _config.yml**
   - Ensure `docs/_config.yml` exists
   - Has correct `include:` section
   - Has `layout: none` for HTML files

### Problem: 404 on Specific File (e.g., privacy.html)

**Symptoms:**
- Index page works
- Specific page returns 404

**Solutions:**

1. **File not included in _config.yml**
   ```yaml
   include:
     - privacy.html  # Make sure file is listed here
   ```

2. **Wrong filename**
   - Check exact filename (case-sensitive)
   - Must be `privacy.html`, not `Privacy.html`

3. **File in wrong directory**
   - Must be in `docs/` directory
   - Not in subdirectory like `docs/pages/`

### Problem: HTML Wrapped in Jekyll Template

**Symptoms:**
- Page loads but has extra header/footer
- Styling looks wrong
- Jekyll's default theme applied

**Solution:**
Add to `docs/_config.yml`:
```yaml
defaults:
  - scope:
      path: "*.html"
    values:
      layout: none
```

### Problem: Changes Not Showing Up

**Symptoms:**
- Made changes to HTML
- Pushed to GitHub
- Old content still showing

**Solutions:**

1. **Wait for GitHub to rebuild**
   - GitHub Pages rebuilds take 1-3 minutes
   - Check GitHub Actions tab for build status

2. **Browser cache**
   - Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
   - Or open in incognito/private window

3. **GitHub Actions failed**
   - Go to repo → Actions tab
   - Check if latest build failed
   - Click on failed build to see error

### Problem: CSS/Styling Not Loading

**Symptoms:**
- Page loads but looks unstyled
- Inline styles work, external don't

**Solutions:**

1. **Use inline styles**
   - Keep all CSS in `<style>` tags within HTML
   - Avoid external CSS files for simplicity

2. **If using external CSS:**
   - Make sure CSS file is in `docs/` directory
   - Add to `include:` in _config.yml
   - Reference with relative path: `<link href="./styles.css">`

---

## GitHub Actions Workflow

GitHub automatically builds your site when you push. You can see this in:
1. Go to your GitHub repo
2. Click "Actions" tab
3. See "pages build and deployment" workflows
4. Each push triggers a new build

**Build Time:** Usually 30-90 seconds

---

## Contact Information

All documentation pages include:
- **Email:** mobex10@gmail.com
- **App Name:** OtoKage
- **Developer:** Ferhat Furkan Afsin

Update these in the HTML files if they change.

---

## For Play Store Submission

When filling out Google Play Store forms:

1. **Privacy Policy URL:**
   ```
   https://ferhatfurkanafsin.github.io/OtoKage/privacy.html
   ```

2. **Data Deletion Instructions URL:**
   ```
   https://ferhatfurkanafsin.github.io/OtoKage/delete-account.html
   ```

3. **Terms of Service URL (optional):**
   ```
   https://ferhatfurkanafsin.github.io/OtoKage/terms.html
   ```

All these URLs have been **VERIFIED** to return HTTP 200 and are ready for Play Store submission.

---

## Summary

✅ **GitHub Pages Setup Complete**
- All HTML files created
- Jekyll configuration correct
- URLs verified working
- Ready for Play Store submission

🔗 **All URLs Working:**
- Privacy Policy ✅
- Delete Account Instructions ✅
- Terms of Service ✅
- Landing Page ✅

📝 **How to Update:**
1. Edit HTML file in `docs/`
2. Commit and push
3. Wait 1-2 minutes
4. Verify URL still works

---

**End of GitHub Pages Setup Guide**
