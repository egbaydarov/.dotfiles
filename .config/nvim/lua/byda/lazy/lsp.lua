return {
  {
    "neovim/nvim-lspconfig",
    config = function()
        -- require("lspconfig").lua_ls.setup {}
        require("lspconfig").csharp_ls.setup {}
        require("lspconfig").gopls.setup {
           on_attach = on_attach,
           capabilities = capabilities,
           settings = {
             gopls = {
               completeUnimported = true,
               usePlaceholders = true,
               analyses = {
                 unusedparams = true,
               }
             }
           }
        }
    end 
  },
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          --lua = { "stylua" },
          go = { "gofmt" },
          --python = { "isort", "black" },
          --rust = { "rustfmt", lsp_format = "fallback" },
          --javascript = { "prettierd", "prettier", stop_after_first = true },
        },
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end
  }
}
