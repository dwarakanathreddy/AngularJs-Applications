#!/usr/bin/env bash

# Ensure jq and semver are installed
if ! command -v jq &> /dev/null; then
    echo "❌ jq is not installed. Install it using: sudo apt install jq (Linux) or brew install jq (Mac)"
    exit 1
fi

if ! command -v semver &> /dev/null; then
    echo "❌ semver is not installed. Install it using: npm install -g semver"
    exit 1
fi

# Create temporary file to store package versions
jq -r '.dependencies | to_entries | .[] | "\(.key):\(.value)"' package.json > package_versions.tmp

# Read versions.txt and check versions
while IFS="," read -r package min_version max_version; do
    pkg_version=$(grep "^$package:" package_versions.tmp | cut -d':' -f2 | tr -d ' ')

    if [[ -z "$pkg_version" ]]; then
        echo "⚠️ Package '$package' not found in package.json"
        continue
    fi

    echo "Checking '$package' ($pkg_version) against range [$min_version - $max_version]..."
    
    if semver -r ">=${min_version} <=${max_version}" "$pkg_version" &>/dev/null; then
        echo "  ✅ $pkg_version is within range"
    else
        echo "  ❌ $pkg_version is NOT within range"
    fi

done < versions.txt

# Clean up temp file
rm -f package_versions.tmp

echo -e "\nCheck complete! ✅"
