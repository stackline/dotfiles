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

-- nvim-treesitter's `main` branch doesn't enable highlighting or indentation by itself,
-- so set them up per buffer.
-- pcall skips filetypes without an installed parser.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end

    -- Starting treesitter turns off regex syntax, which the built-in indent scripts of
    -- some filetypes depend on. Use treesitter indent where an `indents` query exists;
    -- otherwise keep the built-in one.
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.query.get(lang, 'indents') then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
