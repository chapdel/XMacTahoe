#!/bin/bash
# Installs the "XMacTahoe" global theme (KDE Plasma 6).
# Usage: ./install.sh [--light] [--layout] [--no-apply] [--no-round-corners] [--accent NAME] [--wallpaper NAME]
#                     [--glass frosted|liquid|off] [--auto-appearance] [--root] [--update]
#   --light           apply the light variant (dark by default)
#   --layout          also reset the panel layout (top bar + dock)
#   --no-apply        only copy files (themes, icons, fonts, scripts); change no setting
#   --no-round-corners  do not install/enable the KWin rounded-corners effect
#   --accent NAME     blue|purple|pink|red|orange|yellow|green|graphite (extra/xmactahoe-accent)
#   --wallpaper NAME  XMacTahoe (default, zayronxio dynamic) or XMacTahoe-Liuice (vinceliuice day/night)
#   --glass MODE      frosted (KWin blur, light on the GPU), liquid (refraction + edge lighting, needs
#                     kwin-effects-glass, heavier) or off (opaque). Asked interactively when omitted.
#                     --no-glass = --glass off. Change later with: xmactahoe glass frosted|liquid|off
#   --auto-appearance light after sunrise, dark after sunset (systemd timer; extra/xmactahoe-auto-appearance)
#   --root            also run the root steps with sudo: system-wide copy + login screen, Plymouth boot theme
#   --update          download the latest GitHub release, verify it, and run its installer with the same options
# Shortcuts: Meta = AppGrid grid, Alt+Space = AppGrid compact mode (wired by extra/kde-desktop-repair)
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
REPO=chapdel/XMacTahoe
VARIANT=dark; LAYOUT=""; APPLY=1; ROUND=1; ACCENT=""; WALL=""; ROOT=0; GLASSMODE=""; AUTOAPP=0; UPDATE=0; prev=""
for a in "$@"; do
  case "$prev" in --accent) ACCENT="$a"; prev=""; continue;; --wallpaper) WALL="$a"; prev=""; continue;; --glass) GLASSMODE="$a"; prev=""; continue;; esac
  case "$a" in
    --accent|--wallpaper|--glass) prev="$a";; --root) ROOT=1;; --no-glass) GLASSMODE=off;; --auto-appearance) AUTOAPP=1;;
    --update) UPDATE=1;; --light) VARIANT=light;; --layout) LAYOUT="--resetLayout";; --no-apply) APPLY=0;; --no-round-corners) ROUND=0;;
    *) echo "unknown option: $a"; exit 1;;
  esac
done
LS="$HOME/.local/share"
FEDORA=0; command -v dnf >/dev/null 2>&1 && command -v rpm >/dev/null 2>&1 && FEDORA=1
[ "$FEDORA" = 1 ] || echo "⚠ Made for Fedora: package steps (Kvantum check, AppGrid, rounded corners, liquid glass) are skipped on this system."

# ---------------------------------------------------------------- update: download, verify, re-run
if [ "$UPDATE" = 1 ]; then
  CUR=$(cat "$D/VERSION" 2>/dev/null || echo 0)
  LATEST=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')
  [ -n "$LATEST" ] || { echo "⚠ cannot reach GitHub"; exit 1; }
  [ "$LATEST" != "$CUR" ] || { echo "✓ already up to date ($CUR)"; exit 0; }
  echo "→ Updating $CUR → $LATEST ..."
  T=$(mktemp -d); U="https://github.com/$REPO/releases/download/v$LATEST"
  curl -fsSL -o "$T/XMacTahoe-v$LATEST.tar.gz" "$U/XMacTahoe-v$LATEST.tar.gz"
  curl -fsSL -o "$T/SHA256SUMS" "$U/SHA256SUMS" || { echo "⚠ no SHA256SUMS in the release: refusing to install an unverified archive"; exit 1; }
  (cd "$T" && sha256sum -c --ignore-missing SHA256SUMS) || { echo "⚠ checksum mismatch: aborting"; exit 1; }
  if curl -fsSL -o "$T/x.asc" "$U/XMacTahoe-v$LATEST.tar.gz.asc" 2>/dev/null && command -v gpg >/dev/null; then
    gpg --verify "$T/x.asc" "$T/XMacTahoe-v$LATEST.tar.gz" 2>/dev/null && echo "✓ signature verified" || echo "⚠ signature present but not verifiable with your keyring (checksum OK)"
  fi
  tar -xzf "$T/XMacTahoe-v$LATEST.tar.gz" -C "$T"
  ARGS=(); for a in "$@"; do [ "$a" != --update ] && ARGS+=("$a"); done
  exec "$T/XMacTahoe/install.sh" ${ARGS[@]+"${ARGS[@]}"}
fi
[ -d "$D/icons" ] || { echo "This is the runtime copy of XMacTahoe (no themes inside). Use the full package, or: $D/install.sh --update"; exit 1; }

wait_plasma() { for _ in $(seq 1 40); do gdbus call --session --dest org.kde.plasmashell --object-path /PlasmaShell --method org.kde.PlasmaShell.evaluateScript 'print(1)' >/dev/null 2>&1 && return 0; sleep 1; done; echo "⚠ plasmashell did not answer"; }
ini_set() { # ini_set FILE KEY VALUE  (GTK settings.ini, [Settings] group)
  mkdir -p "$(dirname "$1")"; [ -f "$1" ] || printf '[Settings]\n' > "$1"
  if grep -q "^$2=" "$1"; then sed -i "s|^$2=.*|$2=$3|" "$1"; else echo "$2=$3" >> "$1"; fi; }

# ---------------------------------------------------------------- restore point (first install only)
RP="$LS/xmactahoe/restore"
if [ "$APPLY" = 1 ] && [ ! -d "$RP" ]; then
  mkdir -p "$RP"
  for f in kdeglobals kwinrc kwinrulesrc plasmarc plasmashellrc plasma-org.kde.plasma.desktop-appletsrc kscreenlockerrc plasmanotifyrc kglobalshortcutsrc konsolerc dolphinrc katerc kwriterc; do [ -f "$HOME/.config/$f" ] && cp "$HOME/.config/$f" "$RP/"; done
  for d in kdedefaults gtk-3.0 gtk-4.0 Kvantum; do [ -d "$HOME/.config/$d" ] && cp -r "$HOME/.config/$d" "$RP/"; done
  echo "→ Restore point saved in $RP"
fi

# ---------------------------------------------------------------- files (no setting changed)
echo "→ Copying components into ~/.local/share ..."
mkdir -p "$LS"/{plasma/desktoptheme,plasma/look-and-feel,plasma/plasmoids,color-schemes,icons,aurorae/themes,wallpapers,fonts,konsole,applications,kio/servicemenus,kwin/scripts,org.kde.syntax-highlighting/themes} \
         "$LS/icons/hicolor/scalable/apps" "$HOME/.config/Kvantum" "$HOME/.icons" "$HOME/.themes" "$HOME/.local/bin"
cp -a "$D"/plasma/desktoptheme/.  "$LS/plasma/desktoptheme/"
cp -a "$D"/plasma/look-and-feel/. "$LS/plasma/look-and-feel/"
cp -a "$D"/plasma/plasmoids/.     "$LS/plasma/plasmoids/"
cp -a "$D"/color-schemes/.        "$LS/color-schemes/"
cp -a "$D"/icons/.                "$LS/icons/"
ln -sfn "$LS/icons/XMacTahoe-cursors" "$HOME/.icons/XMacTahoe-cursors"
cp -a "$D"/aurorae/themes/.       "$LS/aurorae/themes/"
cp -a "$D"/wallpapers/.           "$LS/wallpapers/"
cp -a "$D"/fonts/.                "$LS/fonts/"
cp -a "$D"/Kvantum/.              "$HOME/.config/Kvantum/"
cp -a "$D"/gtk/themes/.           "$HOME/.themes/"
cp "$D"/extra/apps/macOS.profile "$D"/extra/apps/XMacTahoe.colorscheme "$D"/extra/apps/XMacTahoe-Light.colorscheme "$LS/konsole/"
cp "$D"/extra/apps/kate-themes/*.theme "$LS/org.kde.syntax-highlighting/themes/"
cp -a "$D"/extra/applications/.   "$LS/applications/"
cp "$D/extra/servicemenus/xmactahoe-quicklook.desktop" "$LS/kio/servicemenus/"; chmod +x "$LS/kio/servicemenus/xmactahoe-quicklook.desktop"
cp "$LS/icons/XMacTahoe-Night/apps/scalable/xmactahoe-transparent.svg" "$LS/icons/hicolor/scalable/apps/" 2>/dev/null || true
for k in "$D"/extra/kwin-scripts/*/; do n=$(basename "$k"); rm -rf "${LS:?}/kwin/scripts/$n"; cp -a "$k" "$LS/kwin/scripts/$n"; done
# the Control Center buttons call the xmactahoe command: point them at this user's ~/.local/bin
for f in "$LS"/plasma/look-and-feel/XMacTahoe.*/contents/layouts/*.js; do sed -i "s|@XMT_BIN@|$HOME/.local/bin|g" "$f"; done
# command and helpers
cp "$D/bin/xmactahoe" "$HOME/.local/bin/"
for s in "$D"/extra/xmactahoe-* "$D/extra/kde-desktop-repair"; do case "$s" in *.conf) ;; *) cp "$s" "$HOME/.local/bin/";; esac; done
chmod +x "$HOME/.local/bin/xmactahoe" "$HOME/.local/bin"/xmactahoe-* "$HOME/.local/bin/kde-desktop-repair"
# durable runtime copy used by the xmactahoe command (the folder you installed from may be temporary)
RT="$LS/xmactahoe/package"
if [ "$D" != "$RT" ]; then
  rm -rf "$RT"; mkdir -p "$RT/plasma" "$RT/wallpapers"
  cp -a "$D/install.sh" "$D/uninstall.sh" "$D/VERSION" "$D/bin" "$D/extra" "$D/Kvantum" "$RT/"
  cp -a "$D/plasma/desktoptheme" "$RT/plasma/"; cp -a "$D/wallpapers/XMacTahoe-Dynamic" "$RT/wallpapers/"
fi
mkdir -p "$HOME/.config/xmactahoe"; echo "$RT" > "$HOME/.config/xmactahoe/package-dir"
# the icons just copied carry the neutral logo: keep the user's earlier choice (xmactahoe logo apple)
if [ "$(cat "$HOME/.config/xmactahoe/logo" 2>/dev/null)" = apple ]; then "$HOME/.local/bin/xmactahoe-logo" apple --quiet || echo "⚠ could not fetch the Apple logo: run xmactahoe logo apple later"; fi
fc-cache -f >/dev/null 2>&1 || true
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true

# ---------------------------------------------------------------- system dependencies (Fedora)
if [ "$FEDORA" = 1 ]; then
  command -v kvantummanager >/dev/null 2>&1 || echo "⚠ Kvantum is missing: sudo dnf install kvantum"
  if [ "$APPLY" = 1 ] && ! rpm -q plasma-applet-appgrid >/dev/null 2>&1; then
    echo "→ AppGrid missing: installing it from its COPR (signed packages, sudo password required)"
    sudo dnf copr enable -y scujas/plasma-applet-appgrid && sudo dnf install -y plasma-applet-appgrid || echo "⚠ AppGrid not installed: the Meta and Alt+Space shortcuts need it"
  fi
fi

if [ "$APPLY" = 1 ]; then
  # -------------------------------------------------------------- settings
  [ -f "$HOME/.config/dolphinrc" ] || cp "$D/extra/apps/dolphinrc" "$HOME/.config/dolphinrc"
  kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile macOS.profile
  kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupTimeout 5000
  kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupPosition TopRight
  mkdir -p "$HOME/.config/environment.d"; cp "$D/extra/environment.d/xmactahoe.conf" "$HOME/.config/environment.d/"
  # apps with their own color scheme (Settings → Color Scheme) would ignore the theme: reset them
  for rc in dolphinrc konsolerc katerc kwriterc okularrc gwenviewrc arkrc spectaclerc systemsettingsrc; do kwriteconfig6 --file "$rc" --group UiSettings --key ColorScheme --delete 2>/dev/null || true; done
  kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
  kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image XMacTahoe
  # GTK: only the keys the theme needs (theme and icons are set by xmactahoe-sync-variant)
  for v in gtk-3.0 gtk-4.0; do
    ini_set "$HOME/.config/$v/settings.ini" gtk-cursor-theme-name XMacTahoe-cursors
    ini_set "$HOME/.config/$v/settings.ini" gtk-decoration-layout "close,maximize,minimize:"
  done
  mkdir -p "$HOME/.config/systemd/user"; cp "$D"/extra/systemd/xmactahoe-variant.* "$HOME/.config/systemd/user/"
  systemctl --user daemon-reload 2>/dev/null || true; systemctl --user enable --now xmactahoe-variant.path 2>/dev/null || true
  for k in "$D"/extra/kwin-scripts/*/; do kwriteconfig6 --file kwinrc --group Plugins --key "$(basename "$k")Enabled" true; done
  # Plasma's own light/dark pair (System Settings toggle and automatic switching)
  kwriteconfig6 --file kdeglobals --group KDE --key DefaultDarkLookAndFeel XMacTahoe.Dark
  kwriteconfig6 --file kdeglobals --group KDE --key DefaultLightLookAndFeel XMacTahoe.Light
  if [ "$VARIANT" = light ]; then KV=XMacTahoe; LNF=XMacTahoe.Light; else KV=XMacTahoeDark; LNF=XMacTahoe.Dark; fi
  printf '[General]\ntheme=%s\n' "$KV" > "$HOME/.config/Kvantum/kvantum.kvconfig"
  rm -f "$HOME/.cache"/plasma_theme_XMacTahoe-*.kcache "$HOME/.cache/ksvg-elements" "$HOME/.cache/icon-cache.kcache"
  # glass mode: frosted blur or liquid glass
  GLASS_SO=$(ls /usr/lib64/qt6/plugins/kwin/effects/plugins/glass.so /usr/lib/qt6/plugins/kwin/effects/plugins/glass.so /usr/lib/*/qt6/plugins/kwin/effects/plugins/glass.so 2>/dev/null | head -1)
  [ -n "$GLASSMODE" ] || GLASSMODE=$(cat "$HOME/.config/xmactahoe/glass" 2>/dev/null)   # re-installs and updates keep the chosen mode
  if [ -z "$GLASSMODE" ]; then
    if [ -t 0 ]; then
      echo; echo "Glass effect for the menu bar, dock, popups and translucent windows:"
      echo "  1) Frosted glass  KWin blur, light on the GPU (default)"
      echo "  2) Liquid glass   refraction + edge lighting, closer to macOS Tahoe (kwin-effects-glass, heavier)"
      echo "  3) Off            opaque, no blur"
      read -r -p "Choice [1]: " c; case "$c" in 2) GLASSMODE=liquid;; 3) GLASSMODE=off;; *) GLASSMODE=frosted;; esac
    else GLASSMODE=frosted; fi
  fi
  case "$GLASSMODE" in frosted|liquid|off) ;; *) echo "⚠ unknown glass mode '$GLASSMODE', using frosted"; GLASSMODE=frosted;; esac
  if [ "$GLASSMODE" = liquid ] && [ -z "$GLASS_SO" ]; then
    echo "→ Liquid glass needs kwin-effects-glass (COPR ama1470/kwin-effects-glass, sudo password required)"
    if [ "$FEDORA" = 1 ] && [ -t 0 ] && sudo dnf copr enable -y ama1470/kwin-effects-glass && sudo dnf install -y kwin-effects-glass; then :; else echo "⚠ not installed: using frosted glass"; GLASSMODE=frosted; fi
  fi
  echo "→ Applying global theme $LNF ${LAYOUT:+(with panel layout)} ..."
  plasma-apply-lookandfeel -a "$LNF" $LAYOUT
  "$HOME/.local/bin/xmactahoe-sync-variant"
  [ -n "$ACCENT" ] || ACCENT=$(cat "$HOME/.config/xmactahoe/accent" 2>/dev/null)   # re-installs and updates keep the chosen accent
  if [ -n "$ACCENT" ]; then "$HOME/.local/bin/xmactahoe-accent" "$ACCENT"; fi
  if [ "$AUTOAPP" = 1 ]; then cp "$D"/extra/systemd/xmactahoe-appearance.* "$HOME/.config/systemd/user/"; systemctl --user daemon-reload; systemctl --user enable --now xmactahoe-appearance.timer 2>/dev/null || true; "$HOME/.local/bin/xmactahoe-auto-appearance" --now; fi
  echo "→ Glass: $GLASSMODE ..."; XMT_NO_RESTART=1 "$HOME/.local/bin/xmactahoe-glass" "$GLASSMODE"
  echo "→ Restarting plasmashell ..."
  rm -f "$HOME/.cache"/plasma_theme_XMacTahoe-*.kcache "$HOME/.cache/ksvg-elements"
  systemctl --user restart plasma-plasmashell.service 2>/dev/null || { kquitapp6 plasmashell || true; sleep 1; (plasmashell --replace >/dev/null 2>&1 &); }
  wait_plasma
  if [ -n "$WALL" ]; then plasma-apply-wallpaperimage "$LS/wallpapers/$WALL" >/dev/null 2>&1 || true; kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "$WALL"; fi
  gdbus call --session --dest org.kde.KWin --object-path /KWin --method org.kde.KWin.reconfigure >/dev/null 2>&1 || true
  if [ "$ROUND" = 1 ] && [ "$FEDORA" = 1 ]; then echo "→ Rounded window corners (KWin effect) ..."; "$HOME/.local/bin/xmactahoe-round-corners" || true; fi
  echo "→ Firefox and Ghostty themes, Flatpak overrides, Control Center buttons, old title-bar rules ..."
  for s in firefox ghostty flatpak window-rules flexhub-controls; do "$HOME/.local/bin/xmactahoe-$s" >/dev/null 2>&1 || echo "⚠ xmactahoe-$s failed (run it again later)"; done
  echo "→ AppGrid shortcuts (Meta = grid, Alt+Space = compact) ..."
  wait_plasma; sleep 3; "$HOME/.local/bin/kde-desktop-repair" --no-backup || echo "⚠ run later: kde-desktop-repair"
fi
if [ "$ROOT" = 1 ]; then
  echo "→ Root steps (sudo): system-wide copy + login screen, Plymouth ..."
  { sudo "$D/extra/xmactahoe-system-install" && sudo "$RT/extra/xmactahoe-boot-install"; } || echo "⚠ root steps failed or were cancelled"
fi
echo "ℹ Root steps (or ./install.sh --root): sudo $D/extra/xmactahoe-system-install (all users + login screen), sudo $RT/extra/xmactahoe-boot-install (Plymouth, uses your logo choice)."
echo "✓ Done. Everyday commands: xmactahoe light|dark|accent|glass|dock|logo|motion|auto|dynamic|dnd|doctor|update|restore"
