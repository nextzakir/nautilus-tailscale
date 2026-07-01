#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user
mkdir -p ~/.local/share/nautilus-python/extensions

install -m755 \
    "$SCRIPT_DIR/tailscale_sender.py" \
    ~/.local/bin/tailscale_sender.py

install -m755 \
    "$SCRIPT_DIR/tailscale_auto_receive.sh" \
    ~/.local/bin/tailscale_auto_receive.sh

install -m644 \
    "$SCRIPT_DIR/tailscale-auto-receive.service" \
    ~/.config/systemd/user/tailscale-auto-receive.service

install -m644 \
    "$SCRIPT_DIR/nautilus_tailscale.py" \
    ~/.local/share/nautilus-python/extensions/nautilus_tailscale.py

systemctl --user daemon-reload
systemctl --user enable --now tailscale-auto-receive.service

nautilus -q 2>/dev/null || true

echo ""
echo "Installed successfully."
echo ""
echo "Right click one or more files in Nautilus and select:"
echo ""
echo "  Send with Tailscale"
echo ""
