#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### COSMIC desktop environment (nightly channel -- includes Frosted Glass)
#
# ryanabx/cosmic-epoch is the Fedora COPR that tracks COSMIC's upstream git
# nightly builds. This is the channel that already has the Frosted Glass
# blur effect: cosmic-settings' toggle UI was reapplied at commit fff1485 on
# 2026-07-10 (after an earlier revert) and that exact commit is what this
# COPR built on 2026-07-11; cosmic-comp's blur renderer was snapshotted in
# again on 2026-07-13. Fedora's own official repos only carry the older
# tagged/stable release (`dnf install @cosmic-desktop-environment`), which
# does not have Frosted Glass yet.
dnf5 -y copr enable ryanabx/cosmic-epoch

dnf5 install -y \
    cosmic-desktop \
    cosmic-session \
    cosmic-comp \
    cosmic-settings \
    cosmic-settings-daemon \
    cosmic-panel \
    cosmic-app-library \
    cosmic-applets \
    cosmic-launcher \
    cosmic-files \
    cosmic-store \
    cosmic-bg \
    cosmic-notifications \
    cosmic-osd \
    cosmic-randr \
    cosmic-screenshot \
    cosmic-workspaces \
    cosmic-idle \
    cosmic-icon-theme \
    cosmic-wallpapers \
    cosmic-edit \
    cosmic-term \
    xdg-desktop-portal-cosmic \
    pop-launcher

# Deliberately NOT installing/enabling cosmic-greeter here. GDM is already
# this image's active display manager and lists every .desktop file it finds
# under /usr/share/wayland-sessions/ as a selectable session -- the
# cosmic-session package above drops its own cosmic.desktop there, so it
# shows up next to GNOME's existing entry with no greeter swap required.

# Disable the COPR so it doesn't linger on the built image -- it's only
# needed during this build. Leaving it enabled would let it influence any
# future ad-hoc `rpm-ostree install` run locally on a booted system.
dnf5 -y copr disable ryanabx/cosmic-epoch
