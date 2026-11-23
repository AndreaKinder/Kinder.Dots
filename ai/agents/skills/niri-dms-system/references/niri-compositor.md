# Niri Compositor, Keybinds & Helpers

Reference for Niri Wayland compositor (`niri 26.04`) configuration, window rules, clipboard helper, and touchscreen gestures.

## Configuration Files

| Component | Live Symlink Path | Source in `$DOTFILES_PATH` | Notes |
| :-------- | :---------------- | :------------------------- | :---- |
| Niri compositor dir | `~/.config/niri` | `os/linux/niri` | Contains `config.kdl` (including `nextcloud --background` startup), `dms/*.kdl`, and `src/niri-clipboard/niri-clipboard.c`. Auto-reloads on save. |
| Niri helper binaries | `~/.local/bin/niri-clipboard`, `~/.local/bin/niri-touch-gestures` | `bin/niri-clipboard`, `bin/niri-touch-gestures` | Universal `Mod+C`/`Mod+X`/`Mod+V` Wayland clipboard & 3/4-finger touchscreen gesture daemon. |
| Niri touch service & udev | `~/.config/systemd/user/niri-touch-gestures.service`, `/etc/udev/rules.d/70-raydium-touchscreen.rules` | `os/linux/systemd/user/niri-touch-gestures.service`, `os/linux/udev/rules.d/70-raydium-touchscreen.rules` | Uses `%h/.dotfiles/bin/niri-touch-gestures` + `uaccess` udev rule for Raydium touchscreen. |

## Hardware & Personal Rules to Preserve

In `~/.config/niri/config.kdl` (`$DOTFILES_PATH/os/linux/niri/config.kdl`), always preserve:

- **Input & Tablet**: Spanish keyboard layout (`es`), touchscreen mapping (`eDP-1`), `squeekboard`, `tablet-mode-on/off` switch events.
- **Keybinds**: Omarchy/DMS keybinds, `Mod+B` (Ardia browser), `Mod+Return` (Ghostty), `Mod+Shift+Left/Right/Down/Up` window/column move binds, `Mod+C`/`Mod+X`/`Mod+V` (`niri-clipboard`), `Alt+Space` (`voxtype record toggle`), `Mod+WheelScroll*` vertical/horizontal wheel binds.
- **Layout & Window Rules**: `active-color "#ffffff"` layout border, borderless `window-rule`s for `com.mitchellh.ghostty` and FirefoxPWA (`(?i)^ffpwa-`), and fullscreen `window-rule` (`open-fullscreen true`) for Steam Big Picture (`^steam$` + `(?i)big picture`), Steam games (`^steam_app_\d+$`), and `gamescope`.

## Procedure: Editing Niri Layout, Rules, or Helpers

1. Edit `~/.config/niri/config.kdl` (`$DOTFILES_PATH/os/linux/niri/config.kdl`), preserving all rules listed above.
2. If modifying `niri-clipboard.c` (`$DOTFILES_PATH/os/linux/niri/src/niri-clipboard/niri-clipboard.c`), recompile into `$DOTFILES_PATH/bin/niri-clipboard`:
   ```bash
   gcc -O2 "$DOTFILES_PATH/os/linux/niri/src/niri-clipboard/niri-clipboard.c" -o "$DOTFILES_PATH/bin/niri-clipboard" -lwayland-client -lxkbcommon
   ```
3. Always validate Niri config before finishing (requires running outside sandbox):
   ```bash
   niri validate
   ```
   Niri reloads valid changes automatically.
