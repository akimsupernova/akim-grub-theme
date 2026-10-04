#!/usr/bin/env bash
# Fit the boot menu box to the number of GRUB entries (no empty gap, nothing cut off).
# Usage:  sudo bash /boot/grub/themes/akimori/fit-menu.sh        (auto-detect from grub.cfg)
#         sudo bash /boot/grub/themes/akimori/fit-menu.sh 7       (force 7 entries)
# Re-run it whenever you add/remove boot entries. No grub-mkconfig needed afterwards.
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
THEME="$DIR/theme.txt"
CFG="${GRUB_CFG:-/boot/grub/grub.cfg}"

ITEM_H=40          # must match item_height in theme.txt
PAD=12             # must match item_padding in theme.txt
SPACING=14         # preferred gap between rows
MAX_H=480          # keep the box clear of the hint text at the bottom
BOX_PAD=26         # border slice size of menu_*.png
SLACK=4

count_entries() {
  awk '
    /^[[:space:]]*#/ { next }
    {
      isent = ($0 ~ /^[[:space:]]*(menuentry|submenu)[[:space:]]/)
      if (isent && !insub) n++
      if ($0 ~ /^[[:space:]]*submenu[[:space:]]/ && !insub) { insub = 1; subdepth = depth }
      t = $0; o = gsub(/\{/, "", t)
      t = $0; c = gsub(/\}/, "", t)
      depth += o - c
      if (insub && depth <= subdepth) insub = 0
    }
    END { print n + 0 }
  ' "$1"
}

N="$1"
if [ -z "$N" ]; then
  [ -r "$CFG" ] || { echo "Cannot read $CFG - pass the entry count manually, e.g. fit-menu.sh 7"; exit 1; }
  N=$(count_entries "$CFG")
fi
[ "$N" -ge 1 ] 2>/dev/null || { echo "Invalid entry count: $N"; exit 1; }

BASE=$(( 2*BOX_PAD + 2*PAD + 2 + SLACK ))
H=$(( BASE + N*ITEM_H + (N-1)*SPACING ))
if [ "$H" -gt "$MAX_H" ] && [ "$N" -gt 1 ]; then
  SPACING=$(( (MAX_H - BASE - N*ITEM_H) / (N-1) ))
  [ "$SPACING" -lt 0 ] && SPACING=0
  H=$(( BASE + N*ITEM_H + (N-1)*SPACING ))
fi

cp -a "$THEME" "$THEME.bak"
sed -i -E "s/^([[:space:]]*height = )[0-9]+/\1$H/; s/^([[:space:]]*item_spacing = )[0-9]+/\1$SPACING/" "$THEME"

echo "Entries detected : $N"
echo "item_spacing     : $SPACING"
echo "boot_menu height : $H px"
[ "$H" -gt "$MAX_H" ] && echo "WARNING: $N entries is more than fits; the list will scroll."
echo "Done. Backup: $THEME.bak"
