#!/bin/sh

# WARNING: inherited from samoshkin/dotfiles and not reviewed yet. Read it before running:
# it disables Gatekeeper (`spctl --master-disable`) and download quarantine (LSQuarantine),
# sets the time zone to Europe/Kiev and the locale to en_UA, and changes Dock, Finder,
# trackpad and keyboard settings. install.sh runs it only with --macos, after asking.

set -e
set -o pipefail

# ===================
# General
# ===================

# Set sidebar icon size to medium (1: small, 2: medium, 3: large)
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Disable automatic termination of inactive apps
defaults write -g NSDisableAutomaticTermination -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# make menu bar translucent
# Obsolete (OS X 10.7 era), no effect on current macOS
# defaults write -g AppleEnableMenuBarTransparency -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Always show scrollbars (other values: "WhenScrolling", "Automatic")
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Set Help Viewer windows to non-floating mode
# Obsolete, the current Tips/Help viewer ignores it
# defaults write com.apple.helpviewer DevMode -bool true

# =====================
# Quarantine
# =====================

# Enable applications installed from Internet to run without restrictions
# On macOS 15 Sequoia and later this only unlocks the option: then go to System Settings ->
# Privacy & Security -> Security and choose "Allow applications from: Anywhere"
sudo spctl --master-disable

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ===========================
# Power Management
# ===========================

# on power (values in minutes, 0 = never)
sudo pmset -c displaysleep 10
sudo pmset -c sleep 11
# disksleep only spins down hard disks, no effect on an SSD
# sudo pmset -c disksleep 20

# on battery
sudo pmset -b displaysleep 5
sudo pmset -b sleep 6
# sudo pmset -b disksleep 10

# Wake up the machine when lid is opened
sudo pmset -a lidwake 1

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# disable display sleep to use an intermediate half-brightness state between full brightness and fully off  (value = 0/1)
# just make it fully off
sudo pmset -a halfdim 0

# disable screen saver (idleTime is in seconds, 0 = never)
defaults -currentHost write com.apple.screensaver idleTime 0

# Require password immediately after sleep or screen saver begins
# Ignored since macOS 10.13 High Sierra; use System Settings -> Lock Screen,
# or `sysadminctl -screenLock immediate -password -`
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0


# =======================
# Keyboard
# =======================

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# increase key repeat rate; both values are in units of 15 ms
# KeyRepeat 1 = 15 ms between repeats (fastest in System Settings is 2 = 30 ms)
# InitialKeyRepeat 15 = 225 ms before repeating starts (shortest in System Settings)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# see http://hints.macworld.com/article.php?story=20131123074223584
# see http://osxnotes.net/keybindings.html for valid key chords
# Since macOS 13 Ventura the menu item is "System Settings…", so this matches nothing
# defaults write -g NSUserKeyEquivalents '{
#   "System Preferences..."="@$,";
# }'

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
# 0: text boxes and lists only (default), 2 or 3: all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# ===========================
# TrackPad & Mouse
# ===========================

# Trackpad: enable tap to click for this user and for the login screen
# tapBehavior 1 = tap to click, 0 = off
# Note: com.apple.driver.AppleBluetoothMultitouch.trackpad is the Magic Trackpad only;
# the built-in trackpad reads com.apple.AppleMultitouchTrackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# drag with three fingers (Magic Trackpad only; on current macOS it's an Accessibility
# setting: System Settings -> Accessibility -> Pointer Control -> Trackpad Options)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1

# Mouse sensitivity
# mouse.scaling is the tracking speed slider (about 0 to 3, -1 turns acceleration off)
# scrollwheel.scaling is the scrolling speed slider (about 0 to 1)
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.5
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.1265


# ===========================
# Dock & Dashboard
# ===========================

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 44
defaults write com.apple.dock largesize -int 72

# Keep Dock on the right side
defaults write com.apple.dock orientation -string "right"

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock "show-process-indicators" -int 1

# Marks the Dock's Trash icon as full. macOS sets this flag itself whenever the Trash
# changes, so writing it has no lasting effect
# defaults write com.apple.dock "trash-full" -int 1

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Show hidden apps in a Dock
defaults write com.apple.dock showhidden -bool true

# Use magnigification when hovering mouse over the icon
defaults write com.apple.dock magnification -int 1

# Change minimize/maximize window effect ("genie" is the default, "suck" is hidden)
defaults write com.apple.dock mineffect -string "scale"

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Disable Dashboard
# Dashboard was removed in macOS 10.15 Catalina
# defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Show recent applications in Dock
defaults write com.apple.dock show-recents -bool true

# ===========================
# Locale and language
# ===========================

defaults write NSGlobalDomain AppleLocale -string "en_UA"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Kiev" > /dev/null

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# ===========================
# Activity Monitor
# ===========================

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
# 0 is the pre-10.10 value; current Activity Monitor uses 100: All Processes,
# 101: hierarchically, 102: My Processes, 103: System, 105: Active, 107: Windowed
# defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor ShowCategory -int 100

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
# SortDirection 0 = descending, 1 = ascending
defaults write com.apple.ActivityMonitor SortDirection -int 0

# =======================
# Hot corners
# =======================

# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard (removed in Catalina)
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# 14: Quick Note (macOS 12 Monterey and later)
#
# The *-modifier keys are the key to hold down for the corner to fire:
# 0: none, 131072: Shift, 262144: Control, 524288: Option, 1048576: Command

# Top right screen corner → Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom left screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0


# =======================
# Animations
# =======================

# Enable inertial scroll
defaults write -g AppleMomentumScrollSupported -bool true

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Reduce motion. Prevent animation when navigation between spaces.
# Results in fade in/fade out effects, rather that swipe transition
defaults write com.apple.universalaccess reduceMotion -bool true

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# showing and hiding sheets, resizing preference windows, zooming windows
# 0 is ignored, so use the smallest non-zero value
defaults write -g NSWindowResizeTime -float 0.001

# opening and closing Quick Look windows
defaults write -g QLPanelAnimationDuration -float 0

# rubberband scrolling (doesn't affect web views)
defaults write -g NSScrollViewRubberbanding -bool false

# resizing windows before and after showing the version browser
# also disabled by NSWindowResizeTime -float 0.001
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false

# showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# scrolling column views
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

# showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0

# showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# showing and hiding Launchpad
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0

# changing pages in Launchpad
defaults write com.apple.dock springboard-page-duration -float 0

# Animations in Finder
defaults write com.apple.finder DisableAllAnimations -bool true

# sending messages and opening windows for replies
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true

# smooth scrolling
defaults write NSGlobalDomain AppleScrollAnimationEnabled -bool false
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# =======================
# Chrome
# =======================

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

# ===========================
# Safari & Webkit
# ===========================
# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# ===========================
# Screen capture
# ===========================

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Save location for the screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# ===========================
# Finder
# ===========================

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: allow text selection in Quick Look
# Obsolete, Quick Look allows text selection by default
# defaults write com.apple.finder QLEnableTextSelection -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Make path relative to $HOME dir rather than "/"
defaults write com.apple.finder PathBarRootAtHome -bool TRUE

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# show hidden files everywhere
defaults write -g AppleShowAllFiles -bool true

# When performing a search, search the current folder by default
# SCcf: current folder, SCev: This Mac, SCsp: the previous search scope
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default
# Nlsv: list, icnv: icons, clmv: columns, glyv: gallery
# (`Flwv` was Cover Flow, replaced by gallery in macOS 10.14 Mojave)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Empty Trash securely by default
# Secure empty was removed in OS X 10.11 El Capitan
# defaults write com.apple.finder EmptyTrashSecurely -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# disable warn on empty trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
sudo chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# show path bar, but do not show status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
# Other codes: PfHm: home, PfDo: Documents, PfCm: Computer, PfVo: startup volume,
# PfAF: Recents (all files). If you change it, point NewWindowTargetPath at the same folder
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# =================================
# Mac App Store
# =================================

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

echo "Done. Note that some of these changes require a logout/restart to take effect."
