# TUIgreet Theme Palette & DMS Schema Reference

## Core Aesthetic Rules

- **Corners**: `0px` everywhere (`radiusMode: "fixed"`, `fixedRadius: 0`, `radiusStrength: 0`, `geometry-corner-radius 0`).
- **Elevation**: Flat (`m3ElevationEnabled: false`, `popoutElevationEnabled: false`, `barElevationEnabled: false`, `enableRippleEffects: false`).
- **Borders**: Crisp `1px` TUI box lines (`outline: "#666666"` in DMS; active `#ffffff` / inactive `#333333` in Niri; `#444444`–`#666666` in GTK).
- **Typography**: `MesloLGL Nerd Font Mono` across DMS (`fontFamily`, `monoFontFamily`, `displayFontFamily`), Ghostty, Alacritty, and GTK.

## Dark Palette (`TUIgreet`)

| Role | Hex | Usage |
| :--- | :-- | :---- |
| Background / Surface / Lowest | `#000000` | Wallpaper, window canvas, main surfaces |
| Container Low / Default | `#080808` / `#0f0f0f` | Subtle stepped TUI panels & headerbars |
| Container High / Highest | `#181818` / `#222222` | Hovered / elevated rows & containers |
| Primary Text | `#e6e6e6` | Main foreground text |
| Secondary / Variant Text | `#999999` | Muted labels & metadata |
| Primary Accent / On-Primary | `#ffffff` / `#000000` | Reverse-video active selection |
| Outline / Border | `#666666` | Panel, bar, and launcher borders |
| Semantic Error / Warning / Success / Info | `#e06c75` / `#e5c07b` / `#98c379` / `#c8c8c8` | Muted classic ANSI status accents |
| Terminal / Editor / Folder Fuchsia-Magenta | `#d946ef` / `#f0abfc` / `#e879f9` | Replaces ANSI blue in Ghostty/Alacritty, `tokyonight` blues in Neovim, and folder icons in `Adwaita-Magenta` |

## DMS Custom Theme JSON Keys

A DMS custom theme JSON file supports top-level `"dark"` and `"light"` objects, each containing:
`name`, `primary`, `inversePrimary`, `primaryText`, `primaryContainer`, `onPrimaryContainer`, `secondary`, `secondaryContainer`, `onSecondaryContainer`, `tertiary`, `tertiaryContainer`, `onTertiaryContainer`, `surface`, `surfaceText`, `surfaceVariant`, `surfaceVariantText`, `surfaceTint`, `background`, `backgroundText`, `outline`, `surfaceContainerLowest`, `surfaceContainerLow`, `surfaceContainer`, `surfaceContainerHigh`, `surfaceContainerHighest`, `inverseSurface`, `inverseOnSurface`, `error`, `errorText`, `errorContainer`, `errorContainerText`, `warning`, `info`, `success`.
