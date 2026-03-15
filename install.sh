#!/bin/bash
set -e

REPO="https://github.com/bi-boo/happy.git"
INSTALL_DIR="${TMPDIR:-/tmp}/happy-install-$$"

echo "Installing Happy CLI..."
echo "Server: https://happy.yuanfengai.cn"
echo ""

# Check prerequisites
if ! command -v node &>/dev/null; then
    echo "Error: Node.js is required. Install it from https://nodejs.org/"
    exit 1
fi

if ! command -v git &>/dev/null; then
    echo "Error: git is required."
    exit 1
fi

# Check if yarn is available, install if not
if ! command -v yarn &>/dev/null; then
    echo "[0/5] Installing yarn..."
    npm install -g yarn
fi

# Clone
echo "[1/5] Downloading..."
git clone --depth 1 "$REPO" "$INSTALL_DIR" 2>/dev/null

cd "$INSTALL_DIR"

# Install dependencies
echo "[2/5] Installing dependencies..."
yarn install --frozen-lockfile --ignore-engines 2>&1 | tail -3

# Build happy-wire (required dependency for happy-cli)
echo "[3/5] Building happy-wire..."
yarn workspace @slopus/happy-wire build 2>&1 | tail -3

# Build happy-cli
echo "[4/5] Building happy-cli..."
yarn workspace happy-coder build 2>&1 | tail -3

# Install globally
echo "[5/5] Installing globally..."
cd packages/happy-cli
npm install -g .

# Cleanup
cd /
rm -rf "$INSTALL_DIR"

echo ""
echo "Done! Run 'happy auth login' to authenticate."
echo "Then run 'happy' to start."
