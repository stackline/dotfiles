local ok, module = pcall(require, 'gitsigns')
if not ok then
  print('gitsigns.nvim is not loaded.')
  return
end

module.setup {
  -- NOTE: Make it easy to see git signs by making the vertical line text to thick.
  -- ref. https://github.com/lewis6991/gitsigns.nvim#usage
  signs = {
    add    = { hl = 'GitSignsAdd', text = '▌', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },

  -- Keymaps
  -- ref. https://github.com/lewis6991/gitsigns.nvim#keymaps
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })
  end
}
