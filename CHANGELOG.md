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
