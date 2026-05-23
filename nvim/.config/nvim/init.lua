require("vim._core.ui2").enable({})

require("options")
require("keymaps")
require("commands")
require("pack")

vim.cmd.colorscheme("rose-pine-moon")

require("transparency").setup({
  floats = true, -- set false for full “invisible UI” look
})
