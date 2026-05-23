-- Neovim 0.12 transparent UI module (no plugins)
-- Makes Neovim background transparent by clearing highlight backgrounds

local M = {}

---------------------------------------------------------------------
-- Groups that should NOT have background (main UI transparency)
---------------------------------------------------------------------
local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "EndOfBuffer",
  "FoldColumn",
  "VertSplit",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "WinSeparator",
}

---------------------------------------------------------------------
-- Optional: keep floating windows readable (recommended OFF if full transparency)
---------------------------------------------------------------------
local float_groups = {
  "NormalFloat",
  "FloatBorder",
  "Pmenu",
  "PmenuSel",
  "PmenuSbar",
  "PmenuThumb",
  "TelescopeNormal",
  "TelescopeBorder",
}

---------------------------------------------------------------------
-- Utility: clear background only
---------------------------------------------------------------------
local function clear_bg(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })

  if not ok then
    return
  end

  hl.bg = nil
  hl.ctermbg = nil

  vim.api.nvim_set_hl(0, group, hl)
end

---------------------------------------------------------------------
-- Apply transparency
---------------------------------------------------------------------
local function apply_transparency(opts)
  opts = opts or {}

  for _, group in ipairs(transparent_groups) do
    clear_bg(group)
  end

  if opts.floats then
    for _, group in ipairs(float_groups) do
      clear_bg(group)
    end
  end
end

---------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------
function M.setup(opts)
  opts = opts or {}

  apply_transparency(opts)

  vim.api.nvim_create_augroup("TransparentUI", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = "TransparentUI",
    callback = function()
      apply_transparency(opts)
    end,
  })
end

return M
