#!/usr/bin/env bash
# Ensures cosign.pub exists before build (run from project root)
cd "$(dirname "$0")/.."
if [[ ! -f cosign.pub ]]; then
    echo "==> Downloading cosign.pub..."
    curl -sL -o cosign.pub https://raw.githubusercontent.com/blue-build/template/main/cosign.pub
    echo "==> cosign.pub added."
else
    echo "==> cosign.pub exists."
fi
