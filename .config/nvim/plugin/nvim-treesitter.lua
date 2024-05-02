local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('nvim-treesitter is not loaded.')
  return
end

configs.setup {
  -- NOTE: It takes time to install all parsers, so be limited.
  ensure_installed = {
    'bash',
    'cue',
    'go',
    'graphql',
    'hcl',
    'javascript',
    'json',
    'json5',
    'kotlin',
    'lua',
    'markdown',
    'markdown_inline', -- Used by Lspsaga
    'prisma',
    'ruby',
    'tsx',
    'terraform',
    'typescript',
    'vim',
    'yaml',
  },

  highlight = {
    enable = true,                             -- false will disable the whole extension
    disable = {},                              -- list of language that will be disabled
    additional_vim_regex_highlighting = false, -- NOTE: Must be true when using vim-endwise
  },

  indent = {
    -- NOTE: If indent option is disabled, auto indentation of .tsx files
    -- doesn't work properly.
    enable = true,
    disable = {},
  },

  -- nvim-treesitter-endwise
  endwise = {
    enable = true,
  },

  -- nvim-ts-autotag
  autotag = {
    enable = true,
  },
}
