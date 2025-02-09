return {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
        variant = "dawn",
        dark_variant = "dawn",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        highlight_groups = {
            TelescopeBorder = { fg = "overlay", bg = "overlay" },
            TelescopeNormal = { fg = "subtle", bg = "overlay" },
            TelescopeSelection = { fg = "text", bg = "highlight_med" },
            TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
            TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

            TelescopeTitle = { fg = "base", bg = "love" },
            TelescopePromptTitle = { fg = "base", bg = "pine" },
            TelescopePreviewTitle = { fg = "base", bg = "iris" },

            TelescopePromptNormal = { fg = "text", bg = "surface" },
            TelescopePromptBorder = { fg = "surface", bg = "surface" },

            CurSearch = { fg = "base", bg = "leaf", inherit = true },
            Search = { fg = "text", bg = "leaf", blend = 20, inherit = true },

            StatusLine = { fg = "love", bg = "love", blend = 10 },
            StatusLineNC = { fg = "subtle", bg = "surface" },
        },
        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },
        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },
        disable_background = true
    },
    config = function(_, opts)
        -- Set highlights if needed
        require("rose-pine").setup(opts)

        vim.cmd("colorscheme rose-pine-dawn")

        -- Status line configuration
        vim.opt.laststatus = 3 -- Global statusline
        vim.opt.statusline = " %f %m %= %l:%c ♥ "
        vim.opt.pumblend = 0
    end
}
