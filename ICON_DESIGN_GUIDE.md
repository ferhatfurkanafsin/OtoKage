# OtoKage App Icon Design Guide

## Design Concept

The OtoKage (音影 - "Sound Shadow") icon should embody anime aesthetics while clearly representing music recognition functionality.

## Visual Elements

### Primary Design (Recommended)

**Composition:**
- **Size:** 1024x1024px (square)
- **Background:** Deep dark gradient (#0B0D14 to #1A1F2E)
- **Main Element:** Stylized anime-style headphones with cat ear design

**Central Icon:**
1. **Headphones with Cat Ears:**
   - Modern over-ear headphones shape
   - Two triangular "cat ears" (neko mimi) protruding from the top
   - This references "Kage" (shadow/silhouette) while adding anime charm

2. **Color Gradient:**
   - Primary: Neon Cyan (#00E5FF) on the left side
   - Secondary: Sakura Pink (#FF6B9D) on the right side
   - Smooth gradient transition across the headphones
   - Glowing effect around edges

3. **Additional Details:**
   - Small musical notes (♪ ♫) floating around the headphones
   - Subtle anime-style sparkle/shine effects (4-pointed stars)
   - Sound wave visualization at the bottom
   - Slight neon glow/bloom effect

### Color Palette

```
Background Gradient:
- Top: #0B0D14 (Deep Space)
- Bottom: #1A1F2E (Dark Blue-Gray)

Main Icon:
- Primary: #00E5FF (Neon Cyan)
- Secondary: #FF6B9D (Sakura Pink)
- Accent: #9D4EDD (Electric Purple) - for sparkles
- Highlights: #FFFFFF at 80% opacity
- Shadows: #000000 at 50% opacity

Glow Effects:
- Cyan glow: #00E5FF at 40% opacity, 20px blur
- Pink glow: #FF6B9D at 30% opacity, 25px blur
```

## Design Specifications

### Style Guidelines

1. **Anime Aesthetic:**
   - Clean, bold lines
   - Vibrant neon colors
   - Glowing effects (cyberpunk anime style)
   - Sparkle/shine elements (common in anime)
   - Cat ear motif (popular in anime culture)

2. **Modern & Minimalist:**
   - Not overly complex
   - Recognizable at small sizes
   - Clear silhouette
   - Professional appearance

3. **Music Recognition Theme:**
   - Headphones as primary element
   - Musical notes as supporting elements
   - Sound wave visualization
   - Clear connection to audio/music

### Technical Requirements

**File Specifications:**
- **Master File:** 1024x1024px PNG with transparency
- **Format:** PNG with alpha channel
- **Color Mode:** RGB
- **Resolution:** 72 DPI (for screen display)
- **File Size:** Optimized, ideally under 200KB

**Export Settings:**
- Transparent background OR dark gradient background
- High quality PNG compression
- No white borders or padding
- Icon should fill most of the canvas (leaving ~50px margin)

## Alternative Design Concepts

### Option 2: Anime Character Silhouette
- Anime girl silhouette with headphones
- Gradient coloring (cyan to pink)
- Musical notes forming a circular pattern around her
- More directly anime-themed but potentially less professional

### Option 3: Japanese Character Focus
- Large katakana オト (Oto) overlaid with カゲ (Kage)
- Stylized with neon gradient
- Musical note replacing the dot in カ
- Very Japanese-focused, might not be as universal

### Option 4: Sound Wave Cat
- Abstract cat face made from sound wave patterns
- Neon gradient colors
- Minimalist and modern
- Subtle anime reference through cat motif

## Design Tools Recommendations

**Online Tools:**
1. **Figma** (Free) - Vector design, great for icons
2. **Canva** (Free/Pro) - Easy to use, has anime-style elements
3. **Photopea** (Free) - Photoshop alternative, browser-based
4. **Inkscape** (Free) - Vector graphics editor

**AI Image Generation (if using):**
- Prompt: "App icon, anime style headphones with cat ears, neon cyan and sakura pink gradient, musical notes, dark background, glowing effect, 1024x1024, minimalist, professional"

**Mobile Apps:**
1. **Procreate** (iPad) - Professional digital art
2. **Adobe Illustrator** (Subscription) - Industry standard

## Step-by-Step Creation Guide

### Using Figma (Recommended for Beginners):

1. **Setup:**
   - Create new file, 1024x1024 artboard
   - Add dark gradient background

2. **Main Shape:**
   - Use pen/shape tools to draw headphones
   - Add two triangle shapes on top for cat ears
   - Group all shapes

3. **Gradient:**
   - Apply linear gradient (left to right)
   - Colors: #00E5FF → #FF6B9D
   - Adjust angle for best effect

4. **Effects:**
   - Add outer glow (cyan, 20px blur)
   - Add drop shadow for depth
   - Layer another pink glow beneath

5. **Details:**
   - Add musical note icons (use text: ♪ ♫)
   - Position around headphones
   - Add small star sparkles (4-pointed)

6. **Export:**
   - Export as PNG, 1024x1024
   - Include transparency
   - Name: otokage_icon.png

## Current Icon Status

**Existing Icon:** vibequest_icon.png
- Located at: `/frontend/assets/vibequest_icon.png`
- Size: 1024x1024px
- Style: Neon themed

**New Icon:** otokage_icon.png
- To be created using this guide
- Will replace existing icon
- Should maintain similar neon aesthetic but with anime focus

## Implementation Checklist

Once icon is created:

- [ ] Save as `otokage_icon.png` in `/frontend/assets/`
- [ ] Update `pubspec.yaml` icon path
- [ ] Run `flutter pub run flutter_launcher_icons:main`
- [ ] Verify icons generated for all platforms
- [ ] Test app icon on Android device
- [ ] Test app icon on iOS device (if applicable)
- [ ] Check icon appearance on different backgrounds

## Design Tips

1. **Test at Multiple Sizes:**
   - View at 1024px, 512px, 256px, 128px, 64px, 32px
   - Icon should remain recognizable at all sizes

2. **Avoid:**
   - Too much fine detail (won't show at small sizes)
   - Text/letters (hard to read on icons)
   - Too many colors (keep it simple)
   - Realistic/photographic elements (doesn't scale well)

3. **Ensure:**
   - High contrast between elements
   - Clear, bold shapes
   - Consistent style throughout
   - Professional appearance despite anime theme

## Brand Consistency

The icon should match OtoKage's brand identity:
- **Mission:** Anime music recognition
- **Style:** Modern, neon, anime-inspired
- **Colors:** Cyan, Sakura Pink, Purple accents
- **Vibe:** Energetic, youthful, tech-savvy, anime-focused

---

**Note:** If you need professional icon design services, consider:
- Fiverr icon designers ($5-50)
- 99designs icon contests ($299+)
- Dribbble/Behance freelancers
- Or use AI generation tools with the prompt provided above
