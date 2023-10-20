local ok, cmp = pcall(require, 'cmp')
if not ok then
  print('nvim-cmp is not loaded.')
  return
end

-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- luasnip setup
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

-- nvim-cmp setup
--
-- NOTE: The following options are set to behave like the completion function of vscode.
--
-- * completion
--   * completeopt
-- * mapping
--   * <C-p>, <C-n>, <Tab>, <S-Tab>
--
cmp.setup {
  completion = {
    completeopt = 'menuone,noinsert'
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    -- <C-p>, <C-n>: Do not insert text when selecting completion candidates,
    -- just like when clicking <Down> key.
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- NOTE: Separate behavior with tab key and enter key.
    --   "TAB"   key: Accept selected completion item.
    --   "ENTER" key: Insert a line break.
    --
    -- ['<CR>'] = cmp.mapping.confirm {
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- },
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
  -- Display the icon and the source of completion to completion-menu.
  -- ref. https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      })
    }),
  }
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
local custom_mapping = cmp.mapping.preset.cmdline()
custom_mapping['<Tab>'] = cmp.mapping.confirm()

cmp.setup.cmdline(':', {
  -- mapping = cmp.mapping.preset.cmdline(),
  mapping = custom_mapping,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  -- ref. https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-cmdline-completion-for-certain-commands-such-as-increname
  enabled = function()
    -- Disable completion for specific commands.
    local cmd = vim.fn.getcmdline()
    return (cmd:match("w") == nil and cmd:match("q") == nil)
  end
})

