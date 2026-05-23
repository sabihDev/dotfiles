vim.pack.add({
	"https://github.com/bluz71/vim-moonfly-colors",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/AlexvZyl/nordic.nvim",
	"https://github.com/tiagovla/tokyodark.nvim",
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
	"https://github.com/obsidian-nvim/obsidian.nvim",
	'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})


--- mini files ---
local MiniFiles = require("mini.files")
MiniFiles.setup({
	mappings = {
		go_in = "<CR>",
		go_in_plus = "L",
		go_out = "_",
		go_out_plus = "H",
	},
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

--- mini notify ---
require("mini.notify").setup({
	content = {
		format = function(notif)
			return notif.msg
		end,
	},
})

--- mini cmdline completion ---
require("mini.cmdline").setup()

--- mini surround ---
require("mini.surround").setup()

--- mini pairs ---
require('mini.pairs').setup()

--- mini icons ---
require('mini.icons').setup()

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")

MiniExtra.setup()
MiniPick.setup()

--- keymaps ---
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
	{ desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions ---
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
	lsp_completion = {
		auto_setup = true,
		process_items = function(items, base)
			return MiniCompletion.default_process_items(items, base, {
				filterSort = "fuzzy",
			})
		end,
	},
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
	snippets = {
		MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
	},
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
	source = MiniDiff.gen_source.git({ index = false }),
})

--- nvim treesitter ---
require("treesitter")

--- nvim lsp ---
require("lsp")

--- colorscheme picker ---
require("colors")

--- colorscheme picker ---
require("statusline").setup()

-- obsidian ---
local function setup_obsidian()
	local notes_path = vim.fn.expand("~/code-playground/obsidian/notes")

	if vim.fn.isdirectory(notes_path) == 0 then
		vim.notify(
			"obsidian.nvim disabled: " .. notes_path,
			vim.log.levels.WARN
		)
		return
	end

	require("obsidian").setup({
		legacy_commands = false,

		workspaces = {
			{
				name = "Notes",
				path = notes_path,
			},
		},

		note_id_func = function(title)
			if title ~= nil and title ~= "" then
				return title
			end

			-- fallback if no title given
			return tostring(os.time())
		end,

		-- You are using mini.pick, not fzf-lua
		picker = {
			name = "mini.pick",
		},

		completion = {
			nvim_cmp = false,
			blink = false,
			min_chars = 2,
		},

		notes_subdir = "notes",

		preferred_link_style = "wiki",

		ui = {
			enable = true,
		},
	})

	----------------------------------------------------------------
	-- KEYMAPS
	----------------------------------------------------------------

	vim.keymap.set("n", "<leader>nn", function()
		vim.ui.input({ prompt = "Note name: " }, function(input)
			if not input then return end

			input = vim.trim(input)

			if input == "" then
				return
			end

			vim.cmd("Obsidian new " .. vim.fn.fnameescape(input))
		end)
	end, { desc = "New note" })

	vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<CR>", {
		desc = "Find note",
	})

	vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<CR>", {
		desc = "Search notes",
	})

	vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<CR>", {
		desc = "Today's note",
	})

	vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<CR>", {
		desc = "Switch workspace",
	})
end

setup_obsidian()

--- preview markdown ---
require('render-markdown').setup({
	completions = { lsp = { enabled = false } },
	paragraph = { render_modes = true }
})
