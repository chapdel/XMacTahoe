#!/bin/bash
# Removes XMacTahoe from the user profile and returns to Breeze Dark.
# Usage: ./uninstall.sh [--keep-files] [--restore]
#   --keep-files  only reset the active theme
#   --restore     put back the Plasma config saved before the first install, then remove the files
set -uo pipefail
KEEP=0; RESTORE=0; for a in "$@"; do [ "$a" = --keep-files ] && KEEP=1; [ "$a" = --restore ] && RESTORE=1; done
LS="$HOME/.local/share"
RP="$LS/xmactahoe/restore"
if [ "$RESTORE" = 1 ] && [ -d "$RP" ]; then
  echo "→ Restoring the pre-install Plasma config from $RP ..."
  for f in "$RP"/*; do n=$(basename "$f"); [ -d "$f" ] && { rm -rf "$HOME/.config/$n"; cp -r "$f" "$HOME/.config/$n"; } || cp "$f" "$HOME/.config/$n"; done
  P=$(cat "$HOME/.config/kdedefaults/package" 2>/dev/null); [ -n "$P" ] && plasma-apply-lookandfeel -a "$P" >/dev/null 2>&1
fi
echo "→ Back to Breeze Dark ..."
[ "$RESTORE" = 1 ] || plasma-apply-lookandfeel -a org.kde.breezedark.desktop >/dev/null 2>&1
printf '[General]\ntheme=KvArcDark\n' > "$HOME/.config/Kvantum/kvantum.kvconfig" 2>/dev/null
kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle Breeze
for v in gtk-3.0 gtk-4.0; do f="$HOME/.config/$v/settings.ini"; [ -f "$f" ] && sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Breeze/; s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=breeze-dark/; s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=breeze_cursors/' "$f"; done
rm -f "$HOME/.config/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk-dark.css"; rm -rf "$HOME/.config/gtk-4.0/assets" "$HOME/.config/gtk-4.0/windows-assets"
gsettings set org.gnome.desktop.interface gtk-theme Breeze 2>/dev/null; gsettings set org.gnome.desktop.interface icon-theme breeze-dark 2>/dev/null
# KWin: rounded corners off, panels back to adaptive handled by the Breeze layout
kwriteconfig6 --file kwinrc --group Plugins --key kwin4_effect_shapecornersEnabled false
gdbus call --session --dest org.kde.KWin --object-path /Effects --method org.kde.kwin.Effects.unloadEffect kwin4_effect_shapecorners >/dev/null 2>&1
kwriteconfig6 --file kwinrc --group Plugins --key magiclampEnabled --delete
kwriteconfig6 --file kwinrc --group ElectricBorders --key TopRight --delete
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image --delete
kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupTimeout --delete
kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupPosition --delete
kwriteconfig6 --file kwinrc --group Plugins --key xmactahoe-attentionEnabled --delete; rm -rf "$LS/kwin/scripts/xmactahoe-attention"
gdbus call --session --dest org.kde.KWin --object-path /KWin --method org.kde.KWin.reconfigure >/dev/null 2>&1
# user services and helpers
for u in xmactahoe-variant.path xmactahoe-appearance.timer xmactahoe-wallpaper.timer; do systemctl --user disable --now $u 2>/dev/null; done; rm -f "$HOME/.config/systemd/user/xmactahoe-"*; systemctl --user daemon-reload 2>/dev/null
rm -f "$HOME/.local/bin"/xmactahoe* "$HOME/.config/environment.d/xmactahoe.conf" "$HOME/.local/bin/xmactahoe-sync-variant" "$HOME/.local/bin/xmactahoe-round-corners" "$HOME/.local/bin/kde-desktop-repair" "$LS/applications/xmactahoe-appgrid.desktop"
if [ "$KEEP" = 0 ]; then
  echo "→ Removing files ..."
  rm -rf "$LS"/plasma/look-and-feel/XMacTahoe.* "$LS"/plasma/desktoptheme/XMacTahoe-* "$LS"/color-schemes/XMacTahoe*.colors \
         "$LS"/icons/XMacTahoe "$LS"/icons/XMacTahoe-Night "$LS"/icons/XMacTahoe-Day "$LS"/icons/XMacTahoe-cursors "$HOME/.icons/XMacTahoe-cursors" \
         "$LS"/aurorae/themes/XMacTahoe "$LS"/aurorae/themes/XMacTahoe-Night "$LS"/wallpapers/XMacTahoe "$LS"/wallpapers/XMacTahoe-Liuice \
         "$HOME/.config/Kvantum/XMacTahoe" "$HOME/.themes/MacTahoe-Dark" "$HOME/.themes/MacTahoe-Light" "$LS"/konsole/XMacTahoe.colorscheme \
         "$LS"/icons/hicolor/scalable/apps/xmactahoe-transparent.svg
  for p in org.kpple.kppleMenu org.kde.windowtitle.Fork Plasma.Flex.Hub com.github.zren.commandoutput zayron.simple.separator; do rm -rf "$LS/plasma/plasmoids/$p"; done
  rm -f "$HOME/.cache"/plasma_theme_XMacTahoe-*.kcache "$HOME/.cache/icon-cache.kcache"
fi
echo "→ Restarting plasmashell ..."; systemctl --user restart plasma-plasmashell.service 2>/dev/null
echo "✓ XMacTahoe removed. System packages (kvantum, plasma-applet-appgrid, kwin-effect-roundcorners) and root-installed parts (Plymouth, /usr/share copies) are left in place:"
echo "   sudo dnf remove kwin-effect-roundcorners plasma-applet-appgrid ; sudo plymouth-set-default-theme -R bgrt ; sudo rm -rf /usr/share/plasma/look-and-feel/XMacTahoe.* ..."
