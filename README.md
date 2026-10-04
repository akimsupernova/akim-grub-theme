# AKIM GRUB Theme

A custom GRUB theme made by me.

## Install

```bash
git clone https://github.com/USERNAME/REPO.git
cd REPO
./setup install
```

## Commands

| Command | What it does |
|---|---|
| `./setup install` | Install the theme |
| `./setup update` | Regenerate `grub.cfg` and re-apply icon classes (run after grub/kernel updates) |
| `./setup uninstall` | Remove the theme |

## Options

```bash
THEME_NAME=mytheme ./setup install    # change the theme folder name
GRUB_DIR=/boot/grub2 ./setup install  # custom GRUB directory
NO_MKCONFIG=1 ./setup install         # do not run grub-mkconfig
```

## Notes

- `grub-mkconfig` overwrites the icon classes. After regenerating manually, run
  `./setup update` instead of calling `grub-mkconfig` directly.
- Backups are created automatically: `/etc/default/grub.akim.bak` and `grub.cfg.akim.bak`.
- Requires GRUB 2 with a graphical terminal (UEFI or BIOS). Tested layout: Arch Linux.
