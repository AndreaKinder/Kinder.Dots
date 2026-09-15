return {
  -- Configuración de Autocompletado Blink.cmp (Estilo Gentleman Programming)
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      snippets = {
        preset = "luasnip",
      },
      completion = {
        ghost_text = {
          enabled = true,
        },
        menu = {
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          window = {
            border = "rounded",
          },
        },
      },
    },
  },

  -- Configuración LSP para Auto-Imports de PHP (intelephense) y JS/TS/Vue (vtsls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              completion = {
                insertUseDeclaration = true,
                fullyQualifyGlobalConstantsAndFunctions = false,
              },
            },
          },
        },
        vtsls = {
          settings = {
            typescript = {
              suggest = {
                autoImports = true,
              },
            },
            javascript = {
              suggest = {
                autoImports = true,
              },
            },
          },
        },
        emmet_language_server = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
            "vue",
          },
        },
      },
    },
  },
}
