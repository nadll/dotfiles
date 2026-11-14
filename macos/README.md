# macOS security: manual steps

`install.sh` never runs these. They need sudo, and on a company-managed Mac
the firewall and similar settings may be set by MDM (check with IT first; a
managed setting can be greyed out or reset on the next sync).

Check the current state first (read-only, no sudo):

```sh
./macos/security-check.sh
```

## Firewall

```sh
fw=/usr/libexec/ApplicationFirewall/socketfilterfw

sudo "$fw" --setglobalstate on    # turn the firewall on
sudo "$fw" --setstealthmode on    # don't answer pings / probes on closed ports

"$fw" --getglobalstate            # check
"$fw" --getstealthmode
```

Same thing by hand: System Settings > Network > Firewall (> Options for stealth mode).

## Stricter default file permissions (optional)

New files become readable only by you (umask 077 instead of 022). Some
installers and apps expect other users or groups to be able to read their
files, so undo it if something breaks.

```sh
sudo launchctl config user umask 077   # takes effect after a restart
# undo:
sudo rm /private/var/db/com.apple.xpc.launchd/config/user.plist   # then restart
```
