#!/bin/bash
# Show this Mac's main security settings, without changing anything and without sudo.
# Each line is ✓ (as recommended), ✗ (not as recommended, with what to do) or ? (could not tell).
# Based on the checks in the macOS Security and Privacy Guide (drduh).
#
# Usage: macos/security-check.sh

set -u

if [ "$(uname)" != "Darwin" ]; then
  echo "security-check.sh only runs on macOS" >&2
  exit 1
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

bad=0

ok()      { printf "${GREEN}✓${NC} %-24s %s\n" "$1" "$2"; }
fail()    { printf "${RED}✗${NC} %-24s %s\n      -> %s\n" "$1" "$2" "$3"; bad=$((bad + 1)); }
unknown() { printf "${YELLOW}?${NC} %-24s %s\n" "$1" "$2"; }

# FileVault: the disk can only be unlocked with your password after a restart
out=$(fdesetup status 2>&1)
case "$out" in
  *"FileVault is On"*) ok "FileVault" "on" ;;
  *"FileVault is Off"*) fail "FileVault" "off" "System Settings > Privacy & Security > FileVault" ;;
  *) unknown "FileVault" "$out" ;;
esac

# System Integrity Protection: system files can't be changed, even by root
out=$(csrutil status 2>&1)
case "$out" in
  *"status: enabled"*) ok "SIP" "enabled" ;;
  *"status: disabled"*) fail "SIP" "disabled" "turn it back on from Recovery: csrutil enable" ;;
  *) unknown "SIP" "$out" ;;
esac

# Gatekeeper: apps must be notarized by Apple (or allowed by you) before they open
out=$(spctl --status 2>&1)
case "$out" in
  *"assessments enabled"*) ok "Gatekeeper" "enabled" ;;
  *"assessments disabled"*) fail "Gatekeeper" "disabled" "sudo spctl --global-enable" ;;
  *) unknown "Gatekeeper" "$out" ;;
esac

# Download quarantine: downloaded files are checked by Gatekeeper when first opened
if [ "$(defaults read com.apple.LaunchServices LSQuarantine 2>/dev/null)" = "0" ]; then
  fail "Download quarantine" "off (LSQuarantine, set by preferences.sh)" \
    "your choice for now; to turn it back on: defaults delete com.apple.LaunchServices LSQuarantine"
else
  ok "Download quarantine" "on"
fi

# Built-in firewall: blocks incoming connections to apps you haven't allowed
fw=/usr/libexec/ApplicationFirewall/socketfilterfw
out=$("$fw" --getglobalstate 2>&1)
case "$out" in
  *"State = 1"* | *"State = 2"* | *"is enabled"*) ok "Firewall" "on" ;;
  *"State = 0"* | *"is disabled"*) fail "Firewall" "off" "System Settings > Network > Firewall" ;;
  *) unknown "Firewall" "$out" ;;
esac

# Stealth mode: the Mac doesn't answer pings or connection attempts to closed ports
out=$("$fw" --getstealthmode 2>&1)
case "$out" in
  *"is on"* | *"mode enabled"*) ok "Firewall stealth mode" "on" ;;
  *"is off"* | *"mode disabled"*) fail "Firewall stealth mode" "off" "System Settings > Network > Firewall > Options" ;;
  *) unknown "Firewall stealth mode" "$out" ;;
esac

# Remote Login: the SSH server, off unless you need to log in to this Mac from elsewhere
out=$(launchctl print-disabled system 2>/dev/null | grep '"com.openssh.sshd"')
case "$out" in
  *"=> disabled"* | *"=> true"*) ok "Remote Login (SSH)" "off" ;;
  *"=> enabled"* | *"=> false"*) fail "Remote Login (SSH)" "on" "System Settings > General > Sharing > Remote Login" ;;
  # not listed: never switched on or off, so it has macOS's default (off);
  # double-check that nothing answers on the SSH port
  "")
    if nc -z -G 1 127.0.0.1 22 >/dev/null 2>&1; then
      unknown "Remote Login (SSH)" "not switched on, but something answers on port 22"
    else
      ok "Remote Login (SSH)" "off (never turned on)"
    fi ;;
  *) unknown "Remote Login (SSH)" "$out" ;;
esac

# Lock screen: password required right after sleep or screen saver
out=$(sysadminctl -screenLock status 2>&1)
case "$out" in
  *"is immediate"*) ok "Password after sleep" "immediately" ;;
  *"is off"*) fail "Password after sleep" "not required" "System Settings > Lock Screen > Require password ... Immediately" ;;
  *"delay is"*) fail "Password after sleep" "${out##*delay is }" "System Settings > Lock Screen > Require password ... Immediately" ;;
  *) unknown "Password after sleep" "$out" ;;
esac

# Lockdown Mode: optional, strong protection against targeted attacks (disables many features)
case "$(sysctl -n security.mac.lockdown_mode_state 2>/dev/null)" in
  1) ok "Lockdown Mode" "on" ;;
  0) ok "Lockdown Mode" "off (optional)" ;;
  *) unknown "Lockdown Mode" "not available on this macOS" ;;
esac

# Automatic updates: a missing key means the macOS default, which is on
su_pref() {
  case "$(defaults read /Library/Preferences/com.apple.SoftwareUpdate "$1" 2>/dev/null)" in
    1) echo on ;;
    0) echo off ;;
    *) echo default ;;
  esac
}
check=$(su_pref AutomaticCheckEnabled)
security=$(su_pref CriticalUpdateInstall)
if [ "$check" = off ] || [ "$security" = off ]; then
  fail "Automatic updates" "check: $check, security responses: $security" \
    "System Settings > General > Software Update > Automatic Updates"
else
  ok "Automatic updates" "check: $check, security responses: $security"
fi

echo
echo "Not checked here (System Settings only): firmware security (should be Full Security),"
echo "private Wi-Fi address, Analytics & Improvements, Siri/Spotlight suggestions."
if [ "$bad" -eq 0 ]; then
  echo "Nothing to fix."
else
  echo "$bad setting(s) to review."
fi
