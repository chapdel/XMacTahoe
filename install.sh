#!/bin/bash
# Installation du thème global "XMacTahoe" (KDE Plasma 6).
# Usage : ./install.sh [--light] [--layout] [--no-apply] [--no-round-corners]
# Raccourcis : Meta = grille AppGrid, Alt+Space = AppGrid compact (câblés par extra/kde-desktop-repair)
#   --light     applique la variante claire (sombre par défaut)
#   --layout    réinitialise aussi la disposition des panneaux (barre du haut + dock)
#   --no-apply  installe les fichiers sans changer le thème actif
#   --no-round-corners  ne pas installer/activer l'effet KWin de coins arrondis
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
VARIANT=dark; LAYOUT=""; APPLY=1; ROUND=1
for a in "$@"; do case "$a" in --light) VARIANT=light;; --layout) LAYOUT="--resetLayout";; --no-apply) APPLY=0;; --no-round-corners) ROUND=0;; esac; done
LS="$HOME/.local/share"
mkdir -p "$LS"/{plasma/desktoptheme,plasma/look-and-feel,plasma/plasmoids,color-schemes,icons,aurorae/themes,wallpapers,fonts} "$HOME/.config/Kvantum" "$HOME/.icons"
echo "→ Copie des composants dans ~/.local/share ..."
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
# thèmes GTK MacTahoe (GTK 2/3/4, libadwaita via xmactahoe-sync-variant)
mkdir -p "$HOME/.themes"; cp -a "$D"/gtk/themes/. "$HOME/.themes/"
# Dolphin façon Finder, Konsole façon Terminal.app (n'écrase pas une config Dolphin existante)
[ -f "$HOME/.config/dolphinrc" ] || cp "$D/extra/apps/dolphinrc" "$HOME/.config/dolphinrc"
mkdir -p "$HOME/.local/share/konsole"; cp "$D"/extra/apps/macOS.profile "$D"/extra/apps/XMacTahoe.colorscheme "$HOME/.local/share/konsole/"
kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile macOS.profile
# notifications façon macOS (haut droite, 5 s) ; dialogues KDE dans les applis GTK (effet à la prochaine session)
kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupTimeout 5000
kwriteconfig6 --file plasmanotifyrc --group Notifications --key PopupPosition TopRight
mkdir -p "$HOME/.config/environment.d"; cp "$D/extra/environment.d/xmactahoe.conf" "$HOME/.config/environment.d/"
# écran de verrouillage : fond XMacTahoe
kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image XMacTahoe
# lanceur AppGrid du dock (.desktop) + icône transparente de repli
mkdir -p "$LS/applications" "$LS/icons/hicolor/scalable/apps"
cp -a "$D"/extra/applications/. "$LS/applications/"
cp "$LS/icons/XMacTahoe-Night/128x128/apps/xmactahoe-transparent.svg" "$LS/icons/hicolor/scalable/apps/" 2>/dev/null || true
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
for v in gtk-3.0 gtk-4.0; do [ -f "$D/extra/gtk/$v-settings.ini" ] && { mkdir -p "$HOME/.config/$v"; cp "$D/extra/gtk/$v-settings.ini" "$HOME/.config/$v/settings.ini"; }; done
# script de réparation des raccourcis AppGrid / barre du haut
mkdir -p "$HOME/.local/bin"; cp "$D/extra/kde-desktop-repair" "$HOME/.local/bin/kde-desktop-repair"; chmod +x "$HOME/.local/bin/kde-desktop-repair"
# synchronisation Kvantum/GTK à chaque bascule clair/sombre (Flex Hub, plasma-apply-lookandfeel)
cp "$D/extra/xmactahoe-sync-variant" "$HOME/.local/bin/"; chmod +x "$HOME/.local/bin/xmactahoe-sync-variant"
mkdir -p "$HOME/.config/systemd/user"; cp "$D"/extra/systemd/xmactahoe-variant.* "$HOME/.config/systemd/user/"
systemctl --user daemon-reload 2>/dev/null; systemctl --user enable --now xmactahoe-variant.path 2>/dev/null || true
# dépendances système (non fournies dans ~/.local)
command -v kvantummanager >/dev/null 2>&1 || echo "⚠ Kvantum manquant : sudo dnf install kvantum"
if ! rpm -q plasma-applet-appgrid >/dev/null 2>&1; then
  RPM=$(ls "$D"/extra/rpm/plasma-applet-appgrid-*.x86_64.rpm 2>/dev/null | head -1)
  echo "→ AppGrid absent : installation du RPM embarqué (mot de passe sudo demandé)"
  if [ -n "$RPM" ] && sudo dnf install -y "$RPM"; then :; else
    echo "⚠ Installation RPM impossible. Alternative : sudo cp \"$D/extra/rpm/\"*.repo /etc/yum.repos.d/ && sudo dnf install plasma-applet-appgrid"
  fi
fi
if [ "$APPLY" = 1 ]; then
  if [ "$VARIANT" = light ]; then KV=XMacTahoe; LNF=XMacTahoe.Light; else KV=XMacTahoeDark; LNF=XMacTahoe.Dark; fi
  printf '[General]\ntheme=%s\n' "$KV" > "$HOME/.config/Kvantum/kvantum.kvconfig"
  rm -f "$HOME/.cache"/plasma_theme_XMacTahoe-*.kcache "$HOME/.cache/ksvg-elements" "$HOME/.cache/icon-cache.kcache"
  echo "→ Application du thème global $LNF ${LAYOUT:+(avec disposition des panneaux)} ..."
  plasma-apply-lookandfeel -a "$LNF" $LAYOUT
  "$HOME/.local/bin/xmactahoe-sync-variant"
  echo "→ Redémarrage de plasmashell ..."
  systemctl --user restart plasma-plasmashell.service 2>/dev/null || (kquitapp6 plasmashell; sleep 1; plasmashell --replace >/dev/null 2>&1 &)
  echo "→ Coins arrondis des fenêtres (effet KWin) ..."
  [ "$ROUND" = 1 ] && "$D/extra/xmactahoe-round-corners"
  echo "→ Raccourcis AppGrid (Meta = grille, Alt+Space = compact) ..."
  sleep 10; "$HOME/.local/bin/kde-desktop-repair" --no-backup || echo "⚠ relance plus tard : kde-desktop-repair"
fi
echo "ℹ Étapes root facultatives : sudo $D/extra/xmactahoe-boot-install (Plymouth) ; écran de connexion : Configuration du système → Écran de connexion (Plasma) → Appliquer les réglages de Plasma."
echo "✓ Terminé. Pour basculer : plasma-apply-lookandfeel -a XMacTahoe.Dark | XMacTahoe.Light"
