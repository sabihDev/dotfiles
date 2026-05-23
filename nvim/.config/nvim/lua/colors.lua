-- Neovim 0.12+
-- Creates :Colors command that opens a fuzzy picker for all installed colorschemes.
-- Uses the built-in vim.ui.select() interface, which in 0.12 can be backed by
-- the native fuzzy picker when:
--   vim.o.winborder = "rounded"
--   vim.ui.select = require("vim.ui").select
-- or when your preferred UI provider overrides vim.ui.select.

local function colorscheme_picker()
  -- Get all available colorscheme names from runtimepath
  local themes = vim.fn.getcompletion("", "color")

  -- Remove duplicates and sort
  local seen = {}
  local items = {}

  for _, name in ipairs(themes) do
    if not seen[name] then
      seen[name] = true
      table.insert(items, name)
    end
  end

  table.sort(items)

  -- Open fuzzy picker
  vim.ui.select(items, {
    prompt = "Select colorscheme:",
    kind = "colorscheme",
  }, function(choice)
    if not choice then
      return
    end

    -- Apply selected colorscheme safely
    local ok, err = pcall(vim.cmd.colorscheme, choice)
    if not ok then
      vim.notify(
        ("Failed to load colorscheme '%s': %s"):format(choice, err),
        vim.log.levels.ERROR
      )
    end
  end)
end

-- User command
vim.api.nvim_create_user_command("Colors", colorscheme_picker, {
  desc = "Fuzzy pick and apply a colorscheme",
})

-- Optional keymap
vim.keymap.set("n", "<leader>w", colorscheme_picker, {
  desc = "Pick colorscheme",
})

