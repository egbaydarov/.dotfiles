return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    triggers = {
      { "<none>" },
    }
 },
  keys = {
    {
      "<F4>",
      function()
        require("which-key").show({ global = true, loop = true })
      end,
      desc = "Keymaps (which-key)",
    },
  },
}
