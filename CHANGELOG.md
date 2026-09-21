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
