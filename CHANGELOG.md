## 2.1.1 — 2026-09-26

Control Center readable in both variants, a tidier system tray, and panel rebuilding.

- **Control Center**: the card colour is fixed to white no longer. It follows the variant (white on dark, a light shade of black on light), applied on every light/dark switch, so the light variant stays readable. The coloured tiles take the Plasma accent, which `xmactahoe accent NAME` sets.
- **System tray**: the packaged layout ships a macOS-like set of items and disables Vaults, Weather, KDE Connect and the display-configuration widget, which kept the "Status and Notifications" popup long. Tray icons in the bar are unaffected.
- **`xmactahoe panels swap OLD NEW`** rebuilds the panels with one widget replaced, keeping every setting, live and without restarting plasmashell.
- `xmactahoe dock status` no longer repeats itself once there is a dock per screen.

## 2.1.0 — 2026-09-26

Menu bar and dock on every screen, and a screen plugged in later gets them by itself.

- **Every screen gets its own bar and dock.** Plasma pins a panel to one screen and cannot duplicate or move it, so a second screen used to stay bare. `install.sh --layout` now creates the panels on every connected screen.
- **Hotplug is handled with no command to type.** The new user unit `xmactahoe-panels.path` watches KWin's output configuration: a screen plugged in gets its bar and dock a few seconds later. Unplugging needs nothing — Plasma keeps the panels and brings them back with the screen; a panel it pushed onto another screen meanwhile is moved back instead of a new one being created.
- **`xmactahoe panels`** lists the panels of each screen, and `xmactahoe panels clone` copies them by hand. The copy is made live, without restarting plasmashell, and carries every widget setting (checked key by key), minus the AppGrid widget and any global shortcut, which belong to a single widget.
- `xmactahoe doctor` checks the hotplug unit and reports a screen without panels; `--fix` copies them.
- `kde-desktop-repair` now checks the top bar of every screen, not just the first one.

Upgrading: `xmactahoe update`, then `xmactahoe panels clone` once for the screens that have none (or just plug a screen back in).

## 2.0.0 — 2026-09-22

Audit release: safer install, update and uninstall, clean licensing.

- **Neutral logo by default.** The menu bar, splash and boot screen now show a neutral glyph (a peak over a lake) instead of the Apple logo, a trademark. `xmactahoe logo apple` downloads the Apple logo on your machine for personal use; updates keep your choice.
- **Verified updates.** `xmactahoe update` checks the archive against the release's `SHA256SUMS` (and a GPG signature when one is published) and refuses an unverified archive. AppGrid now comes from its COPR (`scujas/plasma-applet-appgrid`) instead of a bundled RPM.
- **Durable package copy.** The installer keeps what the helpers need in `~/.local/share/xmactahoe/package`, so `glass`, `accent`, `dynamic`, `doctor --fix` and `update` keep working after the extracted folder (or the `/tmp` folder of an update) is gone.
- **Uninstall that leaves nothing broken.** Breeze Dark with a fresh panel layout (no more panels pointing at removed widgets), stock blur back on, and removal of the KWin effects and scripts, every user timer, the Ghostty block, the Firefox theme (your own `chrome/` folder is put back), Flatpak overrides, Kate/KWrite and Konsole choices, Quick Look and the dock launcher. `--restore` puts back the saved configuration without overwriting it, and falls back to Breeze when the restore point was taken with XMacTahoe already active.
- **No hidden changes.** `--no-apply` only copies files. GTK `settings.ini` is edited key by key instead of being replaced. Plasma's own light/dark pair now points at XMacTahoe.
- **Control Center buttons** no longer carry the maintainer's home path; existing installs are repaired.
- **Auto appearance**: fixed a crash when reading `kwinrc` (keys such as `InputMethod[$d]`), which also affected the dynamic wallpaper; a sunrise or sunset missed during sleep is now caught up; `doctor` warns when no location is set.
- **Accent and glass** no longer undo each other: the accent is remembered and re-applied, and stays opaque with glass off.
- Re-installs keep your glass mode and accent without asking again. The installer waits for plasmashell before the steps that need it.
- Licenses: `THIRD_PARTY.md`, SIL OFL texts for Inter and JetBrains Mono, MIT/LGPL/GPL-2.0 texts for the bundled components.
- Tooling: shellcheck on every bash script in CI (a warning fails the build), the package checker finds scripts by shebang and rejects personal paths and bundled binaries, `tools/release.sh` refuses to reuse a published tag. `kde-desktop-repair` speaks English and `doctor` uses its exit code. Quick Look opens DjVu in Okular. Fewer Fedora-only paths.

Upgrading: `xmactahoe update`. If you want the Apple logo back: `xmactahoe logo apple`.

## 1.9.3 — 2026-09-22

- **Dock no longer stays stuck on screen** when an app requests attention (Telegram with unread messages, a finished download...). Plasma kept the auto-hidden dock visible until that app was opened; the new `xmactahoe-attention` KWin script shows it for about 5 seconds and lets it hide again, like the macOS bounce. Unread badges stay on the icons. Delay: `kwinrc [Script-xmactahoe-attention] RevealSeconds`.
- `xmactahoe doctor` checks the script is loaded.

Upgrading: `xmactahoe update`.

## 1.9.2 — 2026-09-21

- **Dock**: auto-hides like macOS ("Automatically hide and show the Dock"): it appears when the pointer touches the bottom edge. The previous "dodge windows" mode kept it on screen whenever no window overlapped it, which looked like a frozen dock. `xmactahoe dock autohide|dodge|always` switches.
- Fix: the packaged layout had been exported while the dock was temporarily forced visible, so fresh installs got a permanent dock; `tools/export-layout.py` now pins the intended modes.

Upgrading: `xmactahoe update`, or just `xmactahoe dock autohide`.

## 1.9.1 — 2026-09-21

- **Ghostty** now matches the other windows: the theme's title bar with the traffic lights, tabs only when there are several, the XMacTahoe Terminal.app-like light/dark palettes (auto), JetBrains Mono and an opaque background. `xmactahoe ghostty` (run by the installer) manages a block in the Ghostty config; conflicting lines are commented out and `--remove` restores them.

Upgrading: `xmactahoe update`.

## 1.9.0 — 2026-09-21

- **Liquid glass**: the installer now asks which glass to use (or `--glass frosted|liquid|off`), and `xmactahoe glass frosted|liquid|off` switches at any time. Liquid uses the Glass KWin effect (COPR `ama1470/kwin-effects-glass`, installed on request): Snell-style refraction on the edges, edge lighting, clearer and more saturated glass, closer to macOS Tahoe. Frosted (KWin blur) stays the default, light on the GPU.
- Fix: the Control Center **Glass** button toggled to a fully opaque bar and dock; it now toggles between off and the last glass mode.
- `xmactahoe doctor` checks that the loaded effect matches the chosen glass mode.

Upgrading: `xmactahoe update`.

## 1.8.5 — 2026-09-21

- Fix: black text on a dark background in Dolphin. Dolphin had its own light color scheme (Settings → Color Scheme, here KvFlatLight), which overrides the theme; the packaged Dolphin defaults carried it too. The installer now resets per-app color schemes of KDE apps, and `xmactahoe doctor --fix` detects them.

Upgrading: `xmactahoe update`.

## 1.8.4 — 2026-09-21

- `xmactahoe chrome`: a Chrome profile signed in to a Google account restores its theme from sync at startup, overwriting a Preferences edit. The command now detects it and tells you to pick the **GTK** theme in `chrome://settings/appearance` instead; the automatic edit is kept for profiles that are not signed in.

Upgrading: `xmactahoe update`.

## 1.8.3 — 2026-09-21

- `xmactahoe chrome`: switches Google Chrome to its GTK theme mode, so the tab strip shows the MacTahoe traffic lights (colored when active, grey in the background) and Chrome follows the light/dark variant. Quit Chrome with Ctrl+Shift+Q first; it is relaunched with the session restored. `--classic` reverts.

Upgrading: `xmactahoe update`.

## 1.8.2 — 2026-09-21

- Fix: double title bar on Chrome (and other apps that draw their own). The KWin rules added in 1.6.0 forced the theme's title bar on top of Chrome's tab strip. They are now removed by the installer, `xmactahoe rules` and `xmactahoe doctor --fix`; every app picks its own title bar again.
- Tip: Chrome → Settings → Appearance → Theme "GTK" gives MacTahoe-style buttons in the tab strip.

Upgrading: `xmactahoe update`.

## 1.8.1 — 2026-09-13

- Window decorations now based on MacSequoia (vinceliuice): the previous Mkos-based decoration drew a 34 px solid grey plate inside its shadow area, visible as a wide border around floating windows on light backgrounds.
- Control center: Tahoe-style pill sliders (white, no handle) and state pills behind toggle icons (blue when active).

Upgrading: `xmactahoe update`.

## 1.8.0 — 2026-09-13

- Control center (Flex Hub) laid out like macOS Tahoe: connectivity card, Focus, Appearance/Screenshot, brightness, sound, Now Playing, toggles row with labels; night light toggle named Night Shift.
- Softer KWin contrast (0.5 intensity, natural saturation) and lighter popups (42 %) so the glass reads as glass.

Upgrading: `xmactahoe update`.

## 1.7.0 — 2026-09-13

- Kate and KWrite now follow the light/dark switch (Xcode-like XMacTahoe themes).
- Do Not Disturb, macOS Focus-like: `xmactahoe dnd on 18:00`, `off`, `schedule 22:00-07:00` (user systemd timer), `status`.
- `tools/release.sh`: builds the archive, `SHA256SUMS` and an optional detached GPG signature (`--sign`); `CHANGELOG.md` split from the README. Checksums also attached to v1.6.0.

Install: see v1.0.0. Upgrading: `xmactahoe update`.

# Changelog

## 1.6.0

- `xmactahoe` command and `doctor`, restore point + `--restore`, Flex Hub quick controls, Firefox MacTahoe theme, Flatpak overrides, KWin rules for Electron apps, eight-slot dynamic wallpaper, reduce-motion toggle, GitHub Pages site and issue templates.

## 1.5.0

- real previews and light/dark GIF, `--update`, automatic appearance timer, Quick Look service menu, redesigned splash, Konsole light palette + Kate Xcode-like themes, `--no-glass` / `xmactahoe-glass`.

## 1.4.0

- uninstaller, package checker + CI, light variant parity (glass, fixed SVG stylesheets, Kvantum 30 %), single-screen layout export, accent colors, alternative Tahoe wallpaper, dock separator/highlight, system-wide + login screen root installer.

## 1.3.0

- nearly transparent top bar, Apple menu wired for Wayland, glass control center, macOS-style notifications, WhiteSur cursors, KDE dialogs in GTK apps, Tahoe lock screen, Plymouth theme.

## 1.2.x

- MacTahoe icons and GTK theme, glass panels/popups, wider shadows, KWin animations, Dolphin/Konsole defaults, lock screen wallpaper, translucent windows (Kvantum 35 %).

## 1.1.0

- rounded corners on all windows.

## 1.0.x

- initial self-contained theme; Aurorae rc fix; Kvantum/GTK light-dark sync.
