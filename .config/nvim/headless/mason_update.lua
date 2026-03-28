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

  for i, pkg in ipairs(packages) do
    local name = pkg.name
    local before = pkg:get_installed_version() or "?"
    pkg:install():once("closed", vim.schedule_wrap(function()
      local after = pkg:get_installed_version() or before
      if before ~= after then
        io.write(("[%d/%d] %s: %s -> %s\n"):format(i, total, name, before, after))
      else
        io.write(("[%d/%d] %s: %s (up-to-date)\n"):format(i, total, name, before))
      end
      io.flush()
      completed = completed + 1
      if completed >= total then
        vim.cmd("qall!")
      end
    end))
  end
end))
