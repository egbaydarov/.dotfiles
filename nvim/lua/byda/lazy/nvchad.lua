return {
    {
      "nvchad/base46",
      lazy = false,
      build = function()
        require("base46").load_all_highlights()
      end,
    },
    {
      "nvchad/ui",
      lazy = false,
      config = function()
        require "nvchad"
      end,
    },
    {
      "nvzone/volt",
      lazy = false,
    },
    {
      "nvzone/menu",
      lazy = false,
    },
    {
      "nvzone/minty",
      lazy = false,
      cmd = { "Huefy", "Shades" }
    },
    {
      "nvim-tree/nvim-web-devicons",
      lazy = false,
      opts = function()
        dofile(vim.g.base46_cache .. "devicons")
        return { override = require "nvchad.icons.devicons" }
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      lazy = false,
      event = "User FilePost",
      opts = {
        indent = { char = "│", highlight = "IblChar" },
        scope = { char = "│", highlight = "IblScopeChar" },
      },
      config = function(_, opts)
        dofile(vim.g.base46_cache .. "blankline")

        local hooks = require "ibl.hooks"
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        require("ibl").setup(opts)

        dofile(vim.g.base46_cache .. "blankline")
      end,
    }
}
