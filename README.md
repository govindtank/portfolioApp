# 🚀 Govind Tank — Architectural Portfolio v2

A high-performance, responsive portfolio application engineered in **Flutter** (Impeller / CanvasKit natively) demonstrating advanced system architecture, Enterprise Mobile expertise, Agentic AI, and Kotlin Multiplatform capabilities.

## 🔗 Live Links
* 🌐 **Main Website:** [govindtank.github.io](https://govindtank.github.io)
* 📱 **Web App Experience:** [govindtank.github.io/portfolioApp/](https://govindtank.github.io/portfolioApp/)
* 📄 **Professional Resume:** [govindtank.github.io/resume/](https://govindtank.github.io/resume/)

---

## 📸 App Preview

The app boasts a fully fluid and responsive **Cyber-Architect Design System** featuring:
- Seamless Dark and Light Mode transitions.
- Interactive mesh ambient background gradients.
- Glassmorphic UI constraints tailored for Mobile, Tablet, and Desktop.
- Live dynamic tech blog integration.

### Dark Mode (Obsidian Cyber)
![Dark Mode Screenshot](assets/images/screenshot_dark.png)

### Light Mode (Aurora Glass)
![Light Mode Screenshot](assets/images/screenshot_light.png)

---

## ⚡ Next-Generation Features

### 1. Dual-Mode Design System & Theme Engine
Instead of just a simple toggle, this app features a true multi-palette design language. The UI adapts dynamically with **Ambient Backgrounds** (animated glowing radial mesh gradients that pulse smoothly). Users can deeply customize the appearance via the stunning **Glassmorphic Appearance Settings Bottom Sheet** offering 5 distinct neon-accent cyber themes (`Cyber Sky`, `Neon Cyan`, `Electric Indigo`, `Matrix Emerald`, `Solar Amber`).

### 2. Dynamic GitHub-Driven Architecture Blog
Tech logs and articles are **not hardcoded**. The app integrates a powerful `BlogService` that uses the GitHub REST API to live-fetch Markdown (`.md`) articles directly from the [`govindtank.github.io`](https://govindtank.github.io) repository's `src/content/blog` directory.
- Instant frontmatter parsing.
- Dual-reading experience via embedded Markdown and high-performance WebViews.
- Intelligent offline caching preventing unnecessary network calls.

### 3. Choreographed Performance Animations
Utilizing `flutter_animate`, the UI feels incredibly tactile. 
- The initial load is guarded by a cinematic, non-blocking splash sequence with breathtaking breathing halo rings.
- Navigation yields staggered list entrance animations. 
- Elements respond fluidly with 3D spring-elevation on touches and hovers ensuring absolute premium visual fidelity.

### 4. Interactive Enterprise Showcase
The **Projects Screen** filters live, high-scale engineering achievements demonstrating metrics like *99.95% crash-free stability*, *AWS CloudFront DRM*, and *100k+ global downloads*.

---

## 🛠️ Build & Run Locally

```bash
# Get dependencies
flutter pub get

# Run on macOS native or Chrome Web
flutter run -d chrome

# Build for Web Deployment (optimized with Impeller)
flutter build web --release --base-href /portfolioApp/
```

> **Author**: Govind Tank — Senior Lead Architect & Android Expert.
