# Windows Terminal like behaviour of CTRL+C

If there is a text selection, CTRL+C copies it to the clipboard, otherwise an interrupt is issued. CTRL+V pastes and clears the selection (nothing special here). Tested with Gnome Terminal, but it should work with any VTE based terminal emulator.

## Nix flake for a modified Gnome Terminal

This repository is a nix flake for a modified Gnome Terminal. Make sure that CTRL+C **is NOT** used as a shortcut anywhere in `Edit->Preferences->Shortcuts`, as it prevents CTRL+C from directly reaching VTE.

```console
nix run github:KacperTopolski/vte-ctrl-c-patch
```
