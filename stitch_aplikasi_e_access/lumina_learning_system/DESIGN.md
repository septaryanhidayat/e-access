---
name: Lumina Learning System
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#c3c6d7'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#8d90a0'
  outline-variant: '#434655'
  surface-tint: '#b4c5ff'
  primary: '#b4c5ff'
  on-primary: '#002a78'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#0053db'
  secondary: '#4edea3'
  on-secondary: '#003824'
  secondary-container: '#00a572'
  on-secondary-container: '#00311f'
  tertiary: '#ffb95f'
  on-tertiary: '#472a00'
  tertiary-container: '#996100'
  on-tertiary-container: '#ffeedd'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Manrope
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  container-margin: 16px
  gutter: 12px
---

## Brand & Style

The design system is engineered for the modern student—balancing high-performance utility with a motivating, energetic aesthetic. The brand personality is **Empowering, Focused, and Intellectual.** It seeks to evoke a sense of clarity and accomplishment through a "Deep Focus" interface.

The design style is a hybrid of **Modern Corporate** and **Glassmorphism**. It utilizes a dark, low-fatigue background to reduce eye strain during long study sessions, contrasted with vibrant, glowing accents that guide the eye toward primary actions and progress metrics. The interface leverages translucent layers and soft shadows to establish a clear hierarchy within a complex information environment.

## Colors

The palette is optimized for a high-contrast dark mode. 
- **Primary (Electric Blue):** Used for primary actions, active states, and brand-level identifiers.
- **Secondary (Vibrant Green):** Dedicated to "Success" states, completed tasks, and positive progress indicators.
- **Tertiary (Amber):** Utilized for warnings, pending tasks, and time-sensitive reminders.
- **Neutral (Slate/Navy):** The foundation of the UI. Backgrounds use a deep slate to prevent pure-black "smearing" on OLED screens while maintaining high contrast with white text.

Surface colors utilize incremental lightening (Step 1: #0F172A, Step 2: #1E293B) to define depth without relying solely on borders.

## Typography

This design system uses **Plus Jakarta Sans** as the primary typeface for its friendly yet professional geometric forms, ensuring readability in dense dashboards. **Manrope** is used for secondary labels and data points due to its technical precision.

- **Headlines:** Use Bold (700) or SemiBold (600) weights with tighter letter spacing to create a strong visual anchor.
- **Body:** Standard weight (400) with generous line heights to ensure legibility of educational content.
- **Labels:** Use Manrope with increased letter spacing and uppercase styling for small-scale metadata (e.g., timestamps, subject categories).

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for Android handheld and tablet devices. 

- **Grid System:** A 12-column grid for tablet/desktop and a 4-column grid for mobile.
- **Safe Areas:** 16px horizontal margins (container-margin) ensure content doesn't hit the bezel.
- **Rhythm:** An 8pt linear scale is the standard, but a 4pt sub-grid is used for tight component internals (like icon-to-text spacing).
- **Cards:** Dashboard items are grouped into cards with 16px internal padding. Spacing between cards should be a consistent 12px to maintain a "tiled" look without excessive whitespace gaps.

## Elevation & Depth

Hierarchy is established through **Tonal Layers** and **Ambient Shadows**.

1.  **Background (Level 0):** Deepest slate (#0F172A). Used for the main app canvas.
2.  **Surface (Level 1):** Slightly lighter slate (#1E293B). Used for secondary containers and navigation bars.
3.  **Elevated (Level 2):** Cards and Modal elements. These use a subtle 1px border (#334155) and a soft, diffused shadow (0px 8px 24px rgba(0, 0, 0, 0.4)).
4.  **Interactive (Level 3):** Elements that are being pressed or hovered gain a glow effect using the Primary or Secondary color at 20% opacity.

Glassmorphism is applied to persistent elements like Bottom Navigation Bars and Top App Bars, using a backdrop blur of 12px and 60% opacity on the surface color.

## Shapes

The shape language is consistently **Rounded**. This approach softens the data-heavy nature of an LMS, making the experience feel more approachable and less like a rigid spreadsheet.

- **Small Components (Buttons, Chips):** 0.5rem (8px).
- **Medium Components (Cards, Modals):** 1rem (16px).
- **Large Components (Sections, Hero Banners):** 1.5rem (24px).
- **Icons:** Should use a rounded cap and join style to match the UI's geometry.

## Components

### Buttons
- **Primary:** Solid Electric Blue with white text. High-contrast, 16px padding.
- **Secondary:** Transparent with an Electric Blue 1.5px outline.
- **Ghost:** No background or border; used for "See All" or "Dismiss" actions.

### Chips & Badges
Used for status (e.g., "Active," "Level 4"). These should use a 15% opacity version of the status color for the background, with a 100% opacity version for the text.

### Cards
Cards are the primary container for course content and schedule items. 
- Must include a subtle 1px top-border "light leak" to enhance the sense of depth.
- Support "Progress Bar" integration at the bottom of the card for course completion.

### Input Fields
Dark backgrounds (#0F172A) with a 1px border that glows Blue when focused. Labels should float or stay above the input to maintain visibility.

### Progress Rings
For the dashboard's "Presensi" (Attendance) and Grade sections, use thick-stroke circular progress bars with rounded ends. Use gradients (Secondary to Primary) for a modern, high-tech feel.