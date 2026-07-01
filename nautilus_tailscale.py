from gi.repository import Nautilus, GObject
import subprocess
import os


class TailscaleExtension(GObject.GObject, Nautilus.MenuProvider):

    def get_file_items(self, files):
        if not files:
            return []

        paths = []

        for file in files:
            location = file.get_location()

            if not location:
                return []

            path = location.get_path()

            if not path:
                return []

            # Show only for regular files
            if not os.path.isfile(path):
                return []

            paths.append(path)

        item = Nautilus.MenuItem(
            name="TailscaleExtension::Send",
            label="Send with Tailscale",
            tip="Send selected files using Tailscale",
            icon="network-transmit-symbolic"
        )

        item.connect("activate", self.on_activate, paths)

        return [item]

    def on_activate(self, menu, paths):
        sender = os.path.expanduser(
            "~/.local/bin/tailscale_sender.py"
        )

        subprocess.Popen(
            [sender, *paths],
            start_new_session=True
        )
