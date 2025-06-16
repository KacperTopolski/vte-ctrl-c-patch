{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    modified-vte = pkgs.vte.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [ ./fix-ctrl-c.patch ];
    });

    modified-gnome-terminal = pkgs.gnome-terminal.override { vte = modified-vte; };

    # I do not know how to properly mix the client server architecture of Gnome Terminal with nix flakes
    appId = "org.gnome.Terminal-${builtins.substring 0 8 (builtins.baseNameOf modified-gnome-terminal)}";
    gnome-terminal = pkgs.writeShellScriptBin "gnome-terminal" ''
      is_dbus_service_present() {
        busctl --user --list | grep -q ${appId}
      }
      is_dbus_service_present || {
        ${modified-gnome-terminal}/libexec/gnome-terminal-server --app-id ${appId} &
        for i in $(seq 0 24); do
          is_dbus_service_present && break
          sleep 0.01
        done;
      }
      ${modified-gnome-terminal}/bin/gnome-terminal --app-id ${appId} "$@"
    '';

  in {
    packages.${system}.default = gnome-terminal;
  };
}
