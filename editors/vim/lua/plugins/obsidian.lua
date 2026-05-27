return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      -- { name = "proyecto", path = "~/path/al/proyecto/docs" },
      { name = "goalmedFront", path = "/Users/andrea/Projects/work/goalmedFront/docs" },
      { name = "KinderDots", path = "/Users/andrea/.dotfiles/doc" },
    },
    log_level = vim.log.levels.INFO,
    completion = { nvim_cmp = false },
    ui = { enable = true },
    picker = {
      name = "telescope.nvim",
    },
  },
}
