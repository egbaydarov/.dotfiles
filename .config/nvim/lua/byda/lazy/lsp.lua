return {
  {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.config("lua_ls", {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },

              workspace = {
                library = {
                  -- This loads Neovim's runtime (including type definitions)
                  vim.fn.expand("$VIMRUNTIME/lua"),
                  vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                },
                checkThirdParty = false,
              },
            },
          },
        }) 
        vim.lsp.enable("lua_ls", {
          filetypes = { "lua" },
        })


        vim.lsp.config("gopls",{
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
        })
        vim.lsp.enable("gopls", { filetypes = { "go", "gomod" } })
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
