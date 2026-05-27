return {
    {"pablopunk/pi.nvim"},
    {"andreakinder/pi-togle.nvim"},
  config = function()
    require("pi-togle").setup({
      split_direction = "vertical",
      keymap = "<leader>at",
    })
  end,
}
