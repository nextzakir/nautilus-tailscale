#!/usr/bin/env bash
set -e

systemctl --user stop tailscale-auto-receive.service 2>/dev/null || true
systemctl --user disable tailscale-auto-receive.service 2>/dev/null || true

rm -f ~/.local/bin/tailscale_sender.py
rm -f ~/.local/bin/tailscale_auto_receive.sh
rm -f ~/.config/systemd/user/tailscale-auto-receive.service
rm -f ~/.local/share/nautilus-python/extensions/nautilus_tailscale.py

systemctl --user daemon-reload
nautilus -q 2>/dev/null || true
