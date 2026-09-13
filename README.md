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

## Coins arrondis des fenêtres (façon Tahoe)
Plasma n'arrondit nativement que le haut des fenêtres. Le paquet installe et configure l'effet KWin **KDE Rounded Corners** (matinlotfali, COPR `matinlotfali/KDE-Rounded-Corners`, paquet `kwin-effect-roundcorners`) : rayon 18 px sur toutes les fenêtres, y compris maximisées, contour blanc discret, pas d'arrondi en plein écran. Réglages dans `extra/kwinrc-round-corners.conf`, appliqués par `extra/xmactahoe-round-corners` (relançable seul). `./install.sh --no-round-corners` pour s'en passer. Interface graphique : Configuration du système → Effets de bureau → Rounded Corners.

## Bascule clair / sombre
Le bouton clair/sombre du widget Flex Hub (ou `plasma-apply-lookandfeel -a XMacTahoe.Light|Dark`) change le thème global. Comme Plasma ne pilote pas Kvantum, `extra/xmactahoe-sync-variant` (déclenché par l'unité systemd utilisateur `xmactahoe-variant.path`) aligne aussitôt Kvantum et GTK sur la variante active. Les applications Qt déjà ouvertes (Dolphin, Spectacle...) prennent le nouveau style à leur prochain lancement.


## Depuis la v1.2.0 : plus de Tahoe
- **Icônes MacTahoe** (vinceliuice) sous les noms XMacTahoe (base), XMacTahoe-Night, XMacTahoe-Day, avec les glyphes de barre régénérés dans leur disposition `status/*`.
- **Thème GTK MacTahoe** (Dark/Light) installé dans `~/.themes`, libadwaita compris (copie dans `~/.config/gtk-4.0`), suivi par la bascule clair/sombre.
- **Verre** : barre du haut, dock et popups translucides (fond #1c1c1e à 58 %) avec flou et contraste KWin ; panneaux en mode « translucide » (v1.2.1). Fenêtres Qt translucides via Kvantum (`translucent_windows`, flou), GTK et Electron restent opaques.
- **Ombres** de fenêtres plus larges et douces (paddings Aurorae).
- **Animations KWin** : lampe magique à la réduction, aperçu en haut à gauche, bureau en haut à droite (`extra/kwinrc-effects.conf`).
- **Dolphin** façon Finder (`extra/apps/dolphinrc`, copié seulement s'il n'y a pas de config), **Konsole** avec profil macOS et palette `XMacTahoe` façon Terminal.app.
- **Écran de verrouillage** sur le fond dynamique XMacTahoe. Le thème SDDM (écran de connexion) reste à installer en root depuis le KDE Store (« Apple Tahoe SDDM »).

## Contenu
| Composant | Nom |
|---|---|
| Thèmes globaux | XMacTahoe.Dark / XMacTahoe.Light / XMacTahoe.Splash |
| Thèmes Plasma | XMacTahoe-Dark (AppleDark-ALL corrigé : barre solide sombre) / XMacTahoe-Light |
| Schémas de couleurs | XMacTahoeDark / XMacTahoeLight |
| Icônes | XMacTahoe (base MacTahoe), XMacTahoe-Night / XMacTahoe-Day (corbeille du dock : icône colorée liée sur la symbolique) |
| Curseur | XMacTahoe-cursors |
| Kvantum | XMacTahoeDark / XMacTahoe |
| Décorations (Aurorae) | XMacTahoe-Night / XMacTahoe |
| Fond d'écran | XMacTahoe (dynamique jour/nuit) |
| Widgets | kppleMenu, Window Title Fork, Flex Hub, Command Output, Simple Separator, AppGrid (RPM) |
| Polices | Inter Variable, JetBrains Mono |
| GTK | MacTahoe-Dark / MacTahoe-Light + settings.ini GTK 3/4 |

Origine : Apple Tahoe (zayronxio), MacSequoia (vinceliuice), Mkos Big Sur (zayronxio). Licences GPL.

## Icônes de la barre de menus (style macOS Tahoe)
Les glyphes de la bandeau système (Wi-Fi, son, Bluetooth, batterie, luminosité, notifications, presse-papiers, mises à jour, Telegram) sont générés par `tools/gen-tray-icons.py` dans les dossiers `*/panel` des packs XMacTahoe-Night/Day et dans `icons/` des thèmes Plasma. Pour les régénérer après modification du script :
```bash
python3 tools/gen-tray-icons.py icons plasma/desktoptheme          # dans le paquet
python3 tools/gen-tray-icons.py ~/.local/share/icons ~/.local/share/plasma/desktoptheme   # installé
rm ~/.cache/icon-cache.kcache && systemctl --user restart plasma-plasmashell
```
