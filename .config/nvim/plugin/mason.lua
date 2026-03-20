require("mason").setup({
  ui = {
    -- Display single border on the UI window.
    border = "single",
  }
})

-- Managed packages.
-- Run :MasonInstallAll to install missing packages on demand.
local mason_packages = {
  "bash-language-server",
  "docker-compose-language-service",
  "gopls",
  "graphql-language-service-cli",
  "json-lsp",
  "kotlin-language-server",
  "lua-language-server",
  "prisma-language-server",
  "pyright",
  "terraform-ls",
  "vim-language-server",
  "yaml-language-server",
}

vim.api.nvim_create_user_command("MasonInstallAll", function()
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, name in ipairs(mason_packages) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        pkg:install()
        vim.notify("mason: installing " .. name, vim.log.levels.INFO)
      end
    end
  end)
end, { desc = "Install all missing Mason packages" })
