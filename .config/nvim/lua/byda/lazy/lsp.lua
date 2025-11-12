return {
  {
    "Decodetalkers/csharpls-extended-lsp.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
        -- require("lspconfig").lua_ls.setup {}
        vim.lsp.config("csharp_ls", {
           cmd = { "csharp-ls" },
           -- prefer .sln as project root
           root_dir = require('lspconfig').util.root_pattern("*.sln", "*.csproj", ".git"),
          handlers = {
            ["textDocument/definition"]     = require("csharpls_extended").handler,
            ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
          },
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
