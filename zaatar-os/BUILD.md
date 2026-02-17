# Building Zaatar OS

This document provides detailed instructions for building Zaatar OS images locally.

## Prerequisites

- Linux or WSL2 environment
- [BlueBuild CLI](https://blue-build.org) installed
- Podman or Docker installed
- Sufficient disk space (at least 20GB free)

### ⚠️ Important for WSL2 Users

**If you're using WSL2, build from within the WSL2 filesystem, NOT from Windows mounts (`/mnt/c/`).**

The "Operation not permitted" error occurs when building from Windows-mounted directories. Solutions:

1. **Copy project to WSL2 filesystem** (Recommended):
   ```bash
   # Copy project to home directory
   cp -r /mnt/c/Users/maher/Downloads/zaatar-os ~/zaatar-os
   cd ~/zaatar-os/zaatar-os
   
   # Then build
   bluebuild build recipes/zaatar.yml
   ```

2. **Use Docker instead of Podman** (if available):
   ```bash
   # Set Docker as the container runtime
   export CONTAINER_RUNTIME=docker
   bluebuild build recipes/zaatar.yml
   ```

3. **Configure Podman for WSL2** (Advanced):
   ```bash
   # Enable rootless Podman with proper permissions
   podman system migrate
   ```

## Installation

### Install BlueBuild CLI

**Using Cargo (Recommended):**
```bash
cargo install bluebuild-cli
```

**Using Install Script:**
```bash
curl -fsSL https://raw.githubusercontent.com/blue-build/cli/main/install.sh | bash
```

**Using Package Manager:**
```bash
# Arch Linux / Manjaro
yay -S bluebuild-cli

# Fedora / RHEL
dnf install bluebuild-cli
```

### Install Cosign (Optional - for signing)

```bash
# Download cosign
wget https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign
```

## Building Without Signing (Local Development)

BlueBuild requires `cosign.pub` in the project root (included in this repo). For local builds without signing:

```bash
# Build standard version
bluebuild build recipes/zaatar.yml

# Build NVIDIA version
bluebuild build recipes/zaatar-nvidia.yml
```

**Note:** The project includes a placeholder `cosign.pub`. For production signing, generate your own keys and replace it.

## Building With Signing (Production)

### Generate Signing Keys

1. **Generate cosign key pair:**
   ```bash
   cosign generate-key-pair
   ```
   
   This creates:
   - `cosign.key` - Private key (keep this secret!)
   - `cosign.pub` - Public key (can be shared)

2. **Set environment variables:**
   ```bash
   export COSIGN_PRIVATE_KEY=$(cat cosign.key)
   export COSIGN_PASSWORD="your-password-here"
   ```

3. **Build with signing:**
   ```bash
   bluebuild build recipes/zaatar.yml
   ```

### Using GitHub Secrets (CI/CD)

For GitHub Actions builds, store your private key as a repository secret:

1. Go to your repository → Settings → Secrets and variables → Actions
2. Add a new secret named `SIGNING_SECRET`
3. Paste the contents of `cosign.key`
4. The workflow will automatically use it for signing

## Build Options

### Specify Output Registry

```bash
bluebuild build recipes/zaatar.yml --registry ghcr.io/your-username
```

### Build for Specific Architecture

```bash
bluebuild build recipes/zaatar.yml --arch amd64
bluebuild build recipes/zaatar.yml --arch arm64
```

### Verbose Output

```bash
bluebuild build recipes/zaatar.yml --verbose
```

## Troubleshooting

### Error: "Operation not permitted" (os error 1)

**Problem:** This error occurs in WSL2 when building from Windows-mounted directories (`/mnt/c/`). Container runtimes cannot properly handle file permissions on Windows NTFS mounts.

**Solutions:**

1. **Move project to WSL2 filesystem** (Best solution):
   ```bash
   # Copy to WSL2 home directory
   cp -r /mnt/c/Users/maher/Downloads/zaatar-os ~/zaatar-os
   cd ~/zaatar-os/zaatar-os
   
   # Build from WSL2 filesystem
   bluebuild build recipes/zaatar.yml
   ```

2. **Use Docker Desktop** (if available):
   ```bash
   # Docker Desktop handles Windows mounts better than Podman
   export CONTAINER_RUNTIME=docker
   bluebuild build recipes/zaatar.yml
   ```

3. **Check Podman/Docker permissions**:
   ```bash
   # For Podman
   podman info
   podman system migrate
   
   # For Docker
   docker info
   ```

4. **Build in a Linux VM or native Linux** (if WSL2 continues to have issues)

### Error: "no such file or directory: keys"

**Problem:** BlueBuild requires `cosign.pub` in the project root to populate the keys stage.

**Solution:** Add cosign.pub to the project root:
```bash
# Download placeholder from BlueBuild template
curl -o cosign.pub https://raw.githubusercontent.com/blue-build/template/main/cosign.pub

# Verify it exists
ls -la cosign.pub

bluebuild build recipes/zaatar.yml
```

**Solution 2:** Set empty environment variables (if above doesn't work)
```bash
export COSIGN_PRIVATE_KEY=""
export COSIGN_PASSWORD=""
bluebuild build recipes/zaatar.yml
```

### Error: "Failed to pull base image"

**Problem:** Cannot access the base Aurora image.

**Solution:**
```bash
# Login to GitHub Container Registry
podman login ghcr.io
# Or
docker login ghcr.io
```

### Error: "Insufficient disk space"

**Problem:** Not enough free disk space for the build.

**Solution:**
- Free up disk space (at least 20GB recommended)
- Clean up old images: `podman image prune` or `docker image prune`

### Build Takes Too Long

**Problem:** Build process is slow.

**Solutions:**
- Ensure you have a stable internet connection
- Use a faster mirror for package downloads
- Build during off-peak hours
- Consider using GitHub Actions for automated builds

## Testing the Build

After building, you can test the image:

```bash
# Using Podman
podman run -it --rm localhost/zaatar:latest bash

# Using Docker
docker run -it --rm localhost/zaatar:latest bash
```

## Pushing to Registry

After a successful build:

```bash
# Tag the image
podman tag localhost/zaatar:latest ghcr.io/your-username/zaatar:latest

# Push to registry
podman push ghcr.io/your-username/zaatar:latest
```

## Additional Resources

- [BlueBuild Documentation](https://blue-build.org)
- [Cosign Documentation](https://docs.sigstore.dev/cosign/overview/)
- [Universal Blue Documentation](https://universal-blue.org)
