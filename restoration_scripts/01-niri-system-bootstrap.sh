#!/usr/bin/env bash

# Restoration script executed automatically by `dot self install` (or via `dot system bootstrap`).
# Safe to run from a bare TTY / headless Arch or CachyOS install (without an active graphical session).
# Installs and configures all saved system packages (pacman, AUR, cargo), Ardia browser + CLI,
# FirefoxPWA web apps (WhatsApp & HEY), Herdr TUI (never herdr-app), HEY CLI/TUI,
# Niri + Dux Shell (DMS) + Ghostty + Alacritty + GTK 3/4 + Neovim + Obsidian, udev touchscreen rules,
# and greetd/tuigreet login settings.

install_niri_system() {
	local dotfiles_dir="${DOTFILES_PATH:-$HOME/.dotfiles}"
	local pacman_pkg_file="$dotfiles_dir/os/linux/pacman/packages.txt"
	local aur_pkg_file="$dotfiles_dir/os/linux/pacman/aur-packages.txt"
	local cargo_pkg_file="$dotfiles_dir/langs/rust/cargo-packages.txt"
	local ffpwa_apps_file="$dotfiles_dir/os/linux/firefoxpwa/apps.txt"

	if ! command -v pacman &>/dev/null; then
		echo "ℹ️ Sistema no basado en Arch/pacman; omitiendo instalación base de Niri."
		return 0
	fi

	if [[ $EUID -eq 0 ]]; then
		echo "❌ No ejecutes la instalación como root directamente (paru/yay requieren usuario normal)."
		return 1
	fi

	echo "🚀 1. Actualizando sistema e instalando paquetes base de Niri, Wayland, audio, fuentes y herramientas CLI..."
	sudo pacman -Syu --noconfirm --needed \
		niri xwayland-satellite xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
		xdg-utils xdg-user-dirs desktop-file-utils shared-mime-info \
		ghostty alacritty neovim micro lazygit obsidian firefoxpwa \
		polkit polkit-gnome gnome-keyring libsecret seatd \
		networkmanager bluez bluez-utils iio-sensor-proxy \
		pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol brightnessctl playerctl wl-clipboard \
		squeekboard greetd greetd-tuigreet \
		ttf-meslo-nerd noto-fonts noto-fonts-emoji noto-fonts-cjk \
		git github-cli base-devel gcc pkgconf wayland wayland-protocols libxkbcommon \
		python rustup zsh fish fzf ripgrep fd jq curl wget tar xz unzip

	if [[ -f "$pacman_pkg_file" ]] && [[ -s "$pacman_pkg_file" ]]; then
		echo "📋 Instalando aplicaciones guardadas en os/linux/pacman/packages.txt (filtrando paquetes exclusivos de CachyOS si no están en los repositorios actuales)..."
		local available_pkgs
		available_pkgs="$(comm -12 <(grep -vE '^\s*(#|firefox$|$)' "$pacman_pkg_file" | sort -u) <(pacman -Slq | sort -u))"
		if [[ -n "$available_pkgs" ]]; then
			sudo pacman -S --noconfirm --needed - <<<"$available_pkgs" || true
		fi
	fi

	echo "📦 2. Asegurando helper AUR (paru/yay) e instalando paquetes de AUR, Dux Shell (DMS) y rot8..."
	local aur_helper=""
	if command -v paru &>/dev/null; then
		aur_helper="paru"
	elif command -v yay &>/dev/null; then
		aur_helper="yay"
	else
		echo "⬇️ No se encontró paru ni yay; instalando paru-bin desde AUR..."
		local tmp_aur
		tmp_aur="$(mktemp -d)"
		if git clone https://aur.archlinux.org/paru-bin.git "$tmp_aur/paru-bin"; then
			(cd "$tmp_aur/paru-bin" && makepkg -si --noconfirm) || true
		fi
		rm -rf "$tmp_aur"
		command -v paru &>/dev/null && aur_helper="paru"
	fi

	if ! pacman -Qi dux-shell &>/dev/null && ! pacman -Qi dux-shell-bin &>/dev/null; then
		if pacman -Si dux-shell &>/dev/null; then
			sudo pacman -S --noconfirm --needed dux-shell
		elif [[ -n "$aur_helper" ]]; then
			"$aur_helper" -S --noconfirm --needed dux-shell-bin || true
		fi
	fi

	if [[ -n "$aur_helper" ]]; then
		"$aur_helper" -S --noconfirm --needed rot8 || true
		if [[ -f "$aur_pkg_file" ]] && [[ -s "$aur_pkg_file" ]]; then
			echo "📋 Instalando paquetes de AUR guardados en os/linux/pacman/aur-packages.txt..."
			grep -vE '^\s*(#|$)' "$aur_pkg_file" | "$aur_helper" -S --noconfirm --needed - || true
		fi
	fi

	echo "🦀 3. Inicializando toolchain de Rust y binarios de Cargo (langs/rust/cargo-packages.txt)..."
	export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
	if command -v rustup &>/dev/null && ! rustup show active-toolchain &>/dev/null; then
		rustup default stable || true
	fi

	local cargo_bin=""
	if command -v cargo &>/dev/null; then
		cargo_bin="cargo"
	elif [[ -x "$HOME/.cargo/bin/cargo" ]]; then
		cargo_bin="$HOME/.cargo/bin/cargo"
	fi
	if [[ -n "$cargo_bin" ]] && [[ -f "$cargo_pkg_file" ]] && [[ -s "$cargo_pkg_file" ]]; then
		while IFS= read -r crate; do
			[[ -z "$crate" || "$crate" =~ ^# ]] && continue
			if ! command -v "$crate" &>/dev/null && [[ ! -x "$HOME/.cargo/bin/$crate" ]]; then
				"$cargo_bin" install "$crate" || true
			fi
		done <"$cargo_pkg_file"
	fi

	echo "🌍 4. Instalando navegador predeterminado Ardia y Ardia CLI (si no están presentes)..."
	mkdir -p "$HOME/.local/bin"
	if [[ ! -x /usr/bin/ardia ]] || [[ ! -x "$HOME/.local/bin/ardia" ]]; then
		local ardia_json
		ardia_json="$(curl -fsSL -H 'Accept: application/vnd.github+json' https://api.github.com/repos/ardia-browser/ardia/releases 2>/dev/null || true)"
		if [[ -n "$ardia_json" ]]; then
			if [[ ! -x /usr/bin/ardia ]]; then
				local ardia_tar_url
				ardia_tar_url="$(python3 -c '
import json, sys
for r in json.load(sys.stdin):
    for a in r.get("assets", []):
        u = a.get("browser_download_url", "")
        if u.endswith("-linux-x64.tar.xz") and "Ardia-" in u:
            print(u); sys.exit(0)
' <<<"$ardia_json" 2>/dev/null || true)"
				if [[ -n "$ardia_tar_url" ]]; then
					echo "⬇️ Descargando e instalando Ardia Browser desde $ardia_tar_url..."
					local tmp_ardia
					tmp_ardia="$(mktemp -d)"
					if curl -fL --retry 3 -o "$tmp_ardia/ardia.tar.xz" "$ardia_tar_url"; then
						tar -xf "$tmp_ardia/ardia.tar.xz" -C "$tmp_ardia"
						local ardia_inst
						ardia_inst="$(find "$tmp_ardia" -maxdepth 3 -name install.sh -type f | head -n 1)"
						[[ -n "$ardia_inst" ]] && sudo bash "$ardia_inst" --prefix /usr || true
					fi
					rm -rf "$tmp_ardia"
				fi
			fi

			if [[ ! -x "$HOME/.local/bin/ardia" ]]; then
				local ardia_cli_url
				ardia_cli_url="$(python3 -c '
import json, sys
for r in json.load(sys.stdin):
    for a in r.get("assets", []):
        u = a.get("browser_download_url", "")
        if "ardia-cli-" in u and u.endswith("-linux-x64.tar.gz"):
            print(u); sys.exit(0)
' <<<"$ardia_json" 2>/dev/null || true)"
				if [[ -n "$ardia_cli_url" ]]; then
					echo "⬇️ Descargando e instalando Ardia CLI desde $ardia_cli_url..."
					mkdir -p "$HOME/.local/share/ardia/cli/current"
					if curl -fL --retry 3 -o /tmp/ardia-cli.tar.gz "$ardia_cli_url"; then
						tar -xzf /tmp/ardia-cli.tar.gz -C "$HOME/.local/share/ardia/cli/current" --strip-components=1 2>/dev/null || tar -xzf /tmp/ardia-cli.tar.gz -C "$HOME/.local/share/ardia/cli/current" || true
						rm -f /tmp/ardia-cli.tar.gz
						[[ -x "$HOME/.local/share/ardia/cli/current/bin/ardia" ]] && ln -sf "$HOME/.local/share/ardia/cli/current/bin/ardia" "$HOME/.local/bin/ardia"
					fi
				fi
			fi
		fi
	fi

	echo "🖥️ 4b. Instalando Herdr TUI (sin herdr-app)..."
	rm -rf "$HOME/.local/bin/herdr-app" "$HOME/.local/bin/herdr-core" "$HOME/.local/bin/hc" \
		"$HOME/.local/share/herdr-app" "$HOME/.local/share/applications/herdr-app.desktop" \
		"$HOME/.config/herdr-app" 2>/dev/null || true

	if [[ ! -x "$HOME/.local/bin/herdr" ]] && ! command -v herdr &>/dev/null; then
		local herdr_url
		herdr_url="$(curl -fsSL https://herdr.dev/latest.json 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin)["assets"]["linux-x86_64"])' 2>/dev/null || true)"
		if [[ -n "$herdr_url" ]]; then
			echo "⬇️ Descargando Herdr TUI desde $herdr_url..."
			curl -fL --retry 3 -o "$HOME/.local/bin/herdr" "$herdr_url" && chmod +x "$HOME/.local/bin/herdr" || true
		fi
	fi

	echo "📬 4c. Instalando HEY CLI & TUI (basecamp/hey-cli) y conectando agentes..."
	if [[ ! -x "$HOME/.local/bin/hey" ]] && ! command -v hey &>/dev/null; then
		HEY_SKIP_SETUP=1 HEY_BIN_DIR="$HOME/.local/bin" bash <(curl -fsSL https://hey.com/install-cli) || true
	fi
	if [[ -x "$HOME/.local/bin/hey" ]]; then
		HEY_NO_KEYRING=1 "$HOME/.local/bin/hey" setup agents >/dev/null 2>&1 || true
	fi

	echo "🔨 5. Compilando binario Wayland niri-clipboard desde el código fuente..."
	local clip_src="$dotfiles_dir/os/linux/niri/src/niri-clipboard/niri-clipboard.c"
	local clip_bin="$dotfiles_dir/bin/niri-clipboard"
	if [[ -f "$clip_src" ]] && command -v gcc &>/dev/null; then
		gcc -O2 "$clip_src" -o "$clip_bin" -lwayland-client -lxkbcommon
		chmod +x "$clip_bin"
	fi

	echo "🌐 6. Restaurando runtime, tema sin barra superior y Web Apps (WhatsApp & HEY) en FirefoxPWA..."
	if command -v firefoxpwa &>/dev/null; then
		if [[ ! -x "$HOME/.local/share/firefoxpwa/runtime/firefox" ]]; then
			echo "⬇️ Instalando runtime de FirefoxPWA..."
			if ! firefoxpwa runtime install; then
				echo "⚠️ Fallback: descargando y parcheando FirefoxPWA runtime manualmente..."
				curl -fL -C - --retry 3 -o /tmp/firefox-runtime.tar.xz "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64" &&
					mkdir -p "$HOME/.local/share/firefoxpwa/runtime" &&
					tar -xf /tmp/firefox-runtime.tar.xz -C "$HOME/.local/share/firefoxpwa/runtime" --strip-components=1 &&
					rm -f /tmp/firefox-runtime.tar.xz &&
					firefoxpwa runtime patch || true
			fi
		fi

		if [[ -f "$ffpwa_apps_file" ]]; then
			local existing_pwas
			existing_pwas="$(firefoxpwa profile list 2>/dev/null || true)"
			while IFS='|' read -r app_name manifest_url categories keywords; do
				[[ -z "$app_name" || "$app_name" =~ ^# ]] && continue
				if ! grep -Fq "$manifest_url" <<<"$existing_pwas"; then
					echo "📲 Instalando Web App FirefoxPWA: $app_name..."
					local kw_args=()
					IFS=',' read -ra kw_arr <<<"$keywords"
					for kw in "${kw_arr[@]}"; do
						[[ -n "$kw" ]] && kw_args+=(--keywords "$kw")
					done
					firefoxpwa site install "$manifest_url" \
						--name "$app_name" \
						--categories "${categories%%,*}" \
						"${kw_args[@]}" || true
				fi
			done <"$ffpwa_apps_file"
		fi

		local default_ffpwa_profile="$HOME/.local/share/firefoxpwa/profiles/00000000000000000000000000"
		mkdir -p "$default_ffpwa_profile/chrome" "$HOME/.local/share/applications" "$HOME/.local/share/icons"
		if [[ -d "$dotfiles_dir/os/linux/firefoxpwa/icons/hicolor" ]]; then
			cp -a "$dotfiles_dir/os/linux/firefoxpwa/icons/hicolor" "$HOME/.local/share/icons/"
		fi
		if [[ -d "$dotfiles_dir/os/linux/firefoxpwa/applications" ]]; then
			cp -af "$dotfiles_dir/os/linux/firefoxpwa/applications/"*.desktop "$HOME/.local/share/applications/" 2>/dev/null || true
		fi
		[[ -f "$dotfiles_dir/os/linux/firefoxpwa/user.js" ]] && cp -af "$dotfiles_dir/os/linux/firefoxpwa/user.js" "$default_ffpwa_profile/user.js" || true
		[[ -f "$dotfiles_dir/os/linux/firefoxpwa/chrome/userChrome.css" ]] && cp -af "$dotfiles_dir/os/linux/firefoxpwa/chrome/userChrome.css" "$default_ffpwa_profile/chrome/userChrome.css" || true
		rm -rf "$default_ffpwa_profile/startupCache/"* 2>/dev/null || true
		command -v update-desktop-database &>/dev/null && update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
	fi

	echo "⚙️ 7. Configurando reglas udev táctiles, logo del sistema (/usr/share/pixmaps/kinder-logo.svg), grupos y servicios..."
	if [[ -f "$dotfiles_dir/os/linux/branding/logo.svg" ]]; then
		sudo mkdir -p /usr/share/pixmaps /usr/share/icons/hicolor/scalable/apps
		sudo cp "$dotfiles_dir/os/linux/branding/logo.svg" /usr/share/pixmaps/kinder-logo.svg
		sudo cp "$dotfiles_dir/os/linux/branding/logo.svg" /usr/share/icons/hicolor/scalable/apps/kinder-logo.svg
	fi
	if [[ -f "$dotfiles_dir/os/linux/udev/rules.d/70-raydium-touchscreen.rules" ]]; then
		sudo mkdir -p /etc/udev/rules.d
		sudo cp "$dotfiles_dir/os/linux/udev/rules.d/70-raydium-touchscreen.rules" /etc/udev/rules.d/70-raydium-touchscreen.rules
		sudo udevadm control --reload-rules 2>/dev/null || true
		sudo udevadm trigger 2>/dev/null || true
	fi

	for grp in input video audio seat wheel network; do
		if getent group "$grp" &>/dev/null; then
			sudo usermod -aG "$grp" "$USER" 2>/dev/null || true
		fi
	done

		for dm in ly@tty2.service ly.service gdm.service sddm.service lightdm.service; do
			if systemctl is-enabled "$dm" &>/dev/null; then
				sudo systemctl disable "$dm" 2>/dev/null || true
			fi
		done
		sudo systemctl set-default graphical.target 2>/dev/null || true
		sudo systemctl enable --now NetworkManager bluetooth iio-sensor-proxy 2>/dev/null || true
		sudo systemctl enable seatd 2>/dev/null || true
		sudo systemctl enable --force greetd.service 2>/dev/null || true

		# En una TTY limpia sin sesión gráfica o sin bus systemd --user activo, creamos los enlaces
		# directamente en ~/.config/systemd/user/{graphical-session.target.wants,niri.service.wants}/
		# además de llamar a `dms systemd enable --compositor niri` y `systemctl --user`.
		mkdir -p "$HOME/.config/systemd/user/graphical-session.target.wants" \
			"$HOME/.config/systemd/user/niri.service.wants"
		ln -sf "$HOME/.config/systemd/user/niri-touch-gestures.service" \
			"$HOME/.config/systemd/user/graphical-session.target.wants/niri-touch-gestures.service"
		if [[ -f /usr/lib/systemd/user/dms.service ]]; then
			ln -sf /usr/lib/systemd/user/dms.service \
				"$HOME/.config/systemd/user/graphical-session.target.wants/dms.service"
			ln -sf /usr/lib/systemd/user/dms.service \
				"$HOME/.config/systemd/user/niri.service.wants/dms.service"
		fi
		if command -v dms &>/dev/null; then
			dms systemd enable --compositor niri 2>/dev/null || true
			dms auth resolve-lock --quiet 2>/dev/null || true
			if [[ -f "$HOME/.config/dms/plugins.lock.json" ]]; then
				dms plugins restore 2>/dev/null || true
			fi
		fi
		if command -v zsh &>/dev/null && [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
			sudo chsh -s "$(command -v zsh)" "$USER" 2>/dev/null || true
		fi
		if command -v systemctl &>/dev/null; then
			systemctl --user daemon-reload 2>/dev/null || true
			systemctl --user enable niri-touch-gestures.service 2>/dev/null || true
			systemctl --user enable dms.service 2>/dev/null || true
		fi

	if command -v voxtype &>/dev/null; then
		echo "🎙️ 7b. Configurando Voxtype (aceleración GPU Vulkan, modelo parakeet-ultra-Q8_0.gguf y servicio systemd)..."
		sudo voxtype setup gpu --enable 2>/dev/null || true
		if [[ ! -f "$HOME/.local/share/voxtype/models/parakeet-ultra-Q8_0.gguf" ]]; then
			voxtype setup --download --model parakeet-ultra-Q8_0.gguf --no-post-install || true
		fi
		if [[ -f /usr/lib/systemd/user/voxtype.service ]]; then
			ln -sf /usr/lib/systemd/user/voxtype.service \
				"$HOME/.config/systemd/user/graphical-session.target.wants/voxtype.service"
		fi
		if command -v systemctl &>/dev/null; then
			systemctl --user daemon-reload 2>/dev/null || true
			systemctl --user enable --now voxtype.service 2>/dev/null || systemctl --user enable voxtype.service 2>/dev/null || true
		fi
	fi

	echo "🖥️ 8. Configurando greetd + tuigreet desde os/linux/greetd/config.toml..."
	sudo mkdir -p /etc/greetd
	if [[ -f "$dotfiles_dir/os/linux/greetd/config.toml" ]]; then
		sudo cp "$dotfiles_dir/os/linux/greetd/config.toml" /etc/greetd/config.toml
	else
		sudo tee /etc/greetd/config.toml >/dev/null <<'EOF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --cmd niri-session"
user = "greeter"
EOF
	fi

	echo "🎨 9. Configurando tema oscuro GTK/GSettings (con fallback dbus-run-session para TTY), directorios y fondo #000000..."
	mkdir -p "$HOME/Work" "$HOME/Proyectos" "$HOME/Notas" \
		"$HOME/Notas/inbox" "$HOME/Notas/journal" "$HOME/Notas/projects" "$HOME/Notas/templates" "$HOME/Notas/zettelkasten" \
		"$HOME/Imágenes/Wallpapers" "$HOME/Imágenes/Profiles" "$HOME/Imágenes/Capturas" \
		"$HOME/.config/niri" "$HOME/.config/niri/dms" "$HOME/.config/dms/themes" "$HOME/.config/ghostty" \
		"$HOME/.config/alacritty" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" \
		"$HOME/.config/herdr" "$HOME/.local/bin" "$HOME/.local/share/icons" "$HOME/.local/state/dms"
	touch "$HOME/.config/dms/.firstlaunch" "$HOME/.config/niri/dms/outputs.kdl"

	if command -v xdg-user-dirs-update &>/dev/null; then
		xdg-user-dirs-update 2>/dev/null || true
	fi

	if command -v gtk4-update-icon-cache &>/dev/null && [[ -d "$HOME/.local/share/icons/Adwaita-Magenta" ]]; then
		gtk4-update-icon-cache -f -t "$HOME/.local/share/icons/Adwaita-Magenta" 2>/dev/null || true
	fi

	if command -v gsettings &>/dev/null; then
		if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
			gsettings set org.gnome.desktop.interface color-scheme prefer-dark 2>/dev/null || true
			gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font Mono 10" 2>/dev/null || true
			gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Nerd Font Mono 10" 2>/dev/null || true
			gsettings set org.gnome.desktop.interface icon-theme "Adwaita-Magenta" 2>/dev/null || true
		elif command -v dbus-run-session &>/dev/null; then
			dbus-run-session -- sh -c '
				gsettings set org.gnome.desktop.interface color-scheme prefer-dark
				gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font Mono 10"
				gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Nerd Font Mono 10"
				gsettings set org.gnome.desktop.interface icon-theme "Adwaita-Magenta"
			' 2>/dev/null || true
		fi
	fi

	echo "🌐 9b. Asignando Ardia como navegador predeterminado del sistema..."
	if command -v xdg-settings &>/dev/null && [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
		xdg-settings set default-web-browser ardia.desktop 2>/dev/null || true
	fi
	if command -v xdg-mime &>/dev/null; then
		for mime in text/html application/xhtml+xml x-scheme-handler/http x-scheme-handler/https x-scheme-handler/about x-scheme-handler/unknown; do
			xdg-mime default ardia.desktop "$mime" 2>/dev/null || true
		done
	fi

	local dms_session_file="$HOME/.local/state/dms/session.json"
	if [[ ! -f "$dms_session_file" ]]; then
		cat >"$dms_session_file" <<'EOF'
{
  "wallpaperPath": "#000000",
  "configVersion": 7
}
EOF
	elif command -v python3 &>/dev/null; then
		python3 - "$dms_session_file" <<'PY' || true
import json, sys
path = sys.argv[1]
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
except Exception:
    data = {"configVersion": 7}
data["wallpaperPath"] = "#000000"
data.setdefault("configVersion", 7)
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
	fi

	echo "✅ Instalación y restauración completa de aplicaciones, Ardia, Herdr TUI, HEY CLI, FirefoxPWA y escritorio Niri + DMS finalizada."
}

install_niri_system
