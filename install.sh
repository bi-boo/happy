#!/bin/bash
set -e

REPO="https://github.com/bi-boo/happy.git"
INSTALL_DIR="${TMPDIR:-/tmp}/happy-install-$$"

echo "Installing Happy CLI..."
echo "Server: https://happy.yuanfengai.cn"
echo ""

# Clone
echo "[1/4] Downloading..."
git clone --depth 1 "$REPO" "$INSTALL_DIR" 2>/dev/null

cd "$INSTALL_DIR"

# Install dependencies
echo "[2/4] Installing dependencies..."
yarn install --frozen-lockfile --ignore-engines --silent 2>/dev/null || npm install --ignore-scripts 2>/dev/null

# Build CLI
echo "[3/4] Building..."
cd packages/happy-cli
npx shx rm -rf dist
npx tsc --noEmit
npx pkgroll

# Install globally
echo "[4/4] Installing globally..."
npm install -g .

# Cleanup
cd /
rm -rf "$INSTALL_DIR"

echo ""
echo "Done! Run 'happy' to get started."
