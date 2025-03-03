return {
    "shaunsingh/solarized.nvim",
    name = "solarized-vim",
    opts = {
    },
    config = function(_, opts)
        vim.cmd("colorscheme solarized")

        -- Status line configuration
        vim.opt.laststatus = 3 -- Global statusline
        vim.opt.statusline = " %f %m %= %l:%c"
        vim.opt.pumblend = 0
    end
}
