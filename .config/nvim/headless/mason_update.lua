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
  local idx_width = #tostring(total)
  local max_name = 0
  for _, pkg in ipairs(packages) do
    if #pkg.name > max_name then max_name = #pkg.name end
  end

  for i, pkg in ipairs(packages) do
    local name = pkg.name
    local before = pkg:get_installed_version() or "?"
    pkg:install():once("closed", vim.schedule_wrap(function()
      local after = pkg:get_installed_version() or before
      local idx = string.format("[%0" .. idx_width .. "d/%0" .. idx_width .. "d]", i, total)
      local padded_name = name .. string.rep(" ", max_name - #name)
      if before ~= after then
        io.write(("%s %s %s -> %s\n"):format(idx, padded_name, before, after))
      else
        io.write(("%s %s (up-to-date) %s\n"):format(idx, padded_name, before))
      end
      io.flush()
      completed = completed + 1
      if completed >= total then
        vim.cmd("qall!")
      end
    end))
  end
end))
