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
  local results = {}

  for i, pkg in ipairs(packages) do
    local name = pkg.name
    local before = pkg:get_installed_version() or "?"
    pkg:install():once("closed", vim.schedule_wrap(function()
      local after = pkg:get_installed_version() or before
      if before ~= after then
        results[i] = ("[%d/%d] %s: %s -> %s\n"):format(i, total, name, before, after)
      else
        results[i] = ("[%d/%d] %s: %s (up-to-date)\n"):format(i, total, name, before)
      end
      completed = completed + 1
      -- \r returns cursor to line start, overwriting the previous progress text.
      io.write(("\rProcessing... [%d/%d]"):format(completed, total))
      io.flush()
      if completed >= total then
        -- \r\27[K: return to line start, then erase to end of line (ANSI ESC [K).
        io.write("\r\27[K")
        io.write(table.concat(results))
        io.flush()
        vim.cmd("qall!")
      end
    end))
  end
end))
