#!/usr/bin/env bash
set -oue pipefail

echo "==> [Zaatar OS] Installing GNOME Extensions..."

EXTENSIONS_DIR="/usr/share/gnome-shell/extensions"
mkdir -p "${EXTENSIONS_DIR}"

# ── Curated Extensions for Smooth, Polished Experience ─────────────
# Essential: Blur, Dock, Animations, Productivity
declare -A EXTENSIONS=(
    ["blur-my-shell@aunetx"]="3193"                                    # Glass/blur effects
    ["dash-to-dock@micxgx.gmail.com"]="307"                             # Quick-access dock
    ["just-perfection-desktop@just-perfection"]="3843"                  # UI customization
    ["burn-my-windows@schneegans.github.com"]="5679"                    # Window animations
    ["compiz-alike-magic-lamp-effect@hermes83.github.com"]="3740"      # Minimize effect
    ["clipboard-indicator@tudmotu.com"]="779"                            # Clipboard history
    ["caffeine@patapon.info"]="517"                                    # Prevent screen sleep
    ["nightthemeswitcher@romainvigier.fr"]="3019"                       # Auto dark/light mode
    ["appindicatorsupport@rgcjonas.gmail.com"]="615"                  # Tray icons (Telegram, etc)
    ["Vitals@CoreCoding.com"]="1460"                                    # System monitoring
)

# ── Download and Install Each Extension ───────────────────────────
GNOME_VERSION=$(gnome-shell --version 2>/dev/null | sed 's/[^0-9.]//g' | cut -d. -f1)

for uuid in "${!EXTENSIONS[@]}"; do
    ext_id="${EXTENSIONS[$uuid]}"
    echo "  --> Installing: ${uuid}"

    # Get latest version_tag
    VERSION_TAG=$(curl -s "https://extensions.gnome.org/extension-info/?pk=${ext_id}&shell_version=${GNOME_VERSION}" \
        | jq -r '.version_tag // empty' 2>/dev/null || echo "")

    if [[ -z "${VERSION_TAG}" ]]; then
        echo "  [WARN] Could not get version for ${uuid}, skipping..."
        continue
    fi

    # Download Extension
    wget -q -O "/tmp/${uuid}.zip" \
        "https://extensions.gnome.org/download-extension/${uuid}.shell-extension.zip?version_tag=${VERSION_TAG}" \
        || { echo "  [WARN] Download failed for ${uuid}"; continue; }

    # Extract
    mkdir -p "${EXTENSIONS_DIR}/${uuid}"
    unzip -q -o "/tmp/${uuid}.zip" -d "${EXTENSIONS_DIR}/${uuid}/"
    rm -f "/tmp/${uuid}.zip"

    echo "  [OK] ${uuid}"
done

# ── Compile Schemas ────────────────────────────────────────────────
for schema_dir in "${EXTENSIONS_DIR}"/*/schemas; do
    if [[ -d "${schema_dir}" ]]; then
        glib-compile-schemas "${schema_dir}" 2>/dev/null || true
    fi
done

echo "==> GNOME Extensions Installed Successfully!"
