#!/usr/bin/env bash
set -oue pipefail

echo "==> [Zaatar OS] Installing GNOME Extensions..."

EXTENSIONS_DIR="/usr/share/gnome-shell/extensions"
mkdir -p "${EXTENSIONS_DIR}"

# ── Extension List with IDs ───────────────────────────────────────
declare -A EXTENSIONS=(
    ["blur-my-shell@aunetx"]="3193"
    ["dash-to-dock@micxgx.gmail.com"]="307"
    ["just-perfection-desktop@just-perfection"]="3843"
    ["compiz-alike-magic-lamp-effect@hermes83.github.com"]="3740"
    ["burn-my-windows@schneegans.github.com"]="5679"
    ["caffeine@patapon.info"]="517"
    ["clipboard-indicator@tudmotu.com"]="779"
    ["nightthemeswitcher@romainvigier.fr"]="3019"
    ["Vitals@CoreCoding.com"]="1460"
    ["openweather-extension@jenslody.de"]="750"
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
