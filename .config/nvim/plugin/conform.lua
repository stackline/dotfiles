local ok, conform = pcall(require, 'conform')
if not ok then
  print('conform.nvim is not loaded.')
  return
end

conform.setup({
  formatters_by_ft = {
    -- Use a sub-list to run only the first available formatter
    javascript = { "prettier" },
    typescript = { "prettier" },
  },
  -- NOTE: Hit-enter prompt occurs when an error is notified, so disable notifying.
  notify_on_error = false,
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
