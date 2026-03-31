local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then
  print('nvim-treesitter is not loaded.')
  return
end

-- Install parsers (no-op for already-installed ones; run :TSUpdate to update)
ts.install({
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
  'sql',
  'tsx',
  'terraform',
  'typescript',
  'vim',
  'yaml',
})
