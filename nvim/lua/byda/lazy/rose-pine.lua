return {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
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

            CurSearch = { fg = "base", bg = "leaf", inherit = false },
            Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },

            StatusLine = { fg = "love", bg = "love", blend = 10 },
            StatusLineNC = { fg = "subtle", bg = "surface" },
        }
    },
    config = function(_, opts)
        -- Set highlights if needed
        require("rose-pine").setup(opts)

        -- Set colorscheme
        vim.cmd("colorscheme rose-pine-dawn")

        -- Status line configuration
        vim.opt.laststatus = 3 -- Global statusline
        vim.opt.statusline = " %f %m %= %l:%c ♥ "
    end
}
