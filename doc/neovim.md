# Documentación de Neovim (KinderVim / Omarchy)

Guía completa de la configuración de Neovim sincronizada entre `~/.config/nvim` y `~/.dotfiles/editors/vim`.

---

## 1. Arquitectura y Organización

La configuración utiliza **LazyVim** como base modular sobre Neovim 0.10+ en macOS. Los archivos se estructuran de la siguiente manera:

```
editors/vim/ (sincronizado con ~/.config/nvim/)
├── init.lua                        # Punto de entrada (bootstrap lazy.nvim)
├── lazy-lock.json                  # Lockfile de versiones exactas de plugins
├── lazyvim.json                    # Configuración de extras de LazyVim
├── .neoconf.json                   # Configuración del servidor de lenguaje / proyecto
├── README.md                       # Resumen del setup
├── stylua.toml                     # Formateo de código Lua
├── spell/                          # Diccionarios ortográficos (en, es)
│   ├── en.utf-8.spl
│   ├── en_custom.txt
│   ├── en_words.txt
│   └── es_words.txt
├── plugin/
│   └── after/
│       └── transparency.lua        # Transparencia en tiempo real de floats y fondos
├── lua/
│   ├── config/
│   │   ├── autocmds.lua            # Autocomandos personalizados
│   │   ├── keymaps.lua             # Atajos de teclado generales
│   │   ├── lazy.lua                # Carga de plugins y extras de LazyVim
│   │   ├── logo.lua                # ASCII Art header para el dashboard
│   │   ├── options.lua             # Opciones globales de Vim
│   │   └── remote_clipboard.lua    # Portapapeles remoto OSC 52 / Wayland / tmux / SSH
│   ├── plugins/                    # Plugins activos
│   │   ├── ai.lua                  # Minuet-AI con modelos locales Ollama
│   │   ├── all-themes.lua          # 20+ coloreschemes disponibles
│   │   ├── antigravity.lua         # Integración IDE/CLI Antigravity
│   │   ├── calendar.lua            # Calendario integrado con notas diarias
│   │   ├── completion.lua          # Blink.cmp + LSP auto-imports
│   │   ├── dashboard-logo.lua      # Snacks dashboard con logo KinderVim
│   │   ├── disable-news-alert.lua  # Silencia avisos de LazyVim/Neovim news
│   │   ├── example.lua             # Referencia de configuración de plugins
│   │   ├── luasnip.lua             # Motor de snippets multi-fuente
│   │   ├── obsidian.lua            # Bóveda de Obsidian en disco externo
│   │   ├── omarchy-theme-hotreload.lua # Recarga de temas en caliente
│   │   ├── render-markdown.lua     # Renderizado visual enriquecido de Markdown
│   │   ├── snacks-animated-scrolling-off.lua # Desactiva animaciones de scroll
│   │   └── surround.lua            # nvim-surround para manipular delimitadores
│   └── legacy_plugins/             # Plugins anteriores archivados para referencia
```

---

## 2. Bóveda Obsidian y Gestión del Conocimiento

La configuración de Obsidian (`lua/plugins/obsidian.lua`) está diseñada según los estándares de `AGENTS.md`:

- **Bóveda Única:** Ubicada en el disco externo: `/Volumes/Files/notes`.
- **Subdirectorio de Notas:** `zettelkasten`.
- **Identificador de Notas (`note_id_func`):** Genera formato `<TIMESTAMP>-<TITULO/SLUG>` (o 4 letras aleatorias si no hay título).
- **Frontmatter Estructurado:** Genera y mantiene campos estándar (`id`, `description`, `events`, `aliases`, `tags`).
- **Lazy Loading Estricto:** Los eventos de buffer (`BufReadPre`, `BufNewFile`) únicamente se disparan dentro de `/Volumes/Files/notes/`.

### Atajos de Obsidian

| Atajo | Comando / Función | Descripción |
|---|---|---|
| `<leader>ow` | `:Obsidian workspace` | Cambiar de bóveda (Workspace) |
| `<leader>of` | `:Obsidian quick_switch` | Búsqueda rápida por título / alias |
| `<leader>os` | `:Obsidian search` | Grep completo dentro de notas |
| `<leader>on` | `:Obsidian new` | Crear nueva nota Zettelkasten |
| `<leader>od` | `:Obsidian today` | Abrir o crear nota diaria de hoy |
| `<leader>oy` | `:Obsidian yesterday` | Nota diaria de ayer |
| `<leader>om` | `:Obsidian tomorrow` | Nota diaria de mañana |
| `<leader>oc` | `:Calendar` | Calendario interactivo de notas diarias |
| `<leader>ot` | `:Obsidian tags` | Buscar notas por etiqueta (`#tag`) |
| `<leader>ob` | `:Obsidian backlinks` | Ver referencias entrantes (Backlinks) |
| `<leader>ox` | `:Obsidian toggle_checkbox`| Alternar casilla `[ ]` / `[x]` |
| `<leader>oo` | `:Obsidian open` | Abrir nota en Obsidian Desktop |
| `<leader>op` | `:Obsidian template` | Insertar plantilla Markdown |
| `<leader>oi` | `:Obsidian paste_img` | Pegar imagen en `assets/` desde portapapeles |
| `<leader>ol` (visual) | `:Obsidian link` | Convertir texto seleccionado en enlace |
| `<leader>onl` (visual)| `:Obsidian link_new` | Crear y vincular nueva nota desde texto |

---

## 3. Calendario Interactivo con Notas Diarias

El archivo `lua/plugins/calendar.lua` integra `itchyny/calendar.vim` directamente con el flujo de notas diarias de Obsidian:

- Abre `/Volumes/Files/notes/journal/YYYY-MM-DD.md` al pulsar `<CR>`, `o` o doble clic sobre cualquier día del calendario.
- Si el archivo del día no existe, lo inicializa automáticamente aplicando la plantilla `/Volumes/Files/notes/templates/plantilla-diaria.md` sustituyendo variables `{{date}}`, `{{title}}`, `{{id}}`.

---

## 4. Inteligencia Artificial

### Minuet AI (`lua/plugins/ai.lua`)
- Conecta con **Ollama** local (`http://localhost:11434/v1/completions`) mediante la API compatible OpenAI FIM.
- Selección inteligente de modelos según el tipo de archivo:
  - Markdown, texto o Neorg: `llama3.1:8b`
  - Código (Lua, JS, TS, PHP, Python): `qwen2.5-coder:7b`
- Atajos de Ghost Text: `<Tab>` para aceptar, `<C-e>` para descartar.

### Google Antigravity (`lua/plugins/antigravity.lua`)
- Integra terminal y split interactivo con Antigravity:
  - `<leader>aa`: Abrir/Cerrar terminal de Antigravity en split vertical.
  - `<leader>af`: Abrir/Cerrar Antigravity en ventana flotante.
  - `<leader>ac`: Enviar archivo actual al contexto de Antigravity.
  - `<leader>as` (visual): Enviar bloque de código seleccionado a Antigravity.

---

## 5. Autocompletado, Snippets y LSP

### Blink.cmp (`lua/plugins/completion.lua`)
- Autocompletado ultrarrápido con mapeo `super-tab`.
- Menús y documentación con bordes redondeados (`rounded`).
- Texto fantasma (`ghost_text`) activo.

### LuaSnip (`lua/plugins/luasnip.lua`)
- Carga de snippets en cascada:
  1. Estándar: `friendly-snippets` (comunidad).
  2. Globales de usuario: `~/.config/nvim/snippets/`.
  3. Locales del proyecto: carpetas `./.luasnip` o `./.snippets`.
  4. Formato VSCode del proyecto: `./.vscode`.

### Servidores LSP y Auto-Imports
- **PHP:** `intelephense` configurado con `insertUseDeclaration = true`.
- **JS / TS / Vue:** `vtsls` configurado con `autoImports = true`.
- **HTML / CSS / Plantillas:** `emmet_language_server`.

---

## 6. Temas y Transparencia

- **Hot-Reload (`lua/plugins/omarchy-theme-hotreload.lua`):** Al cambiar de tema, se invalidan los módulos cargados y se reaplica el tema seleccionado instantáneamente.
- **Transparencia (`plugin/after/transparency.lua`):** Retira fondos opacos en Normal, NormalFloat, FloatBorder, Pmenu, NeoTree, Telescope y Notify.
- **20+ Temas Instalados (`lua/plugins/all-themes.lua`):** bamboo, aether, ethereal, hackerman, vantablack, white, catppuccin, everforest, flexoki, gruvbox, kanagawa, matteblack, monokai-pro, nightfox, rose-pine, ashen, tokyonight, miasma, retro-82, lumon.

---

## 7. Renderizado Markdown (`lua/plugins/render-markdown.lua`)

- Iconos numéricos en títulos (`󰲡 `, `󰲣 `, `󰲥 `, etc.).
- Casillas personalizadas (`󰄱 `, `󰄵 `).
- Tablas ASCII con bordes destacados (`heavy`).
- Callouts nativos GitHub: `[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`.
- Anti-conceal para editar cómodamente bajo el cursor.

---

## 8. Revisión de Elementos Pendientes por Importar

Los siguientes componentes estaban presentes en la versión anterior (`lua/legacy_plugins/`) o en los scripts de dotfiles y son candidatos recomendados para ser importados o activados:

### A. Plugins Recomendados para Reactivar
1. **`oil.nvim` (`lua/legacy_plugins/oil.lua`):**
   Explorador de archivos que permite editar directorios como si fuesen buffers de texto. Incluye atajos `-` y `<leader>E`.
2. **`nvim-rip-substitute` (`lua/legacy_plugins/rip.lua`):**
   Reemplazo y búsqueda interactiva con expresiones regulares en vivo.
3. **`goto-preview` (`lua/legacy_plugins/editor.lua`):**
   Previsualización flotante de definiciones y referencias (`gpd`, `gpi`, `gpr`) sin perder el cursor del archivo actual.
4. **`screenkey.nvim` (`lua/legacy_plugins/screenkey.lua`):**
   Muestra las teclas pulsadas en pantalla (`<leader>uk`), ideal para screencasts o pair-programming.
5. **`git.nvim` (`lua/legacy_plugins/editor.lua`):**
   Git blame en ventana flotante (`<leader>gb`) y abrir archivo en GitHub/GitLab (`<leader>go`).
6. **`nvim-dap` (`lua/legacy_plugins/nvim-dap.lua`):**
   Depurador visual (DAP) para Node.js, TypeScript y PHP.

### B. Atajos de Teclado Útiles (`lua/config/keymaps.lua`)
La versión anterior contaba con atajos altamente prácticos que pueden importarse a `lua/config/keymaps.lua`:
- `<leader>bq`: Cerrar todos los buffers abiertos excepto el actual.
- `<C-s>`: Guardar archivo actual con notificación de estado limpia.
- `<leader>sg` / `<leader>sG` (modo visual): Grep automático del texto seleccionado en el proyecto o raíz git.
- `<leader>md`: Limpiar todas las marcas locales y globales.
- Navegación fluida de paneles Tmux (`<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`).

### C. Gestión de Enlaces Simbólicos en Dotfiles
En `~/.dotfiles/symlinks/conf.macos.yaml` (o `conf.yaml`), agregar el enlace:
```yaml
- link:
    ~/.config/nvim: editors/vim
```
Esto permite que Dotbot / Dotly mantenga `~/.config/nvim` apuntando directamente a `~/.dotfiles/editors/vim`, eliminando la necesidad de sincronización manual entre ambas carpetas.
