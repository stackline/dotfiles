if vim.fn['PlugIsNotInstalled']('nvim-cmp') then
  return
end

-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
--
-- NOTE: The following options are set to behave like the completion function of vscode.
--
-- * completion
--   * completeopt
-- * mapping
--   * <C-p>, <C-n>, <Tab>, <S-Tab>
--
local cmp = require 'cmp'
cmp.setup {
  completion = {
    completeopt = 'menuone,noinsert'
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    -- <C-p>, <C-n>: Do not insert text when selecting completion candidates,
    -- just like when clicking <Down> key.
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping.confirm(),
    ['<S-Tab>'] = cmp.mapping.confirm(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- add sources
    { name = 'buffer' },
    { name = 'path' },
  },
}
