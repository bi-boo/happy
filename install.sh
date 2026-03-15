#!/bin/bash
set -e

REPO="https://github.com/bi-boo/happy.git"
INSTALL_DIR="${TMPDIR:-/tmp}/happy-install-$$"

cleanup() {
    rm -rf "$INSTALL_DIR" 2>/dev/null
}
trap cleanup EXIT

echo ""
echo "  Happy CLI Installer"
echo "  Server: https://happy.yuanfengai.cn"
echo ""

# Check prerequisites
if ! command -v node &>/dev/null; then
    echo "Error: Node.js >= 20 is required. Install it from https://nodejs.org/"
    exit 1
fi

NODE_MAJOR=$(node -e "console.log(process.versions.node.split('.')[0])")
if [ "$NODE_MAJOR" -lt 20 ]; then
    echo "Error: Node.js >= 20 required, found $(node --version)"
    exit 1
fi

if ! command -v npm &>/dev/null; then
    echo "Error: npm is required."
    exit 1
fi

if ! command -v git &>/dev/null; then
    echo "Error: git is required."
    exit 1
fi

# Install yarn if missing
if ! command -v yarn &>/dev/null; then
    echo "[0/5] Installing yarn..."
    npm install -g yarn
fi

# Clone
echo "[1/5] Downloading source..."
git clone --depth 1 "$REPO" "$INSTALL_DIR"

cd "$INSTALL_DIR"

# Install dependencies (SKIP_HAPPY_WIRE_BUILD because we build it explicitly next)
echo "[2/5] Installing dependencies (this may take a few minutes)..."
SKIP_HAPPY_WIRE_BUILD=1 yarn install --frozen-lockfile --ignore-engines

# Build happy-wire (required dependency for happy-cli)
echo "[3/5] Building happy-wire..."
yarn workspace @slopus/happy-wire build

# Build happy-cli
echo "[4/5] Building happy-cli..."
yarn workspace happy-coder build

# Uninstall old version if exists, then install new
echo "[5/5] Installing globally..."
npm uninstall -g happy-coder 2>/dev/null || true
cd packages/happy-cli
npm install -g .

echo ""
echo "Installation complete!"
echo ""
echo "  Next steps:"
echo "    1. Run: happy auth login"
echo "    2. Scan QR code with Happy app on your phone"
echo "    3. Run: happy"
echo ""
