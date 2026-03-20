-- Headless script to update all installed Mason packages.
-- Usage: nvim --headless -c "luafile ~/.config/nvim/headless/mason_update.lua"
require("lazy").load({ plugins = { "mason.nvim" } })

local registry = require("mason-registry")

registry.refresh(vim.schedule_wrap(function()
  local packages = registry.get_installed_packages()
  local total = #packages

  if total == 0 then
    print("mason: no packages installed")
    vim.cmd("qall!")
    return
  end

  local completed = 0
  for _, pkg in ipairs(packages) do
    local name = pkg.name
    pkg:install():once("closed", vim.schedule_wrap(function()
      completed = completed + 1
      io.write(("[%d/%d] %s\n"):format(completed, total, name))
      io.flush()
      if completed >= total then
        vim.cmd("qall!")
      end
    end))
  end
end))
