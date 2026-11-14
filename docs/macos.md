# macOS

Config: `macos/`.

## Text-field key bindings

`macos/DefaultKeyBinding.Dict`, linked to `~/Library/KeyBindings/DefaultKeyBinding.dict`.
Works in Cocoa text fields (TextEdit, Notes, Mail, Safari and Xcode fields), not in iTerm2, VS Code, Chrome or other Electron apps. Quit and reopen an app to pick up changes.

| Keys | Action |
|---|---|
| `Home` / `End` | Start / end of line (macOS default: of the document) |
| `Shift-Home` / `Shift-End` | Select to start / end of line |
| `Cmd-Left` / `Cmd-Right` | Start / end of paragraph |
| `Cmd-Shift-Left` / `Cmd-Shift-Right` | Select to start / end of paragraph |
| `Cmd-Up` / `Cmd-Down` | Start / end of document |
| `Cmd-Shift-Up` / `Cmd-Shift-Down` | Select to start / end of document |
| `Option-Space` | Normal space (macOS default: non-breaking space) |

## Shell helpers

| Command | What it does |
|---|---|
| `cdf` | cd to the folder of the front Finder window |
| `pfd` | Print that folder |
| `ofd` / `o` | Open the current folder in Finder |

More macOS commands (`afk`, `stayawake`, `hidedesktop`, `spotoff`, ...) are in [shell.md](shell.md#macos).

## Scripts

| Script | What it does |
|---|---|
| `macos/security-check.sh` | Shows FileVault, SIP, Gatekeeper, firewall, stealth mode, Remote Login, updates, ... as ✓ / ✗ / ?. Read-only, no sudo |
| `macos/preferences-diff.sh` | Lists which settings in `preferences.sh` differ from this Mac. Read-only |
| `macos/preferences.sh` | Applies the settings below. Runs only with `./install.sh --macos`, after a y/N prompt; no sudo lines are active |
| [`macos/README.md`](../macos/README.md) | Manual sudo steps: firewall, stealth mode, `umask 077` |

## What `preferences.sh` sets

Read the file before running it; obsolete and declined settings are kept commented out.

| Section | Examples |
|---|---|
| General | Save to disk rather than iCloud, expanded save/print panels, scrollbars always shown |
| Quarantine | Apps from the internet run without the "Are you sure?" dialog (LSQuarantine off) |
| Power | Screen saver never starts (the `pmset` sleep settings need sudo and are commented out) |
| Keyboard | Fast key repeat, no press-and-hold accents, no auto-correct / smart quotes / smart dashes / auto-capitalization, full keyboard access |
| Trackpad & mouse | Tap to click, "natural" scrolling off |
| Dock | Bottom, indicator lights, minimize into the app icon, scroll on an icon shows its windows, no bouncing |
| Locale | en_DE |
| Activity Monitor, hot corners, animations | Activity Monitor shows all processes; top-right corner Mission Control, bottom-left Desktop; most animations off |
| Chrome, Safari | Chrome: no swipe back/forward, system print dialog. Safari: no search queries to Apple, no auto-open of downloads, Develop menu (needs Full Disk Access for the terminal) |
| Screenshots | PNG without window shadow, saved to `~/Pictures/Screenshots` |
| Finder | Path bar, all file extensions, `~/Library` visible, ... |
| App Store, Software Update, TextEdit, Preview, Calendar, Time Machine | No in-app review prompts, plain-text TextEdit, week numbers in Calendar (the Software Update lines need sudo and are commented out) |

The script ends with `killall Dock Finder`, so those restart.
