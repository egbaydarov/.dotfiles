return {
{
    'hrsh7th/nvim-cmp',
    event = "InsertEnter", -- Load on entering insert mode
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip', -- Optional: For LuaSnip support
      'L3MON4D3/LuaSnip', -- Optional: LuaSnip for snippets
    },
    config = function()
      -- Set up nvim-cmp
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For LuaSnip support
          end,
        },
        mapping = {
          ['<C-S>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })
      -- Enable LSP capabilities for nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require('lspconfig').pyright.setup({
        capabilities = capabilities,
      })
    end,
  }}
