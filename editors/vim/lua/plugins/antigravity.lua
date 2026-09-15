return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai (antigravity)", icon = "󰚩 " },
      },
    },
  },
  {
    dir = vim.fn.stdpath("config") .. "/lua/plugins/pi-togle.nvim",
    name = "pi-togle.nvim",
    cmd = { "AntigravityToggle", "AntigravityFloat", "AntigravitySendFile", "AntigravitySendSelection" },
    keys = {
      {
        "<leader>aa",
        function()
          require("pi-togle").toggle()
        end,
        desc = "Abrir/Cerrar Antigravity (Split)",
      },
      {
        "<leader>af",
        function()
          require("pi-togle").toggle_float()
        end,
        desc = "Abrir/Cerrar Antigravity (Flotante)",
      },
      {
        "<leader>ac",
        function()
          require("pi-togle").send_file()
        end,
        desc = "Enviar archivo actual a Antigravity",
      },
      {
        "<leader>as",
        function()
          require("pi-togle").send_selection()
        end,
        mode = "v",
        desc = "Enviar selección visual a Antigravity",
      },
    },
    opts = {
      split_direction = "vertical",
      command = "antigravity",
    },
    config = function(_, opts)
      require("pi-togle").setup(opts)
    end,
  },
}
