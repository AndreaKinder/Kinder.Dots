return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        {
          section = "terminal",
          cmd = "cat " .. vim.fn.expand("~/.config/branding/about.txt"),
          height = 23,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
