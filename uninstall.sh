#!/bin/bash
# Removes XMacTahoe from the user profile.
# Usage: ./uninstall.sh [--keep-files] [--restore]
#   (default)     back to Breeze Dark with a fresh Breeze panel layout, then remove every XMacTahoe file and setting
#   --restore     put back the Plasma configuration saved before the first install (panels included) instead of Breeze
#   --keep-files  change the settings but keep the theme files on disk
# System packages and root-installed parts are listed at the end, not removed.
set -uo pipefail
KEEP=0; RESTORE=0; for a in "$@"; do case "$a" in --keep-files) KEEP=1;; --restore) RESTORE=1;; *) echo "unknown option: $a"; exit 1;; esac; done
LS="$HOME/.local/share"; CFG="$HOME/.config"; RP="$LS/xmactahoe/restore"; BIN="$HOME/.local/bin"
PKG=$(cat "$CFG/xmactahoe/package-dir" 2>/dev/null); E="${PKG:+$PKG/extra}"; [ -d "${E:-/nonexistent}" ] || E="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/extra"
if [ "$RESTORE" = 1 ]; then
  if [ ! -d "$RP" ]; then echo "⚠ no restore point in $RP: falling back to Breeze"; RESTORE=0
  elif grep -qs XMacTahoe "$RP/kdedefaults/package"; then echo "⚠ the restore point was taken while XMacTahoe was already active: falling back to Breeze"; RESTORE=0; fi
fi
k() { kwriteconfig6 "$@" 2>/dev/null || true; }
fx() { gdbus call --session --dest org.kde.KWin --object-path /Effects --method "org.kde.kwin.Effects.$1" "$2" >/dev/null 2>&1 || true; }

echo "→ Resetting applications and effects ..."
# apps: Ghostty block, Firefox theme, Flatpak overrides, Kate/Konsole colors, Chrome hint
[ -x "$BIN/xmactahoe-ghostty" ] && "$BIN/xmactahoe-ghostty" --remove >/dev/null 2>&1
rm -f "$CFG"/ghostty/themes/XMacTahoe*
for base in "$CFG/mozilla/firefox" "$HOME/.mozilla/firefox" "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"; do
  for p in "$base"/*.default*; do [ -d "$p" ] || continue
    if [ -e "$p/chrome/.xmactahoe" ] || [ -d "$p/chrome/MacTahoe" ]; then rm -rf "${p:?}/chrome"; fi
    [ -d "$p/chrome.xmactahoe.bak" ] && mv "$p/chrome.xmactahoe.bak" "$p/chrome"
    [ -f "$p/user.js" ] && sed -i -e '/\/\/ XMacTahoe$/d' -e '/"toolkit.legacyUserProfileCustomizations.stylesheets", true);$/d' "$p/user.js"
  done
done
command -v flatpak >/dev/null && flatpak override --user --unset-env=GTK_THEME --unset-env=XCURSOR_THEME --nofilesystem=xdg-config/gtk-3.0 --nofilesystem=xdg-config/gtk-4.0 --nofilesystem="$HOME/.themes" --nofilesystem="$HOME/.local/share/icons" --nofilesystem="$HOME/.icons" 2>/dev/null
for rc in katerc kwriterc; do k --file "$rc" --group "KTextEditor Renderer" --key "Color Theme" --delete; k --file "$rc" --group "KTextEditor Renderer" --key "Auto Color Theme Selection" true; done
[ -f "$LS/konsole/macOS.profile" ] && sed -i 's/^ColorScheme=XMacTahoe.*/ColorScheme=Breeze/' "$LS/konsole/macOS.profile"
[ "$(kreadconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile 2>/dev/null)" = macOS.profile ] && k --file konsolerc --group "Desktop Entry" --key DefaultProfile --delete
# KWin: stock blur back, theme effects and scripts off, theme settings removed
k --file kwinrc --group Plugins --key glassEnabled false; k --file kwinrc --group Plugins --key blurEnabled true; k --file kwinrc --group Plugins --key contrastEnabled true
k --file kwinrc --group Plugins --key kwin4_effect_shapecornersEnabled false; k --file kwinrc --group Plugins --key diminactiveEnabled false
for s in "$LS"/kwin/scripts/xmactahoe-*; do [ -d "$s" ] && k --file kwinrc --group Plugins --key "$(basename "$s")Enabled" --delete; done
k --file kwinrc --group Plugins --key magiclampEnabled --delete; k --file kwinrc --group ElectricBorders --key TopRight --delete
fx unloadEffect glass; fx unloadEffect kwin4_effect_shapecorners; fx loadEffect blur
python3 - "$CFG/kwinrc" <<'PY'
import re, sys
p = sys.argv[1]
try: s = open(p).read()
except OSError: raise SystemExit
s = re.sub(r'(?ms)^\[(Effect-blurplus|Effect-diminactive|Round-Corners|Script-xmactahoe-[a-z]+)\]\n.*?(?=^\[|\Z)', '', s)
open(p, 'w').write(s)
PY
[ -x "$BIN/xmactahoe-window-rules" ] && "$BIN/xmactahoe-window-rules" >/dev/null 2>&1
k --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image --delete
k --file plasmanotifyrc --group Notifications --key PopupTimeout --delete; k --file plasmanotifyrc --group Notifications --key PopupPosition --delete
k --file plasmanotifyrc --group DoNotDisturb --key Until --delete
# user services
for u in $(systemctl --user list-unit-files --no-legend 'xmactahoe-*' 2>/dev/null | awk '{print $1}'); do systemctl --user disable --now "$u" >/dev/null 2>&1; done
rm -f "$CFG/systemd/user"/xmactahoe-*; systemctl --user daemon-reload 2>/dev/null
rm -f "$CFG/environment.d/xmactahoe.conf"

if [ "$RESTORE" = 1 ]; then
  echo "→ Restoring the pre-install Plasma configuration from $RP ..."
  systemctl --user stop plasma-plasmashell.service 2>/dev/null   # otherwise plasmashell rewrites the panel file on exit
  for f in "$RP"/*; do n=$(basename "$f"); if [ -d "$f" ]; then rm -rf "${CFG:?}/$n"; cp -r "$f" "$CFG/$n"; else cp "$f" "$CFG/$n"; fi; done
  # no plasma-apply-lookandfeel here: it would overwrite the restored colors and icons with the package defaults
  for t in 0 2; do dbus-send --session --type=signal /KGlobalSettings org.kde.KGlobalSettings.notifyChange int32:$t int32:0 2>/dev/null; done
else
  echo "→ Back to Breeze Dark with a fresh panel layout ..."
  plasma-apply-lookandfeel -a org.kde.breezedark.desktop --resetLayout >/dev/null 2>&1
  [ -d "$CFG/Kvantum" ] && printf '[General]\ntheme=KvArcDark\n' > "$CFG/Kvantum/kvantum.kvconfig"
  k --file kdeglobals --group KDE --key widgetStyle Breeze
  for v in Dark Light; do [ "$(kreadconfig6 --file kdeglobals --group KDE --key "Default${v}LookAndFeel" 2>/dev/null)" = "XMacTahoe.$v" ] && k --file kdeglobals --group KDE --key "Default${v}LookAndFeel" --delete; done
  for v in gtk-3.0 gtk-4.0; do f="$CFG/$v/settings.ini"; [ -f "$f" ] && sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Breeze/; s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=breeze-dark/; s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=breeze_cursors/' "$f"; done
  rm -f "$CFG/gtk-4.0/gtk.css" "$CFG/gtk-4.0/gtk-dark.css"; rm -rf "$CFG/gtk-4.0/assets" "$CFG/gtk-4.0/windows-assets"
  gsettings set org.gnome.desktop.interface gtk-theme Breeze 2>/dev/null; gsettings set org.gnome.desktop.interface icon-theme breeze-dark 2>/dev/null
fi
gdbus call --session --dest org.kde.KWin --object-path /KWin --method org.kde.KWin.reconfigure >/dev/null 2>&1

rm -f "$BIN"/xmactahoe "$BIN"/xmactahoe-* "$BIN/kde-desktop-repair" "$LS/applications/xmactahoe-appgrid.desktop" "$LS/kio/servicemenus/xmactahoe-quicklook.desktop"
if [ "$KEEP" = 0 ]; then
  echo "→ Removing files ..."
  rm -rf "$LS"/plasma/look-and-feel/XMacTahoe.* "$LS"/plasma/desktoptheme/XMacTahoe-* "$LS"/color-schemes/XMacTahoe*.colors \
         "$LS"/icons/XMacTahoe "$LS"/icons/XMacTahoe-Night "$LS"/icons/XMacTahoe-Day "$LS"/icons/XMacTahoe-cursors "$HOME/.icons/XMacTahoe-cursors" \
         "$LS"/aurorae/themes/XMacTahoe "$LS"/aurorae/themes/XMacTahoe-Night "$LS"/wallpapers/XMacTahoe "$LS"/wallpapers/XMacTahoe-Liuice "$LS"/wallpapers/XMacTahoe-Dynamic \
         "$CFG/Kvantum/XMacTahoe" "$HOME/.themes/MacTahoe-Dark" "$HOME/.themes/MacTahoe-Light" "$LS"/konsole/XMacTahoe*.colorscheme \
         "$LS"/org.kde.syntax-highlighting/themes/XMacTahoe-*.theme "$LS/konsole/macOS.profile" "$LS"/icons/hicolor/scalable/apps/xmactahoe-transparent.svg \
         "$LS"/kwin/scripts/xmactahoe-* "$LS/xmactahoe/package"
  [ "$RESTORE" = 1 ] || for p in org.kpple.kppleMenu org.kde.windowtitle.Fork Plasma.Flex.Hub com.github.zren.commandoutput zayron.simple.separator; do rm -rf "${LS:?}/plasma/plasmoids/$p"; done
  rm -f "$HOME/.cache"/plasma_theme_XMacTahoe-*.kcache "$HOME/.cache/icon-cache.kcache"
  find "$CFG/xmactahoe" -mindepth 1 ! -name location -delete 2>/dev/null; rmdir "$CFG/xmactahoe" 2>/dev/null   # state files; your location stays
fi
echo "→ Restarting plasmashell ..."; systemctl --user restart plasma-plasmashell.service 2>/dev/null || systemctl --user start plasma-plasmashell.service 2>/dev/null
echo "✓ XMacTahoe removed$( [ "$RESTORE" = 1 ] && echo ', previous configuration restored (log out and back in so every app picks it up)'). Left in place on purpose:"
echo "   - fonts Inter and JetBrains Mono (~/.local/share/fonts), the restore point (~/.local/share/xmactahoe/restore)"
echo "   - system packages: sudo dnf remove kwin-effect-roundcorners kwin-effects-glass plasma-applet-appgrid"
echo "   - root parts, if you ran them: sudo plymouth-set-default-theme -R bgrt ; sudo rm -rf /usr/share/plasma/look-and-feel/XMacTahoe.* /etc/plasmalogin.conf.d/xmactahoe.conf"
echo "   - Chrome: chrome://settings/appearance → Theme \"Classic\" if you switched it to GTK"
