return {
  "andreakinder/agy-togle.nvim", -- The repository name remains unchanged
  config = function()
    require("antigravity").setup({
      split_direction = "vertical", -- optional: "vertical" (default) or "horizontal"
      keymap = "<leader>at", -- optional: customize the toggle keymap
    })
  end,
}
