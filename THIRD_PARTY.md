# Third-party components

XMacTahoe assembles work from several projects; the package is an aggregate of separately licensed components. The scripts, the global themes (`XMacTahoe.Dark`, `XMacTahoe.Light`), the color schemes, the generated tray glyphs and the tools are GPL-3.0 (see `LICENSE`). Each bundled component keeps its own license, listed below; where a component carries a license file, it is shipped next to it.

| Component in this package | Origin | License | License text |
|---|---|---|---|
| `icons/XMacTahoe`, `XMacTahoe-Night`, `XMacTahoe-Day` | [MacTahoe icon theme](https://github.com/vinceliuice/MacTahoe-icon-theme), vinceliuice (commit 839848b9), modified | GPL-3.0 | `icons/*/COPYING` |
| `icons/XMacTahoe-cursors` | [WhiteSur cursors](https://github.com/vinceliuice/WhiteSur-cursors), vinceliuice | GPL-3.0 | `LICENSE` |
| `gtk/themes/MacTahoe-*`, `extra/firefox` | [MacTahoe GTK theme](https://github.com/vinceliuice/MacTahoe-gtk-theme), vinceliuice | MIT | `licenses/MIT-MacTahoe-gtk-theme.txt` |
| `Kvantum/XMacTahoe`, `plasma/desktoptheme/XMacTahoe-Light`, `wallpapers/XMacTahoe-Liuice`, `wallpapers/XMacTahoe-Dynamic` (frames generated from it) | [MacTahoe KDE theme](https://github.com/vinceliuice/MacTahoe-kde), vinceliuice, modified | LGPL-3.0 | `licenses/LGPL-3.0-MacTahoe-kde.txt` |
| `aurorae/themes/XMacTahoe*` | [MacSequoia KDE theme](https://github.com/vinceliuice/MacSequoia-kde), vinceliuice, modified | LGPL-3.0 | `licenses/LGPL-3.0-MacTahoe-kde.txt` (same text) |
| `plasma/desktoptheme/XMacTahoe-Dark`, `XMacTahoe.Splash` | Apple Tahoe / AppleDark-ALL / [Mkos Big Sur](https://github.com/zayronxio/Mkos-Big-Sur), zayronxio, modified | GPL-3.0 | `LICENSE` |
| `wallpapers/XMacTahoe` | zayronxio | CC BY-SA 4.0 ([deed](https://creativecommons.org/licenses/by-sa/4.0/)); adaptations must keep this license and credit zayronxio | — |
| `plasma/plasmoids/org.kpple.kppleMenu` | kppleMenu, zayronxio | GPL-2.0 | `licenses/GPL-2.0.txt` |
| `plasma/plasmoids/Plasma.Flex.Hub`, `zayron.simple.separator` | zayronxio, modified (Control Center layout) | GPL-3.0+ | `LICENSE` |
| `plasma/plasmoids/org.kde.windowtitle.Fork` | Window Title, Michail Vourlakos and zayronxio | GPL-2.0 | `plasma/plasmoids/org.kde.windowtitle.Fork/LICENSE` |
| `plasma/plasmoids/com.github.zren.commandoutput` | Command Output, Chris Holland (Zren) and contributors | GPL-2.0+ | `licenses/GPL-2.0.txt` |
| `fonts/Inter*` | [Inter](https://github.com/rsms/inter), The Inter Project Authors | SIL OFL 1.1 | `fonts/Inter-OFL.txt` |
| `fonts/JetBrainsMono-*` | [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono), The JetBrains Mono Project Authors | SIL OFL 1.1 | `fonts/JetBrainsMono-OFL.txt` |

## Installed from their own repositories, not redistributed

| Component | Source | License |
|---|---|---|
| AppGrid launcher (`plasma-applet-appgrid`) | COPR [`scujas/plasma-applet-appgrid`](https://copr.fedorainfracloud.org/coprs/scujas/plasma-applet-appgrid/) (source RPMs are published there) | GPL-3.0 |
| KDE Rounded Corners (`kwin-effect-roundcorners`) | COPR `matinlotfali/KDE-Rounded-Corners`, [source](https://github.com/matinlotfali/KDE-Rounded-Corners) | GPL-3.0 |
| Glass effect (`kwin-effects-glass`) | COPR `ama1470/kwin-effects-glass`, [source](https://github.com/4v3ngR/kwin-effects-glass) | GPL-3.0 |
| Kvantum | Fedora (`kvantum`) | GPL-3.0 |

## Trademarks

Apple, macOS and Tahoe are trademarks of Apple Inc. XMacTahoe is not affiliated with or endorsed by Apple. The package ships a neutral logo (a peak over a lake). `xmactahoe logo apple` downloads the Apple logo from the MacTahoe icon theme at run time for personal use; it is not part of this repository.
