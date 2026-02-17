# 🌿 Zaatar OS

> نظام تشغيل عربي جديد ومتطور — نظام لينكس كامل جاهز للاستخدام مبني على [Aurora](https://getaurora.dev)، مع دعم كامل للغة العربية وواجهة حديثة وأنيقة.

> A new, advanced Arabic operating system — A complete, production-ready Linux distribution built on [Aurora](https://getaurora.dev), featuring full Arabic language support and a modern, elegant interface.

[![Build Status](https://github.com/YOUR_USERNAME/zaatar-os/workflows/Build%20Zaatar%20OS/badge.svg)](https://github.com/YOUR_USERNAME/zaatar-os/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Overview

**Zaatar OS** is a new Arabic Linux distribution built from the ground up for Arabic-speaking users. It offers a complete, ready-to-use system with full Arabic localization, a modern and intuitive interface, and a curated selection of essential applications — all designed for ease of use and a smooth experience.

### Key Features

- ✅ **Complete Arabic Language Support** - Full localization with Arabic as the default language
- ✅ **Production-Ready** - Fully integrated system without any missing components
- ✅ **Modern Interface** - Clean, elegant design with dark mode by default
- ✅ **Easy to Use** - Intuitive and user-friendly for everyone
- ✅ **Regular Updates** - Automated weekly builds for the latest packages

## Quick Start

### Prerequisites

- An existing [Aurora](https://getaurora.dev) installation
- Internet connection for the rebase process

### Installation

#### Standard Version (AMD/Intel)

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/YOUR_USERNAME/zaatar:stable
systemctl reboot
```

#### NVIDIA Version

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/YOUR_USERNAME/zaatar-nvidia:stable
systemctl reboot
```

**Note:** Replace `YOUR_USERNAME` with your GitHub username or organization name.

## What's Included

### 🌐 Complete Arabic Language Support

- **Default Language:** Arabic (Syria - Damascus locale: `ar_SY.UTF-8`)
- **Default Keyboard:** Arabic keyboard layout (with English as secondary)
- **Timezone:** Asia/Damascus (configurable)
- **RTL Support:** Full right-to-left text rendering support
- **Language Packs:**
  - Firefox with Arabic interface
  - LibreOffice with Arabic interface
  - Spell checking tools (hunspell-ar, aspell-ar)
  - Hyphenation and thesaurus (hyphen-ar, mythes-ar)

### 🔤 High-Quality Arabic Fonts

- **Cairo** - Default system font (optimized for Arabic)
- **Amiri** - Traditional Arabic font for literary texts
- **Tajawal** - Modern Arabic font
- **Noto Sans Arabic** - Comprehensive Arabic character support
- **Cascadia Code** - Monospace font for coding
- **Readex Pro** - Variable font for UI elements

### 🎨 User Interface

- **GTK Theme:** Modern dark theme with clean aesthetics
- **Icon Theme:** Consistent, high-quality icons
- **Cursor Theme:** Smooth cursor theme
- **Color Scheme:** Dark mode by default
- **Window Controls:** Streamlined layout (close, minimize, maximize)

### 🔌 Pre-installed GNOME Extensions

Curated for a smooth, polished experience — all pre-installed and enabled:

- **Blur My Shell** - Glass/blur effects for a refined look
- **Dash to Dock** - Quick-access dock at the bottom
- **Just Perfection** - Clean, customizable UI
- **Burn My Windows** - Smooth window animations
- **Compiz Magic Lamp** - Elegant minimize effect
- **Clipboard Indicator** - Clipboard history manager
- **Caffeine** - Prevent automatic suspend
- **Night Theme Switcher** - Automatic dark/light mode
- **AppIndicator** - System tray icons (Telegram, etc.)
- **Vitals** - System monitoring

### 📦 Pre-installed Applications (Flathub)

Essential apps ready from first boot:

| Category | Apps |
|----------|------|
| **Web** | Firefox |
| **Office** | LibreOffice, Evince (PDF), Text Editor |
| **Media** | VLC (video), GIMP (images) |
| **Utilities** | Calculator, Calendar, Clocks |
| **System** | Extension Manager, Flatseal, Kooha (screen recorder) |
| **Communication** | Telegram |

### ⚙️ System Configuration

- **Locale:** Arabic (Syria) - `ar_SY.UTF-8`
- **Timezone:** Asia/Damascus
- **Input Sources:** Arabic (primary), English (secondary)
- **Font Rendering:** Optimized for Arabic text
- **Desktop Environment:** GNOME with customizations

## Project Structure

```
zaatar-os/
├── cosign.pub                  # Signing public key (required for build)
├── recipes/
│   ├── common.yml              # Shared configuration for all variants
│   ├── zaatar.yml              # Standard version recipe
│   └── zaatar-nvidia.yml      # NVIDIA version recipe
├── scripts/
│   ├── setup-arabic-locale.sh # Arabic language setup
│   ├── install-tahoe-theme.sh # Theme installation
│   └── install-extensions.sh   # GNOME extensions installation
├── files/
│   └── gschema-overrides/
│       └── zz1-zaatar.gschema.override  # GNOME settings
├── .github/
│   └── workflows/
│       └── build.yml           # Automated build workflow
└── README.md                   # This file
```

## Building

This project uses [BlueBuild](https://blue-build.org) for automated image building.

### Automated Builds

Builds are automatically triggered:
- On every push to the `main` branch
- Weekly via scheduled cron job (every Sunday at midnight UTC)
- Manually via GitHub Actions workflow dispatch

### Manual Build

For detailed build instructions, see [BUILD.md](BUILD.md).

**Quick Start:**

```bash
# Install BlueBuild CLI
cargo install bluebuild-cli

# Build without signing (for local testing)
bluebuild build recipes/zaatar.yml

# Or build NVIDIA version
bluebuild build recipes/zaatar-nvidia.yml
```

**Note:** If you encounter signing key errors, see the [Troubleshooting](#troubleshooting) section below or refer to [BUILD.md](BUILD.md) for detailed solutions.

## Customization

### Changing Default Locale

To use a different Arabic locale, edit `scripts/setup-arabic-locale.sh` and modify the locale settings.

### Changing Timezone

Edit `scripts/setup-arabic-locale.sh` and update the timezone setting:

```bash
timedatectl set-timezone Your/Timezone
```

### Adding Applications

Add Flatpak applications in `recipes/common.yml` under the `default-flatpaks` section.

### Modifying Theme

Theme settings can be adjusted in `files/gschema-overrides/zz1-zaatar.gschema.override`.

## Troubleshooting

### Build Errors

**Error: "Operation not permitted" (os error 1)**

This error occurs in WSL2 when building from Windows-mounted directories. **Solution:**

```bash
# Copy project to WSL2 filesystem (not /mnt/c/)
cp -r /mnt/c/Users/maher/Downloads/zaatar-os ~/zaatar-os
cd ~/zaatar-os/zaatar-os
bluebuild build recipes/zaatar.yml
```

**Error: "no such file or directory: keys"**

BlueBuild requires `cosign.pub` in the project root. If missing (e.g. after copying project):

```bash
cd ~/zaatar-os/zaatar-os
curl -sL -o cosign.pub https://raw.githubusercontent.com/blue-build/template/main/cosign.pub
ls cosign.pub   # verify it exists
bluebuild build recipes/zaatar.yml
```

2. **Set empty environment variables**:
   ```bash
   export COSIGN_PRIVATE_KEY=""
   export COSIGN_PASSWORD=""
   bluebuild build recipes/zaatar.yml
   ```

3. **Generate signing keys** (for production):
   ```bash
   cosign generate-key-pair
   export COSIGN_PRIVATE_KEY=$(cat cosign.key)
   export COSIGN_PASSWORD="your-password"
   bluebuild build recipes/zaatar.yml
   ```

For more detailed troubleshooting, see [BUILD.md](BUILD.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **[Universal Blue / Aurora](https://universal-blue.org)** - Base distribution
- **[BlueBuild](https://blue-build.org)** - Build system and tooling
- **[GNOME Project](https://www.gnome.org)** - Desktop environment

## Support

For issues, questions, or contributions, please open an issue on the [GitHub repository](https://github.com/YOUR_USERNAME/zaatar-os).

---

**نظام عربي جديد — مصنوع للمجتمع العربي ❤️**
