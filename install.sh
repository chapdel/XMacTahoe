#!/bin/bash
# Installs the "XMacTahoe" global theme (KDE Plasma 6).
# Usage: ./install.sh [--light] [--layout] [--no-apply] [--no-round-corners] [--accent NAME] [--wallpaper NAME] [--root]
# Shortcuts: Meta = AppGrid grid, Alt+Space = AppGrid compact mode (wired by extra/kde-desktop-repair)
#   --light     apply the light variant (dark by default)
#   --layout    also reset the panel layout (top bar + dock)
#   --no-apply  copy the files without changing the active theme
#   --no-round-corners  do not install/enable the KWin rounded-corners effect
#   --accent NAME   blue|purple|pink|red|orange|yellow|green|graphite (extra/xmactahoe-accent)
#   --wallpaper NAME  XMacTahoe (default, zayronxio dynamic) or XMacTahoe-Liuice (vinceliuice day/night)
#   --root          also run the root steps with sudo: system-wide copy + login screen, Plymouth boot theme
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
VARIANT=dark; LAYOUT=""; APPLY=1; ROUND=1; ACCENT=""; WALL=""; ROOT=0; prev=""
for a in "$@"; do case "$prev" in --accent) ACCENT="$a"; prev=""; continue;; --wallpaper) WALL="$a"; prev=""; continue;; esac; case "$a" in --accent|--wallpaper) prev="$a";; --root) ROOT=1;; --light) VARIANT=light;; --layout) LAYOUT="--resetLayout";; --no-apply) APPLY=0;; --no-round-corners) ROUND=0;; esac; done
LS="$HOME/.local/share"
mkdir -p "$LS"/{plasma/desktoptheme,plasma/look-and-feel,plasma/plasmoids,color-schemes,icons,aurorae/themes,wallpapers,fonts} "$HOME/.config/Kvantum" "$HOME/.icons"
echo "→ Copying components into ~/.local/share ..."
cp -a "$D"/plasma/desktoptheme/.   "$LS/plasma/desktoptheme/"
cp -a "$D"/plasma/look-and-feel/.  "$LS/plasma/look-and-feel/"
cp -a "$D"/plasma/plasmoids/.      "$LS/plasma/plasmoids/"
cp -a "$D"/color-schemes/.         "$LS/color-schemes/"
cp -a "$D"/icons/.                 "$LS/icons/"
ln -sfn "$LS/icons/XMacTahoe-cursors" "$HOME/.icons/XMacTahoe-cursors"
cp -a "$D"/aurorae/themes/.        "$LS/aurorae/themes/"
cp -a "$D"/wallpapers/.            "$LS/wallpapers/"
cp -a "$D"/fonts/.                 "$LS/fonts/"
cp -a "$D"/Kvantum/.               "$HOME/.config/Kvantum/"
fc-cache -f >/dev/null 2>&1 || true
# MacTahoe GTK themes (GTK 2/3/4, libadwaita handled by xmactahoe-sync-variant)
mkdir -p "$HOME/.themes"; cp -a "$D"/gtk/themes/. "$HOME/.themes/"
# Finder-like Dolphin, Terminal.app-like Konsole (never overwrites an existing Dolphin config)
[ -f "$HOME/.config/dolphinrc" ] || cp "$D/extra/apps/dolphinrc" "$HOME/.config/dolphinrc"
mkdir -p "$HOME/.local/share/konsole"; cp "$D"/extra/apps/macOS.profile "$D"/extra/apps/XMacTahoe.colorscheme "$HOME/.local/share/konsole/"
kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile macOS.profile
# macOS-style notifications (top right, 5 s); KDE file dialogs in GTK apps (effective at next login)
kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupTimeout 5000
kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupPosition TopRight
mkdir -p "$HOME/.config/environment.d"; cp "$D/extra/environment.d/xmactahoe.conf" "$HOME/.config/environment.d/"
# lock screen: XMacTahoe wallpaper
kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image XMacTahoe
# dock AppGrid launcher (.desktop) + transparent fallback icon
mkdir -p "$LS/applications" "$LS/icons/hicolor/scalable/apps"
cp -a "$D"/extra/applications/. "$LS/applications/"
cp "$LS/icons/XMacTahoe-Night/128x128/apps/xmactahoe-transparent.svg" "$LS/icons/hicolor/scalable/apps/" 2>/dev/null || true
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
for v in gtk-3.0 gtk-4.0; do [ -f "$D/extra/gtk/$v-settings.ini" ] && { mkdir -p "$HOME/.config/$v"; cp "$D/extra/gtk/$v-settings.ini" "$HOME/.config/$v/settings.ini"; }; done
# repair script for the AppGrid shortcuts / top bar
mkdir -p "$HOME/.local/bin"; cp "$D/extra/kde-desktop-repair" "$HOME/.local/bin/kde-desktop-repair"; chmod +x "$HOME/.local/bin/kde-desktop-repair"
# Kvantum/GTK sync on every light/dark switch (Flex Hub, plasma-apply-lookandfeel)
cp "$D/extra/xmactahoe-sync-variant" "$HOME/.local/bin/"; chmod +x "$HOME/.local/bin/xmactahoe-sync-variant"
mkdir -p "$HOME/.config/systemd/user"; cp "$D"/extra/systemd/xmactahoe-variant.* "$HOME/.config/systemd/user/"
systemctl --user daemon-reload 2>/dev/null; systemctl --user enable --now xmactahoe-variant.path 2>/dev/null || true
# system dependencies (not shipped in ~/.local)
command -v kvantummanager >/dev/null 2>&1 || echo "⚠ Kvantum is missing: sudo dnf install kvantum"
if ! rpm -q plasma-applet-appgrid >/dev/null 2>&1; then
  RPM=$(ls "$D"/extra/rpm/plasma-applet-appgrid-*.x86_64.rpm 2>/dev/null | head -1)
  echo "→ AppGrid missing: installing the bundled RPM (sudo password required)"
  if [ -n "$RPM" ] && sudo dnf install -y "$RPM"; then :; else
    echo "⚠ RPM install failed. Alternative: sudo cp \"$D/extra/rpm/\"*.repo /etc/yum.repos.d/ && sudo dnf install plasma-applet-appgrid"
  fi
fi
if [ "$APPLY" = 1 ]; then
  if [ "$VARIANT" = light ]; then KV=XMacTahoe; LNF=XMacTahoe.Light; else KV=XMacTahoeDark; LNF=XMacTahoe.Dark; fi
  printf '[General]\ntheme=%s\n' "$KV" > "$HOME/.config/Kvantum/kvantum.kvconfig"
  rm -f "$HOME/.cache"/plasma_theme_XMacTahoe-*.kcache "$HOME/.cache/ksvg-elements" "$HOME/.cache/icon-cache.kcache"
  echo "→ Applying global theme $LNF ${LAYOUT:+(with panel layout)} ..."
  plasma-apply-lookandfeel -a "$LNF" $LAYOUT
  "$HOME/.local/bin/xmactahoe-sync-variant"
  echo "→ Restarting plasmashell ..."
  systemctl --user restart plasma-plasmashell.service 2>/dev/null || (kquitapp6 plasmashell; sleep 1; plasmashell --replace >/dev/null 2>&1 &)
  [ -n "$ACCENT" ] && "$D/extra/xmactahoe-accent" "$ACCENT"
  if [ -n "$WALL" ]; then plasma-apply-wallpaperimage "$LS/wallpapers/$WALL" >/dev/null 2>&1 || true; kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "$WALL"; fi
  echo "→ Rounded window corners (KWin effect) ..."
  [ "$ROUND" = 1 ] && "$D/extra/xmactahoe-round-corners"
  echo "→ AppGrid shortcuts (Meta = grid, Alt+Space = compact) ..."
  sleep 10; "$HOME/.local/bin/kde-desktop-repair" --no-backup || echo "⚠ run later: kde-desktop-repair"
fi
if [ "$ROOT" = 1 ]; then
  echo "→ Root steps (sudo): system-wide copy + login screen, Plymouth ..."
  sudo "$D/extra/xmactahoe-system-install" && sudo "$D/extra/xmactahoe-boot-install" || echo "⚠ root steps failed or were cancelled"
fi
echo "ℹ Root steps (or ./install.sh --root): sudo $D/extra/xmactahoe-system-install (all users + login screen), sudo $D/extra/xmactahoe-boot-install (Plymouth)."
echo "✓ Done. To switch variants: plasma-apply-lookandfeel -a XMacTahoe.Dark | XMacTahoe.Light"
