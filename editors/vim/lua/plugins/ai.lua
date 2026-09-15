return {
  "milanglacier/minuet-ai.nvim",
  event = "InsertEnter",
  opts = {
    provider = "openai_fim_compatible",
    provider_options = {
      openai_fim_compatible = {
        api_key = "TERM",
        name = "Ollama",
        end_point = "http://localhost:11434/v1/completions",
        -- Esta función determina qué modelo usar según el archivo
        model = function()
          local ft = vim.bo.filetype
          if ft == "markdown" or ft == "text" or ft == "norg" then
            return "llama3.1:8b"
          else
            return "qwen2.5-coder:7b"
          end
        end,
      },
    },
    virtualtext = {
      -- Activar en todos los tipos de archivos de código y notas
      auto_trigger_ft = { "markdown", "text", "norg", "lua", "javascript", "typescript", "php", "python" },
      keymap = {
        accept = "<Tab>",
        dismiss = "<C-e>",
      },
    },
    -- Optimizaciones para no saturar tu RAM
    request_timeout = 2,
    context_window = {
      buffer = {
        max_lines = 30, -- Suficiente para contexto sin latencia excesiva
      },
    },
  },
}
