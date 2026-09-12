# XMacTahoe — thème global KDE Plasma 6 autonome

Tout ce qu'il faut pour retrouver mon bureau macOS-like d'un coup, sans dépendre du KDE Store.

## Installation
```bash
./install.sh            # installe tout et applique la variante sombre
./install.sh --layout   # idem + recrée la barre du haut et le dock (à faire sur une machine neuve)
./install.sh --light    # variante claire
```
Dépendances système (Fedora) : `kvantum` (dnf) ; `plasma-applet-appgrid` est fourni en RPM dans `extra/rpm/` et installé automatiquement par le script (dépôt COPR `scujas/plasma-applet-appgrid` joint).

## Raccourcis clavier (AppGrid, dans le dock)
| Touche | Action |
|---|---|
| `Meta` (Super) seul | grille complète des applications |
| `Alt+Space` | AppGrid en mode compact (recherche) |

Le widget AppGrid vit **invisible** (icône transparente) à l'extrémité droite de la barre du haut : placé dans le dock, chaque appui sur `Meta` faisait apparaître le dock. Le dock garde une icône « Applications » (`extra/applications/xmactahoe-appgrid.desktop`) qui ouvre la même grille.

Ils sont câblés par `extra/kde-desktop-repair`, copié dans `~/.local/bin`. Si un jour ils ne répondent plus (widget recréé, thème réappliqué) : `kde-desktop-repair` (ou `--check` pour diagnostiquer).

## Contenu
| Composant | Nom |
|---|---|
| Thèmes globaux | XMacTahoe.Dark / XMacTahoe.Light / XMacTahoe.Splash |
| Thèmes Plasma | XMacTahoe-Dark (AppleDark-ALL corrigé : barre solide sombre) / XMacTahoe-Light |
| Schémas de couleurs | XMacTahoeDark / XMacTahoeLight |
| Icônes | XMacTahoe-Night / XMacTahoe-Day (corbeille corrigée) |
| Curseur | XMacTahoe-cursors |
| Kvantum | XMacTahoeDark / XMacTahoe |
| Décorations (Aurorae) | XMacTahoe-Night / XMacTahoe |
| Fond d'écran | XMacTahoe (dynamique jour/nuit) |
| Widgets | kppleMenu, Window Title Fork, Flex Hub, Command Output, Simple Separator, AppGrid (RPM) |
| Polices | Inter Variable, JetBrains Mono |
| Extra | settings.ini GTK 3/4 |

Origine : Apple Tahoe (zayronxio), MacSequoia (vinceliuice), Mkos Big Sur (zayronxio). Licences GPL.

## Icônes de la barre de menus (style macOS Tahoe)
Les glyphes de la bandeau système (Wi-Fi, son, Bluetooth, batterie, luminosité, notifications, presse-papiers, mises à jour, Telegram) sont générés par `tools/gen-tray-icons.py` dans les dossiers `*/panel` des packs XMacTahoe-Night/Day et dans `icons/` des thèmes Plasma. Pour les régénérer après modification du script :
```bash
python3 tools/gen-tray-icons.py icons plasma/desktoptheme          # dans le paquet
python3 tools/gen-tray-icons.py ~/.local/share/icons ~/.local/share/plasma/desktoptheme   # installé
rm ~/.cache/icon-cache.kcache && systemctl --user restart plasma-plasmashell
```
