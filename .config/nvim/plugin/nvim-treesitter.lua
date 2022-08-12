local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('nvim-treesitter is not loaded.')
  return
end

configs.setup {
  -- NOTE: It takes time to install all parsers, so be limited.
  ensure_installed = {
    'bash',
    'go',
    'graphql',
    'javascript',
    'json',
    'lua',
    'ruby',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    additional_vim_regex_highlighting = true, -- make vim-endwise work fine
  },
}
