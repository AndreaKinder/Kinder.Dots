# ⚡️ Kinder.Dots

<div align="center">

```
 ██╗  ██╗██╗███╗   ██╗██████╗ ███████╗██████╗   ██████╗  ██████╗ ████████╗███████╗
 ██║ ██╔╝██║████╗  ██║██╔══██╗██╔════╝██╔══██╗  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
 █████╔╝ ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝  ██║  ██║██║   ██║   ██║   ███████╗
 ██╔═██╗ ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗  ██║  ██║██║   ██║   ██║   ╚════██║
 ██║  ██╗██║██║ ╚████║██████╔╝███████╗██║  ██║  ██████╔╝╚██████╔╝   ██║   ███████║
 ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝  ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
```

**Entorno de desarrollo integral, modular y de alto rendimiento para macOS y Linux.**  
Construido sobre el framework [Dotly](https://github.com/CodelyTV/dotly), potenciado por Zsh + Zim, Neovim (LazyVim), Antigravity IDE, agentes de Inteligencia Artificial y automatizaciones con Raycast.

---

[![OS - macOS](https://img.shields.io/badge/OS-macOS%20(Apple%20Silicon%20%2F%20Intel)-blue?logo=apple&style=flat-square)](https://apple.com)
[![OS - Linux](https://img.shields.io/badge/OS-Linux-orange?logo=linux&style=flat-square)](https://kernel.org)
[![Shell - Zsh](https://img.shields.io/badge/Shell-Zsh%20%2B%20Zimfw-purple?logo=gnu-bash&style=flat-square)](https://www.zsh.org)
[![Editor - Neovim](https://img.shields.io/badge/Editor-Neovim%200.10%2B-brightgreen?logo=neovim&style=flat-square)](https://neovim.io)
[![IDE - Antigravity](https://img.shields.io/badge/IDE-Antigravity%20(Google%20AGY)-blueviolet?style=flat-square)](editors/antigravity)
[![Framework - Dotly](https://img.shields.io/badge/Dotfiles-Dotly-red?style=flat-square)](https://github.com/CodelyTV/dotly)
[![License - MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

</div>

---

## 📑 Tabla de Contenidos

1. [Visión General](#-visión-general)
2. [Estructura del Proyecto](#-estructura-del-proyecto)
3. [Instalación y Configuración](#-instalación-y-configuración)
4. [Componentes Principales](#-componentes-principales)
   - [Terminal & Shell (Zsh + Zim)](#1-terminal--shell-zsh--zim)
   - [Neovim (KinderVim / LazyVim)](#2-neovim-kindervim--lazyvim)
   - [Antigravity IDE](#3-antigravity-ide-google-agy)
   - [Skills & Agentes de IA](#4-skills--agentes-de-ia)
   - [Productividad y Raycast](#5-productividad-y-raycast)
   - [Gestión de Enlaces (Symlinks)](#6-gestión-de-enlaces-simbólicos-symlinks)
5. [Flujo de Trabajo y Atajos](#-flujo-de-trabajo-y-atajos)
6. [Seguridad y Variables de Entorno](#-seguridad-y-variables-de-entorno)
7. [Documentación Adicional](#-documentación-adicional)
8. [Licencia](#-licencia)

---

## 🌟 Visión General

**Kinder.Dots** es una configuración reproducible, centralizada y automatizada para gestionar la experiencia de desarrollo en cualquier máquina. Incluye:

- **Rendimiento extremo:** Carga de Zsh asíncrona optimizada mediante [Zimfw](https://github.com/zimfw/zimfw), con utilidades GNU priorizadas en `$PATH`.
- **Doble soporte de edición:**
  - **Neovim (LazyVim):** Configuración modal de última generación con soporte para Obsidian (Zettelkasten), Minuet AI (modelos locales Ollama), Blink.cmp y más de 20 temas dinámicos con hot-reload.
  - **Antigravity IDE:** Entorno VS Code personalizado para agentes de IA con sincronización de extensiones, parámetros de arranque y servidores MCP (Model Context Protocol).
- **Ecosistema de Habilidades para Agentes:** Directorio `skills/` enlazado a `~/.agents/skills/` que dota a los asistentes inteligentes de capacidades en Microsoft Foundry, Logseq (GTD y organización) e informes técnicos.
- **Automatización de macOS:** Scripts y extensiones para Raycast (exportación de notas Markdown a Apple Notes, extracción de eventos de calendario y atajos de lanzamiento en Ghostty).

---

## 📂 Estructura del Proyecto

```bash
~/.dotfiles/
├── assets/                  # Logotipo y recursos visuales
├── bin/                     # Enlaces y wrappers binarios con máxima prioridad en $PATH
├── doc/                     # Documentación, especificaciones y notas Zettelkasten
│   ├── AGENTS-StandardCommits.md  # Guía de commits convencionales para agentes
│   ├── neovim.md            # Documentación exhaustiva de Neovim
│   └── neo-notes/           # Bóveda y estructura de conocimiento
├── editors/                 # Configuraciones de editores e IDEs
│   ├── antigravity/         # Antigravity IDE (settings, argv, MCP, extensions)
│   ├── code/                # Ajustes para VS Code estándar
│   ├── sublime/             # Ajustes para Sublime Text
│   └── vim/                 # Configuración de Neovim (LazyVim) -> ~/.config/nvim
├── langs/                   # Configuraciones específicas por lenguaje (Python, JS, Java, PHP)
├── modules/
│   └── dotly/               # Submódulo del framework Dotly (CodelyTV)
├── os/                      # Configuraciones específicas por SO (macOS, Linux)
├── raycast/                 # Extensiones de Raycast (TypeScript / React)
│   └── exportar-notas/      # Extensión para exportar Markdown a Apple Notes
├── restoration_scripts/     # Scripts ejecutados durante la restauración en nuevas máquinas
├── scripts/                 # Scripts auxiliares y utilidades de automatización
│   ├── raycast/             # Script commands para Raycast (Ghostty, Apple Notes, Calendar)
│   └── surprise/            # Scripts interactivos (banner de bienvenida)
├── shell/                   # Configuración del entorno de consola
│   ├── aliases.sh           # Alias comunes y atajos de navegación/git
│   ├── exports.sh           # Variables de entorno globales, FZF y $PATH
│   ├── functions.sh         # Funciones interactivas (cdd, j, recent_dirs, greeting)
│   ├── init.sh              # Inicializador maestro (.env, exports, aliases, funciones)
│   ├── bash/                # Dotfiles para Bash (.bashrc, .bash_profile)
│   └── zsh/                 # Dotfiles para Zsh (.zshrc, .zimrc, keybindings, temas)
├── skills/                  # Agentes y habilidades de IA -> ~/.agents/skills
│   ├── goalmed-pdf-report/  # Generación de informes en PDF
│   ├── logseq-*/            # Suite de gestión del conocimiento y GTD en Logseq
│   └── microsoft-foundry/   # Ciclo de vida completo en Azure AI Foundry
└── symlinks/                # Definiciones de enlaces simbólicos (Dotbot / Dotly)
    ├── conf.yaml            # Enlaces globales multiplataforma
    ├── conf.macos.yaml      # Enlaces para macOS (Apple Silicon - /opt/homebrew)
    ├── conf.macos-intel.yaml# Enlaces para macOS (Intel - /usr/local)
    └── conf.linux.yaml      # Enlaces para distribuciones Linux
```

---

## 🚀 Instalación y Configuración

### 1. Clonar el repositorio

Clona el repositorio en `$HOME/.dotfiles` asegurando la descarga de los submódulos:

```bash
git clone --recursive https://github.com/AndreaKinder/Kinder.Dots.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
```

Si ya lo habías clonado sin submódulos:

```bash
git submodule update --init --recursive modules/dotly
```

### 2. Ejecutar el instalador de Dotly

```bash
DOTFILES_PATH="$HOME/.dotfiles" DOTLY_PATH="$DOTFILES_PATH/modules/dotly" "$DOTLY_PATH/bin/dot" self install
```

### 3. Aplicar enlaces simbólicos

Aplica los symlinks según la configuración de tu sistema operativo:

```bash
dot symlinks apply
```

### 4. Configurar variables de entorno

Copia la plantilla `.env.example` y edita tus claves privadas (este archivo está ignorado por Git):

```bash
cp .env.example .env
chmod 600 .env
```

Define tus variables en `.env`:
- `OLLAMA_HOST`: Dirección del host de Ollama (`127.0.0.1` o IP de red local).
- Claves de API (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`, `GITHUB_TOKEN`).

---

## 🧩 Componentes Principales

### 1. Terminal & Shell (Zsh + Zim)

- **Framework:** Basado en **Zimfw**, ofreciendo arranque casi instantáneo.
- **Autocompletado y Resaltado:** Resaltado sintáctico con `ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)` y sugerencias asíncronas (`ZSH_AUTOSUGGEST_USE_ASYNC=true`).
- **Tema y Banner:** Prompt temático de Codely/Kinder y saludo interactivo `kinder_greeting` al abrir cada sesión.
- **Búsqueda Difusa (fzf):** Paleta adaptada al modo oscuro de Gruvbox/Codely (`FZF_DEFAULT_OPTS`).
- **Navegación Inteligente:**
  - `cdd`: Navegar interactivamente mediante `fzf` entre subdirectorios.
  - `j <directorio>`: Salto rápido mediante `z`.
  - `recent_dirs`: Historial de carpetas recientes con selector `fzf`.

### 2. Neovim (KinderVim / LazyVim)

Configurado en `editors/vim` y enlazado simbólicamente a `~/.config/nvim`:

- **Gestor de plugins:** [Lazy.nvim](https://github.com/folke/lazy.nvim) con lockfile estricto (`lazy-lock.json`).
- **IA integrada:**
  - **Minuet AI:** Soporte para completion con modelos locales de Ollama (`qwen2.5-coder:7b` para código, `llama3.1:8b` para Markdown/texto).
  - **Antigravity Integration:** Splits verticales, ventanas flotantes e inserción contextual directa de código hacia el CLI de Antigravity.
- **Obsidian & Zettelkasten:** Integración completa con la bóveda de notas (`/Volumes/Files/notes`), generación automática de IDs (`<TIMESTAMP>-<SLUG>`), frontmatter estructurado y calendario interactivo sincronizado con notas diarias.
- **Temas y Estilo:** Más de 20 paletas de color con recarga en caliente instantánea (`omarchy-theme-hotreload.lua`), fondos transparentes automáticos y renderizado enriquecido de Markdown (`render-markdown.lua`).
- **Consulte más detalles:** [`doc/neovim.md`](file:///Users/andrea/.dotfiles/doc/neovim.md).

### 3. Antigravity IDE (Google AGY)

Configurado en `editors/antigravity`:

- **Ajustes:** `settings.json` enlazado con la ruta de configuración del usuario en macOS (`~/Library/Application Support/Antigravity IDE/User/settings.json`) o Linux.
- **Servidores MCP:** Configuración en `mcp_config.json` para conectar servidores Model Context Protocol (por ejemplo, conexión remota por SSH a Raspberry Pi `pi` para el servicio Engram).
- **Restauración de Extensiones:** Lista exhaustiva de extensiones en `extensions.txt`. Para restaurarlas en un nuevo equipo:
  ```bash
  while IFS= read -r ext; do
    [ -n "$ext" ] && antigravity-ide --install-extension "$ext"
  done < editors/antigravity/extensions.txt
  ```

### 4. Skills & Agentes de IA

Los dotfiles enlazan el directorio `skills/` directamente a `~/.agents/skills/`, permitiendo compartir capacidades entre agentes de codificación y modelos autónomos:

| Skill | Descripción |
|---|---|
| [`microsoft-foundry`](file:///Users/andrea/.dotfiles/skills/microsoft-foundry) | Despliegue, evaluación, gestión de modelos, cuotas y RBAC en Azure AI Foundry. |
| [`logseq-dashboard-file-graph`](file:///Users/andrea/.dotfiles/skills/logseq-dashboard-file-graph) | Generación de tableros de control con queries avanzadas para Logseq. |
| [`logseq-gtd-contexts`](file:///Users/andrea/.dotfiles/skills/logseq-gtd-contexts) | Flujo de trabajo GTD (Getting Things Done) basado en contextos para Logseq. |
| [`logseq-gtd-project-pages`](file:///Users/andrea/.dotfiles/skills/logseq-gtd-project-pages) | Creación y administración de páginas de proyectos GTD. |
| [`logseq-inbox-capture`](file:///Users/andrea/.dotfiles/skills/logseq-inbox-capture) & [`triage`](file:///Users/andrea/.dotfiles/skills/logseq-inbox-triage) | Captura y procesamiento sistemático de la bandeja de entrada. |
| [`logseq-weekly-review`](file:///Users/andrea/.dotfiles/skills/logseq-weekly-review) | Plantilla y checklist automatizado para revisiones semanales. |
| [`goalmed-pdf-report`](file:///Users/andrea/.dotfiles/skills/goalmed-pdf-report) | Generación estandarizada de informes de auditoría y documentación en PDF. |

### 5. Productividad y Raycast

- **Extensión Raycast (`raycast/exportar-notas`):**
  Desarrollada en React y TypeScript (`@raycast/api`). Permite seleccionar notas individuales o carpetas de Markdown completas y exportarlas manteniendo el formato a **Apple Notes**.
- **Raycast Script Commands (`scripts/raycast/`):**
  - `open-nvim.sh`: Lanza Neovim en una nueva ventana del emulador de terminal [Ghostty](https://ghostty.org).
  - `exportar-eventos-hoy.sh` / `exportar-eventos-fecha.sh`: Extrae eventos de la agenda de macOS para integrarlos en notas diarias.
  - `exportar-tareas-nota-diaria.sh`: Sincronización rápida de tareas pendientes.

### 6. Gestión de Enlaces Simbólicos (Symlinks)

Los enlaces se definen en la carpeta `symlinks/`:
- `conf.yaml`: Enlaces de shell (`.zshrc`, `.bashrc`, `.zimrc`, etc.), Neovim (`~/.config/nvim`) y Skills (`~/.agents/skills`).
- `conf.macos.yaml` / `conf.macos-intel.yaml`: Configuración de paquetes GNU (`bash`, `date`, `find`, `make`, `sed`, `touch`, `zsh`) sobreescribiendo las versiones desactualizadas de macOS en `~/bin`, y ajustes de usuario de Antigravity IDE.
- `conf.linux.yaml`: Enlaces específicos para rutas Linux estándar.

---

## ⌨️ Flujo de Trabajo y Atajos

### Aliases de Navegación y Utilidades

| Alias | Comando Ejecutado | Acción |
|---|---|---|
| `..` / `...` | `cd ..` / `cd ../..` | Subir uno o dos niveles de directorio |
| `~` | `cd ~` | Ir al directorio personal |
| `dotfiles` | `cd $DOTFILES_PATH` | Acceder rápidamente a este repositorio |
| `ll` / `la` | `ls -l` / `ls -la` | Listar archivos con detalle |
| `up` | `dot package update_all` | Actualizar todos los paquetes y gestores |
| `k` | `kill -9` | Matar proceso de forma forzada |
| `o.` | `open .` (macOS) / `xdg-open .` (Linux) | Abrir directorio actual en el explorador gráfico |
| `c.` | `code $PWD` | Abrir directorio actual en VS Code |
| `i.` | `idea $PWD` | Abrir directorio actual en IntelliJ IDEA |

### Aliases de Git

| Alias | Descripción |
|---|---|
| `gs` | `git status -sb` (estado compacto) |
| `gaa` | `git add -A` (añadir todo) |
| `gc` | `$DOTLY_PATH/bin/dot git commit` (asistente interactivo de commit) |
| `gca` | `git commit --amend --no-edit` |
| `gco` | `git checkout` |
| `gd` | `$DOTLY_PATH/bin/dot git pretty-diff` (diff interactivo con fzf) |
| `gl` | `$DOTLY_PATH/bin/dot git pretty-log` (historial enriquecido) |
| `gf` | `git fetch --all -p` |
| `gpl` | `git pull --rebase --autostash` |
| `gps` | `git push` |
| `gpsf`| `git push --force` |

---

## 🔐 Seguridad y Variables de Entorno

Este repositorio está protegido contra fugas involuntarias de secretos:

1. **Ignorados por Git:** El archivo `.gitignore` excluye activamente archivos `.env`, `.env.local`, claves SSH/GPG y credenciales de nube.
2. **Carga Segura:** `shell/init.sh` carga de forma limpia las variables declaradas en `.env` y `.env.local` si existen en el sistema.
3. **Uso de `.env.example`:** Utiliza siempre la plantilla provista para compartir la estructura de nuevas variables sin exponer valores confidenciales.

---

## 📚 Documentación Adicional

- 📝 [Documentación completa de Neovim](file:///Users/andrea/.dotfiles/doc/neovim.md): Atajos de Obsidian, servidores LSP, Minuet AI, snippets y temas.
- 🤖 [Estándar de Commits para Agentes](file:///Users/andrea/.dotfiles/doc/AGENTS-StandardCommits.md): Convenciones semánticas obligatorias (`feat`, `fix`, `refactor`, `chore`, etc.).
- 🛠️ [Guía de Antigravity IDE](file:///Users/andrea/.dotfiles/editors/antigravity/README.md): Gestión de ajustes de usuario, parámetros de arranque y extensiones.

---

## 📄 Licencia

Distribuido bajo la Licencia **MIT**. Consulta [`LICENSE`](file:///Users/andrea/.dotfiles/LICENSE) para más información.
