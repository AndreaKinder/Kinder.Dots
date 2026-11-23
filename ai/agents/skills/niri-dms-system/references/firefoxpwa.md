# FirefoxPWA Web Apps

Reference for installing, theming, validating, and managing Progressive Web Apps with `firefoxpwa` (`/usr/bin/firefoxpwa`).

## Paths & Installed Apps

- **Runtime**: `~/.local/share/firefoxpwa/runtime`
- **Profiles**: `~/.local/share/firefoxpwa/profiles/` (default profile `00000000000000000000000000`)
- **Launchers**: `~/.local/share/applications/FFPWA-*.desktop`
- **Dotfiles source (`os/linux/firefoxpwa/`)**: `config.json`, `apps.txt`, `applications/`, `icons/`, `user.js`, `chrome/userChrome.css`
- **Tracked apps**: **WhatsApp** (`01M7SHF20HH1SQ5DAMZ8HM0YB9`) & **HEY** (`01M7Y10CWF0X27PJ6RNVS9M5YQ`, `https://app.hey.com/manifest.json`)

## Procedure: Installing & Managing Web Apps

1. **Ensure the runtime is installed** (one-time setup; check `~/.local/share/firefoxpwa/runtime/firefox`):
   - Normally run `firefoxpwa runtime install`.
   - **Timeout fallback**: If the built-in downloader times out, download the official Linux64 Firefox archive with `curl`, extract it, and patch it locally:
     ```bash
     curl -fL -C - --retry 3 -o /tmp/firefox-runtime.tar.xz "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64"
     mkdir -p ~/.local/share/firefoxpwa/runtime
     tar -xf /tmp/firefox-runtime.tar.xz -C ~/.local/share/firefoxpwa/runtime --strip-components=1
     rm -f /tmp/firefox-runtime.tar.xz
     firefoxpwa runtime patch
     ```

2. **Install the web app**:
   - **Always pass at least one `--keywords` flag** so `firefoxpwa` does not generate an invalid `Keywords=;` line (which fails `desktop-file-validate` and can prevent launchers from listing the app).
   - **Site with a Web App Manifest** (e.g., `https://web.whatsapp.com/manifest.json`):
     ```bash
     firefoxpwa site install "<MANIFEST_URL>" \
       --name "<App Name>" \
       --categories Network \
       --keywords "<Keyword1>" --keywords "<Keyword2>"
     ```
   - **Site without a manifest** (inline empty manifest via `data:` URL):
     ```bash
     firefoxpwa site install "data:application/manifest+json,{}" \
       --document-url "https://example.com" \
       --start-url "https://example.com" \
       --icon-url "https://example.com/favicon.ico" \
       --name "<App Name>" \
       --categories Network \
       --keywords "<Keyword1>"
     ```
   - Optional: isolate sessions with `firefoxpwa profile create --name "<Profile>"` and pass `--profile <PROFILE_ID>` to `site install`.

3. **Validate & refresh the DMS launcher**:
   ```bash
   desktop-file-validate ~/.local/share/applications/FFPWA-<SITE_ID>.desktop
   update-desktop-database ~/.local/share/applications
   dms restart
   ```

4. **Window borders & hiding the FirefoxPWA top bar**:
   - All FirefoxPWA web apps (`app-id` matching `(?i)^ffpwa-`) are automatically borderless in Niri via the shared `window-rule` in `~/.config/niri/config.kdl`.
   - To hide FirefoxPWA's own top titlebar/icon bar in a profile (already enabled on the default profile `00000000000000000000000000`; use `userChrome.css`):
     - Add `user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);` to `~/.local/share/firefoxpwa/profiles/<PROFILE_ID>/user.js`.
     - Create `~/.local/share/firefoxpwa/profiles/<PROFILE_ID>/chrome/userChrome.css` collapsing `#titlebar`, `#TabsToolbar`, `#toolbar-menubar`, and `#PersonalToolbar` (`display: none !important; visibility: collapse !important;`) and setting `border-radius: 0 !important;` on `:root, body`.
     - Clear `~/.local/share/firefoxpwa/profiles/<PROFILE_ID>/startupCache/*` before relaunching so Firefox reloads the stylesheet immediately.

5. **Useful commands**:
   - List profiles & installed app IDs: `firefoxpwa profile list`
   - Launch from CLI: `firefoxpwa site launch <SITE_ID>`
   - Update metadata/keywords: `firefoxpwa site update <SITE_ID> --no-manifest-updates --no-icon-updates --keywords "<Keyword>"`
   - Uninstall: `firefoxpwa site uninstall <SITE_ID>`
