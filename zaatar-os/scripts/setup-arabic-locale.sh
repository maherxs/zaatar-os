#!/usr/bin/env bash
set -oue pipefail

echo "==> [Zaatar OS] Setting up Arabic language (Syria - Damascus)..."

# ── Install Arabic Language Packages ─────────────────────────────
dnf install -y \
    glibc-langpack-ar \
    langpacks-ar \
    firefox-langpacks-ar \
    libreoffice-langpacks-ar \
    hunspell-ar

# ── Create Locale Files for Arabic ───────────────────────────────
localedef -i ar_SA -f UTF-8 ar_SA.UTF-8 || true
localedef -i ar_AE -f UTF-8 ar_AE.UTF-8 || true
localedef -i ar_EG -f UTF-8 ar_EG.UTF-8 || true
localedef -i ar_IQ -f UTF-8 ar_IQ.UTF-8 || true
localedef -i ar_JO -f UTF-8 ar_JO.UTF-8 || true
localedef -i ar_KW -f UTF-8 ar_KW.UTF-8 || true
localedef -i ar_LB -f UTF-8 ar_LB.UTF-8 || true
localedef -i ar_LY -f UTF-8 ar_LY.UTF-8 || true
localedef -i ar_MA -f UTF-8 ar_MA.UTF-8 || true
localedef -i ar_OM -f UTF-8 ar_OM.UTF-8 || true
localedef -i ar_QA -f UTF-8 ar_QA.UTF-8 || true
localedef -i ar_SD -f UTF-8 ar_SD.UTF-8 || true
localedef -i ar_SY -f UTF-8 ar_SY.UTF-8 || true
localedef -i ar_TN -f UTF-8 ar_TN.UTF-8 || true
localedef -i ar_YE -f UTF-8 ar_YE.UTF-8 || true

# ── Update locale.conf File ──────────────────────────────────────
cat > /etc/locale.conf <<EOF
LANG=ar_SY.UTF-8
LC_MESSAGES=ar_SY.UTF-8
LC_TIME=ar_SY.UTF-8
LC_NUMERIC=ar_SY.UTF-8
LC_MONETARY=ar_SY.UTF-8
LC_PAPER=ar_SY.UTF-8
LC_NAME=ar_SY.UTF-8
LC_ADDRESS=ar_SY.UTF-8
LC_TELEPHONE=ar_SY.UTF-8
LC_MEASUREMENT=ar_SY.UTF-8
LC_IDENTIFICATION=ar_SY.UTF-8
EOF

# ── Update locale.gen File (if exists) ────────────────────────────
if [ -f /etc/locale.gen ]; then
    sed -i 's/# ar_SY.UTF-8 UTF-8/ar_SY.UTF-8 UTF-8/' /etc/locale.gen || true
fi

# ── Set Timezone to Damascus, Syria ──────────────────────────────
timedatectl set-timezone Asia/Damascus || true

# ── Update dconf Files for Default User ──────────────────────────
# Will be applied on first login
mkdir -p /etc/skel/.config
cat > /etc/skel/.config/user-dirs.locale <<EOF
ar_SY
EOF

# ── Setup User Directories in Arabic ─────────────────────────────
# Will be created on first login
if command -v xdg-user-dirs-update &> /dev/null; then
    # Will be updated automatically on login
    echo "User directories will be updated on first login"
fi

echo "==> Arabic language setup completed successfully!"
