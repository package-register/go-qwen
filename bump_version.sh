#!/bin/bash

VERSION_FILE="VERSION"
BUMP_TYPE="$1"

if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: VERSION file not found. Please run 'make init' first."
  exit 1
fi

current_version=$(cat "$VERSION_FILE")
parts=$(echo "$current_version" | sed -e 's/^v//' | tr '.' '\n')
major=$(echo "${parts}" | head -n 1)
minor=$(echo "${parts}" | head -n 2 | tail -n 1)
patch=$(echo "${parts}" | tail -n 1)

new_major=$major
new_minor=$minor
new_patch=$patch

case "$BUMP_TYPE" in
  major)
    new_major=$((major + 1))
    new_minor=0
    new_patch=0
    ;;
  minor)
    new_minor=$((minor + 1))
    new_patch=0
    ;;
  patch)
    new_patch=$((patch + 1))
    ;;
  *)
    echo "Usage: bump_version.sh [major|minor|patch]"
    exit 1
    ;;
esac

new_version="v${new_major}.${new_minor}.${new_patch}"
echo "$new_version" > "$VERSION_FILE"
echo "Bumped version to $new_version"
