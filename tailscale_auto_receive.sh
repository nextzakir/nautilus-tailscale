#!/usr/bin/env bash
# Native blocking auto-receive daemon using tailscale's --wait flag

if ! command -v tailscale &> /dev/null; then
    echo "Tailscale is not installed." >&2
    exit 1
fi

TAILSCALE_DIR="$HOME/Downloads/Tailscale"

ICON_FILE="$HOME/.local/share/icons/hicolor/512x512/apps/tailscale.png"
[[ -f "$ICON_FILE" ]] || ICON_FILE=""

while true; do
    # Recreate if the user removed it while the service was running
    mkdir -p "$TAILSCALE_DIR"

    output=$(
        /usr/bin/tailscale file get \
            --wait \
            --conflict=rename \
            "$TAILSCALE_DIR/" 2>&1
    )
    status=$?

    if [ $status -eq 0 ]; then
        sleep 0.5

        filename=$(ls -t "$TAILSCALE_DIR" 2>/dev/null | head -n 1)
        filepath="$TAILSCALE_DIR/$filename"

        if [ -z "$filename" ] || [ ! -e "$filepath" ]; then
            filepath="$TAILSCALE_DIR"
            msg="Saved to Tailscale folder."
        else
            msg="Received: $filename"
        fi

        ACTION=$(
            notify-send \
                --app-name="Tailscale" \
                --icon="$ICON_FILE" \
                --action="default=Open" \
                "File received via Tailscale" \
                "$msg"
        )

        if [ "$ACTION" = "default" ]; then
            xdg-open "$filepath" &
        fi
    else
        # Handle directory deletion, tailscale restart,
        # network issues, etc.
        sleep 5
    fi
done
