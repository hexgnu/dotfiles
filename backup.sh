#!/usr/bin/env bash
#
SRC="/home/$USER/"
DEST="/run/media/$USER/Backup/fedora-home-$(hostname)-$(date +%Y%m%d)/"

mkdir -p "$DEST"

EXCLUDES=(
  "--exclude=.cache/"
  "--exclude=.local/share/Trash/"
  "--exclude=.npm/_cacache/"
  "--exclude=**/__pycache__/"
  "--exclude=**/.venv/"
  "--exclude=**/node_modules/"
  "--exclude=.cargo/registry/" "--exclude=.cargo/git/"
  "--exclude=.gradle/" "--exclude=.m2/repository/"
  "--exclude=.ivy2/cache/" "--exclude=Go/pkg/mod/"
  "--exclude=.local/share/flatpak/repo/"
  "--exclude=.var/app/*/cache/"
  "--exclude=.thumbnails/"
  "--exclude=.local"
)

# Dry run first
# rsync -aAXH --numeric-ids --info=progress2 --delete -n \
#   --one-file-system --partial --sparse "${EXCLUDES[@]}" \
#   "/home/$USER/" "$DEST"

sudo rsync -aAXH --numeric-ids --info=progress2 --delete \
  --one-file-system --partial --sparse "${EXCLUDES[@]}" \
  "/home/$USER/" "$DEST"

# sudo rsync -aAXH --numeric-ids --info=progress2 --delete \
#   --one-file-system --partial --sparse "${EXCLUDES[@]}" \
#   "/home/$USER/" "$DEST"
